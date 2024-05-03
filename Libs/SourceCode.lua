--Use common.LogInfo("common", "-"..name.."-") --Log to mods.txt
--Use tostring() to concatenate non-string values in chat()
--itemLib.GetName(itemId) gets the name of the itemId. Wrap userMods.FromWString() around it for proper output.
local lootCounter = {}
function Main()
	
	--common.RegisterEventHandler(OnChat, "EVENT_UNKNOWN_SLASH_COMMAND")
	--common.RegisterEventHandler(EVENT_LOOT_DISTRIBUTION_STARTED, "EVENT_LOOT_DISTRIBUTION_STARTED")

	common.RegisterEventHandler(EVENT_LOOT_TO_DISTRIBUTE, "EVENT_LOOT_TO_DISTRIBUTE")

	--common.RegisterEventHandler(EVENT_RAID_LOOT_MASTER_CHANGED , "EVENT_RAID_LOOT_MASTER_CHANGED")
	-- ITEM_QUALITY_JUNK | poor
	-- ITEM_QUALITY_GOODS | common
	-- ITEM_QUALITY_COMMON | uncommon
	-- ITEM_QUALITY_UNCOMMON | rare
	-- ITEM_QUALITY_RARE | epic
	-- ITEM_QUALITY_EPIC | legendary
	-- ITEM_QUALITY_LEGENDARY | fabled
	-- ITEM_QUALITY_RELIC | relic
	-- ITEM_QUALITY_DRAGON | dragon
	--local quality = ITEM_QUALITY_DRAGON
	--chat(2, loot.SetMinItemQualityForLootScheme( quality ))
    --loot.SetMinItemQualityForLootScheme( quality )
	
	-- LOOT_SCHEME_TYPE_FREE_FOR_ALL
	-- LOOT_SCHEME_TYPE_MASTER
	-- LOOT_SCHEME_TYPE_GROUP
	--local scheme = LOOT_SCHEME_TYPE_MASTER
	
	
end
function EVENT_LOOT_DISTRIBUTION_STARTED(params)
	chat(2, params.itemObject)
end

function EVENT_LOOT_TO_DISTRIBUTE(params)
	local rollId = params.rollId
	local itemId = params.itemId
	local itemIdName = userMods.FromWString(itemLib.GetName(itemId))
	local looters = params.looters
	chat(2, "rollId:",rollId)
	chat(2, "itemId:",itemId )
	chat(2, "itemIdName:",itemIdName)
	common.LogInfo("common", "-"..itemIdName.."-") --Log to mods.txt
	--locales["itemName"]
	chat(2, "looters:",looters)

	if itemIdName == locales["KOErelic"] then
		chat(2, "the itemname is KOE relic, going into LowestLoot()")
		loot.SelectWinnerForLoot( rollId, looters[LowestLoot()] )
		chat(2, LowestLoot())
		LootCounterAdd()
	else
		chat(2, "false")
	end
	chat(1, "I gave",rollId,"to",looters[0])
end

function LowestLoot()
	LootTracker()
	chat(2, "entering lowestLoot() function)")
	local lowestNumber = math.huge
	local playerWithLowestNumber = nil
	local playerWithLowestNumberIndex = nil

	for i = 0, #lootCounter do
		local player = lootCounter[i]
		if player.number < lowestNumber then
			lowestNumber = player.number
			playerWithLowestNumber = player.playername
			playerWithLowestNumberIndex = i
		end
	end
	chat(2, "player with lowest number is:",playerWithLowestNumber,"having",lowestNumber)
	return playerWithLowestNumberIndex
end

function LootTracker()
	local members = group.GetMembers()
	
	for i = 0, #members do
		lootCounter[i] = {playername = userMods.FromWString(members[i].name), number = 0}
	end

	--lootCounter[0][2] = 2 lootcounter is 2nd table, value is loot amount IMPORTANT 2nd table indexes from 1, 1st table indexes from 0
	--lootCounter[0]["number"] = 2

	chat(2, "init party loot info:",lootCounter)
end

function LootCounterAdd()
	lootCounter[LowestLoot()]["number"] = lootCounter[LowestLoot()]["number"] + 1
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