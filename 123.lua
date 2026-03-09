local player = game.Players.LocalPlayer
local coreGui = game:GetService("CoreGui")
local virtualUser = game:GetService("VirtualUser")
local autoTrade = false
local antiAfk = false
local isRunning = false
local afkConnection

local validKeys = {
    ["q1z1xx"] = true,
    ["nazar"] = true,
    ["dima"] = true
}

if coreGui:FindFirstChild("AutoTradeGUI") then
    coreGui.AutoTradeGUI:Destroy()
end

local gui = Instance.new("ScreenGui")
gui.Name = "AutoTradeGUI"
gui.Parent = coreGui

-- === ВІКНО КЛЮЧА ===
local keyFrame = Instance.new("Frame")
keyFrame.Size = UDim2.new(0, 220, 0, 120)
keyFrame.Position = UDim2.new(0.5, -110, 0.5, -60)
keyFrame.BackgroundColor3 = Color3.fromRGB(30, 30, 35)
keyFrame.Active = true
keyFrame.Draggable = true
keyFrame.Parent = gui
Instance.new("UICorner", keyFrame).CornerRadius = UDim.new(0, 10)

local keyTitle = Instance.new("TextLabel", keyFrame)
keyTitle.Size = UDim2.new(1, 0, 0, 40)
keyTitle.BackgroundTransparency = 1
keyTitle.TextColor3 = Color3.fromRGB(255, 255, 255)
keyTitle.Font = Enum.Font.GothamBold
keyTitle.TextSize = 16
keyTitle.Text = "Trading Hub by q1z1xx"

local keyBox = Instance.new("TextBox", keyFrame)
keyBox.Size = UDim2.new(0.85, 0, 0, 30)
keyBox.Position = UDim2.new(0.075, 0, 0.35, 0)
keyBox.BackgroundColor3 = Color3.fromRGB(50, 50, 55)
keyBox.TextColor3 = Color3.fromRGB(255, 255, 255)
keyBox.Font = Enum.Font.GothamSemibold
keyBox.TextSize = 14
keyBox.PlaceholderText = "Введіть ключ..."
keyBox.Text = ""
Instance.new("UICorner", keyBox).CornerRadius = UDim.new(0, 5)

local loginBtn = Instance.new("TextButton", keyFrame)
loginBtn.Size = UDim2.new(0.85, 0, 0, 30)
loginBtn.Position = UDim2.new(0.075, 0, 0.65, 0)
loginBtn.BackgroundColor3 = Color3.fromRGB(39, 174, 96)
loginBtn.TextColor3 = Color3.fromRGB(255, 255, 255)
loginBtn.Font = Enum.Font.GothamBold
loginBtn.TextSize = 14
loginBtn.Text = "Увійти"
Instance.new("UICorner", loginBtn).CornerRadius = UDim.new(0, 5)

-- === ГОЛОВНЕ ВІКНО ===
local frame = Instance.new("Frame")
frame.Size = UDim2.new(0, 220, 0, 200)
frame.Position = UDim2.new(0.5, -110, 0.5, -100)
frame.BackgroundColor3 = Color3.fromRGB(30, 30, 35)
frame.Active = true
frame.Draggable = true
frame.Visible = false
frame.Parent = gui
Instance.new("UICorner", frame).CornerRadius = UDim.new(0, 10)

local title = Instance.new("TextLabel", frame)
title.Size = UDim2.new(1, -40, 0, 40)
title.BackgroundTransparency = 1
title.TextColor3 = Color3.fromRGB(255, 255, 255)
title.Font = Enum.Font.GothamBold
title.TextSize = 18
title.Text = "Auto Trade"

local closeBtn = Instance.new("TextButton", frame)
closeBtn.Size = UDim2.new(0, 30, 0, 30)
closeBtn.Position = UDim2.new(1, -35, 0, 5)
closeBtn.BackgroundColor3 = Color3.fromRGB(235, 87, 87)
closeBtn.TextColor3 = Color3.fromRGB(255, 255, 255)
closeBtn.Font = Enum.Font.GothamBold
closeBtn.TextSize = 14
closeBtn.Text = "X"
Instance.new("UICorner", closeBtn).CornerRadius = UDim.new(0, 8)

local function createButton(text, posY, color)
    local btn = Instance.new("TextButton", frame)
    btn.Size = UDim2.new(0.85, 0, 0, 40)
    btn.Position = UDim2.new(0.075, 0, posY, 0)
    btn.BackgroundColor3 = color
    btn.TextColor3 = Color3.fromRGB(255, 255, 255)
    btn.Font = Enum.Font.GothamSemibold
    btn.TextSize = 14
    btn.Text = text
    btn.AutoButtonColor = true
    Instance.new("UICorner", btn).CornerRadius = UDim.new(0, 8)
    return btn
end

local toggleBtn = createButton("Auto Trade: OFF", 0.2, Color3.fromRGB(235, 87, 87))
local afkBtn = createButton("Anti-AFK: OFF", 0.45, Color3.fromRGB(235, 87, 87))
local creditsBtn = createButton("Credits", 0.7, Color3.fromRGB(45, 156, 219))

local function clickButton(btn)
    if not btn then return end
    pcall(function()
        if getconnections then
            for _, conn in pairs(getconnections(btn.MouseButton1Click)) do conn:Fire() end
            for _, conn in pairs(getconnections(btn.Activated)) do conn:Fire() end
        elseif firesignal then
            firesignal(btn.MouseButton1Click)
            firesignal(btn.Activated)
        end
    end)
end

local function startLoop()
    task.spawn(function()
        while isRunning do
            task.wait(0.5)
            if not autoTrade then continue end
            
            local playerGui = player:FindFirstChild("PlayerGui")
            if not playerGui then continue end

            -- 1. ACCEPT (Глобальний пошук, як у робочій версії)
            pcall(function()
                for _, obj in pairs(playerGui:GetDescendants()) do
                    if obj:IsA("TextLabel") and (obj.Text == "Accept" or obj.Text == "ACCEPT") then
                        if obj.Parent and obj.Parent:IsA("GuiButton") then clickButton(obj.Parent) end
                    elseif obj:IsA("GuiButton") and (obj.Name == "Accept" or obj.Name == "AcceptButton") then
                        clickButton(obj)
                    elseif obj:IsA("TextButton") and (obj.Text == "Accept" or obj.Text == "ACCEPT") then
                        clickButton(obj)
                    end
                end
            end)

            -- 2. READY
            pcall(function()
                local tradeGui = playerGui:FindFirstChild("TradeLiveTrade")
                if tradeGui then
                    local mainFrame = tradeGui:FindFirstChild("TradeLiveTrade")
                    if mainFrame then
                        local otherFrame = mainFrame:FindFirstChild("Other")
                        if otherFrame then
                            local readyBtn = otherFrame:FindFirstChild("ReadyButton")
                            if readyBtn then clickButton(readyBtn) end
                        end
                    end
                end
            end)
        end
    end)
end

-- === ЛОГІКА КНОПОК ===
loginBtn.MouseButton1Click:Connect(function()
    local input = keyBox.Text:lower()
    if validKeys[input] then
        keyFrame.Visible = false
        frame.Visible = true
        isRunning = true
        startLoop()
    else
        gui:Destroy()
    end
end)

toggleBtn.MouseButton1Click:Connect(function()
    autoTrade = not autoTrade
    toggleBtn.Text = autoTrade and "Auto Trade: ON" or "Auto Trade: OFF"
    toggleBtn.BackgroundColor3 = autoTrade and Color3.fromRGB(39, 174, 96) or Color3.fromRGB(235, 87, 87)
end)

afkBtn.MouseButton1Click:Connect(function()
    antiAfk = not antiAfk
    afkBtn.Text = antiAfk and "Anti-AFK: ON" or "Anti-AFK: OFF"
    afkBtn.BackgroundColor3 = antiAfk and Color3.fromRGB(39, 174, 96) or Color3.fromRGB(235, 87, 87)
    
    if antiAfk then
        afkConnection = player.Idled:Connect(function()
            virtualUser:CaptureController()
            virtualUser:ClickButton2(Vector2.new())
        end)
    else
        if afkConnection then 
            afkConnection:Disconnect() 
            afkConnection = nil
        end
    end
end)

creditsBtn.MouseButton1Click:Connect(function()
    if setclipboard then setclipboard("https://madness.click") end
end)

closeBtn.MouseButton1Click:Connect(function()
    isRunning = false
    if afkConnection then afkConnection:Disconnect() end
    gui:Destroy()
end)
