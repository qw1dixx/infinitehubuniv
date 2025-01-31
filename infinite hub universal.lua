currentVersion = "6.2"
local Rayfield = loadstring(game:HttpGet('https://sirius.menu/rayfield'))()
local Window = Rayfield:CreateWindow({
	Name = "Infinite Hub v" .. currentVersion,
	Icon = 'infinity', -- Icon in Topbar. Can use Lucide Icons (string) or Roblox Image (number). 0 to use no icon (default).
	LoadingTitle = "Infinite Hub",
	LoadingSubtitle = "Сделали: Moon и 156memories",
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
-- локалы
local cloneref = cloneref or function(o) return o end
local args = {...}
local split=" "
local lastCmds = {}
local lastBreakTime = 0
local invisGUIS = {}

-- переменные
everyClipboard = setclipboard or toclipboard or set_clipboard or (Clipboard and Clipboard.set)
httprequest = (syn and syn.request) or (http and http.request) or http_request or (fluxus and fluxus.request) or request
HttpService = cloneref(game:GetService("HttpService"))
StarterGui = cloneref(game:GetService("StarterGui"))
InsertService = cloneref(game:GetService("InsertService"))
sethidden = sethiddenproperty or set_hidden_property or set_hidden_prop
gethidden = gethiddenproperty or get_hidden_property or get_hidden_prop
PlaceId, JobId = game.PlaceId, game.JobId
Players = cloneref(game:GetService("Players"))
TeleportService = cloneref(game:GetService("TeleportService"))
GuiService = cloneref(game:GetService("GuiService"))
GroupService = cloneref(game:GetService("GroupService"))
speaker = Players.LocalPlayer
cmds={}
cmdHistory = {}
customAlias = {}
COREGUI = cloneref(game:GetService("CoreGui"))

-- функции
function toClipboard(txt)
    if everyClipboard then
        everyClipboard(tostring(txt))
        Rayfield:Notify({
			Title = "Буфер обмена",
			Content = "Скопировано в буфер обмена",
			Duration = 10,
			Image = "pin",
		 })
    else
        Rayfield:Notify({
			Title = "Буфер обмена",
			Content = "Твой эксплойт не имеет возможности использовать буфер обмена",
			Duration = 10,
			Image = "pin",
		 })
    end
end

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
, {}



 local Tab = Window:CreateTab("Infinite Hub", 'infinity') -- Title, Image

 local Button = Tab:CreateButton({
	Name = "Телеграм / поддержка / помощь",
	Callback = function()
		if everyClipboard then
			toClipboard('t.me/infinityhub_rbx')
			Rayfield:Notify({
				Title = "Телеграм приглашение",
				Content = "Скопировано в буфер обмена!\nt.me/infinityhub_rbx",
				Duration = 10,
				Image = "pin",
			 })
		else
			Rayfield:Notify({
				Title = "Телеграм приглашение",
				Content = "t.me/infinityhub_rbx",
				Duration = 10,
				Image = "pin",
			 })
		end
		if httprequest then
			httprequest({
				Url = 'http://127.0.0.1:6463/rpc?v=1',
				Method = 'POST',
				Headers = {
					['Content-Type'] = 'application/json',
					Origin = 't.me'
				},
				Body = HttpService:JSONEncode({
					cmd = 'INVITE_BROWSER',
					nonce = HttpService:GenerateGUID(false),
					args = {code = 'infinityhub_rbx'}
				})
			})
		end
	end,
 })

 function splitString(str,delim)
	local broken = {}
	if delim == nil then delim = "," end
	for w in string.gmatch(str,"[^"..delim.."]+") do
		table.insert(broken,w)
	end
	return broken
end
 
function FindInTable(tbl,val)
	if tbl == nil then return false end
	for _,v in pairs(tbl) do
		if v == val then return true end
	end 
	return false
end


findCmd=function(cmd_name)
	for i,v in pairs(cmds)do
		if v.NAME:lower()==cmd_name:lower() or FindInTable(v.ALIAS,cmd_name:lower()) then
			return v
		end
	end
	return customAlias[cmd_name:lower()]
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
				cargs = args
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

 local Button = Tab:CreateButton({
	Name = "Консоль",
	Callback = function()
		StarterGui:SetCore("DevConsoleVisible", true)
	end,
 })

 local Button = Tab:CreateButton({
	Name = "Старая консоль",
	Callback = function()
		-- Thanks wally!!
		Rayfield:Notify({
			Title = "Загрузка",
			Content = "Подождите секунду",
			Duration = 10,
			Image = "pin",
		 })
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
		Title = "Консоль",
		Content = "Нажми F9 что бы открыть консоль",
		Duration = 10,
		Image = "pin",
	 })
	end,
 })

 local Button = Tab:CreateButton({
	Name = "Dex Explorer",
	Callback = function()
		Rayfield:Notify({
			Title = "Загрузка",
			Content = "Подождите секунду",
			Duration = 10,
			Image = "pin",
		 })
		loadstring(game:HttpGet("https://raw.githubusercontent.com/infyiff/backup/main/dex.lua"))()
	end,
 })

 local Button = Tab:CreateButton({
	Name = "Remote Spy",
	Callback = function()
		Rayfield:Notify({
			Title = "Загрузка",
			Content = "Подождите секунду",
			Duration = 10,
			Image = "pin",
		 })
	-- Full credit to exx, creator of SimpleSpy
	-- also thanks to NoobSploit for fixing
	loadstring(game:HttpGet("https://raw.githubusercontent.com/infyiff/backup/main/SimpleSpyV3/main.lua"))()
	end,
 })

 local Button = Tab:CreateButton({
	Name = "Аудио логгер",
	Callback = function()
		Rayfield:Notify({
			Title = "Загрузка",
			Content = "Подождите секунду",
			Duration = 10,
			Image = "pin",
		 })
	loadstring(game:HttpGet(('https://raw.githubusercontent.com/infyiff/backup/main/audiologger.lua'),true))()
	end,
 })

 local Button = Tab:CreateButton({
	Name = "JobId сервера",
	Callback = function()
		local jobId = 'Roblox.GameLauncher.joinGameInstance('..PlaceId..', "'..JobId..'")'
		toClipboard(jobId)
	end,
 })

 local Button = Tab:CreateButton({
	Name = "JobId и PlaceId сервера в сообщении",
	Callback = function()
		Rayfield:Notify({
			Title = "JobId / PlaceId",
			Content = JobId..' / '..PlaceId,
			Duration = 10,
			Image = "pin",
		 })
	end,
 })

 local Button = Tab:CreateButton({
	Name = "Перезайти в плейс",
	Callback = function()
		if #Players:GetPlayers() <= 1 then
			Players.LocalPlayer:Kick("\nПерезаходим...")
			wait()
			TeleportService:Teleport(PlaceId, Players.LocalPlayer)
		else
			TeleportService:TeleportToPlaceInstance(PlaceId, JobId, Players.LocalPlayer)
		end
	end,
 })

 local Button = Tab:CreateButton({
	Name = "Анти кик",
	Callback = function()
		GuiService.ErrorMessageChanged:Connect(function()
			if #Players:GetPlayers() <= 1 then
				Players.LocalPlayer:Kick("\nПерезаходим...")
				wait()
				TeleportService:Teleport(PlaceId, Players.LocalPlayer)
			else
				TeleportService:TeleportToPlaceInstance(PlaceId, JobId, Players.LocalPlayer)
			end
		end)
		Rayfield:Notify({
			Title = "Анти кик",
			Content = 'Анти кик включен',
			Duration = 10,
			Image = "pin",
		 })
	end,
 })

 local Button = Tab:CreateButton({
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
				Title = "Переход на другой сервер",
				Content = 'Сервер не найден.',
				Duration = 10,
				Image = "pin",
			 })
        end
    else
        Rayfield:Notify({
			Title = "Неподдерживаемый эксплоит",
			Content = 'Твой эксплоит не поддерживает httprequest (функцию).',
			Duration = 10,
			Image = "pin",
		 })
    end
	end,
 })

 local Button = Tab:CreateButton({
	Name = "Анти афк",
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
			Title = "Анти афк",
			Content = 'Анти афк включен',
			Duration = 10,
			Image = "pin",
		 }) end
	end,
 })

 local Button = Tab:CreateButton({
	Name = "ID аккаунта создателя плейса",
	Callback = function()
		if game.CreatorType == Enum.CreatorType.User then
			Rayfield:Notify({
				Title = "ID создателя",
				Content = game.CreatorId,
				Duration = 10,
				Image = "pin",
			 })
		elseif game.CreatorType == Enum.CreatorType.Group then
			local OwnerID = GroupService:GetGroupInfoAsync(game.CreatorId).Owner.Id
			speaker.UserId = OwnerID
			Rayfield:Notify({
				Title = "ID создателя",
				Content = OwnerID,
				Duration = 10,
				Image = "pin",
			 })
		end
	end,
 })

 local Button = Tab:CreateButton({
	Name = "Анти покупка пассов",
	Callback = function()
    COREGUI.PurchasePrompt.Enabled = false
	end,
 })

local Button = Tab:CreateButton({
	Name = "Вернуть возможность покупки пассов",
	Callback = function()
    COREGUI.PurchasePrompt.Enabled = true
	end,
 })

 local Button = Tab:CreateButton({
	Name = "Видеть все невидимые объекты GUI",
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

 local Tab1 = Window:CreateTab("для кирилла из паровозика", 'train-front') -- Title, Image

 xrayEnabled = false
xray = function()
	for _, v in pairs(workspace:GetDescendants()) do
        if v:IsA("BasePart") and not v.Parent:FindFirstChildWhichIsA("Humanoid") and not v.Parent.Parent:FindFirstChildWhichIsA("Humanoid") then
            v.LocalTransparencyModifier = xrayEnabled and 0.5 or 0
        end
    end
end
 
 local Button = Tab1:CreateButton({
	Name = "X-Ray",
	Callback = function()
		xrayEnabled = true
		xray()
	end,
 })

 local Button = Tab1:CreateButton({
	Name = "Выключить X-Ray",
	Callback = function()
		xrayEnabled = false
		xray()
	end,
 })
