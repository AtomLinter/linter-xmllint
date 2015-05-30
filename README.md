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

Check out [AtomLinter](https://github.com/AtomLinter) for an up-to-date list!

## Donation
[![Share the love!](https://chewbacco-stuff.s3.amazonaws.com/donate.png)](https://www.paypal.com/cgi-bin/webscr?cmd=_s-xclick&hosted_button_id=KXUYS4ARNHCN8)
