http = require 'http'
express = require 'express'
logfmt = require 'logfmt'
WebSocketServer = require('ws').Server
socket = null

port = Number(process.env.PORT || 5000);
app = express()

app.use logfmt.requestLogger()
app.use express.static(__dirname + '/public')

app.get '/push', (req, res)->
  if socket and req.query?.data
    socket.send req.query.data
  res.send()

server = http.createServer app
server.listen port
console.log 'http server listening on %d', port

wss = new WebSocketServer
 server: server
console.log 'websocket server created'

wss.on 'connection', (ws)->
  socket = ws
  # id = setInterval ->
  #   ws.send "<b>HELLO</b>", ->
  # , 1000

  console.log 'websocket connection open'

  ws.on 'close', ->
    console.log 'websocket connection close'
    # clearInterval id
