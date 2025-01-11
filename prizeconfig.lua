-- thanks to rubenwardy for the inventory (de)serialization

--  detached inventory for managing the pice-lists
local prizeinv = core.create_detached_inventory("g_runner_logic_prizemanage", {
    on_move = function(inv, from_list, from_index, to_list, to_index, count, player)
		local list = inv:get_list("prize")
		local retval = {}
		for _, stack in pairs(list) do
			retval[#retval + 1] = stack:to_string()
		end
		local data_base = core.serialize(retval)			
        g_runner_logic.storage:set_string("prize" .. g_runner_logic.storage:get_string("prizerank"), data_base)
    end,

    on_put = function(inv, listname, index, stack, player)
		local list = inv:get_list("prize")
		local retval = {}
		for _, stack in pairs(list) do
			retval[#retval + 1] = stack:to_string()
		end
		local data_base = core.serialize(retval)			
        g_runner_logic.storage:set_string("prize" .. g_runner_logic.storage:get_string("prizerank"), data_base)
    end,

    on_take = function(inv, listname, index, stack, player)
		local list = inv:get_list("prize")
		local retval = {}
		for _, stack in pairs(list) do
			retval[#retval + 1] = stack:to_string()
		end
		local data_base = core.serialize(retval)			
        g_runner_logic.storage:set_string("prize" .. g_runner_logic.storage:get_string("prizerank"), data_base)
    end,
})
prizeinv:set_size("prize", 8*1)

-- show the prize-management inventory for a given rank or "over"
local function showprize(player, rank)
	local prizelist = g_runner_logic.storage:get("prize" .. rank)  -- from get_string
	if rank then
		g_runner_logic.storage:set_string("prizerank", rank)
		local inv = core.get_inventory({type="detached", name="g_runner_logic_prizemanage"})
		if prizelist then			
			local list_strings = core.deserialize(prizelist)
			local list = {}
			for _, str in pairs(list_strings) do
				list[#list + 1] = ItemStack(str)
			end		
			inv:set_list("prize", list)
		else
			inv:set_list("prize", {})
		end
		
		local formspec = {
				"size[8,6]"..
				default.gui_bg ..
				default.gui_bg_img ..
				default.gui_slots ..
				"list[detached:g_runner_logic_prizemanage;prize;0,0.3;8,1;]"..
				"list[current_player;main;0,1.85;8,1;]" ..
				"list[current_player;main;0,3.08;8,3;8]" ..
				"listring[detached:g_runner_logic_prizemanage;prize]" ..
				"listring[current_player;main]" ..
				default.get_hotbar_bg(0,1.85)
				}
				
		core.show_formspec(player, "g_runner_logic:prizemanage", table.concat(formspec, ""))
	end
end

-- chatcommand to show prize-management inventory. limit params to numbers and "over"
core.register_chatcommand("prizemanage", {
	params = "<rank> | over",
    description = "Manage the Runner-Game prizes",
	privs = {
        prizemanage = true,
    },
    func = function(name, param)
		if (type(tonumber(param)) == "number") or (param == "over") then
			showprize(name, param)
		else
			core.chat_send_player(name, "Wrong Parameter. Only numbers or \"over\" allowed")
		end
    end,
})