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
      return atom.workspace.open(__dirname + '/fixtures/valid/all.xml').then (editor) ->
        return lint(editor).then (messages) ->
          expect(messages.length).toEqual 0

  it 'finds something wrong with invalid files', ->
    waitsForPromise ->
      return atom.workspace.open(__dirname + '/fixtures/invalid/inline-dtd.xml').then (editor) ->
        return lint(editor).then (messages) ->
          expect(messages.length).toEqual 2
    waitsForPromise ->
      return atom.workspace.open(__dirname + '/fixtures/invalid/external-dtd.xml').then (editor) ->
        return lint(editor).then (messages) ->
          expect(messages.length).toEqual 1
    waitsForPromise ->
      return atom.workspace.open(__dirname + '/fixtures/invalid/noNamespaceSchemaLocation.xml').then (editor) ->
        return lint(editor).then (messages) ->
          expect(messages.length).toEqual 1
    waitsForPromise ->
      return atom.workspace.open(__dirname + '/fixtures/invalid/schemaLocation.xml').then (editor) ->
        return lint(editor).then (messages) ->
          expect(messages.length).toEqual 1
    waitsForPromise ->
      return atom.workspace.open(__dirname + '/fixtures/invalid/not-well-formed.xml').then (editor) ->
        return lint(editor).then (messages) ->
          expect(messages.length).toEqual 1
    waitsForPromise ->
      return atom.workspace.open(__dirname + '/fixtures/invalid/xsd-error.xml').then (editor) ->
        return lint(editor).then (messages) ->
          expect(messages.length).toEqual 1
    waitsForPromise ->
      return atom.workspace.open(__dirname + '/fixtures/invalid/dtd-error.xml').then (editor) ->
        return lint(editor).then (messages) ->
          expect(messages.length).toEqual 2

  # describe('checks bad.php and', () => {
  #   let editor = null;
  #   beforeEach(() => {
  #     waitsForPromise(() => {
  #       return atom.workspace.open(__dirname + '/files/bad.php').then(openEditor => {
  #         editor = openEditor;
  #       });
  #     });
  #   });

  #   it('finds at least one message', () => {
  #     waitsForPromise(() => {
  #       return lint(editor).then(messages => {
  #         expect(messages.length).toEqual(1);
  #       });
  #     });
  #   });

  #   it('verifies that message', () => {
  #     waitsForPromise(() => {
  #       return lint(editor).then(messages => {
  #         expect(messages[0].type).toBeDefined();
  #         expect(messages[0].type).toEqual('Error');
  #         expect(messages[0].text).toBeDefined();
  #         expect(messages[0].text).toEqual('syntax error, unexpected \'{\' in -');
  #         expect(messages[0].filePath).toBeDefined();
  #         expect(messages[0].filePath).toMatch(/.+bad\.php$/);
  #         expect(messages[0].range).toBeDefined();
  #         expect(messages[0].range.length).toEqual(2);
  #         expect(messages[0].range).toEqual([[1, 0], [1, 6]]);
  #       });
  #     });
  #   });
  # });

  # it('finds nothing wrong with a valid file', () => {
  #   waitsForPromise(() => {
  #     return atom.workspace.open(__dirname + '/files/good.php').then(editor => {
  #       return lint(editor).then(messages => {
  #         expect(messages.length).toEqual(0);
  #       });
  #     });
  #   });
  # })
