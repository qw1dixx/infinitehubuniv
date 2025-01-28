local canOpenServerinfo = true
local sethidden = sethiddenproperty or set_hidden_property or set_hidden_prop
local gethidden = gethiddenproperty or get_hidden_property or get_hidden_prop
local PARENT = nil
local cloneref = cloneref or function(o) return o end
local COREGUI = cloneref(game:GetService("CoreGui"))
local Players = cloneref(game:GetService("Players"))
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
local Players = cloneref(game:GetService("Players"))
local currentVersion = "6.2"


function toClipboard(txt)
    if everyClipboard then
        everyClipboard(tostring(txt))
end
end
local Rayfield = loadstring(game:HttpGet('https://sirius.menu/rayfield'))()
local Window = Rayfield:CreateWindow({
	Name = "Infinite Hub | Универсальная версия v6.2",
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
	Name = "Старый Dex Explorer (нужно 100% unc)",
	Callback = function()
		Rayfield:Notify({
			Title = "Infinite Hub | Загрузка старого декса",
			Content = "Подождите всего лишь секундочку! ;)",
			Duration = 2.8,
			Image = "loader",
		 })

	local getobjects = function(a)
		local Objects = {}
		if a then
			local b = InsertService:LoadLocalAsset(a)
			if b then 
				table.insert(Objects, b) 
			end
		end
		return Objects
	end

	local Dex = getobjects("rbxassetid://10055842438")[1]
	Dex.Parent = PARENT

	local function Load(Obj, Url)
		local function GiveOwnGlobals(Func, Script)
			-- Fix for this edit of dex being poorly made
			-- I (Alex) would like to commemorate whoever added this dex in somehow finding the worst dex to ever exist
			local Fenv, RealFenv, FenvMt = {}, {
				script = Script,
				getupvalue = function(a, b)
					return nil -- force it to use globals
				end,
				getreg = function() -- It loops registry for some idiotic reason so stop it from doing that and just use a global
					return {} -- force it to use globals
				end,
				getprops = getprops or function(inst)
					if getproperties then
						local props = getproperties(inst)
						if props[1] and gethiddenproperty then
							local results = {}
							for _,name in pairs(props) do
								local success, res = pcall(gethiddenproperty, inst, name)
								if success then
									results[name] = res
								end
							end

							return results
						end

						return props
					end

					return {}
				end
			}, {}
			FenvMt.__index = function(a,b)
				return RealFenv[b] == nil and getgenv()[b] or RealFenv[b]
			end
			FenvMt.__newindex = function(a, b, c)
				if RealFenv[b] == nil then 
					getgenv()[b] = c 
				else 
					RealFenv[b] = c 
				end
			end
			setmetatable(Fenv, FenvMt)
			pcall(setfenv, Func, Fenv)
			return Func
		end

		local function LoadScripts(_, Script)
			if Script:IsA("LocalScript") then
				task.spawn(function()
					GiveOwnGlobals(loadstring(Script.Source,"="..Script:GetFullName()), Script)()
				end)
			end
			table.foreach(Script:GetChildren(), LoadScripts)
		end

		LoadScripts(nil, Obj)
	end

	Load(Dex)

	end,
 })

 local Button = MainTab:CreateButton({
	Name = "Remote Spy (слежка за событиями в игре, нужно 100% unc)",
	Callback = function()
		Rayfield:Notify({
			Title = "Infinite Hub | Загрузка",
			Content = "Подождите всего лишь секундочку! ;)",
			Duration = 2.8,
			Image = "loader",
		 })
	-- Спасибо exx, создателю SimpleSpy
	-- также спасибо NoobSploit за фикс
	loadstring(game:HttpGet("https://raw.githubusercontent.com/infyiff/backup/main/SimpleSpyV3/main.lua"))()
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













 Rayfield:Notify({
	Title = "Infinite Hub",
	Content = "Успешно загружено! Хорошей игры ;)",
	Duration = 4.2,
	Image = 'check',
 })