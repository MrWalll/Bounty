--coded by *MrWall 

util.require_natives(1640181023)

util.show_corner_help("~s~Loaded ~o~ " .. SCRIPT_FILENAME .. " ~p~;)\n~s~Let's farm some ~g~$$$")

function on_stp()
	util.show_corner_help("~r~Unloaded ~o~ " .. SCRIPT_FILENAME .. "\n~s~Thanks for using ~p~:D")
end

util.on_stop(on_stp)

local playerList = players.list(false, true, true)
local notify = false
local amount = {1000, 2000, 3000, 4000, 5000, 6000, 7000, 8000, 9000}
local randomamount = 10000

--Header
menu.divider(menu.my_root(), " " .. SCRIPT_NAME .. " ")

--Waiting time
delay = 20
menu.slider(menu.my_root(), "Repeat Colldown", {"bdelay"}, "Set the time on how long the script waits to give the next player a bounty (time is in sec)", 10, 300, delay, 5, function(value)
	delay = value
end)

menu.text_input(menu.my_root(), "Amount", {"bountyamount"}, "Choose a NUMBER not bigger than 10k to be set, as bounty, on random players.", function (int)
	randomamount = int
end)

--Random Amount
function random_pay()
	if type(randomamount) == "string" then randomamount = 1 end
	while randomamount <= 10000  do
		randomamount = amount[math.random(#amount)]
		util.yield(delay * 100)
	end
	return randomamount
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
			if not util.BEGIN_TEXT_COMMAND_IS_THIS_HELP_MESSAGE_BEING_DISPLAYED("~p~Notifications ~g~On") then
				util.show_corner_help("~o~Bounty placed~y~... \n~r~$ ~w~= "..randomamount)
			end
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

menu.action(menu.my_root(), "Reset amount", {}, "", function ()
	randomamount = 10000
	if menu.get_value(start) then
		menu.set_value(start, false)
		util.yield(800)
		menu.set_value(start, true)
	end
	if menu.get_value(random) then menu.set_value(random, false) end
end)


util.keep_running()

--* MrWall == Heykeyo#0191
