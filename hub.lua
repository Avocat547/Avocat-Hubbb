-- ============================================
--  AVOCAT HUB V2 — MAIN SCRIPT
--  Partie 1/4 : Services + GUI Framework
-- ============================================

if game:GetService("CoreGui"):FindFirstChild("AvocatHubV2") then
    game:GetService("CoreGui"):FindFirstChild("AvocatHubV2"):Destroy()
end

local Players      = game:GetService("Players")
local TweenService = game:GetService("TweenService")
local UIS          = game:GetService("UserInputService")
local RunService   = game:GetService("RunService")
local CoreGui      = game:GetService("CoreGui")
local WS           = game:GetService("Workspace")
local Lighting     = game:GetService("Lighting")
local HS           = game:GetService("HttpService")
local TS           = game:GetService("TeleportService")

local LP    = Players.LocalPlayer
local cam   = WS.CurrentCamera
local mouse = LP:GetMouse()

pcall(function() settings().Physics.AllowSleep = false end)

-- ═══ CONFIG ═══
local SKEY = "AvocatHubV2_CFG"
local DEF = {
    toggleKey = "RightShift",
    flyKey = "F5",
    noclipKey = "N",
    godKey = "",
    espKey = "",
    touchFlingKey = "T",
    flingAllKey = "",
    infJumpKey = "",
    autoload = false,
}

local function loadCFG()
    local s
    pcall(function()
        if readfile then
            s = HS:JSONDecode(readfile(SKEY .. ".json"))
        end
    end)
    if not s then s = {} end
    for k, v in pairs(DEF) do
        if s[k] == nil then s[k] = v end
    end
    return s
end

local function saveCFG(s)
    pcall(function()
        if writefile then
            writefile(SKEY .. ".json", HS:JSONEncode(s))
        end
    end)
end

local CFG = loadCFG()

-- ═══ COULEURS ═══
local C = {
    Bg   = Color3.fromRGB(10, 10, 16),
    Bg2  = Color3.fromRGB(16, 16, 24),
    Bg3  = Color3.fromRGB(24, 24, 34),
    Ac   = Color3.fromRGB(140, 80, 255),
    AcH  = Color3.fromRGB(170, 110, 255),
    AcL  = Color3.fromRGB(100, 55, 200),
    W    = Color3.fromRGB(230, 230, 240),
    D    = Color3.fromRGB(120, 120, 145),
    R    = Color3.fromRGB(200, 55, 55),
    RH   = Color3.fromRGB(230, 75, 75),
    G    = Color3.fromRGB(75, 200, 100),
    Sep  = Color3.fromRGB(30, 30, 45),
}

-- ═══ UTILS ═══
local function gc()   return LP.Character end
local function ghrp() local c = gc(); return c and c:FindFirstChild("HumanoidRootPart") end
local function ghum() local c = gc(); return c and c:FindFirstChildOfClass("Humanoid") end

local function rc(p, r)
    Instance.new("UICorner", p).CornerRadius = UDim.new(0, r or 6)
end
local function hfx(b, base, hover)
    b.MouseEnter:Connect(function()
        TweenService:Create(b, TweenInfo.new(0.1), {BackgroundColor3 = hover}):Play()
    end)
    b.MouseLeave:Connect(function()
        TweenService:Create(b, TweenInfo.new(0.1), {BackgroundColor3 = base}):Play()
    end)
end

-- ═══ SCREENGUI ═══
local gui = Instance.new("ScreenGui")
gui.Name = "AvocatHubV2"
gui.ResetOnSpawn = false
gui.ZIndexBehavior = Enum.ZIndexBehavior.Sibling
gui.Parent = CoreGui

-- ═══ TOAST SYSTEM ═══
local ToastHolder = Instance.new("Frame", gui)
ToastHolder.Position = UDim2.new(1, -230, 1, -20)
ToastHolder.Size = UDim2.new(0, 220, 0, 0)
ToastHolder.BackgroundTransparency = 1
ToastHolder.AnchorPoint = Vector2.new(0, 1)

local toastLayout = Instance.new("UIListLayout", ToastHolder)
toastLayout.VerticalAlignment = Enum.VerticalAlignment.Bottom
toastLayout.Padding = UDim.new(0, 5)

local function Toast(msg, col)
    col = col or C.Ac
    local f = Instance.new("Frame", ToastHolder)
    f.Size = UDim2.new(1, 0, 0, 32)
    f.BackgroundColor3 = C.Bg
    f.BorderSizePixel = 0
    f.BackgroundTransparency = 1
    rc(f, 6)
    Instance.new("UIStroke", f).Color = col

    local bar = Instance.new("Frame", f)
    bar.Size = UDim2.new(0, 3, 0.7, 0)
    bar.Position = UDim2.new(0, 0, 0.15, 0)
    bar.BackgroundColor3 = col
    bar.BorderSizePixel = 0
    rc(bar, 2)

    local lbl = Instance.new("TextLabel", f)
    lbl.Size = UDim2.new(1, -14, 1, 0)
    lbl.Position = UDim2.new(0, 10, 0, 0)
    lbl.Text = msg
    lbl.Font = Enum.Font.Gotham
    lbl.TextSize = 11
    lbl.TextColor3 = C.W
    lbl.TextXAlignment = Enum.TextXAlignment.Left
    lbl.BackgroundTransparency = 1

    TweenService:Create(f, TweenInfo.new(0.2), {BackgroundTransparency = 0}):Play()
    task.delay(2.5, function()
        TweenService:Create(f, TweenInfo.new(0.3), {BackgroundTransparency = 1}):Play()
        TweenService:Create(lbl, TweenInfo.new(0.2), {TextTransparency = 1}):Play()
        task.delay(0.35, function() f:Destroy() end)
    end)
end

-- ═══ MAIN WINDOW ═══
local Main = Instance.new("Frame", gui)
Main.Size = UDim2.new(0, 520, 0, 430)
Main.Position = UDim2.new(0.5, -260, 0.5, -215)
Main.BackgroundColor3 = C.Bg
Main.BorderSizePixel = 0
Main.ClipsDescendants = true
rc(Main, 10)
Instance.new("UIStroke", Main).Color = C.Ac

-- titre
local Top = Instance.new("Frame", Main)
Top.Size = UDim2.new(1, 0, 0, 40)
Top.BackgroundColor3 = C.Bg2
Top.BorderSizePixel = 0
rc(Top, 10)

-- fix coins bas du top
local topFix = Instance.new("Frame", Top)
topFix.Size = UDim2.new(1, 0, 0, 12)
topFix.Position = UDim2.new(0, 0, 1, -12)
topFix.BackgroundColor3 = C.Bg2
topFix.BorderSizePixel = 0

local titleAccent = Instance.new("Frame", Top)
titleAccent.Size = UDim2.new(0, 3, 0.5, 0)
titleAccent.Position = UDim2.new(0, 10, 0.25, 0)
titleAccent.BackgroundColor3 = C.Ac
titleAccent.BorderSizePixel = 0
rc(titleAccent, 2)

local titleLbl = Instance.new("TextLabel", Top)
titleLbl.BackgroundTransparency = 1
titleLbl.Position = UDim2.new(0, 20, 0, 0)
titleLbl.Size = UDim2.new(0.5, 0, 1, 0)
titleLbl.Font = Enum.Font.GothamBold
titleLbl.Text = "AVOCAT HUB V2"
titleLbl.TextColor3 = C.W
titleLbl.TextSize = 14
titleLbl.TextXAlignment = Enum.TextXAlignment.Left

-- FPS counter
local fpsLbl = Instance.new("TextLabel", Top)
fpsLbl.BackgroundTransparency = 1
fpsLbl.Position = UDim2.new(0.4, 0, 0, 0)
fpsLbl.Size = UDim2.new(0.3, 0, 1, 0)
fpsLbl.Font = Enum.Font.Gotham
fpsLbl.Text = "FPS: 0"
fpsLbl.TextColor3 = C.D
fpsLbl.TextSize = 10

local fpsCount, fpsLast = 0, tick()
RunService.Heartbeat:Connect(function()
    fpsCount = fpsCount + 1
    if tick() - fpsLast >= 1 then
        fpsLbl.Text = "FPS: " .. fpsCount
        fpsCount = 0
        fpsLast = tick()
    end
end)

-- boutons close / minimize
local closeBtn = Instance.new("TextButton", Top)
closeBtn.Size = UDim2.new(0, 26, 0, 26)
closeBtn.Position = UDim2.new(1, -32, 0.5, -13)
closeBtn.BackgroundColor3 = C.Bg3
closeBtn.Text = "✕"
closeBtn.TextColor3 = C.R
closeBtn.TextSize = 11
closeBtn.Font = Enum.Font.GothamBold
closeBtn.BorderSizePixel = 0
closeBtn.AutoButtonColor = false
rc(closeBtn, 6)
hfx(closeBtn, C.Bg3, C.R)

closeBtn.MouseButton1Click:Connect(function()
    TweenService:Create(Main, TweenInfo.new(0.25, Enum.EasingStyle.Back,
        Enum.EasingDirection.In), {Size = UDim2.new(0, 0, 0, 0)}):Play()
    task.wait(0.3)
    gui:Destroy()
end)

local minBtn = Instance.new("TextButton", Top)
minBtn.Size = UDim2.new(0, 26, 0, 26)
minBtn.Position = UDim2.new(1, -62, 0.5, -13)
minBtn.BackgroundColor3 = C.Bg3
minBtn.Text = "−"
minBtn.TextColor3 = C.D
minBtn.TextSize = 14
minBtn.Font = Enum.Font.GothamBold
minBtn.BorderSizePixel = 0
minBtn.AutoButtonColor = false
rc(minBtn, 6)
hfx(minBtn, C.Bg3, C.AcL)

local minimized = false
minBtn.MouseButton1Click:Connect(function()
    minimized = not minimized
    local target = minimized and UDim2.new(0, 520, 0, 40) or UDim2.new(0, 520, 0, 430)
    TweenService:Create(Main, TweenInfo.new(0.2), {Size = target}):Play()
    minBtn.Text = minimized and "+" or "−"
end)

-- drag
local drag, dragS, dragP = false, nil, nil
Top.InputBegan:Connect(function(i)
    if i.UserInputType == Enum.UserInputType.MouseButton1 then
        drag = true; dragS = i.Position; dragP = Main.Position
    end
end)
Top.InputEnded:Connect(function(i)
    if i.UserInputType == Enum.UserInputType.MouseButton1 then drag = false end
end)
UIS.InputChanged:Connect(function(i)
    if drag and i.UserInputType == Enum.UserInputType.MouseMovement then
        local d = i.Position - dragS
        Main.Position = UDim2.new(dragP.X.Scale, dragP.X.Offset + d.X,
                                   dragP.Y.Scale, dragP.Y.Offset + d.Y)
    end
end)

-- séparateur
Instance.new("Frame", Main).Size = UDim2.new(1, 0, 0, 1)
local sep = Main:GetChildren()[#Main:GetChildren()]
sep.Position = UDim2.new(0, 0, 0, 40)
sep.BackgroundColor3 = C.Sep
sep.BorderSizePixel = 0

-- ═══ SIDEBAR ═══
local Sidebar = Instance.new("Frame", Main)
Sidebar.Size = UDim2.new(0, 120, 1, -41)
Sidebar.Position = UDim2.new(0, 0, 0, 41)
Sidebar.BackgroundColor3 = C.Bg2
Sidebar.BorderSizePixel = 0

local sideLayout = Instance.new("UIListLayout", Sidebar)
sideLayout.Padding = UDim.new(0, 0)

-- séparateur vertical
local vSep = Instance.new("Frame", Main)
vSep.Size = UDim2.new(0, 1, 1, -41)
vSep.Position = UDim2.new(0, 120, 0, 41)
vSep.BackgroundColor3 = C.Sep
vSep.BorderSizePixel = 0

-- content holder
local Content = Instance.new("Frame", Main)
Content.Size = UDim2.new(1, -121, 1, -41)
Content.Position = UDim2.new(0, 121, 0, 41)
Content.BackgroundTransparency = 1

-- ═══ TAB SYSTEM ═══
local allTabs = {}
local allToggles = {}
local allSliders = {}

local function makeTab(name, icon)
    local btn = Instance.new("TextButton", Sidebar)
    btn.Size = UDim2.new(1, 0, 0, 46)
    btn.BackgroundTransparency = 1
    btn.Text = ""
    btn.BorderSizePixel = 0
    btn.AutoButtonColor = false

    local indicator = Instance.new("Frame", btn)
    indicator.Size = UDim2.new(0, 3, 0.5, 0)
    indicator.Position = UDim2.new(0, 0, 0.25, 0)
    indicator.BackgroundColor3 = C.Ac
    indicator.BorderSizePixel = 0
    indicator.Visible = false
    rc(indicator, 2)

    local icoLbl = Instance.new("TextLabel", btn)
    icoLbl.Size = UDim2.new(1, 0, 0, 18)
    icoLbl.Position = UDim2.new(0, 0, 0, 7)
    icoLbl.Text = icon or ""
    icoLbl.Font = Enum.Font.Code
    icoLbl.TextSize = 13
    icoLbl.TextColor3 = C.D
    icoLbl.BackgroundTransparency = 1

    local nmLbl = Instance.new("TextLabel", btn)
    nmLbl.Size = UDim2.new(1, 0, 0, 14)
    nmLbl.Position = UDim2.new(0, 0, 0, 26)
    nmLbl.Text = name
    nmLbl.Font = Enum.Font.Gotham
    nmLbl.TextSize = 10
    nmLbl.TextColor3 = C.D
    nmLbl.BackgroundTransparency = 1

    -- scroll frame pour le contenu
    local scroll = Instance.new("ScrollingFrame", Content)
    scroll.Size = UDim2.new(1, -12, 1, -8)
    scroll.Position = UDim2.new(0, 6, 0, 4)
    scroll.BackgroundTransparency = 1
    scroll.ScrollBarThickness = 3
    scroll.ScrollBarImageColor3 = C.Ac
    scroll.Visible = false
    scroll.BorderSizePixel = 0
    scroll.CanvasSize = UDim2.new(0, 0, 0, 0)

    local layout = Instance.new("UIListLayout", scroll)
    layout.Padding = UDim.new(0, 4)
    layout:GetPropertyChangedSignal("AbsoluteContentSize"):Connect(function()
        scroll.CanvasSize = UDim2.new(0, 0, 0, layout.AbsoluteContentSize.Y + 12)
    end)

    local tabData = {
        Btn = btn, Scroll = scroll, Indicator = indicator,
        IcoLbl = icoLbl, NmLbl = nmLbl, Active = false
    }
    table.insert(allTabs, tabData)

    btn.MouseEnter:Connect(function()
        if not tabData.Active then
            TweenService:Create(icoLbl, TweenInfo.new(0.1),
                {TextColor3 = C.W}):Play()
            TweenService:Create(nmLbl, TweenInfo.new(0.1),
                {TextColor3 = C.W}):Play()
        end
    end)
    btn.MouseLeave:Connect(function()
        if not tabData.Active then
            TweenService:Create(icoLbl, TweenInfo.new(0.1),
                {TextColor3 = C.D}):Play()
            TweenService:Create(nmLbl, TweenInfo.new(0.1),
                {TextColor3 = C.D}):Play()
        end
    end)

    btn.MouseButton1Click:Connect(function()
        for _, t in ipairs(allTabs) do
            t.Active = false
            t.Scroll.Visible = false
            t.Indicator.Visible = false
            TweenService:Create(t.IcoLbl, TweenInfo.new(0.12),
                {TextColor3 = C.D}):Play()
            TweenService:Create(t.NmLbl, TweenInfo.new(0.12),
                {TextColor3 = C.D}):Play()
        end
        tabData.Active = true
        scroll.Visible = true
        indicator.Visible = true
        TweenService:Create(icoLbl, TweenInfo.new(0.12),
            {TextColor3 = C.Ac}):Play()
        TweenService:Create(nmLbl, TweenInfo.new(0.12),
            {TextColor3 = C.Ac}):Play()
    end)

    -- premier onglet = actif
    if #allTabs == 1 then
        tabData.Active = true
        scroll.Visible = true
        indicator.Visible = true
        icoLbl.TextColor3 = C.Ac
        nmLbl.TextColor3 = C.Ac
    end

    return scroll
end

-- ═══ WIDGETS ═══
local function makeSection(parent, text)
    local f = Instance.new("Frame", parent)
    f.Size = UDim2.new(1, 0, 0, 22)
    f.BackgroundTransparency = 1

    local line = Instance.new("Frame", f)
    line.Size = UDim2.new(1, 0, 0, 1)
    line.Position = UDim2.new(0, 0, 0.5, 0)
    line.BackgroundColor3 = C.Sep
    line.BorderSizePixel = 0

    local bg = Instance.new("Frame", f)
    bg.Size = UDim2.new(0, #text * 6 + 12, 1, -4)
    bg.Position = UDim2.new(0, 0, 0, 2)
    bg.BackgroundColor3 = C.Bg
    bg.BorderSizePixel = 0

    local lbl = Instance.new("TextLabel", bg)
    lbl.BackgroundTransparency = 1
    lbl.Size = UDim2.new(1, 0, 1, 0)
    lbl.Position = UDim2.new(0, 6, 0, 0)
    lbl.Font = Enum.Font.GothamBold
    lbl.TextSize = 9
    lbl.TextColor3 = C.D
    lbl.TextXAlignment = Enum.TextXAlignment.Left
    lbl.Text = text
end

local function makeToggle(parent, text, cfgKey, callback)
    local f = Instance.new("Frame", parent)
    f.Size = UDim2.new(1, 0, 0, 34)
    f.BackgroundColor3 = C.Bg2
    f.BorderSizePixel = 0
    rc(f, 6)

    local lbl = Instance.new("TextLabel", f)
    lbl.BackgroundTransparency = 1
    lbl.Position = UDim2.new(0, 10, 0, 0)
    lbl.Size = UDim2.new(1, -100, 1, 0)
    lbl.Font = Enum.Font.Gotham
    lbl.TextSize = 12
    lbl.TextColor3 = C.W
    lbl.TextXAlignment = Enum.TextXAlignment.Left
    lbl.Text = text

    -- keybind label
    local keyLbl = Instance.new("TextLabel", f)
    keyLbl.BackgroundTransparency = 1
    keyLbl.Position = UDim2.new(1, -88, 0, 0)
    keyLbl.Size = UDim2.new(0, 34, 1, 0)
    keyLbl.Font = Enum.Font.Gotham
    keyLbl.TextSize = 8
    keyLbl.TextColor3 = C.D
    local ks = cfgKey and CFG[cfgKey] or ""
    keyLbl.Text = ks ~= "" and "[" .. ks .. "]" or ""

    -- toggle switch
    local sw = Instance.new("TextButton", f)
    sw.Size = UDim2.new(0, 42, 0, 22)
    sw.Position = UDim2.new(1, -50, 0.5, -11)
    sw.BackgroundColor3 = C.Bg3
    sw.Text = ""
    sw.BorderSizePixel = 0
    sw.AutoButtonColor = false
    rc(sw, 11)

    local knob = Instance.new("Frame", sw)
    knob.Size = UDim2.new(0, 16, 0, 16)
    knob.Position = UDim2.new(0, 3, 0.5, -8)
    knob.BackgroundColor3 = C.D
    knob.BorderSizePixel = 0
    rc(knob, 8)

    local state = false

    local function toggle()
        state = not state
        TweenService:Create(sw, TweenInfo.new(0.2),
            {BackgroundColor3 = state and C.Ac or C.Bg3}):Play()
        TweenService:Create(knob, TweenInfo.new(0.2, Enum.EasingStyle.Back),
            {Position = state and UDim2.new(1, -19, 0.5, -8)
                               or UDim2.new(0, 3, 0.5, -8),
             BackgroundColor3 = state and C.W or C.D}):Play()
        if callback then callback(state) end
    end

    sw.MouseButton1Click:Connect(toggle)

    local obj = {
        get = function() return state end,
        set = function(s) if s ~= state then toggle() end end,
        toggle = toggle,
        cfgKey = cfgKey,
        updateKeyLabel = function()
            local k = cfgKey and CFG[cfgKey] or ""
            keyLbl.Text = k ~= "" and "[" .. k .. "]" or ""
        end,
    }
    table.insert(allToggles, obj)
    return obj
end

local function makeSlider(parent, text, min, max, default, callback)
    local f = Instance.new("Frame", parent)
    f.Size = UDim2.new(1, 0, 0, 46)
    f.BackgroundColor3 = C.Bg2
    f.BorderSizePixel = 0
    rc(f, 6)

    local lbl = Instance.new("TextLabel", f)
    lbl.BackgroundTransparency = 1
    lbl.Position = UDim2.new(0, 10, 0, 2)
    lbl.Size = UDim2.new(1, -20, 0, 16)
    lbl.Font = Enum.Font.Gotham
    lbl.TextSize = 11
    lbl.TextColor3 = C.D
    lbl.TextXAlignment = Enum.TextXAlignment.Left
    lbl.Text = text .. ": " .. default

    local track = Instance.new("Frame", f)
    track.Size = UDim2.new(1, -20, 0, 8)
    track.Position = UDim2.new(0, 10, 0, 24)
    track.BackgroundColor3 = C.Bg3
    track.BorderSizePixel = 0
    rc(track, 4)

    local fill = Instance.new("Frame", track)
    fill.Size = UDim2.new((default - min) / (max - min), 0, 1, 0)
    fill.BackgroundColor3 = C.Ac
    fill.BorderSizePixel = 0
    rc(fill, 4)

    local thumb = Instance.new("Frame", track)
    thumb.Size = UDim2.new(0, 12, 0, 12)
    thumb.AnchorPoint = Vector2.new(0.5, 0.5)
    thumb.Position = UDim2.new((default - min) / (max - min), 0, 0.5, 0)
    thumb.BackgroundColor3 = C.W
    thumb.BorderSizePixel = 0
    rc(thumb, 6)

    local sliding = false
    local val = default

    local function update(x)
        local pct = math.clamp(
            (x - track.AbsolutePosition.X) / track.AbsoluteSize.X, 0, 1)
        val = math.floor(min + (max - min) * pct)
        fill.Size = UDim2.new(pct, 0, 1, 0)
        thumb.Position = UDim2.new(pct, 0, 0.5, 0)
        lbl.Text = text .. ": " .. val
        if callback then callback(val) end
    end

    track.InputBegan:Connect(function(i)
        if i.UserInputType == Enum.UserInputType.MouseButton1 then
            sliding = true
            update(i.Position.X)
        end
    end)

    local s = {sliding = false, track = track, update = update, val = val}
    table.insert(allSliders, s)

    return s
end

local function makeButton(parent, text, color, callback)
    local btn = Instance.new("TextButton", parent)
    btn.Size = UDim2.new(1, 0, 0, 30)
    btn.BackgroundColor3 = color or C.Bg3
    btn.BorderSizePixel = 0
    btn.Font = Enum.Font.GothamBold
    btn.TextSize = 11
    btn.TextColor3 = C.W
    btn.Text = text
    btn.AutoButtonColor = false
    rc(btn, 6)
    hfx(btn, color or C.Bg3, C.Ac)
    if callback then
        btn.MouseButton1Click:Connect(callback)
    end
    return btn
end

-- slider global input
UIS.InputChanged:Connect(function(i)
    if i.UserInputType == Enum.UserInputType.MouseMovement then
        for _, s in ipairs(allSliders) do
            if s.sliding then s.update(i.Position.X) end
        end
    end
end)
UIS.InputEnded:Connect(function(i)
    if i.UserInputType == Enum.UserInputType.MouseButton1 then
        for _, s in ipairs(allSliders) do s.sliding = false end
    end
end)-- ============================================
--  Partie 2/4 : Move + Combat + Visuals
-- ============================================

-- ═══ TAB: MOVEMENT ═══
local moveTab = makeTab("Move", "◈")

makeSection(moveTab, "SPEED")
local tSpeed = makeToggle(moveTab, "Speed Hack", nil, function(s)
    if not s then pcall(function() ghum().WalkSpeed = 16 end) end
end)
local sSpeed = makeSlider(moveTab, "WalkSpeed", 16, 500, 16, function(v)
    if tSpeed.get() then pcall(function() ghum().WalkSpeed = v end) end
end)

makeSection(moveTab, "FLY")
local flyBV, flyBG, flyConn
local tFly = makeToggle(moveTab, "Fly", "flyKey", function(s)
    if s then
        local hrp = ghrp()
        local hum = ghum()
        if not hrp or not hum then tFly.set(false); return end
        hum.PlatformStand = true
        flyBV = Instance.new("BodyVelocity")
        flyBV.MaxForce = Vector3.new(math.huge, math.huge, math.huge)
        flyBV.Velocity = Vector3.zero
        flyBV.P = 9000
        flyBV.Parent = hrp
        flyBG = Instance.new("BodyGyro")
        flyBG.MaxTorque = Vector3.new(math.huge, math.huge, math.huge)
        flyBG.D = 200
        flyBG.P = 40000
        flyBG.Parent = hrp
    else
        pcall(function() if flyBV then flyBV:Destroy() end end)
        pcall(function() if flyBG then flyBG:Destroy() end end)
        pcall(function() if flyConn then flyConn:Disconnect() end end)
        pcall(function() ghum().PlatformStand = false end)
    end
end)
local sFlySpd = makeSlider(moveTab, "Fly Speed", 10, 300, 80)

makeSection(moveTab, "NOCLIP")
local ncConn
local tNoclip = makeToggle(moveTab, "Noclip", "noclipKey", function(s)
    if ncConn then ncConn:Disconnect(); ncConn = nil end
    if s then
        ncConn = RunService.Stepped:Connect(function()
            pcall(function()
                local c = gc()
                if c then
                    for _, p in ipairs(c:GetDescendants()) do
                        if p:IsA("BasePart") then p.CanCollide = false end
                    end
                end
            end)
        end)
    end
end)

makeSection(moveTab, "JUMP")
local tInfJump = makeToggle(moveTab, "Infinite Jump", "infJumpKey")
local sJumpPower = makeSlider(moveTab, "JumpPower", 50, 500, 50)

UIS.JumpRequest:Connect(function()
    if tInfJump.get() then
        pcall(function()
            ghum():ChangeState(Enum.HumanoidStateType.Jumping)
        end)
    end
end)

makeSection(moveTab, "SPIN")
local spinBAV
local tSpin = makeToggle(moveTab, "Spin", nil, function(s)
    pcall(function()
        local hrp = ghrp()
        if hrp then
            local old = hrp:FindFirstChild("_AV_SPIN")
            if old then old:Destroy() end
        end
    end)
    if s then
        local hrp = ghrp()
        if hrp then
            spinBAV = Instance.new("BodyAngularVelocity")
            spinBAV.Name = "_AV_SPIN"
            spinBAV.MaxTorque = Vector3.new(0, math.huge, 0)
            spinBAV.AngularVelocity = Vector3.new(0, 20, 0)
            spinBAV.P = 500
            spinBAV.Parent = hrp
        end
    end
end)
local sSpinSpd = makeSlider(moveTab, "Spin Speed", 1, 100, 20, function(v)
    pcall(function()
        local hrp = ghrp()
        if hrp then
            local b = hrp:FindFirstChild("_AV_SPIN")
            if b then b.AngularVelocity = Vector3.new(0, v, 0) end
        end
    end)
end)

makeSection(moveTab, "TELEPORT")

local tpFrame = Instance.new("Frame", moveTab)
tpFrame.Size = UDim2.new(1, 0, 0, 34)
tpFrame.BackgroundColor3 = C.Bg2
tpFrame.BorderSizePixel = 0
rc(tpFrame, 6)
Instance.new("UIPadding", tpFrame).PaddingLeft = UDim.new(0, 6)

local function tpBox(pos, ph)
    local b = Instance.new("TextBox", tpFrame)
    b.BackgroundColor3 = C.Bg3
    b.BorderSizePixel = 0
    b.Position = pos
    b.Size = UDim2.new(0.22, 0, 0, 24)
    b.Font = Enum.Font.Gotham
    b.PlaceholderText = ph
    b.PlaceholderColor3 = C.D
    b.Text = ""
    b.TextColor3 = C.W
    b.TextSize = 11
    b.ClearTextOnFocus = false
    rc(b, 4)
    return b
end

local tpX = tpBox(UDim2.new(0, 0, 0.5, -12), "X")
local tpY = tpBox(UDim2.new(0.24, 0, 0.5, -12), "Y")
local tpZ = tpBox(UDim2.new(0.48, 0, 0.5, -12), "Z")

local tpGo = Instance.new("TextButton", tpFrame)
tpGo.BackgroundColor3 = C.Ac
tpGo.BorderSizePixel = 0
tpGo.Position = UDim2.new(0.73, 0, 0.5, -12)
tpGo.Size = UDim2.new(0.24, -6, 0, 24)
tpGo.Font = Enum.Font.GothamBold
tpGo.Text = "TP"
tpGo.TextColor3 = C.W
tpGo.TextSize = 11
tpGo.AutoButtonColor = false
rc(tpGo, 4)
hfx(tpGo, C.Ac, C.AcH)

tpGo.MouseButton1Click:Connect(function()
    pcall(function()
        local hrp = ghrp()
        if hrp then
            hrp.CFrame = CFrame.new(
                tonumber(tpX.Text) or 0,
                tonumber(tpY.Text) or 0,
                tonumber(tpZ.Text) or 0
            )
        end
    end)
    Toast("Téléporté !", C.G)
end)

-- ═══ TAB: COMBAT ═══
local combatTab = makeTab("Combat", "✦")

makeSection(combatTab, "DÉFENSE")
local godConn
local tGod = makeToggle(combatTab, "God Mode", "godKey", function(s)
    if godConn then godConn:Disconnect(); godConn = nil end
    if s then
        godConn = RunService.Heartbeat:Connect(function()
            pcall(function()
                local h = ghum()
                if h then h.Health = h.MaxHealth end
            end)
        end)
    end
end)

local avoidConn
local tAntiVoid = makeToggle(combatTab, "Anti Void", nil, function(s)
    if avoidConn then avoidConn:Disconnect(); avoidConn = nil end
    if s then
        avoidConn = RunService.Heartbeat:Connect(function()
            pcall(function()
                local hrp = ghrp()
                if hrp and hrp.Position.Y < -50 then
                    hrp.CFrame = CFrame.new(hrp.Position.X, 50, hrp.Position.Z)
                    hrp.Velocity = Vector3.zero
                end
            end)
        end)
    end
end)

makeSection(combatTab, "HITBOX")
local hitboxConn
local tHitbox = makeToggle(combatTab, "Hitbox Expander", nil, function(s)
    if hitboxConn then hitboxConn:Disconnect(); hitboxConn = nil end
    if s then
        hitboxConn = RunService.Heartbeat:Connect(function()
            pcall(function()
                for _, p in ipairs(Players:GetPlayers()) do
                    if p ~= LP and p.Character then
                        local head = p.Character:FindFirstChild("Head")
                        if head then
                            head.Size = Vector3.new(
                                sHitboxSize.val, sHitboxSize.val, sHitboxSize.val)
                            head.Transparency = 0.7
                            head.CanCollide = false
                            head.Massless = true
                        end
                    end
                end
            end)
        end)
    else
        pcall(function()
            for _, p in ipairs(Players:GetPlayers()) do
                if p ~= LP and p.Character then
                    local head = p.Character:FindFirstChild("Head")
                    if head then
                        head.Size = Vector3.new(2, 1, 1)
                        head.Transparency = 0
                    end
                end
            end
        end)
    end
end)
sHitboxSize = makeSlider(combatTab, "Hitbox Size", 1, 20, 5)

makeSection(combatTab, "ANTI")
local tAntiAfk = makeToggle(combatTab, "Anti AFK", nil, function(s)
    if s then
        pcall(function()
            if getconnections then
                for _, c in ipairs(getconnections(LP.Idled)) do
                    c:Disable()
                end
            end
        end)
        Toast("Anti AFK activé", C.G)
    end
end)

local slowConn
local tAntiSlow = makeToggle(combatTab, "Anti Slowdown", nil, function(s)
    if slowConn then slowConn:Disconnect(); slowConn = nil end
    if s then
        slowConn = RunService.Heartbeat:Connect(function()
            pcall(function()
                local h = ghum()
                if h and h.WalkSpeed < 16 then
                    h.WalkSpeed = tSpeed.get() and sSpeed.val or 16
                end
            end)
        end)
    end
end)

-- ═══ TAB: VISUALS ═══
local visualTab = makeTab("Visuals", "◉")

makeSection(visualTab, "ESP")
local espConn
local tESP = makeToggle(visualTab, "ESP", "espKey", function(s)
    if espConn then espConn:Disconnect(); espConn = nil end
    if s then
        espConn = RunService.Heartbeat:Connect(function()
            for _, p in ipairs(Players:GetPlayers()) do
                if p ~= LP then
                    pcall(function()
                        local c = p.Character
                        if not c then return end
                        -- highlight
                        if not c:FindFirstChild("_AV_ESP") then
                            local h = Instance.new("Highlight")
                            h.Name = "_AV_ESP"
                            h.FillColor = C.Ac
                            h.FillTransparency = 0.75
                            h.OutlineColor = C.W
                            h.Parent = c
                        end
                        -- nametag
                        local head = c:FindFirstChild("Head")
                        if head and not head:FindFirstChild("_AV_NAME") then
                            local bb = Instance.new("BillboardGui")
                            bb.Name = "_AV_NAME"
                            bb.Parent = head
                            bb.Size = UDim2.new(0, 180, 0, 36)
                            bb.StudsOffset = Vector3.new(0, 2.5, 0)
                            bb.AlwaysOnTop = true
                            bb.MaxDistance = 800

                            local nl = Instance.new("TextLabel", bb)
                            nl.BackgroundTransparency = 1
                            nl.Size = UDim2.new(1, 0, 0.5, 0)
                            nl.Font = Enum.Font.GothamBold
                            nl.TextColor3 = C.W
                            nl.TextStrokeTransparency = 0.5
                            nl.TextSize = 13
                            nl.Text = p.DisplayName

                            local dl = Instance.new("TextLabel", bb)
                            dl.BackgroundTransparency = 1
                            dl.Size = UDim2.new(1, 0, 0.5, 0)
                            dl.Position = UDim2.new(0, 0, 0.5, 0)
                            dl.Font = Enum.Font.Gotham
                            dl.TextColor3 = C.D
                            dl.TextStrokeTransparency = 0.5
                            dl.TextSize = 10
                        end
                        -- update distance
                        local espBB = head and head:FindFirstChild("_AV_NAME")
                        if espBB and ghrp() then
                            local d = math.floor(
                                (ghrp().Position - head.Position).Magnitude)
                            local hum2 = c:FindFirstChildOfClass("Humanoid")
                            local hp = hum2 and math.floor(hum2.Health) or 0
                            local ch = espBB:GetChildren()
                            if ch[2] then
                                ch[2].Text = "HP:" .. hp .. " | " .. d .. "m"
                            end
                        end
                    end)
                end
            end
        end)
    else
        for _, p in ipairs(Players:GetPlayers()) do
            pcall(function()
                local c = p.Character
                if c then
                    local e = c:FindFirstChild("_AV_ESP")
                    if e then e:Destroy() end
                    local head = c:FindFirstChild("Head")
                    if head then
                        local n = head:FindFirstChild("_AV_NAME")
                        if n then n:Destroy() end
                    end
                end
            end)
        end
    end
end)

makeSection(visualTab, "ÉCLAIRAGE")
local origAmb, origFog
local brightConn, fogConn

local tBright = makeToggle(visualTab, "Fullbright", nil, function(s)
    if brightConn then brightConn:Disconnect(); brightConn = nil end
    if s then
        origAmb = Lighting.Ambient
        brightConn = RunService.Heartbeat:Connect(function()
            pcall(function()
                Lighting.Ambient = Color3.new(1, 1, 1)
                Lighting.Brightness = 2
                Lighting.OutdoorAmbient = Color3.new(1, 1, 1)
            end)
        end)
    else
        pcall(function()
            if origAmb then Lighting.Ambient = origAmb end
            Lighting.Brightness = 1
        end)
    end
end)

local tNoFog = makeToggle(visualTab, "No Fog", nil, function(s)
    if fogConn then fogConn:Disconnect(); fogConn = nil end
    if s then
        origFog = Lighting.FogEnd
        fogConn = RunService.Heartbeat:Connect(function()
            Lighting.FogEnd = 1e9
        end)
    else
        pcall(function()
            if origFog then Lighting.FogEnd = origFog end
        end)
    end
end)

local sFOV = makeSlider(visualTab, "FOV", 70, 120, 70, function(v)
    pcall(function() cam.FieldOfView = v end)
end)-- ============================================
--  Partie 3/4 : Players + Fling Engine
-- ============================================

-- ═══ FLING ENGINE (méthode SkidFling prouvée) ═══
local FL = {
    busy = false,
    allOn = false,
    stopFlag = false,
    touchOn = false,
    followOn = false,
    followTarget = nil,
    savedFPDH = nil,
}
pcall(function() FL.savedFPDH = WS.FallenPartsDestroyHeight end)

local function SkidFling(TP)
    if FL.busy or FL.stopFlag then return end
    local Ch = gc()
    local Hum = Ch and Ch:FindFirstChildOfClass("Humanoid")
    local RP = Hum and Hum.RootPart
    if not Ch or not Hum or not RP or Hum.Health <= 0 then return end

    local TC = TP.Character
    if not TC then return end
    local TH = TC:FindFirstChildOfClass("Humanoid")
    if not TH or TH.Health <= 0 then return end
    local TR = TH.RootPart
    local THd = TC:FindFirstChild("Head")
    FL.busy = true
    local Old = RP.CFrame

    local FP = function(B, P, A)
        if FL.stopFlag then return end
        RP.CFrame = CFrame.new(B.Position) * P * A
        pcall(function()
            Ch:SetPrimaryPartCFrame(CFrame.new(B.Position) * P * A)
        end)
        RP.Velocity = Vector3.new(9e7, 9e7 * 10, 9e7)
        RP.RotVelocity = Vector3.new(9e8, 9e8, 9e8)
    end

    local SF = function(B)
        local T = tick()
        local Ag = 0
        repeat
            if FL.stopFlag or not RP or not RP.Parent
               or not TH or not B or not B.Parent then break end

            if B.Velocity.Magnitude < 50 then
                Ag = Ag + 100
                local md = TH.MoveDirection * B.Velocity.Magnitude / 1.25
                FP(B, CFrame.new(0, 1.5, 0) + md,
                    CFrame.Angles(math.rad(Ag), 0, 0))
                task.wait()
                FP(B, CFrame.new(0, -1.5, 0) + md,
                    CFrame.Angles(math.rad(Ag), 0, 0))
                task.wait()
                FP(B, CFrame.new(2.25, 1.5, -2.25) + md,
                    CFrame.Angles(math.rad(Ag), 0, 0))
                task.wait()
                FP(B, CFrame.new(-2.25, -1.5, 2.25) + md,
                    CFrame.Angles(math.rad(Ag), 0, 0))
                task.wait()
            else
                FP(B, CFrame.new(0, 1.5, TH.WalkSpeed),
                    CFrame.Angles(math.rad(90), 0, 0))
                task.wait()
                FP(B, CFrame.new(0, -1.5, -TH.WalkSpeed),
                    CFrame.Angles(0, 0, 0))
                task.wait()
            end
        until FL.stopFlag
           or B.Velocity.Magnitude > 500
           or B.Parent ~= TP.Character
           or TP.Parent ~= Players
           or TH.Sit
           or Hum.Health <= 0
           or tick() > T + 2
    end

    -- protections
    pcall(function() WS.FallenPartsDestroyHeight = 0 / 0 end)
    local BV = Instance.new("BodyVelocity")
    BV.Name = "_AV_FLING"
    BV.Parent = RP
    BV.Velocity = Vector3.new(9e8, 9e8, 9e8)
    BV.MaxForce = Vector3.new(math.huge, math.huge, math.huge)
    Hum:SetStateEnabled(Enum.HumanoidStateType.Seated, false)

    -- fling !
    if not FL.stopFlag then
        if TR and THd then
            if (TR.CFrame.p - THd.CFrame.p).Magnitude > 5 then
                SF(THd)
            else
                SF(TR)
            end
        elseif TR then
            SF(TR)
        elseif THd then
            SF(THd)
        end
    end

    -- cleanup
    pcall(function() BV:Destroy() end)
    pcall(function()
        Hum:SetStateEnabled(Enum.HumanoidStateType.Seated, true)
    end)
    pcall(function() cam.CameraSubject = Hum end)

    -- retour position
    pcall(function()
        if RP and RP.Parent then
            repeat
                RP.CFrame = Old * CFrame.new(0, 0.5, 0)
                Hum:ChangeState("GettingUp")
                for _, x in ipairs(Ch:GetChildren()) do
                    if x:IsA("BasePart") then
                        x.Velocity = Vector3.zero
                        x.RotVelocity = Vector3.zero
                    end
                end
                task.wait()
            until FL.stopFlag or (RP.Position - Old.p).Magnitude < 25
        end
    end)

    pcall(function()
        if FL.savedFPDH then
            WS.FallenPartsDestroyHeight = FL.savedFPDH
        end
    end)
    FL.busy = false
end

-- raccourcis fling
function FL.flingOne(t)
    if t == LP then return end
    FL.stopFlag = false
    Toast("Fling: " .. t.Name, C.Ac)
    task.spawn(function() SkidFling(t) end)
end

function FL.flingAll(statusLbl)
    if FL.allOn then
        FL.allOn = false
        FL.stopFlag = true
        return
    end
    FL.allOn = true
    FL.stopFlag = false
    Toast("Fling All activé", C.R)
    task.spawn(function()
        while FL.allOn and not FL.stopFlag do
            local targets = {}
            for _, p in ipairs(Players:GetPlayers()) do
                if p ~= LP and p.Character then
                    local h = p.Character:FindFirstChildOfClass("Humanoid")
                    if h and h.Health > 0 then
                        table.insert(targets, p)
                    end
                end
            end
            if #targets == 0 then FL.allOn = false; break end
            for _, t in ipairs(targets) do
                if not FL.allOn or FL.stopFlag then return end
                SkidFling(t)
                if not FL.allOn or FL.stopFlag then return end
                task.wait(0.5)
            end
        end
    end)
end

function FL.touchFling()
    if FL.touchOn then
        FL.touchOn = false
        return
    end
    FL.touchOn = true
    Toast("Touch Fling ON", C.Ac)
    task.spawn(function()
        local ml = 0.1
        while FL.touchOn do
            RunService.Heartbeat:Wait()
            local c = gc()
            local h = c and c:FindFirstChild("HumanoidRootPart")
            while FL.touchOn and not (c and c.Parent and h and h.Parent) do
                RunService.Heartbeat:Wait()
                c = gc()
                h = c and c:FindFirstChild("HumanoidRootPart")
            end
            if FL.touchOn and h and h.Parent then
                local v = h.Velocity
                h.Velocity = v * 10000 + Vector3.new(0, 10000, 0)
                RunService.RenderStepped:Wait()
                if c and c.Parent and h and h.Parent then h.Velocity = v end
                RunService.Stepped:Wait()
                if c and c.Parent and h and h.Parent then
                    h.Velocity = v + Vector3.new(0, ml, 0)
                    ml = ml * -1
                end
            end
        end
    end)
end

function FL.follow(t)
    if FL.followOn and FL.followTarget == t then
        FL.followOn = false
        FL.followTarget = nil
        return
    end
    FL.followOn = true
    FL.followTarget = t
    Toast("Follow: " .. t.Name, C.Ac)
    task.spawn(function()
        while FL.followOn and FL.followTarget == t do
            local hrp = ghrp()
            local th = t.Character
                and t.Character:FindFirstChild("HumanoidRootPart")
            if hrp and th and (th.Position - hrp.Position).Magnitude > 5 then
                hrp.CFrame = CFrame.new(hrp.Position, th.Position)
                    * CFrame.new(0, 0, -3)
                pcall(function() ghum():MoveTo(th.Position) end)
            end
            task.wait(0.1)
        end
    end)
end

function FL.stop()
    FL.allOn = false
    FL.stopFlag = true
    FL.touchOn = false
    FL.followOn = false
    FL.followTarget = nil
    pcall(function()
        local hrp = ghrp()
        if hrp then
            for _, v in ipairs(hrp:GetChildren()) do
                if v:IsA("BodyMover") and v.Name == "_AV_FLING" then
                    v:Destroy()
                end
            end
            hrp.Velocity = Vector3.zero
            hrp.RotVelocity = Vector3.zero
        end
        local h = ghum()
        if h then h.PlatformStand = false end
    end)
    task.wait(0.3)
    FL.busy = false
    FL.stopFlag = false
    Toast("Fling stoppé", C.D)
end

-- ═══ TAB: PLAYERS ═══
local playersTab = makeTab("Players", "◆")

-- status
local pStatus = Instance.new("TextLabel", playersTab)
pStatus.Size = UDim2.new(1, 0, 0, 18)
pStatus.BackgroundColor3 = C.Bg2
pStatus.Font = Enum.Font.GothamBold
pStatus.Text = "  Idle"
pStatus.TextColor3 = C.D
pStatus.TextSize = 10
pStatus.TextXAlignment = Enum.TextXAlignment.Left
rc(pStatus, 4)

-- boutons d'action
local actionFrame = Instance.new("Frame", playersTab)
actionFrame.Size = UDim2.new(1, 0, 0, 28)
actionFrame.BackgroundTransparency = 1

local actionBtns = {}
for i, data in ipairs({
    {"Stop", C.R},
    {"Fling All", C.Bg3},
    {"Touch", C.Bg3},
}) do
    local b = Instance.new("TextButton", actionFrame)
    b.Size = UDim2.new(1 / 3, -3, 1, 0)
    b.Position = UDim2.new((i - 1) / 3, 1, 0, 0)
    b.BackgroundColor3 = data[2]
    b.BorderSizePixel = 0
    b.Font = Enum.Font.GothamBold
    b.Text = data[1]
    b.TextColor3 = C.W
    b.TextSize = 10
    b.AutoButtonColor = false
    rc(b, 6)
    hfx(b, data[2], C.Ac)
    actionBtns[data[1]] = b
end

actionBtns["Stop"].MouseButton1Click:Connect(function() FL.stop() end)
actionBtns["Fling All"].MouseButton1Click:Connect(function()
    FL.flingAll(pStatus)
end)
actionBtns["Touch"].MouseButton1Click:Connect(function()
    FL.touchFling()
end)

-- recherche
local pSearch = Instance.new("TextBox", playersTab)
pSearch.BackgroundColor3 = C.Bg2
pSearch.BorderSizePixel = 0
pSearch.Size = UDim2.new(1, 0, 0, 24)
pSearch.Font = Enum.Font.Gotham
pSearch.PlaceholderText = "Rechercher joueur..."
pSearch.PlaceholderColor3 = C.D
pSearch.Text = ""
pSearch.TextColor3 = C.W
pSearch.TextSize = 11
pSearch.ClearTextOnFocus = false
rc(pSearch, 6)

-- liste joueurs (dans un frame scrollable imbriqué)
local pListFrame = Instance.new("Frame", playersTab)
pListFrame.Size = UDim2.new(1, 0, 0, 200)
pListFrame.BackgroundColor3 = C.Bg2
pListFrame.BorderSizePixel = 0
rc(pListFrame, 6)

local pList = Instance.new("ScrollingFrame", pListFrame)
pList.Size = UDim2.new(1, -6, 1, -6)
pList.Position = UDim2.new(0, 3, 0, 3)
pList.BackgroundTransparency = 1
pList.ScrollBarThickness = 3
pList.ScrollBarImageColor3 = C.Ac
pList.CanvasSize = UDim2.new(0, 0, 0, 0)
pList.BorderSizePixel = 0

local pListLayout = Instance.new("UIListLayout", pList)
pListLayout.Padding = UDim.new(0, 3)
pListLayout:GetPropertyChangedSignal("AbsoluteContentSize"):Connect(function()
    pList.CanvasSize = UDim2.new(0, 0, 0,
        pListLayout.AbsoluteContentSize.Y + 6)
end)

local function refreshPlayers()
    for _, v in ipairs(pList:GetChildren()) do
        if v:IsA("Frame") then v:Destroy() end
    end

    local search = pSearch.Text:lower()

    for _, p in ipairs(Players:GetPlayers()) do
        if p ~= LP then
            local dn = p.DisplayName
            local un = p.Name

            if search == ""
               or dn:lower():find(search, 1, true)
               or un:lower():find(search, 1, true) then

                local row = Instance.new("Frame", pList)
                row.Size = UDim2.new(1, 0, 0, 30)
                row.BackgroundColor3 = C.Bg
                row.BorderSizePixel = 0
                rc(row, 4)

                -- nom (cliquable = spectate)
                local nm = Instance.new("TextButton", row)
                nm.BackgroundTransparency = 1
                nm.Position = UDim2.new(0, 6, 0, 0)
                nm.Size = UDim2.new(1, -170, 1, 0)
                nm.Font = Enum.Font.Gotham
                nm.TextColor3 = C.W
                nm.TextSize = 11
                nm.TextXAlignment = Enum.TextXAlignment.Left
                nm.AutoButtonColor = false
                nm.Text = dn ~= un and dn .. " @" .. un or un

                nm.MouseButton1Click:Connect(function()
                    pcall(function()
                        cam.CameraSubject =
                            p.Character:FindFirstChildOfClass("Humanoid")
                    end)
                    pStatus.Text = "  Spec: " .. dn
                end)

                -- boutons action
                local btns = {
                    {"F", function() FL.flingOne(p) end},
                    {"TP", function()
                        pcall(function()
                            local h = ghrp()
                            local th = p.Character
                                and p.Character:FindFirstChild(
                                    "HumanoidRootPart")
                            if h and th then
                                h.CFrame = th.CFrame * CFrame.new(3, 0, 0)
                            end
                        end)
                        Toast("TP → " .. dn, C.G)
                    end},
                    {"Fw", function() FL.follow(p) end},
                }

                for j, bd in ipairs(btns) do
                    local ab = Instance.new("TextButton", row)
                    ab.BackgroundColor3 = C.Bg3
                    ab.BorderSizePixel = 0
                    ab.Position = UDim2.new(
                        1, -(#btns - j + 1) * 42, 0, 4)
                    ab.Size = UDim2.new(0, 38, 0, 22)
                    ab.Font = Enum.Font.GothamBold
                    ab.TextColor3 = C.W
                    ab.TextSize = 9
                    ab.Text = bd[1]
                    ab.AutoButtonColor = false
                    rc(ab, 4)
                    hfx(ab, C.Bg3, C.Ac)
                    ab.MouseButton1Click:Connect(bd[2])
                end
            end
        end
    end
end

-- bouton refresh
makeButton(playersTab, "Actualiser", C.Bg3, refreshPlayers)

-- auto refresh
pSearch:GetPropertyChangedSignal("Text"):Connect(refreshPlayers)
Players.PlayerAdded:Connect(function() task.wait(1); refreshPlayers() end)
Players.PlayerRemoving:Connect(function() task.wait(0.5); refreshPlayers() end)
task.defer(refreshPlayers)-- ============================================
--  Partie 4/4 : Tools + Settings + Logic
-- ============================================

-- ═══ TAB: TOOLS ═══
local toolsTab = makeTab("Tools", "⬡")

local tSearch = Instance.new("TextBox", toolsTab)
tSearch.BackgroundColor3 = C.Bg2
tSearch.BorderSizePixel = 0
tSearch.Size = UDim2.new(1, 0, 0, 24)
tSearch.Font = Enum.Font.Gotham
tSearch.PlaceholderText = "Rechercher un tool..."
tSearch.PlaceholderColor3 = C.D
tSearch.Text = ""
tSearch.TextColor3 = C.W
tSearch.TextSize = 11
tSearch.ClearTextOnFocus = false
rc(tSearch, 6)

local tListFrame = Instance.new("Frame", toolsTab)
tListFrame.Size = UDim2.new(1, 0, 0, 250)
tListFrame.BackgroundColor3 = C.Bg2
tListFrame.BorderSizePixel = 0
rc(tListFrame, 6)

local tList = Instance.new("ScrollingFrame", tListFrame)
tList.Size = UDim2.new(1, -6, 1, -6)
tList.Position = UDim2.new(0, 3, 0, 3)
tList.BackgroundTransparency = 1
tList.ScrollBarThickness = 3
tList.ScrollBarImageColor3 = C.Ac
tList.CanvasSize = UDim2.new(0, 0, 0, 0)
tList.BorderSizePixel = 0

local tListLayout = Instance.new("UIListLayout", tList)
tListLayout.Padding = UDim.new(0, 3)
tListLayout:GetPropertyChangedSignal("AbsoluteContentSize"):Connect(function()
    tList.CanvasSize = UDim2.new(0, 0, 0,
        tListLayout.AbsoluteContentSize.Y + 6)
end)

local function findTools()
    local tools = {}
    local seen = {}

    local function addTool(v, source)
        if v:IsA("Tool") and v.Parent
           and v.Parent ~= LP.Backpack
           and v.Parent ~= gc() then
            local k = tostring(v) .. v.Name
            if not seen[k] then
                seen[k] = true
                table.insert(tools, {Tool = v, Source = source})
            end
        end
    end

    local function scan(loc, tag)
        pcall(function()
            for _, v in ipairs(loc:GetDescendants()) do
                pcall(function() addTool(v, tag) end)
            end
        end)
    end

    scan(WS, "WS")
    scan(game:GetService("ReplicatedStorage"), "RS")
    pcall(function() scan(game:GetService("StarterPack"), "SP") end)
    pcall(function() scan(Lighting, "LT") end)

    pcall(function()
        if getnilinstances then
            for _, v in ipairs(getnilinstances()) do
                pcall(function()
                    if v:IsA("Tool") then
                        local k = tostring(v) .. v.Name .. "nil"
                        if not seen[k] then
                            seen[k] = true
                            table.insert(tools,
                                {Tool = v, Source = "Nil"})
                        end
                    end
                end)
            end
        end
    end)

    return tools
end

local function refreshTools()
    for _, v in ipairs(tList:GetChildren()) do
        if v:IsA("TextButton") then v:Destroy() end
    end

    local tools = findTools()
    local search = tSearch.Text:lower()
    local displayed = {}

    for _, data in ipairs(tools) do
        pcall(function()
            local name = data.Tool.Name
            local key = name .. "_" .. data.Source
            if not displayed[key]
               and (search == ""
                    or name:lower():find(search, 1, true)) then
                displayed[key] = true

                local b = Instance.new("TextButton", tList)
                b.Size = UDim2.new(1, 0, 0, 28)
                b.BackgroundColor3 = C.Bg
                b.BorderSizePixel = 0
                b.Font = Enum.Font.Gotham
                b.TextColor3 = C.W
                b.TextSize = 11
                b.Text = "  " .. name .. "  [" .. data.Source .. "]"
                b.TextXAlignment = Enum.TextXAlignment.Left
                b.AutoButtonColor = false
                rc(b, 4)
                hfx(b, C.Bg, C.Ac)

                b.MouseButton1Click:Connect(function()
                    pcall(function()
                        data.Tool:Clone().Parent = LP.Backpack
                    end)
                    Toast("Tool: " .. name, C.G)
                end)
            end
        end)
    end
end

makeButton(toolsTab, "Actualiser", C.Bg3, refreshTools)
tSearch:GetPropertyChangedSignal("Text"):Connect(refreshTools)
task.defer(refreshTools)

-- ═══ TAB: SETTINGS ═══
local settingsTab = makeTab("Settings", "⚙")

makeSection(settingsTab, "KEYBINDS")

local function makeKeybind(parent, displayName, cfgKey)
    local f = Instance.new("Frame", parent)
    f.Size = UDim2.new(1, 0, 0, 30)
    f.BackgroundColor3 = C.Bg2
    f.BorderSizePixel = 0
    rc(f, 6)

    local lbl = Instance.new("TextLabel", f)
    lbl.BackgroundTransparency = 1
    lbl.Position = UDim2.new(0, 10, 0, 0)
    lbl.Size = UDim2.new(0.5, 0, 1, 0)
    lbl.Font = Enum.Font.Gotham
    lbl.TextColor3 = C.W
    lbl.TextSize = 11
    lbl.TextXAlignment = Enum.TextXAlignment.Left
    lbl.Text = displayName

    local kb = Instance.new("TextButton", f)
    kb.BackgroundColor3 = C.Bg3
    kb.BorderSizePixel = 0
    kb.Position = UDim2.new(0.55, 0, 0, 4)
    kb.Size = UDim2.new(0.4, -8, 0, 22)
    kb.Font = Enum.Font.GothamBold
    kb.TextColor3 = C.D
    kb.TextSize = 10
    kb.Text = CFG[cfgKey] ~= "" and CFG[cfgKey] or "None"
    kb.AutoButtonColor = false
    rc(kb, 4)

    local listening = false
    kb.MouseButton1Click:Connect(function()
        if listening then return end
        listening = true
        kb.Text = "..."
        kb.TextColor3 = C.Ac

        local cn
        cn = UIS.InputBegan:Connect(function(input, gpe)
            if gpe then return end
            if input.KeyCode and input.KeyCode ~= Enum.KeyCode.Unknown then
                CFG[cfgKey] = input.KeyCode.Name
                kb.Text = input.KeyCode.Name
                kb.TextColor3 = C.D
                saveCFG(CFG)
                for _, t in ipairs(allToggles) do
                    t.updateKeyLabel()
                end
                listening = false
                cn:Disconnect()
            end
        end)
    end)
end

makeKeybind(settingsTab, "Toggle GUI", "toggleKey")
makeKeybind(settingsTab, "Fly", "flyKey")
makeKeybind(settingsTab, "Noclip", "noclipKey")
makeKeybind(settingsTab, "God Mode", "godKey")
makeKeybind(settingsTab, "ESP", "espKey")
makeKeybind(settingsTab, "Touch Fling", "touchFlingKey")
makeKeybind(settingsTab, "Fling All", "flingAllKey")

makeSection(settingsTab, "ACTIONS")

makeButton(settingsTab, "Rejoin", C.Bg3, function()
    pcall(function()
        TS:TeleportToPlaceInstance(game.PlaceId, game.JobId, LP)
    end)
end)

makeButton(settingsTab, "Server Hop", C.Bg3, function()
    pcall(function()
        local d = HS:JSONDecode(game:HttpGet(
            "https://games.roblox.com/v1/games/"
            .. game.PlaceId
            .. "/servers/Public?sortOrder=Asc&limit=100"))
        for _, s in ipairs(d.data) do
            if s.id ~= game.JobId and s.playing < s.maxPlayers then
                TS:TeleportToPlaceInstance(game.PlaceId, s.id, LP)
                break
            end
        end
    end)
end)

makeButton(settingsTab, "Copy Place ID", C.Bg3, function()
    pcall(function() setclipboard(tostring(game.PlaceId)) end)
    Toast("Place ID copié", C.G)
end)

makeButton(settingsTab, "Anti Lag", C.Bg3, function()
    pcall(function()
        for _, v in ipairs(WS:GetDescendants()) do
            pcall(function()
                if v:IsA("ParticleEmitter") or v:IsA("Trail")
                   or v:IsA("Smoke") or v:IsA("Fire")
                   or v:IsA("Sparkles") then
                    v:Destroy()
                end
            end)
        end
        for _, v in ipairs(Lighting:GetDescendants()) do
            pcall(function()
                if v:IsA("BloomEffect") or v:IsA("BlurEffect")
                   or v:IsA("SunRaysEffect") then
                    v:Destroy()
                end
            end)
        end
        Lighting.GlobalShadows = false
        pcall(function()
            settings().Rendering.QualityLevel =
                Enum.QualityLevel.Level01
        end)
    end)
    Toast("Anti Lag appliqué", C.G)
end)

makeButton(settingsTab, "Reset Character", C.R, function()
    pcall(function() ghum().Health = 0 end)
end)

-- ═══ KEYBINDS GLOBAUX ═══
UIS.InputBegan:Connect(function(i, gpe)
    if gpe then return end
    if not i.KeyCode then return end
    local kn = i.KeyCode.Name

    if kn == CFG.toggleKey then
        Main.Visible = not Main.Visible
    end
    if CFG.flyKey ~= "" and kn == CFG.flyKey then
        tFly.toggle()
    end
    if CFG.noclipKey ~= "" and kn == CFG.noclipKey then
        tNoclip.toggle()
    end
    if CFG.godKey ~= "" and kn == CFG.godKey then
        tGod.toggle()
    end
    if CFG.espKey ~= "" and kn == CFG.espKey then
        tESP.toggle()
    end
    if CFG.touchFlingKey ~= "" and kn == CFG.touchFlingKey then
        FL.touchFling()
    end
    if CFG.flingAllKey ~= "" and kn == CFG.flingAllKey then
        FL.flingAll()
    end
end)

-- ═══ FLY LOOP ═══
local keys = {}
UIS.InputBegan:Connect(function(i, g)
    if not g and i.KeyCode then keys[i.KeyCode] = true end
end)
UIS.InputEnded:Connect(function(i)
    if i.KeyCode then keys[i.KeyCode] = nil end
end)

RunService.Heartbeat:Connect(function()
    -- fly
    if tFly.get() and flyBV and flyBG then
        pcall(function()
            local cf = cam.CFrame
            local d = Vector3.zero
            if keys[Enum.KeyCode.W] or keys[Enum.KeyCode.Z] then
                d = d + cf.LookVector end
            if keys[Enum.KeyCode.S] then d = d - cf.LookVector end
            if keys[Enum.KeyCode.A] or keys[Enum.KeyCode.Q] then
                d = d - cf.RightVector end
            if keys[Enum.KeyCode.D] then d = d + cf.RightVector end
            if keys[Enum.KeyCode.Space] or keys[Enum.KeyCode.E] then
                d = d + Vector3.yAxis end
            if keys[Enum.KeyCode.LeftShift] or keys[Enum.KeyCode.C] then
                d = d - Vector3.yAxis end
            flyBV.Velocity = d.Magnitude > 0
                and d.Unit * sFlySpd.val or Vector3.zero
            flyBG.CFrame = cf
        end)
    end

    -- speed
    if tSpeed.get() then
        pcall(function() ghum().WalkSpeed = sSpeed.val end)
    end

    -- jump power
    pcall(function()
        local h = ghum()
        if h then h.JumpPower = sJumpPower.val end
    end)
end)

-- ═══ RESPAWN HOOK ═══
LP.CharacterAdded:Connect(function()
    if tFly.get() then tFly.set(false) end
    if tNoclip.get() then tNoclip.set(false) end
    if tSpin.get() then tSpin.set(false) end
    FL.stop()
    task.wait(2)
    FL.busy = false
end)

-- ═══ DONE ═══
Toast("Avocat Hub V2 chargé !", C.G)
