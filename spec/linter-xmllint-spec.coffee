describe 'The xmllint provider for Linter', ->
  lint = require('../lib/init').provideLinter().lint

  beforeEach ->
    atom.workspace.destroyActivePaneItem()
    waitsForPromise ->
      return atom.packages.activatePackage('linter-xmllint')

  it 'should be in the packages list', ->
    return expect(atom.packages.isPackageLoaded('linter-xmllint')).toBe true

  it 'should be an active package', ->
    return expect(atom.packages.isPackageActive('linter-xmllint')).toBe true

  it 'finds nothing wrong with an empty file', ->
    waitsForPromise ->
      return atom.workspace.open(__dirname + '/fixtures/empty-root.xml').then (editor) ->
        return lint(editor).then (messages) ->
          expect(messages.length).toEqual 0

  it 'finds nothing wrong with a well formed file', ->
    waitsForPromise ->
      return atom.workspace.open(__dirname + '/fixtures/well-formed.xml').then (editor) ->
        return lint(editor).then (messages) ->
          expect(messages.length).toEqual 0

  it 'finds something wrong with a not well formed file', ->
    waitsForPromise ->
      return atom.workspace.open(__dirname + '/fixtures/not-well-formed.xml').then (editor) ->
        return lint(editor).then (messages) ->
          expect(messages.length).toEqual 1
          expect(messages[0].range).toEqual [[3, 8], [3, 8]]

  it 'finds nothing wrong with valid files', ->
    waitsForPromise ->
      return atom.workspace.open(__dirname + '/fixtures/valid/inline-dtd.xml').then (editor) ->
        return lint(editor).then (messages) ->
          expect(messages.length).toEqual 0
    waitsForPromise ->
      return atom.workspace.open(__dirname + '/fixtures/valid/external-dtd.xml').then (editor) ->
        return lint(editor).then (messages) ->
          expect(messages.length).toEqual 0
    waitsForPromise ->
      return atom.workspace.open(__dirname + '/fixtures/valid/noNamespaceSchemaLocation.xml').then (editor) ->
        return lint(editor).then (messages) ->
          expect(messages.length).toEqual 0
    waitsForPromise ->
      return atom.workspace.open(__dirname + '/fixtures/valid/schemaLocation.xml').then (editor) ->
        return lint(editor).then (messages) ->
          expect(messages.length).toEqual 0
    waitsForPromise ->
      return atom.workspace.open(__dirname + '/fixtures/valid/xml-model.xml').then (editor) ->
        return lint(editor).then (messages) ->
          expect(messages.length).toEqual 0
    waitsForPromise ->
      return atom.workspace.open(__dirname + '/fixtures/valid/all.xml').then (editor) ->
        return lint(editor).then (messages) ->
          expect(messages.length).toEqual 0
    waitsForPromise ->
      return atom.workspace.open(__dirname + '/fixtures/valid/relax.xml').then (editor) ->
        return lint(editor).then (messages) ->
          expect(messages.length).toEqual 0
    waitsForPromise ->
      return atom.workspace.open(__dirname + '/fixtures/valid/schematron.xml').then (editor) ->
        return lint(editor).then (messages) ->
          expect(messages.length).toEqual 0

  it 'finds something wrong with invalid files', ->
    waitsForPromise ->
      return atom.workspace.open(__dirname + '/fixtures/invalid/inline-dtd.xml').then (editor) ->
        return lint(editor).then (messages) ->
          expect(messages.length).toEqual 2
          expect(messages[0].range).toEqual [[10, 8], [10, 8]]
          expect(messages[0].text).toEqual 'No declaration for element foo (DTD)'
          expect(messages[1].range).toEqual [[14, 7], [14, 7]]
    waitsForPromise ->
      return atom.workspace.open(__dirname + '/fixtures/invalid/external-dtd.xml').then (editor) ->
        return lint(editor).then (messages) ->
          expect(messages.length).toEqual 1
          expect(messages[0].range).toEqual [[3, 11], [3, 11]]
          expect(messages[0].text).toEqual 'No declaration for attribute id of element to (DTD)'
    waitsForPromise ->
      return atom.workspace.open(__dirname + '/fixtures/invalid/noNamespaceSchemaLocation.xml').then (editor) ->
        return lint(editor).then (messages) ->
          expect(messages.length).toEqual 1
          expect(messages[0].range).toEqual [[9, 2], [9, 51]]
    waitsForPromise ->
      return atom.workspace.open(__dirname + '/fixtures/invalid/schemaLocation.xml').then (editor) ->
        return lint(editor).then (messages) ->
          expect(messages.length).toEqual 1
          expect(messages[0].range).toEqual [[6, 2], [6, 21]]
          expect(messages[0].text).toEqual "Element '{http://www.w3schools.com}to', attribute 'id': The attribute 'id' is not allowed. (../note.xsd)"
    waitsForPromise ->
      return atom.workspace.open(__dirname + '/fixtures/invalid/not-well-formed.xml').then (editor) ->
        return lint(editor).then (messages) ->
          expect(messages.length).toEqual 1
          expect(messages[0].range).toEqual [[7, 16], [7, 16]]
          expect(messages[0].text).toEqual 'Opening and ending tag mismatch: to line 8 and two'
    waitsForPromise ->
      return atom.workspace.open(__dirname + '/fixtures/invalid/xsd-error.xml').then (editor) ->
        return lint(editor).then (messages) ->
          expect(messages.length).toEqual 1
          expect(messages[0].range).toEqual [[10, 2], [10, 50]]
    waitsForPromise ->
      return atom.workspace.open(__dirname + '/fixtures/invalid/dtd-error.xml').then (editor) ->
        return lint(editor).then (messages) ->
          expect(messages.length).toEqual 2
          expect(messages[0].range).toEqual [[11, 11], [11, 11]]
          expect(messages[1].range).toEqual [[12, 7], [12, 7]]
    waitsForPromise ->
      return atom.workspace.open(__dirname + '/fixtures/invalid/xml-model-error.xml').then (editor) ->
        return lint(editor).then (messages) ->
          expect(messages.length).toEqual 1
          expect(messages[0].range).toEqual [[3, 2], [3, 21]]
    waitsForPromise ->
      return atom.workspace.open(__dirname + '/fixtures/invalid/relax-errors.xml').then (editor) ->
        return lint(editor).then (messages) ->
          expect(messages.length).toEqual 2
          expect(messages[0].range).toEqual [[8, 2], [8, 11]]
          expect(messages[0].text).toEqual 'Did not expect element footer there (../note.rng)'
          expect(messages[1].range).toEqual [[7, 2], [7, 44]]
          expect(messages[1].text).toEqual 'Did not expect element body there (../note2.rng)'
    waitsForPromise ->
      return atom.workspace.open(__dirname + '/fixtures/invalid/multiple-errors.xml').then (editor) ->
        return lint(editor).then (messages) ->
          expect(messages.length).toEqual 3
          expect(messages[0].range).toEqual [[11, 11], [11, 11]]
          expect(messages[1].range).toEqual [[12, 7], [12, 7]]
          expect(messages[2].range).toEqual [[10, 2], [10, 54]]
    waitsForPromise ->
      return atom.workspace.open(__dirname + '/fixtures/invalid/schematron-errors.xml').then (editor) ->
        return lint(editor).then (messages) ->
          expect(messages.length).toEqual 2
          expect(messages[0].range).toEqual [[2, 0], [2, 6]]
          expect(messages[0].text).toEqual '/note: Note must have a "from" (../schematron.xml)'
          expect(messages[1].range).toEqual [[2, 0], [2, 6]]
