local obj = {}
obj.__index = obj

obj.logger = hs.logger.new('MuteSyncTeams')

function obj:start()
  obj:find()
  if obj.application
  then
    obj.logger.d(obj.application)
  else
    obj.logger.d("Application not found")
  end

  teamsWatcher = hs.application.watcher.new(function(name, action, app)
    if action == hs.application.watcher.launched and name == "Microsoft Teams" then
      obj.logger.d("Teams launch detected.")
      obj.application = app
      obj.logger.d(obj.application)
    end

    if action == hs.application.watcher.terminated then
      obj.from(app)
      --obj.logger.d(string.format('Need to check if "%s" is the PID for an existing teams', app:pid()))
    end
  end)
  teamsWatcher:start()
end

function obj:find()
  local app = hs.application.get("Microsoft Teams")
  if not app then return nil end

  obj:from(app)
end

function obj:from(app)
  if obj.application and app ~= nil and obj.application:pid() == app:pid() then return end

  obj.logger.d(app)

  obj:stopWatchingForMeetings()
  obj.application = app
  obj:startWatchingForMeetings()
end

function obj:startWatchingForMeetings()
  obj.windowWatcher = hs.application.watcher.new(function(name, event, app)
    if event == hs.uielement.watcher.windowCreated then
      obj.loger:d(name)
    end
  end)
  obj.windowWatcher:start()
end

function obj:stopWatchingForMeetings()
  if obj.windowWatcher then obj.windowWatcher:stop() end
end

return obj
