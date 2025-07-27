-- Services
local Players = game:GetService("Players")
local Workspace = game:GetService("Workspace")
local RunService = game:GetService("RunService")
local player = Players.LocalPlayer

-- UI Setup
local screenGui = Instance.new("ScreenGui", player:WaitForChild("PlayerGui"))
screenGui.Name = "PetESP_GUI"
screenGui.ResetOnSpawn = false

local mainFrame = Instance.new("Frame", screenGui)
mainFrame.Size = UDim2.new(0, 250, 0, 240)
mainFrame.Position = UDim2.new(0.02, 0, 0.2, 0)
mainFrame.BackgroundTransparency = 0.2
mainFrame.BackgroundColor3 = Color3.fromRGB(20, 20, 20)
mainFrame.BorderSizePixel = 0
mainFrame.Active = true
mainFrame.Draggable = true

local title = Instance.new("TextLabel", mainFrame)
title.Text = "🌟 Pet Randomizer"
title.Font = Enum.Font.GothamBold
title.TextSize = 18
title.Size = UDim2.new(1, 0, 0, 30)
title.BackgroundTransparency = 1
title.TextColor3 = Color3.fromRGB(255, 255, 255)

local username = Instance.new("TextLabel", mainFrame)
username.Text = "User: " .. player.Name
username.Font = Enum.Font.Gotham
username.TextSize = 14
username.Size = UDim2.new(1, 0, 0, 20)
username.Position = UDim2.new(0, 0, 0, 30)
username.BackgroundTransparency = 1
username.TextColor3 = Color3.fromRGB(200, 200, 200)

local timeLabel = Instance.new("TextLabel", mainFrame)
timeLabel.Text = "Time: 00:00:00"
timeLabel.Font = Enum.Font.Gotham
timeLabel.TextSize = 14
timeLabel.Size = UDim2.new(1, 0, 0, 20)
timeLabel.Position = UDim2.new(0, 0, 0, 50)
timeLabel.BackgroundTransparency = 1
timeLabel.TextColor3 = Color3.fromRGB(180, 180, 180)

-- ESP Toggle
local espEnabled = false
local toggleBtn = Instance.new("TextButton", mainFrame)
toggleBtn.Text = "ESP: OFF"
toggleBtn.Size = UDim2.new(1, 0, 0, 30)
toggleBtn.Position = UDim2.new(0, 0, 0, 80)
toggleBtn.BackgroundColor3 = Color3.fromRGB(50, 50, 50)
toggleBtn.TextColor3 = Color3.new(1,1,1)
toggleBtn.Font = Enum.Font.GothamBold
toggleBtn.TextSize = 16

toggleBtn.MouseButton1Click:Connect(function()
	espEnabled = not espEnabled
	toggleBtn.Text = "ESP: " .. (espEnabled and "ON" or "OFF")
end)

-- Randomize Once Button
local randBtn = Instance.new("TextButton", mainFrame)
randBtn.Text = "Randomize ESP"
randBtn.Size = UDim2.new(1, 0, 0, 30)
randBtn.Position = UDim2.new(0, 0, 0, 120)
randBtn.BackgroundColor3 = Color3.fromRGB(80, 80, 80)
randBtn.TextColor3 = Color3.new(1,1,1)
randBtn.Font = Enum.Font.GothamBold
randBtn.TextSize = 16

-- Auto Mode Button
local autoBtn = Instance.new("TextButton", mainFrame)
autoBtn.Text = "Auto Randomize"
autoBtn.Size = UDim2.new(1, 0, 0, 30)
autoBtn.Position = UDim2.new(0, 0, 0, 160)
autoBtn.BackgroundColor3 = Color3.fromRGB(100, 100, 100)
autoBtn.TextColor3 = Color3.new(1,1,1)
autoBtn.Font = Enum.Font.GothamBold
autoBtn.TextSize = 16

-- Got Hit Display
local gotHitLabel = Instance.new("TextLabel", mainFrame)
gotHitLabel.Text = ""
gotHitLabel.Font = Enum.Font.GothamBlack
gotHitLabel.TextSize = 20
gotHitLabel.Size = UDim2.new(1, 0, 0, 30)
gotHitLabel.Position = UDim2.new(0, 0, 0, 200)
gotHitLabel.BackgroundTransparency = 1
gotHitLabel.TextColor3 = Color3.fromRGB(255, 0, 0)

-- Pet Pool
local eggPets = {
	NightEgg = {
		{name="Phantom Cat", weight=0.5},
		{name="Dark Bat", weight=5},
		{name="Moon Mouse", weight=20},
		{name="Owl", weight=70}
	},
	-- Add other eggs similarly...
}

-- 🧠 Helper: Rainbow color animation
local function getRainbow(t)
	local r = math.sin(t) * 127 + 128
	local g = math.sin(t + 2) * 127 + 128
	local b = math.sin(t + 4) * 127 + 128
	return Color3.fromRGB(r, g, b)
end

-- 🧠 Get pet name + rarity color
local function getPetForEgg(eggType)
	local pool = eggPets[eggType]
	if not pool then return nil, nil, nil end

	local total = 0
	for _, pet in ipairs(pool) do total += pet.weight end
	local rand = math.random() * total
	local acc = 0
	for _, pet in ipairs(pool) do
		acc += pet.weight
		if rand <= acc then
			local rarity = pet.weight
			local color = Color3.new(1, 1, 1) -- default

			if rarity <= 0.5 then
				color = getRainbow(tick())
			elseif rarity <= 5 then
				color = Color3.fromRGB(255, 120, 0)
			elseif rarity <= 20 then
				color = Color3.fromRGB(180, 100, 255)
			end

			return pet.name, color, rarity <= 0.5
		end
	end
end

-- 🔁 Randomize Names
function randomizeAll()
	if not espEnabled then return end
	gotHitLabel.Text = ""
	for _, obj in pairs(Workspace:GetDescendants()) do
		if obj:IsA("BillboardGui") and obj:FindFirstChildOfClass("TextLabel") then
			local label = obj:FindFirstChildOfClass("TextLabel")
			local eggName = obj.Parent and obj.Parent.Name
			local petName, color, gotHit = getPetForEgg(eggName)
			if petName and label then
				label.Text = petName
				label.TextColor3 = color
				label.TextStrokeTransparency = 0
				if gotHit then
					gotHitLabel.Text = "🎯 Got Hit!"
				end
			end
		end
	end
end

-- 🎯 Auto randomize until rarest hit
local auto = false
autoBtn.MouseButton1Click:Connect(function()
	if auto then return end
	auto = true
	gotHitLabel.Text = ""
	while auto do
		randomizeAll()
		if gotHitLabel.Text ~= "" then
			wait(1)
			break
		end
		wait(0.5)
	end
	auto = false
end)

randBtn.MouseButton1Click:Connect(randomizeAll)

-- ⏰ Clock Update
spawn(function()
	while true do
		timeLabel.Text = "Time: " .. os.date("%H:%M:%S")
		wait(1)
	end
end)
