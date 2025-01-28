local Players = cloneref(game:GetService("Players"))

local speaker = Players.LocalPlayer
local IYMouse = Players.LocalPlayer:GetMouse()
local PlayerGui = Players.LocalPlayer:FindFirstChildWhichIsA("PlayerGui")
local UserInputService = cloneref(game:GetService("UserInputService"))
local TweenService = cloneref(game:GetService("TweenService"))
local HttpService = cloneref(game:GetService("HttpService"))
local MarketplaceService = cloneref(game:GetService("MarketplaceService"))
local RunService = cloneref(game:GetService("RunService"))
local TeleportService = cloneref(game:GetService("TeleportService"))
local StarterGui = cloneref(game:GetService("StarterGui"))
local GuiService = cloneref(game:GetService("GuiService"))
local Lighting = cloneref(game:GetService("Lighting"))
local ContextActionService = cloneref(game:GetService("ContextActionService"))
local NetworkClient = cloneref(game:GetService("NetworkClient"))
local ReplicatedStorage = cloneref(game:GetService("ReplicatedStorage"))
local GroupService = cloneref(game:GetService("GroupService"))
local PathService = cloneref(game:GetService("PathfindingService"))
local SoundService = cloneref(game:GetService("SoundService"))
local Teams = cloneref(game:GetService("Teams"))
local StarterPlayer = cloneref(game:GetService("StarterPlayer"))
local InsertService = cloneref(game:GetService("InsertService"))
local ChatService = cloneref(game:GetService("Chat"))
local ProximityPromptService = cloneref(game:GetService("ProximityPromptService"))
local StatsService = cloneref(game:GetService("Stats"))
local MaterialService = cloneref(game:GetService("MaterialService"))
local AvatarEditorService = cloneref(game:GetService("AvatarEditorService"))
local TextChatService = cloneref(game:GetService("TextChatService"))
local httprequest = (syn and syn.request) or (http and http.request) or http_request or (fluxus and fluxus.request) or request
local everyClipboard = setclipboard or toclipboard or set_clipboard or (Clipboard and Clipboard.set)

local COREGUI = cloneref(game:GetService("CoreGui"))

local currentVersion = "2.2"

local Players = cloneref(game:GetService("Players"))

local MousePositionToVector2 = function()
	return Vector2.new(IYMouse.X, IYMouse.Y)
end

local WorldToScreen = function(Object)
	local ObjectVector = workspace.CurrentCamera:WorldToScreenPoint(Object.Position)
	return Vector2.new(ObjectVector.X, ObjectVector.Y)
end

local GetClosestPlayerFromCursor = function()
	local found = nil
	local ClosestDistance = math.huge
	for i, v in pairs(Players:GetPlayers()) do
		if v ~= Players.LocalPlayer and v.Character and v.Character:FindFirstChildOfClass("Humanoid") then
			for k, x in pairs(v.Character:GetChildren()) do
				if string.find(x.Name, "Torso") then
					local Distance = (WorldToScreen(x) - MousePositionToVector2()).Magnitude
					if Distance < ClosestDistance then
						ClosestDistance = Distance
						found = v
					end
				end
			end
		end
	end
	return found
end

function getRoot(char)
	local rootPart = char:FindFirstChild('HumanoidRootPart') or char:FindFirstChild('Torso') or char:FindFirstChild('UpperTorso')
	return rootPart
end


SpecialPlayerCases = {
	["all"] = function(speaker) return Players:GetPlayers() end,
	["others"] = function(speaker)
		local plrs = {}
		for i,v in pairs(Players:GetPlayers()) do
			if v ~= speaker then
				table.insert(plrs,v)
			end
		end
		return plrs
	end,
	["me"] = function(speaker)return {speaker} end,
	["#(%d+)"] = function(speaker,args,currentList)
		local returns = {}
		local randAmount = tonumber(args[1])
		local players = {unpack(currentList)}
		for i = 1,randAmount do
			if #players == 0 then break end
			local randIndex = math.random(1,#players)
			table.insert(returns,players[randIndex])
			table.remove(players,randIndex)
		end
		return returns
	end,
	["random"] = function(speaker,args,currentList)
		local players = Players:GetPlayers()
		local localplayer = Players.LocalPlayer
		table.remove(players, table.find(players, localplayer))
		return {players[math.random(1,#players)]}
	end,
	["%%(.+)"] = function(speaker,args)
		local returns = {}
		local team = args[1]
		for _,plr in pairs(Players:GetPlayers()) do
			if plr.Team and string.sub(string.lower(plr.Team.Name),1,#team) == string.lower(team) then
				table.insert(returns,plr)
			end
		end
		return returns
	end,
	["allies"] = function(speaker)
		local returns = {}
		local team = speaker.Team
		for _,plr in pairs(Players:GetPlayers()) do
			if plr.Team == team then
				table.insert(returns,plr)
			end
		end
		return returns
	end,
	["enemies"] = function(speaker)
		local returns = {}
		local team = speaker.Team
		for _,plr in pairs(Players:GetPlayers()) do
			if plr.Team ~= team then
				table.insert(returns,plr)
			end
		end
		return returns
	end,
	["team"] = function(speaker)
		local returns = {}
		local team = speaker.Team
		for _,plr in pairs(Players:GetPlayers()) do
			if plr.Team == team then
				table.insert(returns,plr)
			end
		end
		return returns
	end,
	["nonteam"] = function(speaker)
		local returns = {}
		local team = speaker.Team
		for _,plr in pairs(Players:GetPlayers()) do
			if plr.Team ~= team then
				table.insert(returns,plr)
			end
		end
		return returns
	end,
	["friends"] = function(speaker,args)
		local returns = {}
		for _,plr in pairs(Players:GetPlayers()) do
			if plr:IsFriendsWith(speaker.UserId) and plr ~= speaker then
				table.insert(returns,plr)
			end
		end
		return returns
	end,
	["nonfriends"] = function(speaker,args)
		local returns = {}
		for _,plr in pairs(Players:GetPlayers()) do
			if not plr:IsFriendsWith(speaker.UserId) and plr ~= speaker then
				table.insert(returns,plr)
			end
		end
		return returns
	end,
	["guests"] = function(speaker,args)
		local returns = {}
		for _,plr in pairs(Players:GetPlayers()) do
			if plr.Guest then
				table.insert(returns,plr)
			end
		end
		return returns
	end,
	["bacons"] = function(speaker,args)
		local returns = {}
		for _,plr in pairs(Players:GetPlayers()) do
			if plr.Character:FindFirstChild('Pal Hair') or plr.Character:FindFirstChild('Kate Hair') then
				table.insert(returns,plr)
			end
		end
		return returns
	end,
	["age(%d+)"] = function(speaker,args)
		local returns = {}
		local age = tonumber(args[1])
		if not age == nil then return end
		for _,plr in pairs(Players:GetPlayers()) do
			if plr.AccountAge <= age then
				table.insert(returns,plr)
			end
		end
		return returns
	end,
	["nearest"] = function(speaker,args,currentList)
		local speakerChar = speaker.Character
		if not speakerChar or not getRoot(speakerChar) then return end
		local lowest = math.huge
		local NearestPlayer = nil
		for _,plr in pairs(currentList) do
			if plr ~= speaker and plr.Character then
				local distance = plr:DistanceFromCharacter(getRoot(speakerChar).Position)
				if distance < lowest then
					lowest = distance
					NearestPlayer = {plr}
				end
			end
		end
		return NearestPlayer
	end,
	["farthest"] = function(speaker,args,currentList)
		local speakerChar = speaker.Character
		if not speakerChar or not getRoot(speakerChar) then return end
		local highest = 0
		local Farthest = nil
		for _,plr in pairs(currentList) do
			if plr ~= speaker and plr.Character then
				local distance = plr:DistanceFromCharacter(getRoot(speakerChar).Position)
				if distance > highest then
					highest = distance
					Farthest = {plr}
				end
			end
		end
		return Farthest
	end,
	["group(%d+)"] = function(speaker,args)
		local returns = {}
		local groupID = tonumber(args[1])
		for _,plr in pairs(Players:GetPlayers()) do
			if plr:IsInGroup(groupID) then  
				table.insert(returns,plr)
			end
		end
		return returns
	end,
	["alive"] = function(speaker,args)
		local returns = {}
		for _,plr in pairs(Players:GetPlayers()) do
			if plr.Character and plr.Character:FindFirstChildOfClass("Humanoid") and plr.Character:FindFirstChildOfClass("Humanoid").Health > 0 then
				table.insert(returns,plr)
			end
		end
		return returns
	end,
	["dead"] = function(speaker,args)
		local returns = {}
		for _,plr in pairs(Players:GetPlayers()) do
			if (not plr.Character or not plr.Character:FindFirstChildOfClass("Humanoid")) or plr.Character:FindFirstChildOfClass("Humanoid").Health <= 0 then
				table.insert(returns,plr)
			end
		end
		return returns
	end,
	["rad(%d+)"] = function(speaker,args)
		local returns = {}
		local radius = tonumber(args[1])
		local speakerChar = speaker.Character
		if not speakerChar or not getRoot(speakerChar) then return end
		for _,plr in pairs(Players:GetPlayers()) do
			if plr.Character and getRoot(plr.Character) then
				local magnitude = (getRoot(plr.Character).Position-getRoot(speakerChar).Position).magnitude
				if magnitude <= radius then table.insert(returns,plr) end
			end
		end
		return returns
	end,
	["cursor"] = function(speaker)
		local plrs = {}
		local v = GetClosestPlayerFromCursor()
		if v ~= nil then table.insert(plrs, v) end
		return plrs
	end,
	["npcs"] = function(speaker,args)
		local returns = {}
		for _, v in pairs(workspace:GetDescendants()) do
			if v:IsA("Model") and getRoot(v) and v:FindFirstChildWhichIsA("Humanoid") and Players:GetPlayerFromCharacter(v) == nil then
				local clone = Instance.new("Player")
				clone.Name = v.Name .. " - " .. v:FindFirstChildWhichIsA("Humanoid").DisplayName
				clone.Character = v
				table.insert(returns, clone)
			end
		end
		return returns
	end,
}

function toTokens(str)
	local tokens = {}
	for op,name in string.gmatch(str,"([+-])([^+-]+)") do
		table.insert(tokens,{Operator = op,Name = name})
	end
	return tokens
end



function getPlayer(list,speaker)
	if list == nil then return {speaker.Name} end
	local nameList = splitString(list,",")

	local foundList = {}

	for _,name in pairs(nameList) do
		if string.sub(name,1,1) ~= "+" and string.sub(name,1,1) ~= "-" then name = "+"..name end
		local tokens = toTokens(name)
		local initialPlayers = Players:GetPlayers()

		for i,v in pairs(tokens) do
			if v.Operator == "+" then
				local tokenContent = v.Name
				local foundCase = false
				for regex,case in pairs(SpecialPlayerCases) do
					local matches = {string.match(tokenContent,"^"..regex.."$")}
					if #matches > 0 then
						foundCase = true
						initialPlayers = onlyIncludeInTable(initialPlayers,case(speaker,matches,initialPlayers))
					end
				end
				if not foundCase then
					initialPlayers = onlyIncludeInTable(initialPlayers,getPlayersByName(tokenContent))
				end
			else
				local tokenContent = v.Name
				local foundCase = false
				for regex,case in pairs(SpecialPlayerCases) do
					local matches = {string.match(tokenContent,"^"..regex.."$")}
					if #matches > 0 then
						foundCase = true
						initialPlayers = removeTableMatches(initialPlayers,case(speaker,matches,initialPlayers))
					end
				end
				if not foundCase then
					initialPlayers = removeTableMatches(initialPlayers,getPlayersByName(tokenContent))
				end
			end
		end

		for i,v in pairs(initialPlayers) do table.insert(foundList,v) end
	end

	local foundNames = {}
	for i,v in pairs(foundList) do table.insert(foundNames,v.Name) end

	return foundNames
end



local lastBreakTime = 0
local cmdHistory = {}
local customAlias = {}
local lastCmds = {}
local historyCount = 0
local split=" "
local args = {...}
local PlaceId, JobId = game.PlaceId, game.JobId
local canOpenServerinfo = true
local sethidden = sethiddenproperty or set_hidden_property or set_hidden_prop
local gethidden = gethiddenproperty or get_hidden_property or get_hidden_prop
local PARENT = nil

local COREGUI = cloneref(game:GetService("CoreGui"))




function toClipboard(txt)
    if everyClipboard then
        everyClipboard(tostring(txt))
end
end

function splitString(str,delim)
	local broken = {}
	if delim == nil then delim = "," end
	for w in string.gmatch(str,"[^"..delim.."]+") do
		table.insert(broken,w)
	end
	return broken
end

findCmd=function(cmd_name)
	for i,v in pairs(cmds)do
		if v.NAME:lower()==cmd_name:lower() or FindInTable(v.ALIAS,cmd_name:lower()) then
			return v
		end
	end
	return customAlias[cmd_name:lower()]
end

function FindInTable(tbl,val)
	if tbl == nil then return false end
	for _,v in pairs(tbl) do
		if v == val then return true end
	end 
	return false
end


function execCmd(cmdStr,speaker,store)
	cmdStr = cmdStr:gsub("%s+$","")
	task.spawn(function()
		local rawCmdStr = cmdStr
		cmdStr = string.gsub(cmdStr,"\\\\","%%BackSlash%%")
		local commandsToRun = splitString(cmdStr,"\\")
		for i,v in pairs(commandsToRun) do
			v = string.gsub(v,"%%BackSlash%%","\\")
			local x,y,num = v:find("^(%d+)%^")
			local cmdDelay = 0
			local infTimes = false
			if num then
				v = v:sub(y+1)
				local x,y,del = v:find("^([%d%.]+)%^")
				if del then
					v = v:sub(y+1)
					cmdDelay = tonumber(del) or 0
				end
			else
				local x,y = v:find("^inf%^")
				if x then
					infTimes = true
					v = v:sub(y+1)
					local x,y,del = v:find("^([%d%.]+)%^")
					if del then
						v = v:sub(y+1)
						del = tonumber(del) or 1
						cmdDelay = (del > 0 and del or 1)
					else
						cmdDelay = 1
					end
				end
			end
			num = tonumber(num or 1)

			if v:sub(1,1) == "!" then
				local chunks = splitString(v:sub(2),split)
				if chunks[1] and lastCmds[chunks[1]] then v = lastCmds[chunks[1]] end
			end

			local args = splitString(v,split)
			local cmdName = args[1]
			local cmd = findCmd(cmdName)
			if cmd then
				table.remove(args,1)
				local cargs = args
				if not speaker then speaker = Players.LocalPlayer end
				if store then
					if speaker == Players.LocalPlayer then
						if cmdHistory[1] ~= rawCmdStr and rawCmdStr:sub(1,11) ~= 'lastcommand' and rawCmdStr:sub(1,7) ~= 'lastcmd' then
							table.insert(cmdHistory,1,rawCmdStr)
						end
					end
					if #cmdHistory > 30 then table.remove(cmdHistory) end

					lastCmds[cmdName] = v
				end
				local cmdStartTime = tick()
				if infTimes then
					while lastBreakTime < cmdStartTime do
						local success,err = pcall(cmd.FUNC,args, speaker)
						if not success and _G.IY_DEBUG then
							warn("Command Error:", cmdName, err)
						end
						wait(cmdDelay)
					end
				else
					for rep = 1,num do
						if lastBreakTime > cmdStartTime then break end
						local success,err = pcall(function()
							cmd.FUNC(args, speaker)
						end)
						if not success and _G.IY_DEBUG then
							warn("Command Error:", cmdName, err)
						end
						if cmdDelay ~= 0 then wait(cmdDelay) end
					end
				end
			end
		end
	end)
end	
local Rayfield = loadstring(game:HttpGet('https://sirius.menu/rayfield'))()
local Window = Rayfield:CreateWindow({
	Name = "Infinite Hub | Универсальная версия v1",
	Icon = 'infinity', -- Icon in Topbar. Can use Lucide Icons (string) or Roblox Image (number). 0 to use no icon (default).
	LoadingTitle = "Infinite Hub",
	LoadingSubtitle = "Загрузка...",
	Theme = "Default", -- Check https://docs.sirius.menu/rayfield/configuration/themes
 
	DisableRayfieldPrompts = true,
	DisableBuildWarnings = false, -- Prevents Rayfield from warning when the script has a version mismatch with the interface
 
	ConfigurationSaving = {
	   Enabled = false,
	   FolderName = nil, -- Create a custom folder for your hub/game
	   FileName = "Big Hub"
	},
 
	Discord = {
	   Enabled = false, -- Prompt the user to join your Discord server if their executor supports it
	   Invite = "noinvitelink", -- The Discord invite code, do not include discord.gg/. E.g. discord.gg/ ABCD would be ABCD
	   RememberJoins = true -- Set this to false to make them join the discord every time they load it up
	},
 
	KeySystem = false, -- Set this to true to use our key system
	KeySettings = {
	   Title = "Untitled",
	   Subtitle = "Key System",
	   Note = "No method of obtaining the key is provided", -- Use this to tell the user how to get a key
	   FileName = "Key", -- It is recommended to use something unique as other scripts using Rayfield may overwrite your key file
	   SaveKey = true, -- The user's key will be saved, but if you change the key, they will be unable to use your script
	   GrabKeyFromSite = false, -- If this is true, set Key below to the RAW site you would like Rayfield to get the key from
	   Key = {"Hello"} -- List of keys that will be accepted by the system, can be RAW file links (pastebin, github etc) or simple strings ("hello","key22")
	}
 })

 local MainTab = Window:CreateTab("Основное", 'binary') -- Title, Image
 local Button = MainTab:CreateButton({
	Name = "Телеграм",
	Callback = function()
		if everyClipboard then
			toClipboard('t.me/infinityhub_rbx')
			Rayfield:Notify({
			Title = "Infinite Hub | Телеграм",
			Content = "Скопировано в буфер обмена!\nt.me/infinityhub_rbx",
			Duration = 11,
			Image = "clipboard-copy",
		 })
		else
			Rayfield:Notify({
				Title = "Infinite Hub | Телеграм",
				Content = "t.me/infinityhub_rbx",
				Duration = 7.9,
				Image = "clipboard-copy",
			 })
		end
	end,
 })

 local Toggle = MainTab:CreateToggle({
	Name = "Роблокс консоль",
	CurrentValue = false,
	Flag = "Toggle1", -- A flag is the identifier for the configuration file, make sure every element has a different flag if you're using configuration saving to ensure no overlaps
	Callback = function(Value)
		StarterGui:SetCore("DevConsoleVisible", Value)
	end,
 })

 local Button = MainTab:CreateButton({
	Name = "Загрузить старую роблокс консоль",
	Callback = function()
	-- Спасибо wally!!
	
	local _, str = pcall(function()
		return game:HttpGet("https://raw.githubusercontent.com/infyiff/backup/main/console.lua", true)
	end)

	local s, e = loadstring(str)
	if typeof(s) ~= "function" then
		return
	end

	local success, message = pcall(s)
	if (not success) then
		if printconsole then
			printconsole(message)
		elseif printoutput then
			printoutput(message)
		end
	end
	wait(1)
	Rayfield:Notify({
		Title = "Infinite Hub | Консоль",
		Content = "Нажмите F9 что бы открыть консоль",
		Duration = 7.3,
		Image = "square-chevron-right",
	 })
	end,
 })

 local Button = MainTab:CreateButton({
	Name = "Открыть скрипт Dex Explorer",
	Callback = function()
		Rayfield:Notify({
			Title = "Infinite Hub | Загрузка",
			Content = "Подождите всего лишь секундочку! ;)",
			Duration = 2.8,
			Image = "loader",
		 })
		loadstring(game:HttpGet("https://raw.githubusercontent.com/infyiff/backup/main/dex.lua"))()
	end,
 })

 local Button = MainTab:CreateButton({
	Name = "Аудио логгер",
	Callback = function()
		Rayfield:Notify({
			Title = "Infinite Hub | Загрузка",
			Content = "Подождите всего лишь секундочку! ;)",
			Duration = 2.8,
			Image = "loader",
		 })
		loadstring(game:HttpGet(('https://raw.githubusercontent.com/infyiff/backup/main/audiologger.lua'),true))()
	end,
 })

 local Button = MainTab:CreateButton({
	Name = "Перезайти в плейс",
	Callback = function()
		
	end,
 })

 local Button = MainTab:CreateButton({
	Name = "Анти кик",
	Callback = function()
		GuiService.ErrorMessageChanged:Connect(function()
			if #Players:GetPlayers() <= 1 then
			Players.LocalPlayer:Kick("\nRejoining...")
			wait()
			TeleportService:Teleport(PlaceId, Players.LocalPlayer)
		else
			TeleportService:TeleportToPlaceInstance(PlaceId, JobId, Players.LocalPlayer)
		end
		end)
		Rayfield:Notify({
			Title = "Infinite Hub | Анти кик",
			Content = "Анти кик успешно включён!",
			Duration = 2.8,
			Image = "loader-circle",
		 })
	end,
 })

 local Button = MainTab:CreateButton({
	Name = "Перейти на другой сервер",
	Callback = function()
	 -- thanks to NoobSploit for fixing
	 if httprequest then
        local servers = {}
        local req = httprequest({Url = string.format("https://games.roblox.com/v1/games/%d/servers/Public?sortOrder=Desc&limit=100&excludeFullGames=true", PlaceId)})
        local body = HttpService:JSONDecode(req.Body)

        if body and body.data then
            for i, v in next, body.data do
                if type(v) == "table" and tonumber(v.playing) and tonumber(v.maxPlayers) and v.playing < v.maxPlayers and v.id ~= JobId then
                    table.insert(servers, 1, v.id)
                end
            end
        end

        if #servers > 0 then
            TeleportService:TeleportToPlaceInstance(PlaceId, servers[math.random(1, #servers)], Players.LocalPlayer)
        else
            return Rayfield:Notify({
				Title = "Infinite Hub | Переход на сервер",
				Content = "Не удалось найти сервер! :(",
				Duration = 3,
				Image = 'circle-x',
			 })
        end
    else
        Rayfield:Notify({
			Title = "Infinite Hub | Твой эксплоит",
			Content = "Твой эксплот не поддерживает эту функцию! :(",
			Duration = 3,
			Image = 'circle-x',
		 })
    end
	end,
 })

 local Button = MainTab:CreateButton({
	Name = "Анти-афк",
	Callback = function()
		local GC = getconnections or get_signal_cons
		if GC then
			for i,v in pairs(GC(Players.LocalPlayer.Idled)) do
				if v["Disable"] then
					v["Disable"](v)
				elseif v["Disconnect"] then
					v["Disconnect"](v)
				end
			end
		else
			local VirtualUser = cloneref(game:GetService("VirtualUser"))
			Players.LocalPlayer.Idled:Connect(function()
				VirtualUser:CaptureController()
				VirtualUser:ClickButton2(Vector2.new())
			end)
		end
		if not (args[1] and tostring(args[1]) == 'nonotify') then Rayfield:Notify({
			Title = "Infinite Hub | Анти афк",
			Content = "Анти афк включен.",
			Duration = 2.6,
			Image = "check",
		 }) end
	end,
 })

 local Button = MainTab:CreateButton({
	Name = "Закрыть меню",
	Callback = function()
		Rayfield:Destroy()
	end,
 })

 local Slider = MainTab:CreateSlider({
	Name = "Громкость роблокса",
	Range = {0, 10},
	Increment = 1,
	Suffix = "",
	CurrentValue = 6,
	Flag = "Slider1", -- A flag is the identifier for the configuration file, make sure every element has a different flag if you're using configuration saving to ensure no overlaps
	Callback = function(Value)
		UserSettings():GetService("UserGameSettings").MasterVolume = Value/10
	end,
 })

 local Button = MainTab:CreateButton({
	Name = "Буст фпс",
	Callback = function()
		local Terrain = workspace:FindFirstChildOfClass('Terrain')
		Terrain.WaterWaveSize = 0
		Terrain.WaterWaveSpeed = 0
		Terrain.WaterReflectance = 0
		Terrain.WaterTransparency = 0
		Lighting.GlobalShadows = false
		Lighting.FogEnd = 9e9
		settings().Rendering.QualityLevel = 1
		for i,v in pairs(game:GetDescendants()) do
			if v:IsA("Part") or v:IsA("UnionOperation") or v:IsA("MeshPart") or v:IsA("CornerWedgePart") or v:IsA("TrussPart") then
				v.Material = "Plastic"
				v.Reflectance = 0
			elseif v:IsA("Decal") then
				v.Transparency = 1
			elseif v:IsA("ParticleEmitter") or v:IsA("Trail") then
				v.Lifetime = NumberRange.new(0)
			elseif v:IsA("Explosion") then
				v.BlastPressure = 1
				v.BlastRadius = 1
			end
		end
		for i,v in pairs(Lighting:GetDescendants()) do
			if v:IsA("BlurEffect") or v:IsA("SunRaysEffect") or v:IsA("ColorCorrectionEffect") or v:IsA("BloomEffect") or v:IsA("DepthOfFieldEffect") then
				v.Enabled = false
			end
		end
		workspace.DescendantAdded:Connect(function(child)
			task.spawn(function()
				if child:IsA('ForceField') then
					RunService.Heartbeat:Wait()
					child:Destroy()
				elseif child:IsA('Sparkles') then
					RunService.Heartbeat:Wait()
					child:Destroy()
				elseif child:IsA('Smoke') or child:IsA('Fire') then
					RunService.Heartbeat:Wait()
					child:Destroy()
				end
			end)
		end)
	end,
 })

 local Button = MainTab:CreateButton({
	Name = "Закрыть роблокс",
	Callback = function()
	    game:Shutdown()
	end,
 })

 local Noclipping = nil
 local Button = MainTab:CreateButton({
	Name = "Ноуклип",
	Callback = function()
		Clip = false
	wait(0.1)
	local function NoclipLoop()
		if Clip == false and speaker.Character ~= nil then
			for _, child in pairs(speaker.Character:GetDescendants()) do
				if child:IsA("BasePart") and child.CanCollide == true and child.Name ~= floatName then
					child.CanCollide = false
				end
			end
		end
	end
	Noclipping = RunService.Stepped:Connect(NoclipLoop)
	if args[1] and args[1] == 'nonotify' then return end
		Rayfield:Notify({
			Title = "Infinite Hub | Ноуклип",
			Content = "Ноуклип включён.",
			Duration = 3,
			Image = "check",
		 })
	end,
 })

 local Button = MainTab:CreateButton({
	Name = "Выключить ноуклип",
	Callback = function()
		if Noclipping then
			Noclipping:Disconnect()
		end
		Clip = true
		Rayfield:Notify({
			Title = "Infinite Hub | Ноуклип",
			Content = "Ноуклип выключен.",
			Duration = 3,
			Image = "check",
		 })
	end,
 })

 local Section = MainTab:CreateSection("Если у вас не получается выключить ноуклип, нажимайте несколько раз")

 swimming = false
 local oldgrav = workspace.Gravity
 local swimbeat = nil

 local Button = MainTab:CreateButton({
	Name = "Плавать в воздухе",
	Callback = function()
		if not swimming and speaker and speaker.Character and speaker.Character:FindFirstChildWhichIsA("Humanoid") then
			oldgrav = workspace.Gravity
			workspace.Gravity = 0
			local swimDied = function()
				workspace.Gravity = oldgrav
				swimming = false
			end
			local Humanoid = speaker.Character:FindFirstChildWhichIsA("Humanoid")
			gravReset = Humanoid.Died:Connect(swimDied)
			local enums = Enum.HumanoidStateType:GetEnumItems()
			table.remove(enums, table.find(enums, Enum.HumanoidStateType.None))
			for i, v in pairs(enums) do
				Humanoid:SetStateEnabled(v, false)
			end
			Humanoid:ChangeState(Enum.HumanoidStateType.Swimming)
			swimbeat = RunService.Heartbeat:Connect(function()
				pcall(function()
					speaker.Character.HumanoidRootPart.Velocity = ((Humanoid.MoveDirection ~= Vector3.new() or UserInputService:IsKeyDown(Enum.KeyCode.Space)) and speaker.Character.HumanoidRootPart.Velocity or Vector3.new())
				end)
			end)
			swimming = true
		end	
	end,
 })

 local Button = MainTab:CreateButton({
	Name = "Не плавать в воздухе",
	Callback = function()
		if speaker and speaker.Character and speaker.Character:FindFirstChildWhichIsA("Humanoid") then
			workspace.Gravity = oldgrav
			swimming = false
			if gravReset then
				gravReset:Disconnect()
			end
			if swimbeat ~= nil then
				swimbeat:Disconnect()
				swimbeat = nil
			end
			local Humanoid = speaker.Character:FindFirstChildWhichIsA("Humanoid")
			local enums = Enum.HumanoidStateType:GetEnumItems()
			table.remove(enums, table.find(enums, Enum.HumanoidStateType.None))
			for i, v in pairs(enums) do
				Humanoid:SetStateEnabled(v, true)
			end
		end
	end,
 })

 local hiddenGUIS = {}
 local invisGUIS = {}
 
 local Button = MainTab:CreateButton({
	Name = "Спрятать все GUI",
	Callback = function()
		for i,v in pairs(speaker:FindFirstChildWhichIsA("PlayerGui"):GetDescendants()) do
			if (v:IsA("Frame") or v:IsA("ImageLabel") or v:IsA("ScrollingFrame")) and v.Visible then
				v.Visible = false
				if not FindInTable(hiddenGUIS,v) then
					table.insert(hiddenGUIS,v)
				end
			end
		end
	end,
 })

 local Button = MainTab:CreateButton({
	Name = "Показать все GUI",
	Callback = function()
		for i,v in pairs(speaker:FindFirstChildWhichIsA("PlayerGui"):GetDescendants()) do
			if (v:IsA("Frame") or v:IsA("ImageLabel") or v:IsA("ScrollingFrame")) and not v.Visible then
				v.Visible = true
				if not FindInTable(invisGUIS,v) then
					table.insert(invisGUIS,v)
				end
			end
		end
	end,
 })

 local Input = MainTab:CreateInput({
	Name = "Телепорт до игрока",
	CurrentValue = "Roblox",
	PlaceholderText = "",
	RemoveTextAfterFocusLost = false,
	Flag = "Input5",
	Callback = function(speaker)
		local players = getPlayer(args[1], speaker)
		for i,v in pairs(players)do
			if Players[v].Character ~= nil then
				if speaker.Character:FindFirstChildOfClass('Humanoid') and speaker.Character:FindFirstChildOfClass('Humanoid').SeatPart then
					speaker.Character:FindFirstChildOfClass('Humanoid').Sit = false
					wait(.1)
				end
				getRoot(speaker.Character).CFrame = getRoot(Players[v].Character).CFrame + Vector3.new(3,1,0)
			end
		end
	end,
 })

 








 Rayfield:Notify({
	Title = "Infinite Hub",
	Content = "Успешно загружено! Хорошей игры ;)",
	Duration = 4.2,
	Image = 'check',
 })
