const app = require('express')()
const http = require('http').createServer(app)
const io = require('socket.io')(http)
const firebase = require('firebase-admin')

const serviceAccount = require('./serviceAccountKey.json')

firebase.initializeApp({
  credential: firebase.credential.cert(serviceAccount),
  databaseURL: 'https://separty-7a072.firebaseio.com/'
})

const db = firebase.database()

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

const SENTENCES = {
  quiz: [],
  questions: [],
  challenge: [],
  versus: []
}

const userIdToUsername = async (userId) => {
  const ref = db.ref('Users').child(userId).child('username')
  try {
    const usernameAsSnapshot = await ref.once('value')
    return usernameAsSnapshot.val()
  } catch (e) {
    return userId
  }
}

const loadSentences = (lang = 'English') => {
  db.ref(lang).once('value', (snap) => {
    Object.entries(snap.val()).forEach(([key, value]) => {
      SENTENCES[key.toLowerCase()] = Object.values(value)
      SENTENCES[key.toLowerCase()].sort(() => Math.random() - 0.5)
    })
  })
}

const getSentences = (array, limit) => {
  const sentences = []
  let usedIndex = []
  let index = -1;
  for (let i = 0; i < limit; i++) {
    do {
      index = getRandomIntInclusive(0, SENTENCES.questions.length - 1)
    }
    while (usedIndex.includes(index))
    sentences.push(SENTENCES.questions[index])
  }
  return sentences
}

const getRandomIntInclusive = (min, max) => {
  min = Math.ceil(min)
  max = Math.floor(max)
  return Math.floor(Math.random() * (max - min + 1)) + min
}

const sleep = m => new Promise(r => setTimeout(r, m))

app.get('/', (req, res) => {
  res.sendFile(__dirname + '/index.html')
})

io.on('connection', (socket) => {
  socket.on('create', async ({ userId, questions }) => {
    let gamePin = getRandomIntInclusive(1000, 9999)
    while (gamePin in games) {
      if (Object.keys(games).length === 1000) {
        socket.emit('_error', { code: 'NO_MORE_ROOMS', error: 'Please wait a moment, there are no rooms available.' })
        return
      }
      gamePin = getRandomIntInclusive(1000, 9999)
    }
    games[gamePin] = new Game(questions)

    const username = await userIdToUsername(userId)
    games[gamePin].users.push({ username, userId, socket })
    socket.emit('create', { gamePin, question: getSentences(SENTENCES.questions, 1) })
    socket.join(gamePin)
    io.to(gamePin).emit('update-game', { gamePin, users: [...games[gamePin].users.map(u => u.username)] })

    console.log(`+ ${gamePin}`)
  })

  socket.on('join', async ({ userId, gamePin }) => {
    if (!(gamePin in games)) {
      socket.emit('_error', { code: 'NO_GAME_WITH_PIN', error: `The game with pin '${gamePin}' does not exist.` })
      return
    }

    if (games[gamePin].users.length === 4) {
      socket.emit('_error', { code: 'NO_MORE_PLACES', error: `The game with pin '${gamePin}' is full.` })
      return
    }

    const username = await userIdToUsername(userId)
    games[gamePin].users.push({ username, userId, socket })
    socket.emit('join', { gamePin, question: getSentences(SENTENCES.questions, 1) })
    socket.join(gamePin)
    io.to(gamePin).emit('update-game', { gamePin, users: [...games[gamePin].users.map(u => u.username)] })

    console.log(`+ [${gamePin}] ${userId} (${games[gamePin].users.length} / 4)`)

    if (games[gamePin].users.length === 4) {
      console.log(`~ [${gamePin}] game will start in 5 seconds`)
      await sleep(5000)
      io.to(gamePin).emit('start-game')
    }
  })

  socket.on('leave', ({ userId, gamePin }) => {
    if (!(gamePin in games)) {
      return
    }

    games[gamePin].users = games[gamePin].users.filter(u => u.socket.id !== socket.id)
    socket.emit('leave', { gamePin, users: games[gamePin].users.map(u => u.userId) })
    socket.leave(gamePin)
    io.to(gamePin).emit('update-game', { gamePin, users: [...games[gamePin].users.map(u => u.username)] })
    console.log(`- [${gamePin}] ${userId} (${games[gamePin].users.length} / 4)`)

    if (games[gamePin].users.length === 0) {
      delete games[gamePin]
      console.log(`- ${gamePin}`)
    }
  })
})

http.listen(3000, () => {
  console.log('listening on *:3000')
  loadSentences()
})
