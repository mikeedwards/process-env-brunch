module.exports = class ProcessEnvPrecompiler
  brunchPlugin: yes
  type: 'javascript'
  pattern: /\.(coffee|js|html|hbr|css|styl|sass|scss|less)/
  searchRegEx: /_PROCESS_ENV_(\w+)/gi

  constructor: (@config) ->
    null

  compile: (data, path, callback) ->
    try
      result = data.replace @searchRegEx, (match)=>
        '"' + process.env[(@searchRegEx.exec match)[1]] + '"'
    catch err
      error = err
    finally
      callback error, result
