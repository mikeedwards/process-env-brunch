fs = require "fs"

module.exports = class ProcessEnvPrecompiler
  brunchPlugin: yes
  searchRegEx: /\$PROCESS_ENV_(\w+)/gi

  constructor: (@config) ->

  onCompile: (generatedFiles) ->
    for generatedFile in generatedFiles
      do (generatedFile) =>
        data = fs.readFileSync generatedFile.path, "utf8"
        result = data.replace @searchRegEx, (match) =>
          matches = @searchRegEx.exec match
          if matches isnt null
            replacement = "'" + process.env[matches[1]] + "'"
          else
            replacement = 'undefined'
          replacement

        fs.writeFileSync generatedFile.path, result


