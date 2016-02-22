# linter-xmllint

[![Build Status](https://img.shields.io/travis/AtomLinter/linter-xmllint.svg)](https://travis-ci.org/AtomLinter/linter-xmllint)
[![Plugin installs!](https://img.shields.io/apm/dm/linter-xmllint.svg)](https://atom.io/packages/linter-xmllint)
[![Package version!](https://img.shields.io/apm/v/linter-xmllint.svg)](https://atom.io/packages/linter-xmllint)
[![Dependencies!](https://img.shields.io/david/AtomLinter/linter-xmllint.svg)](https://david-dm.org/AtomLinter/linter-xmllint)

> xmllint - The xmllint program parses XML files. It is useful for detecting errors XML code. See [xmlsoft.org/xmllint.html](http://xmlsoft.org/xmllint.html) for more informations about xmllint.

This package will lint your opened `.xml` files in Atom through [xmllint linter](http://xmlsoft.org/xmllint.html).

The [changelog](https://github.com/AtomLinter/linter-xmllint/blob/master/CHANGELOG.md) lists the changes for each release.

## Linter installation

Before using this package, you must ensure that `xmllint` is installed on your system. On recent versions of Mac OS X, `xmllint` comes pre-installed. To install `xmllint` on other platforms, do the following:

- On Linux:

  ```text
  [sudo] apt-get install libxml2-utils
  ```

- On Windows, the current binary distribution is managed by Igor Zlatkovic ([here](https://www.zlatkovic.com/libxml.en.html "Igor Zlatkovic")) and there were some known issues with version 2.9.3 (20903) x86_64.
  The validation messages did not contain the filename and would not work with this plugin.
  The instructions below use the 2.7.8 (20708) x86 binary.

  1. Pick a location where to store the required files, e.g. `C:\tools\xmllint`.

  1. Browse to ftp://ftp.zlatkovic.com/libxml/ to get the needed files.
    If the versions are no longer available at root check the [oldreleases](ftp://ftp.zlatkovic.com/libxml/oldreleases/ "Old Releases") folder.

  1. Download the following files:

    - `iconv-1.9.2.win32.zip`
    - `libxml2-2.7.8.win32.zip`
    - `libxslt-1.1.26.win32.zip`
    - `zlib-1.2.5.win32.zip`

  1. Extract all the files into the location we created in the first step.
    Example of extracted structure:

    ```text
    C:\tools\xmllint\
    - bin
    - include
    - lib
    - share
    ```

  1. Add the `bin` directory to your path, e.g. `C:\tools\xmllint\bin` by calling

    - `setx path %PATH%;C:\tools\xmllint\bin`
    - This is a CLI command that will attempt to add it to your path, if your path is really long it will fail and you will have to do it manually through windows.
      Use quotes if your path has spaces.

  1. Open a new command prompt and try the command `xmllint --version` to see if it worked.
    If it worked you will see the version be (20708).

## Installation

- `$ apm install linter-xmllint`
