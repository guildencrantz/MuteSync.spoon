--- === MuteSync ===
---
--- Sync the mic's mute state between the system and Microsoft Teams.
---
--- Download: https://github.com/guildencrantz/MuteSync.spoon/releases

local obj = {}
obj.__index = obj

-- Metadata
obj.name = "MuteSync"
obj.version = "0.1"
obj.author = "Matt Henkel <guildencrantz@menagerie.cc>"
obj.homepage = "https://github.com/guildencrantz/MuteSync.spoon"
obj.license = "MIT - https://github.com/guildencrantz/MuteSync.spoon/blob/main/LICENSE"

--- MuteSync.logger
--- Variable
--- Logger object used within the Spoon. Can be accessed to set the default log level for the messages coming from the Spoon.
obj.logger = hs.logger.new('MuteSync')

function obj:init()
  -- TODO: Conditionally enable apps
  obj.logger.i("Init")
  obj.apps = {
    teams = dofile(hs.spoons.resourcePath("teams.lua")),
  }
end

function obj:start()
  for k, v in pairs(obj.apps) do
    v.logger.setLogLevel(obj.logger:getLogLevel())
    obj.logger.i("Starting "..k)
    v:start()
  end
end

function obj:stop()
  for k, v in pairs(obj.apps) do
    obj.logger.i("Stopping "..k)
    v:stop()
  end
end


-- TODO: Consider a obj:bindHotkeys(mapping)

return obj
