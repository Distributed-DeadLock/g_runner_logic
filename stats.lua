-- the show your stats(rank, best-time, last-time) chatcommand
core.register_chatcommand("mystats", {
    description = "Show my Rank, Best-Time & Last-Time",
	privs = {interact = true},
    func = function(name)
		local player = core.get_player_by_name(name)
		local pmeta = player:get_meta()
		local rank = pmeta:get_int("g_runner_logic:rank")
		local besttime = pmeta:get_int("g_runner_logic:besttime")
		local lasttime = pmeta:get_int("g_runner_logic:lasttime")
		core.chat_send_player(name, "Rank: " .. rank .. " -- BestTime: " .. g_runner_logic.SecondsToClock(besttime) .. " -- LastTime: " .. g_runner_logic.SecondsToClock(lasttime))		
    end,
})


-- the show highscore chatcommand
core.register_chatcommand("highscores", {
    description = "Show the Highscore List",
	privs = {interact = true},
    func = function(name)
		local sorting = {}
		for i,v in pairs(g_runner_logic.highscore) do
			table.insert(sorting, {i, v})
		end
		table.sort(sorting, function (k1, k2) return tonumber(k1[2]) < tonumber(k2[2]) end )									
		core.chat_send_player(name, "Highscores")
		core.chat_send_player(name, "------------------")
		for i,v in ipairs(sorting) do
			local nl = string.len(v[1])
			local pad = string.rep(" ",math.max((30 - nl), 1))
			core.chat_send_player(name, i .. ". " .. v[1] .. "\t" .. pad .. " : " .. g_runner_logic.SecondsToClock(v[2]))
		end
    end,
})

-- a who chatcommand showing additional info

core.register_chatcommand("who", {
	description = "List online players, their Rank & Run-Status(R = running | F = finnished)",
	privs = {interact = true},
	func = function(name, param)
		local who = "Players Online:  "
		for _, obj in pairs(core.get_connected_players()) do
			local pmeta = obj:get_meta()
			local runstat
			if (pmeta:get_int("g_runner_logic:starttime") == 0) then
				runstat = "F"
			else
				runstat = "R"
			end
			who = who .. obj:get_player_name() .. " [" .. pmeta:get_int("g_runner_logic:rank") .. "] (" .. runstat .. ") , "
		end
		core.chat_send_player(name, who)
	end,
})
