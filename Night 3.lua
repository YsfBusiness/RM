-- Residence Massacre Night 3 By Frank

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
        print(Clock)
        ExactTime_Label.Text = Clock
    end)
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
end

local function Mutant_ESP()
    if workspace:FindFirstChild("Mutant") then CreateESP(workspace.Mutant, Color3.fromRGB(0, 255, 0)) end

    workspace.ChildAdded:Connect(function(Child)
        if Child.Name == "Mutant" then
            CreateESP(Child, Color3.fromRGB(0, 255, 0))
        end
    end)
end

local function JerryCan_ESP()
    local JerryCans = workspace:FindFirstChild("JerryCans")

    if not JerryCans then return end

    for _, v in pairs(JerryCans:GetChildren()) do
        CreateESP(v, Color3.fromRGB(255, 0, 0))
    end
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
end)
