local Players=game:GetService("Players")
local TweenService=game:GetService("TweenService")
local UIS=game:GetService("UserInputService")
local CoreGui=game:GetService("CoreGui")
local RunService=game:GetService("RunService")
local WS=game:GetService("Workspace")
local RS=game:GetService("ReplicatedStorage")
local TS=game:GetService("TeleportService")
local HS=game:GetService("HttpService")
local Lighting=game:GetService("Lighting")
local lp=Players.LocalPlayer
local cam=WS.CurrentCamera
local mouse=lp:GetMouse()

pcall(function() if CoreGui:FindFirstChild("AvocatHub") then CoreGui:FindFirstChild("AvocatHub"):Destroy() end end)
pcall(function() settings().Physics.AllowSleep=false end)
pcall(function() settings().Physics.PhysicsEnvironmentalThrottle=Enum.EnviromentalPhysicsThrottle.Disabled end)

local SKEY="AvocatHubCFG"
local DEF={toggleKey="RightShift",flyKey="F5",noclipKey="N",freecamKey="F6",godKey="G",espKey="",touchFlingKey="T",flingAllKey="",infJumpKey="",antiVoidKey="",fullbrightKey="",noFogKey="",antiAfkKey="",antiSlowKey="",autoload=false}
local function loadCFG() local s pcall(function() if readfile then s=HS:JSONDecode(readfile(SKEY..".json")) end end) if not s then s={} end for k,v in pairs(DEF) do if s[k]==nil then s[k]=v end end return s end
local function saveCFG(s) pcall(function() if writefile then writefile(SKEY..".json",HS:JSONEncode(s)) end end) end
local CFG=loadCFG()

local gui=Instance.new("ScreenGui") gui.Name="AvocatHub" gui.ZIndexBehavior=Enum.ZIndexBehavior.Sibling gui.ResetOnSpawn=false
gui.Parent=lp:WaitForChild("PlayerGui")

local C={Bg=Color3.fromRGB(10,10,10),Bg2=Color3.fromRGB(18,18,18),Bg3=Color3.fromRGB(28,28,28),Ac=Color3.fromRGB(48,48,48),AcH=Color3.fromRGB(62,62,62),AcL=Color3.fromRGB(35,35,35),W=Color3.fromRGB(255,255,255),D=Color3.fromRGB(130,130,130),R=Color3.fromRGB(160,35,35),RH=Color3.fromRGB(200,50,50)}

local AIM={on=false,fov=150,showFov=true,smooth=false,smoothV=0.15,pred=false,predV=0.165,team=false,wall=false,tgtP=true,tgtN=false}
local FC
pcall(function() FC=Drawing.new("Circle") FC.Radius=150 FC.Color=C.W FC.Thickness=1.5 FC.Filled=false FC.Visible=false end)
local RP_AIM=RaycastParams.new() RP_AIM.FilterType=Enum.RaycastFilterType.Exclude
local function LOS(o,t) RP_AIM.FilterDescendantsInstances={lp.Character or {}} local r=WS:Raycast(o,t-o,RP_AIM) return not r or r.Distance>=(t-o).Magnitude*0.95 end

local function gc() return lp.Character end
local function ghrp() local c=gc() return c and c:FindFirstChild("HumanoidRootPart") end
local function ghum() local c=gc() return c and c:FindFirstChildOfClass("Humanoid") end
local function rc(p,r) Instance.new("UICorner",p).CornerRadius=UDim.new(0,r or 6) end
local function mkb(p,t,col) local b=Instance.new("TextButton") b.BackgroundColor3=col or C.Ac b.BorderSizePixel=0 b.Size=UDim2.new(1,0,0,28) b.Font=Enum.Font.Gotham b.TextColor3=C.W b.TextSize=11 b.AutoButtonColor=false b.Text=t b.Parent=p rc(b) return b end
local function hfx(b,ba,ho) b.MouseEnter:Connect(function() TweenService:Create(b,TweenInfo.new(0.08),{BackgroundColor3=ho}):Play() end) b.MouseLeave:Connect(function() TweenService:Create(b,TweenInfo.new(0.08),{BackgroundColor3=ba}):Play() end) end
local function sep(p,o) local s=Instance.new("Frame") s.Parent=p s.BackgroundColor3=C.Ac s.BorderSizePixel=0 s.Size=UDim2.new(1,0,0,1) s.LayoutOrder=o end
local function lbl(p,t,o) local l=Instance.new("TextLabel") l.Parent=p l.BackgroundTransparency=1 l.Size=UDim2.new(1,0,0,18) l.Font=Enum.Font.GothamBold l.TextColor3=C.D l.TextSize=10 l.TextXAlignment=Enum.TextXAlignment.Left l.Text="  "..t l.LayoutOrder=o end
local function mscr(p,pos,sz) local sf=Instance.new("ScrollingFrame") sf.Parent=p sf.Active=true sf.BackgroundColor3=C.Bg2 sf.BorderSizePixel=0 sf.Position=pos sf.Size=sz sf.ScrollBarThickness=3 sf.ScrollBarImageColor3=C.Ac sf.CanvasSize=UDim2.new(0,0,0,0) rc(sf,8) local pd=Instance.new("UIPadding",sf) pd.PaddingTop=UDim.new(0,4) pd.PaddingBottom=UDim.new(0,4) pd.PaddingLeft=UDim.new(0,4) pd.PaddingRight=UDim.new(0,4) local l=Instance.new("UIListLayout",sf) l.SortOrder=Enum.SortOrder.LayoutOrder l.Padding=UDim.new(0,2) l:GetPropertyChangedSignal("AbsoluteContentSize"):Connect(function() sf.CanvasSize=UDim2.new(0,0,0,l.AbsoluteContentSize.Y+8) end) return sf end

local sliders={}
local function mkSlider(p,name,mn,mx,def,o) local f=Instance.new("Frame") f.Parent=p f.BackgroundColor3=C.Bg f.BorderSizePixel=0 f.Size=UDim2.new(1,0,0,34) f.LayoutOrder=o rc(f) local lb=Instance.new("TextLabel",f) lb.BackgroundTransparency=1 lb.Position=UDim2.new(0,8,0,0) lb.Size=UDim2.new(1,-16,0,16) lb.Font=Enum.Font.Gotham lb.TextColor3=C.D lb.TextSize=10 lb.TextXAlignment=Enum.TextXAlignment.Left lb.Text=name..": "..def local bg=Instance.new("Frame",f) bg.BackgroundColor3=C.Bg2 bg.BorderSizePixel=0 bg.Position=UDim2.new(0,8,0,19) bg.Size=UDim2.new(1,-16,0,10) rc(bg,4) local fl=Instance.new("Frame",bg) fl.BackgroundColor3=C.Ac fl.BorderSizePixel=0 fl.Size=UDim2.new(math.clamp((def-mn)/(mx-mn),0,1),0,1,0) rc(fl,4) local s={bg=bg,fill=fl,label=lb,name=name,min=mn,max=mx,val=def,dragging=false,cb=nil} bg.InputBegan:Connect(function(i) if i.UserInputType==Enum.UserInputType.MouseButton1 or i.UserInputType==Enum.UserInputType.Touch then s.dragging=true end end) table.insert(sliders,s) return s end

local allToggles={}
local function mkToggle(p,name,o,cfgK) local f=Instance.new("Frame") f.Parent=p f.BackgroundColor3=C.Bg f.BorderSizePixel=0 f.Size=UDim2.new(1,0,0,26) f.LayoutOrder=o rc(f) local lb=Instance.new("TextLabel",f) lb.BackgroundTransparency=1 lb.Position=UDim2.new(0,8,0,0) lb.Size=UDim2.new(1,-100,1,0) lb.Font=Enum.Font.Gotham lb.TextColor3=C.W lb.TextSize=11 lb.TextXAlignment=Enum.TextXAlignment.Left lb.Text=name local kl=Instance.new("TextLabel",f) kl.BackgroundTransparency=1 kl.Position=UDim2.new(1,-96,0,0) kl.Size=UDim2.new(0,46,1,0) kl.Font=Enum.Font.Gotham kl.TextColor3=C.D kl.TextSize=8 kl.TextXAlignment=Enum.TextXAlignment.Right local ks=cfgK and CFG[cfgK] or "" kl.Text=ks~="" and "["..ks.."]" or "" local b=Instance.new("TextButton",f) b.BackgroundColor3=C.Bg2 b.BorderSizePixel=0 b.Position=UDim2.new(1,-44,0,3) b.Size=UDim2.new(0,36,0,20) b.Font=Enum.Font.GothamBold b.TextColor3=C.D b.TextSize=9 b.Text="OFF" b.AutoButtonColor=false rc(b,4) local st=false local cb=nil local function tog() st=not st b.Text=st and "ON" or "OFF" TweenService:Create(b,TweenInfo.new(0.12),{BackgroundColor3=st and C.Ac or C.Bg2}):Play() b.TextColor3=st and C.W or C.D if cb then cb(st) end end b.MouseButton1Click:Connect(tog) local obj={set=function(s) if s~=st then tog() end end,get=function() return st end,on=function(c) cb=c end,toggle=tog,cfgKey=cfgK,updateKeyLabel=function() local k=cfgK and CFG[cfgK] or "" kl.Text=k~="" and "["..k.."]" or "" end} table.insert(allToggles,obj) return obj end

local Main=Instance.new("Frame") Main.Parent=gui Main.Active=true Main.BackgroundColor3=C.Bg Main.BorderSizePixel=0 Main.AnchorPoint=Vector2.new(0.5,0.5) Main.Position=UDim2.new(0.5,0,0.5,0) Main.Size=UDim2.new(0,0,0,0) Main.ClipsDescendants=true rc(Main,10) Instance.new("UIStroke",Main).Color=C.Ac
TweenService:Create(Main,TweenInfo.new(0.4,Enum.EasingStyle.Back),{Size=UDim2.new(0,380,0,470)}):Play() task.wait(0.3)
local Top=Instance.new("Frame") Top.Parent=Main Top.BackgroundColor3=C.Bg2 Top.BorderSizePixel=0 Top.Size=UDim2.new(1,0,0,30) rc(Top,10)
local ttl=Instance.new("TextLabel",Top) ttl.BackgroundTransparency=1 ttl.Position=UDim2.new(0,10,0,0) ttl.Size=UDim2.new(0.6,0,1,0) ttl.Font=Enum.Font.GothamBold ttl.Text="⬡ Avocat Hub" ttl.TextColor3=C.W ttl.TextSize=13 ttl.TextXAlignment=Enum.TextXAlignment.Left
local xB=Instance.new("TextButton",Top) xB.BackgroundColor3=C.Bg2 xB.BorderSizePixel=0 xB.Position=UDim2.new(1,-28,0,0) xB.Size=UDim2.new(0,28,0,30) xB.Font=Enum.Font.GothamBold xB.Text="X" xB.TextColor3=C.D xB.TextSize=11 xB.AutoButtonColor=false rc(xB,6) xB.MouseButton1Click:Connect(function() TweenService:Create(Main,TweenInfo.new(0.3,Enum.EasingStyle.Back,Enum.EasingDirection.In),{Size=UDim2.new(0,0,0,0)}):Play() task.wait(0.35) gui:Destroy() end) hfx(xB,C.Bg2,C.R)
local mBt=Instance.new("TextButton",Top) mBt.BackgroundColor3=C.Bg2 mBt.BorderSizePixel=0 mBt.Position=UDim2.new(1,-52,0,0) mBt.Size=UDim2.new(0,24,0,30) mBt.Font=Enum.Font.GothamBold mBt.Text="-" mBt.TextColor3=C.D mBt.TextSize=14 mBt.AutoButtonColor=false
local mni=false mBt.MouseButton1Click:Connect(function() mni=not mni TweenService:Create(Main,TweenInfo.new(0.15),{Size=mni and UDim2.new(0,380,0,30) or UDim2.new(0,380,0,470)}):Play() mBt.Text=mni and "+" or "-" end)
local tabN={"Move","Combat","Players","Tools","Ext","Config"}
local tbs,pgs={},{}
local tabF=Instance.new("Frame",Main) tabF.BackgroundTransparency=1 tabF.Position=UDim2.new(0,4,0,33) tabF.Size=UDim2.new(1,-8,0,22)
for i,n in ipairs(tabN) do local t=Instance.new("TextButton",tabF) t.BackgroundColor3=i==1 and C.Ac or C.Bg2 t.BorderSizePixel=0 t.Position=UDim2.new((i-1)/#tabN,1,0,0) t.Size=UDim2.new(1/#tabN,-2,1,0) t.Font=Enum.Font.GothamBold t.Text=n t.TextColor3=i==1 and C.W or C.D t.TextSize=9 t.AutoButtonColor=false rc(t) tbs[n]=t end
local function stab(name) for n,t in pairs(tbs) do local s=n==name TweenService:Create(t,TweenInfo.new(0.12),{BackgroundColor3=s and C.Ac or C.Bg2}):Play() t.TextColor3=s and C.W or C.D end for n,p in pairs(pgs) do p.Visible=n==name end end
for n,t in pairs(tbs) do t.MouseButton1Click:Connect(function() stab(n) end) end
local cY=58
local drag,ds,dp=false,nil,nil
Top.InputBegan:Connect(function(i) if i.UserInputType==Enum.UserInputType.MouseButton1 or i.UserInputType==Enum.UserInputType.Touch then drag=true ds=i.Position dp=Main.Position i.Changed:Connect(function() if i.UserInputState==Enum.UserInputState.End then drag=false end end) end end)
UIS.InputChanged:Connect(function(i) if drag and(i.UserInputType==Enum.UserInputType.MouseMovement or i.UserInputType==Enum.UserInputType.Touch)then local d=i.Position-ds Main.Position=UDim2.new(dp.X.Scale,dp.X.Offset+d.X,dp.Y.Scale,dp.Y.Offset+d.Y) end end)

-- MOVE TAB
local mvP=Instance.new("Frame",Main) mvP.BackgroundTransparency=1 mvP.Position=UDim2.new(0,0,0,cY) mvP.Size=UDim2.new(1,0,1,-cY) mvP.Visible=true pgs["Move"]=mvP
local mvS=mscr(mvP,UDim2.new(0,4,0,0),UDim2.new(1,-8,1,-4))
lbl(mvS,"MOVEMENT",1) local tFly=mkToggle(mvS,"Fly",2,"flyKey") local sFlySpd=mkSlider(mvS,"Fly Speed",10,300,80,3) local tNoclip=mkToggle(mvS,"Noclip",4,"noclipKey") local tInfJ=mkToggle(mvS,"Infinite Jump",5,"infJumpKey") local sSpd=mkSlider(mvS,"WalkSpeed",16,500,16,6) local tSpin=mkToggle(mvS,"Spin",7) local sSpinSpd=mkSlider(mvS,"Spin Speed",1,100,20,8)
sep(mvS,9) lbl(mvS,"CAMERA",10) local tFreecam=mkToggle(mvS,"Freecam",11,"freecamKey") local sFov=mkSlider(mvS,"FOV",70,120,70,12)
sep(mvS,13) lbl(mvS,"TELEPORT",14)
local tpFrame=Instance.new("Frame",mvS) tpFrame.BackgroundColor3=C.Bg tpFrame.BorderSizePixel=0 tpFrame.Size=UDim2.new(1,0,0,56) tpFrame.LayoutOrder=15 rc(tpFrame)
local tpPad=Instance.new("UIPadding",tpFrame) tpPad.PaddingLeft=UDim.new(0,6) tpPad.PaddingRight=UDim.new(0,6) tpPad.PaddingTop=UDim.new(0,4)
local tpLbl=Instance.new("TextLabel",tpFrame) tpLbl.BackgroundTransparency=1 tpLbl.Size=UDim2.new(1,0,0,14) tpLbl.Font=Enum.Font.Gotham tpLbl.TextColor3=C.D tpLbl.TextSize=9 tpLbl.TextXAlignment=Enum.TextXAlignment.Left tpLbl.Text="Coordonnees X Y Z"
local tpX=Instance.new("TextBox",tpFrame) tpX.BackgroundColor3=C.Bg2 tpX.BorderSizePixel=0 tpX.Position=UDim2.new(0,0,0,18) tpX.Size=UDim2.new(0.25,-4,0,26) tpX.Font=Enum.Font.Gotham tpX.PlaceholderText="X" tpX.PlaceholderColor3=C.D tpX.Text="" tpX.TextColor3=C.W tpX.TextSize=11 rc(tpX,4)
local tpY=Instance.new("TextBox",tpFrame) tpY.BackgroundColor3=C.Bg2 tpY.BorderSizePixel=0 tpY.Position=UDim2.new(0.25,2,0,18) tpY.Size=UDim2.new(0.25,-4,0,26) tpY.Font=Enum.Font.Gotham tpY.PlaceholderText="Y" tpY.PlaceholderColor3=C.D tpY.Text="" tpY.TextColor3=C.W tpY.TextSize=11 rc(tpY,4)
local tpZ=Instance.new("TextBox",tpFrame) tpZ.BackgroundColor3=C.Bg2 tpZ.BorderSizePixel=0 tpZ.Position=UDim2.new(0.5,2,0,18) tpZ.Size=UDim2.new(0.25,-4,0,26) tpZ.Font=Enum.Font.Gotham tpZ.PlaceholderText="Z" tpZ.PlaceholderColor3=C.D tpZ.Text="" tpZ.TextColor3=C.W tpZ.TextSize=11 rc(tpZ,4)
local tpGo=Instance.new("TextButton",tpFrame) tpGo.BackgroundColor3=C.Ac tpGo.BorderSizePixel=0 tpGo.Position=UDim2.new(0.75,2,0,18) tpGo.Size=UDim2.new(0.25,-2,0,26) tpGo.Font=Enum.Font.GothamBold tpGo.Text="TP" tpGo.TextColor3=C.W tpGo.TextSize=11 tpGo.AutoButtonColor=false rc(tpGo,4) hfx(tpGo,C.Ac,C.AcH)
tpGo.MouseButton1Click:Connect(function() pcall(function() local hrp=ghrp() if hrp then hrp.CFrame=CFrame.new(tonumber(tpX.Text)or 0,tonumber(tpY.Text)or 0,tonumber(tpZ.Text)or 0) end end) end)
local tpCopy=mkb(mvS,"Copier ma position",C.Bg) tpCopy.LayoutOrder=16 tpCopy.Font=Enum.Font.Gotham tpCopy.TextSize=10 hfx(tpCopy,C.Bg,C.Ac)
tpCopy.MouseButton1Click:Connect(function() pcall(function() local hrp=ghrp() if hrp then local p=hrp.Position tpX.Text=tostring(math.floor(p.X)) tpY.Text=tostring(math.floor(p.Y)) tpZ.Text=tostring(math.floor(p.Z)) pcall(function() if setclipboard then setclipboard(math.floor(p.X)..","..math.floor(p.Y)..","..math.floor(p.Z)) end end) end end) end)

-- COMBAT TAB
local cbP=Instance.new("Frame",Main) cbP.BackgroundTransparency=1 cbP.Position=UDim2.new(0,0,0,cY) cbP.Size=UDim2.new(1,0,1,-cY) cbP.Visible=false pgs["Combat"]=cbP
local cbS=mscr(cbP,UDim2.new(0,4,0,0),UDim2.new(1,-8,1,-4))
lbl(cbS,"DEFENSE",1) local tGod=mkToggle(cbS,"God Mode",2,"godKey") local tAntiVoid=mkToggle(cbS,"Anti Void",3,"antiVoidKey")
sep(cbS,4) lbl(cbS,"HITBOX",5) local tHitbox=mkToggle(cbS,"Hitbox Expander",6) local sHitbox=mkSlider(cbS,"Hitbox Size",1,20,5,7)
sep(cbS,8) lbl(cbS,"AIM & CLICK",9)
local aimOpenBtn=mkb(cbS,"Aimbot Settings",C.Bg) aimOpenBtn.LayoutOrder=10 aimOpenBtn.Font=Enum.Font.GothamBold hfx(aimOpenBtn,C.Bg,C.Ac)
local clickOpenBtn=mkb(cbS,"AutoClick Settings",C.Bg) clickOpenBtn.LayoutOrder=11 clickOpenBtn.Font=Enum.Font.GothamBold hfx(clickOpenBtn,C.Bg,C.Ac)
sep(cbS,12) lbl(cbS,"VISUALS",13) local tESP=mkToggle(cbS,"ESP",14,"espKey") local tFullbright=mkToggle(cbS,"Fullbright",15,"fullbrightKey") local tNoFog=mkToggle(cbS,"No Fog",16,"noFogKey")
sep(cbS,17) lbl(cbS,"AC BYPASS",18) local tAdonis=mkToggle(cbS,"AC Bypass",19)
sep(cbS,20) lbl(cbS,"MISC",21) local tAntiAfk=mkToggle(cbS,"Anti AFK",22,"antiAfkKey") local tAntiSlow=mkToggle(cbS,"Anti Slowdown",23,"antiSlowKey")

-- AIMBOT PANEL
local aimPanel=Instance.new("Frame") aimPanel.Parent=gui aimPanel.BackgroundColor3=C.Bg aimPanel.BorderSizePixel=0 aimPanel.AnchorPoint=Vector2.new(0.5,0.5) aimPanel.Position=UDim2.new(0.5,200,0.5,-60) aimPanel.Size=UDim2.new(0,0,0,0) aimPanel.ClipsDescendants=true aimPanel.Visible=false aimPanel.Active=true rc(aimPanel,10) Instance.new("UIStroke",aimPanel).Color=C.Ac
local aimTop=Instance.new("Frame",aimPanel) aimTop.BackgroundColor3=C.Bg2 aimTop.BorderSizePixel=0 aimTop.Size=UDim2.new(1,0,0,28) rc(aimTop,10)
local aimTtl=Instance.new("TextLabel",aimTop) aimTtl.BackgroundTransparency=1 aimTtl.Position=UDim2.new(0,10,0,0) aimTtl.Size=UDim2.new(1,-40,1,0) aimTtl.Font=Enum.Font.GothamBold aimTtl.Text="Aimbot Settings" aimTtl.TextColor3=C.W aimTtl.TextSize=11 aimTtl.TextXAlignment=Enum.TextXAlignment.Left
local aimX=Instance.new("TextButton",aimTop) aimX.BackgroundColor3=C.Bg2 aimX.BorderSizePixel=0 aimX.Position=UDim2.new(1,-26,0,0) aimX.Size=UDim2.new(0,26,0,28) aimX.Font=Enum.Font.GothamBold aimX.Text="X" aimX.TextColor3=C.D aimX.TextSize=10 aimX.AutoButtonColor=false rc(aimX,6) hfx(aimX,C.Bg2,C.R)
local aimScr=mscr(aimPanel,UDim2.new(0,4,0,32),UDim2.new(1,-8,1,-36))
local tAimbot=mkToggle(aimScr,"Aimbot",1) local tShowFov=mkToggle(aimScr,"Show FOV Circle",2) local tAimSmooth=mkToggle(aimScr,"Smoothing",3) local tAimPred=mkToggle(aimScr,"Prediction",4) local tAimTeam=mkToggle(aimScr,"Team Check",5) local tAimWall=mkToggle(aimScr,"Wall Check",6)
sep(aimScr,7) lbl(aimScr,"TARGETING",8) local tTgtPlayers=mkToggle(aimScr,"Target Players",9) local tTgtNPCs=mkToggle(aimScr,"Target NPCs",10)
sep(aimScr,11) lbl(aimScr,"VALUES",12)
local sAimFov=mkSlider(aimScr,"FOV",10,800,150,13) local sAimSmooth=mkSlider(aimScr,"Smoothing",1,100,15,14) local sAimPred=mkSlider(aimScr,"Prediction",1,100,16,15)
local aimInfo=Instance.new("TextLabel",aimScr) aimInfo.BackgroundColor3=C.Bg aimInfo.Size=UDim2.new(1,0,0,20) aimInfo.LayoutOrder=16 aimInfo.Font=Enum.Font.Gotham aimInfo.TextColor3=C.D aimInfo.TextSize=9 aimInfo.Text="  Clic droit = viser tete la plus proche" aimInfo.TextXAlignment=Enum.TextXAlignment.Left rc(aimInfo)
tTgtPlayers.set(true)
tAimbot.on(function(s) AIM.on=s if FC then pcall(function() FC.Visible=AIM.showFov and s end) end end)
tShowFov.on(function(s) AIM.showFov=s if FC then pcall(function() FC.Visible=s and AIM.on end) end end)
tAimSmooth.on(function(s) AIM.smooth=s end) tAimPred.on(function(s) AIM.pred=s end) tAimTeam.on(function(s) AIM.team=s end) tAimWall.on(function(s) AIM.wall=s end) tTgtPlayers.on(function(s) AIM.tgtP=s end) tTgtNPCs.on(function(s) AIM.tgtN=s end)
sAimFov.cb=function(v) AIM.fov=v if FC then pcall(function() FC.Radius=v end) end end
sAimSmooth.cb=function(v) AIM.smoothV=v/100 end sAimPred.cb=function(v) AIM.predV=v/100 end
local aimPO=false
local function toggleAim() aimPO=not aimPO if aimPO then aimPanel.Visible=true TweenService:Create(aimPanel,TweenInfo.new(0.3,Enum.EasingStyle.Back),{Size=UDim2.new(0,260,0,420)}):Play() else TweenService:Create(aimPanel,TweenInfo.new(0.2,Enum.EasingStyle.Back,Enum.EasingDirection.In),{Size=UDim2.new(0,0,0,0)}):Play() task.wait(0.25) aimPanel.Visible=false end end
aimOpenBtn.MouseButton1Click:Connect(toggleAim) aimX.MouseButton1Click:Connect(toggleAim)
local aimDr,aimDS,aimDP=false,nil,nil
aimTop.InputBegan:Connect(function(i) if i.UserInputType==Enum.UserInputType.MouseButton1 or i.UserInputType==Enum.UserInputType.Touch then aimDr=true aimDS=i.Position aimDP=aimPanel.Position i.Changed:Connect(function() if i.UserInputState==Enum.UserInputState.End then aimDr=false end end) end end)
UIS.InputChanged:Connect(function(i) if aimDr and(i.UserInputType==Enum.UserInputType.MouseMovement or i.UserInputType==Enum.UserInputType.Touch)then local d=i.Position-aimDS aimPanel.Position=UDim2.new(aimDP.X.Scale,aimDP.X.Offset+d.X,aimDP.Y.Scale,aimDP.Y.Offset+d.Y) end end)

-- AUTOCLICK PANEL
local clickPanel=Instance.new("Frame") clickPanel.Parent=gui clickPanel.BackgroundColor3=C.Bg clickPanel.BorderSizePixel=0 clickPanel.AnchorPoint=Vector2.new(0.5,0.5) clickPanel.Position=UDim2.new(0.5,200,0.5,120) clickPanel.Size=UDim2.new(0,0,0,0) clickPanel.ClipsDescendants=true clickPanel.Visible=false clickPanel.Active=true rc(clickPanel,10) Instance.new("UIStroke",clickPanel).Color=C.Ac
local clickTop=Instance.new("Frame",clickPanel) clickTop.BackgroundColor3=C.Bg2 clickTop.BorderSizePixel=0 clickTop.Size=UDim2.new(1,0,0,28) rc(clickTop,10)
local clickTtl=Instance.new("TextLabel",clickTop) clickTtl.BackgroundTransparency=1 clickTtl.Position=UDim2.new(0,10,0,0) clickTtl.Size=UDim2.new(1,-40,1,0) clickTtl.Font=Enum.Font.GothamBold clickTtl.Text="AutoClick Settings" clickTtl.TextColor3=C.W clickTtl.TextSize=11 clickTtl.TextXAlignment=Enum.TextXAlignment.Left
local clickXBtn=Instance.new("TextButton",clickTop) clickXBtn.BackgroundColor3=C.Bg2 clickXBtn.BorderSizePixel=0 clickXBtn.Position=UDim2.new(1,-26,0,0) clickXBtn.Size=UDim2.new(0,26,0,28) clickXBtn.Font=Enum.Font.GothamBold clickXBtn.Text="X" clickXBtn.TextColor3=C.D clickXBtn.TextSize=10 clickXBtn.AutoButtonColor=false rc(clickXBtn,6) hfx(clickXBtn,C.Bg2,C.R)
local clickScr=mscr(clickPanel,UDim2.new(0,4,0,32),UDim2.new(1,-8,1,-36))
local tAutoClick=mkToggle(clickScr,"Auto Click",1) local tClickHold=mkToggle(clickScr,"Hold Mode",2) local tClickRight=mkToggle(clickScr,"Clic Droit",3) local sClickSpd=mkSlider(clickScr,"Vitesse (CPS)",1,100,10,4) local sClickJitter=mkSlider(clickScr,"Jitter (%)",0,50,0,5)
sep(clickScr,6) lbl(clickScr,"INFO",7)
local clkI1=Instance.new("TextLabel",clickScr) clkI1.BackgroundColor3=C.Bg clkI1.Size=UDim2.new(1,0,0,20) clkI1.LayoutOrder=8 clkI1.Font=Enum.Font.Gotham clkI1.TextColor3=C.D clkI1.TextSize=9 clkI1.Text="  Auto = clic continu non stop" clkI1.TextXAlignment=Enum.TextXAlignment.Left rc(clkI1)
local clkI2=Instance.new("TextLabel",clickScr) clkI2.BackgroundColor3=C.Bg clkI2.Size=UDim2.new(1,0,0,20) clkI2.LayoutOrder=9 clkI2.Font=Enum.Font.Gotham clkI2.TextColor3=C.D clkI2.TextSize=9 clkI2.Text="  Hold = clic quand souris maintenue" clkI2.TextXAlignment=Enum.TextXAlignment.Left rc(clkI2)
local clkI3=Instance.new("TextLabel",clickScr) clkI3.BackgroundColor3=C.Bg clkI3.Size=UDim2.new(1,0,0,20) clkI3.LayoutOrder=10 clkI3.Font=Enum.Font.Gotham clkI3.TextColor3=C.D clkI3.TextSize=9 clkI3.Text="  CPS = clics par seconde" clkI3.TextXAlignment=Enum.TextXAlignment.Left rc(clkI3)
local clickPO=false
local function toggleClick() clickPO=not clickPO if clickPO then clickPanel.Visible=true TweenService:Create(clickPanel,TweenInfo.new(0.3,Enum.EasingStyle.Back),{Size=UDim2.new(0,260,0,310)}):Play() else TweenService:Create(clickPanel,TweenInfo.new(0.2,Enum.EasingStyle.Back,Enum.EasingDirection.In),{Size=UDim2.new(0,0,0,0)}):Play() task.wait(0.25) clickPanel.Visible=false end end
clickOpenBtn.MouseButton1Click:Connect(toggleClick) clickXBtn.MouseButton1Click:Connect(toggleClick)
local clickDr,clickDS,clickDP=false,nil,nil
clickTop.InputBegan:Connect(function(i) if i.UserInputType==Enum.UserInputType.MouseButton1 or i.UserInputType==Enum.UserInputType.Touch then clickDr=true clickDS=i.Position clickDP=clickPanel.Position i.Changed:Connect(function() if i.UserInputState==Enum.UserInputState.End then clickDr=false end end) end end)
UIS.InputChanged:Connect(function(i) if clickDr and(i.UserInputType==Enum.UserInputType.MouseMovement or i.UserInputType==Enum.UserInputType.Touch)then local d=i.Position-clickDS clickPanel.Position=UDim2.new(clickDP.X.Scale,clickDP.X.Offset+d.X,clickDP.Y.Scale,clickDP.Y.Offset+d.Y) end end)-- PLAYERS TAB
local selPlayer=nil
local jP=Instance.new("Frame",Main) jP.BackgroundTransparency=1 jP.Position=UDim2.new(0,0,0,cY) jP.Size=UDim2.new(1,0,1,-cY) jP.Visible=false pgs["Players"]=jP
local jSt=Instance.new("TextLabel",jP) jSt.BackgroundColor3=C.Bg2 jSt.BorderSizePixel=0 jSt.Position=UDim2.new(0,4,0,0) jSt.Size=UDim2.new(1,-8,0,20) jSt.Font=Enum.Font.GothamBold jSt.Text="Idle" jSt.TextColor3=C.D jSt.TextSize=10 rc(jSt)
local jBtnFrame=Instance.new("Frame",jP) jBtnFrame.BackgroundTransparency=1 jBtnFrame.Position=UDim2.new(0,4,0,24) jBtnFrame.Size=UDim2.new(1,-8,0,26)
local jBO={}
for i,n in ipairs({"Stop","Fling All","Touch","Unspec"}) do local key=n=="Fling All" and "All" or n local b=mkb(jBtnFrame,n,n=="Stop" and C.R or C.Ac) b.Position=UDim2.new((i-1)/4,1,0,0) b.Size=UDim2.new(1/4,-2,1,0) b.Font=Enum.Font.GothamBold b.TextSize=9 hfx(b,n=="Stop" and C.R or C.Ac,n=="Stop" and C.RH or C.AcH) jBO[key]=b end
jBO["Unspec"].MouseButton1Click:Connect(function() pcall(function() cam.CameraSubject=gc():FindFirstChildOfClass("Humanoid") end) selPlayer=nil jSt.Text="Idle" jSt.TextColor3=C.D end)
local jSearch=Instance.new("TextBox",jP) jSearch.BackgroundColor3=C.Bg2 jSearch.BorderSizePixel=0 jSearch.Position=UDim2.new(0,4,0,54) jSearch.Size=UDim2.new(1,-8,0,22) jSearch.Font=Enum.Font.Gotham jSearch.PlaceholderText="Rechercher joueur..." jSearch.PlaceholderColor3=C.D jSearch.Text="" jSearch.TextColor3=C.W jSearch.TextSize=10 jSearch.ClearTextOnFocus=false rc(jSearch)
local jScr=mscr(jP,UDim2.new(0,4,0,80),UDim2.new(1,-8,1,-116))
local jRef=mkb(jP,"Actualiser",C.Ac) jRef.Position=UDim2.new(0,4,1,-32) jRef.Size=UDim2.new(1,-8,0,28) jRef.Font=Enum.Font.GothamBold hfx(jRef,C.Ac,C.AcH)

-- TOOLS TAB
local oP=Instance.new("Frame",Main) oP.BackgroundTransparency=1 oP.Position=UDim2.new(0,0,0,cY) oP.Size=UDim2.new(1,0,1,-cY) oP.Visible=false pgs["Tools"]=oP
local oSr=Instance.new("TextBox",oP) oSr.BackgroundColor3=C.Bg2 oSr.BorderSizePixel=0 oSr.Position=UDim2.new(0,4,0,0) oSr.Size=UDim2.new(1,-8,0,24) oSr.Font=Enum.Font.Gotham oSr.PlaceholderText="Rechercher..." oSr.PlaceholderColor3=C.D oSr.Text="" oSr.TextColor3=C.W oSr.TextSize=11 oSr.ClearTextOnFocus=false rc(oSr)
local oScr=mscr(oP,UDim2.new(0,4,0,28),UDim2.new(1,-8,1,-64))
local oRf=mkb(oP,"Actualiser",C.Ac) oRf.Position=UDim2.new(0,4,1,-32) oRf.Size=UDim2.new(1,-8,0,28) oRf.Font=Enum.Font.GothamBold hfx(oRf,C.Ac,C.AcH)

-- EXT TAB
local extP=Instance.new("Frame",Main) extP.BackgroundTransparency=1 extP.Position=UDim2.new(0,0,0,cY) extP.Size=UDim2.new(1,0,1,-cY) extP.Visible=false pgs["Ext"]=extP
local extS=mscr(extP,UDim2.new(0,4,0,0),UDim2.new(1,-8,1,-4))
lbl(extS,"SCRIPTS",1)
local function extBtn(name,url,o) local b=mkb(extS,name,C.Bg) b.LayoutOrder=o b.Font=Enum.Font.GothamBold hfx(b,C.Bg,C.Ac) b.MouseButton1Click:Connect(function() b.Text="..." task.spawn(function() local ok=pcall(function() loadstring(game:HttpGet(url))() end) b.Text=ok and name.." [OK]" or name.." [FAIL]" task.wait(2) b.Text=name end) end) end
extBtn("Infinite Yield","https://raw.githubusercontent.com/EdgeIY/infiniteyield/master/source",2)
extBtn("Dex Explorer","https://raw.githubusercontent.com/peyton2465/Dex/master/out.lua",3)
sep(extS,4) lbl(extS,"CHARGER UN SCRIPT",5)
local extUrlF=Instance.new("Frame",extS) extUrlF.BackgroundColor3=C.Bg extUrlF.BorderSizePixel=0 extUrlF.Size=UDim2.new(1,0,0,34) extUrlF.LayoutOrder=6 rc(extUrlF) local extUP=Instance.new("UIPadding",extUrlF) extUP.PaddingLeft=UDim.new(0,4) extUP.PaddingRight=UDim.new(0,4) extUP.PaddingTop=UDim.new(0,4)
local extUrl=Instance.new("TextBox",extUrlF) extUrl.BackgroundColor3=C.Bg2 extUrl.BorderSizePixel=0 extUrl.Size=UDim2.new(0.75,-4,0,26) extUrl.Font=Enum.Font.Gotham extUrl.PlaceholderText="https://..." extUrl.PlaceholderColor3=C.D extUrl.Text="" extUrl.TextColor3=C.W extUrl.TextSize=10 extUrl.ClearTextOnFocus=false rc(extUrl,4)
local extRun=Instance.new("TextButton",extUrlF) extRun.BackgroundColor3=C.Ac extRun.BorderSizePixel=0 extRun.Position=UDim2.new(0.75,2,0,0) extRun.Size=UDim2.new(0.25,-2,0,26) extRun.Font=Enum.Font.GothamBold extRun.Text="Run" extRun.TextColor3=C.W extRun.TextSize=11 extRun.AutoButtonColor=false rc(extRun,4) hfx(extRun,C.Ac,C.AcH)
extRun.MouseButton1Click:Connect(function() local url=extUrl.Text if url=="" then return end extRun.Text="..." task.spawn(function() local ok=pcall(function() loadstring(game:HttpGet(url))() end) extRun.Text=ok and "OK" or "Fail" task.wait(2) extRun.Text="Run" end) end)
sep(extS,7) lbl(extS,"EXECUTER DU CODE",8)
local extCF=Instance.new("Frame",extS) extCF.BackgroundColor3=C.Bg extCF.BorderSizePixel=0 extCF.Size=UDim2.new(1,0,0,86) extCF.LayoutOrder=9 rc(extCF) local extCP=Instance.new("UIPadding",extCF) extCP.PaddingLeft=UDim.new(0,4) extCP.PaddingRight=UDim.new(0,4) extCP.PaddingTop=UDim.new(0,4)
local extCode=Instance.new("TextBox",extCF) extCode.BackgroundColor3=C.Bg2 extCode.BorderSizePixel=0 extCode.Size=UDim2.new(1,0,0,50) extCode.Font=Enum.Font.Code extCode.PlaceholderText="code..." extCode.PlaceholderColor3=C.D extCode.Text="" extCode.TextColor3=C.W extCode.TextSize=10 extCode.ClearTextOnFocus=false extCode.MultiLine=true extCode.TextWrapped=true extCode.TextYAlignment=Enum.TextYAlignment.Top rc(extCode,4)
local extExec=Instance.new("TextButton",extCF) extExec.BackgroundColor3=C.Ac extExec.BorderSizePixel=0 extExec.Position=UDim2.new(0,0,0,54) extExec.Size=UDim2.new(1,0,0,26) extExec.Font=Enum.Font.GothamBold extExec.Text="Executer" extExec.TextColor3=C.W extExec.TextSize=11 extExec.AutoButtonColor=false rc(extExec,4) hfx(extExec,C.Ac,C.AcH)
extExec.MouseButton1Click:Connect(function() local code=extCode.Text if code=="" then return end extExec.Text="..." task.spawn(function() local ok=pcall(function() loadstring(code)() end) extExec.Text=ok and "OK" or "Erreur" task.wait(2) extExec.Text="Executer" end) end)

-- CONFIG TAB
local cfP=Instance.new("Frame",Main) cfP.BackgroundTransparency=1 cfP.Position=UDim2.new(0,0,0,cY) cfP.Size=UDim2.new(1,0,1,-cY) cfP.Visible=false pgs["Config"]=cfP
local cfS=mscr(cfP,UDim2.new(0,4,0,0),UDim2.new(1,-8,1,-4))
lbl(cfS,"KEYBINDS (Backspace = None)",1)
local function mkKB(p,dn,ck,o) local f=Instance.new("Frame") f.Parent=p f.BackgroundColor3=C.Bg f.BorderSizePixel=0 f.Size=UDim2.new(1,0,0,26) f.LayoutOrder=o rc(f) local lb=Instance.new("TextLabel",f) lb.BackgroundTransparency=1 lb.Position=UDim2.new(0,8,0,0) lb.Size=UDim2.new(0.55,-8,1,0) lb.Font=Enum.Font.Gotham lb.TextColor3=C.W lb.TextSize=10 lb.TextXAlignment=Enum.TextXAlignment.Left lb.Text=dn local kb=Instance.new("TextButton",f) kb.BackgroundColor3=C.Bg2 kb.BorderSizePixel=0 kb.Position=UDim2.new(0.55,2,0,3) kb.Size=UDim2.new(0.45,-10,0,20) kb.Font=Enum.Font.GothamBold kb.TextColor3=C.D kb.TextSize=9 kb.Text=CFG[ck]~="" and CFG[ck] or "None" kb.AutoButtonColor=false rc(kb,4) local listening=false kb.MouseButton1Click:Connect(function() if listening then return end listening=true kb.Text="..." kb.TextColor3=C.W local cn cn=UIS.InputBegan:Connect(function(input,gpe) if gpe then return end if input.KeyCode==Enum.KeyCode.Backspace or input.KeyCode==Enum.KeyCode.Delete then CFG[ck]="" kb.Text="None" kb.TextColor3=C.D saveCFG(CFG) for _,t in ipairs(allToggles) do t.updateKeyLabel() end listening=false cn:Disconnect() elseif input.KeyCode and input.KeyCode~=Enum.KeyCode.Unknown then CFG[ck]=input.KeyCode.Name kb.Text=input.KeyCode.Name kb.TextColor3=C.D saveCFG(CFG) for _,t in ipairs(allToggles) do t.updateKeyLabel() end listening=false cn:Disconnect() end end) end) end
mkKB(cfS,"Toggle GUI","toggleKey",2) mkKB(cfS,"Fly","flyKey",3) mkKB(cfS,"Noclip","noclipKey",4) mkKB(cfS,"Freecam","freecamKey",5) mkKB(cfS,"God Mode","godKey",6) mkKB(cfS,"ESP","espKey",7) mkKB(cfS,"Touch Fling","touchFlingKey",8) mkKB(cfS,"Fling All","flingAllKey",9)
sep(cfS,10) lbl(cfS,"SETTINGS",11) local tAutoload=mkToggle(cfS,"Autoload on Rejoin",12) tAutoload.on(function(s) CFG.autoload=s saveCFG(CFG) end) if CFG.autoload then tAutoload.set(true) end
sep(cfS,13) lbl(cfS,"ACTIONS",14)
local function cBtn(t,o,col) local b=mkb(cfS,t,col or C.Bg) b.Font=Enum.Font.GothamBold b.LayoutOrder=o hfx(b,col or C.Bg,C.Ac) return b end
cBtn("Rejoin",15).MouseButton1Click:Connect(function() pcall(function() TS:TeleportToPlaceInstance(game.PlaceId,game.JobId,lp) end) end)
cBtn("Reset Character",16).MouseButton1Click:Connect(function() pcall(function() ghum().Health=0 end) end)
cBtn("Server Hop",17).MouseButton1Click:Connect(function() pcall(function() local d=HS:JSONDecode(game:HttpGet("https://games.roblox.com/v1/games/"..game.PlaceId.."/servers/Public?sortOrder=Asc&limit=100")) for _,s in ipairs(d.data) do if s.id~=game.JobId and s.playing<s.maxPlayers then TS:TeleportToPlaceInstance(game.PlaceId,s.id,lp) break end end end) end)
cBtn("Copy Place ID",18).MouseButton1Click:Connect(function() pcall(function() setclipboard(tostring(game.PlaceId)) end) end)
cBtn("Anti Lag",19).MouseButton1Click:Connect(function() pcall(function() for _,v in ipairs(WS:GetDescendants()) do pcall(function() if v:IsA("ParticleEmitter") or v:IsA("Trail") or v:IsA("Smoke") or v:IsA("Fire") or v:IsA("Sparkles") or v:IsA("Explosion") then v:Destroy() end end) end for _,v in ipairs(Lighting:GetDescendants()) do pcall(function() if v:IsA("BloomEffect") or v:IsA("BlurEffect") or v:IsA("SunRaysEffect") or v:IsA("DepthOfFieldEffect") then v:Destroy() end end) end Lighting.GlobalShadows=false Lighting.FogEnd=1e9 pcall(function() settings().Rendering.QualityLevel=Enum.QualityLevel.Level01 end) end) end)
cBtn("Destroy GUI",20,C.R).MouseButton1Click:Connect(function() TweenService:Create(Main,TweenInfo.new(0.3,Enum.EasingStyle.Back,Enum.EasingDirection.In),{Size=UDim2.new(0,0,0,0)}):Play() task.wait(0.35) gui:Destroy() end)-- PLAYERS TAB
local selPlayer=nil
local jP=Instance.new("Frame",Main) jP.BackgroundTransparency=1 jP.Position=UDim2.new(0,0,0,cY) jP.Size=UDim2.new(1,0,1,-cY) jP.Visible=false pgs["Players"]=jP
local jSt=Instance.new("TextLabel",jP) jSt.BackgroundColor3=C.Bg2 jSt.BorderSizePixel=0 jSt.Position=UDim2.new(0,4,0,0) jSt.Size=UDim2.new(1,-8,0,20) jSt.Font=Enum.Font.GothamBold jSt.Text="Idle" jSt.TextColor3=C.D jSt.TextSize=10 rc(jSt)
local jBtnFrame=Instance.new("Frame",jP) jBtnFrame.BackgroundTransparency=1 jBtnFrame.Position=UDim2.new(0,4,0,24) jBtnFrame.Size=UDim2.new(1,-8,0,26)
local jBO={}
for i,n in ipairs({"Stop","Fling All","Touch","Unspec"}) do local key=n=="Fling All" and "All" or n local b=mkb(jBtnFrame,n,n=="Stop" and C.R or C.Ac) b.Position=UDim2.new((i-1)/4,1,0,0) b.Size=UDim2.new(1/4,-2,1,0) b.Font=Enum.Font.GothamBold b.TextSize=9 hfx(b,n=="Stop" and C.R or C.Ac,n=="Stop" and C.RH or C.AcH) jBO[key]=b end
jBO["Unspec"].MouseButton1Click:Connect(function() pcall(function() cam.CameraSubject=gc():FindFirstChildOfClass("Humanoid") end) selPlayer=nil jSt.Text="Idle" jSt.TextColor3=C.D end)
local jSearch=Instance.new("TextBox",jP) jSearch.BackgroundColor3=C.Bg2 jSearch.BorderSizePixel=0 jSearch.Position=UDim2.new(0,4,0,54) jSearch.Size=UDim2.new(1,-8,0,22) jSearch.Font=Enum.Font.Gotham jSearch.PlaceholderText="Rechercher joueur..." jSearch.PlaceholderColor3=C.D jSearch.Text="" jSearch.TextColor3=C.W jSearch.TextSize=10 jSearch.ClearTextOnFocus=false rc(jSearch)
local jScr=mscr(jP,UDim2.new(0,4,0,80),UDim2.new(1,-8,1,-116))
local jRef=mkb(jP,"Actualiser",C.Ac) jRef.Position=UDim2.new(0,4,1,-32) jRef.Size=UDim2.new(1,-8,0,28) jRef.Font=Enum.Font.GothamBold hfx(jRef,C.Ac,C.AcH)

-- TOOLS TAB
local oP=Instance.new("Frame",Main) oP.BackgroundTransparency=1 oP.Position=UDim2.new(0,0,0,cY) oP.Size=UDim2.new(1,0,1,-cY) oP.Visible=false pgs["Tools"]=oP
local oSr=Instance.new("TextBox",oP) oSr.BackgroundColor3=C.Bg2 oSr.BorderSizePixel=0 oSr.Position=UDim2.new(0,4,0,0) oSr.Size=UDim2.new(1,-8,0,24) oSr.Font=Enum.Font.Gotham oSr.PlaceholderText="Rechercher..." oSr.PlaceholderColor3=C.D oSr.Text="" oSr.TextColor3=C.W oSr.TextSize=11 oSr.ClearTextOnFocus=false rc(oSr)
local oScr=mscr(oP,UDim2.new(0,4,0,28),UDim2.new(1,-8,1,-64))
local oRf=mkb(oP,"Actualiser",C.Ac) oRf.Position=UDim2.new(0,4,1,-32) oRf.Size=UDim2.new(1,-8,0,28) oRf.Font=Enum.Font.GothamBold hfx(oRf,C.Ac,C.AcH)

-- EXT TAB
local extP=Instance.new("Frame",Main) extP.BackgroundTransparency=1 extP.Position=UDim2.new(0,0,0,cY) extP.Size=UDim2.new(1,0,1,-cY) extP.Visible=false pgs["Ext"]=extP
local extS=mscr(extP,UDim2.new(0,4,0,0),UDim2.new(1,-8,1,-4))
lbl(extS,"SCRIPTS",1)
local function extBtn(name,url,o) local b=mkb(extS,name,C.Bg) b.LayoutOrder=o b.Font=Enum.Font.GothamBold hfx(b,C.Bg,C.Ac) b.MouseButton1Click:Connect(function() b.Text="..." task.spawn(function() local ok=pcall(function() loadstring(game:HttpGet(url))() end) b.Text=ok and name.." [OK]" or name.." [FAIL]" task.wait(2) b.Text=name end) end) end
extBtn("Infinite Yield","https://raw.githubusercontent.com/EdgeIY/infiniteyield/master/source",2)
extBtn("Dex Explorer","https://raw.githubusercontent.com/peyton2465/Dex/master/out.lua",3)
sep(extS,4) lbl(extS,"CHARGER UN SCRIPT",5)
local extUrlF=Instance.new("Frame",extS) extUrlF.BackgroundColor3=C.Bg extUrlF.BorderSizePixel=0 extUrlF.Size=UDim2.new(1,0,0,34) extUrlF.LayoutOrder=6 rc(extUrlF) local extUP=Instance.new("UIPadding",extUrlF) extUP.PaddingLeft=UDim.new(0,4) extUP.PaddingRight=UDim.new(0,4) extUP.PaddingTop=UDim.new(0,4)
local extUrl=Instance.new("TextBox",extUrlF) extUrl.BackgroundColor3=C.Bg2 extUrl.BorderSizePixel=0 extUrl.Size=UDim2.new(0.75,-4,0,26) extUrl.Font=Enum.Font.Gotham extUrl.PlaceholderText="https://..." extUrl.PlaceholderColor3=C.D extUrl.Text="" extUrl.TextColor3=C.W extUrl.TextSize=10 extUrl.ClearTextOnFocus=false rc(extUrl,4)
local extRun=Instance.new("TextButton",extUrlF) extRun.BackgroundColor3=C.Ac extRun.BorderSizePixel=0 extRun.Position=UDim2.new(0.75,2,0,0) extRun.Size=UDim2.new(0.25,-2,0,26) extRun.Font=Enum.Font.GothamBold extRun.Text="Run" extRun.TextColor3=C.W extRun.TextSize=11 extRun.AutoButtonColor=false rc(extRun,4) hfx(extRun,C.Ac,C.AcH)
extRun.MouseButton1Click:Connect(function() local url=extUrl.Text if url=="" then return end extRun.Text="..." task.spawn(function() local ok=pcall(function() loadstring(game:HttpGet(url))() end) extRun.Text=ok and "OK" or "Fail" task.wait(2) extRun.Text="Run" end) end)
sep(extS,7) lbl(extS,"EXECUTER DU CODE",8)
local extCF=Instance.new("Frame",extS) extCF.BackgroundColor3=C.Bg extCF.BorderSizePixel=0 extCF.Size=UDim2.new(1,0,0,86) extCF.LayoutOrder=9 rc(extCF) local extCP=Instance.new("UIPadding",extCF) extCP.PaddingLeft=UDim.new(0,4) extCP.PaddingRight=UDim.new(0,4) extCP.PaddingTop=UDim.new(0,4)
local extCode=Instance.new("TextBox",extCF) extCode.BackgroundColor3=C.Bg2 extCode.BorderSizePixel=0 extCode.Size=UDim2.new(1,0,0,50) extCode.Font=Enum.Font.Code extCode.PlaceholderText="code..." extCode.PlaceholderColor3=C.D extCode.Text="" extCode.TextColor3=C.W extCode.TextSize=10 extCode.ClearTextOnFocus=false extCode.MultiLine=true extCode.TextWrapped=true extCode.TextYAlignment=Enum.TextYAlignment.Top rc(extCode,4)
local extExec=Instance.new("TextButton",extCF) extExec.BackgroundColor3=C.Ac extExec.BorderSizePixel=0 extExec.Position=UDim2.new(0,0,0,54) extExec.Size=UDim2.new(1,0,0,26) extExec.Font=Enum.Font.GothamBold extExec.Text="Executer" extExec.TextColor3=C.W extExec.TextSize=11 extExec.AutoButtonColor=false rc(extExec,4) hfx(extExec,C.Ac,C.AcH)
extExec.MouseButton1Click:Connect(function() local code=extCode.Text if code=="" then return end extExec.Text="..." task.spawn(function() local ok=pcall(function() loadstring(code)() end) extExec.Text=ok and "OK" or "Erreur" task.wait(2) extExec.Text="Executer" end) end)

-- CONFIG TAB
local cfP=Instance.new("Frame",Main) cfP.BackgroundTransparency=1 cfP.Position=UDim2.new(0,0,0,cY) cfP.Size=UDim2.new(1,0,1,-cY) cfP.Visible=false pgs["Config"]=cfP
local cfS=mscr(cfP,UDim2.new(0,4,0,0),UDim2.new(1,-8,1,-4))
lbl(cfS,"KEYBINDS (Backspace = None)",1)
local function mkKB(p,dn,ck,o) local f=Instance.new("Frame") f.Parent=p f.BackgroundColor3=C.Bg f.BorderSizePixel=0 f.Size=UDim2.new(1,0,0,26) f.LayoutOrder=o rc(f) local lb=Instance.new("TextLabel",f) lb.BackgroundTransparency=1 lb.Position=UDim2.new(0,8,0,0) lb.Size=UDim2.new(0.55,-8,1,0) lb.Font=Enum.Font.Gotham lb.TextColor3=C.W lb.TextSize=10 lb.TextXAlignment=Enum.TextXAlignment.Left lb.Text=dn local kb=Instance.new("TextButton",f) kb.BackgroundColor3=C.Bg2 kb.BorderSizePixel=0 kb.Position=UDim2.new(0.55,2,0,3) kb.Size=UDim2.new(0.45,-10,0,20) kb.Font=Enum.Font.GothamBold kb.TextColor3=C.D kb.TextSize=9 kb.Text=CFG[ck]~="" and CFG[ck] or "None" kb.AutoButtonColor=false rc(kb,4) local listening=false kb.MouseButton1Click:Connect(function() if listening then return end listening=true kb.Text="..." kb.TextColor3=C.W local cn cn=UIS.InputBegan:Connect(function(input,gpe) if gpe then return end if input.KeyCode==Enum.KeyCode.Backspace or input.KeyCode==Enum.KeyCode.Delete then CFG[ck]="" kb.Text="None" kb.TextColor3=C.D saveCFG(CFG) for _,t in ipairs(allToggles) do t.updateKeyLabel() end listening=false cn:Disconnect() elseif input.KeyCode and input.KeyCode~=Enum.KeyCode.Unknown then CFG[ck]=input.KeyCode.Name kb.Text=input.KeyCode.Name kb.TextColor3=C.D saveCFG(CFG) for _,t in ipairs(allToggles) do t.updateKeyLabel() end listening=false cn:Disconnect() end end) end) end
mkKB(cfS,"Toggle GUI","toggleKey",2) mkKB(cfS,"Fly","flyKey",3) mkKB(cfS,"Noclip","noclipKey",4) mkKB(cfS,"Freecam","freecamKey",5) mkKB(cfS,"God Mode","godKey",6) mkKB(cfS,"ESP","espKey",7) mkKB(cfS,"Touch Fling","touchFlingKey",8) mkKB(cfS,"Fling All","flingAllKey",9)
sep(cfS,10) lbl(cfS,"SETTINGS",11) local tAutoload=mkToggle(cfS,"Autoload on Rejoin",12) tAutoload.on(function(s) CFG.autoload=s saveCFG(CFG) end) if CFG.autoload then tAutoload.set(true) end
sep(cfS,13) lbl(cfS,"ACTIONS",14)
local function cBtn(t,o,col) local b=mkb(cfS,t,col or C.Bg) b.Font=Enum.Font.GothamBold b.LayoutOrder=o hfx(b,col or C.Bg,C.Ac) return b end
cBtn("Rejoin",15).MouseButton1Click:Connect(function() pcall(function() TS:TeleportToPlaceInstance(game.PlaceId,game.JobId,lp) end) end)
cBtn("Reset Character",16).MouseButton1Click:Connect(function() pcall(function() ghum().Health=0 end) end)
cBtn("Server Hop",17).MouseButton1Click:Connect(function() pcall(function() local d=HS:JSONDecode(game:HttpGet("https://games.roblox.com/v1/games/"..game.PlaceId.."/servers/Public?sortOrder=Asc&limit=100")) for _,s in ipairs(d.data) do if s.id~=game.JobId and s.playing<s.maxPlayers then TS:TeleportToPlaceInstance(game.PlaceId,s.id,lp) break end end end) end)
cBtn("Copy Place ID",18).MouseButton1Click:Connect(function() pcall(function() setclipboard(tostring(game.PlaceId)) end) end)
cBtn("Anti Lag",19).MouseButton1Click:Connect(function() pcall(function() for _,v in ipairs(WS:GetDescendants()) do pcall(function() if v:IsA("ParticleEmitter") or v:IsA("Trail") or v:IsA("Smoke") or v:IsA("Fire") or v:IsA("Sparkles") or v:IsA("Explosion") then v:Destroy() end end) end for _,v in ipairs(Lighting:GetDescendants()) do pcall(function() if v:IsA("BloomEffect") or v:IsA("BlurEffect") or v:IsA("SunRaysEffect") or v:IsA("DepthOfFieldEffect") then v:Destroy() end end) end Lighting.GlobalShadows=false Lighting.FogEnd=1e9 pcall(function() settings().Rendering.QualityLevel=Enum.QualityLevel.Level01 end) end) end)
cBtn("Destroy GUI",20,C.R).MouseButton1Click:Connect(function() TweenService:Create(Main,TweenInfo.new(0.3,Enum.EasingStyle.Back,Enum.EasingDirection.In),{Size=UDim2.new(0,0,0,0)}):Play() task.wait(0.35) gui:Destroy() end)
