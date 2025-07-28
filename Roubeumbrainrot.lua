-- Meu Hub (Delta Executor Script)
-- Feito com carinho pela Maninha ✨

local Players = game:GetService("Players")
local LocalPlayer = Players.LocalPlayer
local UIS = game:GetService("UserInputService")
local HighlightFolder = Instance.new("Folder", game.CoreGui)
HighlightFolder.Name = "ESP_Highlights"

-- UI
local ScreenGui = Instance.new("ScreenGui", game.CoreGui)
local Frame = Instance.new("Frame", ScreenGui)
Frame.Size = UDim2.new(0, 250, 0, 180)
Frame.Position = UDim2.new(0, 20, 0, 100)
Frame.BackgroundColor3 = Color3.fromRGB(30, 30, 30)
Frame.BorderSizePixel = 0
Frame.Active = true
Frame.Draggable = true

local UICorner = Instance.new("UICorner", Frame)
UICorner.CornerRadius = UDim.new(0, 10)

local UIListLayout = Instance.new("UIListLayout", Frame)
UIListLayout.Padding = UDim.new(0, 10)
UIListLayout.SortOrder = Enum.SortOrder.LayoutOrder

local function createButton(text, color)
	local button = Instance.new("TextButton", Frame)
	button.Size = UDim2.new(1, -20, 0, 40)
	button.Position = UDim2.new(0, 10, 0, 0)
	button.BackgroundColor3 = color
	button.TextColor3 = Color3.new(1, 1, 1)
	button.Font = Enum.Font.GothamBold
	button.TextSize = 14
	button.Text = text
	Instance.new("UICorner", button).CornerRadius = UDim.new(0, 8)
	return button
end

-- SPEED BUTTON
local speedOn = false
local speedBtn = createButton("Velocidade: OFF", Color3.fromRGB(200, 0, 0))
speedBtn.MouseButton1Click:Connect(function()
	speedOn = not speedOn
	speedBtn.Text = "Velocidade: " .. (speedOn and "ON" or "OFF")
	speedBtn.BackgroundColor3 = speedOn and Color3.fromRGB(0, 200, 0) or Color3.fromRGB(200, 0, 0)
	LocalPlayer.Character.Humanoid.WalkSpeed = speedOn and 24 or 16 -- 16 é padrão, 24 = +90%
end)

-- ESP BUTTON
local espOn = false
local function clearESP()
	for _, v in ipairs(HighlightFolder:GetChildren()) do
		v:Destroy()
	end
end

local function applyESP()
	clearESP()
	for _, plr in ipairs(Players:GetPlayers()) do
		if plr ~= LocalPlayer and plr.Character and plr.Character:FindFirstChild("HumanoidRootPart") then
			local highlight = Instance.new("Highlight", HighlightFolder)
			highlight.Adornee = plr.Character
			highlight.FillColor = Color3.new(1, 0, 0)
			highlight.OutlineColor = Color3.new(0, 0, 0)
			highlight.FillTransparency = 0.5
		end
	end
end

local espBtn = createButton("ESP: OFF", Color3.fromRGB(200, 0, 0))
espBtn.MouseButton1Click:Connect(function()
	espOn = not espOn
	espBtn.Text = "ESP: " .. (espOn and "ON" or "OFF")
	espBtn.BackgroundColor3 = espOn and Color3.fromRGB(0, 200, 0) or Color3.fromRGB(200, 0, 0)
	if espOn then
		applyESP()
	else
		clearESP()
	end
end)

-- JUMP AIR BUTTON
local airJumpOn = false
local jumping = false
local airBtn = createButton("Pulo no Ar: OFF", Color3.fromRGB(200, 0, 0))

UIS.JumpRequest:Connect(function()
	if airJumpOn and LocalPlayer.Character and LocalPlayer.Character:FindFirstChild("Humanoid") then
		if not jumping then
			jumping = true
			task.wait(0.05)
			LocalPlayer.Character:FindFirstChildOfClass("Humanoid"):ChangeState(Enum.HumanoidStateType.Jumping)
			jumping = false
		end
	end
end)

airBtn.MouseButton1Click:Connect(function()
	airJumpOn = not airJumpOn
	airBtn.Text = "Pulo no Ar: " .. (airJumpOn and "ON" or "OFF")
	airBtn.BackgroundColor3 = airJumpOn and Color3.fromRGB(0, 200, 0) or Color3.fromRGB(200, 0, 0)
end)
