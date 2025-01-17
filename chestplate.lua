-- Black Chestplate

	armor:register_armor(":g_runner_logic:chestplate_black", {
		description = "Black Chestplate",
		inventory_image = "g_runner_logic_inv_chestplate_black.png",
		groups = {armor_torso=1, armor_heal=12, armor_use=300, armor_fire=1},
		armor_groups = {fleshy=20},
		damage_groups = {cracky=2, snappy=1, choppy=1, level=3},
	})