-- Fastest Player Reporting Digilines-Block

 -- called on message recieve  
local on_digiline_receive = function (pos, _, channel, msg) 
	local receiveChannel = core.get_meta(pos):get_string("channel")
    if channel == receiveChannel then
		local cmd = string.sub(msg,1,3)		
		if (cmd == "GET") then
			local nr = tonumber(string.sub(msg,5,-1))
			
			
			local sorting = {}
			for i,v in pairs(g_runner_logic.highscore) do
				table.insert(sorting, {i, v})
			end
			table.sort(sorting, function (k1, k2) return tonumber(k1[2]) < tonumber(k2[2]) end )
			local answer
			if sorting[nr] then
				answer = nr .. ". " .. sorting[nr][1] .. " " .. g_runner_logic.SecondsToClock(sorting[nr][2]) 
			else
				answer = 0
			end
			digilines.receptor_send(pos, digilines.rules.default, receiveChannel, answer) -- send Player at Highscore position "nr"
		end
    end
end

core.register_node("g_runner_logic:RunTimeReport", {
	description = "This block gets the fastest Player",
	tiles = {
		"g_runner_logic_goal_top.png",
		"g_runner_logic_goal_top.png",
		"g_runner_logic_dl_side.png",
		"g_runner_logic_dl_side.png",
		"g_runner_logic_dl_side.png",
		"g_runner_logic_dl_side.png"
	},
        groups = {cracky = 2},
        digilines = 
	{
		receptor = {},
		effector = {
			action = on_digiline_receive
		},
	},
    after_place_node = function(pos, placer)
		local meta = core.get_meta(pos)
		meta:set_string("channel", "")
		meta:set_string("formspec",
				"size[10,10]"..
				"label[4,4;Channel]".. 
                "field[2,5;6,1;chnl;;${channel}]"..  
                "button_exit[4,6;2,1;exit;Save]")
	end,
    on_receive_fields = function(pos, formname, fields, player)
        core.get_meta(pos):set_string("channel", fields.chnl)
    end
})
