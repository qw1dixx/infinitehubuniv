currentVersion = "6.2"
local Rayfield = loadstring(game:HttpGet('https://sirius.menu/rayfield'))()
local Window = Rayfield:CreateWindow({
	Name = "Infinite Hub v" .. currentVersion,
	Icon = 'infinity', -- Icon in Topbar. Can use Lucide Icons (string) or Roblox Image (number). 0 to use no icon (default).
	LoadingTitle = "Infinite Hub",
	LoadingSubtitle = "Сделали: Moon и 156bored",
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
local IsOnMobile = table.find({Enum.Platform.IOS, Enum.Platform.Android}, UserInputService:GetPlatform())

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
UserInputService = cloneref(game:GetService("UserInputService"))
IYMouse = Players.LocalPlayer:GetMouse()
Lighting = cloneref(game:GetService("Lighting"))
RunService = cloneref(game:GetService("RunService"))

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

function deleteGuisAtPos()
	pcall(function()
		local guisAtPosition = Players.LocalPlayer.PlayerGui:GetGuiObjectsAtPosition(IYMouse.X, IYMouse.Y)
		for _, gui in pairs(guisAtPosition) do
			if gui.Visible == true then
				gui:Destroy()
			end
		end
	end)
end

function getRoot(char)
	local rootPart = char:FindFirstChild('HumanoidRootPart') or char:FindFirstChild('Torso') or char:FindFirstChild('UpperTorso')
	return rootPart
end

function randomString()
	local length = math.random(10,20)
	local array = {}
	for i = 1, length do
		array[i] = string.char(math.random(32, 126))
	end
	return table.concat(array)
end

function isNumber(str)
	if tonumber(str) ~= nil or str == 'inf' then
		return true
	end
end



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

 local Button = Tab:CreateButton({
	Name = "Вернуть предыдущее состояние GUI",
	Callback = function()
		for i,v in pairs(invisGUIS) do
			v.Visible = false
		end
		invisGUIS = {}
	end,
 })

 local hiddenGUIS = {}
 local Button = Tab:CreateButton({
	Name = "Спрятать GUI",
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

 local Button = Tab:CreateButton({
	Name = "Показать GUI",
	Callback = function()
		for i,v in pairs(hiddenGUIS) do
			v.Visible = true
		end
		hiddenGUIS = {}
	end,
 })

 local deleteGuiInput
 local Button = Tab:CreateButton({
	Name = "Удалить GUI",
	Callback = function()
		deleteGuiInput = UserInputService.InputBegan:Connect(function(input, gameProcessedEvent)
			if not gameProcessedEvent then
				if input.KeyCode == Enum.KeyCode.Backspace then
					deleteGuisAtPos()
				end
			end
		end)
		Rayfield:Notify({
			Title = "Удаление GUI включено",
			Content = "Наведите курсор на GUI и нажмите Backspace, чтобы удалить GUI",
			Duration = 10,
			Image = "pin",
		 })
	end,
 })

 local Button = Tab:CreateButton({
	Name = "Восстановить GUI",
	Callback = function()
		if deleteGuiInput then deleteGuiInput:Disconnect() end
		Rayfield:Notify({
			Title = "Удаление GUI выключено",
			Content = "GUI Восстановлено",
			Duration = 10,
			Image = "pin",
		 })
	end,
 })

 local Button = Tab:CreateButton({
	Name = "Закрыть Infinite Hub",
	Callback = function()
		Rayfield:Destroy()
	end,
 })

 local Button = Tab:CreateButton({
	Name = "Закрыть ошибку роблокса",
	Callback = function()
		GuiService:ClearError()
	end,
 })

 local Button = Tab:CreateButton({
	Name = "Буст ФПС",
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

 local Button = Tab:CreateButton({
	Name = "Запись экрана",
	Callback = function()
		return COREGUI:ToggleRecording()
	end,
 })

 local Button = Tab:CreateButton({
	Name = "Скриншот",
	Callback = function()
		return COREGUI:TakeScreenshot()
	end,
 })

 local Button = Tab:CreateButton({
	Name = "Выйти из роблокса",
	Callback = function()
		game:Shutdown()
	end,
 })

 FLYING = false
QEfly = true
iyflyspeed = 1
vehicleflyspeed = 1
function sFLY(vfly)
	repeat wait() until Players.LocalPlayer and Players.LocalPlayer.Character and getRoot(Players.LocalPlayer.Character) and Players.LocalPlayer.Character:FindFirstChildOfClass("Humanoid")
	repeat wait() until IYMouse
	if flyKeyDown or flyKeyUp then flyKeyDown:Disconnect() flyKeyUp:Disconnect() end

	local T = getRoot(Players.LocalPlayer.Character)
	local CONTROL = {F = 0, B = 0, L = 0, R = 0, Q = 0, E = 0}
	local lCONTROL = {F = 0, B = 0, L = 0, R = 0, Q = 0, E = 0}
	local SPEED = 0

	local function FLY()
		FLYING = true
		local BG = Instance.new('BodyGyro')
		local BV = Instance.new('BodyVelocity')
		BG.P = 9e4
		BG.Parent = T
		BV.Parent = T
		BG.maxTorque = Vector3.new(9e9, 9e9, 9e9)
		BG.cframe = T.CFrame
		BV.velocity = Vector3.new(0, 0, 0)
		BV.maxForce = Vector3.new(9e9, 9e9, 9e9)
		task.spawn(function()
			repeat wait()
				if not vfly and Players.LocalPlayer.Character:FindFirstChildOfClass('Humanoid') then
					Players.LocalPlayer.Character:FindFirstChildOfClass('Humanoid').PlatformStand = true
				end
				if CONTROL.L + CONTROL.R ~= 0 or CONTROL.F + CONTROL.B ~= 0 or CONTROL.Q + CONTROL.E ~= 0 then
					SPEED = 50
				elseif not (CONTROL.L + CONTROL.R ~= 0 or CONTROL.F + CONTROL.B ~= 0 or CONTROL.Q + CONTROL.E ~= 0) and SPEED ~= 0 then
					SPEED = 0
				end
				if (CONTROL.L + CONTROL.R) ~= 0 or (CONTROL.F + CONTROL.B) ~= 0 or (CONTROL.Q + CONTROL.E) ~= 0 then
					BV.velocity = ((workspace.CurrentCamera.CoordinateFrame.lookVector * (CONTROL.F + CONTROL.B)) + ((workspace.CurrentCamera.CoordinateFrame * CFrame.new(CONTROL.L + CONTROL.R, (CONTROL.F + CONTROL.B + CONTROL.Q + CONTROL.E) * 0.2, 0).p) - workspace.CurrentCamera.CoordinateFrame.p)) * SPEED
					lCONTROL = {F = CONTROL.F, B = CONTROL.B, L = CONTROL.L, R = CONTROL.R}
				elseif (CONTROL.L + CONTROL.R) == 0 and (CONTROL.F + CONTROL.B) == 0 and (CONTROL.Q + CONTROL.E) == 0 and SPEED ~= 0 then
					BV.velocity = ((workspace.CurrentCamera.CoordinateFrame.lookVector * (lCONTROL.F + lCONTROL.B)) + ((workspace.CurrentCamera.CoordinateFrame * CFrame.new(lCONTROL.L + lCONTROL.R, (lCONTROL.F + lCONTROL.B + CONTROL.Q + CONTROL.E) * 0.2, 0).p) - workspace.CurrentCamera.CoordinateFrame.p)) * SPEED
				else
					BV.velocity = Vector3.new(0, 0, 0)
				end
				BG.cframe = workspace.CurrentCamera.CoordinateFrame
			until not FLYING
			CONTROL = {F = 0, B = 0, L = 0, R = 0, Q = 0, E = 0}
			lCONTROL = {F = 0, B = 0, L = 0, R = 0, Q = 0, E = 0}
			SPEED = 0
			BG:Destroy()
			BV:Destroy()
			if Players.LocalPlayer.Character:FindFirstChildOfClass('Humanoid') then
				Players.LocalPlayer.Character:FindFirstChildOfClass('Humanoid').PlatformStand = false
			end
		end)
	end
	flyKeyDown = IYMouse.KeyDown:Connect(function(KEY)
		if KEY:lower() == 'w' then
			CONTROL.F = (vfly and vehicleflyspeed or iyflyspeed)
		elseif KEY:lower() == 's' then
			CONTROL.B = - (vfly and vehicleflyspeed or iyflyspeed)
		elseif KEY:lower() == 'a' then
			CONTROL.L = - (vfly and vehicleflyspeed or iyflyspeed)
		elseif KEY:lower() == 'd' then 
			CONTROL.R = (vfly and vehicleflyspeed or iyflyspeed)
		elseif QEfly and KEY:lower() == 'e' then
			CONTROL.Q = (vfly and vehicleflyspeed or iyflyspeed)*2
		elseif QEfly and KEY:lower() == 'q' then
			CONTROL.E = -(vfly and vehicleflyspeed or iyflyspeed)*2
		end
		pcall(function() workspace.CurrentCamera.CameraType = Enum.CameraType.Track end)
	end)
	flyKeyUp = IYMouse.KeyUp:Connect(function(KEY)
		if KEY:lower() == 'w' then
			CONTROL.F = 0
		elseif KEY:lower() == 's' then
			CONTROL.B = 0
		elseif KEY:lower() == 'a' then
			CONTROL.L = 0
		elseif KEY:lower() == 'd' then
			CONTROL.R = 0
		elseif KEY:lower() == 'e' then
			CONTROL.Q = 0
		elseif KEY:lower() == 'q' then
			CONTROL.E = 0
		end
	end)
	FLY()
end

function NOFLY()
	FLYING = false
	if flyKeyDown or flyKeyUp then flyKeyDown:Disconnect() flyKeyUp:Disconnect() end
	if Players.LocalPlayer.Character:FindFirstChildOfClass('Humanoid') then
		Players.LocalPlayer.Character:FindFirstChildOfClass('Humanoid').PlatformStand = false
	end
	pcall(function() workspace.CurrentCamera.CameraType = Enum.CameraType.Custom end)
end

local velocityHandlerName = randomString()
local gyroHandlerName = randomString()
local mfly1
local mfly2

local unmobilefly = function(speaker)
	pcall(function()
		FLYING = false
		local root = getRoot(speaker.Character)
		root:FindFirstChild(velocityHandlerName):Destroy()
		root:FindFirstChild(gyroHandlerName):Destroy()
		speaker.Character:FindFirstChildWhichIsA("Humanoid").PlatformStand = false
		mfly1:Disconnect()
		mfly2:Disconnect()
	end)
end

local mobilefly = function(speaker, vfly)
	unmobilefly(speaker)
	FLYING = true

	local root = getRoot(speaker.Character)
	local camera = workspace.CurrentCamera
	local v3none = Vector3.new()
	local v3zero = Vector3.new(0, 0, 0)
	local v3inf = Vector3.new(9e9, 9e9, 9e9)

	local controlModule = require(speaker.PlayerScripts:WaitForChild("PlayerModule"):WaitForChild("ControlModule"))
	local bv = Instance.new("BodyVelocity")
	bv.Name = velocityHandlerName
	bv.Parent = root
	bv.MaxForce = v3zero
	bv.Velocity = v3zero

	local bg = Instance.new("BodyGyro")
	bg.Name = gyroHandlerName
	bg.Parent = root
	bg.MaxTorque = v3inf
	bg.P = 1000
	bg.D = 50

	mfly1 = speaker.CharacterAdded:Connect(function()
		local bv = Instance.new("BodyVelocity")
		bv.Name = velocityHandlerName
		bv.Parent = root
		bv.MaxForce = v3zero
		bv.Velocity = v3zero

		local bg = Instance.new("BodyGyro")
		bg.Name = gyroHandlerName
		bg.Parent = root
		bg.MaxTorque = v3inf
		bg.P = 1000
		bg.D = 50
	end)

	mfly2 = RunService.RenderStepped:Connect(function()
		root = getRoot(speaker.Character)
		camera = workspace.CurrentCamera
		if speaker.Character:FindFirstChildWhichIsA("Humanoid") and root and root:FindFirstChild(velocityHandlerName) and root:FindFirstChild(gyroHandlerName) then
			local humanoid = speaker.Character:FindFirstChildWhichIsA("Humanoid")
			local VelocityHandler = root:FindFirstChild(velocityHandlerName)
			local GyroHandler = root:FindFirstChild(gyroHandlerName)

			VelocityHandler.MaxForce = v3inf
			GyroHandler.MaxTorque = v3inf
			if not vfly then humanoid.PlatformStand = true end
			GyroHandler.CFrame = camera.CoordinateFrame
			VelocityHandler.Velocity = v3none

			local direction = controlModule:GetMoveVector()
			if direction.X > 0 then
				VelocityHandler.Velocity = VelocityHandler.Velocity + camera.CFrame.RightVector * (direction.X * ((vfly and vehicleflyspeed or iyflyspeed) * 50))
			end
			if direction.X < 0 then
				VelocityHandler.Velocity = VelocityHandler.Velocity + camera.CFrame.RightVector * (direction.X * ((vfly and vehicleflyspeed or iyflyspeed) * 50))
			end
			if direction.Z > 0 then
				VelocityHandler.Velocity = VelocityHandler.Velocity - camera.CFrame.LookVector * (direction.Z * ((vfly and vehicleflyspeed or iyflyspeed) * 50))
			end
			if direction.Z < 0 then
				VelocityHandler.Velocity = VelocityHandler.Velocity - camera.CFrame.LookVector * (direction.Z * ((vfly and vehicleflyspeed or iyflyspeed) * 50))
			end
		end
	end)
end
 
 local Button = Tab:CreateButton({
	Name = "Летать",
	Callback = function()
		if not IsOnMobile then
			NOFLY()
			wait()
			sFLY()
		else
			mobilefly(speaker)
		end
		if args[1] and isNumber(args[1]) then
			iyflyspeed = args[1]
		end
	end,
 })
