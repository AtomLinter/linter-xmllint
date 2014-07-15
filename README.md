linter-xmllint
===========

> xmllint — The xmllint program parses XML files. It is useful for detecting errors XML code. See [xmlsoft.org/xmllint.html](http://xmlsoft.org/xmllint.html) for more informations about xmllint.

This package will lint your `.xml` opened filed in Atom through [xmllint linter](http://xmlsoft.org/xmllint.html). **It will lint on edit and/or on save**, so you'll see instantly if your code has errors.

### Linter installation
Before using this package, you must ensure that `xmllint` is installed on your system. On recent versions of Mac OS X, `xmllint` comes pre-installed. To install `xmllint` on other platforms, do the following:

1. On Linux:

     ```text
     [sudo] apt-get install libxml2-utils
     ```

   On Windows, follow the instructions [here](http://flowingmotion.jojordan.org/2011/10/08/3-steps-to-download-xmllint/). There is another version on code.google.com, but that version is incompatible with this plugin.

Once `xmllint` is installed, you must ensure it is in your system PATH so that Linter can find it.

## Installation

* `$ apm install linter` (if you don't have [AtomLinter/Linter](https://github.com/AtomLinter/Linter) installed).
* `$ apm install linter-xmllint`


## Other available linters
- [linter-php](https://atom.io/packages/linter-php), for PHP using `php -l`
- [linter-phpcs](https://atom.io/packages/linter-phpcs) - Linter plugin for PHP, using phpcs.
- [linter-phpmd](https://atom.io/packages/linter-phpmd) - Linter plugin for PHP, using phpmd.
- [linter-jshint](https://atom.io/packages/linter-jshint) - Linter plugin for JavaScript, using jshint.
- [linter-scss-lint](https://atom.io/packages/linter-scss-lint) - Sass Linter plugin for SCSS, using scss-lint.
- [linter-coffeelint](https://atom.io/packages/linter-coffeelint) Linter plugin for CoffeeScript, using coffeelint.
- [linter-csslint](https://atom.io/packages/linter-csslint) Linter plugin for CSS, using csslint.
- [linter-rubocop](https://atom.io/packages/linter-rubocop) - Linter plugin for Ruby, using rubocop.
- [linter-tslint](https://atom.io/packages/linter-tslint) Linter plugin for TypeScript, using tslint.
