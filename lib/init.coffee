module.exports =
  config:
    xmllintExecutablePath:
      type: 'string'
      default: ''

  activate: ->
    console.log 'activate linter-xmllint'
