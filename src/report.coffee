###############################################################################
#
#  palava report - Statistics monitor for palava
#  Copyright (C) 2013  Stephan Thamm
#
#  This program is free software: you can redistribute it and/or modify
#  it under the terms of the GNU Affero General Public License as
#  published by the Free Software Foundation, either version 3 of the
#  License, or (at your option) any later version.
#
#  This program is distributed in the hope that it will be useful,
#  but WITHOUT ANY WARRANTY; without even the implied warranty of
#  MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
#  GNU Affero General Public License for more details.
#
#  You should have received a copy of the GNU Affero General Public License
#  along with this program.  If not, see <http://www.gnu.org/licenses/>.
#
###############################################################################

mongodb = require('mongodb')
ua_parser = require 'ua-parser'

exports.init = (app, db) =>
  collection = db.collection 'reports'

  # helper

  parse_client_data = (body) =>
    data = {}

    if body.user_agent != undefined
      agent = ua_parser.parse(body.user_agent)

      data.browser = 
        name: agent.ua.family
        major: agent.ua.major
        version: agent.ua.toVersionString()

      data.os = 
        name: agent.os.family
        major: agent.os.major
        version: agent.os.toVersionString()

      data.device = agent.device.family

    if body.quality != undefined
      data.quality = parseInt(body.quality)

    if typeof body.errors == 'string'
      data.errors = [body.errors]
    else
      data.errors = body.errors

    data.comment = body.comment

    return data

  # create a new report

  app.post '/create_report.json', (req, res) =>
    data = {}

    body = req.body

    # TODO: check for neccessary elements

    report =
      time: Date.now()
      version:
        portal: body.portal_revision
        client: body.client_revision
      connection:
        type: if body.network_type then body.network_type else "unknown"
        known_to_work: !!body.known_to_work
      clients: [parse_client_data(body)]

    collection.insert report, {safe: true}, (err, objects) =>
      if err
        res.send {error: err}
        return

      res.send { success: true, id: objects[0]._id }

  # add client data to existing report

  app.post '/extend_report.json', (req, res) =>
    body = req.body

    # TODO: check if id present

    query = { _id: new mongodb.ObjectID(body.id) }

    # find existing report

    collection.find query, (err, objects) ->
      if err
        res.send { error: err }
        return

      # actually get object

      objects.nextObject (err, obj) ->
        if err
          res.send { error: err }
          return

        if obj == null
          res.send { error: "report not found" }
          return

        if obj.clients.length > 1
          res.send { error: "report already got a response" }
          return

        # insert new client data

        cmd = { $push: { "clients": parse_client_data(body) } }
        opts = { safe: true }

        collection.update query, cmd, opts, (err) ->
          if err
            res.send { error: err }
          else
            res.send { success: true }

