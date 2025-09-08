if not game.Players.LocalPlayer.Team then game.ReplicatedStorage.Remotes.CommF_:InvokeServer("SetTeam", getgenv().Team or "Pirates") end
repeat wait() until game.Players.LocalPlayer.Team
if game.PlaceId == 2753915549 then
        World1 = true
    elseif game.PlaceId == 4442272183 then
        World2 = true
    elseif game.PlaceId == 7449423635 then
        World3 = true
    else
    game:GetService("Players").LocalPlayer:Kick("This Game Is Not Support [ Nexon Hub ]")
  end 
  
if not game:GetService("Workspace").Map:FindFirstChild("Temple of Time") and World3 then
game.ReplicatedStorage.MapStash["Temple of Time"].Parent = workspace.Map
end

loadstring(game:HttpGet("https://raw.githubusercontent.com/NHMdz/Chest-farm/refs/heads/main/CheckQuest.lua"))()

function AutoHaki()
  if game:GetService("Players").LocalPlayer.Character and not game:GetService("Players").LocalPlayer.Character:FindFirstChild("HasBuso") then
     game:GetService("ReplicatedStorage").Remotes.CommF_:InvokeServer("Buso") 
  end
end
    
function EquipWeapon(w) --// equip 
	pcall(function()
		for i,v in pairs(game.Players.LocalPlayer.Backpack:GetChildren()) do
			if v.ToolTip == w then
				local ToolHumanoid = game.Players.LocalPlayer.Backpack:FindFirstChild(v.Name) 
				game.Players.LocalPlayer.Character.Humanoid:EquipTool(ToolHumanoid) 
			end
		end
	end)
end
  
function GetFruitUnder1()
	local fruitList = {
		["Rocket-Rocket"] = true,
		["Spin-Spin"] = true,
		["Blade-Blade"] = true,
		["Spring-Spring"] = true,
		["Bomb-Bomb"] = true,
		["Smoke-Smoke"] = true,
		["Spike-Spike"] = true,
		["Flame-Flame"] = true,
		["Eagle-Eagle"] = true,
		["Ice-Ice"] = true,
		["Sand-Sand"] = true,
		["Dark-Dark"] = true,
		["Ghost-Ghost"] = true,
		["Diamond-Diamond"] = true,
		["Light-Light"] = true,
		["Rubber-Rubber"] = true,
		["Magma-Magma"] = true
	}

	local fruit = game:GetService("ReplicatedStorage").Remotes.CommF_:InvokeServer("getInventory")
	if not fruit then return false end

	for _, v in pairs(fruit) do
		if v.Type == "Blox Fruit" then
			print("[Debug] Blox Fruit: " .. tostring(v.Name))
			if fruitList[v.Name] then
				local success = pcall(function()
					game:GetService("ReplicatedStorage").Remotes.CommF_:InvokeServer("LoadFruit", v.Name)
				end)
				if success then
					print("[Debug] Đã load trái: " .. v.Name)
					return true
				end
			end
		end
	end

	return false
end

function GetDistance(target)
        return math.floor((target.Position - game.Players.LocalPlayer.Character.HumanoidRootPart.Position).Magnitude)
    end
    
    function BTP(p)
    	pcall(function()
	    	if (p.Position-game.Players.LocalPlayer.Character.HumanoidRootPart.Position).Magnitude >= 1500 and not Auto_Raid and game.Players.LocalPlayer.Character.Humanoid.Health > 0 then
				repeat wait()
					game.Players.LocalPlayer.Character.HumanoidRootPart.CFrame = p
					wait(0.5)
					game.Players.LocalPlayer.Character.Head:Destroy()
					game.Players.LocalPlayer.Character.HumanoidRootPart.CFrame = p
				until (p.Position-game.Players.LocalPlayer.Character.HumanoidRootPart.Position).Magnitude < 1500 and game.Players.LocalPlayer.Character.Humanoid.Health > 0
			end
		end)
	end
    function TP(Pos)
        Distance = (Pos.Position - game:GetService("Players").LocalPlayer.Character.HumanoidRootPart.Position).Magnitude
        if Distance < 300 then
            Speed = 300
        elseif Distance >= 1000 then
            Speed = 300
        end
        game:GetService("TweenService"):Create(
            game:GetService("Players").LocalPlayer.Character.HumanoidRootPart,
            TweenInfo.new(Distance/Speed, Enum.EasingStyle.Linear),
            {CFrame = Pos}
        ):Play()
        _G.Clip = true
        wait(Distance/Speed)
        _G.Clip = false
    end

local w = game.PlaceId
local distbyp = (w == 2753915549 and 1500) or (w == 4442272183 and 3500) or (w == 7449423635 and 6000)
local gQ = (w == 2753915549 and {
    Vector3.new(-7894.6201171875, 5545.49169921875, -380.246346191406),
    Vector3.new(-4607.82275390625, 872.5422973632812, -1667.556884765625),
    Vector3.new(61163.8515625, 11.759522438049316, 1819.7841796875),
    Vector3.new(3876.280517578125, 35.10614013671875, -1939.3201904296875)
}) or (w == 4442272183 and {
    Vector3.new(-288.46246337890625, 306.130615234375, 597.9988403320312),
    Vector3.new(2284.912109375, 15.152046203613281, 905.48291015625),
    Vector3.new(923.21252441406, 126.9760055542, 32852.83203125),
    Vector3.new(-6508.5581054688, 89.034996032715, -132.83953857422)
}) or (w == 7449423635 and {
    Vector3.new(-5058.77490234375, 314.5155029296875, -3155.88330078125),
    Vector3.new(5661.5302734375, 1013.3587036132812, -334.9619140625),
    Vector3.new(-12463.8740234375, 374.9144592285156, -7523.77392578125)
})

local lp = game.Players.LocalPlayer
local rs = game.ReplicatedStorage
local ts = game:GetService("TweenService")

getgenv().Bounty = getgenv().Bounty or {}
Bounty.CurrentTween = nil
Bounty.IsMoving = false

local function getPortal(pos)
    if not pos or not gQ then return nil end
    local closest, dist = nil, math.huge
    for _, p in ipairs(gQ) do
        local mag = (p - pos.Position).Magnitude
        if mag < dist then
            closest, dist = p, mag
        end
    end
    return closest
end

local function requestEntrance(aJ)
    local success = false
    for i = 1, 2 do
        rs.Remotes.CommF_:InvokeServer("requestEntrance", aJ)
        local hrp = lp.Character and lp.Character:FindFirstChild("HumanoidRootPart")
        if hrp then
            hrp.CFrame = CFrame.new(hrp.Position.X, hrp.Position.Y - 30, hrp.Position.Z)
        end
        task.wait(0.6)
        local hrpCheck = lp.Character and lp.Character:FindFirstChild("HumanoidRootPart")
        if hrpCheck and (aJ - hrpCheck.Position).Magnitude < 100 then
            success = true
            break
        end
    end
    return success
end

local function calcpos(a, b)
    if not a then return math.huge end
    if typeof(a) == "CFrame" then a = a.Position end
    if typeof(b) == "CFrame" then b = b.Position end
    b = b or (lp.Character and lp.Character.PrimaryPart and lp.Character.PrimaryPart.Position) or Vector3.new()
    return (Vector3.new(a.X, 0, a.Z) - Vector3.new(b.X, 0, b.Z)).Magnitude
end

local function checkInventory(name)
    local inv = rs.Remotes.CommF_:InvokeServer("getInventory")
    for _, item in ipairs(inv) do
        if item.Name == name then
            return true
        end
    end
    return false
end

function CheckBoss(name, mode)
    local targets = typeof(name) == "table" and name or {name}
    for _, parent in ipairs({rs, workspace.Enemies}) do
        for _, v in ipairs(parent:GetChildren()) do
            if v:IsA("Model") and table.find(targets, v.Name) then
                local h = v:FindFirstChildWhichIsA("Humanoid")
                if h and h.Health > 0 then
                    return mode == "CF" and v:GetPivot() or v
                end
            end
        end
    end
end

function topos(Pos)
    local char = lp.Character
    if not char then return false end
    local hrp = char:FindFirstChild("HumanoidRootPart")
    local hum = char:FindFirstChildOfClass("Humanoid")
    getgenv().Kill = false
    if not hrp or not hum or hum.Health <= 0 then return false end
    if Bounty.CurrentTween and getgenv().Loaded then
        Bounty.CurrentTween:Cancel()
        Bounty.CurrentTween = nil
    end
    local myCFrame = hrp.CFrame
    local distToPos = calcpos(Pos, myCFrame)
    if distToPos <= 200 and getgenv().Loaded then
        hrp.CFrame = Pos
        return true
    end
    local portal = getPortal(hrp)
    local distToPortal = portal and calcpos(portal, myCFrame) or math.huge
    local distPortalToPos = portal and calcpos(Pos, portal) or math.huge
    if not getgenv().Kill and portal and distToPos > distbyp and distPortalToPos < distToPos and (World1 or World2 or (World3 and checkInventory("Valkyrie Helm"))) and getgenv().Loaded then
        requestEntrance(portal)
        task.wait(0.3)
        local hrpCheck = lp.Character and lp.Character:FindFirstChild("HumanoidRootPart")
        if hrpCheck and (portal - hrpCheck.Position).Magnitude <= 100 then
            return true
        end
    end
    if getgenv().Loaded and Pos then
        local speed = getgenv().Config and getgenv().Config.Setting and getgenv().Config.Setting["Tween Speed"] or 300
        local tweenTime = math.max(0.1, distToPos / speed)
        Bounty.IsMoving = true
        local tweenInfo = TweenInfo.new(tweenTime, Enum.EasingStyle.Linear)
        Bounty.CurrentTween = ts:Create(hrp, tweenInfo, { CFrame = Pos })
        Bounty.CurrentTween.Completed:Connect(function()
            Bounty.IsMoving = false
            Bounty.CurrentTween = nil
        end)
        Bounty.CurrentTween:Play()
        return true
    end
end
    
    game:GetService("Players").LocalPlayer.Idled:connect(function()
        game:GetService("VirtualUser"):Button2Down(Vector2.new(0,0),workspace.CurrentCamera.CFrame)
        wait(1)
        game:GetService("VirtualUser"):Button2Up(Vector2.new(0,0),workspace.CurrentCamera.CFrame)
    end) 

local PlayerName = game.Players.LocalPlayer.DisplayName
require(game.ReplicatedStorage.Notification).new("<Color=Blue>" ..PlayerName.. "<Color=/>"):Display()

--//macdinh 
AutoHaki()

function GetCountMaterials(materialName)
    local inventory = game:GetService("ReplicatedStorage").Remotes.CommF_:InvokeServer("getInventory")
    for _, item in pairs(inventory) do
        if item.Name == materialName then
            return item["Count"]
        end
    end
    return 0
end

function Hopl()
    game.StarterGui:SetCore("SendNotification", {
        Title = "ndayeuem",
        Text = "Hopping...",
        Duration = 3,
        Icon = "rbxassetid://90131637613962"
    })
    local PlaceID = game.PlaceId
    local AllIDs = {}
    local foundAnything = ""
    local actualHour = os.date("!*t").hour
    local Deleted = false
    local isTeleporting = false
    local function bQ(v)
        if v.Name == "ErrorPrompt" then
            if v.Visible then
                if v.TitleFrame.ErrorTitle.Text == "Teleport Failed" then
                    v.Visible = false
                end
            end
            v:GetPropertyChangedSignal("Visible"):Connect(function()
                if v.Visible then
                    if v.TitleFrame.ErrorTitle.Text == "Teleport Failed" then
                        v.Visible = false
                    end
                end
            end)
        end
    end
    for i, v in pairs(game.CoreGui.RobloxPromptGui.promptOverlay:GetChildren()) do
        bQ(v)
    end
    game.CoreGui.RobloxPromptGui.promptOverlay.ChildAdded:Connect(bQ)
    local function TPReturner()
        if isTeleporting then return end
        local Site
        if foundAnything == "" then
            Site = game.HttpService:JSONDecode(game:HttpGet('https://games.roblox.com/v1/games/' .. PlaceID .. '/servers/Public?sortOrder=Asc&limit=100'))
        else
            Site = game.HttpService:JSONDecode(game:HttpGet('https://games.roblox.com/v1/games/' .. PlaceID .. '/servers/Public?sortOrder=Asc&limit=100&cursor=' .. foundAnything))
        end
        local ID = ""
        if Site.nextPageCursor and Site.nextPageCursor ~= "null" and Site.nextPageCursor ~= nil then
            foundAnything = Site.nextPageCursor
        end
        local num = 0
        local serverList = {}
        for i, v in pairs(Site.data) do
            local Possible = true
            ID = tostring(v.id)
            if tonumber(v.maxPlayers) > tonumber(v.playing) then
                for i2, Existing in pairs(AllIDs) do
                    if num ~= 0 then
                        if ID == tostring(Existing) then
                            Possible = false
                        end
                    else
                        if tonumber(actualHour) ~= tonumber(Existing) then
                            AllIDs = {}
                            table.insert(AllIDs, actualHour)
                        end
                    end
                    num = num + 1
                end
                if Possible == true then
                    table.insert(serverList, {id = ID, players = tonumber(v.playing)})
                end
            end
        end
        
        table.sort(serverList, function(a, b)
            return a.players < b.players
        end)
        
        if #serverList > 0 then
            local selectedServer = serverList[1]
            table.insert(AllIDs, selectedServer.id)
            isTeleporting = true
            pcall(function()
                game:GetService("TeleportService"):TeleportToPlaceInstance(PlaceID, selectedServer.id, game:GetService("Players").LocalPlayer)
            end)
            task.wait(6)
            isTeleporting = false
            return
        end
    end
    local function Teleport()
        while task.wait(2) do
            pcall(function()
                TPReturner()
                if foundAnything ~= "" then
                    TPReturner()
                end
            end)
        end
    end
    Teleport()
end

function Hop()
game.StarterGui:SetCore("SendNotification", {
        Title = "ndayeuem",
        Text = "Hopping...",
        Duration = 3,
        Icon = "rbxassetid://90131637613962"
    })
    
    local PlaceID = game.PlaceId
    local AllIDs = {}
    local foundAnything = ""
    local actualHour = os.date("!*t").hour
    local isTeleporting = false

    local function handleErrorPrompt(v)
        if v.Name == "ErrorPrompt" then
            if v.Visible and v.TitleFrame.ErrorTitle.Text == "Teleport Failed" then
                v.Visible = false
            end
            v:GetPropertyChangedSignal("Visible"):Connect(function()
                if v.Visible and v.TitleFrame.ErrorTitle.Text == "Teleport Failed" then
                    v.Visible = false
                end
            end)
        end
    end

    for _, v in pairs(game.CoreGui.RobloxPromptGui.promptOverlay:GetChildren()) do
        handleErrorPrompt(v)
    end
    game.CoreGui.RobloxPromptGui.promptOverlay.ChildAdded:Connect(handleErrorPrompt)

    local function TPReturner()
        if isTeleporting then return end

        local url = ("https://games.roblox.com/v1/games/%s/servers/Public?sortOrder=Desc&excludeFullGames=true&limit=100&cursor=%s"):format(PlaceID, foundAnything)
        local success, Site = pcall(function()
            return game.HttpService:JSONDecode(game:HttpGet(url))
        end)

        if not success then
            task.wait(8)
            return
        end

        if Site.nextPageCursor and Site.nextPageCursor ~= "null" then
            foundAnything = Site.nextPageCursor
        else
            foundAnything = ""
        end

        for _, v in pairs(Site.data) do
            local ID = tostring(v.id)
            local Possible = true

            if tonumber(v.maxPlayers) > tonumber(v.playing) then
                for _, Existing in pairs(AllIDs) do
                    if ID == tostring(Existing) then
                        Possible = false
                    end
                end

                if Possible then
                    table.insert(AllIDs, ID)
                    isTeleporting = true
                    pcall(function()
                        game:GetService("TeleportService"):TeleportToPlaceInstance(PlaceID, ID, game:GetService("Players").LocalPlayer)
                    end)
                    task.wait(1)
                    isTeleporting = false
                    return
                end
            end
        end
    end

    local function Teleport()
        while task.wait(2) do
            pcall(TPReturner)
        end
    end

    Teleport()
end

function checkInventory(name)
    local inventory = game.ReplicatedStorage.Remotes.CommF_:InvokeServer("getInventory")
    for _, item in pairs(inventory) do
        if item.Name == name then
            return true
        end
    end
    return false
end
            
function Time()
    local GameTime = "Error"
    local c2 = game.Lighting.ClockTime
    if c2 >= 16 or c2 < 5 then
        GameTime = "Night"
    else
        GameTime = "Day"
    end
    return GameTime
end

function getBlueGear()
    if not game.workspace.Map:FindFirstChild("MysticIsland") then return false end
    for r, v in pairs(game.workspace.Map.MysticIsland:GetChildren()) do
        if v:IsA("MeshPart") and v.MeshId == "rbxassetid://10153114969" then
            return v
        end
    end
end

local HttpService = game:GetService("HttpService")
local TeleportService = game:GetService("TeleportService")
local Players = game:GetService("Players")

local key = "DUCANHCHODE"
local TrollApi = loadstring(game:HttpGet("https://raw.githubusercontent.com/PorryDepTrai/exploit/main/SimpleTroll.lua"))()

local joinedJobs = {}

local function base64decode(data)
	local b = 'ABCDEFGHIJKLMNOPQRSTUVWXYZabcdefghijklmnopqrstuvwxyz0123456789+/'
	data = string.gsub(data, '[^'..b..'=]', '')
	return (data:gsub('.', function(x)
		if x == '=' then return '' end
		local r,f='',(b:find(x)-1)
		for i=6,1,-1 do r=r..(f%2^i - f%2^(i-1) > 0 and '1' or '0') end
		return r
	end):gsub('%d%d%d?%d?%d?%d?%d?%d?', function(x)
		if #x ~= 8 then return '' end
		local c = 0
		for i = 1,8 do c = c + (x:sub(i,i)=='1' and 2^(8-i) or 0) end
		return string.char(c)
	end))
end

local function xor_deobfuscate(data, key)
	local result = {}
	for i = 1, #data do
		local k = key:byte(((i - 1) % #key) + 1)
		local d = data:byte(i)
		table.insert(result, string.char(bit32.bxor(d, k)))
	end
	return table.concat(result)
end

local function decode(job)
	return TrollApi["Decode JobId API Porry | discord.gg/umaru | MB KHOI"](job, "discord.gg/umaru | MB_Bank 9929992999 Phan Dat Khoi")
end

local function countJobOccurrences(jobId)
	local count = 0
	for _, id in ipairs(joinedJobs) do
		if id == jobId then
			count = count + 1
		end
	end
	return count
end

local function appendJobId(id)
	table.insert(joinedJobs, 1, id)
	while #joinedJobs > 20 do
		table.remove(joinedJobs, #joinedJobs)
	end
end

local function getDeobfuscatedJobIds(api)
	local request = (syn and syn.request) or (http and http.request) or request
	local success, res = pcall(function()
		return request({ Url = api, Method = "GET" })
	end)
	if not success or not res or not res.Body then 
		return {} 
	end

	local decodeSuccess, data = pcall(function()
		return HttpService:JSONDecode(res.Body)
	end)
	if not decodeSuccess then 
		return {} 
	end
	if typeof(data) ~= "table" or typeof(data.jobId) ~= "table" then 
		return {} 
	end

	local jobTable = data.jobId
	local result = {}
	for obfKey in pairs(jobTable) do
		local b64 = obfKey:match("^lion_(.+)")
		if b64 then
			local decoded = base64decode(b64)
			local deobf = xor_deobfuscate(decoded, key)
			if typeof(deobf) == "string" and #deobf > 5 then
				table.insert(result, deobf)
			end
		end
	end
	return result
end

local function scrapeAPI(apiUrl)
	local request = (syn and syn.request) or (http and http.request) or request
	local success, response = pcall(function()
		return request({ Url = apiUrl, Method = "GET" })
	end)
	if not success or not response or not response.Success then 
		return {} 
	end

	local successDecode, data = pcall(function()
		return HttpService:JSONDecode(response.Body)
	end)
	if not successDecode or not data then 
		return {} 
	end

	if not data.Amount or data.Amount <= 0 then 
		return {} 
	end

	local jobIds = {}
	if data.JobId then
		for _, job in ipairs(data.JobId) do
			if type(job) == "table" then
				for jobId in pairs(job) do
					table.insert(jobIds, jobId)
				end
			elseif type(job) == "string" then
				table.insert(jobIds, job)
			end
		end
	end
	return jobIds
end

local function Has_Job_In_Api(api)
	local useTrollApi = string.match(api, "hostserver%.porry%.store") ~= nil
	local jobs = {}
	
	if useTrollApi then
		jobs = scrapeAPI(api)
	else
		jobs = getDeobfuscatedJobIds(api)
	end
	
	return #jobs > 0
end

local function shuffleArray(array)
	for i = #array, 2, -1 do
		local j = math.random(i)
		array[i], array[j] = array[j], array[i]
	end
	return array
end

local function hopapi(api)
	local jobs = {}
	local useTrollApi = string.match(api, "hostserver%.porry%.store") ~= nil

	if useTrollApi then
		local rawJobs = scrapeAPI(api)
		if #rawJobs == 0 then return false end
		for _, jobId in ipairs(rawJobs) do
			if countJobOccurrences(jobId) < 2 then
				local decoded = decode(jobId)
				if decoded then
					table.insert(jobs, {original = jobId, decoded = decoded})
				end
			end
		end
	else
		local rawJobs = getDeobfuscatedJobIds(api)
		if #rawJobs == 0 then return false end
		for _, id in ipairs(rawJobs) do
			if countJobOccurrences(id) < 2 then
				table.insert(jobs, {original = id, decoded = id})
			end
		end
	end
	
	if #jobs > 0 then
		jobs = shuffleArray(jobs)
		local jobData = jobs[1]
		appendJobId(jobData.original)
		
		wait(1)
		
		local success, errorMsg = pcall(function()
		    warn("Joined Job", jobData.decoded)
			TeleportService:TeleportToPlaceInstance(game.PlaceId, jobData.decoded, Players.LocalPlayer)
		end)
		
		return true
	else
		return false
	end
end

function CheckNotificationText(s)
    local n = game.Players.LocalPlayer:FindFirstChild("PlayerGui") and game.Players.LocalPlayer.PlayerGui:FindFirstChild("Notifications")
    if not n then return false end
    for _, v in pairs(n:GetDescendants()) do
        if (v:IsA("TextLabel") or v:IsA("TextBox")) and v.Text and v.Text:lower():find(s:lower()) then
            return true
        end
    end
    return false
end

function lockm()
    game.Players.LocalPlayer.CameraMode = Enum.CameraMode.LockFirstPerson
    workspace.CurrentCamera.CFrame = CFrame.lookAt(
        workspace.CurrentCamera.CFrame.Position,
        workspace.CurrentCamera.CFrame.Position + game.Lighting:GetMoonDirection() * 100
    )
    game.Players.LocalPlayer.Character.Humanoid.AutoRotate = false
    game.Players.LocalPlayer.Character.Humanoid.RootPart.CFrame = CFrame.lookAt(
        game.Players.LocalPlayer.Character.Humanoid.RootPart.Position,
        workspace.CurrentCamera.CFrame.Position + game.Lighting:GetMoonDirection() * 100
    )
end

function pull()
    local pul = game:GetService("ReplicatedStorage").Remotes.CommF_:InvokeServer("RaceV4Progress", "Check")
    if pul == 1 then
        game:GetService("ReplicatedStorage").Remotes.CommF_:InvokeServer("RaceV4Progress", "Check")
        game:GetService("ReplicatedStorage").Remotes.CommF_:InvokeServer("RaceV4Progress", "Begin")
    elseif pul == 2 then
        game:GetService("ReplicatedStorage").Remotes.CommF_:InvokeServer("RaceV4Progress", "Check")
        repeat wait(.1)
        if (game.Players.LocalPlayer.Character.HumanoidRootPart.Position - Vector3.new(3028, 2281, -7325)).Magnitude > 15 then
            topos(CFrame.new(3028, 2281, -7325))
        end
        if (game.Players.LocalPlayer.Character.HumanoidRootPart.Position - Vector3.new(3028, 2281, -7325)).Magnitude <= 10 then 
            game:GetService("ReplicatedStorage").Remotes.CommF_:InvokeServer("RaceV4Progress", "Teleport")
        end
        until (game.Players.LocalPlayer.Character.HumanoidRootPart.Position - Vector3.new(28286.35546875, 14896.5078125, 102.62469482421875)).Magnitude <= 15
    elseif pul == 3 then
        game:GetService("ReplicatedStorage").Remotes.CommF_:InvokeServer("RaceV4Progress", "Check")
        wait(1)
        game:GetService("ReplicatedStorage").Remotes.CommF_:InvokeServer("RaceV4Progress", "Continue")
    end
end

function InMi()
    if not game.Players.LocalPlayer.Character and game.Players.LocalPlayer.Character:FindFirstChild("HumanoidRootPart") then return false end
    for _, v in pairs(game:GetService("Workspace")._WorldOrigin.Locations:GetChildren()) do
        if v.Name == "Mirage Island" then
            if (game.Players.LocalPlayer.Character and game.Players.LocalPlayer.Character:FindFirstChild("HumanoidRootPart").Position - v.Position).Magnitude < 500 then
                return true
            end
        end
    end
    return false
end

function CheckRaceVer()
    local v113 = game.ReplicatedStorage.Remotes.CommF_:InvokeServer("Wenlocktoad", "1")
    local v111 = game.Players.LocalPlayer.Data.Race:FindFirstChild("Evolved")
    if game.Players.LocalPlayer.Character:FindFirstChild("RaceTransformed") then
        return "V4"
    end
    if v113 == -2 then
        return "V3"
    end
    if v111 then
        return "V2"
    end
    return "V1"
end

spawn(function()
    local CommF_ = game:GetService("ReplicatedStorage").Remotes.CommF_
    while task.wait(0.1) do
        if not CommF_:InvokeServer("CheckTempleDoor") then
            if CheckRaceVer() == "V3" and checkInventory("Valkyrie Helm") and GetCountMaterials("Mirror Fractal") >= 1 and CommF_:InvokeServer("RaceV4Progress","Check") ~= 4 then
                warn("cắn đá")
                if not World3 then
                    CommF_:InvokeServer("TravelZou")
                end
                pull()
            elseif not game.Workspace._WorldOrigin.Locations:FindFirstChild("Mirage Island") or Time() == "Day" then
                warn("hop mi")
                if not World3 then
                    CommF_:InvokeServer("TravelZou")
                end
                hopapi("http://103.65.235.97:5000/mirage")
                task.wait(3)
            elseif game.Workspace._WorldOrigin.Locations:FindFirstChild("Mirage Island") and Time() == "Night" and not InMi() and getBlueGear() and getBlueGear().Transparency == 1 then
                warn("tp mi")
                topos(game.Workspace._WorldOrigin.Locations["Mirage Island"].CFrame * CFrame.new(0, 350, 0))
            elseif InMi() and Time() == "Night" and getBlueGear() and getBlueGear().Transparency == 1 then
                warn("lock moon")
                lockm()
                game.ReplicatedStorage.Remotes.CommE:FireServer("ActivateAbility")
            elseif getBlueGear() and getBlueGear().Transparency ~= 1 then
                warn("tp gear")
                topos(getBlueGear().CFrame)
            end
        else
            warn("lever done")
            game.StarterGui:SetCore("SendNotification", {
                Title = "Pull Lever Completed",
                Text = "",
                Duration = 3,
                Icon = "rbxassetid://90131637613962"
            })
            task.wait(3)
        end
    end
end)

local Players = game:GetService("Players")
local LocalPlayer = Players.LocalPlayer
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local RunService = game:GetService("RunService")
local Workspace = game:GetService("Workspace")
local Modules = ReplicatedStorage:WaitForChild("Modules")
local Net = Modules:WaitForChild("Net")
local RegisterAttack = Net:WaitForChild("RE/RegisterAttack")
local RegisterHit = Net:WaitForChild("RE/RegisterHit")

local SUCCESS_FLAGS, COMBAT_REMOTE_THREAD = pcall(function()
    return require(Modules.Flags).COMBAT_REMOTE_THREAD or false
end)
local SUCCESS_HIT, HIT_FUNCTION = pcall(function()
    return (getmenv or getsenv)(Net)._G.SendHitsToServer
end)

function SendAttack(Cooldown, Args)
    RegisterAttack:FireServer(Cooldown)
    if SUCCESS_FLAGS and COMBAT_REMOTE_THREAD and SUCCESS_HIT and HIT_FUNCTION then
        HIT_FUNCTION(Args[1], Args[2])
    else
        RegisterHit:FireServer(Args[1], Args[2])
    end
end

local FastAttack = {
    Distance = 60,
    AttackMobs = true,
    AttackPlayers = true,
    Debounce = 0
}

function FastAttack:IsEntityAlive(entity)
    local humanoid = entity and entity:FindFirstChild("Humanoid")
    return humanoid and humanoid.Health > 0
end

function FastAttack:GetTargets(character)
    if not character or not character:FindFirstChild("HumanoidRootPart") then return {} end
    local playerPos = character.HumanoidRootPart.Position
    local targets = {}

    if self.AttackMobs then
        for _, enemy in ipairs(Workspace.Enemies:GetChildren()) do
            local rootPart = enemy:FindFirstChild("HumanoidRootPart")
            local head = enemy:FindFirstChild("Head")
            if rootPart and self:IsEntityAlive(enemy) and (rootPart.Position - playerPos).Magnitude <= self.Distance then
                table.insert(targets, {enemy, head or rootPart})
            end
        end
    end

    if self.AttackPlayers then
        for _, otherPlayer in ipairs(Players:GetPlayers()) do
            if otherPlayer ~= LocalPlayer and otherPlayer.Character then
                local rootPart = otherPlayer.Character:FindFirstChild("HumanoidRootPart")
                if rootPart and self:IsEntityAlive(otherPlayer.Character) and (rootPart.Position - playerPos).Magnitude <= self.Distance then
                    table.insert(targets, {otherPlayer.Character, rootPart})
                end
            end
        end
    end

    return targets
end

function FastAttack:Attack()
    local character = LocalPlayer.Character
    if not character or not character:FindFirstChild("HumanoidRootPart") then return end
    local weapon = character:FindFirstChildOfClass("Tool")
    if not weapon then return end
    local currentTime = tick()
    if currentTime - self.Debounce < 0.1 then return end
    self.Debounce = currentTime
    local targets = self:GetTargets(character)
    if #targets == 0 then return end
    
    local hitTargets = {}
    for _, target in ipairs(targets) do
        table.insert(hitTargets, {target[1], target[2]})
    end
    pcall(function()
        SendAttack(0.1, {hitTargets[1][2], hitTargets})
        task.wait(0.1)
    end)
end

game:GetService("RunService").Stepped:Connect(function()
    pcall(function()
        FastAttack:Attack()
    end)
end)

getgenv().NoClip = true

game:GetService("RunService").Stepped:Connect(function()
    pcall(function()
        if not (game:GetService("Players").LocalPlayer.Character and game:GetService("Players").LocalPlayer.Character:FindFirstChild("Head") and game:GetService("Players").LocalPlayer.Character:FindFirstChild("HumanoidRootPart")) then return end
        if getgenv().NoClip then
            if not game:GetService("Players").LocalPlayer.Character:FindFirstChild("Head"):FindFirstChild("BodyClip") then
                local bv = Instance.new("BodyVelocity")
                bv.Name = "BodyClip"
                bv.Velocity = Vector3.new(0, 0, 0)
                bv.MaxForce = Vector3.new(math.huge, math.huge, math.huge)
                bv.P = 15000
                bv.Parent = game:GetService("Players").LocalPlayer.Character:FindFirstChild("Head")
            end

            for _, v in ipairs(game:GetService("Players").LocalPlayer.Character:GetDescendants()) do
                if v:IsA("BasePart") then
                    v.CanCollide = false
                end
            end
        else
            if game:GetService("Players").LocalPlayer.Character:FindFirstChild("Head"):FindFirstChild("BodyClip") then
                game:GetService("Players").LocalPlayer.Character:FindFirstChild("Head"):FindFirstChild("BodyClip"):Destroy()
            end

            for _, v in ipairs(game:GetService("Players").LocalPlayer.Character:GetDescendants()) do
                if v:IsA("BasePart") then
                    v.CanCollide = true
                end
            end
        end
    end)
end)


getgenv().Loaded = true