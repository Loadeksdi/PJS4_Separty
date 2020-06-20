const app = require('express')()
const http = require('http').createServer(app)
const io = require('socket.io')(http)

/** @type {Object.<String, Game>} */
let games = {}

class Game {
  /**
   * 
   * @param {String[]} questions 
   */
  constructor(questions) {
    this.questions = [...questions]
    this.users = []
  }
}

const getRandomIntInclusive = (min, max) => {
  min = Math.ceil(min)
  max = Math.floor(max)
  return Math.floor(Math.random() * (max - min + 1)) + min
}

app.get('/', (req, res) => {
  res.sendFile(__dirname + '/index.html')
})

io.on('connection', (socket) => {
  console.log(games)
  socket.on('create', ({ userId, questions }) => {
    let gamePin = getRandomIntInclusive(1000, 9999)
    while (gamePin in games) {
      if (Object.keys(games).length === 1000) {
        socket.emit('_error', { code: 'NO_MORE_ROOMS', error: 'Please wait a moment, there are no rooms available.' })
        return
      }
      gamePin = getRandomIntInclusive(1000, 9999)
    }
    games[gamePin] = new Game(questions)
    games[gamePin].users.push({ [socket.id]: userId })
    socket.emit('create', gamePin)
    socket.join(gamePin)
  })

  socket.on('join', ({ userId, gamePin }) => {
    if (!(gamePin in games)) {
      socket.emit('_error', { code: 'NO_GAME_WITH_PIN', error: `The game with pin '${gamePin}' does not exist.` })
      return
    }

    if (games[gamePin].users.length === 4) {
      socket.emit('_error', { code: 'NO_MORE_PLACES', error: `The game with pin '${gamePin}' is full.` })
      return
    }
    console.log('join')
    games[gamePin].users.push({ [socket.id]: userId })
    socket.emit('join', {gamePin, users: games[gamePin].users, questions: games[gamePin].questions })
    io.to(gamePin).emit('new-join', {  })
    socket.join(gamePin)
  })

  socket.on('leave', ({userId, gamePin}) => {
    console.log('leave')
    console.log(games)
    games[gamePin].users = games[gamePin].users.filter((user) => Object.keys(user)[0] !== socket.id)
    socket.emit('leave', {gamePin, users: games[gamePin].users})
    io.to(gamePin).emit('new-leave', {  })
    socket.leave(gamePin)
    console.log(games)
  })
})

http.listen(3000, () => {
  console.log('listening on *:3000')
})