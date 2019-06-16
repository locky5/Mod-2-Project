App.name = App.cable.subscriptions.create "NameChannel",
  connected: ->
    # Called when the subscription is ready for use on the server

  disconnected: ->
    # Called when the subscription has been terminated by the server

  received: (data) ->
    # Called when there's incoming data on the websocket for this channel

  title: ->
    @perform 'title'

  viewer_count:integer: ->
    @perform 'viewer_count:integer'
