-- Residence Massacre Night 3 By Frank

if game.PlaceId ~= 140260816701736 then
    warn("Please execute this script in the Residence Massacre Night 3.")
    return
end

-- Services --
local RunService = game:GetService("RunService")
local Lighting = game:GetService("Lighting")
local Players = game:GetService("Players")

-- Better Clock --
-- New Clock Label --
local function Create_NewClockLabel()
    local Plr = Players.LocalPlayer
    local PlrGui = Plr:FindFirstChild("PlayerGui")
    local DialogueUI = PlrGui:FindFirstChild("DialogueUI")
    local TimeLabel = DialogueUI:FindFirstChild("TimeLabel")

    local Exact_Time = TimeLabel and TimeLabel:Clone()
    Exact_Time.Name = "ExactTime"
    Exact_Time.Parent = DialogueUI
    Exact_Time.Position = UDim2.new(0.5, 0, 0.092, 0)
    Exact_Time.Size = UDim2.new(0.228, 0, 0.05, 0)
    Exact_Time.TextColor3 = Color3.fromRGB(8, 140, 30)

    return Exact_Time
end

-- Clock Manager --
local function Clock()
    local Plr = Players.LocalPlayer
    local PlrGui = Plr:FindFirstChild("PlayerGui")
    local DialogueUI = PlrGui:FindFirstChild("DialogueUI")

    local ExactTime_Label = DialogueUI:FindFirstChild("ExactTime") or Create_NewClockLabel()

    if not ExactTime_Label then warn("An error occured.") end
    ExactTime_Label.Text = tostring(Lighting.TimeOfDay:sub(1,5))

    Lighting:GetPropertyChangedSignal("TimeOfDay"):Connect(function()
        local Clock = tostring(Lighting.TimeOfDay:sub(1,5)) -- Take the Hour and Minutes
        ExactTime_Label.Text = Clock
    end)

    print("Clock Succesful")
end

-- --


-- Bright Lighting --
local Bright_C

local function BrightLighting()
    local Atmosphere = Lighting:FindFirstChild("Atmosphere")
    
    Bright_C = RunService.RenderStepped:Connect(function()
        Lighting.Ambient = Color3.fromRGB(255, 255, 255)
        Lighting.Brightness = 2
        Lighting.OutdoorAmbient = Color3.fromRGB(255, 255, 255)

        if Atmosphere and Atmosphere:IsA("Atmosphere") then
            Atmosphere.Density = 0
            Atmosphere.Offset = 1
            Atmosphere.Haze = 0
            Atmosphere.Color = Color3.fromRGB(255, 255, 255)
        end
    end)

    print("InfBright Succesful")
end

-- --

-- Inf Sprint --
local Inf_C

local function InfSprint()
    local Plr = Players.LocalPlayer
    local Chr = Plr.Character or Plr.CharacterAdded:Wait()
    local Sprint_Code = Chr and Chr:FindFirstChild("Sprint")

    if Sprint_Code and Sprint_Code:FindFirstChild("Stam") then
        Inf_C = RunService.RenderStepped:Connect(function()
            Sprint_Code.Stam:SetAttribute("Max", math.huge)
            Sprint_Code.Stam.Value = Sprint_Code.Stam:GetAttribute("Max")
        end)
    end

    print("InfSprint Succesful")
end

-- --

-- Anticheat Removation --

local function Deform_Anticheat()
    local Plr = Players.LocalPlayer
    local Plr_Scripts = Plr:FindFirstChild("PlayerScripts")
    local Anticheat = Plr_Scripts and Plr_Scripts:FindFirstChild("LocalScript")

    if Anticheat then
        Anticheat.Parent = game:GetService("Debris") -- Remove
    end

    print("Anticheat succesful")
end

-- --

-- ESP --

local function CreateESP(Object, Color)
    if Object and not Object:FindFirstChild("Viewer") then
        local Viewer = Instance.new("Highlight")
        Viewer.Name = "Viewer"
        Viewer.FillColor = Color
        Viewer.Parent = Object
    end

    print("CreateESP Succesful")
end

local function Mutant_ESP()
    if workspace:FindFirstChild("Mutant") then CreateESP(workspace.Mutant, Color3.fromRGB(0, 255, 0)) end

    workspace.ChildAdded:Connect(function(Child)
        if Child.Name == "Mutant" then
            CreateESP(Child, Color3.fromRGB(0, 255, 0))
        end
    end)

    print("Mutant_ESP Succesful")
end

local function JerryCan_ESP()
    local JerryCans = workspace:FindFirstChild("JerryCans")

    if not JerryCans then return end

    for _, v in pairs(JerryCans:GetChildren()) do
        CreateESP(v, Color3.fromRGB(255, 0, 0))
    end

    print("JerryCan_ESP Succesful")
end

-- --

-- Protect Player --
local Protect_M

local SafeSpot_Locations = {
    Vector3.new(-174.568, 4.275, -144.146),
    Vector3.new(145.444, 4.2, -213.325),
    Vector3.new(65.616, 4.2, -3.609),
    Vector3.new(55.907, 4.275, 210.202),
    Vector3.new(-103.215, 4.275, 271.189),
    Vector3.new(252.637, 4.275, 207.016),
}

local function InstanceSpot(Pos)
	local Spot = Instance.new("Part")
	Spot.Name = "SafeSpot"
	Spot.CanCollide = false
	Spot.Size = Vector3.new(1, 1, 1)
	Spot.Anchored = true
	Spot.Transparency = 0.5
	Spot.Position = Pos
	Spot.Parent = workspace.Safe_Spots or nil
end

local function CreateSafeSpots()
	if not workspace:FindFirstChild("Safe_Spots") then
        print("SAFE SPOTS DOESNT EXIST")
		local Safe_Spots = Instance.new("Folder")
		Safe_Spots.Name = "Safe_Spots"
		Safe_Spots.Parent = workspace

		for _, v in pairs(SafeSpot_Locations) do
			InstanceSpot(v)
		end
	end
end

local function GetMutant()
	return workspace:FindFirstChild("Mutant")
end

local function CalculateDistance(a, b)
	return (a - b).Magnitude
end

local function GetFarthestSafeSpot(mutantPos)
	local FarthestSpot = nil
	local MaxDistance = -math.huge

	for _, spot in pairs(workspace.Safe_Spots:GetChildren()) do
		local Distance = CalculateDistance(spot.Position, mutantPos)

		if Distance > MaxDistance then
			MaxDistance = Distance
			FarthestSpot = spot
		end
	end

	return FarthestSpot
end

local function TakeToSafeSpot(player)
	local Mutant = GetMutant()
	if not Mutant then return end

	if not workspace:FindFirstChild("Safe_Spots") then
		CreateSafeSpots()
	end

	local SafeSpot = GetFarthestSafeSpot(Mutant.PrimaryPart.Position)

	if SafeSpot and player.Character and player.Character:FindFirstChild("HumanoidRootPart") then
		player.Character:MoveTo(SafeSpot.Position)
	end
end

local function ProtectPlayer()
    Protect_M = RunService.Heartbeat:Connect(function()
        local Mutant = GetMutant()
	    local Plr = Players.LocalPlayer
	    local Chr = Plr.Character or Plr.CharacterAdded:Wait()
	    local RootPart = Chr:WaitForChild("HumanoidRootPart")

        if Mutant and RootPart then
		    local Distance = CalculateDistance(Mutant.PrimaryPart.Position, RootPart.Position)
            
		    if Distance < 20 then
			    TakeToSafeSpot(Plr)
		    end
	    end
    end)

    print("ProtectPlayer Succesful")
end

-- --

-- Execution --
task.spawn(function()
    Clock()
    BrightLighting()
    InfSprint()
    Deform_Anticheat()
    Mutant_ESP()
    JerryCan_ESP()
    ProtectPlayer()

    print("<> Loaded Residence Massacre Night 3 Script By Frank <>")
end)
