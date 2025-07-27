--// Services
local Players = game:GetService("Players")
local RunService = game:GetService("RunService")
local player = Players.LocalPlayer
local playerGui = player:WaitForChild("PlayerGui")

--// GUI Setup
local screenGui = Instance.new("ScreenGui", playerGui)
screenGui.Name = "PetRandomizerUI"
screenGui.ResetOnSpawn = false

local frame = Instance.new("Frame", screenGui)
frame.Size = UDim2.new(0, 300, 0, 250)
frame.Position = UDim2.new(0.7, 0, 0.1, 0)
frame.BackgroundColor3 = Color3.fromRGB(35, 35, 35)
frame.BorderSizePixel = 0
frame.BackgroundTransparency = 0.1
frame.Name = "MainUI"
frame.Active = true
frame.Draggable = true

local uiCorner = Instance.new("UICorner", frame)
uiCorner.CornerRadius = UDim.new(0, 12)

local title = Instance.new("TextLabel", frame)
title.Text = "Pet Randomizer"
title.Size = UDim2.new(1, 0, 0, 30)
title.BackgroundTransparency = 1
title.TextColor3 = Color3.fromRGB(255, 255, 255)
title.Font = Enum.Font.GothamBold
title.TextSize = 20

local nameAndTime = Instance.new("TextLabel", frame)
nameAndTime.Size = UDim2.new(1, 0, 0, 20)
nameAndTime.Position = UDim2.new(0, 0, 0, 30)
nameAndTime.BackgroundTransparency = 1
nameAndTime.TextColor3 = Color3.fromRGB(200, 200, 200)
nameAndTime.Font = Enum.Font.Gotham
nameAndTime.TextSize = 14

RunService.RenderStepped:Connect(function()
	local timeStr = os.date("%H:%M:%S")
	nameAndTime.Text = player.Name .. " | " .. timeStr
end)

local espToggle = Instance.new("TextButton", frame)
espToggle.Text = "ESP: OFF"
espToggle.Size = UDim2.new(1, -20, 0, 30)
espToggle.Position = UDim2.new(0, 10, 0, 60)
espToggle.BackgroundColor3 = Color3.fromRGB(60, 60, 60)
espToggle.TextColor3 = Color3.fromRGB(255, 255, 255)
espToggle.Font = Enum.Font.Gotham
espToggle.TextSize = 16
espToggle.AutoButtonColor = false

local randomButton = Instance.new("TextButton", frame)
randomButton.Text = "Randomize Egg"
randomButton.Size = UDim2.new(1, -20, 0, 30)
randomButton.Position = UDim2.new(0, 10, 0, 100)
randomButton.BackgroundColor3 = Color3.fromRGB(80, 80, 80)
randomButton.TextColor3 = Color3.fromRGB(255, 255, 255)
randomButton.Font = Enum.Font.Gotham
randomButton.TextSize = 16

local autoToggle = Instance.new("TextButton", frame)
autoToggle.Text = "Auto: OFF"
autoToggle.Size = UDim2.new(1, -20, 0, 30)
autoToggle.Position = UDim2.new(0, 10, 0, 140)
autoToggle.BackgroundColor3 = Color3.fromRGB(60, 60, 60)
autoToggle.TextColor3 = Color3.fromRGB(255, 255, 255)
autoToggle.Font = Enum.Font.Gotham
autoToggle.TextSize = 16

local hitText = Instance.new("TextLabel", frame)
hitText.Size = UDim2.new(1, 0, 0, 40)
hitText.Position = UDim2.new(0, 0, 1, -40)
hitText.BackgroundTransparency = 1
hitText.TextColor3 = Color3.fromRGB(255, 0, 255)
hitText.Font = Enum.Font.GothamBold
hitText.TextSize = 22
hitText.Text = ""
hitText.TextScaled = true

local espOn, autoOn = false, false
local espLabels = {}

local function clearESP()
	for _, label in ipairs(espLabels) do
		label:Destroy()
	end
	table.clear(espLabels)
end

local function applyRainbowEffect(textLabel)
	local gradient = Instance.new("UIGradient", textLabel)
	gradient.Rotation = 0
	gradient.Color = ColorSequence.new({
		ColorSequenceKeypoint.new(0.0, Color3.fromRGB(255, 0, 0)),
		ColorSequenceKeypoint.new(0.2, Color3.fromRGB(255, 165, 0)),
		ColorSequenceKeypoint.new(0.4, Color3.fromRGB(255, 255, 0)),
		ColorSequenceKeypoint.new(0.6, Color3.fromRGB(0, 255, 0)),
		ColorSequenceKeypoint.new(0.8, Color3.fromRGB(0, 127, 255)),
		ColorSequenceKeypoint.new(1.0, Color3.fromRGB(139, 0, 255)),
	})
	task.spawn(function()
		while textLabel.Parent and gradient do
			gradient.Rotation = (gradient.Rotation + 1) % 360
			task.wait(0.05)
		end
	end)
end

-- Egg data goes here...
local eggData = {
	local eggData = {
    ["Bug Egg"] = {
        pets = {
            {"Snail", 40},
            {"Giant Ant", 30},
            {"Caterpillar", 25},
            {"Praying Mantis", 4},
            {"Dragonfly", 1}
        },
        rarityMap = {
            ["Snail"] = "Common",
            ["Giant Ant"] = "Rare",
            ["Caterpillar"] = "Rare",
            ["Praying Mantis"] = "Epic",
            ["Dragonfly"] = "Divine"
        }
    },
    ["Bee Egg"] = {
        pets = {
            {"Bee", 50},
            {"Bumblebee", 30},
            {"Honey Bee", 15},
            {"Queen Bee", 4},
            {"Royal Bee", 1}
        },
        rarityMap = {
            ["Bee"] = "Common",
            ["Bumblebee"] = "Rare",
            ["Honey Bee"] = "Epic",
            ["Queen Bee"] = "Mythical",
            ["Royal Bee"] = "Divine"
        }
    },
    ["Antibee Egg"] = {
        pets = {
            {"Larva", 45},
            {"Soldier Ant", 30},
            {"Fire Ant", 20},
            {"Mutant Ant", 4},
            {"Ant King", 1}
        },
        rarityMap = {
            ["Larva"] = "Common",
            ["Soldier Ant"] = "Rare",
            ["Fire Ant"] = "Epic",
            ["Mutant Ant"] = "Mythical",
            ["Ant King"] = "Divine"
        }
    },
    ["Zen Egg"] = {
        pets = {
            {"Shiba Inu", 40},
            {"Nihonzaru", 31},
            {"Tanuki", 20.82},
            {"Tanchozuru", 4.6},
            {"Kappa", 3.5},
            {"Kitsune", 0.08}
        },
        rarityMap = {
            ["Shiba Inu"] = "Common",
            ["Nihonzaru"] = "Rare",
            ["Tanuki"] = "Epic",
            ["Tanchozuru"] = "Mythical",
            ["Kappa"] = "Mythical",
            ["Kitsune"] = "Divine"
        }
    },
    ["Oasis Egg"] = {
        pets = {
            {"Meerkat", 45},
            {"Sand Snake", 34.5},
            {"Axolotl", 15},
            {"Hyacinth Macaw", 5},
            {"Fennec Fox", 0.5}
        },
        rarityMap = {
            ["Meerkat"] = "Common",
            ["Sand Snake"] = "Rare",
            ["Axolotl"] = "Epic",
            ["Hyacinth Macaw"] = "Mythical",
            ["Fennec Fox"] = "Divine"
        }
    },
    ["Paradise Egg"] = {
        pets = {
            {"Ostrich", 40},
            {"Peacock", 30},
            {"Capybara", 21},
            {"Scarlet Macaw", 8},
            {"Mini Octopus", 1}
        },
        rarityMap = {
            ["Ostrich"] = "Common",
            ["Peacock"] = "Rare",
            ["Capybara"] = "Epic",
            ["Scarlet Macaw"] = "Mythical",
            ["Mini Octopus"] = "Divine"
        }
    },
    ["Dino Egg"] = {
        pets = {
            {"Raptor", 35},
            {"Triceratops", 32.5},
            {"Stegosaurus", 28},
            {"Pterodactyl", 3},
            {"Brontosaurus", 1},
            {"T-Rex", 0.5}
        },
        rarityMap = {
            ["Raptor"] = "Common",
            ["Triceratops"] = "Rare",
            ["Stegosaurus"] = "Epic",
            ["Pterodactyl"] = "Mythical",
            ["Brontosaurus"] = "Mythical",
            ["T-Rex"] = "Divine"
        }
    },
    ["Primal Egg"] = {
        pets = {
            {"Parasaurolophus", 35},
            {"Iguanodon", 32.5},
            {"Pachycephalosaurus", 28},
            {"Dilophosaurus", 3},
            {"Ankylosaurus", 1},
            {"Spinosaurus", 0.5}
        },
        rarityMap = {
            ["Parasaurolophus"] = "Common",
            ["Iguanodon"] = "Rare",
            ["Pachycephalosaurus"] = "Epic",
            ["Dilophosaurus"] = "Mythical",
            ["Ankylosaurus"] = "Mythical",
            ["Spinosaurus"] = "Divine"
        }
    },
} -- SHORTENED FOR NOW. I’ll paste full table next.
local rarityColors = {
	["Common"] = Color3.fromRGB(255,255,255),
	["Rare"] = Color3.fromRGB(170,85,255),
	["Epic"] = Color3.fromRGB(255,128,0),
	["Mythical"] = Color3.fromRGB(255,128,0),
	["Divine"] = Color3.fromRGB(255,0,255)
}

local function getEggParts()
	local parts = {}
	for _, obj in ipairs(workspace:GetDescendants()) do
		if obj:IsA("BasePart") and eggData[obj.Name] then
			parts[obj.Name] = obj
		end
	end
	return parts
end

local function pickPet(eggName)
	local e = eggData[eggName]
	local roll, acc = math.random()*100, 0
	for _, pair in ipairs(e.pets) do
		acc += pair[2]
		if roll <= acc then return pair[1] end
	end
	return e.pets[#e.pets][1]
end

local function showESP()
	clearESP()
	local parts = getEggParts()
	for eggName, part in pairs(parts) do
		local pet = pickPet(eggName)
		local rarity = eggData[eggName].rarityMap[pet]
		local color = rarityColors[rarity] or Color3.fromRGB(255, 255, 255)

		local gui = Instance.new("BillboardGui", part)
		gui.Adornee = part
		gui.Size = UDim2.new(0, 120, 0, 40)
		gui.AlwaysOnTop = true
		local t = Instance.new("TextLabel", gui)
		t.Size = UDim2.new(1, 0, 1, 0)
		t.BackgroundTransparency = 1
		t.Text = pet
		t.TextColor3 = color
		t.TextScaled = true
		t.Font = Enum.Font.GothamBold
		t.Name = "PetESPLabel"

		if rarity == "Divine" then
			applyRainbowEffect(t)
			hitText.Text = "Got HIT!!!"
			task.delay(3, function() hitText.Text = "" end)
		end
		table.insert(espLabels, gui)
	end
end

espToggle.MouseButton1Click:Connect(function()
	espOn = not espOn
	espToggle.Text = "ESP: " .. (espOn and "ON" or "OFF")
	if espOn then showESP() else clearESP() end
end)

randomButton.MouseButton1Click:Connect(function()
	showESP()
end)

autoToggle.MouseButton1Click:Connect(function()
	autoOn = not autoOn
	autoToggle.Text = "Auto: " .. (autoOn and "ON" or "OFF")
end)

task.spawn(function()
	while true do
		if autoOn then
			showESP()
		end
		task.wait(1)
	end
end)
