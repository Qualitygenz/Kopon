local Players = game:GetService("Players")
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local LocalPlayer = Players.LocalPlayer
local Camera = workspace.CurrentCamera
local CoreGui = game:GetService("CoreGui")
local UserInputService = game:GetService("UserInputService")

local WindUI = loadstring(game:HttpGet("https://github.com/Footagesus/WindUI/releases/latest/download/main.lua"))()

local Window = WindUI:CreateWindow({
    Title = "Quality x",
    Icon = "rbxassetid://138614699274576",
    Author = "Hello, I'm Txr, I'm cool.",
    Folder = "MySuperHub",
    Size = UDim2.fromOffset(580, 460),
    MinSize = Vector2.new(560, 350),
    MaxSize = Vector2.new(850, 560),
    Transparent = true,
    Theme = "Dark",
    Resizable = true,
    SideBarWidth = 200,
    BackgroundImageTransparency = 0.42,
    HideSearchBar = true,
    ScrollBarEnabled = false,
    User = {
        Enabled = true,
        Anonymous = false,
        Name = LocalPlayer.Name,
        Image = "rbxthumb://type=AvatarHeadShot&id=" .. LocalPlayer.UserId,
        Callback = function() end,
    },
})

Window:EditOpenButton({ Enabled = false })

local ScreenGui = Instance.new("ScreenGui")
local ToggleBtn = Instance.new("ImageButton")

ScreenGui.Name = "WindUI_Toggle"
ScreenGui.ResetOnSpawn = false
ScreenGui.Parent = CoreGui

ToggleBtn.Size = UDim2.new(0, 50, 0, 50)
ToggleBtn.Position = UDim2.new(0, 20, 0.5, -25)
ToggleBtn.BackgroundTransparency = 1
ToggleBtn.Image = "rbxassetid://138614699274576" 
ToggleBtn.Active = true
ToggleBtn.Draggable = true
ToggleBtn.Parent = ScreenGui

local opened = true

local function toggle()
    opened = not opened
    if Window.UI then
        Window.UI.Enabled = opened
    else
        Window:Toggle()
    end
end

ToggleBtn.MouseButton1Click:Connect(function()
    ToggleBtn:TweenSize(
        UDim2.new(0, 56, 0, 56),
        Enum.EasingDirection.Out,
        Enum.EasingStyle.Quad,
        0.12,
        true,
        function()
            ToggleBtn:TweenSize(
                UDim2.new(0, 50, 0, 50),
                Enum.EasingDirection.Out,
                Enum.EasingStyle.Quad,
                0.12,
                true
            )
        end
    )
    toggle()
end)

UserInputService.InputBegan:Connect(function(input, gp)
    if gp then return end
    if input.KeyCode == Enum.KeyCode.T then
        toggle()
    end
end)


if not LocalPlayer.Character then
LocalPlayer.CharacterAdded:Wait()
end

--====================================================
-- 🧍 MAIN TAB
--====================================================
local MainTab =
    Window:Tab(
    {
        Title = "General",
        Icon = "globe"
    }
)

--== Money Reader ==--
local Players = game:GetService("Players")
local Client = Players.LocalPlayer
local PlayerGui = Client:WaitForChild("PlayerGui")

local BankBalance =
    MainTab:Button(
    {
        Title = "🏦 Bank Balance",
        Desc = "N/A"
    }
)
local HandBalance =
    MainTab:Button(
    {
        Title = "💸 Hand Balance",
        Desc = "N/A"
    }
)

local function HandMoney()
    return tonumber(PlayerGui.TopRightHud.Holder.Frame.MoneyTextLabel.Text:match("%$(%d+)"))
end

local function ATMMoney()
    for _, v in ipairs(PlayerGui:GetDescendants()) do
        if v:IsA("TextLabel") and string.find(v.Text, "Bank Balance") then
            return tonumber(v.Text:match("%$(%d+)"))
        end
    end
    return 0
end

task.spawn(
    function()
        while task.wait(0.2) do
            BankBalance:SetDesc('<b><font color="#FFFFFF">$' .. (ATMMoney() or 0) .. "</font></b>")
            HandBalance:SetDesc('<b><font color="#FFFFFF">$' .. (HandMoney() or 0) .. "</font></b>")
        end
    end
)
