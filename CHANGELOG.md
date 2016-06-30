# Changelog linter-xmllint

## 1.3.5 (Jun 30 2016)

* Make warnings from the linter available rather then ignoring them ([#62](https://github.com/AtomLinter/linter-xmllint/pull/62))
* Update to AtomLinter 5.0.1 ([#59](https://github.com/AtomLinter/linter-xmllint/pull/59))
* Update to xmldoc 0.5.0 ([#57](https://github.com/AtomLinter/linter-xmllint/pull/57))

## 1.3.4 (Feb 24 2016)

* Update to XRegExp 3.1.0 ([#52](https://github.com/AtomLinter/linter-xmllint/pull/52))

## 1.3.3 (Feb 17 2016)

* Fix regex to work on Windows ([#49](https://github.com/AtomLinter/linter-xmllint/pull/49))

## 1.3.2 (Feb 13 2016)

* Fix marker text for DTD errors (regression in 1.3.0) ([#43](https://github.com/AtomLinter/linter-xmllint/pull/43))
* Improve marker position and text for schemas and schematron ([#44](https://github.com/AtomLinter/linter-xmllint/pull/44))

## 1.3.1 (Feb 10 2016)

* Improve startup time ([#41](https://github.com/AtomLinter/linter-xmllint/pull/41))

## 1.3.0 (Jan 8 2016)

* Add support for Relax NG and Schematron schemas ([#29](https://github.com/AtomLinter/linter-xmllint/issues/29))
* Validate against all specified schemas ([#37](https://github.com/AtomLinter/linter-xmllint/pull/37))

## 1.2.0 (Dec 14 2015)

* Add support for *lintOnFlyAdd* option ([#32](https://github.com/AtomLinter/linter-xmllint/pull/32))
* Add support for *xml-model* processing instruction to specify the *XML schema definition* ([#34](https://github.com/AtomLinter/linter-xmllint/pull/34))

## 1.1.0 (Nov 14 2015)

* Add validation based on *document type definition* (`.dtd`) and *XML schema definition* (`.xsd`) files ([#28](https://github.com/AtomLinter/linter-xmllint/pull/28))

## 1.0.0 (Nov 10 2015)

* Update to new `linter` API ([#27](https://github.com/AtomLinter/linter-xmllint/pull/27))

## 0.0.7 (Jun 27 2015)

* Also check `.xsl` files ([#5](https://github.com/AtomLinter/linter-xmllint/issues/5))
* Fix `Uncaught TypeError` by updating regular expression ([#18](https://github.com/AtomLinter/linter-xmllint/issues/18))

## 0.0.6 (May 26 2015)

* Update configuration to use non-deprecated API ([#7](https://github.com/AtomLinter/linter-xmllint/issues/7), [#8](https://github.com/AtomLinter/linter-xmllint/issues/8), [#10](https://github.com/AtomLinter/linter-xmllint/issues/10))

## 0.0.5 (Aug 13 2014)

* Update README

## 0.0.4 (Jul 28 2014)

* Update README

## 0.0.3 (May 14 2014)

* First working release checking that `.xml` files are *well-formed*
