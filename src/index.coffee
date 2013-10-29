fs = require "fs"

module.exports = class ProcessEnvPrecompiler
  brunchPlugin: yes
  searchRegEx: /\$PROCESS_ENV_(\w+)/gi

  constructor: (config) ->
    # Extract own config object
    conf = config.plugins?.process_env or {}
    # Custom source files to process aside from generated files
    @customSources = conf.custom_sources or []
    # Allow raw (unquoted) processing
    @raw = conf.raw or false

  # Scan through the files to see whether there are matching *source* files
  # that need to be individually processed
  includeCustomSources: (generatedFiles) ->
    # Save us some resources if there isn't any custom sources
    return generatedFiles unless @customSources.length > 0

    # Extract the files that will be processed either way
    files = for file in generatedFiles
      path: file.path

    # Go through each category of generated files
    for generatedFile in generatedFiles
      # Go through each source file
      for file in generatedFile.sourceFiles
        # If it's wanted, add to files
        if file.path.indexOf(@customSources) > -1
          files.push file

    # Return the new files object
    files

  onCompile: (generatedFiles) ->
    for file in @includeCustomSources generatedFiles
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
