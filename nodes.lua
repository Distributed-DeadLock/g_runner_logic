-- Register the goal-block.
core.register_node("g_runner_logic:the_goal", {
	description = "The Goal",
	tiles = {{name="g_runner_logic_goal_atop.png", animation={type="vertical_frames", aspect_w=16, aspect_h=16, length=11}}, 
			 {name="g_runner_logic_goal_atop.png", animation={type="vertical_frames", aspect_w=16, aspect_h=16, length=21}},
			 {name="g_runner_logic_goal_aside.png", animation={type="vertical_frames", aspect_w=16, aspect_h=16, length=13}},
			 {name="g_runner_logic_goal_aside.png", animation={type="vertical_frames", aspect_w=16, aspect_h=16, length=15}},
			 {name="g_runner_logic_goal_aside.png", animation={type="vertical_frames", aspect_w=16, aspect_h=16, length=17}},
			 {name="g_runner_logic_goal_aside.png", animation={type="vertical_frames", aspect_w=16, aspect_h=16, length=19}},
			},
	paramtype = "light",
	paramtype2 = "facedir",
	light_source = 10,
	groups = {cracky = 2},
	legacy_facedir_simple = true,
	sounds = default.node_sound_wood_defaults(),
	on_construct = function(pos)
		local meta = core.get_meta(pos)
		meta:set_string("infotext", "The Goal. Punch it to stop your time!")
	end,
	on_punch = function(pos, node, puncher, pointed_thing)
        if puncher:is_player() then
			local pmeta = puncher:get_meta()
			local now = os.time()
			local starttime = pmeta:get_int("g_runner_logic:starttime")
			local playername = puncher:get_player_name()
			local maininv = puncher:get_inventory()
			if (starttime > 0) then
				local currenttime = now - starttime
				pmeta:set_int("g_runner_logic:lasttime", currenttime)
				core.chat_send_player(playername, "Run finnished. Time: " .. g_runner_logic.SecondsToClock(currenttime) .. " (H:M:S)")
				local rank = pmeta:get_int("g_runner_logic:rank")
				rank = rank + 1
				pmeta:set_int("g_runner_logic:rank", rank)
				core.chat_send_player(playername, "Your are now Rank: " .. rank)
				core.chat_send_player(playername, "Check the Price-Chest!")
				local pricelist = g_runner_logic.storage:get("price" .. rank)
				if pricelist then			
					local list_strings = core.deserialize(pricelist)
					for _, str in pairs(list_strings) do
						maininv:add_item("g_runner_logic:price_chest", ItemStack(str))
					end
				else
					local pricelist = g_runner_logic.storage:get("price" .. "over")
					if pricelist then
						local list_strings = core.deserialize(pricelist)
						maininv:add_item("g_runner_logic:price_chest", ItemStack(list_strings[math.random(1, 8)]))
						maininv:add_item("g_runner_logic:price_chest", ItemStack(list_strings[math.random(1, 8)]))
					end
				end
				
				local besttime = pmeta:get_int("g_runner_logic:besttime")
				if (currenttime < besttime) then
					core.chat_send_all(playername .. " set a new personal Best-Time with: " .. g_runner_logic.SecondsToClock(currenttime) .. " (H:M:S)")
					pmeta:set_int("g_runner_logic:besttime", currenttime)
					g_runner_logic.highscore[playername] = currenttime
					g_runner_logic.storage:set_string("highscores", core.serialize(g_runner_logic.highscore))
				elseif (besttime == 0) then
					core.chat_send_all(playername .. " finnished the first Run in: " .. g_runner_logic.SecondsToClock(currenttime) .. " (H:M:S)")
					pmeta:set_int("g_runner_logic:besttime", currenttime)
					g_runner_logic.highscore[playername] = currenttime
					g_runner_logic.storage:set_string("highscores", core.serialize(g_runner_logic.highscore))					
				end
				pmeta:set_int("g_runner_logic:starttime", 0)
			end
        end
    end,
})

-- Register the price-chest.
core.register_node("g_runner_logic:price_chest", {
	description = "" ..core.colorize("#229944","Prize Chest\n") ..core.colorize("#FFFFFF", "Check for prices after each run."),
	tiles = {"g_runner_logic_pricechest_top.png", "g_runner_logic_pricechest_top.png", "g_runner_logic_pricechest_side.png",
		"g_runner_logic_pricechest_side.png", "g_runner_logic_pricechest_side.png", "g_runner_logic_pricechest_front.png"},
	paramtype2 = "facedir",
	groups = {snappy=2, choppy=2, oddly_breakable_by_hand=2,},
	legacy_facedir_simple = true,
	sounds = default.node_sound_wood_defaults(),
	on_construct = function(pos)
		local meta = core.get_meta(pos)
		meta:set_string("formspec",
				"size[8,6]"..
				default.gui_bg ..
				default.gui_bg_img ..
				default.gui_slots ..
				"list[current_player;g_runner_logic:price_chest;0,0.3;8,2;]"..
				"list[current_player;main;0,1.85;8,1;]" ..
				"list[current_player;main;0,3.08;8,3;8]" ..
				"listring[current_player;g_runner_logic:price_chest]" ..
				"listring[current_player;main]" ..
				default.get_hotbar_bg(0,1.85))

		meta:set_string("infotext", "Price Chest")
	end,	
})