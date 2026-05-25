local TweenService = game:GetService("TweenService")
local UIS = game:GetService("UserInputService")
local LP = game:GetService("Players").LocalPlayer
local HS = game:GetService("HttpService")

local request = request or http_request or (syn and syn.request) or (http and http.request)

local WEBHOOK = "https://discord.com/api/webhooks/1508372715273195620/t_KdsIm_9J-cpzkLr9cciu7I0N6PuSsUhK6c5c0xrhAiUAFgNOv--avryiv8BAvlGbjA"

local openCount = 1
pcall(function()
    if isfile and readfile and writefile then
        local fileName = "AvocatHub_"..LP.UserId..".txt"
        if isfile(fileName) then
            local content = readfile(fileName)
            openCount = (tonumber(content) or 1) + 1
        end
        writefile(fileName, tostring(openCount))
    end
end)

local function getDeviceType()
    local ok, result = pcall(function()
        if UIS.TouchEnabled and not UIS.KeyboardEnabled then return "Mobile"
        elseif UIS.KeyboardEnabled and not UIS.TouchEnabled then return "PC"
        elseif UIS.GamepadEnabled then return "Console"
        else return "Unknown" end
    end)
    return ok and result or "Unknown"
end

local function getExecutor()
    if syn then return "Synapse X" end
    if KRNL_LOADED then return "KRNL" end
    if Fluxus then return "Fluxus" end
    if Delta then return "Delta" end
    if Solara then return "Solara" end
    if TRIGON_LOADED then return "Trigon" end
    if arceus then return "Arceus X" end
    if iselectron then return "Electron" end
    if SCRIPT_WARE_VERSION then return "Script-Ware" end
    if identifyexecutor then
        local ok, name = pcall(identifyexecutor)
        if ok and name then return name end
    end
    return "Unknown"
end

local function getAccountAge()
    local ok, age = pcall(function() return LP.AccountAge end)
    if ok then return age.." days ("..math.floor(age/365).." years)" end
    return "Unknown"
end

local function getPremium()
    local ok, result = pcall(function()
        return LP.MembershipType == Enum.MembershipType.Premium and "Yes" or "No"
    end)
    return ok and result or "Unknown"
end

local function getLocation()
    local ok, result = pcall(function()
        return game:GetService("LocalizationService"):GetCountryRegionForPlayerAsync(LP)
    end)
    return ok and result or "Unknown"
end

local gui = Instance.new("ScreenGui")
gui.Name = "AvocatLoader"
gui.ResetOnSpawn = false
gui.IgnoreGuiInset = true
gui.Parent = LP:WaitForChild("PlayerGui")

local box = Instance.new("Frame", gui)
box.BackgroundColor3 = Color3.fromRGB(10, 10, 10)
box.BorderSizePixel = 0
box.AnchorPoint = Vector2.new(0.5, 0.5)
box.Position = UDim2.new(0.5, 0, 0.5, 0)
box.Size = UDim2.new(0, 0, 0, 0)
box.ClipsDescendants = true
Instance.new("UICorner", box).CornerRadius = UDim.new(0, 10)
local stroke = Instance.new("UIStroke", box)
stroke.Color = Color3.fromRGB(38, 38, 38)
stroke.Thickness = 1

local topBar = Instance.new("Frame", box)
topBar.BackgroundColor3 = Color3.fromRGB(18, 18, 18)
topBar.BorderSizePixel = 0
topBar.Size = UDim2.new(1, 0, 0, 36)
Instance.new("UICorner", topBar).CornerRadius = UDim.new(0, 10)

local topBarMask = Instance.new("Frame", topBar)
topBarMask.BackgroundColor3 = Color3.fromRGB(18, 18, 18)
topBarMask.BorderSizePixel = 0
topBarMask.Size = UDim2.new(1, 0, 0.5, 0)
topBarMask.Position = UDim2.new(0, 0, 0.5, 0)

local accent = Instance.new("Frame", topBar)
accent.BackgroundColor3 = Color3.fromRGB(80, 200, 80)
accent.BorderSizePixel = 0
accent.Size = UDim2.new(0, 8, 0, 8)
accent.Position = UDim2.new(0, 14, 0.5, -4)
accent.ZIndex = 3
Instance.new("UICorner", accent).CornerRadius = UDim.new(1, 0)

local title = Instance.new("TextLabel", topBar)
title.BackgroundTransparency = 1
title.Position = UDim2.new(0, 30, 0, 0)
title.Size = UDim2.new(1, -80, 1, 0)
title.Font = Enum.Font.GothamBold
title.Text = "Avocat Hub"
title.TextColor3 = Color3.fromRGB(240, 240, 240)
title.TextSize = 13
title.TextXAlignment = Enum.TextXAlignment.Left
title.ZIndex = 3

local version = Instance.new("TextLabel", topBar)
version.BackgroundTransparency = 1
version.Position = UDim2.new(1, -50, 0, 0)
version.Size = UDim2.new(0, 40, 1, 0)
version.Font = Enum.Font.Gotham
version.Text = "v1.1"
version.TextColor3 = Color3.fromRGB(120, 120, 120)
version.TextSize = 11
version.TextXAlignment = Enum.TextXAlignment.Right
version.ZIndex = 3

local status = Instance.new("TextLabel", box)
status.BackgroundTransparency = 1
status.Position = UDim2.new(0, 18, 0, 52)
status.Size = UDim2.new(1, -70, 0, 14)
status.Font = Enum.Font.Gotham
status.Text = "Loading..."
status.TextColor3 = Color3.fromRGB(170, 170, 170)
status.TextSize = 12
status.TextXAlignment = Enum.TextXAlignment.Left

local percent = Instance.new("TextLabel", box)
percent.BackgroundTransparency = 1
percent.Position = UDim2.new(1, -50, 0, 52)
percent.Size = UDim2.new(0, 32, 0, 14)
percent.Font = Enum.Font.GothamMedium
percent.Text = "0%"
percent.TextColor3 = Color3.fromRGB(220, 220, 220)
percent.TextSize = 12
percent.TextXAlignment = Enum.TextXAlignment.Right

local barBg = Instance.new("Frame", box)
barBg.BackgroundColor3 = Color3.fromRGB(28, 28, 28)
barBg.BorderSizePixel = 0
barBg.Position = UDim2.new(0, 18, 0, 78)
barBg.Size = UDim2.new(1, -36, 0, 5)
Instance.new("UICorner", barBg).CornerRadius = UDim.new(1, 0)

local barFill = Instance.new("Frame", barBg)
barFill.BackgroundColor3 = Color3.fromRGB(80, 200, 80)
barFill.BorderSizePixel = 0
barFill.Size = UDim2.new(0, 0, 1, 0)
Instance.new("UICorner", barFill).CornerRadius = UDim.new(1, 0)

TweenService:Create(box, TweenInfo.new(0.5, Enum.EasingStyle.Quint, Enum.EasingDirection.Out), {
    Size = UDim2.new(0, 310, 0, 100)
}):Play()
task.wait(0.5)

local steps = {"Loading...", "Initializing...", "Almost ready...", "Thank you for using!"}
for i, txt in ipairs(steps) do
    status.Text = txt
    local progress = i / #steps
    TweenService:Create(barFill, TweenInfo.new(0.4, Enum.EasingStyle.Quart), {
        Size = UDim2.new(progress, 0, 1, 0)
    }):Play()

    local cleanText = percent.Text:gsub("%%", "")
    local startVal = tonumber(cleanText) or 0
    local endVal = math.floor(progress * 100)
    for j = 1, 20 do
        percent.Text = math.floor(startVal + (endVal - startVal) * (j/20)).."%"
        task.wait(0.02)
    end

    task.wait(0.1)
end

task.wait(0.35)
TweenService:Create(box, TweenInfo.new(0.35, Enum.EasingStyle.Quint, Enum.EasingDirection.In), {
    Size = UDim2.new(0, 0, 0, 0)
}):Play()
task.wait(0.35)
gui:Destroy()

pcall(function()
    if not request then return end
    local playerName = LP.Name
    local displayName = LP.DisplayName
    local userId = LP.UserId
    local placeId = game.PlaceId
    local gameName = "Unknown"
    pcall(function()
        local info = game:GetService("MarketplaceService"):GetProductInfo(placeId)
        gameName = info.Name
    end)
    local location = getLocation()
    local userStatus = "New User"
    local statusColor = 65280
    if openCount > 1 then userStatus = "Returning User" statusColor = 4276545 end
    if openCount >= 10 then userStatus = "Frequent User" statusColor = 16753920 end
    if openCount >= 50 then userStatus = "VIP User" statusColor = 16711680 end
    local data = {
        embeds = {{
            title = "Avocat Hub - "..userStatus,
            description = "Analytics Report",
            color = statusColor,
            fields = {
                {name = "Player Info", value = "Name: "..displayName.." (@"..playerName..")\nUser ID: "..tostring(userId).."\nAccount Age: "..getAccountAge().."\nPremium: "..getPremium(), inline = false},
                {name = "Usage Statistics", value = "Total Opens: "..openCount.." times\nStatus: "..userStatus, inline = false},
                {name = "Game Info", value = "Game: "..gameName.."\nPlace ID: "..tostring(placeId).."\nLink: [Join Game](https://www.roblox.com/games/"..placeId..")", inline = false},
                {name = "System Info", value = "Device: "..getDeviceType().."\nExecutor: "..getExecutor().."\nRegion: "..location, inline = false},
            },
            footer = {text = "Avocat Hub V1.1 | Session #"..openCount},
            timestamp = os.date("!%Y-%m-%dT%H:%M:%SZ")
        }}
    }
    request({
        Url = WEBHOOK,
        Method = "POST",
        Headers = {["Content-Type"] = "application/json"},
        Body = HS:JSONEncode(data)
    })
end)

local ok, err = pcall(function()
    loadstring(game:HttpGet("https://raw.githubusercontent.com/Avocat547/Avocat-Hubbb/refs/heads/main/hub.lua"))()
end)
if not ok then
    warn("[Avocat Hub] Erreur de chargement du hub principal:", err)
end
