# Place all the behaviors and hooks related to the matching controller here.
# All this logic will automatically be available in application.js.
# You can use CoffeeScript in this file: http://jashkenas.github.com/coffee-script/
class Youtube
  perPage: 10
  videos: null
  watched_videos: Array()
  nextPageToken: null

  embed: (element) ->
    $(element).html "<iframe width='640' height='390' src='http://www.youtube.com/embed/#{@videos[0].id.videoId}?autoplay=1' frameborder='0' />"
    @add_watched_video(@videos[0].id.videoId)

  constructor: ->
    # load watched videos from local storage
    @watched_videos = JSON.parse localStorage['watched_videos'] if localStorage['watched_videos']

  add_watched_video: (video_id) ->
    @watched_videos.push video_id
    localStorage['watched_videos'] = JSON.stringify @watched_videos

  filter_watched_videos: ->
    @videos = @videos.filter (video) =>
      @watched_videos.lastIndexOf(video.id.videoId) == -1

    if @videos.length == 0
      @get_videos()
    else
      @embed('.youtube')

  handleData: (data) ->
    console.log data
    @videos = data.items
    @nextPageToken = data.nextPageToken
    @filter_watched_videos()

  get_videos: ->
    url = "https://www.googleapis.com/youtube/v3/search?q=fails&part=id&type=video&key=AIzaSyCH2Z8DZ4MqVIoQPO38LknGinhiRqLKLFY&maxResults=#{@perPage}"
    if @nextPageToken
      url += "&pageToken=#{@nextPageToken}"
    $.ajax url,
      dataType: 'jsonp'
    .done (data) => @handleData(data)
    @

$ ->
  if $('.youtube').length > 0
    youtube = new Youtube
    youtube.get_videos()
