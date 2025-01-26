--- g_runner_logic  -- Runner Game Logic ---
--- a Luanti/Minetest Mod --
--- Logic and Blocks for the Runner Game

local modpath = core.get_modpath("g_runner_logic")

-- Definitions made by this mod that other mods can use too
g_runner_logic = {}

-- init Mod storage
g_runner_logic.storage = core.get_mod_storage()
local s_highscorelist = g_runner_logic.storage:get("highscores")
if not s_highscorelist then
	s_highscorelist = core.serialize({})
	g_runner_logic.storage:set_string("highscores", s_highscorelist)
end
g_runner_logic.highscore = core.deserialize(s_highscorelist)

g_runner_logic.season = g_runner_logic.storage:get("season")
if not g_runner_logic.season then
	g_runner_logic.season = 1
	g_runner_logic.storage:set_string("season", g_runner_logic.season)
end

local s_seasonscorelist = g_runner_logic.storage:get("seasonscores")
if not s_seasonscorelist then
	s_seasonscorelist = core.serialize({})
	g_runner_logic.storage:set_string("seasonscores", s_seasonscorelist)
end
g_runner_logic.seasonscore = core.deserialize(s_seasonscorelist)


-- register priv for price setup
core.register_privilege("prizemanage", {
    description = "Can manage the prices for the runner Game",
    give_to_singleplayer = true
})
-- register priv for season advance
core.register_privilege("newseason", {
    description = "Can start a new Season for the runner Game",
    give_to_singleplayer = true
})

-- Helper function for time formatting
function g_runner_logic.SecondsToClock(seconds)
  local seconds = tonumber(seconds)
  if seconds <= 0 then
    return "00:00:00";
  else
    local hours = string.format("%02.f", math.floor(seconds/3600));
    local mins = string.format("%02.f", math.floor(seconds/60 - (hours*60)));
    local secs = string.format("%02.f", math.floor(seconds - hours*3600 - mins *60));
    return hours..":"..mins..":"..secs
  end
end

-- Create a prize chest inv & Init player values when first connected.
core.register_on_joinplayer(function(player,last_login)
	local inv = player:get_inventory()
	inv:set_size("g_runner_logic:prize_chest", 8*1)
	local pmeta = player:get_meta()
	if not (pmeta:get_int("g_runner_logic:season") > 0) then
		pmeta:set_int("g_runner_logic:rank", 0)
		pmeta:set_int("g_runner_logic:starttime", os.time())
		pmeta:set_int("g_runner_logic:lasttime", 0)
		pmeta:set_int("g_runner_logic:besttime", 0)
		pmeta:set_int("g_runner_logic:season", g_runner_logic.season)
	end
	local pseason = tonumber(pmeta:get_int("g_runner_logic:season"))
	if not (pseason == tonumber(g_runner_logic.season)) then
		core.chat_send_player(player:get_player_name(), "We are in Season " .. g_runner_logic.season .. " now. Respawn to join!")
	end
end)

-- Reset the starttime when player respawns
core.register_on_respawnplayer(function(player) 
	local pmeta = player:get_meta()
	pmeta:set_int("g_runner_logic:starttime", os.time())
	local pseason = tonumber(pmeta:get_int("g_runner_logic:season"))
	if not (pseason == tonumber(g_runner_logic.season)) then
		pmeta:set_int("g_runner_logic:season", g_runner_logic.season)
		pmeta:set_int("g_runner_logic:lasttime", 0)
		pmeta:set_int("g_runner_logic:besttime", 0)
		core.chat_send_player(player:get_player_name(), "Welcome to Season " .. g_runner_logic.season)
	end
end)


dofile(modpath .. "/prizeconfig.lua")
dofile(modpath .. "/nodes.lua")
dofile(modpath .. "/stats.lua")
dofile(modpath .. "/seasons.lua")
if core.get_modpath("digilines") then
	dofile(modpath .. "/dl_block.lua")
end
if core.get_modpath("3d_armor") then
	dofile(modpath .. "/chestplate.lua")
end