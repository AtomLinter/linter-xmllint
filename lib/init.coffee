{CompositeDisposable} = require 'atom'
helpers = require 'atom-linter'
XRegExp = require('xregexp').XRegExp

module.exports =
  config:
    executablePath:
      type: 'string'
      title: 'xmllint Executable Path'
      default: 'xmllint'
  activate: ->
    @subscriptions = new CompositeDisposable
    @subscriptions.add atom.config.observe 'linter-xmllint.executablePath',
      (executablePath) =>
        @executablePath = executablePath
  deactivate: ->
    @subscriptions.dispose()

  lintFile: (filePath) ->
    params = ['--noout', filePath]
    return helpers.exec(@executablePath, params, {stream: 'stderr'})

  parseMessages: (output) ->

    toReturn = []
    regex = XRegExp(
      '^(?<file>.+):' +
      '(?<line>\\d+): ' +
      '(?<type>.+) : ' +
      '(?<message>.+)[\\r?\\n]' +
      '(?<source_line>.*)[\\r?\\n]' +
      '(?<marker>.*)\\^$', 'm')

    XRegExp.forEach output, regex, (match, i) ->
      line = parseInt(match.line) - 1
      column = match.marker.length
      toReturn.push({
        type: 'Error'
        text: match.message
        filePath: match.file
        range: [[line, column], [line, column]]
      })

    return toReturn

  provideLinter: ->
    provider =
      name: 'xmllint'
      grammarScopes: ['text.xml']
      scope: 'file'
      lintOnFly: false
      lint: (textEditor) =>
        return @lintFile textEditor.getPath()
          .then @parseMessages
