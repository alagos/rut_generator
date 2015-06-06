do ->
  app = angular.module('app', ['angular-select-text'])

  app.controller 'RutController', ->
    this.ruts = []
    this.input = ''

    this.rutOpts =
      quantity: 12
      minValue: 1000000
      maxValue: 30000000

    this.generateRut = ->
      genRuts = []
      count = 0
      while count < this.rutOpts.quantity
        number = this.getRandomNumber()
        i = 0
        exists = false
        while i < genRuts.length
          if genRuts[i].number == number
            exists = true
            break
          i++
        if !exists
          mod = this.getMod(number)
          genRuts.push
            number: number
            mod: mod
        count++
      this.ruts = genRuts

    this.getRandomNumber = ->
      min = this.rutOpts.minValue
      max = this.rutOpts.maxValue
      input = this.input.replace(/\D/g, '')
      inputNumber = parseInt(input)
      if !inputNumber || input.length > 8
        Math.floor(Math.random() * (max - min + 1)) + min
      else
        inputNumber

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
