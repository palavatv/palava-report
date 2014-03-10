#!/usr/bin/env coffee
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

# configuration

BIND_PORT = process.env.BIND_PORT ? 3000
BIND_HOST = process.env.BIND_HOST ? "0.0.0.0"

MONGO_HOST = process.env.MONGO_HOST ? "localhost"
MONGO_DB = process.env.MONGO_DB ? "plv_report"

# require stuff

MongoClient = require('mongodb').MongoClient
express = require 'express'
connect = require 'connect'

# require local modules

report = require './report'

# initalize express

app = express()

app.configure () =>
  app.set 'views', __dirname + '/../views'
  app.use require('connect-assets')()
  app.use connect.static __dirname + '/../public'
  app.use connect.static __dirname + '/../support/public'
  app.use express.bodyParser()

# initialize mongo db connection

mongo_url = "mongodb://" + MONGO_HOST + "/" + MONGO_DB

MongoClient.connect mongo_url, (err, db) =>
  if err then throw err

  # initialize modules

  report.init app, db

  # test page

  app.get '/', (req, res) =>
    res.render 'index.jade'

  # actually start

  console.log "Listening on " + BIND_HOST + ":" + BIND_PORT
  app.listen BIND_PORT, BIND_HOST


