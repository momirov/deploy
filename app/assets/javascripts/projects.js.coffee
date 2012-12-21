# Place all the behaviors and hooks related to the matching controller here.
# All this logic will automatically be available in application.js.
# You can use CoffeeScript in this file: http://jashkenas.github.com/coffee-script/

colorTheLog = (data) ->
  parser = new ansi();
  $('#deployment-log').html(parser.toHtml(data.split("\n").reverse().join("\n")));

$ ->
  if $('#deployment-log').length > 0
    colorTheLog($('#deployment-log').html())

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

PrivatePub.subscribe "/deployments/new", (data, channel) ->
  if data.deployment.status == 'completed'
    $("#deployment_#{data.deployment.id} .spinner").remove()
    $("#deployment_#{data.deployment.id} td span").removeClass('label-inverse').addClass('label-success').html('completed')
    $("#deployment_#{data.deployment.id} td a.btn-danger").remove()

  if data.deployment.status == 'error'
    $("#deployment_#{data.deployment.id} .spinner").remove()
    $("#deployment_#{data.deployment.id} td span").removeClass('label-inverse').addClass('label-important').html('error')
    $("#deployment_#{data.deployment.id} td a.btn-danger").remove()
  
PrivatePub.subscribe "/deployments/#{gon.deployment.id}", (data, channel) ->
  colorTheLog(data.deployment.log)
  $('.status').html(data.deployment.status)
