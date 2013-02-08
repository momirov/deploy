# Place all the behaviors and hooks related to the matching controller here.
# All this logic will automatically be available in application.js.
# You can use CoffeeScript in this file: http://jashkenas.github.com/coffee-script/
class Youtube
  perPage: 50
  page: 1
  videos: null
  watched_videos: Array()

  embed: (element) ->
    $(element).html "<iframe width='640' height='390' src='http://www.youtube.com/embed/#{@videos[0].id}?autoplay=1' frameborder='0' />"
    @add_watched_video(@videos[0].id)

  constructor: ->
    # load watched videos from local storage
    @watched_videos = JSON.parse localStorage['watched_videos'] if localStorage['watched_videos']

  add_watched_video: (video_id) ->
    @watched_videos.push video_id
    localStorage['watched_videos'] = JSON.stringify @watched_videos

  filter_watched_videos: ->
    @videos = @videos.filter (video) =>
      @watched_videos.lastIndexOf(video.id) == -1

    if @videos.length == 0
      @page++
      @get_videos()
    else
      @embed('.youtube')


  handleData: (data) ->
    @videos = data.data.items
    @filter_watched_videos()

  get_offset: ->
    (@page - 1) * @perPage + 1

  get_videos: ->
    $.ajax "http://gdata.youtube.com/feeds/api/videos?alt=jsonc&q=fail&start-index=#{@get_offset()}&max-results=#{@perPage}&v=2",
      dataType: 'jsonp'
    .done (data) => @handleData(data)
    @

$ ->
  if $('.youtube').length > 0
    youtube = new Youtube
    youtube.get_videos()