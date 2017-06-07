{CompositeDisposable} = require 'atom'
helpers = null
path = null
Readable = require('stream').Readable
sax = null
xmldoc = null
XRegExp = null

class ReadableString extends Readable

  constructor: (@content, options) ->
    super options

  _read: (size) ->
    if not @content
      @push null
    else
      @push(@content.slice(0, size))
      @content = @content.slice(size)

module.exports =

  config:
    executablePath:
      type: 'string'
      title: 'xmllint Executable Path'
      default: 'xmllint'
      order: 1
    skipDtd:
      type: 'boolean'
      title: 'Skip validation against DTDs'
      default: false
      order: 2
    skipSchema:
      type: 'boolean'
      title: 'Skip validation against W3C XML Schemas'
      default: false
      order: 3
    skipRelaxng:
      type: 'boolean'
      title: 'Skip validation against Relax NGs'
      default: false
      order: 4
    skipSchematron:
      type: 'boolean'
      title: 'Skip validation against Schematrons'
      default: false
      order: 5

  activate: ->
    require('atom-package-deps').install('linter-xmllint')

    @subscriptions = new CompositeDisposable
    @subscriptions.add atom.config.observe 'linter-xmllint.executablePath',
      (executablePath) =>
        @executablePath = executablePath
    @subscriptions.add atom.config.observe 'linter-xmllint.skipDtd',
      (skipDtd) =>
        @skipDtd = skipDtd
    @subscriptions.add atom.config.observe 'linter-xmllint.skipSchema',
      (skipSchema) =>
        @skipSchema = skipSchema
    @subscriptions.add atom.config.observe 'linter-xmllint.skipRelaxng',
      (skipRelaxng) =>
        @skipRelaxng = skipRelaxng
    @subscriptions.add atom.config.observe 'linter-xmllint.skipSchematron',
      (skipSchematron) =>
        @skipSchematron = skipSchematron

  deactivate: ->
    @subscriptions.dispose()

  provideLinter: ->
    provider =
      name: 'xmllint'
      grammarScopes: ['text.xml', 'text.xml.xsl']
      scope: 'file'
      lintsOnChange: true
      lint: (textEditor) =>
        return @lintOpenFile textEditor

  lintOpenFile: (textEditor) ->
    promise_well_formed = @checkWellFormed textEditor
    # if the file is well formed try to validate it
    linter = this
    validateIfWellFormed = (messages) ->
      if messages.length
        return messages
      return linter.checkValid textEditor
    return promise_well_formed.then validateIfWellFormed

  checkWellFormed: (textEditor) ->
    helpers ?= require 'atom-linter'
    params = ['--noout', '-']
    options = {
      stdin: textEditor.getText()
      stream: 'stderr'
      allowEmptyStderr: true
    }
    return helpers.exec(@executablePath, params, options)
      .then (output) =>
        messages = @parseMessages(output)
        for message in messages
          message.location.file = textEditor.getPath()
        return messages

  checkValid: (textEditor) ->
    # if the document is well formed it must have a root node
    linter = this
    firstOpenTag = true
    hasDtd = false
    schemas = []

    promiseValidation = new Promise (resolve, reject) ->
      sax ?= require 'sax'
      strict = true
      parser = sax.createStream(strict)
      # use a low value for the highWaterMark
      # since we can't abort parsing what has already been read
      stream = new ReadableString(textEditor.getText(), {highWaterMark: 128})

      parser.onprocessinginstruction = (procInst) ->
        if procInst.name isnt 'xml-model'
          return

        xmldoc ?= require 'xmldoc'
        # parse attributes from body
        try
          xmlDoc = new xmldoc.XmlDocument('<body ' + procInst.body + '/>')
        catch
          return
        attributes = xmlDoc.attr
        if not attributes
          return

        # ignore if group is not empty
        if 'group' of attributes and attributes['group']
          return

        if 'schematypens' of attributes and 'href' of attributes
          if attributes['schematypens'] is 'http://www.w3.org/2001/XMLSchema'
            if not linter.skipSchema
              schemas.push({
                arg: '--schema'
                url: attributes['href']
              })
          if attributes['schematypens'] is 'http://relaxng.org/ns/structure/1.0'
            if not linter.skipRelaxng
              schemas.push({
                arg: '--relaxng'
                url: attributes['href']
              })
          if attributes['schematypens'] is 'http://purl.oclc.org/dsdl/schematron'
            if not linter.skipSchematron
              schemas.push({
                arg: '--schematron'
                url: attributes['href']
              })

      parser.ondoctype = (doctype) ->
        if not linter.skipDtd
          hasDtd = true

      parser.onopentag = (node) ->
        # only handle first open tag
        if not firstOpenTag
          return
        firstOpenTag = false

        # stop reading more data after the first tag
        stream.unpipe()
        stream.content = ''

        # try to extract schema url from attributes
        if 'xsi:noNamespaceSchemaLocation' of node.attributes
          if not linter.skipSchema
            schemas.push({
              arg: '--schema'
              url: node.attributes['xsi:noNamespaceSchemaLocation']
            })
        else if 'xsi:schemaLocation' of node.attributes
          if not linter.skipSchema
            schemaLocation = node.attributes['xsi:schemaLocation']
            parts = schemaLocation.split /\s+/
            if parts.length is 2
              schemas.push({
                arg: '--schema'
                url: parts[1]
              })

        # trigger validation
        if not hasDtd and schemas.length is 0
          resolve([])
        else
          promises = []

          if hasDtd
            promises.push(linter.validateDtd(textEditor))

          for schema in schemas
            promises.push(linter.validateSchema(textEditor, schema.arg, schema.url))

          Promise.all(promises).then (results) ->
            messages = []
            for result in results
              for message in result
                messages.push(message)
            resolve(messages)

      stream.pipe(parser)

    return promiseValidation

  validateDtd: (textEditor) ->
    helpers ?= require 'atom-linter'
    path ?= require('path')
    params = ['--noout', '--valid', '-']
    options = {
      # since the schema might be relative exec in the directory of the xml file
      cwd: path.dirname(textEditor.getPath())
      stdin: textEditor.getText()
      stream: 'stderr'
      allowEmptyStderr: true
    }
    return helpers.exec(@executablePath, params, options)
      .then (output) =>
        messages = @parseMessages(output)
        for message in messages
          message.excerpt += ' (DTD)'
          message.location.file = textEditor.getPath()
        return messages

  validateSchema: (textEditor, argSchemaType, schemaUrl) ->
    helpers ?= require 'atom-linter'
    path ?= require('path')
    params = []
    # --noout results in no error messages to be printed for schematron
    if argSchemaType is not '--schematron'
      params.push('--noout')
    params = params.concat([argSchemaType, schemaUrl, '-'])
    options = {
      # since the schema might be relative exec in the directory of the xml file
      cwd: path.dirname(textEditor.getPath())
      stdin: textEditor.getText()
      stream: 'stderr'
    }
    return helpers.exec(@executablePath, params, options)
      .then (output) =>
        if argSchemaType is '--schematron'
          messages = @parseSchematronMessages(textEditor, output)
        else
          messages = @parseSchemaMessages(textEditor, output)
        if messages.length
          for message in messages
            message.severity = 'error'
            if schemaUrl.includes('://')
              message.url = schemaUrl
            else
              message.excerpt = message.excerpt + ' (' + schemaUrl + ')'
            message.location.file = textEditor.getPath()
        else if output.indexOf('- validates') is -1
          messages.push({
            severity: 'error'
            excerpt: output
            location: {
              file: textEditor.getPath()
              position: [[0, 0], [0, 0]]
            }
          })
        return messages

  parseMessages: (output) ->
    XRegExp ?= require('xregexp')
    messages = []
    regex = XRegExp(
      '^(?<file>.+):' +
      '(?<line>\\d+): ' +
      '(?<severity>.+) : ' +
      '(?<message>.+)' +
      '(' +  # some error might not contain a newline, source line and marker
      '\\r?\\n' +
      '(?<source_line>.*)\\r?\\n' +
      '(?<marker>.*)\\^' +
      ')?' +  # end optional part
      '$', 'm')
    XRegExp.forEach output, regex, (match, i) ->
      line = parseInt(match.line) - 1
      column = if match.marker then match.marker.length else 0
      messages.push({
        severity: 'error'
        excerpt: match.message
        location: {
          file: match.file
          position: [[line, column], [line, column]]
        }
      })
    return messages

  parseSchemaMessages: (textEditor, output) ->
    helpers ?= require 'atom-linter'
    regex = '(?<file>.+):(?<line>\\d+): .*: .* : (?<message>.+)'
    messages = helpers.parse(output, regex)
    for message in messages
      message.severity = message.type
      delete message.type

      message.excerpt = message.text
      delete message.text

      message.location = {
        file: message.filePath
      }
      delete message.filePath

      message.location.position = helpers.generateRange(textEditor, message.range[0][0])
      delete message.range
    return messages

  parseSchematronMessages: (textEditor, output) ->
    XRegExp ?= require('xregexp')
    messages = []
    regex = XRegExp(
      '^(?<rule>.+) ' +
      'line (?<line>\\d+): ' +
      '(?<message>.+)$', 'm')
    XRegExp.forEach output, regex, (match, i) ->
      line = parseInt(match.line) - 1
      messages.push({
        excerpt: match.rule + ': ' + match.message
        location: {
          position: helpers.generateRange(textEditor, line)
        }
      })
    return messages
