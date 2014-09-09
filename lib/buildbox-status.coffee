fs = require 'fs'
path = require 'path'
shell = require 'shell'

Q = require 'q'

BuildBox = require './buildbox'

BuildMatrixView = require './build-matrix-view'
BuildStatusView = require './build-status-view'

module.exports =
  # Internal: The default configuration properties for the package.
  configDefaults:
    apiKey: '<Your buildbox api key>'
    account: '<Default buildbox account>'
    project: '<Default buildbox project>'

  # Internal: The build matrix bottom panel view.
  buildMatrixView: null

  # Internal: The build status status bar entry view.
  buildStatusView: null

  # Internal: Active the package.
  #
  # Returns nothing.
  activate: ->
    atom.buildboxStatus = @
    @isGitHubRepo() and @init()

  # Internal: Deactive the package and destroys any views.
  #
  # Returns nothing.
  deactivate: ->
    atom.buildbox = null
    @buildStatusView?.destroy()
    @buildMatrixView?.destroy()

  # Internal: Serialize each view state so it can be restored when activated.
  #
  # Returns an object containing key/value pairs of view state data.
  serialize: ->

  # Internal: Get whether the project repository exists and is hosted on GitHub.
  #
  # Returns true if the repository exists and is hosted on GitHub, else false.
  isGitHubRepo: ->
    return true

    repo = atom.project.getRepo()
    return false unless repo?
    /(.)*github\.com/i.test(repo.getOriginUrl())


  # Internal: Check there is a .buildbox.yml configuration file.
  # Bool result is passed in callback.
  #
  # Returns nothing.
  loadLocalConfig: =>
    deferred = Q.defer()

    deferred.reject() unless atom.project.path?

    conf = path.join(atom.project.path, '.buildbox.json')
    fs.readFile conf, 'utf8', (err,data) =>
      if err
        deferred.resolve({})
      else
        localConfig = JSON.parse(data)
        deferred.resolve(localConfig)

    deferred.promise

  # Internal: initializes any views.
  #
  # Returns nothing
  init: ->
    @loadLocalConfig().then (config) =>
      apiKey = config['apiKey'] ? atom.config.get('buildbox-status.apiKey')
      account = config['account'] ? atom.config.get('buildbox-status.account')
      project = config['project'] ? atom.config.get('buildbox-status.project')

      atom.buildbox = new BuildBox(apiKey: apiKey, account: account, project: project)

      atom.workspaceView.command 'buildbox-status:open-on-buildbox', =>
        @openOnBuildbox()

      atom.workspaceView.command 'buildbox-status:refresh', =>
        @update()

      createStatusEntry = =>
        @buildMatrixView = new BuildMatrixView()
        @buildStatusView = new BuildStatusView(@buildMatrixView)

        @update()

      if atom.workspaceView.statusBar
        createStatusEntry()
      else
        atom.packages.once 'activated', ->
          createStatusEntry()
    null

  update: ->
    @buildStatusView.update()

  # Internal: Open the project on Travis CI in the default browser.
  #
  # Returns nothing.
  openOnBuildbox: ->
    nwo = @getNameWithOwner()
    domain = 'buildbox.io'

    shell.openExternal("https://api.#{domain}/")
