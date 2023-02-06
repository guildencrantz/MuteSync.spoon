local obj = {}
obj.__index = obj

obj.logger = hs.logger.new('MuteSyncTeams')
obj.meetings = {}
obj.windows = {}

obj.windowCreated = function(window, app_name, event)
  obj.logger.d("Window created")

  obj:addWindow(window)
end

obj.windowDestroyed = function(window, app_name, event)
  obj.logger.d("Window destroyed")
  obj.removeWindow(window)
end

obj.titleChanged = function(observer, axui, notification, addl)
  obj.logger.d("Window title changed: "..axui.AXTitle)
end


function obj:start()
  if obj.windowWatcher
  then
    obj.logger.d("Resuming window watcher")
    obj.windowWatcher:resume()
  else
    obj.logger.d("Creating window watcher")
    local wf = hs.window.filter
    -- Empty default filter means visible and invisible windows
    local teams = wf.new{['Microsoft Teams'] = {}}
    obj.windowWatcher = teams:subscribe(wf.windowCreated, obj.windowCreated):subscribe(wf.windowDestroyed, obj.windowDestroyed)
  end

  local windows = obj.windowWatcher:getWindows()
  for _, window in pairs(windows) do
    obj:addWindow(window)
  end
end

function obj:addWindow(window)
  if obj.app == nil then
    obj.app = window:application()

    obj.observer = hs.axuielement.observer.new(obj.app:pid())

    obj.observer:callback(obj.titleChanged)
  end

  local we = hs.axuielement.windowElement(window)
  obj.logger.d(we.AXTitle)

  obj.windows[window.id()] = {
    axui = we,
    observers = {
      titleChanged = obj.observer:addWatcher(we, "titleChanged"),
    },
  }
end

function obj:removeWindow(window)

end

function obj:stop()
  obj.windowWatcher.pause()
end

function obj:find()
  local app = hs.application.get("Microsoft Teams")
  if not app then return nil end

  obj:from(app)
end

function obj:from(app)
end

return obj
