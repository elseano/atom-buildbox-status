{View} = require 'atom'

require './extensions'

module.exports =
# Internal: The main view for displaying the build matrix from Travis-CI.
class BuildMatrixView extends View
  # Internal: Build up the HTML contents for the fragment.
  @content: ->
    @div class: 'buildbox-status tool-panel panel-bottom padded native-key-bindings', tabIndex: -1, =>
      @div class: 'build-matrix block', =>
        @div class: 'message', outlet: 'matrix', =>
          @p class: 'matrix-title', outlet: 'title', 'No build matrix fetched'
          @ul class: 'builds', outlet: 'builds'
          @a class: 'refresh-link', outlet: 'refreshLink', 'Refresh'

  # Internal: Initialize the view.
  initialize: () ->
    @matrix.css('font-size', "#{atom.config.get('editor.fontSize')}px")
    @refreshLink.click(=> atom.buildboxStatus.update())

    atom.workspaceView.command 'buildbox-status:toggle-build-matrix', =>
      @toggle()

  # Internal: Serialize the state of this view.
  #
  # Returns an object containing key/value pairs of state data.
  serialize: ->

  # Internal: Attach the build matrix segment to the workspace.
  #
  # Returns nothing.
  attach: ->
    atom.workspaceView.prependToBottom(this)

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

  # Internal: Update the repository build matrix from Travis CI.
  #
  # buildId - The string or number of the build ID.
  #
  # Returns nothing.
  update: (buildId) =>
    atom.buildbox.build(buildId, @buildMatrix)

  updateFromJson: (buildData) =>
    @buildMatrix(null, buildData)

  noBuild: =>
    @matrix.removeClass('pending success fail')
    @builds.empty()
    @title.html("No build found")

  # Internal: Callback for the Travis CI build status, updates the build matrix.
  #
  # err  - The error object if there was an error, else null.
  # data - The object of parsed JSON returned from the API.
  #
  # Returns nothing.
  buildMatrix: (err, data) =>
    @matrix.removeClass('pending success fail')
    return console.log "Error:", err if err?

    number = data['number']

    progressString = if data['state'] is 'running'
      started = new Date(data['started_at'])
      now = new Date()

      duration = ((now - started) / 1000).toString()

      "in progress for #{duration.formattedDuration()}"
    else if data['state'] in ['passed', 'failed']
      started = new Date(data['started_at'])
      finished = new Date(data['finished_at'])

      duration = ((finished - started) / 1000).toString()

      "took #{duration.formattedDuration()}"


    buildboxUrl = atom.buildbox.urlForBuild(number)
    @title.html("Build <a href='#{buildboxUrl}'>#{number}</a> #{progressString}")
    @builds.empty()

    buildComplete = data['state'] in ['passed', 'failed']

    for buildSet in data['jobs']
      @addBuild(build, buildComplete) for build in buildSet

  # Internal: Add the build details to the builds list.
  #
  # build - The object of build details from the matrix array.
  #
  # Returns nothing.
  addBuild: (build, buildComplete) =>
    status = if build['exit_status'] is 0
      'success'
    else if build['exit_status'] is null
      'pending'
    else
      'fail'

    duration = if build['finished_at']
      started = new Date(build['started_at'])
      finished = new Date(build['finished_at'])
      ((finished - started) / 1000).toString().formattedDuration()
    else if buildComplete
      "Did not run"
      status = "ignored"
    else
      "Incomplete"


    @builds.append("""
      <li class='#{status}'>
        #{build['name']} - #{duration}
      </li>
    """)
