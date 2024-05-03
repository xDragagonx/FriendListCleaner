--Use common.LogInfo("common", "-"..name.."-") --Log to mods.txt
--Use tostring() to concatenate non-string values in chat()
--itemLib.GetName(itemId) gets the name of the itemId. Wrap userMods.FromWString() around it for proper output.
local lootCounter = {}
local lootTrackerInit = 0 --Used as flag to init LootTracker() once per addonload.
function Main()
	

end

function FriendListCleaning(cflInput)
	local friendsDeleted = false
	--Gives unitId of all friends(.GetFriendList()) in friendlist(social.)
	local friends = social.GetFriendList()
	--ChatLog(friends) --Shows all ID's of all players in friendlist.
	for i = 0, GetTableSize( friends ) -1 do
		--Gets the whole list of info you can pull out of friendlist data.
		local friendInfo = social.GetFriendInfo( friends[i] )
		if(friendInfo) then
			local friendName = friendInfo.name
			local friendLastOnline = friendInfo.lastOnlineTimeMs
			--[[ HOW TO FIND SPECIFIC PEOPLE AND STRIPPED VERSION 
				local friendstring = userMods.FromWString(friendName) 
			if(friendstring == "pasidaips")then
				ChatLog(friendstring, offlineSinceToday, friendLastOnline)
			end ]]
			--currentDate is today's date to the milisecond accurate.
			local currentDate = common.GetLocalDateTime()
			--Converts amount of miliseconds to date since last logged in.
			local dateLastLogged = common.GetDateTimeFromMs( friendLastOnline )
			--ChatLog(friendName, dateLastLogged.d, dateLastLogged.m, dateLastLogged.y)
			--Making sure to not delete players that are online (says they are offline since 1970)
			if(friendName and friendLastOnline > 3600000) then
				local yearToMonths = (currentDate.y - dateLastLogged.y) * 12
				local monthsDifference = (currentDate.m - dateLastLogged.m) + 12
				local monthsInCurrentYear = currentDate.m
				local monthsInPreviousYear = 12 - dateLastLogged.m
				--[[ ChatLog("friendName:", friendName)
				ChatLog("monthsInCurrentYear:", monthsInCurrentYear)
				ChatLog("monthsInPreviousYear:", monthsInPreviousYear) ]]
				if((monthsInCurrentYear + monthsInPreviousYear) > cflInput and currentDate.y - dateLastLogged.y == 1 
				or(monthsInCurrentYear + monthsInPreviousYear + yearToMonths) > cflInput and currentDate.y - dateLastLogged.y >= 2) then
					--ChatLog(friendName, dateLastLogged.y, dateLastLogged.m) --Logs all players that get deleted
					--social.RemoveFriend(friendName)
					friendsDeleted = true
					ChatLog(friendName, "has been removed")
					
				end
			end
		end
	end
	if(not friendsDeleted)then
		ChatLog("There were no friends to remove. Try a longer inactivity. Or don't, haha.")	
	end
end
--s is the whole input being /cfl 10. 
--delimiter is where it cuts it. being " ".
function Split(s, delimiter)
local result = {};
	for match in (s..delimiter):gmatch("(.-)"..delimiter) do
		table.insert(result, match);
	end
return result;
end
local waitingForInput = false
local data = {}
function SlashCommand(params)
	local playerText = userMods.FromWString(params.text) 
	local playerSplitTable = Split(playerText, " ")
		--current table has 2 info's,[1] and [2]. One is /cfl and the other is a number.
	if(playerSplitTable[1] == "/cfl")then
		local cflInput = 12
		if(#playerSplitTable == 2)then
				cflInput = tonumber(playerSplitTable[2])
		end
		ChatLog("You select "..tostring(cflInput).." months. Write /ok if you're sure.")
		--ChatLog("You select", cflInput, "months. Write /ok if you're sure.")
		waitingForInput = true
		data["cflInput"] = cflInput	
	elseif (playerText == "/ok" and waitingForInput) then
		FriendListCleaning(data["cflInput"])
		waitingForInput = false
		data = {}
	elseif waitingForInput then
		ChatLog("Unsure what you did. Start over.")
		waitingForInput = false
		data = {}
	end
end

function OnChat(params)
	--common.UnRegisterEvent("EVENT_UNKNOWN_SLASH_COMMAND")
	local inputText = userMods.FromWString(params.text)
	if inputText == "/rcreset" then
		
	end
	if inputText == "/rclist" then
		
		
	end
end

if (avatar.IsExist()) then
	chat(2,"Loaded.")
	Main()
else
	chat(2,"Loaded.")
	common.RegisterEventHandler(Main, "EVENT_AVATAR_CREATED")
end