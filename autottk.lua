

if not game.Players.LocalPlayer.Team then game.ReplicatedStorage.Remotes.CommF_:InvokeServer("SetTeam", getgenv().Team or "Pirates") end
wait(1)

repeat task.wait(1) until game:GetService("Players").LocalPlayer.Team

--// check Sea
if game.PlaceId == 2753915549 then
        World1 = true
    elseif game.PlaceId == 4442272183 then
        World2 = true
    elseif game.PlaceId == 7449423635 then
        World3 = true
    else
    game:GetService("Players").LocalPlayer:Kick("This Game Is Not Support")
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

local function appendJobId(id)
    table.insert(joinedJobs, 1, id)
    while #joinedJobs > 20 do
        table.remove(joinedJobs, #joinedJobs)
    end
end

local function safeRequest(opts)
    local req = (syn and syn.request) or (http and http.request) or request
    if not req then return nil end
    local ok, res = pcall(function() return req(opts) end)
    return ok and res or nil
end

local function getDeobfuscatedJobIds(api)
    local res = safeRequest({ Url = api, Method = "GET" })
    if not res or not res.Body then return {} end
    local ok, data = pcall(function() return HttpService:JSONDecode(res.Body) end)
    if not ok or typeof(data) ~= "table" or typeof(data.jobId) ~= "table" then return {} end
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
    local res = safeRequest({ Url = apiUrl, Method = "GET" })
    if not res or not res.Success then return {} end
    local ok, data = pcall(function() return HttpService:JSONDecode(res.Body) end)
    if not ok or not data or not data.Amount or data.Amount <= 0 then return {} end
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

local function hasJobsInAPI(api)
    local joinedSet = {}
    for _, id in ipairs(joinedJobs) do
        joinedSet[id] = true
    end
    local useTrollApi = string.match(api, "hostserver%.porry%.store") ~= nil
    local jobs = useTrollApi and scrapeAPI(api) or getDeobfuscatedJobIds(api)
    local count = 0
    for _, jobId in ipairs(jobs) do
        local decoded = useTrollApi and decode(jobId) or jobId
        if decoded and decoded ~= game.JobId and not joinedSet[decoded] then
            count += 1
        end
    end
    return count > 0
end

local function JoinNextJob(api)
    local joinedSet = {}
    for _, id in ipairs(joinedJobs) do
        joinedSet[id] = true
    end
    local useTrollApi = string.match(api, "hostserver%.porry%.store") ~= nil
    local jobs = {}
    if useTrollApi then
        local rawJobs = scrapeAPI(api)
        for _, jobId in ipairs(rawJobs) do
            if not joinedSet[jobId] and jobId ~= game.JobId then
                local decoded = decode(jobId)
                if decoded and decoded ~= game.JobId and not joinedSet[decoded] then
                    table.insert(jobs, decoded)
                end
            end
        end
    else
        local rawJobs = getDeobfuscatedJobIds(api)
        for _, id in ipairs(rawJobs) do
            if not joinedSet[id] and id ~= game.JobId then
                table.insert(jobs, id)
            end
        end
    end
    if #jobs > 0 then
        local jobData = jobs[math.random(1, #jobs)]
        appendJobId(jobData)
        warn("Teleporting to JobId:", jobData)
        local ok = pcall(function()
            TeleportService:TeleportToPlaceInstance(game.PlaceId, jobData, Players.LocalPlayer)
        end)
        if ok then return true end
    else
        warn("No available job found in API")
    end
    return false
end
--// code farm
local lp = game.Players.LocalPlayer
local RunService = game:GetService("RunService")
local isBringing = false
local bringConnection = nil
local globalTarget = Instance.new("Part")
globalTarget.Name = "GlobalBringTarget"
globalTarget.Size = Vector3.new(1,1,1)
globalTarget.Anchored = true
globalTarget.Transparency = 1
globalTarget.CanCollide = false
globalTarget.Parent = workspace

function BringMob(mobName, targetPos, range, maxCount, skipDeath)
    if isBringing then return end
    maxCount = maxCount or 5
    range = range or 10
    isBringing = true
    bringConnection = RunService.Heartbeat:Connect(function()
        local hrpPlr = lp.Character and lp.Character:FindFirstChild("HumanoidRootPart")
        if not hrpPlr then return end
        pcall(function() sethiddenproperty(lp, "SimulationRadius", math.huge) end)
        globalTarget.Position = targetPos
        local count = 0
        for _, mob in ipairs(workspace.Enemies:GetChildren()) do
            if count >= maxCount then break end
            if mob.Name == mobName and mob:FindFirstChild("HumanoidRootPart") and mob:FindFirstChild("Humanoid") and mob.Humanoid.Health > 0 then
                local hrp = mob.HumanoidRootPart
                hrp.CanCollide = false
                hrp.Size = Vector3.new(1,1,1)
                
                local att0 = hrp:FindFirstChild("AP_Att0") or Instance.new("Attachment", hrp)
                att0.Name = "AP_Att0"
                local att1 = globalTarget:FindFirstChild("AP_Att1") or Instance.new("Attachment", globalTarget)
                att1.Name = "AP_Att1"
                
                local ap = hrp:FindFirstChild("AlignPos_AP") or Instance.new("AlignPosition")
                ap.Name = "AlignPos_AP"
                ap.Attachment0 = att0
                ap.Attachment1 = att1
                ap.RigidityEnabled = false
                ap.Responsiveness = 200
                ap.MaxForce = math.huge
                ap.MaxVelocity = math.huge
                ap.Parent = hrp
                
                local ao = hrp:FindFirstChild("AlignOri_AP") or Instance.new("AlignOrientation")
                ao.Name = "AlignOri_AP"
                ao.Attachment0 = att0
                ao.Attachment1 = att1
                ao.RigidityEnabled = false
                ao.Responsiveness = 200
                ao.MaxTorque = math.huge
                ao.MaxAngularVelocity = math.huge
                ao.Parent = hrp
                
                hrp.AssemblyLinearVelocity = Vector3.new(0,0,0)
                hrp.AssemblyAngularVelocity = Vector3.new(0,0,0)
                
                count += 1
                if not skipDeath then
                    task.delay(50, function()
                        if mob and mob:FindFirstChild("Humanoid") and mob.Humanoid.Health > 0 then
                            mob.Humanoid:ChangeState(Enum.HumanoidStateType.Dead)
                            task.delay(4, function()
                                if mob and mob:FindFirstChild("Humanoid") and mob.Humanoid.Health > 0 then
                                    mob.Humanoid.Health = 0
                                end
                            end)
                        end
                    end)
                end
            end
        end
    end)
end

function StopBring()
    if bringConnection then
        bringConnection:Disconnect()
        bringConnection = nil
    end
    isBringing = false
end

function AutoHaki() --// turn on haki
    if not game.Players.LocalPlayer.Character:FindFirstChild("HasBuso") then
        game.ReplicatedStorage.Remotes.CommF_:InvokeServer("Buso")
    end
end

function EquipWeapon(w) --// equip 
	pcall(function()
		for i,v in pairs(game.Players.LocalPlayer.Backpack:GetChildren()) do
			if v.ToolTip == w or game.Players.LocalPlayer.Backpack:FindFirstChild(w)  then
				game.Players.LocalPlayer.Character.Humanoid:EquipTool(v) 
			end
		end
	end)
end

function CheckScreen(text)
    local success, result = pcall(function()
        if not text then return false end
        local playerGui = lp:FindFirstChild("PlayerGui")
        if not playerGui then return false end
        local lowerText = string.lower(text)
        for _, v in ipairs(playerGui:GetDescendants()) do
            if v:IsA("TextLabel") and v.Visible and v.Text then
                if string.find(string.lower(v.Text), lowerText) then
                    return true
                end
            end
        end
        return false
    end)
    return success and result or false
end

game:GetService("RunService").Stepped:Connect(function()
    pcall(function()
        if not (game.Players.LocalPlayer.Character and game.Players.LocalPlayer.Character:FindFirstChild("Head") and game.Players.LocalPlayer.Character:FindFirstChild("HumanoidRootPart")) then return end
        if getgenv().NoClip then
            if not game.Players.LocalPlayer.Character.Head:FindFirstChild("BodyClip") then
                local bv = Instance.new("BodyVelocity")
                bv.Name = "BodyClip"
                bv.Velocity = Vector3.new(0, 0, 0)
                bv.MaxForce = Vector3.new(math.huge, math.huge, math.huge)
                bv.P = 15000
                bv.Parent = game.Players.LocalPlayer.Character.Head
            end
            for _, v in ipairs(game.Players.LocalPlayer.Character:GetDescendants()) do
                if v:IsA("BasePart") then
                    v.CanCollide = false
                end
            end
        else
            local clip = game.Players.LocalPlayer.Character.Head:FindFirstChild("BodyClip")
            if clip then clip:Destroy() end
            for _, v in ipairs(game.Players.LocalPlayer.Character:GetDescendants()) do
                if v:IsA("BasePart") then
                    v.CanCollide = true
                end
            end
        end
    end)
end)

local w = game.PlaceId
local distbyp = (w == 2753915549 and 1500) or (w == 4442272183 and 3500) or (w == 7449423635 and 6000)
local gQ = (w == 2753915549 and {
    Vector3.new(-7894.6201171875, 5545.49169921875, -380.2467346191406),
    Vector3.new(-4607.82275390625, 872.5422973632812, -1667.556884765625),
    Vector3.new(61163.8515625, 11.759522438049316, 1819.7841796875),
    Vector3.new(3876.280517578125, 35.10614013671875, -1939.3201904296875)
}) or (w == 4442272183 and {
    Vector3.new(-288.46246337890625, 306.130615234375, 597.9988403320312),
    Vector3.new(2284.912109375, 15.152046203613281, 905.48291015625),
    Vector3.new(923.21252441406, 126.9760055542, 32852.83203125),
    Vector3.new(-6508.5581054688, 89.034996032715, -132.83953857422)
}) or (w == 7449423635 and {
    Vector3.new(-5058, 314, -3155),
    Vector3.new(5661, 1013, -334),
    Vector3.new(-12463, 374, -7523),
    Vector3.new(-16814, 58, 304)
})

local lp = game.Players.LocalPlayer
local rs = game.ReplicatedStorage
local ts = game:GetService("TweenService")
local ws = game.Workspace

getgenv().Main = getgenv().Main or {}
Main.CurrentTween = nil
Main.IsMoving = false

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

function request(aJ)
    local success = false
    for i = 1, 2 do
        args = {"requestEntrance", aJ}
        game.ReplicatedStorage.Remotes.CommF_:InvokeServer(unpack(args))
        oldcframe = game.Players.LocalPlayer.Character.HumanoidRootPart.CFrame
        char = game.Players.LocalPlayer.Character.HumanoidRootPart
        char.CFrame = CFrame.new(oldcframe.X, oldcframe.Y + 30, oldcframe.Z)
        task.wait(0.6)
        local currentDistance = (aJ - game.Players.LocalPlayer.Character.HumanoidRootPart.Position).Magnitude
        if currentDistance < 100 then
            success = true
            break
        end
    end
    return success
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
local function calcpos(a, b)
    if not a then return math.huge end
    b = b or (lp.Character and lp.Character.PrimaryPart and lp.Character.PrimaryPart.CFrame) or CFrame.new(0, 0, 0)
    return (Vector3.new(a.X, 0, a.Z) - Vector3.new(b.X, 0, b.Z)).Magnitude
end

function ffc(obj, child)
    return obj and child and obj:FindFirstChild(tostring(child))
end

function cd(a, b)
    if not a then return math.huge end
    b = b or (lp.Character and lp.Character.PrimaryPart and lp.Character.PrimaryPart.CFrame) or CFrame.new(0,0,0)
    return (Vector3.new(a.X, 0, a.Z) - Vector3.new(b.X, 0, b.Z)).Magnitude
end

function str(string)
    return string and tostring(string) or ""
end

function wfc(obj, child)
    return obj and child and obj:WaitForChild(tostring(child), 5)
end

function wfh(mob)
    return mob and mob.Character and wfc(mob.Character, "Humanoid")
end

function wfhrp(mob)
    return mob and mob.Character and wfc(mob.Character, "HumanoidRootPart")
end

function TP1(Pos)
    local lp = game:GetService("Players").LocalPlayer
    local char = lp.Character
    if not char then 
        print("TP1 aborted: no character") 
        return 
    end
    local hrp = ffc(char, "HumanoidRootPart")
    local hum = char:FindFirstChildOfClass("Humanoid")
    if not hrp or not hum or hum.Health <= 0 then 
        print("TP1 aborted: missing HRP or Humanoid or dead") 
        return 
    end  
    getgenv().Request = false
    getgenv().NoClip = true
    local MyCFrame = hrp.CFrame
    local DistanceToPos = cd(MyCFrame, Pos)
    local function isInSubmergedIsland(position)
        local submergedMap = workspace.Map:FindFirstChild("Submerged Island")
        if not submergedMap then return false end
        local cframe, size = submergedMap:GetBoundingBox()
        local center = cframe.Position
        local min = center - size/2
        local max = center + size/2
        return position.X >= min.X and position.X <= max.X and 
               position.Y >= min.Y and position.Y <= max.Y and 
               position.Z >= min.Z and position.Z <= max.Z
    end
    local targetInSubmerged = isInSubmergedIsland(Pos.Position)
    local playerInSubmerged = isInSubmergedIsland(hrp.Position)
    if targetInSubmerged and not playerInSubmerged then
        repeat 
            task.wait(0.1)
            Main.IsMoving = false
            Main.CurrentTween = nil
            wait(0.1)
            local Character = game.Players.LocalPlayer.Character
            local Humanoid = Character:FindFirstChildOfClass("Humanoid")
            Character.HumanoidRootPart.Anchored = true
            Humanoid.PlatformStand = true
            Character:SetPrimaryPartCFrame(CFrame.new(-16270, 25, 1373))
            task.delay(1, function()
                local args1 = {"TravelToSubmergedIsland"}
                game:GetService("ReplicatedStorage").Modules.Net:FindFirstChild("RF/SubmarineWorkerSpeak"):InvokeServer(unpack(args1))
            end)
            task.wait(4)
        until isInSubmergedIsland(hrp.Position)
        game.Players.LocalPlayer.Character.HumanoidRootPart.Anchored = false
        game.Players.LocalPlayer.Character:FindFirstChildOfClass("Humanoid").PlatformStand = false
    end
    local ws = workspace or game.Workspace
    local dimRift = ffc(ws._WorldOrigin.Locations, "Dimensional Rift")
    local myHRP = wfhrp(lp)
    if dimRift and myHRP and cd(dimRift.CFrame, myHRP.CFrame) <= 1000 and cd(Pos, dimRift.CFrame) <= 1000 then
        Main.IsMoving = false
        Main.CurrentTween = nil
        wait(0.1)
        task.delay(1, function()
            hrp.CFrame = game:GetService("Workspace").Map.CakeLoaf.BigMirror.Other.CFrame
        end)
        task.wait(4)
        return true
    end
    if DistanceToPos <= 100 then
        Main.IsMoving = false
        Main.CurrentTween = nil
        wait(0.1)
        hrp.CFrame = Pos
        return true
    end
    local Portal = getPortal(Pos)
    local DistanceToPortal = Portal and cd(MyCFrame, Portal) or math.huge
    local DistancePortalToPos = Portal and cd(Portal, Pos) or math.huge
    if Portal and DistanceToPos > distbyp and DistancePortalToPos < DistanceToPos and (World1 or World2 or (World3 and checkInventory("Valkyrie Helm"))) then
        Main.IsMoving = false
        Main.CurrentTween = nil
        wait(0.1)
        if Portal.X == -16814 and Portal.Y == 58 and Portal.Z == 304 then
            local Character = lp.Character
            local Humanoid = Character:FindFirstChildOfClass("Humanoid")
            Character.HumanoidRootPart.Anchored = true
            Humanoid.PlatformStand = true
            Character:SetPrimaryPartCFrame(CFrame.new(-5085, 314, -3156))
            task.delay(1, function()
                local boatCastle = workspace.Map:FindFirstChild("Boat Castle")
                if boatCastle then
                    local mapTeleportC = boatCastle:FindFirstChild("MapTeleportC")
                    if mapTeleportC then
                        local args = {
                            [1] = "InitiateTeleport",
                            [2] = mapTeleportC
                        }
                        game:GetService("ReplicatedStorage").Modules.Net:FindFirstChild("RF/BoatCastleTeleporters"):InvokeServer(unpack(args))
                    end
                end
            end)
            task.wait(2)
            Character.HumanoidRootPart.Anchored = false
            Humanoid.PlatformStand = false
            return true
        end
        for i = 1, 2 do
            pcall(function()
                request(Portal)
                getgenv().Request = true
            end)
            return true
        end
    end
    local Speed = Config and Config["Setting"] and Config["Setting"]["Tween Speed"] or 300
    local TweenTime = math.max(0.3, DistanceToPos / Speed)
    Main.IsMoving = true
    local TweenInfo = TweenInfo.new(TweenTime, Enum.EasingStyle.Linear)
    Main.CurrentTween = game:GetService("TweenService"):Create(hrp, TweenInfo, {CFrame = Pos})
    Main.CurrentTween.Completed:Connect(function()
        Main.IsMoving = false
        Main.CurrentTween = nil
    end)
    Main.CurrentTween:Play()
    hrp.CFrame = CFrame.new(hrp.Position.X, Pos.Y, hrp.Position.Z)
    return true
end
local function Hop(mode) --// hop
    game.StarterGui:SetCore("SendNotification", {Title = "Nexon Hub", Text = "Hopping...", Duration = 3, Icon = ""})
    local PlaceID = game.PlaceId
    local AllIDs, foundAnything, actualHour, isTeleporting = {}, "", os.date("!*t").hour, false

    local function bQ(v)
        if v.Name == "ErrorPrompt" then
            if v.Visible and v.TitleFrame.ErrorTitle.Text == "Teleport Failed" then v.Visible = false end
            v:GetPropertyChangedSignal("Visible"):Connect(function()
                if v.Visible and v.TitleFrame.ErrorTitle.Text == "Teleport Failed" then v.Visible = false end
            end)
        end
    end
    for _, v in pairs(game.CoreGui.RobloxPromptGui.promptOverlay:GetChildren()) do bQ(v) end
    game.CoreGui.RobloxPromptGui.promptOverlay.ChildAdded:Connect(bQ)

    local function TPReturner()
        if isTeleporting then return end
        local Site = foundAnything == "" 
            and game.HttpService:JSONDecode(game:HttpGet('https://games.roblox.com/v1/games/' .. PlaceID .. '/servers/Public?sortOrder=Asc&limit=100')) 
            or game.HttpService:JSONDecode(game:HttpGet('https://games.roblox.com/v1/games/' .. PlaceID .. '/servers/Public?sortOrder=Asc&limit=100&cursor=' .. foundAnything))
        if Site.nextPageCursor and Site.nextPageCursor ~= "null" then foundAnything = Site.nextPageCursor end
        local serverList, num = {}, 0
        for _, v in pairs(Site.data) do
            local Possible, ID = true, tostring(v.id)
            if tonumber(v.maxPlayers) > tonumber(v.playing) then
                for _, Existing in pairs(AllIDs) do
                    if num ~= 0 then
                        if ID == tostring(Existing) then Possible = false end
                    else
                        if tonumber(actualHour) ~= tonumber(Existing) then
                            AllIDs = {}
                            table.insert(AllIDs, actualHour)
                        end
                    end
                    num = num + 1
                end
                if Possible then
                    table.insert(serverList, {id = ID, players = tonumber(v.playing)})
                end
            end
        end
        if mode == "Low" then
            table.sort(serverList, function(a, b) return a.players < b.players end)
        elseif mode == "High" then
            table.sort(serverList, function(a, b) return a.players > b.players end)
            serverList = table.filter(serverList, function(s) return s.players > 8 end)
        end
        if #serverList > 0 then
            local selectedServer = serverList[1]
            table.insert(AllIDs, selectedServer.id)
            isTeleporting = true
            pcall(function() game:GetService("TeleportService"):TeleportToPlaceInstance(PlaceID, selectedServer.id, game.Players.LocalPlayer) end)
            task.wait(6)
            isTeleporting = false
        end
    end

    local function Teleport()
        while task.wait(2) do
            pcall(function()
                TPReturner()
                if foundAnything ~= "" then TPReturner() end
            end)
        end
    end
    Teleport()
end
local function IsPlayerNearby(position, radius)
    for _, player in pairs(game.Players:GetPlayers()) do
        if player ~= game.Players.LocalPlayer and player.Character and player.Character:FindFirstChild("HumanoidRootPart") then
            if (player.Character.HumanoidRootPart.Position - position).Magnitude <= radius then
                return true
            end
        end
    end
    return false
end
function FMS(sw) --// farm mastery
    if sw ~= "no" and not game.Players.LocalPlayer.Backpack:FindFirstChild(sw) and not game.Players.LocalPlayer.Character:FindFirstChild(sw) then
        game.ReplicatedStorage.Remotes.CommF_:InvokeServer("LoadItem", sw)
        return
    end
    if not game.Players.LocalPlayer.Character or not game.Players.LocalPlayer.Character:FindFirstChild("HumanoidRootPart") then return end
    local priority = {
        "Reborn Skeleton",
        "Living Zombie",
        "Demonic Soul",
        "Posessed Mummy"
    }
    for _, mobName in ipairs(priority) do
        local mobs = {}
        for _, v in pairs(workspace.Enemies:GetChildren()) do
            if v.Name == mobName and v:FindFirstChild("HumanoidRootPart") and v:FindFirstChild("Humanoid") and v.Humanoid.Health > 0 then
                table.insert(mobs, v)
            end
        end
        if #mobs > 0 then
            table.sort(mobs, function(a, b)
                return (game.Players.LocalPlayer.Character.HumanoidRootPart.Position - a.HumanoidRootPart.Position).Magnitude < (game.Players.LocalPlayer.Character.HumanoidRootPart.Position - b.HumanoidRootPart.Position).Magnitude
            end)
            for _, mob in ipairs(mobs) do
                if mob and mob:FindFirstChild("Humanoid") and mob.Humanoid.Health > 0 and mob:FindFirstChild("HumanoidRootPart") then
                    if IsPlayerNearby(mob.HumanoidRootPart.Position, 50) then
                        Hop("Low")
                        return
                    end
                    NearestTarget = mob.Name
                    repeat
                        task.wait()
                        AutoHaki()
                        if sw == "no" then
                            EquipWeapon("Melee")
                        else
                            EquipWeapon("Sword")
                        end
                        BringMob(mob.Name, mob.HumanoidRootPart.Position, 350, 3)
                        TP1(mob.HumanoidRootPart.CFrame * CFrame.new(0, 20, 0))
                    until not mob.Parent or mob.Humanoid.Health <= 0
                    StopBring()
                end
            end
        end
    end
    TP1(CFrame.new(-9506.234375, 172.130615234375, 6117.0771484375))
end

--// code chính
function CheckApi()
    if hasJobsInAPI("http://103.65.235.97:5000/shizu") and not checkInventory("Shizu") then
        return "http://103.65.235.97:5000/shizu"
    end
    if hasJobsInAPI("http://103.65.235.97:5000/Saishi") and not checkInventory("Saishi") then
        return "http://103.65.235.97:5000/Saishi"
    end
    if hasJobsInAPI("http://103.65.235.97:5000/Oroshi") and not checkInventory("Oroshi") then
        return "http://103.65.235.97:5000/Oroshi"
    end
    return false
end

function CheckBeli()
    local total = 8e6
    if checkInventory("True Triple Katana") then total = total - 2e6 end
    if checkInventory("Shizu") then total = total - 2e6 end
    if checkInventory("Oroshi") then total = total - 2e6 end
    if checkInventory("Saishi") then total = total - 2e6 end
    return total
end

function Zoro()
    for i = 1, 3 do
        if game:GetService("ReplicatedStorage").Remotes.CommF_:InvokeServer("LegendarySwordDealer", tostring(i)) then
            if i == 1 and not checkInventory("Saishi") then
                return true
            elseif i == 2 and not checkInventory("Shizu") then
                return true
            elseif i == 3 and not checkInventory("Oroshi") then
                return true
            end
        end
    end
    return false
end

function checkmas1(t, n) --// check mastery 
    for _, v in pairs(game.ReplicatedStorage.Remotes.CommF_:InvokeServer("getInventory")) do
        if v.Type == t and v.Name == n then return v.Mastery end
    end
    return 0 
end

spawn(function()
    while task.wait(0.1) do
        if getgenv().Loaded and not checkInventory("True Triple Katana") then
            local B = CheckBeli()
            local A = CheckApi()
            local Z = Zoro()
            local SA = checkmas1("Sword", "Saishi")
            local SI = checkmas1("Sword", "Shizu")
            local OR = checkmas1("Sword", "Oroshi")
            print("B:", B, "A:", A, "Z:", Z, "SA:", SA, "SI:", SI, "OR:", OR)
            if game:GetService("Players").LocalPlayer.Data.Beli.Value < B then
                FMS("no")
                print("farm beli")
            elseif game:GetService("Players").LocalPlayer.Data.Beli.Value >= B and A then
                if not World2 then
                    game.ReplicatedStorage.Remotes.CommF_:InvokeServer("TravelDressrosa")
                    print("done farm beli")
                end
                if not Z then
                    JoinNextJob(A)
                    print("join api")
                elseif Z then
                    for i = 1, 3 do
                        game:GetService("ReplicatedStorage").Remotes.CommF_:InvokeServer("LegendarySwordDealer", tostring(i)) 
                        print("buy")
                    end
                end
            elseif (checkInventory("Saishi") and checkInventory("Shizu") and checkInventory("Oroshi")) and (SA < 300 or SI < 300 or OR < 300) then
                if not World3 then
                    game.ReplicatedStorage.Remotes.CommF_:InvokeServer("TravelZou")
                end
                if SA < 300 then
                    FMS("Saishi")
                elseif SI < 300 then
                    FMS("Shizu")
                elseif OR < 300 then
                    FMS("Oroshi")
                end
                print("farm mas")
            elseif (checkInventory("Saishi") and checkInventory("Shizu") and checkInventory("Oroshi")) and (SA >= 300 and SI >= 300 and OR >= 300) then
                if not World2 then
                    game.ReplicatedStorage.Remotes.CommF_:InvokeServer("TravelDressrosa")
                else
                    game:GetService("ReplicatedStorage").Remotes.CommF_:InvokeServer("MysteriousMan", "1")
                    print("TTK")
                end
            end
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
    local tip = weapon.ToolTip
    if tip ~= "Melee" and tip ~= "Sword" then return end
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

spawn(function()
    while task.wait(0.15) do
        pcall(function()
            FastAttack:Attack()
        end)
    end
end)

task.delay(3,function()
   getgenv().Loaded = true
end)