do ->
  app = angular.module('app', ['angular-select-text'])

  app.controller 'RutController', ->
    this.ruts = []

    this.rutOpts =
      quantity: 12
      minValue: 1000000
      maxValue: 30000000

    this.generateRut = ->
      genRuts = []
      count = 0
      while count < this.rutOpts.quantity
        number = this.getRandomArbitrary(
                  this.rutOpts.minValue
                  this.rutOpts.maxValue)
        mod = this.getMod(number)
        genRuts.push
          number: number
          mod: mod
        count++
      this.ruts = genRuts

    this.getRandomArbitrary = (min, max) ->
      Math.floor(Math.random() * (max - min + 1)) + min

    this.getMod = (number) ->
      M = 0
      S = 1
      while number
        S = (S + number % 10 * (9 - (M++ % 6))) % 11
        number = Math.floor(number / 10)
      if S then S - 1 else 'K'

    this.generateRut()

  app.filter 'rutFormat', ->
    (input) ->
      input.number.toLocaleString('cl-ES') + '-' + input.mod;
