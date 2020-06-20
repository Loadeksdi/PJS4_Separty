const app = require('express')()
const http = require('http').createServer(app)
const io = require('socket.io')(http)
/** @type {Object.<String, Game>} */
let games = {}

//const admin = admin.database();


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
    games[gamePin].users.push({ userId, socket })
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
    games[gamePin].users.push({ userId, socket })
    socket.emit('join', { gamePin, questions: games[gamePin].questions })
    socket.join(gamePin)
    // socket.to(gamePin).emit('newjoin', { gamePin, users: [] })
    // Object.values(games[gamePin].users).forEach(
    //   user => {
    //     const socketId = user.socket.id
    //     socket.in(socket.id).emit('newjoin', { gamePin, users: [...games[gamePin].users.map(u => u.userId)]})
    //   }
    // )
    io.to(gamePin).emit('newjoin', { gamePin, users: [...games[gamePin].users.map(u => u.userId)] })
  })

  socket.on('leave', ({ userId, gamePin }) => {
    console.log(games)
    games[gamePin].users = games[gamePin].users.filter(u => u.socket.id !== socket.id)
    socket.emit('leave', { gamePin, users: games[gamePin].users.map(u => u.userId) })
    socket.leave(gamePin)
    io.to(gamePin).emit('new-leave', {})
    console.log(games)

    //if (games[gamePin].users.length === 0) {
      //let ref = admin.ref('Games');
      //ref.child(gamePin).remove();

    //}
  }) 
})

http.listen(3000, () => {
  console.log('listening on *:3000')
})