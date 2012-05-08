# A way to add tasks to Asana
#
# todo: @name? <task directive>

url  = 'https://app.asana.com/api/1.0'

workspace = "WORKSPACE_ID"
project = "PROJECT_ID"
user = "xxxxx.xxxxxxxxxxxxxxx"
pass = ""

getRequest = (msg, path, callback) ->
  auth = 'Basic ' + new Buffer("#{user}:#{pass}").toString('base64')
  msg.http("#{url}#{path}")
    .headers("Authorization": auth, "Accept": "application/json")
    .get() (err, res, body) ->
      callback(err, res, body)

postRequest = (msg, path, params, callback) ->
  stringParams = JSON.stringify params
  auth = 'Basic ' + new Buffer("#{user}:#{pass}").toString('base64')
  msg.http("#{url}#{path}")
    .headers("Authorization": auth, "Content-Length": stringParams.length, "Accept": "application/json")
    .post(stringParams) (err, res, body) ->
      callback(err, res, body)

module.exports = (robot) ->
# Add a task
  robot.hear /^(todo|task):\s?(@\w+)?(.*)/i, (msg) ->
    taskName = msg.match[3]
    userAcct = msg.match[2] if msg.match[2] != undefined
    params = {data:{name: "#{taskName}", workspace: "#{workspace}"}}
    if userAcct
      userAcct = userAcct.replace /^\s+|\s+$/g, ""
      userAcct = userAcct.replace "@", ""
      getRequest msg, "/workspaces/#{workspace}/users", (err, res, body) ->
        response = JSON.parse body
        assignedUser = ""
        for user in response.data
          name = user.name.toLowerCase().split " "
          if userAcct == name[0] || userAcct == name[1]
            assignedUser = user.id
        if assignedUser != ""
          params = {data:{name: "#{taskName}", workspace: "#{workspace}", assignee: "#{assignedUser}"}}
        else
          msg.send "Unable to Assign User"
        postRequest msg, '/tasks', params, (err, res, body) ->
          response = JSON.parse body
          if response.data.errors
            msg.send response.data.errors
          else
            projectId = response.data.id
            params = {data:{project: "#{project}"}}
            postRequest msg, "/tasks/#{projectId}/addProject", params, (err, res, body) ->
              response = JSON.parse body
              if response.data
                msg.send "Task Created : #{taskName}"
              else
                msg.send "Error creating task."
    else
      postRequest msg, '/tasks', params, (err, res, body) ->
        response = JSON.parse body
        if response.data.errors
          msg.send response.data.errors
        else
          projectId = response.data.id
          params = {data:{project: "#{project}"}}
          postRequest msg, "/tasks/#{projectId}/addProject", params, (err, res, body) ->
            response = JSON.parse body
            if response.data
              msg.send "Task Created : #{taskName}"
            else
              msg.send "Error creating task."