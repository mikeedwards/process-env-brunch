fs = require "fs"

module.exports = class ProcessEnvPrecompiler
  brunchPlugin: yes
  searchRegEx: /\$PROCESS_ENV_(\w+)/gi

  constructor: (config) ->
    # Extract own config object
    conf = config.plugins?.process_env or {}

    # Custom targets to process aside from generated files
    @customTargets = for target in (conf.custom_targets or [])
      # Simulate generated files
      path: target

    # Allow raw (unquoted) processing
    @raw = conf.raw or false

  onCompile: (generatedFiles) ->
    for file in @customTargets.concat generatedFiles
      do (file) =>
        data = fs.readFileSync file.path, "utf8"
        result = data.replace @searchRegEx, (match) =>
          match = match.replace '$PROCESS_ENV_', ''
          if match and process.env[match]
            if @raw
              # Pass through as-is if desired
              replacement = process.env[match]
            else
              # Quote it to be safe otherwise
              replacement = "'" + process.env[match] + "'"
          else
            replacement = 'undefined'
          replacement

        fs.writeFileSync file.path, result
