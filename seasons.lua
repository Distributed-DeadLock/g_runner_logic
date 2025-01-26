-- function for new season
local function new_season(name)
	-- get highscores
	local sorting = {}
	for i,v in pairs(g_runner_logic.highscore) do
		table.insert(sorting, {i, v})
	end
	table.sort(sorting, function (k1, k2) return tonumber(k1[2]) < tonumber(k2[2]) end )
	-- compile season results
	local score = {}
	for i=1,3 do
		print(i)
		if sorting[i] then
			table.insert(score, {sorting[i][1],sorting[i][2]})
		end
	end
	-- add to seasonscore list
	table.insert(g_runner_logic.seasonscore, {g_runner_logic.season, score})
	g_runner_logic.storage:set_string("seasonscores", core.serialize(g_runner_logic.seasonscore))
	
	-- delete highscores
	g_runner_logic.highscore = {}
	g_runner_logic.storage:set_string("highscores",core.serialize(g_runner_logic.highscore))
	
	-- advance season score
	g_runner_logic.season = tonumber(g_runner_logic.season) + 1
	g_runner_logic.storage:set_string("season", g_runner_logic.season)
	
	--
	core.chat_send_all("-- New Season! --")
	core.chat_send_all("Season " .. g_runner_logic.season .. " has started.")
end


-- chatcommand to advance to next season
core.register_chatcommand("newseason", {
    description = "Start a new season",
	privs = {
        newseason = true,
    },
    func = function(name)
		new_season(name)
    end,
})


-- the show season-winners chatcommand
core.register_chatcommand("seasonwinners", {
    description = "Show the Winners of previous Seasons",
	privs = {interact = true},
    func = function(name)
		local aseason
		for i,v in pairs(g_runner_logic.seasonscore) do
			core.chat_send_player(name, "Season: " .. v[1] )
			aseason = "|"
			for j,w in pairs(v[2]) do
				aseason = aseason .. j .. ". " .. w[1] .. " : " .. w[2] .. " | "
			end
			core.chat_send_player(name, aseason)
		end
    end,
})