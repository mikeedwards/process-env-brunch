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
          match = match.replace '$PROCESS_ENV_', ''
          if match and process.env[match]
            replacement = "'" + process.env[match] + "'"
          else
            replacement = 'undefined'
          replacement

        fs.writeFileSync generatedFile.path, result
