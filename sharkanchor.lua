if not game.Players.LocalPlayer.Team then game.ReplicatedStorage.Remotes.CommF_:InvokeServer("SetTeam", getgenv().Team or "Pirates") end
wait(1)

repeat
    task.wait(1)
    local chooseTeam = game:GetService("Players").LocalPlayer:WaitForChild("PlayerGui"):FindFirstChild("ChooseTeam", true)
    local uiController = game:GetService("Players").LocalPlayer:WaitForChild("PlayerGui"):FindFirstChild("UIController", true)

    if chooseTeam and chooseTeam.Visible and uiController then
        for _, v in pairs(getgc(true)) do
            if type(v) == "function" and getfenv(v).script == uiController then
                local constant = getconstants(v)
                pcall(function()
                    if (constant[1] == "Pirates" or constant[1] == "Marines") and #constant == 1 then
                        if constant[1] == getgenv().Team then
                            v(getgenv().Team)
                        end
                    end
                end)
            end
        end
    end
until game:GetService("Players").LocalPlayer.Team
  
--// check Sea
if game.PlaceId == 2753915549 then
        World1 = true
    elseif game.PlaceId == 4442272183 then
        World2 = true
    elseif game.PlaceId == 7449423635 then
        World3 = true
    else
    game:GetService("Players").LocalPlayer:Kick("This Game Is Not Support [ Lion Hub ]")
  end 
  
if getgenv().Config["Shark Anchor"]["Enabled"] then
warn("loading")
function checkInventory(L_V5)
    local L_V3 = game.ReplicatedStorage.Remotes.CommF_:InvokeServer("getInventory")
    for _, L_V6 in pairs(L_V3) do
        if L_V6.Name == L_V5 then
            return true
        end
    end
    return false
end

RS = game:GetService("ReplicatedStorage")
TS = game:GetService("TeleportService")
HS = game:GetService("HttpService")
WS = game:GetService("Workspace")
Players = game:GetService("Players")
RunService = game:GetService("RunService")
TweenService = game:GetService("TweenService")
LP = Players.LocalPlayer

function CheckNearestTeleporter(aI)
    local MyLevel = game.Players.LocalPlayer.Data.Level.Value
    vcspos = aI.Position
    min = math.huge
    min2 = math.huge
    local y = game.PlaceId
    if y == 2753915549 then
        World1 = true
    elseif y == 4442272183 then
        World2 = true
    elseif y == 7449423635 then
        World3 = true
    end  
    
    if World3 then
        TableLocations = {
            ["Caslte On The Sea"] = Vector3.new(-5058.77490234375, 314.5155029296875, -3155.88330078125),
            ["Hydra"] = Vector3.new(5661.5302734375, 1013.3587036132812, -334.9619140625),
            ["Mansion"] = Vector3.new(-12463.8740234375, 374.9144592285156, -7523.77392578125)
        }
    elseif World2 then
        TableLocations = {
            ["Mansion"] = Vector3.new(-288.46246337890625, 306.130615234375, 597.9988403320312),
            ["Flamingo"] = Vector3.new(2284.912109375, 15.152046203613281, 905.48291015625),
            ["122"] = Vector3.new(923.21252441406, 126.9760055542, 32852.83203125),
            ["3032"] = Vector3.new(-6508.5581054688, 89.034996032715, -132.83953857422)
        }
    elseif World1 then
        TableLocations = {
            ["1"] = Vector3.new(-7894.6201171875, 5545.49169921875, -380.2467346191406),
            ["2"] = Vector3.new(-4607.82275390625, 872.5422973632812, -1667.556884765625),
            ["3"] = Vector3.new(61163.8515625, 11.759522438049316, 1819.7841796875),
            ["4"] = Vector3.new(3876.280517578125, 35.10614013671875, -1939.3201904296875)
        }
    end
    
    TableLocations2 = {}
    for r, v in pairs(TableLocations) do
        TableLocations2[r] = (v - vcspos).Magnitude
    end
    
    for r, v in pairs(TableLocations2) do
        if v < min then
            min = v
            min2 = v
        end
    end
    
    for r, v in pairs(TableLocations2) do
        if v <= min then
            choose = TableLocations[r]
        end
    end
    
    min3 = (vcspos - game.Players.LocalPlayer.Character.HumanoidRootPart.Position).Magnitude
    if min2 <= min3 then
        return choose
    end
end

function requestEntrance(aJ)
    local success = false
    for i = 1, 2 do
        args = {"requestEntrance", aJ}
        game.ReplicatedStorage.Remotes.CommF_:InvokeServer(unpack(args))
        oldcframe = game.Players.LocalPlayer.Character.HumanoidRootPart.CFrame
        char = game.Players.LocalPlayer.Character.HumanoidRootPart
        char.CFrame = CFrame.new(oldcframe.X, oldcframe.Y + 50, oldcframe.Z)
        task.wait(0.6)
        
        local currentDistance = (aJ - game.Players.LocalPlayer.Character.HumanoidRootPart.Position).Magnitude
        if currentDistance < 100 then
            success = true
            break
        end
    end
    return success
end

local TweenSpeed = 350
local travelTween = nil

local function TP1(targetCFrame)
    local char = LP.Character
    local root = char and char:FindFirstChild("HumanoidRootPart")
    local humanoid = char and char:FindFirstChild("Humanoid")
    local canUseTele = (World1 or World2) or (World3 and checkInventory("Valkyrie Helm"))
    local AM = CheckNearestTeleporter(targetCFrame)
    if not (char and root and humanoid and humanoid.Health > 0) then return nil end

    if travelTween then
        pcall(function() travelTween:Cancel() end)
        travelTween = nil
    end
    
    if canUseTele and AM then
        pcall(function() travelTween:Cancel() end)
        travelTween = nil
        requestEntrance(AM)
        task.wait(1)
    end
    
    local noClipConn = RunService.Stepped:Connect(function()
        if char then
            for _, part in pairs(char:GetDescendants()) do
                if part:IsA("BasePart") and part.CanCollide then
                    part.CanCollide = false
                end
            end
        end
    end)

    local targetPos = targetCFrame.Position
    local distance = (targetPos - root.Position).Magnitude

    if distance < 200 then
        root.CFrame = targetCFrame
        if noClipConn then noClipConn:Disconnect() end
        return { Cancel = function() end }
    else
        local startPos = root.Position
        local direction = (targetPos - startPos).Unit
        local totalTime = distance / TweenSpeed
        local microSteps = math.ceil(totalTime * 60)
        local currentStep = 0

        local moveConn
        local cancelFunc = function()
            if moveConn and moveConn.Connected then moveConn:Disconnect() end
            if noClipConn and noClipConn.Connected then noClipConn:Disconnect() end
        end

        moveConn = RunService.Heartbeat:Connect(function(deltaTime)
            if not (root and root.Parent) then
                cancelFunc()
                return
            end

            local steps = math.min(deltaTime * 60, 3)
            currentStep += steps

            if currentStep >= microSteps then
                root.CFrame = targetCFrame
                cancelFunc()
                return
            end

            local ratio = currentStep / microSteps
            local newPos = startPos + direction * (distance * ratio)
            root.CFrame = CFrame.new(newPos)
            root.Velocity = Vector3.zero
            root.RotVelocity = Vector3.zero
        end)

        travelTween = { Cancel = cancelFunc }
        return travelTween
    end
end

function AutoHaki()
    local c = game.Players.LocalPlayer.Character
    if c and not c:FindFirstChild("HasBuso") then
        game.ReplicatedStorage.Remotes.CommF_:InvokeServer("Buso")
    end
end

function EquipWeapon(ToolSe)
	pcall(function()
		if game.Players.LocalPlayer.Backpack:FindFirstChild(ToolSe) and game.Players.LocalPlayer.Character:FindFirstChild('Humanoid') then
			local tool = game.Players.LocalPlayer.Backpack:FindFirstChild(ToolSe)
			wait()
			game.Players.LocalPlayer.Character.Humanoid:EquipTool(tool)
		end
	end)
end
	
function EquipWeaponMelee()
	pcall(function()
		for i,v in pairs(game.Players.LocalPlayer.Backpack:GetChildren()) do
			if v.ToolTip == "Melee" and v:IsA('Tool') then
				local ToolHumanoid = game.Players.LocalPlayer.Backpack:FindFirstChild(v.Name) 
				game.Players.LocalPlayer.Character.Humanoid:EquipTool(ToolHumanoid) 
			end
		end
	end)
end

function EquipWeaponSword()
	pcall(function()
		for i,v in pairs(game.Players.LocalPlayer.Backpack:GetChildren()) do
			if v.ToolTip == "Sword" and v:IsA('Tool') then
				local ToolHumanoid = game.Players.LocalPlayer.Backpack:FindFirstChild(v.Name) 
				game.Players.LocalPlayer.Character.Humanoid:EquipTool(ToolHumanoid) 
			end
		end
	end)
end

function EquipWeaponFruit()
	pcall(function()
		for i,v in pairs(game.Players.LocalPlayer.Backpack:GetChildren()) do
			if v.ToolTip == "Blox Fruit" and v:IsA('Tool') then
				local ToolHumanoid = game.Players.LocalPlayer.Backpack:FindFirstChild(v.Name) 
				game.Players.LocalPlayer.Character.Humanoid:EquipTool(ToolHumanoid) 
			end
		end
	end)
end

function EquipWeaponGun()
	pcall(function()
		for i,v in pairs(game.Players.LocalPlayer.Backpack:GetChildren()) do
			if v.ToolTip == "Gun" and v:IsA('Tool') then
				local ToolHumanoid = game.Players.LocalPlayer.Backpack:FindFirstChild(v.Name) 
				game.Players.LocalPlayer.Character.Humanoid:EquipTool(ToolHumanoid) 
			end
		end
	end)
end

function Hopl()
    game.StarterGui:SetCore("SendNotification", {
        Title = "KTH Hub [ Shark Anchor ]",
        Text = "Hopping...",
        Duration = 3,
        Icon = ""
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

function GetCountMaterials(L_V1, L_V2)
    local L_V3 = game:GetService("ReplicatedStorage").Remotes.CommF_:InvokeServer("getInventory")
    for _, L_V4 in pairs(L_V3) do
        if L_V4.Name == L_V1 and L_V4.Count >= L_V2 then
            return true
        end
    end
    return false
end

function checkmas(_type, name)
    local MAS = game:GetService("ReplicatedStorage").Remotes.CommF_:InvokeServer("getInventory")
    for i, v in pairs(MAS) do
        if v.Type == _type and v.Name == name then
            return v.Mastery
        end
    end
    return false
end

spawn(function()
    while task.wait(1) do
      if getgenv().Loaded then
        I_V1 = checkInventory("Shark Tooth Necklace")
        I_V2 = checkInventory("Terror Jaw")
        I_V3 = checkInventory("Monster Magnet")
        I_V4 = checkInventory("Shark Anchor")
        I_V5 = checkInventory("Saber")

        MS_V1 = checkmas("Sword", "Saber")
        MS_V2 = checkmas("Sword", "Shark Anchor")

        M_V1 = function(S) return GetCountMaterials("Mutant Tooth", S) == true end
        M_V2 = function(S) return GetCountMaterials("Shark Tooth", S) == true end
        M_V3 = function(S) return GetCountMaterials("Terror Eyes", S) == true end
        M_V4 = function(S) return GetCountMaterials("Fool's Gold", S) == true end
        M_V5 = function(S) return GetCountMaterials("Electric Wings", S) == true end
        task.wait(0.1)
        getgenv().Checked = true
        end
    end
end)

--// Get Sb & Farm Mas
function FMS(sw)
    if not game.Players.LocalPlayer.Backpack:FindFirstChild(sw) and not game.Players.LocalPlayer.Character:FindFirstChild(sw) then
        game:GetService("ReplicatedStorage").Remotes.CommF_:InvokeServer("LoadItem", sw)
        return
    end
    
    if not World3 then
        game:GetService("ReplicatedStorage").Remotes.CommF_:InvokeServer("TravelZou")
    end
    
    if not game.Players.LocalPlayer.Character or not game.Players.LocalPlayer.Character:FindFirstChild("HumanoidRootPart") then 
        return 
    end

    local Mob_V1 = {"Reborn Skeleton", "Living Zombie", "Demonic Soul", "Posessed Mummy"}

    for _, MobsN in ipairs(Mob_V1) do
        local mobs = {}
        for _, v in pairs(workspace.Enemies:GetChildren()) do
            if v.Name == MobsN and v:FindFirstChild("HumanoidRootPart") and v:FindFirstChild("Humanoid") and v.Humanoid.Health > 0 then
                table.insert(mobs, v)
            end
        end

        if #mobs > 0 then
            table.sort(mobs, function(a, b)
                return (game.Players.LocalPlayer.Character.HumanoidRootPart.Position - a.HumanoidRootPart.Position).Magnitude < 
                       (game.Players.LocalPlayer.Character.HumanoidRootPart.Position - b.HumanoidRootPart.Position).Magnitude
            end)

            for _, mob in ipairs(mobs) do
                if mob and mob:FindFirstChild("Humanoid") and mob.Humanoid.Health > 0 and mob:FindFirstChild("HumanoidRootPart") then
                    NearestTarget = mob.Name
                    repeat
                        task.wait()
                        AutoHaki()
                        EquipWeapon(sw)
                        TP1(mob.HumanoidRootPart.CFrame * CFrame.new(0, 20, 0))
                        MonFarm = mob.Name
                        PosMon = mob.HumanoidRootPart.CFrame
                        getgenv().BringMon = true
                    until not mob.Parent or mob.Humanoid.Health <= 0
                    getgenv().BringMon = false
                end
            end
        end
    end

    TP1(CFrame.new(-9506.234375, 172.130615234375, 6117.0771484375))
end

spawn(function()
    while task.wait(0.1) do
        if not I_V5 and getgenv().Checked then
            if not game.Players.LocalPlayer.Character or not game.Players.LocalPlayer.Character:FindFirstChild("HumanoidRootPart") then 
                continue 
            end
            
            if not World1 then
            game:GetService("ReplicatedStorage").Remotes.CommF_:InvokeServer("TravelMain")
            end
            
            if game:GetService("Workspace").Map.Jungle.Final.Part.Transparency == 0 then
                if game:GetService("Workspace").Map.Jungle.QuestPlates.Door.Transparency == 0 then
                    if (CFrame.new(-1612.55884, 36.9774132, 148.719543).Position - game.Players.LocalPlayer.Character.HumanoidRootPart.Position).Magnitude <= 100 then
                        TP1(game.Players.LocalPlayer.Character.HumanoidRootPart.CFrame)
                        task.wait(1)
                        for i = 1, 5 do
                            game:GetService("ReplicatedStorage").Remotes.CommF_:InvokeServer("ProQuestProgress", "Plate", i)
                            task.wait(0.5)
                        end
                    else
                        TP1(CFrame.new(-1612.55884, 36.9774132, 148.719543))
                    end
                else
                    if game:GetService("Workspace").Map.Desert.Burn.Part.Transparency == 0 then
                        if game.Players.LocalPlayer.Backpack:FindFirstChild("Torch") or game.Players.LocalPlayer.Character:FindFirstChild("Torch") then
                            EquipWeapon("Torch")
                            TP1(CFrame.new(1110.631591796875, 5.235761642456055, 4353.2412109375))
                            game:GetService("VirtualInputManager"):SendKeyEvent(true, "Space", false, game)
                            task.wait(1)
                            game:GetService("VirtualInputManager"):SendKeyEvent(false, "Space", false, game)
                        else
                            TP1(CFrame.new(-1610.00757, 11.5049858, 164.001587))
                        end
                    else
                        if game:GetService("ReplicatedStorage").Remotes.CommF_:InvokeServer("ProQuestProgress", "SickMan") ~= 0 then
                            game:GetService("ReplicatedStorage").Remotes.CommF_:InvokeServer("ProQuestProgress", "GetCup")
                            task.wait(0.5)
                            EquipWeapon("Cup")
                            task.wait(0.5)
                            game:GetService("ReplicatedStorage").Remotes.CommF_:InvokeServer("ProQuestProgress", "FillCup", game.Players.LocalPlayer.Character.Cup)
                            task.wait()
                            game:GetService("ReplicatedStorage").Remotes.CommF_:InvokeServer("ProQuestProgress", "SickMan")
                        else
                            if game:GetService("ReplicatedStorage").Remotes.CommF_:InvokeServer("ProQuestProgress", "RichSon") == nil then
                                game:GetService("ReplicatedStorage").Remotes.CommF_:InvokeServer("ProQuestProgress", "RichSon")
                            elseif game:GetService("ReplicatedStorage").Remotes.CommF_:InvokeServer("ProQuestProgress", "RichSon") == 0 then
                                if game:GetService("Workspace").Enemies:FindFirstChild("Mob Leader") or game:GetService("ReplicatedStorage"):FindFirstChild("Mob Leader") then
                                    TP1(CFrame.new(-2892.87451171875, 22.10824966430664, 5445.8857421875))
                                    for _, v in pairs(game:GetService("Workspace").Enemies:GetChildren()) do
                                        if v.Name == "Mob Leader" and v:FindFirstChild("Humanoid") and v:FindFirstChild("HumanoidRootPart") and v.Humanoid.Health > 0 then
                                            repeat 
                                                task.wait()
                                                AutoHaki()
                                                EquipWeaponMelee()
                                                TP1(v.HumanoidRootPart.CFrame * CFrame.new(0, 20, 0))
                                            until not v.Parent or v.Humanoid.Health <= 0 
                                        end
                                    end
                                end
                            elseif game:GetService("ReplicatedStorage").Remotes.CommF_:InvokeServer("ProQuestProgress", "RichSon") == 1 then
                                game:GetService("ReplicatedStorage").Remotes.CommF_:InvokeServer("ProQuestProgress", "RichSon")
                                task.wait(0.5)
                                EquipWeapon("Relic")
                                task.wait(0.5)
                                TP1(CFrame.new(-1406.6300048828125, 30.166263580322266, 3.0864763259887695))
                            end
                        end
                    end
                end
            else
                if game:GetService("Workspace").Enemies:FindFirstChild("Saber Expert") or game:GetService("ReplicatedStorage"):FindFirstChild("Saber Expert") then
                    TP1(CFrame.new(-1401.85046, 29.9773273, 8.81916237))
                    for _, v in pairs(game:GetService("Workspace").Enemies:GetChildren()) do
                        if v.Name == "Saber Expert" and v:FindFirstChild("Humanoid") and v:FindFirstChild("HumanoidRootPart") and v.Humanoid.Health > 0 then
                            repeat 
                                task.wait()
                                AutoHaki()
                                EquipWeaponMelee()
                                TP1(v.HumanoidRootPart.CFrame * CFrame.new(0, 20, 0))
                                game:GetService("ReplicatedStorage").Remotes.CommF_:InvokeServer("SetSpawnPoint")
                            until not v.Parent or v.Humanoid.Health <= 0 
                            
                            if v.Humanoid.Health <= 0 then
                                game:GetService("ReplicatedStorage").Remotes.CommF_:InvokeServer("ProQuestProgress", "PlaceRelic")
                            end
                        end
                    end
                else
                    Hopl()
                end
            end
        end
    end
end)

spawn(function()
   while task.wait(0.1) do
       if I_V5 and MS_V1 and MS_V1 < 125 and getgenv().Checked then
         FMS("Saber")
       end
   end
end)

spawn(function()
   while task.wait(0.1) do
       if I_V4 and MS_V2 and MS_V2 < 350 and getgenv().Checked then
         FMS("Shark Anchor")
       end
   end
end)
--// Buy Shark Anchor
spawn(function()
    while task.wait(1) do
        if not I_V4 and I_V5 and MS_V1 and MS_V1 >= 125 and getgenv().Checked then
            if not I_V1 and M_V1(1) and M_V2(5) then
                local args = {
                    [1] = "CraftItem",
                    [2] = "Craft",
                    [3] = "ToothNecklace"
                }
                game:GetService("ReplicatedStorage").Remotes.CommF_:InvokeServer(unpack(args))
            elseif I_V1 and not I_V2 and M_V3(1) and M_V1(2) and M_V4(10) and M_V2(5) then
                local args = {
                    [1] = "CraftItem",
                    [2] = "Craft",
                    [3] = "TerrorJaw"
                }
                game:GetService("ReplicatedStorage").Remotes.CommF_:InvokeServer(unpack(args))
            elseif I_V1 and I_V2 and not I_V3 and M_V3(2) and M_V5(8) and M_V4(20) and M_V2(10) then
                local args = {
                    [1] = "CraftItem",
                    [2] = "Craft",
                    [3] = "SharkAnchor"
                }
                game:GetService("ReplicatedStorage").Remotes.CommF_:InvokeServer(unpack(args))
            end
        end
    end
end)

--// Drive Boat
function E_V1(E_V2)
    if not game.Players.LocalPlayer.Character or not game.Players.LocalPlayer.Character:FindFirstChild("HumanoidRootPart") then 
        return false 
    end

    local P_V1 = game.Players.LocalPlayer.Character.HumanoidRootPart.Position
    local E_V3 = {
        "Shark",
        "Terrorshark",
        "Piranha",
        "Fish Crew Member",
        "PirateBrigade",
        "PirateGrandBrigade",
        "FishBoat",
        "SeaBeast1"
    }

    for _, E_V4 in pairs({game.Workspace.Enemies, game.Workspace.SeaBeasts}) do
        for _, E_V5 in pairs(E_V4:GetChildren()) do
            if table.find(E_V3, E_V5.Name) then
                local E_V6 = E_V5:FindFirstChild("HumanoidRootPart")
                local E_V7 = (E_V5.Name == "PirateBrigade" or E_V5.Name == "PirateGrandBrigade" or E_V5.Name == "FishBoat") and E_V5:FindFirstChild("VehicleSeat")
                local E_V8 = (E_V6 and (E_V6.Position - P_V1).Magnitude <= 800) or (E_V7 and (E_V7.Position - P_V1).Magnitude <= 800)
                if E_V8 then
                    if E_V2 == "all" then
                        return E_V5.Name
                    elseif typeof(E_V2) == "string" and E_V5.Name == E_V2 then
                        return E_V5.Name
                    elseif typeof(E_V2) == "table" and table.find(E_V2, E_V5.Name) then
                        return E_V5.Name
                    end
                end
            end
        end
    end

    return false
end

local function R_V1()
    local R_V2 = game.Workspace._WorldOrigin.Locations:FindFirstChild("Rough Sea")
    if R_V2 and game.Players.LocalPlayer.Character and game.Players.LocalPlayer.Character:FindFirstChild("HumanoidRootPart") then
        local P_V1 = game.Players.LocalPlayer.Character.HumanoidRootPart.Position
        return (P_V1 - R_V2.Position).Magnitude
    end
    return nil
end

function AddEsp(Text, Name, Parent)
    local BillboardGui = Instance.new("BillboardGui")
    BillboardGui.Parent = Parent
    BillboardGui.Name = Name
    BillboardGui.AlwaysOnTop = true
    BillboardGui.Size = UDim2.new(0, 200, 0, 50)
    BillboardGui.StudsOffset = Vector3.new(0, 2.5, 0)
    BillboardGui.ZIndexBehavior = Enum.ZIndexBehavior.Sibling
    BillboardGui.LightInfluence = 1

    local TextLabel = Instance.new("TextLabel")
    TextLabel.Parent = BillboardGui
    TextLabel.Size = UDim2.new(1, 0, 1, 0)
    TextLabel.BackgroundTransparency = 1
    TextLabel.Font = Enum.Font.GothamBold
    TextLabel.Text = Text
    TextLabel.TextColor3 = Color3.fromRGB(255, 50, 50)
    TextLabel.TextSize = 18
    TextLabel.TextStrokeTransparency = 0
    TextLabel.TextStrokeColor3 = Color3.fromRGB(0, 0, 0)
end

function B_V1()
    for _, B_V2 in next, workspace.Boats:GetChildren() do
        if B_V2:IsA("Model") and B_V2.Name == "Guardian" then
            if B_V2:FindFirstChild("Owner") and tostring(B_V2.Owner.Value) == game.Players.LocalPlayer.Name and B_V2.Humanoid.Value > 0 then
                return B_V2
            end
        end
    end
    return false
end

function Teleport_Boat(CF_V1)
    local S_V1 = game:GetService("TweenService")
    local P_V1 = game.Players.LocalPlayer
    local P_V2 = P_V1.Character and P_V1.Character:FindFirstChild("HumanoidRootPart")
    if not P_V2 then return end

    for _, B_V1 in pairs(game.Workspace.Boats:GetChildren()) do
        if B_V1:FindFirstChild("VehicleSeat") and B_V1:FindFirstChild("Owner") then
            if tostring(B_V1.Owner.Value) == P_V1.Name then
                local S_V2 = B_V1.VehicleSeat
                if (S_V2.Position - P_V2.Position).Magnitude <= 5 then
                    local T_V2 = S_V1:Create(S_V2, TweenInfo.new((S_V2.Position - CF_V1.Position).Magnitude / 300, Enum.EasingStyle.Linear), {CFrame = CF_V1})
                    T_V2:Play()
                    spawn(function()
                        while T_V2 and T_V2.PlaybackState == Enum.PlaybackState.Playing do
                            task.wait(0.1)
                            local P_V3 = P_V1.Character and P_V1.Character:FindFirstChild("HumanoidRootPart")
                            if not P_V3 or (S_V2.Position - P_V3.Position).Magnitude > 100 then
                                T_V2:Cancel()
                                break
                            end
                        end
                    end)
                    return T_V2
                end
            end
        end
    end
end

local S_V1 = nil
local lastRoughSeaTime = 0
local lastSeaBeastTime = 0
local flyingFromRoughSea = false
local flyingFromSeaBeast = false

spawn(function()
	while task.wait() do
		if getgenv().Config["Shark Anchor"]["Enabled"] and not I_V4 and I_V5 and MS_V1 and MS_V1 >= 125 and getgenv().Checked then
			pcall(function()
				if not game.Players.LocalPlayer.Character or not game.Players.LocalPlayer.Character:FindFirstChild("HumanoidRootPart") then return end

				if not World3 then
					game:GetService("ReplicatedStorage").Remotes.CommF_:InvokeServer("TravelZou")
				end

				local currentTime = tick()
				local roughSeaDetected = R_V1() and R_V1() <= 800
				local seaBeastDetected = E_V1({"PirateBrigade", "PirateGrandBrigade", "SeaBeast1"})

				if roughSeaDetected and not flyingFromRoughSea then
					lastRoughSeaTime = currentTime
					flyingFromRoughSea = true
				end
				if seaBeastDetected and not flyingFromSeaBeast then
					lastSeaBeastTime = currentTime
					flyingFromSeaBeast = true
				end

				if flyingFromRoughSea or flyingFromSeaBeast then
					if getgenv().MK == "None" then
						if getgenv().Config["Shark Anchor"]["Leave Rough Sea"] then
							local shouldFlyFromRoughSea = flyingFromRoughSea and (currentTime - lastRoughSeaTime < 3)
							local shouldFlyFromSeaBeast = flyingFromSeaBeast and (currentTime - lastSeaBeastTime < 3)

							if shouldFlyFromRoughSea or shouldFlyFromSeaBeast then
								if game.Players.LocalPlayer.Character.Humanoid.Sit then
									game.Players.LocalPlayer.Character.Humanoid.Sit = false
								end
								task.wait(1)
								local P_V1 = game.Players.LocalPlayer.Character.HumanoidRootPart.Position
								TP1(CFrame.new(P_V1.X, P_V1.Y + 3000, P_V1.Z))
							else
								if not roughSeaDetected then
									flyingFromRoughSea = false
								end
								if currentTime - lastSeaBeastTime >= 15 then
									flyingFromSeaBeast = false
								end
							end
						end
					end
				else
					flyingFromRoughSea = false
					flyingFromSeaBeast = false

					if not E_V1({"Shark", "Terrorshark", "Piranha", "Fish Crew Member", "FishBoat"}) then
						local boat = B_V1()
						if not boat then
							if World3 then
								TP1(CFrame.new(-16927, 9, 433))
								if (game.Players.LocalPlayer.Character.HumanoidRootPart.Position - Vector3.new(-16927, 9, 433)).Magnitude <= 10 then
									game.ReplicatedStorage.Remotes.CommF_:InvokeServer("BuyBoat", "Guardian")
								end
							end
						else
							if not boat:FindFirstChild("YOUR_BOAT_ESP") then
								AddEsp("Your Boat", "YOUR_BOAT_ESP", boat)
							end
							if not game.Players.LocalPlayer.Character.Humanoid.Sit and not E_V1({"PirateBrigade", "PirateGrandBrigade", "SeaBeast1"}) then
								TP1(boat.VehicleSeat.CFrame * CFrame.new(0, 1, 0))
							else
								S_V1 = boat.VehicleSeat.Position
								if World3 then
									local D_V1 = CFrame.new(-42250, 50, 9247)
									local D_V2 = (boat.VehicleSeat.Position - D_V1.Position).Magnitude
									if D_V2 > 350 then
										for _, P_V2 in pairs(boat:GetDescendants()) do
											if P_V2:IsA("BasePart") then
												P_V2.CanCollide = false
												P_V2.Velocity = Vector3.new(0, 0, 0)
												P_V2.RotVelocity = Vector3.new(0, 0, 0)
											end
										end
										boat.VehicleSeat.CFrame = CFrame.new(boat.VehicleSeat.Position.X, 300, boat.VehicleSeat.Position.Z)
										Teleport_Boat(D_V1)
									else
										for _, B_V2 in pairs(game.Workspace.Boats:GetChildren()) do
											if B_V2:FindFirstChild("VehicleSeat") and B_V2.Owner.Value == game.Players.LocalPlayer then
												if (B_V2.VehicleSeat.Position - game.Players.LocalPlayer.Character.HumanoidRootPart.Position).Magnitude <= 10 then
													for _, P_V3 in pairs(B_V2:GetDescendants()) do
														if P_V3:IsA("BasePart") then
															P_V3.CanCollide = false
															P_V3.Velocity = Vector3.new(0, 0, 0)
															P_V3.RotVelocity = Vector3.new(0, 0, 0)
														end
													end
													B_V2.VehicleSeat.CFrame = CFrame.new(B_V2.VehicleSeat.Position.X, 24, B_V2.VehicleSeat.Position.Z)
												end
											end
										end
									end
								end
							end
						end
					end

					if not B_V1() and getgenv().Config["Shark Anchor"]["Reset if no boat found"] and S_V1 and not E_V1({"Shark", "Terrorshark", "Piranha", "Fish Crew Member", "FishBoat"}) then
						game.Players.LocalPlayer.Character.Head:Destroy()
						S_V1 = nil
					end
				end
			end)
		end
	end
end)

spawn(function()
    while task.wait() do
        if getgenv().Config["Shark Anchor"]["Enabled"] and E_V1({"Shark", "Terrorshark", "Piranha", "Fish Crew Member", "FishBoat"}) and not I_V4 and I_V5 and MS_V1 and MS_V1 >= 125 then
            if game.Players.LocalPlayer.Character and game.Players.LocalPlayer.Character:FindFirstChild("Humanoid") then
                if game.Players.LocalPlayer.Character.Humanoid.Sit then
                    game.Players.LocalPlayer.Character.Humanoid.Sit = false
                end
            end
        end
    end
end)


--// Attack Sea Monster

spawn(function()
        local gg = getrawmetatable(game)
        local old = gg.__namecall
        setreadonly(gg, false)
        gg.__namecall = newcclosure(function(...)
            local method = getnamecallmethod()
            local args = {...}
            if tostring(method) == "FireServer" then
                if tostring(args[1]) == "RemoteEvent" then
                    if tostring(args[2]) ~= "true" and tostring(args[2]) ~= "false" then
                        if getgenv().Aimbot then
                            if type(args[2]) == "vector" then
                                args[2] = aimpos
                            else
                                args[2] = CFrame.new(aimpos)
                            end
                            return old(unpack(args))
                        end
                    end
                end
            end
            return old(...)
        end)
    end)
    
function SendKey(Key)
    game:GetService("VirtualInputManager"):SendKeyEvent(true, Key, false, game)
    game:GetService("VirtualInputManager"):SendKeyEvent(false, Key, false, game)
end

function SendKey(Key)
    game:GetService("VirtualInputManager"):SendKeyEvent(true, Key, false, game)
    game:GetService("VirtualInputManager"):SendKeyEvent(false, Key, false, game)
end

function AutoSkill()
    local weaponList = getgenv().Config["Shark Anchor"] and getgenv().Config["Shark Anchor"]["Select Weapon"]
    local skillList = getgenv().Config["Shark Anchor"] and getgenv().Config["Shark Anchor"]["Select Skills"]
    if not weaponList or not skillList then return end

    local char = game.Players.LocalPlayer.Character
    if not char then return end

    for _, weapon in ipairs(weaponList) do
        local tool

        if weapon == "Melee" then
            EquipWeaponMelee()
            task.wait()
            tool = char:FindFirstChildOfClass("Tool")
            if tool and tool.ToolTip == "Melee" then
                for _, skill in ipairs(skillList) do
                    if skill == "Z" or skill == "X" or skill == "C" then
                        SendKey(skill)
                    end
                end
            end
            task.wait(1)

        elseif weapon == "Sword" then
            EquipWeaponSword()
            task.wait()
            tool = char:FindFirstChildOfClass("Tool")
            if tool and tool.ToolTip == "Sword" then
                for _, skill in ipairs(skillList) do
                    if skill == "Z" or skill == "X" then
                        SendKey(skill)
                    end
                end
            end
            task.wait(1)

        elseif weapon == "Gun" then
            EquipWeaponGun()
            task.wait()
            tool = char:FindFirstChildOfClass("Tool")
            if tool and tool.ToolTip == "Gun" then
                for _, skill in ipairs(skillList) do
                    if skill == "Z" or skill == "X" then
                        SendKey(skill)
                    end
                end
            end
            task.wait(1)

        elseif weapon == "Blox Fruit" then
            local fruitName = game.Players.LocalPlayer.Data and game.Players.LocalPlayer.Data.DevilFruit.Value
            EquipWeaponFruit()
            task.wait()
            local fruit = char:FindFirstChild(fruitName)
            if fruit and fruit:FindFirstChild("Level") then
                local level = fruit.Level.Value
                for _, skill in ipairs(skillList) do
                    local required = skill == "Z" and 1 or skill == "X" and 2 or skill == "C" and 3 or skill == "V" and 4 or skill == "F" and 5 or math.huge
                    if level >= required then
                        SendKey(skill)
                    end
                end
            end
            task.wait(1)
        end
    end
end

local r = game:GetService("ReplicatedStorage").Remotes.CommF_:InvokeServer("BuySharkmanKarate")
spawn(function()
    while task.wait(1) do
        if not game.Players.LocalPlayer.Character:FindFirstChild("Saber") and not game.Players.LocalPlayer.Backpack:FindFirstChild("Saber") and I_V5 and not I_V4 then
            game:GetService("ReplicatedStorage").Remotes.CommF_:InvokeServer("LoadItem", "Saber")
        elseif not game.Players.LocalPlayer.Character:FindFirstChild("Sharkman Karate") and not game.Players.LocalPlayer.Backpack:FindFirstChild("Sharkman Karate") and (r == 1 or r == 2) and not I_V4 then
            game:GetService("ReplicatedStorage").Remotes.CommF_:InvokeServer("BuySharkmanKarate", true)
            game:GetService("ReplicatedStorage").Remotes.CommF_:InvokeServer("BuySharkmanKarate")
        end
    end
end)

getgenv().MK = ""
local lon = {FishBoat = true}
local cac = {
	Piranha = true,
	Terrorshark = true,
	Shark = true,
	["Fish Crew Member"] = true,
}

spawn(function()
	while task.wait(0.1) do
		if getgenv().Config["Shark Anchor"]["Enabled"] and not I_V4 and I_V5 and MS_V1 and MS_V1 >= 125 and getgenv().Checked then
			pcall(function()
				if not game.Players.LocalPlayer.Character or not game.Players.LocalPlayer.Character:FindFirstChild("HumanoidRootPart") then return end
				local SM_Found = false
				for _, v in ipairs(workspace.Enemies:GetChildren()) do
					local part = v:FindFirstChild("HumanoidRootPart") or v:FindFirstChild("VehicleSeat")
					if part and (part.Position - game.Players.LocalPlayer.Character.HumanoidRootPart.Position).Magnitude <= 800 then
						local n = v.Name
						if lon[n] or cac[n] then
							getgenv().MK = "Kill " .. n
							SM_Found = true
							break
						end
					end
				end
				if not SM_Found then getgenv().MK = "None" end
			end)
		else
			task.wait(1)
		end
	end
end)

local function Kill_Sea_Monster(name, isBoat, offset, special)
    spawn(function()
        while task.wait(0.1) do
            if getgenv().MK == "Kill " .. name and getgenv().Config["Shark Anchor"]["Enabled"] and not I_V4 and I_V5 and MS_V1 and MS_V1 >= 125 then
                for _, v in pairs(workspace.Enemies:GetChildren()) do
                    local part = v:FindFirstChild(isBoat and "VehicleSeat" or "HumanoidRootPart")
                    local valid = isBoat and v:FindFirstChild("Health") and v.Health.Value > 0 or v:FindFirstChild("Humanoid") and v.Humanoid.Health > 0
                    if v.Name == name and part and valid then
                        local lp = game.Players.LocalPlayer
                        local char = lp.Character
                        local hrp = char and char:FindFirstChild("HumanoidRootPart")
                        local hum = char and char:FindFirstChild("Humanoid")
                        if not hrp or not hum then break end
                        local dist = (part.Position - hrp.Position).Magnitude
                        if dist <= 800 then
                            repeat task.wait(0.1)
                                pcall(function()
                                    AutoHaki()
                                    if not isBoat then
                                    EquipWeaponMelee()
                                    end
                                    if hum.Health / hum.MaxHealth < 0.5 and name ~= "Piranha" then
                                        local safePos = hrp.Position + (hrp.Position - part.Position).Unit * 150
                                        TP1(CFrame.new(safePos))
                                    else
                                        if special then
                                            special(v)
                                        else
                                            TP1(part.CFrame * offset)
                                        end
                                        if isBoat then
                                            getgenv().Aimbot = true
                                            aimpos = part.CFrame
                                            AutoSkill()
                                        end
                                    end
                                end)
                            until not v or not v.Parent or (isBoat and v.Health.Value <= 0) or (not isBoat and v.Humanoid.Health <= 0) or getgenv().MK ~= "Kill " .. name or not getgenv().Config["Shark Anchor"]["Enabled"]
                            if isBoat then getgenv().Aimbot = false end
                        end
                    end
                end
            end
        end
    end)
end

Kill_Sea_Monster("Piranha", false, CFrame.new(0, 35, 0))
Kill_Sea_Monster("Shark", false, CFrame.new(0, 35, 0))
Kill_Sea_Monster("Fish Crew Member", false, CFrame.new(0, 35, 0))
Kill_Sea_Monster("Terrorshark", false, nil, function(v)
    if workspace["_WorldOrigin"]:FindFirstChild("SpinSlash") or workspace["_WorldOrigin"]:FindFirstChild("SharkSplash") then
        TP1(v.HumanoidRootPart.CFrame * CFrame.new(0, 250, 0))
    else
        TP1(v.HumanoidRootPart.CFrame * CFrame.new(10, 40, 5))
    end
end)
Kill_Sea_Monster("FishBoat", true, CFrame.new(0, 10, 0))
warn("loaded")
end

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

spawn(function()
    while task.wait(0.1) do
        pcall(function()
            FastAttack:Attack()
        end)
    end
end)

local Players = game:GetService("Players")
local RunService = game:GetService("RunService")
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local Enemies = workspace.Enemies

local LocalPlayer = Players.LocalPlayer
local Character = LocalPlayer.Character or LocalPlayer.CharacterAdded:Wait()
local HRP = Character:WaitForChild("HumanoidRootPart")

local mobInitialPos = {}
local lastTouched = {}
local ghostStartTime = {}
local teleportCount = {}
local lastPositionCheck = {}
local currentTargets = {}

local function ForceCFrame(part, cf)
    part.CFrame = cf
    part.Velocity = Vector3.zero
    part.RotVelocity = Vector3.zero
end

local function GetMobId(mob)
    local idValue = mob:FindFirstChild("ID") or mob:FindFirstChild("MobID")
    if idValue and idValue:IsA("StringValue") then
        return idValue.Value
    else
        return mob:GetDebugId()
    end
end

local function DetectGhost(mob)
    local gui = Players.LocalPlayer:FindFirstChild("PlayerGui")
    local counterOn = gui and gui:FindFirstChild("Main") and gui.Main:FindFirstChild("Settings") and gui.Main.Settings:FindFirstChild("Buttons") and gui.Main.Settings.Buttons:FindFirstChild("DmgCounterButton") and gui.Main.Settings.Buttons.DmgCounterButton:FindFirstChild("TextLabel") and gui.Main.Settings.Buttons.DmgCounterButton.TextLabel.Text == "Counter (ON)"
    local dmg = gui and gui:FindFirstChild("Main") and gui.Main:FindFirstChild("DmgCounter") and gui.Main.DmgCounter:FindFirstChild("Text")
    local dmgCounter = dmg and dmg.Text
    if counterOn then
        if dmgCounter == "0" then
            if not ghostStartTime[mob] then
                ghostStartTime[mob] = tick()
            elseif tick() - ghostStartTime[mob] >= 2 then
                return true
            end
        else
            ghostStartTime[mob] = nil
        end
    else
        if not ghostStartTime[mob] then
            ghostStartTime[mob] = tick()
        elseif tick() - ghostStartTime[mob] >= 5 then
            return true
        end
    end
    return false
end

local function TeleportToInitial(mob, id)
    local pos = mobInitialPos[id]
    if pos then
        HRP.CFrame = CFrame.new(pos + Vector3.new(0, 5, 0))
        lastTouched[mob] = tick()
        teleportCount[id] = (teleportCount[id] or 0) + 1
        if teleportCount[id] >= 7 then
            local humanoid = mob:FindFirstChild("Humanoid")
            if humanoid then humanoid:TakeDamage(999999) end
        end
        task.wait(0.15)
    end
end

local function GetNetworkOwnership(part)
    pcall(function()
        if part and part:IsA("BasePart") then
            part:SetNetworkOwner(LocalPlayer)
        end
    end)
end

local function IsPlayerNearby(position, radius)
    for _, player in pairs(Players:GetPlayers()) do
        if player ~= LocalPlayer and player.Character and player.Character:FindFirstChild("HumanoidRootPart") then
            if (player.Character.HumanoidRootPart.Position - position).Magnitude <= radius then
                return true
            end
        end
    end
    return false
end

local function IsStuck(mob, id)
    local now = tick()
    local pos = mob.HumanoidRootPart.Position
    local lastData = lastPositionCheck[id]
    if not lastData then
        lastPositionCheck[id] = {Pos = pos, Time = now}
        return false
    end
    if (pos - lastData.Pos).Magnitude <= 1 and now - lastData.Time >= 2 then
        return true
    end
    if (pos - lastData.Pos).Magnitude > 1 then
        lastPositionCheck[id] = {Pos = pos, Time = now}
    end
    return false
end

task.spawn(function()
    while task.wait(0.1) do
        pcall(function()
            if getgenv().BringMon and PosMon then
                task.delay(2,function()
                    getgenv().BringWait = false
                end)
                if #currentTargets == 0 then
                    for _, mob in pairs(Enemies:GetChildren()) do
                        if mob:FindFirstChild("Humanoid") and mob:FindFirstChild("HumanoidRootPart") and mob.Humanoid.Health > 0 and (mob.Name == MonFarm or mob.Name == NameMon) then
                            local id = GetMobId(mob)
                            local pos = mob.HumanoidRootPart.Position
                            local distance = (pos - HRP.Position).Magnitude
                            
                            if distance > 200 then
                                continue
                            end
                            
                            if IsPlayerNearby(pos, 50) then
                                continue
                            end
                            if IsStuck(mob, id) then
                                mob.Humanoid:TakeDamage(999999)
                                continue
                            end
                            mobInitialPos[id] = mobInitialPos[id] or pos
                            pcall(function()
                                GetNetworkOwnership(mob.HumanoidRootPart)
                            end)
                            table.insert(currentTargets, mob)
                            if #currentTargets >= 2 then
                                break
                            end
                        end
                    end
                else
                    local alive = 0
                    for i = #currentTargets, 1, -1 do
                        local mob = currentTargets[i]
                        if mob and mob.Parent and mob:FindFirstChild("Humanoid") and mob:FindFirstChild("HumanoidRootPart") then
                            local id = GetMobId(mob)
                            if mob.Humanoid.Health <= 0 then
                                teleportCount[id] = nil
                                lastPositionCheck[id] = nil
                                table.remove(currentTargets, i)
                            elseif DetectGhost(mob) then
                                TeleportToInitial(mob, id)
                                table.remove(currentTargets, i)
                                getgenv().BringWait = true
                            else
                                setscriptable(LocalPlayer, "SimulationRadius", true)
                                sethiddenproperty(LocalPlayer, "SimulationRadius", math.huge)
                                pcall(function()
                                    GetNetworkOwnership(mob.HumanoidRootPart)
                                end)
                                ForceCFrame(mob.HumanoidRootPart, CFrame.new(PosMon.Position + PosMon.LookVector * 0.01))
                                lastTouched[mob] = lastTouched[mob] or tick()
                                alive += 1
                            end
                        else
                            table.remove(currentTargets, i)
                        end
                    end
                    if alive == 0 then
                        currentTargets = {}
                    end
                end
            end
        end)
    end
end)

spawn(function()
    RunService.RenderStepped:Connect(function()
        pcall(function()
            for monster, data in pairs(stabilizedMobMonsters) do
                if monster and monster.Parent and monster:FindFirstChild("HumanoidRootPart") and monster.Humanoid.Health > 0 then
                    local t = tick()
                    local x = math.sin(t * data.RockSpeedX + data.FloatPhase) * 0.5
                    local z = math.cos(t * data.RockSpeedZ + data.FloatPhase) * 0.5
                    LockPosition(monster.HumanoidRootPart, data.Position + Vector3.new(x, 0, z))
                    data.LastUpdate = tick()
                else
                    stabilizedMobMonsters[monster] = nil
                end
            end
        end)
    end)
end)
getgenv().NoClip = true

local Players = game:GetService("Players")
local RunService = game:GetService("RunService")
local LocalPlayer = Players.LocalPlayer

RunService.Stepped:Connect(function()
    pcall(function()
        local char = LocalPlayer.Character
        local head = char and char:FindFirstChild("Head")
        local hrp = char and char:FindFirstChild("HumanoidRootPart")

        if not (char and head and hrp) then return end

        if getgenv().NoClip then
            if not head:FindFirstChild("BodyClip") then
                local bv = Instance.new("BodyVelocity")
                bv.Name = "BodyClip"
                bv.Velocity = Vector3.new(0, 0, 0)
                bv.MaxForce = Vector3.new(math.huge, math.huge, math.huge)
                bv.P = 15000
                bv.Parent = head
            end

            for _, v in ipairs(char:GetDescendants()) do
                if v:IsA("BasePart") then
                    v.CanCollide = false
                end
            end
        else
            local existingClip = head:FindFirstChild("BodyClip")
            if existingClip then
                existingClip:Destroy()
            end

            for _, v in ipairs(char:GetDescendants()) do
                if v:IsA("BasePart") then
                    v.CanCollide = true
                end
            end
        end
    end)
end)

game:GetService("Players").LocalPlayer.Idled:connect(function()
game:GetService("VirtualUser"):Button2Down(Vector2.new(0,0),workspace.CurrentCamera.CFrame)
wait(50)
game:GetService("VirtualUser"):Button2Up(Vector2.new(0,0),workspace.CurrentCamera.CFrame)
end) 

task.delay(1,function()
  getgenv().Loaded = true
end)