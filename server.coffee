http         = require 'http'
express      = require 'express'
bodyParser   = require 'body-parser'
errorHandler = require 'errorhandler'
logger       = require 'morgan'
mongojs      = require 'mongojs'

mongo_port = MONGO_PORT_27018_TCP_PORT ? "27017"
mongo_host = MONGO_PORT_27018_TCP_ADDR ? "localhost"

db = mongojs "#{mongo_host}:#{mongo_port}/exampleDB", ['greetings']

app = express()

app.set 'port', process.env.PORT || 80
app.use logger 'dev'
app.use bodyParser.json()
app.use bodyParser.urlencoded extended: true

app.get '/', (req, res) =>
  db.greetings.find {}, (error, greetings) =>
    return res.status(500).send error.message if error?
    res.send greetings

server = http.createServer app
server.listen app.get('port'), ->
  console.log "Express server listening on port #{app.get('port')}"
