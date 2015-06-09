do ->
  app = angular.module('app', ['angular-select-text'])

  app.controller 'RutController', ['$filter', ($filter)->
    this.ruts = []
    this.input = ''
    this.lastInput = ''

    this.rutOpts =
      quantity: 12
      minValue: 1000000
      maxValue: 40000000

    # Generates a rut according the given options
    this.generateRut = ->
      if this.input == '' || this.getInput() != this.lastInput
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
        this.lastInput = this.getInput()
        this.ruts = genRuts

    # Returns a random number between the max/min values
    this.getRandomNumber = ->
      min = this.rutOpts.minValue
      max = this.rutOpts.maxValue
      input = this.getInput()
      inputNumber = parseInt(input)
      if !inputNumber || input.length > 8
        Math.floor(Math.random() * (max - min + 1)) + min
      else
        inputNumber

    # Removes from input all the characters diferent than a digit
    this.getInput =  ->
      this.input.replace(/\D/g, '')

    # Returns the module for a rut number
    this.getMod = (number) ->
      M = 0
      S = 1
      while number
        S = (S + number % 10 * (9 - (M++ % 6))) % 11
        number = Math.floor(number / 10)
      if S then S - 1 else 'K'

    # Generates a txt file "on-the-fly" with the generated ruts to download
    this.download = ->
      csvString = this.ruts.map($filter('rutFormat')).join('%0A')
      a = document.createElement('a')
      a.href = 'data:attachment/txt,' + csvString
      a.target = '_blank'
      a.download = 'gen-ruts-' + Date.now() + '.txt'
      document.body.appendChild a
      a.click()
      return

    this.generateRut()

  ]

  # Returns a rut object in the classic format with dots and hyphen
  app.filter 'rutFormat', ->
    (input) ->
      input.number.toLocaleString('cl-ES') + '-' + input.mod;
