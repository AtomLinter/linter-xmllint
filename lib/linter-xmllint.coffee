linterPath = atom.packages.getLoadedPackage("linter").path
Linter = require "#{linterPath}/lib/linter"

class LinterXmllint extends Linter
  # ConfigObserver.includeInto(this)

  # The syntax that the linter handles. May be a string or
  # list/tuple of strings. Names should be all lowercase.
  @syntax: 'text.xml'

  # A string, list, tuple or callable that returns a string, list or tuple,
  # containing the command line (with arguments) used to lint.
  cmd: 'xmllint --noout'

  linterName: 'xmllint'

  # A regex pattern used to extract information from the executable's output.
  regex:
    '.+?:' +
    '(?<line>\\d+):.+?: ' +
    '(?<message>[^\\r\\n]+).*?' +
    '.*?' +
    '(?<col>[^\\^]*)\\^'

  errorStream: 'stderr'

  regexFlags: 's'

  constructor: (editor)->
    super(editor)

    atom.config.observe 'linter-xmllint.xmllintExecutablePath', =>
      @executablePath = atom.config.get 'linter-xmllint.xmllintExecutablePath'

  destroy: ->
    atom.config.unobserve 'linter-xmllint.xmllintExecutablePath'

module.exports = LinterXmllint
