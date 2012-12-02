fs = require "fs"

module.exports = class ProcessEnvPrecompiler
  brunchPlugin: yes
  searchRegEx: /_PROCESS_ENV_(\w+)/gi

  constructor: (@config) ->

  onCompile: (generatedFiles) ->
    for generatedFile in generatedFiles
      do (generatedFile) =>
        fs.readFile generatedFile.path, "utf8", (err, data) =>
          result = data.replace @searchRegEx, (match)=>
            '"' + process.env[(@searchRegEx.exec match)[1]] + '"'
          
          fs.writeFile generatedFile.path, result


