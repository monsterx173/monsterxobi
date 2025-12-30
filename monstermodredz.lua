local Players = game:GetService("Players")
local LP = Players.LocalPlayer
local Camera = workspace.CurrentCamera
local RunService = game:GetService("RunService")

local Settings = {
    Enabled = true,
    TargetPart = "HumanoidRootPart",
    FOV_Radius = 100,
    FOV_Color = Color3.fromRGB(180, 180, 180),
    FOV_Transparency = 0.5,
    Y_Offset = -35 
}

if LP.PlayerGui:FindFirstChild("NexusAimFOV") then
    LP.PlayerGui.NexusAimFOV:Destroy()
end

local ScreenGui = Instance.new("ScreenGui", LP.PlayerGui)
ScreenGui.Name = "NexusAimFOV"
ScreenGui.ResetOnSpawn = false

local FOVFrame = Instance.new("Frame", ScreenGui)
FOVFrame.Size = UDim2.new(0, Settings.FOV_Radius * 2, 0, Settings.FOV_Radius * 2)
FOVFrame.AnchorPoint = Vector2.new(0.5, 0.5)
FOVFrame.Position = UDim2.new(0.5, 0, 0.5, Settings.Y_Offset)
FOVFrame.BackgroundTransparency = 1 

local Corner = Instance.new("UICorner", FOVFrame)
Corner.CornerRadius = UDim.new(1, 0) 

local Stroke = Instance.new("UIStroke", FOVFrame)
Stroke.Color = Settings.FOV_Color
Stroke.Thickness = 1.5
Stroke.Transparency = Settings.FOV_Transparency

local function GetClosestTarget()
    local ClosestTarget = nil
    local MaxDistance = Settings.FOV_Radius

    for _, player in pairs(Players:GetPlayers()) do
        if player ~= LP and player.Character and player.Character:FindFirstChild("Humanoid") and player.Character.Humanoid.Health > 0 then
            local Part = player.Character:FindFirstChild(Settings.TargetPart)
            if Part then
                local ScreenPos, OnScreen = Camera:WorldToViewportPoint(Part.Position)
                if OnScreen then
                    local CustomCenter = Vector2.new(Camera.ViewportSize.X / 2, (Camera.ViewportSize.Y / 2) + Settings.Y_Offset)
                    local Distance = (Vector2.new(ScreenPos.X, ScreenPos.Y) - CustomCenter).Magnitude
                    
                    if Distance < MaxDistance then
                        ClosestTarget = Part
                        MaxDistance = Distance
                    end
                end
            end
        end
    end
    return ClosestTarget
end

RunService.RenderStepped:Connect(function()
    FOVFrame.Position = UDim2.new(0.5, 0, 0.5, Settings.Y_Offset)
    if Settings.Enabled then
        local TargetPart = GetClosestTarget()
        if TargetPart then
            Camera.CFrame = CFrame.new(Camera.CFrame.Position, TargetPart.Position)
        end
    end
end)
