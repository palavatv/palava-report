$ () =>
  send_report = () ->
    $.ajax {
      url: "/create_report.json"
      type: 'POST'
      data: {
        user_agent: navigator.userAgent
        quality: 0
        errors: ["blub", "bla"]
        comment: "just a test"
        portal_revision: "a"
        client_revision: "b"
      }
      success: (data) ->
        console.log data
        extend_report data.id
      error: (err) ->
        console.log err
    }

  extend_report = (id) ->
    $.ajax {
      url: "/extend_report.json"
      type: 'POST'
      data: {
        id: id
        user_agent: navigator.userAgent
        quality: 10
        errors: "err"
        comment: "another test"
      }
      success: (data) ->
        console.log data
      error: (err) ->
        console.log err
    }

  $('button').click send_report

