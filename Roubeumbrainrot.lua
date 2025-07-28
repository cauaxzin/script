-- Meu Hub
local player = game.Players.LocalPlayer
local char = player.Character or player.CharacterAdded:Wait()
local humanoid = char:WaitForChild("Humanoid")
local hrp = char:WaitForChild("HumanoidRootPart")

-- GUI Setup
local ScreenGui = Instance.new("ScreenGui", game.CoreGui)
local Frame = Instance.new("Frame", ScreenGui)
Frame.Size = UDim2.new(0, 200, 0, 250)
Frame.Position = UDim2.new(0, 20, 0, 100)
Frame.BackgroundColor3 = Color3.fromRGB(40, 40, 40)
Frame.BackgroundTransparency = 0.2
Frame.Active = true
Frame.Draggable = true

local function createButton(text, yPos, callback)
	local btn = Instance.new("TextButton", Frame)
	btn.Size = UDim2.new(0, 180, 0, 30)
	btn.Position = UDim2.new(0, 10, 0, yPos)
	btn.Text = text
	btn.BackgroundColor3 = Color3.fromRGB(80, 80, 80)
	btn.TextColor3 = Color3.new(1, 1, 1)
	btn.Font = Enum.Font.Gotham
	btn.TextSize = 14
	btn.MouseButton1Click:Connect(callback)
	return btn
end

-- Velocidade
local speedOn = false
createButton("🏃 Velocidade: OFF", 10, function(btn)
	speedOn = not speedOn
	btn.Text = speedOn and "🏃 Velocidade: ON" or "🏃 Velocidade: OFF"
	humanoid.WalkSpeed = speedOn and 24 or 16 -- 16 padrão, 90% extra é 30.4, mas 24 é mais balanceado
end)

-- Jump Air (pular no ar)
local jumpAirOn = false
createButton("🛸 Pular no Ar: OFF", 50, function(btn)
	jumpAirOn = not jumpAirOn
	btn.Text = jumpAirOn and "🛸 Pular no Ar: ON" or "🛸 Pular no Ar: OFF"
end)

game:GetService("UserInputService").JumpRequest:Connect(function()
	if jumpAirOn and humanoid:GetState() ~= Enum.HumanoidStateType.Freefall then
		hrp.Velocity = Vector3.new(hrp.Velocity.X, 60, hrp.Velocity.Z)
	end
end)

-- ESP (Highlight vermelho)
local espOn = false
createButton("👁️ ESP: OFF", 90, function(btn)
	espOn = not espOn
	btn.Text = espOn and "👁️ ESP: ON" or "👁️ ESP: OFF"
	for _, plr in pairs(game.Players:GetPlayers()) do
		if plr ~= player and plr.Character then
			local highlight = plr.Character:FindFirstChildOfClass("Highlight")
			if espOn and not highlight then
				local esp = Instance.new("Highlight", plr.Character)
				esp.FillColor = Color3.fromRGB(255, 0, 0)
				esp.OutlineColor = Color3.new(1, 1, 1)
				esp.FillTransparency = 0.5
			elseif not espOn and highlight then
				highlight:Destroy()
			end
		end
	end
end)

-- Atravessar paredes (sem atravessar chão)
local noclipOn = false
createButton("🧱 Atravessar Paredes: OFF", 130, function(btn)
	noclipOn = not noclipOn
	btn.Text = noclipOn and "🧱 Atravessar Paredes: ON" or "🧱 Atravessar Paredes: OFF"

	game:GetService("RunService").Stepped:Connect(function()
		if noclipOn then
			for _, part in pairs(char:GetDescendants()) do
				if part:IsA("BasePart") and part.Name ~= "HumanoidRootPart" then
					part.CanCollide = true
				end
			end

			local rayOrigin = hrp.Position
			local rayDirection = hrp.CFrame.LookVector * 3
			local raycast = workspace:Raycast(rayOrigin, rayDirection, RaycastParams.new())
			if raycast and raycast.Instance and raycast.Normal.Y < 0.5 then
				hrp.CanCollide = false
			else
				hrp.CanCollide = true
			end
		else
			hrp.CanCollide = true
		end
	end)
end)
