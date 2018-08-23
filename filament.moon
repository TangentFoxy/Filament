path = (...)\match "(.-)[^%.]+$"

import thread, filesystem from love

fn = (...) ->
  opts = ...
  if opts.modules
    for mod in opts.modules\gmatch "[^,]+"
      require mod
  loadstring(opts.fn\getString!)(opts)

fn = filesystem.newFileData string.dump(fn), "filament.thread"

next_id = 0

class Filament
  run: (...) ->
    filament = Filament(...)
    filament\start!
    return filament

  id: ->
    next_id += 1
    return next_id

  new: (opts={}) =>
    switch type opts
      when "string", "function"
        opts = fn: opts

    switch type opts.fn
      when "string"
        opts.fn = filesystem.newFileData opts.fn, "filament.fn"
      when "function"
        opts.fn = filesystem.newFileData string.dump(opts.fn), "filament.fn"

    opts.input = thread.getChannel(@id!) unless opts.input
    opts.output = thread.getChannel(@id!) unless opts.output

    @opts = opts
    @input = opts.input
    @output = opts.output
    @thread = thread.newThread fn

  start: =>
    @thread\start opts

  push: (...) =>
    if 1 < select "#", ...
      @input\push {...}
    else
      @input\push(...)

  pop: =>
    return @output\pop!

  supply: (...) =>
    if 1 < select "#", ...
      @input\supply {...}
    else
      @input\supply(...)

  demand: =>
    return @output\demand!

  peek: =>
    return @output\peek!

  getError: =>
    return @thread\getError!

  isRunning: =>
    return @thread\isRunning!

  wait: =>
    return @thread\wait!
