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

--====================================================
-- ⚙️ Player Modifier Section
--====================================================
MainTab:Section(
    {
        Title = "Player Modifier:"
    }
)

local DesyncButton = MainTab:Button({
    Title = "Invisible",
    Locked = false,
    Callback = function()
	   Net.send("request_respawn")
		task.wait(6.1)
		Net.get("death_screen_request_respawn")
        setfflag("NextGenReplicatorEnabledWrite4", "true")
		        WindUI:Notify({
            Title = "Invisible Success",
            Content = "Enjoy <3",
            Duration = 3,
            Icon = "rbxassetid://121136649812616",
        })
    end,
})

-- Player Tab: High Jump
local Players = game:GetService("Players")
local RunService = game:GetService("RunService")
local player = Players.LocalPlayer

local defaultJumpPower = 20
local maxJumpPower = 100
local highJumpPower = 60
local walkSpeedMultiplier = 0.10
local highJumpActive = false
local speedActive = false

local function setJumpPower(power)
    local char = player.Character or player.CharacterAdded:Wait()
    local hum = char:FindFirstChildOfClass("Humanoid")
    if hum then
        hum.UseJumpPower = true
        hum.JumpPower = math.clamp(power, 0, maxJumpPower)
    end
end

local function setupCharacter(char)
    local hum = char:WaitForChild("Humanoid")
    hum.AutoJumpEnabled = false  

    if highJumpActive then
        hum.UseJumpPower = true
        hum.JumpPower = highJumpPower
    else
        hum.JumpPower = defaultJumpPower
    end
end

player.CharacterAdded:Connect(setupCharacter)

if player.Character then
    setupCharacter(player.Character)
end

-- High Jump Toggle
MainTab:Toggle({
    Title = "High Jump",
    Default = false,
    Callback = function(state)
        highJumpActive = state
        if state then
            setJumpPower(highJumpPower)
        else
            setJumpPower(defaultJumpPower)
        end
    end
})

-- High Jump Slider
MainTab:Slider({
    Title = "High Jump Power",
    Value = {Min = 20, Max = maxJumpPower, Default = highJumpPower},
    Step = 1,
    Callback = function(value)
        highJumpPower = tonumber(value)
        if highJumpActive then
            setJumpPower(highJumpPower)
        end
    end
})

-- Walk Speed Toggle
MainTab:Toggle({
    Title = "Walk Speed",
    Default = false,
    Callback = function(state)
        speedActive = state
    end
})

-- Walk Speed Slider
MainTab:Slider({
    Title = "Speed Multiplier",
    Value = {Min = 1, Max = 5, Default = walkSpeedMultiplier},
    Step = 1,
    Callback = function(value)
        walkSpeedMultiplier = tonumber(value)
    end
})

RunService.RenderStepped:Connect(function(delta)
    if speedActive and player.Character then
        local char = player.Character
        local hum = char:FindFirstChildOfClass("Humanoid")
        local root = char:FindFirstChild("HumanoidRootPart")
        if hum and root then
            local moveDir = hum.MoveDirection
            if moveDir.Magnitude > 0 then
                root.CFrame = root.CFrame + moveDir.Unit * walkSpeedMultiplier * delta * 1
            end
        end
    end
end)

-- Antiaim Script
_G.AntiLock = false

local Players = game:GetService("Players")
local RunService = game:GetService("RunService")
local ReplicatedStorage = game:GetService("ReplicatedStorage")

local LocalPlayer = Players.LocalPlayer
local CharModule = require(ReplicatedStorage.Modules.Core.Char)

-- Animation Anti-Aim
local AntiAimAnimTrack = nil
local ANIM_ID = "rbxassetid://104767795538635"

local function playDanceAntiAim()
    local char = LocalPlayer.Character or LocalPlayer.CharacterAdded:Wait()
    local humanoid = char:WaitForChild("Humanoid")

    if AntiAimAnimTrack then
        AntiAimAnimTrack:Stop()
        AntiAimAnimTrack:Destroy()
        AntiAimAnimTrack = nil
    end

    local anim = Instance.new("Animation")
    anim.AnimationId = ANIM_ID

    AntiAimAnimTrack = humanoid:LoadAnimation(anim)
    AntiAimAnimTrack.Looped = true
    AntiAimAnimTrack:Play()
    AntiAimAnimTrack:AdjustSpeed(99999999999999999999999999999999999)
end

local function stopDanceAntiAim()
    if AntiAimAnimTrack then
        AntiAimAnimTrack:Stop()
        AntiAimAnimTrack:Destroy()
        AntiAimAnimTrack = nil
    end
end

-- Velocity Desync + CustomPhysicalProperties
local function VelocityDesync()
    local hrp = CharModule.get_hrp()
    if not hrp then return end

    local OldVec = hrp.Velocity
    local Lin = hrp.AssemblyLinearVelocity
    local Ang = hrp.AssemblyAngularVelocity

    local RandomVec = Vector3.new(
        math.random(-16000, 16000),
        math.random(-16000, 16000),
        math.random(-16000, 16000)
    )

    hrp.Velocity = RandomVec
    hrp.AssemblyLinearVelocity = RandomVec
    hrp.AssemblyAngularVelocity = RandomVec

    RunService.RenderStepped:Wait()

    hrp.Velocity = OldVec
    hrp.AssemblyLinearVelocity = Lin
    hrp.AssemblyAngularVelocity = Ang
end

local function SetPhysics()
    local hrp = CharModule.get_hrp()
    if hrp then
        hrp.CustomPhysicalProperties = PhysicalProperties.new(0.001, 0.001, 0.001)
    end
end

-- Loop ทำงานถ้าเปิด AntiLock
RunService.Heartbeat:Connect(function()
    if _G.AntiLock then
        VelocityDesync()
        SetPhysics()
    end
end)

-- UI Toggle
MainTab:Toggle({
    Title = "Anti Aim",
    Flag = "antilock",
    Type = "Checkbox",
    Value = false,
    Callback = function(Value)
        _G.AntiLock = Value

        if Value then
            playDanceAntiAim()
        else
            stopDanceAntiAim()
        end
    end
})


-- Anti Ragdoll Function
local function AntiRagdollLoop()
    while _G.AntiRagdoll do
        task.wait(0.1)

        pcall(function()
            local isRagdolled = RagdollModule.is_ragdolling.get()
            if isRagdolled then
                RagdollModule.is_ragdolling.set(false)
                
                -- ลองส่ง remote ทั้ง 2 แบบ
                pcall(function() Net.send("end_ragdoll_early") end)
                pcall(function() Net.send("clear_ragdoll") end)
                pcall(function() Net.get("end_ragdoll_early") end)
                pcall(function() Net.get("clear_ragdoll") end)
            end
        end)
    end
end

-- Toggle UI
MainTab:Toggle({
    Title = "Anti Ragdoll",
    Desc = "No ragdoll",
    Flag = "AntiRagdoll",
    Type = "Checkbox",
    Value = false,
    Callback = function(Value)
        _G.AntiRagdoll = Value

        if Value then
            task.spawn(AntiRagdollLoop)
        end
    end
})


- ✅ ฟังก์ชัน Anti Kill สมบูรณ์
func["AntiDied"] = function()
    while task.wait(0.240) do
        if Settings.AntiDied then
            -- ตรวจสอบตัวแปรหลักมีอยู่จริง
            if not Character or not Humanoid or not RootPart then
                Character = Client.Character or Client.CharacterAdded:Wait()
                Humanoid = Character:WaitForChild("Humanoid")
                RootPart = Character:WaitForChild("HumanoidRootPart")
            end
            
            local hum = CharModule.get_hum()
            
            if hum then
                if hum:GetAttribute("HasBeenDowned") then
                    if not hum:GetAttribute("IsDead") then
                        if Humanoid.Health > 0 then
                            
                            -- ปิด Anti Lock ชั่วคราว
                            if _G.AntiLock then
                                WasAntiLockEnabled = true
                                _G.AntiLock = false
                                stopDanceAntiAim()
                                WindUI:Notify({
                                    Title = "Anti System",
                                    Content = "Anti Lock disabled (Anti Kill active)",
                                    Duration = 2
                                })
                            end
                            
                            -- ตรวจสอบ DeathScreen
                            local deathScreenExists = PlayerGui:FindFirstChild("DeathScreen")
                            if deathScreenExists then
                                local deathscreen = PlayerGui.DeathScreen.DeathScreenHolder
                                if not deathscreen.Visible then
                                    local Radius = 15
                                    local targetY = RootPart.Position.Y - Radius
                                    local currentY = RootPart.Position.Y
                                    local deltaY = targetY - currentY
                                    local Gan = math.random(-5, 15)

                                    RootPart.Anchored = false
                                    RootPart.CanCollide = false
                                    RootPart.CFrame = RootPart.CFrame * CFrame.new(Gan, deltaY, Gan)
                                    RootPart.Velocity = Vector3.new(RootPart.Velocity.X, -11, RootPart.Velocity.Z)

                                    for i, v in pairs(Character:GetChildren()) do
                                        if v:IsA("BasePart") then
                                            v.CanCollide = false
                                            v.Anchored = false
                                            v.CFrame = v.CFrame * CFrame.new(0, deltaY, 0)
                                            v.Velocity = Vector3.new(v.Velocity.X, -11, v.Velocity.Z)
                                        end
                                    end
                                    EverDown = true
                                end
                            end
                        else
                            EverDown = false
                        end
                    else
                        EverDown = false
                    end
                else
                    if EverDown then
                        local ganys = 15
                        local targetY = RootPart.Position.Y - ganys
                        local currentY = RootPart.Position.Y
                        local deltaY = targetY - currentY
                        RootPart.CFrame = RootPart.CFrame * CFrame.new(0, deltaY, 0)
                        
                        if not Client:GetAttribute("IsInCombat") then
                            EverDown = false
                            Net.send("request_respawn")
                            
                            -- เปิด Anti Lock กลับมา
                            if WasAntiLockEnabled then
                                _G.AntiLock = true
                                playDanceAntiAim()
                                WasAntiLockEnabled = false
                                WindUI:Notify({
                                    Title = "Anti System",
                                    Content = "Anti Lock re-enabled",
                                    Duration = 2
                                })
                            end
                        end
                    end
                end
            end
        else
            EverDown = false
            
            -- รีเซ็ตสถานะเมื่อปิด Anti Kill
            if WasAntiLockEnabled then
                WasAntiLockEnabled = false
            end
        end
    end
end

-- ✅ Toggle UI สำหรับ Anti Kill
MainTab:Toggle(
    {
        Title = "Anti Kill",
		Flag = "antikill",
        Type = "Checkbox",
        Value = false,
        Callback = function(state)
            Settings.AntiDied = state

            if state then
                task.spawn(func["AntiDied"])
            end
        end
    }
)


MainTab:Toggle({
    Title = "Auto Health",
    Flag = "autohealth",
    Desc = "Auto Bloodbag",
    Type = "Checkbox",
    Callback = function(state)
        c().AutoBlood = state
        if not state then return end

        local Player = game.Players.LocalPlayer
        local Character = Player.Character or Player.CharacterAdded:Wait()
        local Humanoid = Character:WaitForChild("Humanoid")
        local ReplicatedStorage = game:GetService("ReplicatedStorage")
        local Net = require(ReplicatedStorage.Modules.Core.Net)
        local ItemsUI = Player.PlayerGui.Items.ItemsHolder.ItemsScrollingFrame
        local Busy = false

        -- หา UID ของ Blood Bag
        local function GetBloodBagUID()
            for _, v in ipairs(ItemsUI:GetChildren()) do
                if v:IsA("Frame") or v:IsA("ImageButton") then
                    local itemType = v:GetAttribute("ItemType")
                    if itemType and itemType:lower() == "consumable" then
                        return v.Name
                    end
                end
            end
            return nil
        end

local function UseBloodBag(uid)
    if Busy then return end
    Busy = true

    local tool = Character:FindFirstChild("Blood Bag")

    -- ถ้า tool ไม่มีใน Character → equip
    local didEquip = false
    if not tool then
        Net.get("toggle_equip_item", uid)
        didEquip = true
        task.wait(0.1) -- รอให้ equip สำเร็จ
        tool = Character:FindFirstChild("Blood Bag") or Player.Backpack:FindFirstChild("Blood Bag")
    end

    if tool then
        -- ใช้ซ้ำ ๆ จน HP >= 90
        while Humanoid.Health < 90 do
            Net.get("consume_power_up", tool)
            task.wait(0.1)
        end

        -- หลังใช้ครบ HP >= 90 → unequip ถ้าเคย equip
        if didEquip then
            Net.get("toggle_equip_item", uid)
        end
    else
        warn(" Blood Bag tool not found.")
    end

    Busy = false
end


        task.spawn(function()
            while c().AutoBlood do
                task.wait(0.2)

                if Humanoid.Health <= 50 then
                    local uid = GetBloodBagUID()
                    if uid then
                        UseBloodBag(uid)
                    else
                        warn("⚠ No bloodbag found.")
                    end
                end
            end
        end)
    end
})

MainTab:Divider()

local EnabledSnapRunning = false
local SnapThread = nil
local YoffsetValue = 70

func["EnabledSnap"] = function()
    local basePosition = RootPart.Position
    while EnabledSnapRunning do
        task.wait()
        if not EnabledSnapRunning then
            break
        end
        local currentY = RootPart.Position.Y
        local targetY = basePosition.Y - YoffsetValue
        local deltaY = targetY - currentY
        RootPart.CFrame = RootPart.CFrame * CFrame.new(0, deltaY, 0)
    end
end

MainTab:Divider()

local EnabledSnapRunning = false
local SnapThread = nil
local YoffsetValue = 70

func["EnabledSnap"] = function()
    local basePosition = RootPart.Position
    while EnabledSnapRunning do
        task.wait()
        if not EnabledSnapRunning then
            break
        end
        local currentY = RootPart.Position.Y
        local targetY = basePosition.Y - YoffsetValue
        local deltaY = targetY - currentY
        RootPart.CFrame = RootPart.CFrame * CFrame.new(0, deltaY, 0)
    end
end

-- 🔘 Toggle & Keybind Sync System
local function SetSnapState(value)
    if EnabledSnapRunning == value then
        return
    end -- ไม่ต้องทำซ้ำ
    EnabledSnapRunning = value
    if value then
        if not SnapThread then
            SnapThread = task.spawn(func["EnabledSnap"])
        end
    else
        SnapThread = nil
    end

    -- Sync UI Toggle ให้ตรงกับสถานะ
    MainTab:Get("UndergroundToggle"):SetValue(value)
end

-- 🧩 Toggle
MainTab:Toggle(
    {
        Title = "Underground",
        Icon = "check",
        Type = "Checkbox",
        Value = false,
        Flag = "UndergroundToggle", -- ต้องมี flag เพื่อให้ sync ได้
        Callback = function(value)
            SetSnapState(value)
        end
    }
)

-- 🎹 Keybind
MainTab:Keybind(
    {
        Title = "Keybind",
        Flag = "keybind",
        Value = "G",
        Callback = function()
            SetSnapState(not EnabledSnapRunning)
        end
    }
)

-- 📏 Slider Snap Height
MainTab:Slider(
    {
        Title = "Snap Height",
        Flag = "snap_height",
        Step = 1,
        Value = {
            Min = 1,
            Max = 100,
            Default = 10
        },
        Callback = function(value)
            YoffsetValue = value
        end
    }
)














local CombatTab =
    Window:Tab(
    {
        Title = "Combat",
        Icon = "sword"
    }
)

