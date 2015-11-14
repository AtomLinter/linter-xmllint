{CompositeDisposable} = require 'atom'
fs = require('fs')
helpers = require 'atom-linter'
path = require('path')
sax = require('sax')
XRegExp = require('xregexp').XRegExp

module.exports =

  config:
    executablePath:
      type: 'string'
      title: 'xmllint Executable Path'
      default: 'xmllint'

  activate: ->
    require('atom-package-deps').install()

    @subscriptions = new CompositeDisposable
    @subscriptions.add atom.config.observe 'linter-xmllint.executablePath',
      (executablePath) =>
        @executablePath = executablePath

  deactivate: ->
    @subscriptions.dispose()

  provideLinter: ->
    provider =
      name: 'xmllint'
      grammarScopes: ['text.xml']
      scope: 'file'
      lintOnFly: false
      lint: (textEditor) =>
        return @lintOpenFile textEditor

  lintOpenFile: (textEditor) ->
    promise_well_formed = @checkWellFormed textEditor.getPath()
    # if the file is well formed try to validate it
    linter = this
    validateIfWellFormed = (messages) ->
      if messages.length
        return messages
      return linter.checkValid textEditor
    return promise_well_formed.then validateIfWellFormed

  checkWellFormed: (filePath) ->
    params = ['--noout', filePath]
    return helpers.exec(@executablePath, params, {stream: 'stderr'})
      .then @parseMessages

  checkValid: (textEditor) ->
    # if the document is well formed it must have a root node
    linter = this
    hasDtd = false
    schemaUrl = undefined

    promiseValidation = new Promise (resolve, reject) ->
      strict = true
      parser = sax.createStream(strict)
      # use a low value for the highWaterMark
      # since we can't abort parsing what has already been read
      stream = fs.createReadStream(textEditor.getPath(), {highWaterMark: 128})

      parser.ondoctype = (doctype) ->
        hasDtd = true

      parser.onopentag = (node) ->
        # only consider the first tag
        if schemaUrl?
          return

        # try to extract schema url
        schemaUrl = false
        if 'xsi:noNamespaceSchemaLocation' of node.attributes
          schemaUrl= node.attributes['xsi:noNamespaceSchemaLocation']
        else if 'xsi:schemaLocation' of node.attributes
          schemaLocation = node.attributes['xsi:schemaLocation']
          parts = schemaLocation.split /\s+/
          if parts.length is 2
            schemaUrl = parts[1]

        # stop reading more data from the file
        stream.unpipe()
        stream.close()

        if not hasDtd and not schemaUrl
          resolve([])
        if hasDtd and not schemaUrl
          resolve(linter.validateDtd(textEditor.getPath()))
        if not hasDtd and schemaUrl
          resolve(linter.validateSchema(textEditor, schemaUrl))
        if hasDtd and schemaUrl
          promise = new Promise (resolve2, reject2) ->
            linter.validateSchema(textEditor, schemaUrl).then (result) ->
              if result.length > 0
                resolve2(result)
              else
                resolve2(linter.validateDtd(textEditor.getPath()))
          promise.then (result) ->
            resolve(result)

      stream.pipe(parser)

    return promiseValidation

  validateDtd: (filePath) ->
    params = ['--noout', '--valid', filePath]
    return helpers.exec(@executablePath, params, {stream: 'stderr'})
      .then @parseMessages

  validateSchema: (textEditor, schemaUrl) ->
    filePath = textEditor.getPath()
    params = ['--noout', '--schema', schemaUrl, filePath]
    # since the schema might be relative exec in the directory of the xml file
    cwd = path.dirname(filePath)
    return helpers.exec(@executablePath, params, {cwd: cwd, stream: 'stderr'})
      .then (output) ->
        regex = '(?<file>.+):(?<line>\\d+): .*: .* : (?<message>.+)'
        helpers.parse(output, regex).map (error) ->
          error.type = 'Error'
          # make range the full line
          error.range = helpers.rangeFromLineNumber(
            textEditor, error.range[0][0], error.range[0][1])
          return error

  parseMessages: (output) ->
    messages = []
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
      messages.push({
        type: 'Error'
        text: match.message
        filePath: match.file
        range: [[line, column], [line, column]]
      })
    return messages
