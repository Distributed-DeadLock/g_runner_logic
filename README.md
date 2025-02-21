# g_runner_logic
 ## Runner Game Core Logic
 -------------

 This luanti/minetest mod adds the logic, nodes & chat-commands for a simple "running"-game.
 
 The goal of this game is to reach the goal-node and punch it.
 
 When you die, your time gets reset and you start a new run.
 
 Every time you reach the goal, you gain a rank and get a prize(prizes need to be configured by the admin).
 
 Your time is recorded in a Highscore-Table, so you can compete on the fastest time.
 
 Admins can advance to a new "Season", which will reset the highscores and all personal times.
 
 -------------
 
 The mod provides 3 non-craftable blocks:
 
 + The Goal Block				-	punch it to end your run.
 + The Prize Chest				-	contains your prizes after you punched the Goal Block.
 + The Digiline Status Block	-	(with digiline-mod installed) returns the Name & Time of a Position in the Highscore-Table
 
 ![The Nodes](screenshots/nodes.png)

--------------

The mod has 4 chat-commands for players & 2 for the admin.

Player-Commands:

+ /mystats 						-	Show your Rank, Best-Time & Last-Time 
+ /highscores					-	Show the Highscore-Table
+ /who							-	Show the Players currently online, their Rank & and Run-Status (if running or finnished)
+ /seasonwinners				-	Show the Winners of previous Seasons

Admin-Commands:

(requires priv "prizemanage")
+ /prizemanage \<number\> | over	-	opens the prize-Inventory for a Rank or the "over"-inventory

Example Usage: `/prizemanage 1` , `/prizemanage 12` or `/prizemanage over`
 
A copy of every item in a prize-Inventory for a Rank will be given to the player when he reaches that Rank.

When there is no Rank-Inventory for a certain Rank, the player instead receives 2 random items from the "over"-inventory.


(requires priv "newseason")
+ /newseason 						-	Start a new Season

A New Season will be started. 
The Top-3 Results of the current season will be stored in the seasonwinner-list. 
The highcore-list and all player times will be reset.
Players need to respawn to join the new season.

------------- 

Digiline Block Usage:

The Block reacts to 
+ GET \<number\>		-	where number is a Highscore-Position (e.g. `GET 1` for the first place) 

it will then respond with a string with `<Highscore-Position>. <Playername> <Best-Time>` or `0` if that position does not exist.

![The Digiline](screenshots/digiline-node.png)

-------------

The mod adds a Black Chestplate if the 3d_armor mod is installed.  
(same armor values as crystal, but with more durability. Not craftable)  

The Black Chestplate will be awarded to players who reach position 1 on the global Highscore-Table.  

-------------  

For this game-mode to make sense, it is required to:  
+ disable teleport-commands for players  
+ disable teleport to home  
+ not have any Teleport-Devices readily availiable to the players  

Suggested to use with this mod:  
+ all interesting vehicle mods  
+ all monster mods  
+ any funny or dangerous biome  
+ my own "respawn-kit"-mod  

-------------  

API ?:
To get notified if a player ends(or tries to) his run by punching the goal,  
hook g_runner_logic.on_run_finish(playername, finished, personalbest, globalbest).  
+ cache the original function  
+ overwrite g_runner_logic.on_run_finish with your own function  
+ call the cached original function at the end of your function  
finished will be true if a run was finished with this punch.  
personalbest will be true if player set a personal Best-Time.   
globalbest will be true if player set a global Best-Time.  
  
  
g_runner_logic.highscore contains the current highscorelist.  
g_runner_logic.seasonscore contains the all-seasons best times list.  
g_runner_logic.season contains the current season nr.  

each player now has the following player-metas set:  
"g_runner_logic:rank"  
"g_runner_logic:starttime"  
"g_runner_logic:lasttime"  
"g_runner_logic:besttime"  
"g_runner_logic:season"  

-------------  

**License**: Code: MIT , Textures: CC0  

**Mod dependencies**: default  

**optional Mod dependencies**: digilines, 3d_armor  

**Thanks**:  

My Knowledge about how to expand the player-inventory & how to interact with digilines is based on parts of :  

https://github.com/MeseCraft/void_chest by MeseCraft &  

https://github.com/Darin755/minetest-uptime-stats by Darin755   

**Author**: DeadLock  