-- Gui principal
local ScreenGui = Instance.new("ScreenGui", game.CoreGui)
ScreenGui.Name = "MeuHub"

local Frame = Instance.new("Frame", ScreenGui)
Frame.Size = UDim2.new(0, 200, 0, 150)
Frame.Position = UDim2.new(0, 20, 0.5, -75)
Frame.BackgroundColor3 = Color3.fromRGB(30, 30, 30)
Frame.BorderSizePixel = 0
Frame.Active = true
Frame.Draggable = true

local Title = Instance.new("TextLabel", Frame)
Title.Size = UDim2.new(1, 0, 0, 30)
Title.Text = "Meu Hub"
Title.TextColor3 = Color3.fromRGB(255, 255, 255)
Title.BackgroundColor3 = Color3.fromRGB(45, 45, 45)
Title.Font = Enum.Font.SourceSansBold
Title.TextSize = 20

-- Botão de Velocidade
local speedBtn = Instance.new("TextButton", Frame)
speedBtn.Size = UDim2.new(1, -20, 0, 40)
speedBtn.Position = UDim2.new(0, 10, 0, 40)
speedBtn.Text = "Velocidade: OFF"
speedBtn.Font = Enum.Font.SourceSans
speedBtn.TextSize = 16
speedBtn.BackgroundColor3 = Color3.fromRGB(200, 50, 50)
speedBtn.TextColor3 = Color3.new(1, 1, 1)

local speedAtivo = false
local player = game.Players.LocalPlayer

speedBtn.MouseButton1Click:Connect(function()
	speedAtivo = not speedAtivo
	if speedAtivo then
		player.Character.Humanoid.WalkSpeed = 24 -- 16 padrão * 1.5 = 24
		speedBtn.Text = "Velocidade: ON"
		speedBtn.BackgroundColor3 = Color3.fromRGB(50, 200, 50)
	else
		player.Character.Humanoid.WalkSpeed = 16
		speedBtn.Text = "Velocidade: OFF"
		speedBtn.BackgroundColor3 = Color3.fromRGB(200, 50, 50)
	end
end)

-- Botão de ESP
local espBtn = Instance.new("TextButton", Frame)
espBtn.Size = UDim2.new(1, -20, 0, 40)
espBtn.Position = UDim2.new(0, 10, 0, 90)
espBtn.Text = "ESP: OFF"
espBtn.Font = Enum.Font.SourceSans
espBtn.TextSize = 16
espBtn.BackgroundColor3 = Color3.fromRGB(200, 50, 50)
espBtn.TextColor3 = Color3.new(1, 1, 1)

local espAtivo = false
local highlights = {}

espBtn.MouseButton1Click:Connect(function()
	espAtivo = not espAtivo
	espBtn.Text = espAtivo and "ESP: ON" or "ESP: OFF"
	espBtn.BackgroundColor3 = espAtivo and Color3.fromRGB(50, 200, 50) or Color3.fromRGB(200, 50, 50)

	if espAtivo then
		for _, plr in pairs(game.Players:GetPlayers()) do
			if plr ~= player and plr.Character then
				local hl = Instance.new("Highlight", plr.Character)
				hl.FillColor = Color3.fromRGB(255, 0, 0)
				hl.OutlineColor = Color3.fromRGB(255, 0, 0)
				highlights[plr] = hl
			end
		end

		game.Players.PlayerAdded:Connect(function(plr)
			plr.CharacterAdded:Connect(function(char)
				wait(1)
				if espAtivo then
					local hl = Instance.new("Highlight", char)
					hl.FillColor = Color3.fromRGB(255, 0, 0)
					hl.OutlineColor = Color3.fromRGB(255, 0, 0)
					highlights[plr] = hl
				end
			end)
		end)

	else
		for _, hl in pairs(highlights) do
			if hl then
				hl:Destroy()
			end
		end
		highlights = {}
	end
end)
