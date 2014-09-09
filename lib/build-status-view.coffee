{View} = require 'atom'

BuildBox = require './buildbox'

module.exports =
# Internal: The main view for displaying the status from Travis CI.
class BuildStatusView extends View
  # Internal: Build up the HTML contents for the fragment.
  @content: ->
    @div class: 'buildbox-status inline-block', =>
      @span class: 'build-status icon icon-history', outlet: 'status', tabindex: -1, ''

  # Internal: Initialize the view.
  #
  # nwo    - The string of the repo owner and name.
  # matrix - The build matrix view.
  initialize: (@matrix) ->
    atom.workspaceView.command 'buildbox-status:toggle', =>
      @toggle()

    @subscribe this, 'click', =>
      @matrix.toggle()

    @attach()
    @subscribeToRepo()

  # Internal: Serialize the state of this view.
  #
  # Returns an object containing key/value pairs of state data.
  serialize: ->

  # Internal: Attach the status bar segment to the status bar.
  #
  # Returns nothing.
  attach: ->
    atom.workspaceView.statusBar.appendLeft(this)

  # Internal: Destroy the view and tear down any state.
  #
  # Returns nothing.
  destroy: ->
    @detach()

  # Internal: Toggle the visibility of the view.
  #
  # Returns nothing.
  toggle: ->
    if @hasParent()
      @detach()
    else
      @attach()

  # Internal: Get the active pane item path.
  #
  # Returns a string of the file path, else undefined.
  getActiveItemPath: ->
    @getActiveItem()?.getPath?()

  # Internal: Get the active pane item.
  #
  # Returns an object for the pane item if it exists, else undefined.
  getActiveItem: ->
    atom.workspace.getActivePaneItem()

  # Internal: Subcribe to events on the projects repository object.
  #
  # Returns nothing.
  subscribeToRepo: =>
    @unsubscribe(@repo) if @repo?

    if repo = atom.project.getRepo()
      @repo = repo
      @subscribe repo, 'status-changed', (path, status) =>
        @update() if path is @getActiveItemPath()
      @subscribe repo, 'statuses-changed', @update

  # Internal: Update the repository build status from Travis CI.
  #
  # Returns nothing.
  update: =>
    return unless @hasParent()

    @status.removeClass('success fail').addClass("pending")

    branchPath = (atom.project.getRepo()?.branch ? "").split("/")
    branch = branchPath[branchPath.length - 1]

    atom.buildbox.builds(branch: branch, @repoStatus)

  # Internal: Callback for the Buildbox repository request, updates the build
  # status.
  #
  # err  - The error object if there was an error, else null.
  # data - The object of parsed JSON returned from the API.
  #
  # Returns nothing.
  repoStatus: (err, data) =>
    return console.log "Error:", err if err?

    @status.removeClass('pending success fail')

    lastBuild = data[0]

    console.log("Last build ", lastBuild)

    if lastBuild
      @matrix.updateFromJson(lastBuild)

      if lastBuild['state'] is "passed"
        @status.addClass('success')
        @clearTimer()
      else if lastBuild['state'] is "running"
        @status.addClass('pending')
        @startTimer()
      else
        @status.addClass('fail')
        @clearTimer()
    else
      @matrix.noBuild()

  clearTimer: =>
    if @updateTimer
      window.clearInterval @updateTimer
      @updateTimer = null

  startTimer: =>
    @updateTimer ?= window.setInterval (=> @update()), 30000
