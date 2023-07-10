--[[
	Coded by MrWall
]]

util.show_corner_help("~g~Loaded ~o~ " .. SCRIPT_FILENAME .. " ~p~;)\n~s~Let's farm some ~g~$$$")

function on_stp()
	util.show_corner_help("~r~Unloaded ~o~ " .. SCRIPT_FILENAME .. "\n~s~Thanks for using ~p~:D")
end

util.on_stop(on_stp)

local playerList = players.list(false, true, true)
local notify = false
local delay = 20
local amount = {1000, 2000, 3000, 4000, 5000, 6000, 7000, 8000, 9000}
local randomamount = 10000

--Header
menu.divider(menu.my_root(), " " .. SCRIPT_NAME .. " ")

--Waiting time
menu.slider(menu.my_root(), "Repeat Colldown", {"bdelay"}, "Set the time on how long the script waits to give the next player a bounty (time is in sec)", 10, 300, delay, 5, function(value)
	delay = value
end)

menu.slider(menu.my_root(), "Amount", {}, "Click to apply", 0, 9000, 10000, 1000, function (int)
	randomamount = int
end)

--Random Amount
function random_pay()
	randomamount = amount[math.random(#amount)]
	util.yield(delay * 100)
end

random = menu.toggle(menu.my_root(), "Random payout¿", {}, "Set $ at random or 10k\n\nOverwrites the input above.", function(d)
	if d then
		random_pay()
	else
		randomamount = 10000
	end
end)

--Bounty Toggle
start = menu.toggle_loop(menu.my_root(), "Start", {}, "Will get a random players and give them bounty on set time", function()
	if #playerList > 0 then
		randomPlayer = players.get_name(playerList[math.random(1, #playerList)])
		menu.trigger_commands("bounty"..randomPlayer.." "..randomamount)
		if notify then
			util.show_corner_help("~o~Bounty placed~y~... \n~r~$ ~w~= "..randomamount)
		end
			util.yield(delay * 1000)
	else
		util.show_corner_help("Lobby has ~r~no ~w~other ~o~players.\n\n~w~Consider ~g~joining ~w~a ~g~new one.")
		menu.set_value(start, false)
	end
end)


--Notify
menu.divider(menu.my_root(), "===================")

menu.toggle(menu.my_root(), "Notifications", {}, "By default notifications are turned OFF", function(on)
	if on then
		notify = true
		util.show_corner_help("~p~Notifications ~g~On")
	else
		notify = false
		util.show_corner_help("~p~Notifications ~r~Off")
	end
end)

players.add_command_hook(function(playerID)
	menu.attach_after(menu.ref_by_path("Players>"..players.get_name_with_tags(playerID)..">Trolling>Mugger Loop"), menu.toggle_loop(menu.shadow_root(), "Place Bounty Loop", {}, 'This does NOT collect the bounty.', function()
		if players.exists(playerID) and players.get_bounty(playerID) == nil then
			menu.trigger_commands("bounty"..players.get_name(playerID).." "..randomamount)
			if notify then
				util.show_corner_help("~o~Bounty placed~w~ on ~b~"..players.get_name(playerID).." \n~r~$ ~w~= "..randomamount)
			end
		else
			util.yield(delay * 1000)
		end
	end))
end)

util.keep_running()
