-- T.H HUB UI-only skeleton: original automation/game logic removed.
-- UI controls are retained; callbacks are intentionally empty.
repeat task.wait() until game:IsLoaded() and game.Players.LocalPlayer
local A = loadstring(game:HttpGet("https://raw.githubusercontent.com/obiiyeuem/vthangsitink/refs/heads/main/zzzz.lua"))()
Main = A.CreateMain({ Title = "Blox Fruit", Desc = " - Blox Fruit" })
PageShop = Main.CreatePage({ Page_Name = "Shop", Page_Title = "Shop" })
SectionShopMisc = PageShop.CreateSection("Misc Shop")
SectionShopMisc.CreateButton({ Title = "Redeem Code" }, function(...) end)
SectionShopMisc.CreateButton({ Title = "Teleport Old World" }, function(...) end)
SectionShopMisc.CreateButton({ Title = "Teleport New World" }, function(...) end)
SectionShopMisc.CreateButton({ Title = "Teleport Thid Sea" }, function(...) end)
SectionShopMisc.CreateButton({ Title = "Buy Dual Flintlock" }, function(...) end)
SectionShopMisc.CreateButton({ Title = "Reroll Race" }, function(...) end)
SectionShopMisc.CreateButton({ Title = "Reset Stats" }, function(...) end)
SectionShopMisc.CreateButton({ Title = "Buy Race Cyborg" }, function(...) end)
SectionShopMisc.CreateButton({ Title = "Buy Race Ghoul" }, function(...) end)
SectionShopFighting = PageShop.CreateSection("Fighting Shop")
SectionShopFighting.CreateToggle({ Title = "Black Leg", Desc = nil, Default = false }, function(...) end)
SectionShopFighting.CreateToggle({ Title = "Fishman Karate", Desc = nil, Default = false }, function(...) end)
SectionShopFighting.CreateToggle({ Title = "Electro", Desc = nil, Default = false }, function(...) end)
SectionShopFighting.CreateToggle({ Title = "Dragon Breath", Desc = nil, Default = false }, function(...) end)
SectionShopFighting.CreateToggle({ Title = "SuperHuman", Desc = nil, Default = false }, function(...) end)
SectionShopFighting.CreateToggle({ Title = "Death Step", Desc = nil, Default = false }, function(...) end)
SectionShopFighting.CreateToggle({ Title = "Sharkman Karate", Desc = nil, Default = false }, function(...) end)
SectionShopFighting.CreateToggle({ Title = "Electric Claw", Desc = nil, Default = false }, function(...) end)
SectionShopFighting.CreateToggle({ Title = "Dragon Talon", Desc = nil, Default = false }, function(...) end)
SectionShopFighting.CreateToggle({ Title = "God Human", Desc = nil, Default = false }, function(...) end)
SectionShopFighting.CreateToggle({ Title = "Sanguine Art", Desc = nil, Default = false }, function(...) end)
SectionShopAbilities = PageShop.CreateSection("Abilities Shop")
SectionShopAbilities.CreateButton({ Title = "Skyjump [ $10,000 Beli ]" }, function(...) end)
SectionShopAbilities.CreateButton({ Title = "Buso Haki [ $25,000 Beli ]" }, function(...) end)
SectionShopAbilities.CreateButton({ Title = "Observation haki [ $750,000 Beli ]" }, function(...) end)
SectionShopAbilities.CreateButton({ Title = "Soru [ $100,000 Beli ]" }, function(...) end)
PageStatusAndServer = Main.CreatePage({ Page_Name = "Status And Server", Page_Title = "Status And Server" })
local SectionStatusUI = PageStatusAndServer.CreateSection("T.H HUB Status UI")
SectionStatusUI.CreateToggle({
		Title = "Show T.H HUB Status UI",
		Desc = "Show what the script is doing at the top of the screen",
		Default = Settings[UI_KEY] ~= false,
	}, function(...) end)
SectionStatus = PageStatusAndServer.CreateSection("Status")
TimerLabel = SectionStatus.CreateLabel({ Title = "Timer" })
TimerServerLabel = SectionStatus.CreateLabel({ Title = "Timer Server" })
NextTimerServerLabel = SectionStatus.CreateLabel({ Title = "Next Time Spawn Fist of Darkness or God's Chalice" })
StatusEliteHunter = SectionStatus.CreateLabel({ Title = "Elite" })
StatusTyrant = SectionStatus.CreateLabel({ Title = "Eyes Summon Tyrant" })
StatusKatakuri = SectionStatus.CreateLabel({ Title = "Summon Katakuri" })
Statusspy = SectionStatus.CreateLabel({ Title = "Status SPY" })
StatusMirage = SectionStatus.CreateLabel({ Title = "Mirage" })
StatusPrehistoricIsland = SectionStatus.CreateLabel({ Title = "Prehistoric Island" })
StatusFrozenDimension = SectionStatus.CreateLabel({ Title = "Frozen Dimension" })
StatusMoon = SectionStatus.CreateLabel({ Title = "Moon" })
StatusGear = SectionStatus.CreateLabel({ Title = "Acient One Status" })
SectionServer = PageStatusAndServer.CreateSection("Server")
SectionServer.CreateButton({ Title = "Open Gui Server Browser (Low Player and Ping)" }, function(...) end)
StatusPlaceId = SectionServer.CreateLabel({ Title = "PlaceId: " .. game.PlaceId })
SectionServer.CreateToggle({ Title = "Spam Join", Desc = nil, Default = Settings["Spam Join"] or false }, function(...) end)
SectionServer.CreateButton({ Title = "Join JobId" }, function(...) end)
SectionServer.CreateButton({ Title = "Copy JobId" }, function(...) end)
SectionServer.CreateButton({ Title = "Hop Server" }, function(...) end)
SectionServer.CreateButton({ Title = "Hop Server Less People" }, function(...) end)
LocalPlayerMain = Main.CreatePage({ Page_Name = "LocalPlayer", Page_Title = "LocalPlayer" })
SectionLocalPlayerMain = LocalPlayerMain.CreateSection("Local Player")
SectionLocalPlayerMain.CreateToggle({
		Title = "Auto Translate",
		Desc = "It may take a bit longer to translate the first time.",
		Default = Settings["Auto Translate"] or false,
	}, function(...) end)
SectionLocalPlayerMain.CreateButton({ Title = "Stop Tween" }, function(...) end)
SectionLocalPlayerMain.CreateButton({ Title = "Fix UI Button Game" }, function(...) end)
SectionLocalPlayerMain.CreateButton({ Title = "Load config in Web" }, function(...) end)
SectionLocalPlayerMain.CreateButton({ Title = "Push Data To Web ( just push when join game,if push again plz rejoin )" }, function(...) end)
SectionLocalPlayerMain.CreateButton({ Title = "Show Item" }, function(...) end)
SectionLocalPlayerMain.CreateButton({ Title = "Open Devil Fruit Shop" }, function(...) end)
SectionLocalPlayerMain.CreateButton({ Title = "Open Devil Fruit Shop Mirage" }, function(...) end)
SectionLocalPlayerMain.CreateButton({ Title = "Open Title" }, function(...) end)
SectionLocalPlayerMain.CreateButton({ Title = "Open Color" }, function(...) end)
SectionLocalPlayerMain.CreateDropdown({
		Title = "Select Stats",
		List = PrepareMultiSelectList(
			{ Melee = false, Defense = false, Sword = false, Gun = false, ["Demon Fruit"] = false },
			Settings["Select Stats"]
		),
		Search = true,
		Selected = true,
		Default = Settings["Select Stats"] or nil,
	}, function(...) end)
SectionLocalPlayerMain.CreateToggle({ Title = "Auto Stats", Desc = nil, Default = Settings["Auto Stats"] or false }, function(...) end)
SectionLocalPlayerMain.CreateDropdown({
		Title = "Select Team",
		List = { "Pirate", "Marine" },
		Search = true,
		Selected = false,
		Default = Settings["Select Team"] or nil,
	}, function(...) end)
SectionLocalPlayerMain.CreateDropdown({ Title = "Change Team", List = { "Pirates", "Marines" }, Search = true, Selected = false, Default = nil }, function(...) end)
SectionLocalPlayerMain.CreateToggle({ Title = "Noclip", Desc = nil, Default = Settings.Noclip or false }, function(...) end)
SectionLocalPlayerMain.CreateDropdown({ Title = "Select Npc", List = R, Search = true, Selected = false, Default = nil }, function(...) end)
SectionLocalPlayerMain.CreateToggle({ Title = "Teleport To Npc", Desc = nil, Default = false }, function(...) end)
SectionLocalPlayerMain.CreateDropdown({ Title = "Select Island", List = b, Search = true, Selected = false, Default = nil }, function(...) end)
SectionLocalPlayerMain.CreateToggle({ Title = "Teleport To Island", Desc = nil, Default = false }, function(...) end)
SectionLocalPlayerMain.CreateToggle({ Title = "Teleport Mirage", Desc = nil, Default = false }, function(...) end)
SectionLocalPlayerMain.CreateToggle({ Title = "Teleport Prehistoric Island", Desc = nil, Default = false }, function(...) end)
SettingFarmMain = Main.CreatePage({ Page_Name = "Setting Farm", Page_Title = "Setting Farm" })
SettingFarmMainSection = SettingFarmMain.CreateSection("Setting Farm")
SettingFarmMainSection.CreateDropdown({
			Title = "Select Weapon",
			List = { "Melee", "Sword", "Blox Fruit" },
			Search = true,
			Selected = false,
			Default = Settings["Select Weapon"] or nil,
		}, function(...) end)
SettingFarmMainSection.CreateToggle({ Title = "Attack No Animation ", Desc = nil, Default = Settings["Attack No Animation "] or true }, function(...) end)
SettingFarmMainSection.CreateToggle({
		Title = "Kill Aura Only Raid And Volcano",
		Desc = nil,
		Default = Settings["Kill Aura Only Raid And Volcano"] or false,
	}, function(...) end)
SettingFarmMainSection.CreateSlider({ Title = "Time Delay Kill", Min = 0, Max = 5, Default = Settings["Time Delay Kill"] or 5, Precise = true }, function(...) end)
SettingFarmMainSection.CreateToggle({ Title = "Auto Click", Desc = nil, Default = Settings["Auto Click"] or false }, function(...) end)
SettingFarmMainSection.CreateToggle({ Title = "Kill Aura With DragonStorm", Desc = nil, Default = Settings["Kill Aura With DragonStorm"] or false }, function(...) end)
SettingFarmMainSection.CreateToggle({ Title = "Auto Turn On Buso", Desc = nil, Default = Settings["Auto Turn On Buso"] or true }, function(...) end)
SettingFarmMainSection.CreateToggle({ Title = "Auto Turn On Observation", Desc = nil, Default = Settings["Auto Turn On Observation"] or false }, function(...) end)
local m = SettingFarmMainSection.CreateToggle({ Title = "Auto Turn On V4", Desc = nil, Default = Settings["Auto Turn On V4"] or false }, function(...) end)
SettingFarmMainSection.CreateToggle({ Title = "Auto Turn On V3", Desc = nil, Default = Settings["Auto Turn On V3"] or false }, function(...) end)
SettingFarmMainSection.CreateToggle({ Title = "Auto Dodge Skill Mobs", Desc = nil, Default = Settings["Auto Dodge Skill Mobs"] or false }, function(...) end)
SettingFarmMainSection.CreateToggle({ Title = "Teleport Y if low health", Desc = nil, Default = Settings["Teleport Y"] or false }, function(...) end)
SettingFarmMainSection.CreateSlider({ Title = "% Health Player", Min = 0, Max = 100, Default = Settings["% Health Player"] or 40, Precise = true }, function(...) end)
SettingFarmMainSection.CreateSlider({
		Title = "Distance Teleport Y",
		Min = 0,
		Max = 10000,
		Default = Settings["Distance Teleport Y"] or 800,
		Precise = true,
	}, function(...) end)
SettingFarmMainSection.CreateToggle({ Title = "Tween Safe if have Items", Desc = nil, Default = Settings["Tween Safe if have Items"] or false }, function(...) end)
SettingFarmMainSection.CreateSlider({ Title = "Time Hop Server", Min = 0, Max = 60, Default = Settings["Time Hop Server"] or 10, Precise = true }, function(...) end)
SettingFarmMainSection.CreateToggle({ Title = "Use Portal Teleport", Desc = nil, Default = Settings["Use Portal Teleport"] or false }, function(...) end)
SettingFarmMainSection.CreateSlider({ Title = "Bring Mob Count", Min = 2, Max = 6, Default = Settings["Bring Mob Count"] or 2, Precise = true }, function(...) end)
SettingFarmMainSection.CreateToggle({ Title = "Bring Mob", Desc = nil, Default = Settings["Bring Mob"] or true }, function(...) end)
SettingFarmMainSection.CreateToggle({ Title = "Reset Teleport [ Beta ]", Desc = nil, Default = Settings["Reset Teleport"] or false }, function(...) end)
SettingFarmMainSection.CreateToggle({ Title = "Use Submarine Teleport", Desc = nil, Default = Settings["Use Submarine Teleport"] or false }, function(...) end)
SettingFarmMainSection.CreateSlider({ Title = "Speed Tween ", Min = 0, Max = 1000, Default = Settings["Speed Tween "] or 300, Precise = true }, function(...) end)
SettingFarmMainSection.CreateLabel({
	Title = "Recommended: 350. If you\226\128\153re farming spots close to each other, use a higher speed",
})
Main.CreatePage({ Page_Name = "Hold and Select Skill", Page_Title = "Setting Hold and Select Skill" })
SelectSkillsSection = SettingSkillMain.CreateSection("Select Skills")
SelectSkillsSection.CreateDropdown({ Title = V, List = _, Search = true, Selected = true, Default = Settings[V] or nil }, function(...) end)
HoldSkillsSection = SettingSkillMain.CreateSection("Hold Skills")
HoldSkillsSection.CreateDropdown({ Title = "Set Delay " .. o, List = N, Slider = true }, function(...) end)
HoldSkillsSection.CreateToggle({ Title = "Use skill fast dont hold", Desc = nil, Default = Settings["Use skill fast dont hold"] or false }, function(...) end)
FarmMain = Main.CreatePage({ Page_Name = "Farming", Page_Title = "Farming" })
SettingAutoFarmSection = FarmMain.CreateSection("Setting Farm")
SettingAutoFarmSection.CreateDropdown({
		Title = "Select Method Farm",
		List = { "Level Farm", "Farm Bones", "Farm Katakuri", "Farm Tyrant of the Skies", "Aura Farm" },
		Search = false,
		Selected = false,
		Default = Settings["Select Method Farm"] or nil,
	}, function(...) end)
SettingAutoFarmSection.CreateSlider({
		Title = "Distance Farm Aura",
		Min = 0,
		Max = 1000,
		Default = Settings["Distance Farm Aura"] or 300,
		Precise = true,
	}, function(...) end)
SettingAutoFarmSection.CreateToggle({ Title = "Ignore Attack Katakuri", Desc = nil, Default = Settings["Ignore Attack Katakuri"] or false }, function(...) end)
SettingAutoFarmSection.CreateToggle({ Title = "Hop Find Katakuri", Desc = nil, Default = Settings["Hop Find Katakuri"] or false }, function(...) end)
SettingAutoFarmSection.CreateToggle({
		Title = "Auto Quest [Katakuri/Bone/Tyrant]",
		Desc = nil,
		Default = Settings["Auto Quest [Katakuri/Bone/Tyrant]"] or false,
	}, function(...) end)
local o = SettingAutoFarmSection.CreateToggle({ Title = "Start Farm", Desc = nil, Default = Settings["Start Farm"] or false }, function(...) end)
MasteryFarmSection = FarmMain.CreateSection("Mastery Farm")
MasteryFarmSection.CreateDropdown({
		Title = "Select Method Farm Mastery",
		List = { "Blox Fruit", "Gun" },
		Search = true,
		Selected = false,
		Default = Settings["Select Method Farm Mastery"] or nil,
	}, function(...) end)
MasteryFarmSection.CreateSlider({ Title = "Health %", Min = 0, Max = 100, Default = Settings["Health %"] or 40, Precise = true }, function(...) end)
MasteryFarmSection.CreateToggle({ Title = "Farm Mastery", Desc = nil, Default = Settings["Farm Mastery"] or false }, function(...) end)
FarmingMaterialSection = FarmMain.CreateSection("Farming Material")
FarmingMaterialSection.CreateDropdown({
		Title = "Select Material",
		List = TableMaterials,
		Search = true,
		Selected = false,
		Default = Settings["Select Material"] or nil,
	}, function(...) end)
FarmingMaterialSection.CreateToggle({ Title = "Farm Material", Desc = nil, Default = Settings["Farm Material"] or false }, function(...) end)
stackFarmMain = Main.CreatePage({ Page_Name = "Stack Farming", Page_Title = "Stack Farming" })
AutoWorldSection = stackFarmMain.CreateSection("Auto World")
AutoWorldSection.CreateToggle({ Title = "Auto New World", Desc = nil, Default = Settings["Auto New World"] or false }, function(...) end)
AutoWorldSection.CreateToggle({ Title = "Auto Third World", Desc = nil, Default = Settings["Auto Third World"] or false }, function(...) end)
StackDevilFruitSection = stackFarmMain.CreateSection("Devil Fruit")
StackDevilFruitSection.CreateToggle({
		Title = "Collect Chest When Server Spawn\10God's Chalice or Fist of Darkness",
		Desc = nil,
		Default = Settings["Collect Chest When Server Spawn God's Chalice or Fist of Darkness"] or false,
	}, function(...) end)
StackDevilFruitSection.CreateToggle({ Title = "Teleport To Fruit", Desc = nil, Default = Settings["Teleport To Fruit"] or false }, function(...) end)
StackDevilFruitSection.CreateToggle({
		Title = "Teleport To Fruit [ Hop Server ]",
		Desc = nil,
		Default = Settings["Teleport To Fruit [ Hop Server ]"] or false,
	}, function(...) end)
EventGameSection = stackFarmMain.CreateSection("Event Game")
EventGameSection.CreateToggle({ Title = "Auto Factory", Desc = nil, Default = Settings["Auto Factory"] or false }, function(...) end)
EventGameSection.CreateToggle({ Title = "Auto Pirate Raid", Desc = nil, Default = Settings["Auto Pirate Raid"] or false }, function(...) end)
BossRipIndraSection = stackFarmMain.CreateSection("Boss Rip Indra")
BossRipIndraSection.CreateToggle({ Title = "Auto Elite Hunter", Desc = nil, Default = Settings["Auto Elite Hunter"] or false }, function(...) end)
BossRipIndraSection.CreateToggle({
		Title = 'Hop Server Elite Hunter"',
		Desc = "Hop if u have God chalice and teleport in safezone",
		Default = Settings["Hop Server Elite Hunter"] or false,
	}, function(...) end)
BossRipIndraSection.CreateToggle({ Title = "Auto Touch Pad Haki", Desc = nil, Default = Settings["Auto Touch Pad Haki"] or false }, function(...) end)
BossRipIndraSection.CreateToggle({ Title = "Auto Summon Rip Indra", Desc = nil, Default = Settings["Auto Summon Rip Indra"] or false }, function(...) end)
BossRipIndraSection.CreateToggle({ Title = "Attack Rip Indra", Desc = nil, Default = Settings["Attack Rip Indra"] or false }, function(...) end)
BossSoulReaperSection = stackFarmMain.CreateSection("Boss Soul Reaper")
BossSoulReaperSection.CreateToggle({ Title = "Attack Soul Reaper", Desc = nil, Default = Settings["Attack Soul Reaper"] or false }, function(...) end)
BossSoulReaperSection.CreateToggle({ Title = "Summon Soul Reaper", Desc = nil, Default = Settings["Summon Soul Reaper"] or false }, function(...) end)
BossDoughKingSection = stackFarmMain.CreateSection("Boss Dough King")
BossDoughKingSection.CreateToggle({ Title = "Attack Dough King", Desc = nil, Default = Settings["Attack Dough King"] or false }, function(...) end)
BossDoughKingSection.CreateToggle({ Title = "Summon Dough King", Desc = nil, Default = Settings["Summon Dough King"] or false }, function(...) end)
BossDoughKingSection.CreateToggle({ Title = "Hop Find Dough King", Desc = nil, Default = Settings["Hop Find Dough King"] or false }, function(...) end)
BossDarkbeardSection = stackFarmMain.CreateSection("Boss Darkbeard")
BossDarkbeardSection.CreateToggle({ Title = "Attack Darkbeard", Desc = nil, Default = Settings["Attack Darkbeard"] or false }, function(...) end)
BossDarkbeardSection.CreateToggle({ Title = "Summon Darkbeard", Desc = nil, Default = Settings["Summon Darkbeard"] or false }, function(...) end)
BossDarkbeardSection.CreateToggle({ Title = "Hop Find Darkbeard", Desc = nil, Default = Settings["Hop Find Darkbeard"] or false }, function(...) end)
FarmotherMain = Main.CreatePage({ Page_Name = "Farming Other", Page_Title = "Farming Other" })
HiddenEventSection = FarmotherMain.CreateSection("Secret Quest")
StatusHiddenProgress = HiddenEventSection.CreateLabel({ Title = "Secret Quest : 0/39 Quests" })
StatusHiddenQuest = HiddenEventSection.CreateLabel({ Title = "Title Quest : ..." })
StatusHiddenStep = HiddenEventSection.CreateLabel({ Title = "Doing Quest : None" })
StatusHiddenBoss = HiddenEventSection.CreateLabel({ Title = "Title Awakened Boss : None" })
HiddenEventSection.CreateToggle({
	Title = "Hop Server For Secret Quest",
	Desc = "Hop khi không có quest / giờ chết",
	Default = Settings["Hop Server For Secret Quest"] or false,
}, function(...) end)
HiddenEventSection.CreateToggle({
	Title = "Auto Secret Quest",
	Desc = "Auto complete 39 Sea 1 secret quests (Hidden Event)",
	Default = Settings["Auto Secret Quest"] or false,
}, function(...) end)
FishingSection = FarmotherMain.CreateSection("Fishing")
FishingSection.CreateToggle({ Title = "Change Size Reel", Desc = nil, Default = Settings["Change Size Reel"] or false }, function(...) end)
FishingSection.CreateToggle({
		Title = "Auto Slap Battle",
		Desc = "There\226\128\153s still a chance of a misclick",
		Default = Settings["Auto Slap Battle"] or false,
	}, function(...) end)
LocalPositionPlantSeed = FishingSection.CreateLabel({ Title = R })
FishingSection.CreateButton({ Title = "Save Position Fishing" }, function(...) end)
FishingSection.CreateDropdown({ Title = "Select Bait", List = a, Search = true, Selected = false, Default = Settings["Select Bait"] or nil }, function(...) end)
StatusFishingLabel = FishingSection.CreateLabel({ Title = "Status Fishing :" })
FishingSection.CreateToggle({
		Title = "Auto Tween To Event Fishing Spot",
		Desc = nil,
		Default = Settings["Auto Tween To Event Fishing Spot"] or false,
	}, function(...) end)
FishingSection.CreateToggle({ Title = "Auto Fishing", Desc = nil, Default = Settings["Auto Fishing"] or false }, function(...) end)
FishingSection.CreateToggle({ Title = "Auto Sell Fishing", Desc = nil, Default = Settings["Auto Sell Fishing"] or false }, function(...) end)
FishingSection.CreateToggle({ Title = "Auto Open Chest", Desc = nil, Default = Settings["Auto Open Chest"] or false }, function(...) end)
FishingSection.CreateDropdown({
		Title = "Select Quest Fishing",
		List = PrepareMultiSelectList(_, Settings["Select Quest Fishing"]),
		Search = true,
		Selected = true,
		Default = Settings["Select Quest Fishing"] or nil,
	}, function(...) end)
FishingSection.CreateToggle({ Title = "Auto Accept Quest Fishing", Desc = nil, Default = Settings["Auto Accept Quest Fishing"] or false }, function(...) end)
QuestDragonSection = FarmotherMain.CreateSection("Quest Dragon")
AttackAllMobSection = FarmotherMain.CreateSection("Attack All Mobs")
AttackAllMobSection.CreateToggle({ Title = "Auto Attack All Mob and Boss", Desc = nil, Default = Settings["Auto Attack All Mob and Boss"] or false }, function(...) end)
QuestDragonSection.CreateToggle({ Title = "Auto Quest Dojo Trainer", Desc = nil, Default = Settings["Auto Quest Dojo Trainer"] or false }, function(...) end)
QuestDragonSection.CreateToggle({ Title = "Auto Quest Dragon Hunter", Desc = nil, Default = Settings["Auto Quest Dragon Hunter"] or false }, function(...) end)
BerrySection = FarmotherMain.CreateSection("Berry")
BerrySection.CreateToggle({ Title = "Hop Find Berry", Desc = nil, Default = Settings["Hop Find Berry"] or false }, function(...) end)
BerrySection.CreateToggle({ Title = "Auto Collect Berry", Desc = nil, Default = Settings["Auto Collect Berry"] or false }, function(...) end)
FarmChestSection = FarmotherMain.CreateSection("Farm Chest")
FarmChestSection.CreateSlider({
		Title = "Value Collect Chest to Hop",
		Min = 0,
		Max = 100,
		Default = Settings["Value Collect Chest to Hop"] or 20,
		Precise = true,
	}, function(...) end)
FarmChestSection.CreateToggle({ Title = "Auto Chest Hop", Desc = nil, Default = Settings["Auto Chest Hop"] or false }, function(...) end)
FarmChestSection.CreateToggle({ Title = "Use Method Teleport [ Risk ]", Desc = nil, Default = Settings["Use Method Teleport"] or false }, function(...) end)
FarmChestSection.CreateToggle({ Title = "Auto Chest", Desc = nil, Default = Settings["Auto Chest"] or false }, function(...) end)
RaidLawSection = FarmotherMain.CreateSection("Raid Law")
RaidLawSection.CreateToggle({ Title = "Auto Buy Chip and Attack Law", Desc = nil, Default = Settings["Auto Buy Chip and Attack Law"] or false }, function(...) end)
FarmObservationSection = FarmotherMain.CreateSection("Farm Observation")
FarmObservationSection.CreateToggle({ Title = "Auto UP Observation V2", Desc = nil, Default = Settings["Auto UP Observation V2"] or false }, function(...) end)
FarmObservationSection.CreateToggle({ Title = "Farm Observation", Desc = nil, Default = Settings["Farm Observation"] or false }, function(...) end)
FarmObservationSection.CreateToggle({
		Title = "Farm Observation [ Hop Server ]",
		Desc = nil,
		Default = Settings["Farm Observation [ Hop Server ]"] or false,
	}, function(...) end)
AutoKillMobSection = FarmotherMain.CreateSection("Auto Kill Mob")
AutoKillMobSection.CreateDropdown({
		Title = "Select Mob",
		List = PrepareMultiSelectList(TableMob(), Settings["Select Mob"]),
		Search = true,
		Selected = true,
		Default = Settings["Select Mob"] or nil,
	}, function(...) end)
AutoKillMobSection.CreateToggle({ Title = "Kill Mob", Desc = nil, Default = Settings["Kill Mob"] or false }, function(...) end)
AutoKillBossSection = FarmotherMain.CreateSection("Auto Boss")
local y = AutoKillBossSection.CreateDropdown({
		Title = "Select Boss",
		List = TableBoss(),
		Search = true,
		Selected = false,
		Default = Settings["Select Boss"] or nil,
	}, function(...) end)
AutoKillBossSection.CreateButton({ Title = "Refresh Boss" }, function(...) end)
AutoKillBossSection.CreateToggle({ Title = "Kill Boss", Desc = nil, Default = Settings["Kill Boss"] or false }, function(...) end)
AutoKillBossSection.CreateToggle({ Title = "Kill All Boss", Desc = nil, Default = Settings["Kill All Boss"] or false }, function(...) end)
AutoKillBossSection.CreateToggle({ Title = "Hop Server Find Boss", Desc = nil, Default = Settings["Hop Server Find Boss"] or false }, function(...) end)
DFRaidMain = Main.CreatePage({ Page_Name = "Fruit and Raid, Dungeon", Page_Title = "Fruit and Raid and Dungeon Tab" })
DevilFruitSection = DFRaidMain.CreateSection("Devil Fruit")
DevilFruitSection.CreateToggle({ Title = "Random Devil Fruit", Desc = nil, Default = Settings["Random Devil Fruit"] or false }, function(...) end)
DevilFruitSection.CreateToggle({ Title = "Auto Store Fruit", Desc = nil, Default = Settings["Auto Store Fruit"] or false }, function(...) end)
DevilFruitSection.CreateDropdown({
		Title = "Blox Fruit Sniper Shop",
		List = PrepareMultiSelectList(TableDevilFruit, Settings["Blox Fruit Sniper Shop"]),
		Search = true,
		Selected = true,
		Default = Settings["Blox Fruit Sniper Shop"] or nil,
	}, function(...) end)
DevilFruitSection.CreateToggle({ Title = "Buy Blox Fruit Sniper Shop", Desc = nil, Default = Settings["Buy Blox Fruit Sniper Shop"] or false }, function(...) end)
RaidsSection = DFRaidMain.CreateSection("Raids")
RaidsSection.CreateDropdown({ Title = "Select Raid", List = g, Search = true, Selected = false, Default = Settings["Select Raid"] or nil }, function(...) end)
RaidsSection.CreateToggle({
		Title = "Get Fruit In Inventory Low Beli",
		Desc = nil,
		Default = Settings["Get Fruit In Inventory Low Beli"] or false,
	}, function(...) end)
RaidsSection.CreateToggle({ Title = "Auto Raid", Desc = nil, Default = Settings["Auto Raid"] or false }, function(...) end)
RaidsSection.CreateToggle({ Title = "Hop Sever Raid", Desc = nil, Default = Settings["Hop Sever Raid"] or false }, function(...) end)
RaidsSection.CreateToggle({ Title = "Auto Awake Fruit", Desc = nil, Default = Settings["Auto Awake Fruit"] or false }, function(...) end)
MultiRaidsSection = DFRaidMain.CreateSection("Multi Raid")
DropdownSelectPlayerMultiRaid = MultiRaidsSection.CreateDropdown({
		Title = "Select Player Multi Raid",
		List = PrepareMultiSelectList(DetectNamePlayerMulti(), Settings["Select Player Multi Raid"]),
		Search = true,
		Selected = true,
		Default = Settings["Select Player Multi Raid"] or nil,
	}, function(...) end)
MultiRaidsSection.CreateButton({ Title = "Refresh Player" }, function(...) end)
MultiRaidsSection.CreateToggle({ Title = "Account Buy Chip", Desc = nil, Default = Settings["Account Buy Chip"] or false }, function(...) end)
MultiRaidsSection.CreateToggle({ Title = "Account Pick Slot Raid", Desc = nil, Default = Settings["Account Pick Slot Raid"] or false }, function(...) end)
MultiRaidsSection.CreateToggle({ Title = "Auto Multi Raid", Desc = nil, Default = Settings["Auto Multi Raid"] or false }, function(...) end)
DungeonJoinSection = DFRaidMain.CreateSection("Join Dungeon")
DropdownDropdownSelectAccountJoin = DungeonJoinSection.CreateDropdown({
		Title = "Select Account Join",
		List = DetectNamePlayer(),
		Search = true,
		Selected = false,
		Default = Settings["Select Account Join"] or nil,
	}, function(...) end)
DungeonJoinSection.CreateButton({ Title = "Refresh Player" }, function(...) end)
DungeonJoinSection.CreateSlider({
		Title = "Min Player Join Dungeon",
		Min = 0,
		Max = 4,
		Default = Settings["Min Player Join Dungeon"] or 2,
		Precise = true,
	}, function(...) end)
DungeonJoinSection.CreateDropdown({
		Title = "Select Difficulty",
		List = { "Normal", "Hard", "Challenge" },
		Search = true,
		Selected = false,
		Default = Settings["Select Difficulty"] or nil,
	}, function(...) end)
DungeonJoinSection.CreateToggle({
		Title = "Account Start Dungeon",
		Desc = "Account Start Dungeon",
		Default = Settings["Account Start Dungeon"] or false,
	}, function(...) end)
DungeonJoinSection.CreateToggle({ Title = "Auto Join Dungeon", Desc = "Auto Join Dungeon", Default = Settings["Auto Join Dungeon"] or false }, function(...) end)
DungeonSection = DFRaidMain.CreateSection("Dungeon")
DungeonSection.CreateDropdown({
		Title = "Select Weapon Dungeon",
		List = { "Melee", "Sword", "Blox Fruit", "Gun" },
		Search = true,
		Selected = false,
		Default = Settings["Select Weapon Dungeon"] or nil,
	}, function(...) end)
DungeonSection.CreateDropdown({
		Title = "Select Card Priority",
		List = TableCardpriority,
		Search = true,
		Priority = true,
		Default = Settings["Select Card Priority"] or {},
	}, function(...) end)
DungeonSection.CreateToggle({
		Title = "Auto Attack Dungeon",
		Desc = "Auto Attack Mob and go next Floor",
		Default = Settings["Auto Attack Dungeon"] or false,
	}, function(...) end)
DungeonSection.CreateToggle({ Title = "Auto Pick Card Dungeon", Desc = nil, Default = Settings["Auto Pick Card Dungeon"] or false }, function(...) end)
SeaEventTab = Main.CreatePage({ Page_Name = "Sea Event", Page_Title = "Sea Event Tab" })
SettingSeaEventSection = SeaEventTab.CreateSection("Setting")
SettingSeaEventSection.CreateDropdown({
		Title = "Select Zone",
		List = { "Zone 1", "Zone 2", "Zone 3", "Zone 4", "Zone 5", "Zone 6" },
		Search = true,
		Selected = false,
		Default = Settings["Select Zone"] or nil,
	}, function(...) end)
SettingSeaEventSection.CreateDropdown({
		Title = "Select Sea Events",
		List = PrepareMultiSelectList(
			{
				SeaBeast = false,
				Ship = false,
				Shark = false,
				Terrorshark = false,
				Piranha = false,
				["Only Farm Ship Brigade"] = false,
			},
			Settings["Select Sea Events"]
		),
		Search = true,
		Selected = true,
		Default = Settings["Select Sea Events"] or nil,
	}, function(...) end)
SettingSeaEventSection.CreateDropdown({
		Title = "Select Boat",
		List = { "Beast Hunter", "Guardian", "Lantern", "Seleigh", "Brigade", "GrandBrigade" },
		Search = true,
		Selected = false,
		Default = Settings["Select Boat"] or nil,
	}, function(...) end)
SettingSeaEventSection.CreateDropdown({
		Title = "Select Weapons Use Skill",
		List = PrepareMultiSelectList(E, Settings["Select Weapons Use Skill"]),
		Search = true,
		Selected = true,
		Default = Settings["Select Weapons Use Skill"] or nil,
	}, function(...) end)
SettingSeaEventSection.CreateToggle({
		Title = "Use Dragonstorm For Sea Event",
		Desc = "Only Farm Boat and Fish and TerrorShark",
		Default = Settings["Use Dragonstorm For Sea Event"] or false,
	}, function(...) end)
SettingSeaEventSection.CreateToggle({
		Title = "Use Click M1 Skull Guitar For Sea Event",
		Desc = "Only Farm Boat and Seabeast",
		Default = Settings["Use Click M1 Skull Guitar For Sea Event"] or false,
	}, function(...) end)
SettingSeaEventSection.CreateToggle({
		Title = "Auto Change Dragonstorm With Skull Guitar",
		Desc = "When Kill Boat and Fish and TerrorShark use Dragonstorm\10Kill Seabeast use Seabeast",
		Default = Settings["Auto Change Dragonstorm With Skull Guitar"] or false,
	}, function(...) end)
SettingSeaEventSection.CreateToggle({
		Title = "Auto Change Dragonstorm When Kill Boat",
		Desc = nil,
		Default = Settings["Auto Change Dragonstorm When Kill Boat"] or false,
	}, function(...) end)
SettingSeaEventSection.CreateToggle({
		Title = "Use Click M1 Fruit For Sea Event",
		Desc = nil,
		Default = Settings["Use Click M1 Fruit For Sea Event"] or false,
	}, function(...) end)
SettingSeaEventSection.CreateToggle({
		Title = "Reset Character Buy Boat",
		Desc = "if u spawn in tiki it will reset for buy boat",
		Default = Settings["Reset Character Buy Boat"] or false,
	}, function(...) end)
SettingSeaEventSection.CreateToggle({ Title = "Auto Dodge Skill Terrorshark", Desc = nil, Default = Settings["Auto Dodge Skill Terrorshark"] or false }, function(...) end)
SettingSeaEventSection.CreateToggle({
		Title = "Auto Dodge Skill Seabeast",
		Desc = "Dodge Only Skill Kameha and waterbeam",
		Default = Settings["Auto Dodge Skill Seabeast"] or false,
	}, function(...) end)
SettingSeaEventSection.CreateToggle({
		Title = "Teleport Boat Other CFrame if Rough Sea",
		Desc = nil,
		Default = Settings["Teleport Boat Other CFrame if Rough Sea"] or false,
	}, function(...) end)
SettingSeaEventSection.CreateToggle({
		Title = "Tween Until Have Sea Event",
		Desc = "When there's a sea event, it will stop to fight, and after finishing the fight, it will continue tweening",
		Default = Settings["Tween Until Have Sea Event"] or false,
	}, function(...) end)
SettingSeaEventSection.CreateToggle({ Title = "Will Back When over 10km", Desc = nil, Default = Settings["Will Back When over 10km"] or false }, function(...) end)
FarmingSeaEventSection = SeaEventTab.CreateSection("Farming")
local b = FarmingSeaEventSection.CreateDropdown({
		Title = "Select Friend",
		List = DetectNamePlayer(),
		Search = true,
		Selected = false,
		Default = Settings["Select Friend"] or nil,
	}, function(...) end)
FarmingSeaEventSection.CreateButton({ Title = "Refresh Player" }, function(...) end)
FarmingSeaEventSection.CreateToggle({ Title = "Auto Sea Event With Friend", Desc = nil, Default = Settings["Auto Sea Event With Friend"] or false }, function(...) end)
FarmingSeaEventSection.CreateToggle({ Title = "Auto Repair Ur Ship", Desc = nil, Default = Settings["Auto Repair Ur Ship"] or false }, function(...) end)
FarmingSeaEventSection.CreateToggle({ Title = "Auto Sea Event", Desc = nil, Default = Settings["Auto Sea Event"] or false }, function(...) end)
ToggleFindMirage = FarmingSeaEventSection.CreateToggle({ Title = "Auto Find Mirage", Desc = nil, Default = Settings["Auto Find Mirage"] or false }, function(...) end)
KitsuneEventSection = SeaEventTab.CreateSection("Kitsune Event")
KitsuneEventSection.CreateToggle({ Title = "Teleport To Kitsune Island", Desc = nil, Default = Settings["Teleport To Kitsune Island"] or false }, function(...) end)
KitsuneEventSection.CreateToggle({
		Title = "Hop Server [ Next Night or Near Full Moon > 2m ]",
		Desc = nil,
		Default = Settings["Hop Server Kitsune Island"] or false,
	}, function(...) end)
KitsuneEventSection.CreateToggle({ Title = "Auto Spawn Kitsune Island", Desc = nil, Default = Settings["Auto Spawn Kitsune Island"] or false }, function(...) end)
KitsuneEventSection.CreateToggle({ Title = "Auto Summon Soul Ember", Desc = nil, Default = Settings["Auto Summon Soul Ember"] or false }, function(...) end)
KitsuneEventSection.CreateToggle({ Title = "Auto Collect Soul Ember", Desc = nil, Default = Settings["Auto Collect Soul Ember"] or false }, function(...) end)
KitsuneEventSection.CreateSlider({ Title = "Values Azure Ember", Min = 0, Max = 25, Default = Settings["Values Azure Ember"] or 10, Precise = true }, function(...) end)
KitsuneEventSection.CreateToggle({ Title = "Auto Trade Azure Ember", Desc = nil, Default = Settings["Auto Trade Azure Ember"] or false }, function(...) end)
LeviathanEventSection = SeaEventTab.CreateSection("Leviathan Event")
LeviathanEventSection.CreateButton({ Title = "Buy Spy" }, function(...) end)
LeviathanEventSection.CreateButton({ Title = "Teleport your boat to current Position" }, function(...) end)
LeviathanEventSection.CreateToggle({ Title = "Auto Buy Spy", Desc = nil, Default = Settings["Auto Buy Spy"] or false }, function(...) end)
LeviathanEventSection.CreateToggle({ Title = "Auto Buy Boat Beast Hunter", Desc = nil, Default = Settings["Auto Buy Boat Beast Hunter"] or false }, function(...) end)
local s = LeviathanEventSection.CreateDropdown({
		Title = "Select Owner Boat Find Leviathan",
		List = DetectNamePlayer(),
		Search = true,
		Selected = false,
		Default = Settings["Select Owner Boat Find Leviathan"] or nil,
	}, function(...) end)
LeviathanEventSection.CreateButton({ Title = "Refresh Player" }, function(...) end)
LeviathanEventSection.CreateToggle({ Title = "Multi Find Leviathan", Desc = nil, Default = Settings["Multi Find Leviathan"] or false }, function(...) end)
LeviathanEventSection.CreateToggle({ Title = "Auto Find Leviathan", Desc = nil, Default = Settings["Auto Find Leviathan"] or false }, function(...) end)
LeviathanEventSection.CreateToggle({ Title = "Auto Start Leviathan", Desc = nil, Default = Settings["Auto Start Leviathan"] or false }, function(...) end)
LeviathanEventSection.CreateToggle({ Title = "Auto Destroy IDK", Desc = nil, Default = Settings["Auto Destroy IDK"] or false }, function(...) end)
LeviathanEventSection.CreateToggle({
		Title = "Attack Multi Segments Leviathan",
		Desc = "Please enable the damage counter so I can calculate the damage dealt to that segment.\10plz Turn on multi Segments first.",
		Default = Settings["Attack Multi Segments Leviathan"] or false,
	}, function(...) end)
LeviathanEventSection.CreateSlider({
		Title = "Value Damage Multi Segments",
		Min = 0,
		Max = 1000000,
		Default = Settings["Value Damage Multi Segments"] or 30000,
		Precise = true,
	}, function(...) end)
LeviathanEventSection.CreateToggle({ Title = "Auto Attack Leviathan", Desc = nil, Default = Settings["Auto Attack Leviathan"] or false }, function(...) end)
LeviathanEventSection.CreateToggle({ Title = "Use Click M1 Fruit Leviathan", Desc = nil, Default = Settings["Use Click M1 Fruit Leviathan"] or false }, function(...) end)
LeviathanEventSection.CreateToggle({
		Title = "Use Click M1 Skull Guitar Leviathan",
		Desc = nil,
		Default = Settings["Use Click M1 Skull Guitar Leviathan"] or false,
	}, function(...) end)
local b = LeviathanEventSection.CreateDropdown({
		Title = "Select Owner Boat Beast Hunter Shoot Heart",
		List = DetectNamePlayer(),
		Search = true,
		Selected = false,
		Default = Settings["Select Owner Boat Beast Hunter"] or nil,
	}, function(...) end)
LeviathanEventSection.CreateButton({ Title = "Refresh Player" }, function(...) end)
LeviathanEventSection.CreateToggle({ Title = "Use Your Boat Beast Hunter", Desc = nil, Default = Settings["Use Your Boat Beast Hunter"] or false }, function(...) end)
LeviathanEventSection.CreateToggle({
		Title = "Auto Fire Shoot Heart Leviathan",
		Desc = nil,
		Default = Settings["Auto Fire Shoot Heart Leviathan"] or false,
	}, function(...) end)
LeviathanEventSection.CreateToggle({ Title = "Teleport Frozen Dimension", Desc = nil, Default = Settings["Teleport Frozen Dimension"] or false }, function(...) end)
LeviathanEventSection.CreateToggle({
		Title = "Tween Boat To Frozen Dimension",
		Desc = nil,
		Default = Settings["Tween Boat To Frozen Dimension"] or false,
	}, function(...) end)
LeviathanEventSection.CreateSlider({
		Title = "Speed Boat Auto Drive",
		Min = 0,
		Max = 500,
		Default = Settings["Speed Boat Auto Drive"] or 300,
		Precise = true,
	}, function(...) end)
LeviathanEventSection.CreateToggle({ Title = "Drive Boat To Tiki", Desc = nil, Default = Settings["Drive Boat To Tiki"] or false }, function(...) end)
LeviathanEventSection.CreateToggle({ Title = "Drive Boat To Hydra", Desc = nil, Default = Settings["Drive Boat To Hydra"] or false }, function(...) end)
BoatSettingSection = SeaEventTab.CreateSection("Boat Setting")
BoatSettingSection.CreateToggle({ Title = "Fly Boat", Desc = nil, Default = Settings["Fly Boat"] or false }, function(...) end)
BoatSettingSection.CreateSlider({ Title = "Value Speed Boat", Min = 0, Max = 500, Default = Settings["Value Speed Boat"] or 200, Precise = true }, function(...) end)
BoatSettingSection.CreateSlider({
		Title = "Value Speed Tween Boat",
		Min = 50,
		Max = 2000,
		Default = tonumber(Settings["Value Speed Tween Boat"]) or 350,
		Precise = true,
	}, function(...) end)
BoatSettingSection.CreateSlider({
		Title = "Value Speed Fly Boat",
		Min = 0,
		Max = 10,
		Default = Settings["Value Speed Fly Boat"] or 3,
		Precise = true,
	}, function(...) end)
BoatSettingSection.CreateToggle({ Title = "Change Speed Boat", Desc = nil, Default = Settings["Change Speed Boat"] or false }, function(...) end)
RaceMain = Main.CreatePage({ Page_Name = "Upgrade Race", Page_Title = "Upgrade Race Tab" })
RaceDracoSection = RaceMain.CreateSection("Race Draco")
RaceDracoSection.CreateToggle({ Title = "Auto Upgrade Race V2-V3 Draco", Desc = nil, Default = Settings["Auto Upgrade Race V2-V3 Draco"] or false }, function(...) end)
getgenv().StatusGearDraco = RaceDracoSection.CreateLabel({ Title = "Acient One Draco Status" })
ToggleAutoTrialDraco = RaceDracoSection.CreateToggle({ Title = "Auto Trial Draco", Desc = nil, Default = Settings["Auto Trial Draco"] or false }, function(...) end)
RaceDracoSection.CreateToggle({
		Title = "Fully Trial Draco",
		Desc = "Auto Craft and Auto Find and Auto Attack and Fix\10 Auto Trial and auto Train Race and Buy Gear and Choose Gear",
		Default = Settings["Fully Trial Draco"] or false,
	}, function(...) end)
RaceDracoSection.CreateToggle({
		Title = "Ignore Craft Volcanic Magnet [ Fully Draco ]",
		Desc = nil,
		Default = Settings["Ignore Craft Volcanic Magnet Draco"] or false,
	}, function(...) end)
RaceDracoSection.CreateToggle({ Title = "Auto Buy Gear Draco", Desc = nil, Default = Settings["Auto Buy Gear Draco"] or false }, function(...) end)
RaceDracoSection.CreateToggle({ Title = "Auto Finish Train Draco Quest", Desc = nil, Default = Settings["Auto Finish Train Draco Quest"] or false }, function(...) end)
RaceNormalSection = RaceMain.CreateSection("Race Normal")
RaceNormalSection.CreateToggle({ Title = "Auto Upgrade Race V2-V3", Desc = nil, Default = Settings["Auto Upgrade Race V2-V3"] or false }, function(...) end)
ToggleAutoGetFullyCyborg = RaceNormalSection.CreateToggle({ Title = "Auto Get Fully Cyborg", Desc = nil, Default = Settings["Auto Get Fully Cyborg"] or false }, function(...) end)
RaceNormalSection.CreateToggle({
		Title = "Auto Get Cyborg Hop Collect Chest",
		Desc = nil,
		Default = Settings["Auto Get Cyborg Hop Collect Chest"] or false,
	}, function(...) end)
RaceNormalSection.CreateToggle({ Title = "Auto Get Cyborg", Desc = nil, Default = Settings["Auto Get Cyborg"] or false }, function(...) end)
RaceNormalSection.CreateToggle({ Title = "Hop Server Find Boss Cursed Captain", Desc = nil, Default = Settings["Hop Server Get Ghoul"] or false }, function(...) end)
RaceNormalSection.CreateToggle({ Title = "Auto Get Ghoul", Desc = nil, Default = Settings["Auto Get Ghoul"] or false }, function(...) end)
RaceV4Section = RaceMain.CreateSection("Race V4")
RaceV4Section.CreateToggle({ Title = "No Frog", Desc = nil, Default = Settings["No Frog"] or false }, function(...) end)
RaceV4Section.CreateToggle({ Title = "Teleport Acient Clock", Desc = nil, Default = Settings["Teleport Acient Clock"] or false }, function(...) end)
RaceV4Section.CreateToggle({ Title = "Auto Buy Gear", Desc = nil, Default = Settings["Auto Buy Gear"] or false }, function(...) end)
RaceV4Section.CreateDropdown({
		Title = "Select Gear V4",
		List = { "Alpha", "Omega" },
		Search = false,
		Selected = false,
		Default = Settings["Select Gear V4"] or "Omega",
	}, function(...) end)
getgenv().ToggleAutoChooseGears = RaceV4Section.CreateToggle({ Title = "Auto Choose Gears", Desc = nil, Default = Settings["Auto Choose Gears"] or false }, function(...) end)
RaceV4Section.CreateToggle({ Title = "Auto Finish Train Quest", Desc = nil, Default = Settings["Auto Finish Train Quest"] or false }, function(...) end)
RaceV4Section.CreateToggle({ Title = "Stack Train With Trial Race", Desc = nil, Default = Settings["Stack Train With Trial Race"] or false }, function(...) end)
getgenv().TurnOffHOPSVPullAndTrial = RaceV4Section.CreateToggle({
		Title = "Hop Server [Trial Or Pull Lever]",
		Desc = nil,
		Default = Settings["Hop Server [Trial Or Pull Lever]"] or false,
	}, function(...) end)
RaceV4Section.CreateToggle({ Title = "Auto Pull Lever", Desc = nil, Default = Settings["Auto Pull Lever"] or false }, function(...) end)
DropdownSelectPlayerMulti = RaceV4Section.CreateDropdown({
		Title = "Select Players Multi",
		List = PrepareMultiSelectList(DetectNameMulti(), Settings["Select Players Multi"]),
		Search = true,
		Selected = true,
		Default = Settings["Select Players Multi"] or nil,
	}, function(...) end)
RaceV4Section.CreateButton({ Title = "Refresh Player" }, function(...) end)
RaceV4Section.CreateToggle({ Title = "Multi Trial", Desc = nil, Default = Settings["Multi Trial"] or false }, function(...) end)
RaceV4Section.CreateToggle({ Title = "Auto Reset Character", Desc = nil, Default = Settings["Auto Reset Character"] or false }, function(...) end)
ToggleAutoTrial = RaceV4Section.CreateToggle({ Title = "Auto Trial", Desc = nil, Default = Settings["Auto Trial"] or false }, function(...) end)
RaceV4Section.CreateToggle({
		Title = "Auto Turn On V3 Near Door",
		Desc = "will auto turn on race \10if have players near door",
		Default = Settings["Auto Turn On V3 Near Door"] or false,
	}, function(...) end)
KillTrialSection = RaceMain.CreateSection("Kill Trial")
KillTrialSection.CreateDropdown({
		Title = "Select Weapon Attack Trial",
		List = { "Melee", "Sword", "Blox Fruit" },
		Search = true,
		Selected = false,
		Default = Settings["Select Weapon Attack Trial"] or nil,
	}, function(...) end)
KillTrialSection.CreateToggle({
		Title = "Kill players When complete Trial",
		Desc = "Turn on before Start Attack and Turn on Auto Trial",
		Default = Settings["Kill players When complete Trial"] or false,
	}, function(...) end)
KillTrialSection.CreateToggle({ Title = "Use Skill when Kill Player", Desc = nil, Default = Settings["Use Skill when Kill Player"] or false }, function(...) end)
KillTrialSection.CreateToggle({
		Title = "Just Use Skill when Player Active Ken",
		Desc = nil,
		Default = Settings["Just Use Skill when Player Active Ken"] or false,
	}, function(...) end)
GetItemsMain = Main.CreatePage({ Page_Name = "Get and Upgrade Items", Page_Title = "Get and Upgrade Items Tab" })
GetItemsSection = GetItemsMain.CreateSection("Get Items")
GetItemsSection.CreateToggle({ Title = "Auto Trade Bone", Desc = nil, Default = Settings["Auto Trade Bone"] or false }, function(...) end)
GetItemsSection.CreateToggle({ Title = "Auto Buy Legendary Sword", Desc = nil, Default = Settings["Auto Buy Legendary Sword"] or false }, function(...) end)
GetItemsSection.CreateToggle({ Title = "Auto Buy Haki Color", Desc = nil, Default = Settings["Auto Buy Haki Color"] or false }, function(...) end)
GetItemsSection.CreateToggle({
		Title = "Hop Server [ Haki color or Legendary Sword]",
		Desc = nil,
		Default = Settings["Hop Server [ Haki color or Legendary Sword]"] or false,
	}, function(...) end)
GetItemsSection.CreateToggle({ Title = "Auto Get Rainbow Haki", Desc = nil, Default = Settings["Auto Get Rainbow Haki"] or false }, function(...) end)
GetItemsSection.CreateToggle({ Title = "Auto Soul Guitar", Desc = nil, Default = Settings["Auto Soul Guitar"] or false }, function(...) end)
GetItemsSection.CreateDropdown({
		Title = "Select Method Hop CDK",
		List = PrepareMultiSelectList(MethodHopCDk, Settings["Select Method Hop CDK1"]),
		Search = true,
		Selected = true,
		Default = Settings["Select Method Hop CDK1"] or nil,
	}, function(...) end)
GetItemsSection.CreateToggle({ Title = "Auto CDK", Desc = nil, Default = Settings["Auto CDK"] or false }, function(...) end)
GetItemsSection.CreateToggle({ Title = "Auto Yama", Desc = nil, Default = Settings["Auto Yama"] or false }, function(...) end)
GetItemsSection.CreateToggle({ Title = "Auto Tushita", Desc = nil, Default = Settings["Auto Tushita"] or false }, function(...) end)
GetItemsSection.CreateToggle({ Title = "Auto TTK", Desc = nil, Default = Settings["Auto TTK"] or false }, function(...) end)
GetItemsSection.CreateToggle({ Title = "Auto Saber", Desc = nil, Default = Settings["Auto Saber"] or false }, function(...) end)
GetItemsSection.CreateToggle({ Title = "Auto Craft Item Shark Anchor", Desc = nil, Default = Settings["Auto Craft Item Shark Anchor"] or false }, function(...) end)
GetItemsSection.CreateToggle({
		Title = "Auto Yoru Mini",
		Desc = "u need have 3 haki legendary,\10it will auto chest, kill Elite Hunter Find Chalice,\10Summon And Kill Rip Indra",
		Default = Settings["Auto Yoru Mini"] or false,
	}, function(...) end)
GetItemsSection.CreateToggle({
		Title = "Auto Yoru Mini (Hop Server)",
		Desc = "u can change value hop chest in Tab Farming Other",
		Default = Settings["Auto Yoru Mini"] or false,
	}, function(...) end)
MasteryWeaponSection = GetItemsMain.CreateSection("Mastery Weapon")
MasteryWeaponSection.CreateToggle({ Title = "Auto Farm Mastery 600 Melees", Desc = nil, Default = Settings["Auto Farm Mastery 600 Melees"] or false }, function(...) end)
MasteryWeaponSection.CreateToggle({
		Title = "Auto Farm Mastery 600 Sword In Inventory",
		Desc = nil,
		Default = Settings["Auto Farm Mastery 600 Sword In Inventory"] or false,
	}, function(...) end)
UpgradeWeaponSection = GetItemsMain.CreateSection("Upgrade Weapon")
getgenv().StatusUpgradeWP = UpgradeWeaponSection.CreateLabel({ Title = "" })
UpgradeWeaponSection.CreateToggle({ Title = "Auto Upgrade Sword Inventory", Desc = nil, Default = Settings["Auto Upgrade Sword Inventory"] or false }, function(...) end)
UpgradeWeaponSection.CreateToggle({ Title = "Auto Upgrade Gun Inventory", Desc = nil, Default = Settings["Auto Upgrade Gun Inventory"] or false }, function(...) end)
VolcanoTab = Main.CreatePage({ Page_Name = "Volcano Event", Page_Title = "Volcano Event Tab" })
SettingsVolcanoSection = VolcanoTab.CreateSection("Settings Volcano")
SettingsVolcanoSection.CreateDropdown({
		Title = "Select Weapon Kill Golem",
		List = { "Melee", "Sword", "Blox Fruit" },
		Search = true,
		Selected = false,
		Default = Settings["Select Weapon Kill Golem"] or nil,
	}, function(...) end)
SettingsVolcanoSection.CreateDropdown({
		Title = "Select Weapons Fix Lava",
		List = PrepareMultiSelectList(E, Settings["Select Weapons Fix Lava"]),
		Search = true,
		Selected = true,
		Default = Settings["Select Weapons Fix Lava"] or nil,
	}, function(...) end)
SettingsVolcanoSection.CreateDropdown({
		Title = "Select Method Kill Golem",
		List = { "Click M1", "Instant Kill [ Risk and can bug no die mob ]" },
		Search = true,
		Selected = false,
		Default = Settings["Select Method Kill Golem"] or nil,
	}, function(...) end)
FarmingVolcanoSection = VolcanoTab.CreateSection("Farming Volcano")
ToggleAutoCraftingVolcanicMagnet = FarmingVolcanoSection.CreateToggle({ Title = "Auto Crafting Volcanic Magnet", Desc = nil, Default = Settings["Auto Crafting Volcanic Magnet"] or false }, function(...) end)
ToggleAutoFindPrehistoricIsland = FarmingVolcanoSection.CreateToggle({ Title = "Auto Find Prehistoric Island", Desc = nil, Default = Settings["Auto Find Prehistoric Island"] or false }, function(...) end)
FarmingVolcanoSection.CreateToggle({
		Title = "Auto Event Prehistoric Island",
		Desc = "auto Start Event and Auto kill golem, Auto Fix Volcano",
		Default = Settings["Auto Event Prehistoric Island"] or false,
	}, function(...) end)
FarmingVolcanoSection.CreateToggle({ Title = "Auto Collect Bone", Desc = nil, Default = Settings["Auto Collect Bone"] or false }, function(...) end)
FarmingVolcanoSection.CreateToggle({ Title = "Auto Collect Egg", Desc = nil, Default = Settings["Auto Collect Egg"] or false }, function(...) end)
FullyVolcanoSection = VolcanoTab.CreateSection("Fully Volcano")
FullyVolcanoSection.CreateToggle({
		Title = "Ignore Craft Volcanic Magnet [ Fully ]",
		Desc = nil,
		Default = Settings["Ignore Craft Volcanic Magnet"] or false,
	}, function(...) end)
FullyVolcanoSection.CreateToggle({ Title = "Ignore Collect Bone [ Fully ]", Desc = nil, Default = Settings["Ignore Collect Bone"] or false }, function(...) end)
FullyVolcanoSection.CreateToggle({
		Title = "Fully Event Prehistoric Island",
		Desc = nil,
		Default = Settings["Fully Event Prehistoric Island"] or false,
	}, function(...) end)
ESPTab = Main.CreatePage({ Page_Name = "ESP", Page_Title = "ESP Tab" })
ESPSection = ESPTab.CreateSection("ESP")
ESPSection.CreateToggle({ Title = "ESP Berry", Desc = nil, Default = Settings["ESP Berry"] or false }, function(...) end)
ESPSection.CreateToggle({ Title = "ESP Island", Desc = nil, Default = Settings["ESP Island"] or false }, function(...) end)
ESPSection.CreateToggle({ Title = "ESP Fruit", Desc = nil, Default = Settings["ESP Fruit"] or false }, function(...) end)
ESPSection.CreateToggle({ Title = "ESP Player", Desc = nil, Default = Settings["ESP Player"] or false }, function(...) end)
PvpTab = Main.CreatePage({ Page_Name = "PVP", Page_Title = "PVP Tab" })
SettingsAimbotSection = PvpTab.CreateSection("PVP")
local b = SettingsAimbotSection.CreateDropdown({
		Title = "Select Player PVP",
		List = DetectNamePlayer(),
		Search = true,
		Selected = false,
		Default = Settings["Select Player PVP"] or nil,
	}, function(...) end)
SettingsAimbotSection.CreateDropdown({
		Title = "Select Method Aimbot",
		List = { "Select Player", "Target nearest Player" },
		Search = true,
		Selected = false,
		Default = Settings["Select Method Aimbot"] or nil,
	}, function(...) end)
SettingsAimbotSection.CreateButton({ Title = "Refresh Player" }, function(...) end)
SettingsAimbotSection.CreateToggle({ Title = "Teleport Player", Desc = nil, Default = Settings["Teleport Player"] or false }, function(...) end)
SettingsAimbotSection.CreateToggle({ Title = "Auto Aimbot", Desc = nil, Default = Settings["Auto Aimbot"] or false }, function(...) end)
SettingsAimbotSection.CreateToggle({ Title = "Auto Aimbot Gun", Desc = nil, Default = Settings["Auto Aimbot Gun"] or false }, function(...) end)
MISCPVPSection = PvpTab.CreateSection("MISC PVP")
MISCPVPSection.CreateSlider({ Title = "Input WalkSpeed", Min = 0, Max = 500, Default = Settings["Input WalkSpeed"] or 200, Precise = true }, function(...) end)
MISCPVPSection.CreateSlider({ Title = "Input JumpPower", Min = 0, Max = 500, Default = Settings["Input JumpPower"] or 200, Precise = true }, function(...) end)
MISCPVPSection.CreateToggle({ Title = "Change JumpPower", Desc = nil, Default = Settings["Change JumpPower"] or false }, function(...) end)
MISCPVPSection.CreateToggle({ Title = "Change WalkSpeed", Desc = nil, Default = Settings["Change WalkSpeed"] or false }, function(...) end)
MISCPVPSection.CreateToggle({ Title = "Walk On Water", Desc = nil, Default = Settings["Walk On Water "] or true }, function(...) end)
TabWebhook = Main.CreatePage({ Page_Name = "Tab Webhook", Page_Title = "Tab Webhook" })
SectionWebhook = TabWebhook.CreateSection("Webhook")
SectionWebhook.CreateToggle({ Title = "Ping Everyone/Id Discord", Desc = nil, Default = Settings["Ping Discord"] or false }, function(...) end)
SectionWebhook.CreateToggle({ Title = "Noti Profile", Desc = nil, Default = Settings["Noti Profile"] or false }, function(...) end)
SectionWebhook.CreateDropdown({
		Title = "Select Rarity Fruit",
		List = PrepareMultiSelectList(TableRarityFruit, Settings["Select Rarity Fruit"]),
		Search = true,
		Selected = true,
		Default = Settings["Select Rarity Fruit"] or nil,
	}, function(...) end)
SectionWebhook.CreateToggle({ Title = "Webhook Store Fruit", Desc = nil, Default = Settings["Webhook Store Fruit"] or false }, function(...) end)
SectionWebhook.CreateToggle({
		Title = "Webhook Find Prehistoric Island",
		Desc = nil,
		Default = Settings["Webhook Find Prehistoric Island"] or false,
	}, function(...) end)
SectionWebhook.CreateToggle({ Title = "Webhook Find Leviathan", Desc = nil, Default = Settings["Webhook Find Leviathan"] or false }, function(...) end)
SectionWebhook.CreateToggle({ Title = "Webhook Destroy IDK", Desc = nil, Default = Settings["Webhook Destroy IDK"] or false }, function(...) end)
SectionWebhook.CreateToggle({ Title = "Webhook Find Mirage", Desc = nil, Default = Settings["Webhook Find Mirage"] or false }, function(...) end)
SettingPage = Main.CreatePage({ Page_Name = "Setting", Page_Title = "Setting Tab" })
a = SettingPage.CreateSection("Settings")
a.CreateToggle({ Title = "White Screen", Desc = nil, Default = Settings["White Screen"] or false }, function(...) end)
a.CreateToggle({ Title = "Black Screen", Desc = nil, Default = Settings["Black Screen"] or false }, function(...) end)
a.CreateToggle({ Title = "Remove Notifications", Desc = nil, Default = Settings["Remove Notifications"] or false }, function(...) end)
a.CreateToggle({ Title = "Auto rejoin Disconnect", Desc = nil, Default = Settings["Auto rejoin Disconnect"] or false }, function(...) end)
a.CreateToggle({ Title = "Auto Load Script", Desc = nil, Default = Settings["Auto Load Script"] or false }, function(...) end)
a.CreateToggle({ Title = "Boost Fps", Desc = nil, Default = Settings["Boost Fps"] or false }, function(...) end)
a.CreateButton({ Title = "Copy Config" }, function(...) end)
print("[T.H HUB] UI-only skeleton loaded.")
