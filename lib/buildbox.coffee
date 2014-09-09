http = require 'http'
https = require 'https'

module.exports =
class BuildBox
  constructor: (options) ->
    @apiKey = options['apiKey']
    @account = options['account']
    @project = options['project']

  urlForBuild: (buildNumber) =>
    "https://buildbox.io/#{@account}/#{@project}/builds/#{buildNumber}"

  userEmail: (callback) =>
    https.get("https://api.buildbox.io/v1/user?api_key=#{@apiKey}", (res) ->
      data = '';

      res.on 'data', (chunk) ->
        data += chunk;

      res.on 'end', ->
        obj = JSON.parse(data);
        callback(null, obj["email"])

      res.on "error", (err) ->
        callback(err, null)
    )


  builds: (options, callback) =>
    project = options['project'] ? @project
    account = options['account'] ? @account
    apiKey = options['apiKey'] ? @apiKey
    branch = options['branch']

    url = "https://api.buildbox.io/v1/accounts/#{account}/projects/#{project}/builds?api_key=#{apiKey}"

    if branch
      url += "&branch=#{branch}"

    console.log(url)

    https.get(url, (res) ->
      data = '';

      res.on 'data', (chunk) ->
        data += chunk;

      res.on 'end', ->
        obj = JSON.parse(data);
        callback(null, obj)

      res.on "error", (err) ->
        callback(err, null)
    )
