# Place all the behaviors and hooks related to the matching controller here.
# All this logic will automatically be available in application.js.
# You can use CoffeeScript in this file: http://jashkenas.github.com/coffee-script/

parser = new ansi()
colorTheLog = (data) ->
  $('#deployment-log').prepend(parser.toHtml(data.split("\n").reverse().join("\n")));

$ ->
  # color the log on deployment show
  if $('#deployment-log').length > 0
    colorTheLog($('#deployment-log').html())

  # spinner for labels
  $(".label-inverse").parent().spin
    lines: 9 # The number of lines to draw
    length: 1 # The length of each line
    width: 3 # The line thickness
    radius: 6 # The radius of the inner circle
    corners: 1 # Corner roundness (0..1)
    rotate: 0 # The rotation offset
    color: '#000' # #rgb or #rrggbb
    speed: 1 # Rounds per second
    trail: 60 # Afterglow percentage
    shadow: false # Whether to render a shadow
    hwaccel: true # Whether to use hardware acceleration
    className: 'spinner' # The CSS class to assign to the spinner
    zIndex: 2e9 # The z-index (defaults to 2000000000)
    top: '0' # Top position relative to parent in px
    left: '-30' # Left position relative to parent in px

  # lazy load current versions so original page load is faster
  $('.revisions span').each (index) ->
    $.getScript($(this).data('url'))

  # lazy load diff links in left sidebar for speed
  $('.environments span').each (index) ->
    $.getScript($(this).data('url'))

  pusher = new Pusher('ad3b3ac62e18e65df34b')
  statusChannel = pusher.subscribe('deployment')
  if $("#deployment").data('id')
    deploymentChannel = pusher.subscribe('deployment_' + $("#deployment").data('id'));
    deploymentChannel.bind 'update_log', (data) ->
      colorTheLog(data.new_line)
      $('.status').html(data.status)

  statusChannel.bind 'finished', (data) ->
    if data.status == 'completed'
      $("#deployment_#{data.id} .spinner").remove()
      $("#deployment_#{data.id} td span").removeClass('label-inverse').addClass('label-success').html('completed')
      $("#deployment_#{data.id} td a.btn-danger").remove()

    if data.status == 'error'
      $("#deployment_#{data.id} .spinner").remove()
      $("#deployment_#{data.id} td span").removeClass('label-inverse').addClass('label-important').html('error')
      $("#deployment_#{data.id} td a.btn-danger").remove()







