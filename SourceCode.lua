function Main()
	common.RegisterEventHandler(EVENT_UNKNOWN_SLASH_COMMAND, "EVENT_UNKNOWN_SLASH_COMMAND")
end
function FriendListCleaning(cflInput)
	local friendsDeleted = false
	local friends = social.GetFriendList() --Gives unitId of all friends(.GetFriendList()) in friendlist(social.)
	--chat(2, friends) --Shows all ID's of all players in friendlist.

	for i = 0, GetTableSize( friends ) -1 do
		--Gets the whole list of info you can pull out of friendlist data.
		local friendInfo = social.GetFriendInfo( friends[i] )
		if(friendInfo) then
			local friendName = userMods.FromWString(friendInfo.name)
			local friendLastOnline = friendInfo.lastOnlineTimeMs
			--[[ HOW TO FIND SPECIFIC PEOPLE AND STRIPPED VERSION 
				local friendstring = userMods.FromWString(friendName)
			if(friendstring == "pasidaips")then
				chat(2, friendstring, offlineSinceToday, friendLastOnline)
			end ]]
			--currentDate is today's date to the milisecond accurate.
			local currentDate = common.GetLocalDateTime()
			--Converts amount of miliseconds to date since last logged in.
			local dateLastLogged = common.GetDateTimeFromMs( friendLastOnline )
			--chat(2, friendName, dateLastLogged.d, dateLastLogged.m, dateLastLogged.y)
			--Making sure to not delete players that are online (says they are offline since 1970)
			if(friendName and friendLastOnline > 3600000) then
				local yearToMonths = (currentDate.y - dateLastLogged.y) * 12
				local monthsDifference = (currentDate.m - dateLastLogged.m) + 12
				local monthsInCurrentYear = currentDate.m
				local monthsInPreviousYear = 12 - dateLastLogged.m
				-- chat(2, "friendName:", friendName)
				-- chat(2, "monthsInCurrentYear:", monthsInCurrentYear)
				-- chat(2, "monthsInPreviousYear:", monthsInPreviousYear)
				if((monthsInCurrentYear + monthsInPreviousYear) > cflInput and currentDate.y - dateLastLogged.y == 1 
				or(monthsInCurrentYear + monthsInPreviousYear + yearToMonths) > cflInput and currentDate.y - dateLastLogged.y >= 2) then
					chat(2, friendName,"last online:",dateLastLogged.d.."/"..dateLastLogged.m.."/"..dateLastLogged.y) --Logs all players that get deleted
					social.RemoveFriend(userMods.ToWString(friendName))
					friendsDeleted = true
				end
			end
		end
	end
	if(not friendsDeleted)then
		chat(2, "There were no friends to remove. Try a longer inactivity. Or don't, haha.")	
	end
end
-- s is the whole input being /cfl 10. 
-- delimiter is where it cuts it. being " ".
function Split(s, delimiter)
	local result = {}
	for match in (s..delimiter):gmatch("(.-)"..delimiter) do
		table.insert(result, match);
	end
	return result;
end
local waitingForInput = false
local data = {}
function EVENT_UNKNOWN_SLASH_COMMAND(params)
	local playerText = userMods.FromWString(params.text)
	local playerSplitTable = Split(playerText, " ")
		--current table has 2 info's,[1] and [2]. One is /cfl and the other is a number.
	if (playerSplitTable[1] == "/cfl") then
		local cflInput = 12
		if (#playerSplitTable == 2) then
				cflInput = tonumber(playerSplitTable[2])
		end
		chat(2, "You select "..tostring(cflInput).." month(s). Write /y if you're sure.")
		--chat(2, "You select", cflInput, "months. Write /ok if you're sure.")
		waitingForInput = true
		data["cflInput"] = cflInput
	elseif (playerText == "/y" and waitingForInput) then
		FriendListCleaning(data["cflInput"])
		waitingForInput = false
		data = {}
	elseif waitingForInput then
		chat(2, "Unsure what you did. Start over.")
		waitingForInput = false
		data = {}
	end
end

if (avatar.IsExist()) then
	chat(2,"Loaded.")
	Main()
else
	chat(2,"Loaded.")
	common.RegisterEventHandler(Main, "EVENT_AVATAR_CREATED")
end