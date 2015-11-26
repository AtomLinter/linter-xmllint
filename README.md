# linter-xmllint

[![Build Status](https://img.shields.io/travis/AtomLinter/linter-xmllint.svg)](https://travis-ci.org/AtomLinter/linter-xmllint)
[![Plugin installs!](https://img.shields.io/apm/dm/linter-xmllint.svg)](https://atom.io/packages/linter-xmllint)
[![Package version!](https://img.shields.io/apm/v/linter-xmllint.svg)](https://atom.io/packages/linter-xmllint)
[![Dependencies!](https://img.shields.io/david/AtomLinter/linter-xmllint.svg)](https://david-dm.org/AtomLinter/linter-xmllint)

> xmllint — The xmllint program parses XML files. It is useful for detecting errors XML code. See [xmlsoft.org/xmllint.html](http://xmlsoft.org/xmllint.html) for more informations about xmllint.

This package will lint your opened `.xml` files in Atom through [xmllint linter](http://xmlsoft.org/xmllint.html).

The [changelog](https://github.com/AtomLinter/linter-xmllint/blob/master/CHANGELOG.md) lists the changes for each release.

## Linter installation

Before using this package, you must ensure that `xmllint` is installed on your system. On recent versions of Mac OS X, `xmllint` comes pre-installed. To install `xmllint` on other platforms, do the following:

1. On Linux:

     ```text
     [sudo] apt-get install libxml2-utils
     ```

2. On Windows, follow the instructions [here](http://flowingmotion.jojordan.org/2011/10/08/3-steps-to-download-xmllint/). There is another version on code.google.com, but that version is incompatible with this plugin.

Once `xmllint` is installed, you must ensure it is in your system PATH so that Linter can find it.

## Installation

* `$ apm install linter-xmllint`
