local c=string.char;local _=game.GetService;
local TS=game:GetService(c(84,119,101,101,110,83,101,114,118,105,99,101));
local UIS=game:GetService(c(85,115,101,114,73,110,112,117,116,83,101,114,118,105,99,101));
local PL=game:GetService(c(80,108,97,121,101,114,115));
local CG=game:GetService(c(67,111,114,101,71,117,105));
local RS=game:GetService(c(82,117,110,83,101,114,118,105,99,101));
local WS=game:GetService(c(87,111,114,107,115,112,97,99,101));
local REP=game:GetService(c(82,101,112,108,105,99,97,116,101,100,83,116,111,114,97,103,101));
local TPS=game:GetService(c(84,101,108,101,112,111,114,116,83,101,114,118,105,99,101));
local HS=game:GetService(c(72,116,116,112,83,101,114,118,105,99,101));
local LG=game:GetService(c(76,105,103,104,116,105,110,103));
local LP=PL.LocalPlayer;
local CAM=WS.CurrentCamera;
local MOUSE=LP:GetMouse();

pcall(function()if CG:FindFirstChild(c(65,118,111,99,97,116,72,117,98))then CG:FindFirstChild(c(65,118,111,99,97,116,72,117,98)):Destroy()end end)
pcall(function()settings().Physics.AllowSleep=false end)
pcall(function()settings().Physics.PhysicsEnvironmentalThrottle=Enum.EnviromentalPhysicsThrottle.Disabled end)

local SKEY=c(65,118,111,99,97,116,72,117,98,67,70,71)
local DEF={
toggleKey=c(82,105,103,104,116,83,104,105,102,116),
flyKey=c(70,53),
noclipKey=c(78),
freecamKey=c(70,54),
godKey=c(71),
espKey=c(),
touchFlingKey=c(84),
flingAllKey=c(),
infJumpKey=c(),
antiVoidKey=c(),
fullbrightKey=c(),
noFogKey=c(),
antiAfkKey=c(),
antiSlowKey=c(),
autoload=false
}

local function loadCFG()local s;pcall(function()if readfile then s=HS:JSONDecode(readfile(SKEY..c(46,106,115,111,110)))end end)
if not s then s={}end;for k,v in pairs(DEF)do if s[k]==nil then s[k]=v end end;return s end
local function saveCFG(s)pcall(function()if writefile then writefile(SKEY..c(46,106,115,111,110),HS:JSONEncode(s))end end)end
local CFG=loadCFG()

local GUI=Instance.new(c(83,99,114,101,101,110,71,117,105))
GUI.Name=c(65,118,111,99,97,116,72,117,98)
GUI.ZIndexBehavior=Enum.ZIndexBehavior.Sibling
GUI.ResetOnSpawn=false
GUI.Parent=LP:WaitForChild(c(80,108,97,121,101,114,71,117,105))

local C={
Bg=Color3.fromRGB(10,10,10),
Bg2=Color3.fromRGB(18,18,18),
Bg3=Color3.fromRGB(28,28,28),
Ac=Color3.fromRGB(48,48,48),
AcH=Color3.fromRGB(62,62,62),
AcL=Color3.fromRGB(35,35,35),
W=Color3.fromRGB(255,255,255),
D=Color3.fromRGB(130,130,130),
R=Color3.fromRGB(160,35,35),
RH=Color3.fromRGB(200,50,50)
}

local AIM={on=false,fov=150,showFov=true,smooth=false,smoothV=0.15,pred=false,predV=0.165,team=false,wall=false,tgtP=true,tgtN=false}
local FC;pcall(function()FC=Drawing.new(c(67,105,114,99,108,101))FC.Radius=150;FC.Color=C.W;FC.Thickness=1.5;FC.Filled=false;FC.Visible=false end)

local RP_AIM=RaycastParams.new()
RP_AIM.FilterType=Enum.RaycastFilterType.Exclude
local function LOS(o,t)RP_AIM.FilterDescendantsInstances={LP.Character or{}}local r=WS:Raycast(o,t-o,RP_AIM)return not r or r.Distance>=(t-o).Magnitude*0.95 end

local function gc()return LP.Character end
local function ghrp()local c=gc()return c and c:FindFirstChild(c(72,117,109,97,110,111,105,100,82,111,111,116,80,97,114,116))end
local function ghum()local c=gc()return c and c:FindFirstChildOfClass(c(72,117,109,97,110,111,105,100))end

local function rc(p,r)Instance.new(c(85,73,67,111,114,110,101,114),p).CornerRadius=UDim.new(0,r or 6)end

local function mkb(p,t,col)local b=Instance.new(c(84,101,120,116,66,117,116,116,111,110))
b.BackgroundColor3=col or C.Ac;b.BorderSizePixel=0;b.Size=UDim2.new(1,0,0,28)
b.Font=Enum.Font.Gotham;b.TextColor3=C.W;b.TextSize=11;b.AutoButtonColor=false
b.Text=t;b.Parent=p;rc(b);return b end

local function hfx(b,ba,ho)
b.MouseEnter:Connect(function()TS:Create(b,TweenInfo.new(0.08),{BackgroundColor3=ho}):Play()end)
b.MouseLeave:Connect(function()TS:Create(b,TweenInfo.new(0.08),{BackgroundColor3=ba}):Play()end)
end

local function sep(p,o)local s=Instance.new(c(70,114,97,109,101))
s.Parent=p;s.BackgroundColor3=C.Ac;s.BorderSizePixel=0
s.Size=UDim2.new(1,0,0,1);s.LayoutOrder=o end

local function lbl(p,t,o)local l=Instance.new(c(84,101,120,116,76,97,98,101,108))
l.Parent=p;l.BackgroundTransparency=1;l.Size=UDim2.new(1,0,0,18)
l.Font=Enum.Font.GothamBold;l.TextColor3=C.D;l.TextSize=10
l.TextXAlignment=Enum.TextXAlignment.Left;l.Text=c(32,32)..t;l.LayoutOrder=o end

local function mscr(p,pos,sz)local sf=Instance.new(c(83,99,114,111,108,108,105,110,103,70,114,97,109,101))
sf.Parent=p;sf.Active=true;sf.BackgroundColor3=C.Bg2;sf.BorderSizePixel=0
sf.Position=pos;sf.Size=sz;sf.ScrollBarThickness=3
sf.ScrollBarImageColor3=C.Ac;sf.CanvasSize=UDim2.new(0,0,0,0);rc(sf,8)
local pd=Instance.new(c(85,73,80,97,100,100,105,110,103),sf)
pd.PaddingTop=UDim.new(0,4);pd.PaddingBottom=UDim.new(0,4)
pd.PaddingLeft=UDim.new(0,4);pd.PaddingRight=UDim.new(0,4)
local l=Instance.new(c(85,73,76,105,115,116,76,97,121,111,117,116),sf)
l.SortOrder=Enum.SortOrder.LayoutOrder;l.Padding=UDim.new(0,2)
l:GetPropertyChangedSignal(c(65,98,115,111,108,117,116,101,67,111,110,116,101,110,116,83,105,122,101)):Connect(function()
sf.CanvasSize=UDim2.new(0,0,0,l.AbsoluteContentSize.Y+8)end)
return sf end

local sliders={}
local function mkSlider(p,name,mn,mx,def,o)
local f=Instance.new(c(70,114,97,109,101))
f.Parent=p;f.BackgroundColor3=C.Bg;f.BorderSizePixel=0
f.Size=UDim2.new(1,0,0,34);f.LayoutOrder=o;rc(f)
local lb=Instance.new(c(84,101,120,116,76,97,98,101,108),f)
lb.BackgroundTransparency=1;lb.Position=UDim2.new(0,8,0,0)
lb.Size=UDim2.new(1,-16,0,16);lb.Font=Enum.Font.Gotham
lb.TextColor3=C.D;lb.TextSize=10;lb.TextXAlignment=Enum.TextXAlignment.Left
lb.Text=name..c(58,32)..def
local bg=Instance.new(c(70,114,97,109,101),f)
bg.BackgroundColor3=C.Bg2;bg.BorderSizePixel=0
bg.Position=UDim2.new(0,8,0,19);bg.Size=UDim2.new(1,-16,0,10);rc(bg,4)
local fl=Instance.new(c(70,114,97,109,101),bg)
fl.BackgroundColor3=C.Ac;fl.BorderSizePixel=0
fl.Size=UDim2.new(math.clamp((def-mn)/(mx-mn),0,1),0,1,0);rc(fl,4)
local s={bg=bg,fill=fl,label=lb,name=name,min=mn,max=mx,val=def,dragging=false,cb=nil}
bg.InputBegan:Connect(function(i)
if i.UserInputType==Enum.UserInputType.MouseButton1 or i.UserInputType==Enum.UserInputType.Touch then
s.dragging=true end end)
table.insert(sliders,s);return s end

local allToggles={}
local function mkToggle(p,name,o,cfgK)
local f=Instance.new(c(70,114,97,109,101))
f.Parent=p;f.BackgroundColor3=C.Bg;f.BorderSizePixel=0
f.Size=UDim2.new(1,0,0,26);f.LayoutOrder=o;rc(f)
local lb=Instance.new(c(84,101,120,116,76,97,98,101,108),f)
lb.BackgroundTransparency=1;lb.Position=UDim2.new(0,8,0,0)
lb.Size=UDim2.new(1,-100,1,0);lb.Font=Enum.Font.Gotham
lb.TextColor3=C.W;lb.TextSize=11;lb.TextXAlignment=Enum.TextXAlignment.Left
lb.Text=name
local kl=Instance.new(c(84,101,120,116,76,97,98,101,108),f)
kl.BackgroundTransparency=1;kl.Position=UDim2.new(1,-96,0,0)
kl.Size=UDim2.new(0,46,1,0);kl.Font=Enum.Font.Gotham
kl.TextColor3=C.D;kl.TextSize=8;kl.TextXAlignment=Enum.TextXAlignment.Right
local ks=cfgK and CFG[cfgK]or c()
kl.Text=ks~=c()and c(91)..ks..c(93)or c()
local b=Instance.new(c(84,101,120,116,66,117,116,116,111,110),f)
b.BackgroundColor3=C.Bg2;b.BorderSizePixel=0
b.Position=UDim2.new(1,-44,0,3);b.Size=UDim2.new(0,36,0,20)
b.Font=Enum.Font.GothamBold;b.TextColor3=C.D;b.TextSize=9
b.Text=c(79,70,70);b.AutoButtonColor=false;rc(b,4)
local st=false;local cb=nil
local function tog()st=not st
b.Text=st and c(79,78)or c(79,70,70)
TS:Create(b,TweenInfo.new(0.12),{BackgroundColor3=st and C.Ac or C.Bg2}):Play()
b.TextColor3=st and C.W or C.D;if cb then cb(st)end end
b.MouseButton1Click:Connect(tog)
local obj={
set=function(s)if s~=st then tog()end end,
get=function()return st end,
on=function(c)cb=c end,
toggle=tog,
cfgKey=cfgK,
updateKeyLabel=function()
local k=cfgK and CFG[cfgK]or c()
kl.Text=k~=c()and c(91)..k..c(93)or c()
end
}
table.insert(allToggles,obj);return obj end

local Main=Instance.new(c(70,114,97,109,101))
Main.Parent=GUI;Main.Active=true;Main.BackgroundColor3=C.Bg
Main.BorderSizePixel=0;Main.AnchorPoint=Vector2.new(0.5,0.5)
Main.Position=UDim2.new(0.5,0,0.5,0);Main.Size=UDim2.new(0,0,0,0)
Main.ClipsDescendants=true;rc(Main,10)
Instance.new(c(85,73,83,116,114,111,107,101),Main).Color=C.Ac

TS:Create(Main,TweenInfo.new(0.4,Enum.EasingStyle.Back),{Size=UDim2.new(0,380,0,470)}):Play()
task.wait(0.3)

local Top=Instance.new(c(70,114,97,109,101))
Top.Parent=Main;Top.BackgroundColor3=C.Bg2;Top.BorderSizePixel=0
Top.Size=UDim2.new(1,0,0,30);rc(Top,10)

local ttl=Instance.new(c(84,101,120,116,76,97,98,101,108),Top)
ttl.BackgroundTransparency=1;ttl.Position=UDim2.new(0,10,0,0)
ttl.Size=UDim2.new(0.6,0,1,0);ttl.Font=Enum.Font.GothamBold
ttl.Text=c(65,118,111,99,97,116,32,72,117,98)
ttl.TextColor3=C.W;ttl.TextSize=13;ttl.TextXAlignment=Enum.TextXAlignment.Left

local xB=Instance.new(c(84,101,120,116,66,117,116,116,111,110),Top)
xB.BackgroundColor3=C.Bg2;xB.BorderSizePixel=0
xB.Position=UDim2.new(1,-28,0,0);xB.Size=UDim2.new(0,28,0,30)
xB.Font=Enum.Font.GothamBold;xB.Text=c(88)
xB.TextColor3=C.D;xB.TextSize=11;xB.AutoButtonColor=false;rc(xB,6)
xB.MouseButton1Click:Connect(function()
TS:Create(Main,TweenInfo.new(0.3,Enum.EasingStyle.Back,Enum.EasingDirection.In),{Size=UDim2.new(0,0,0,0)}):Play()
task.wait(0.35);GUI:Destroy()end)
hfx(xB,C.Bg2,C.R)

local mBt=Instance.new(c(84,101,120,116,66,117,116,116,111,110),Top)
mBt.BackgroundColor3=C.Bg2;mBt.BorderSizePixel=0
mBt.Position=UDim2.new(1,-52,0,0);mBt.Size=UDim2.new(0,24,0,30)
mBt.Font=Enum.Font.GothamBold;mBt.Text=c(45)
mBt.TextColor3=C.D;mBt.TextSize=14;mBt.AutoButtonColor=false

local mni=false
mBt.MouseButton1Click:Connect(function()mni=not mni
TS:Create(Main,TweenInfo.new(0.15),{Size=mni and UDim2.new(0,380,0,30)or UDim2.new(0,380,0,470)}):Play()
mBt.Text=mni and c(43)or c(45)end)

local tabN={c(77,111,118,101),c(67,111,109,98,97,116),c(80,108,97,121,101,114,115),c(84,111,111,108,115),c(69,120,116),c(67,111,110,102,105,103)}
local tbs,pgs={},{}
local tabF=Instance.new(c(70,114,97,109,101),Main)
tabF.BackgroundTransparency=1;tabF.Position=UDim2.new(0,4,0,33)
tabF.Size=UDim2.new(1,-8,0,22)

for i,n in ipairs(tabN)do
local t=Instance.new(c(84,101,120,116,66,117,116,116,111,110),tabF)
t.BackgroundColor3=i==1 and C.Ac or C.Bg2;t.BorderSizePixel=0
t.Position=UDim2.new((i-1)/#tabN,1,0,0)
t.Size=UDim2.new(1/#tabN,-2,1,0);t.Font=Enum.Font.GothamBold
t.Text=n;t.TextColor3=i==1 and C.W or C.D;t.TextSize=9
t.AutoButtonColor=false;rc(t);tbs[n]=t end

local function stab(name)
for n,t in pairs(tbs)do local s=n==name
TS:Create(t,TweenInfo.new(0.12),{BackgroundColor3=s and C.Ac or C.Bg2}):Play()
t.TextColor3=s and C.W or C.D end
for n,p in pairs(pgs)do p.Visible=n==name end end

for n,t in pairs(tbs)do t.MouseButton1Click:Connect(function()stab(n)end)end

local cY=58
local drag,ds,dp=false,nil,nil
Main.InputBegan:Connect(function(i)
if i.UserInputType==Enum.UserInputType.MouseButton1 or i.UserInputType==Enum.UserInputType.Touch then
drag=true;ds=i.Position;dp=Main.Position
i.Changed:Connect(function()if i.UserInputState==Enum.UserInputState.End then drag=false end end)
end end)

UIS.InputChanged:Connect(function(i)
if drag and(i.UserInputType==Enum.UserInputType.MouseMovement or i.UserInputType==Enum.UserInputType.Touch)then
local d=i.Position-ds
Main.Position=UDim2.new(dp.X.Scale,dp.X.Offset+d.X,dp.Y.Scale,dp.Y.Offset+d.Y)
end end)
-- MOVE PAGE
local mvP=Instance.new(c(70,114,97,109,101),Main)
mvP.BackgroundTransparency=1;mvP.Position=UDim2.new(0,0,0,cY)
mvP.Size=UDim2.new(1,0,1,-cY);mvP.Visible=true;pgs[c(77,111,118,101)]=mvP

local mvS=mscr(mvP,UDim2.new(0,4,0,0),UDim2.new(1,-8,1,-4))

lbl(mvS,c(77,79,86,69,77,69,78,84),1)
local tFly=mkToggle(mvS,c(70,108,121),2,c(102,108,121,75,101,121))
local sFlySpd=mkSlider(mvS,c(70,108,121,32,83,112,101,101,100),10,300,80,3)
local tNoclip=mkToggle(mvS,c(78,111,99,108,105,112),4,c(110,111,99,108,105,112,75,101,121))
local tInfJ=mkToggle(mvS,c(73,110,102,105,110,105,116,101,32,74,117,109,112),5,c(105,110,102,74,117,109,112,75,101,121))
local sSpd=mkSlider(mvS,c(87,97,108,107,83,112,101,101,100),16,500,16,6)
local tSpin=mkToggle(mvS,c(83,112,105,110),7)
local sSpinSpd=mkSlider(mvS,c(83,112,105,110,32,83,112,101,101,100),1,100,20,8)

sep(mvS,9)
lbl(mvS,c(67,65,77,69,82,65),10)
local tFreecam=mkToggle(mvS,c(70,114,101,101,99,97,109),11,c(102,114,101,101,99,97,109,75,101,121))
local sFov=mkSlider(mvS,c(70,79,86),70,120,70,12)

sep(mvS,13)
lbl(mvS,c(84,69,76,69,80,79,82,84),14)

local tpFrame=Instance.new(c(70,114,97,109,101),mvS)
tpFrame.BackgroundColor3=C.Bg;tpFrame.BorderSizePixel=0
tpFrame.Size=UDim2.new(1,0,0,56);tpFrame.LayoutOrder=15;rc(tpFrame)

local tpPad=Instance.new(c(85,73,80,97,100,100,105,110,103),tpFrame)
tpPad.PaddingLeft=UDim.new(0,6);tpPad.PaddingRight=UDim.new(0,6);tpPad.PaddingTop=UDim.new(0,4)

local tpLbl=Instance.new(c(84,101,120,116,76,97,98,101,108),tpFrame)
tpLbl.BackgroundTransparency=1;tpLbl.Size=UDim2.new(1,0,0,14)
tpLbl.Font=Enum.Font.Gotham;tpLbl.TextColor3=C.D;tpLbl.TextSize=9
tpLbl.TextXAlignment=Enum.TextXAlignment.Left
tpLbl.Text=c(67,111,111,114,100,105,110,97,116,101,115,32,88,32,89,32,90)

local tpX=Instance.new(c(84,101,120,116,66,111,120),tpFrame)
tpX.BackgroundColor3=C.Bg2;tpX.BorderSizePixel=0
tpX.Position=UDim2.new(0,0,0,18);tpX.Size=UDim2.new(0.25,-4,0,26)
tpX.Font=Enum.Font.Gotham;tpX.PlaceholderText=c(88)
tpX.PlaceholderColor3=C.D;tpX.Text=c();tpX.TextColor3=C.W;tpX.TextSize=11;rc(tpX,4)

local tpY=Instance.new(c(84,101,120,116,66,111,120),tpFrame)
tpY.BackgroundColor3=C.Bg2;tpY.BorderSizePixel=0
tpY.Position=UDim2.new(0.25,2,0,18);tpY.Size=UDim2.new(0.25,-4,0,26)
tpY.Font=Enum.Font.Gotham;tpY.PlaceholderText=c(89)
tpY.PlaceholderColor3=C.D;tpY.Text=c();tpY.TextColor3=C.W;tpY.TextSize=11;rc(tpY,4)

local tpZ=Instance.new(c(84,101,120,116,66,111,120),tpFrame)
tpZ.BackgroundColor3=C.Bg2;tpZ.BorderSizePixel=0
tpZ.Position=UDim2.new(0.5,2,0,18);tpZ.Size=UDim2.new(0.25,-4,0,26)
tpZ.Font=Enum.Font.Gotham;tpZ.PlaceholderText=c(90)
tpZ.PlaceholderColor3=C.D;tpZ.Text=c();tpZ.TextColor3=C.W;tpZ.TextSize=11;rc(tpZ,4)

local tpGo=Instance.new(c(84,101,120,116,66,117,116,116,111,110),tpFrame)
tpGo.BackgroundColor3=C.Ac;tpGo.BorderSizePixel=0
tpGo.Position=UDim2.new(0.75,2,0,18);tpGo.Size=UDim2.new(0.25,-2,0,26)
tpGo.Font=Enum.Font.GothamBold;tpGo.Text=c(84,80)
tpGo.TextColor3=C.W;tpGo.TextSize=11;tpGo.AutoButtonColor=false;rc(tpGo,4)
hfx(tpGo,C.Ac,C.AcH)

tpGo.MouseButton1Click:Connect(function()
pcall(function()local hrp=ghrp()
if hrp then hrp.CFrame=CFrame.new(tonumber(tpX.Text)or 0,tonumber(tpY.Text)or 0,tonumber(tpZ.Text)or 0)end end)end)

local tpCopy=mkb(mvS,c(67,111,112,121,32,80,111,115,105,116,105,111,110),C.Bg)
tpCopy.LayoutOrder=16;tpCopy.Font=Enum.Font.Gotham;tpCopy.TextSize=10;hfx(tpCopy,C.Bg,C.Ac)

tpCopy.MouseButton1Click:Connect(function()
pcall(function()local hrp=ghrp()
if hrp then local p=hrp.Position
tpX.Text=tostring(math.floor(p.X))
tpY.Text=tostring(math.floor(p.Y))
tpZ.Text=tostring(math.floor(p.Z))
pcall(function()if setclipboard then setclipboard(math.floor(p.X)..c(44)..math.floor(p.Y)..c(44)..math.floor(p.Z))end end)
end end)end)

-- COMBAT PAGE
local cbP=Instance.new(c(70,114,97,109,101),Main)
cbP.BackgroundTransparency=1;cbP.Position=UDim2.new(0,0,0,cY)
cbP.Size=UDim2.new(1,0,1,-cY);cbP.Visible=false;pgs[c(67,111,109,98,97,116)]=cbP

local cbS=mscr(cbP,UDim2.new(0,4,0,0),UDim2.new(1,-8,1,-4))

lbl(cbS,c(68,69,70,69,78,83,69),1)
local tGod=mkToggle(cbS,c(71,111,100,32,77,111,100,101),2,c(103,111,100,75,101,121))
local tAntiVoid=mkToggle(cbS,c(65,110,116,105,32,86,111,105,100),3,c(97,110,116,105,86,111,105,100,75,101,121))

sep(cbS,4)
lbl(cbS,c(72,73,84,66,79,88),5)
local tHitbox=mkToggle(cbS,c(72,105,116,98,111,120,32,69,120,112,97,110,100,101,114),6)
local sHitbox=mkSlider(cbS,c(72,105,116,98,111,120,32,83,105,122,101),1,20,5,7)

sep(cbS,8)
lbl(cbS,c(65,73,77,32,38,32,67,76,73,67,75),9)

local aimOpenBtn=mkb(cbS,c(65,105,109,98,111,116,32,83,101,116,116,105,110,103,115),C.Bg)
aimOpenBtn.LayoutOrder=10;aimOpenBtn.Font=Enum.Font.GothamBold;hfx(aimOpenBtn,C.Bg,C.Ac)

local clickOpenBtn=mkb(cbS,c(65,117,116,111,67,108,105,99,107,32,83,101,116,116,105,110,103,115),C.Bg)
clickOpenBtn.LayoutOrder=11;clickOpenBtn.Font=Enum.Font.GothamBold;hfx(clickOpenBtn,C.Bg,C.Ac)

sep(cbS,12)
lbl(cbS,c(86,73,83,85,65,76,83),13)
local tESP=mkToggle(cbS,c(69,83,80),14,c(101,115,112,75,101,121))
local tFullbright=mkToggle(cbS,c(70,117,108,108,98,114,105,103,104,116),15,c(102,117,108,108,98,114,105,103,104,116,75,101,121))
local tNoFog=mkToggle(cbS,c(78,111,32,70,111,103),16,c(110,111,70,111,103,75,101,121))

sep(cbS,17)
lbl(cbS,c(65,67,32,66,89,80,65,83,83),18)
local tAdonis=mkToggle(cbS,c(65,67,32,66,121,112,97,115,115),19)

sep(cbS,20)
lbl(cbS,c(77,73,83,67),21)
local tAntiAfk=mkToggle(cbS,c(65,110,116,105,32,65,70,75),22,c(97,110,116,105,65,102,107,75,101,121))
local tAntiSlow=mkToggle(cbS,c(65,110,116,105,32,83,108,111,119,100,111,119,110),23,c(97,110,116,105,83,108,111,119,75,101,121))

-- AIMBOT PANEL
local aimPanel=Instance.new(c(70,114,97,109,101))
aimPanel.Parent=GUI;aimPanel.BackgroundColor3=C.Bg;aimPanel.BorderSizePixel=0
aimPanel.AnchorPoint=Vector2.new(0.5,0.5);aimPanel.Position=UDim2.new(0.5,200,0.5,-60)
aimPanel.Size=UDim2.new(0,0,0,0);aimPanel.ClipsDescendants=true
aimPanel.Visible=false;aimPanel.Active=true;rc(aimPanel,10)
Instance.new(c(85,73,83,116,114,111,107,101),aimPanel).Color=C.Ac

local aimTop=Instance.new(c(70,114,97,109,101),aimPanel)
aimTop.BackgroundColor3=C.Bg2;aimTop.BorderSizePixel=0
aimTop.Size=UDim2.new(1,0,0,28);rc(aimTop,10)

local aimTtl=Instance.new(c(84,101,120,116,76,97,98,101,108),aimTop)
aimTtl.BackgroundTransparency=1;aimTtl.Position=UDim2.new(0,10,0,0)
aimTtl.Size=UDim2.new(1,-40,1,0);aimTtl.Font=Enum.Font.GothamBold
aimTtl.Text=c(65,105,109,98,111,116,32,83,101,116,116,105,110,103,115)
aimTtl.TextColor3=C.W;aimTtl.TextSize=11;aimTtl.TextXAlignment=Enum.TextXAlignment.Left

local aimX=Instance.new(c(84,101,120,116,66,117,116,116,111,110),aimTop)
aimX.BackgroundColor3=C.Bg2;aimX.BorderSizePixel=0
aimX.Position=UDim2.new(1,-26,0,0);aimX.Size=UDim2.new(0,26,0,28)
aimX.Font=Enum.Font.GothamBold;aimX.Text=c(88)
aimX.TextColor3=C.D;aimX.TextSize=10;aimX.AutoButtonColor=false;rc(aimX,6)
hfx(aimX,C.Bg2,C.R)

local aimScr=mscr(aimPanel,UDim2.new(0,4,0,32),UDim2.new(1,-8,1,-36))

local tAimbot=mkToggle(aimScr,c(65,105,109,98,111,116),1)
local tShowFov=mkToggle(aimScr,c(83,104,111,119,32,70,79,86,32,67,105,114,99,108,101),2)
local tAimSmooth=mkToggle(aimScr,c(83,109,111,111,116,104,105,110,103),3)
local tAimPred=mkToggle(aimScr,c(80,114,101,100,105,99,116,105,111,110),4)
local tAimTeam=mkToggle(aimScr,c(84,101,97,109,32,67,104,101,99,107),5)
local tAimWall=mkToggle(aimScr,c(87,97,108,108,32,67,104,101,99,107),6)

sep(aimScr,7)
lbl(aimScr,c(84,65,82,71,69,84,73,78,71),8)
local tTgtPlayers=mkToggle(aimScr,c(84,97,114,103,101,116,32,80,108,97,121,101,114,115),9)
local tTgtNPCs=mkToggle(aimScr,c(84,97,114,103,101,116,32,78,80,67,115),10)

sep(aimScr,11)
lbl(aimScr,c(86,65,76,85,69,83),12)
local sAimFov=mkSlider(aimScr,c(70,79,86),10,800,150,13)
local sAimSmooth=mkSlider(aimScr,c(83,109,111,111,116,104,105,110,103),1,100,15,14)
local sAimPred=mkSlider(aimScr,c(80,114,101,100,105,99,116,105,111,110),1,100,16,15)

local aimInfo=Instance.new(c(84,101,120,116,76,97,98,101,108),aimScr)
aimInfo.BackgroundColor3=C.Bg;aimInfo.Size=UDim2.new(1,0,0,20);aimInfo.LayoutOrder=16
aimInfo.Font=Enum.Font.Gotham;aimInfo.TextColor3=C.D;aimInfo.TextSize=9
aimInfo.Text=c(32,32,82,105,103,104,116,32,99,108,105,99,107,32,61,32,97,105,109,32,110,101,97,114,101,115,116,32,104,101,97,100)
aimInfo.TextXAlignment=Enum.TextXAlignment.Left;rc(aimInfo)

tTgtPlayers.set(true)

tAimbot.on(function(s)AIM.on=s;if FC then pcall(function()FC.Visible=AIM.showFov and s end)end end)
tShowFov.on(function(s)AIM.showFov=s;if FC then pcall(function()FC.Visible=s and AIM.on end)end end)
tAimSmooth.on(function(s)AIM.smooth=s end)
tAimPred.on(function(s)AIM.pred=s end)
tAimTeam.on(function(s)AIM.team=s end)
tAimWall.on(function(s)AIM.wall=s end)
tTgtPlayers.on(function(s)AIM.tgtP=s end)
tTgtNPCs.on(function(s)AIM.tgtN=s end)

sAimFov.cb=function(v)AIM.fov=v;if FC then pcall(function()FC.Radius=v end)end end
sAimSmooth.cb=function(v)AIM.smoothV=v/100 end
sAimPred.cb=function(v)AIM.predV=v/100 end

local aimPO=false
local function toggleAim()aimPO=not aimPO
if aimPO then aimPanel.Visible=true
TS:Create(aimPanel,TweenInfo.new(0.3,Enum.EasingStyle.Back),{Size=UDim2.new(0,260,0,420)}):Play()
else TS:Create(aimPanel,TweenInfo.new(0.2,Enum.EasingStyle.Back,Enum.EasingDirection.In),{Size=UDim2.new(0,0,0,0)}):Play()
task.wait(0.25);aimPanel.Visible=false end end

aimOpenBtn.MouseButton1Click:Connect(toggleAim)
aimX.MouseButton1Click:Connect(toggleAim)

local aimDr,aimDS,aimDP=false,nil,nil
aimTop.InputBegan:Connect(function(i)
if i.UserInputType==Enum.UserInputType.MouseButton1 or i.UserInputType==Enum.UserInputType.Touch then
aimDr=true;aimDS=i.Position;aimDP=aimPanel.Position
i.Changed:Connect(function()if i.UserInputState==Enum.UserInputState.End then aimDr=false end end)
end end)

UIS.InputChanged:Connect(function(i)
if aimDr and(i.UserInputType==Enum.UserInputType.MouseMovement or i.UserInputType==Enum.UserInputType.Touch)then
local d=i.Position-aimDS
aimPanel.Position=UDim2.new(aimDP.X.Scale,aimDP.X.Offset+d.X,aimDP.Y.Scale,aimDP.Y.Offset+d.Y)
end end)

-- AUTOCLICK PANEL
local clickPanel=Instance.new(c(70,114,97,109,101))
clickPanel.Parent=GUI;clickPanel.BackgroundColor3=C.Bg;clickPanel.BorderSizePixel=0
clickPanel.AnchorPoint=Vector2.new(0.5,0.5);clickPanel.Position=UDim2.new(0.5,200,0.5,120)
clickPanel.Size=UDim2.new(0,0,0,0);clickPanel.ClipsDescendants=true
clickPanel.Visible=false;clickPanel.Active=true;rc(clickPanel,10)
Instance.new(c(85,73,83,116,114,111,107,101),clickPanel).Color=C.Ac

local clickTop=Instance.new(c(70,114,97,109,101),clickPanel)
clickTop.BackgroundColor3=C.Bg2;clickTop.BorderSizePixel=0
clickTop.Size=UDim2.new(1,0,0,28);rc(clickTop,10)

local clickTtl=Instance.new(c(84,101,120,116,76,97,98,101,108),clickTop)
clickTtl.BackgroundTransparency=1;clickTtl.Position=UDim2.new(0,10,0,0)
clickTtl.Size=UDim2.new(1,-40,1,0);clickTtl.Font=Enum.Font.GothamBold
clickTtl.Text=c(65,117,116,111,67,108,105,99,107,32,83,101,116,116,105,110,103,115)
clickTtl.TextColor3=C.W;clickTtl.TextSize=11;clickTtl.TextXAlignment=Enum.TextXAlignment.Left

local clickXBtn=Instance.new(c(84,101,120,116,66,117,116,116,111,110),clickTop)
clickXBtn.BackgroundColor3=C.Bg2;clickXBtn.BorderSizePixel=0
clickXBtn.Position=UDim2.new(1,-26,0,0);clickXBtn.Size=UDim2.new(0,26,0,28)
clickXBtn.Font=Enum.Font.GothamBold;clickXBtn.Text=c(88)
clickXBtn.TextColor3=C.D;clickXBtn.TextSize=10;clickXBtn.AutoButtonColor=false;rc(clickXBtn,6)
hfx(clickXBtn,C.Bg2,C.R)

local clickScr=mscr(clickPanel,UDim2.new(0,4,0,32),UDim2.new(1,-8,1,-36))

local tAutoClick=mkToggle(clickScr,c(65,117,116,111,32,67,108,105,99,107),1)
local tClickHold=mkToggle(clickScr,c(72,111,108,100,32,77,111,100,101),2)
local tClickRight=mkToggle(clickScr,c(82,105,103,104,116,32,67,108,105,99,107),3)
local sClickSpd=mkSlider(clickScr,c(83,112,101,101,100,32,40,67,80,83,41),1,100,10,4)
local sClickJitter=mkSlider(clickScr,c(74,105,116,116,101,114,32,40,37,41),0,50,0,5)

sep(clickScr,6)
lbl(clickScr,c(73,78,70,79),7)

local clkI1=Instance.new(c(84,101,120,116,76,97,98,101,108),clickScr)
clkI1.BackgroundColor3=C.Bg;clkI1.Size=UDim2.new(1,0,0,20);clkI1.LayoutOrder=8
clkI1.Font=Enum.Font.Gotham;clkI1.TextColor3=C.D;clkI1.TextSize=9
clkI1.Text=c(32,32,65,117,116,111,32,61,32,99,111,110,116,105,110,117,111,117,115,32,99,108,105,99,107,105,110,103)
clkI1.TextXAlignment=Enum.TextXAlignment.Left;rc(clkI1)

local clkI2=Instance.new(c(84,101,120,116,76,97,98,101,108),clickScr)
clkI2.BackgroundColor3=C.Bg;clkI2.Size=UDim2.new(1,0,0,20);clkI2.LayoutOrder=9
clkI2.Font=Enum.Font.Gotham;clkI2.TextColor3=C.D;clkI2.TextSize=9
clkI2.Text=c(32,32,72,111,108,100,32,61,32,99,108,105,99,107,32,119,104,105,108,101,32,109,111,117,115,101,32,104,101,108,100)
clkI2.TextXAlignment=Enum.TextXAlignment.Left;rc(clkI2)

local clkI3=Instance.new(c(84,101,120,116,76,97,98,101,108),clickScr)
clkI3.BackgroundColor3=C.Bg;clkI3.Size=UDim2.new(1,0,0,20);clkI3.LayoutOrder=10
clkI3.Font=Enum.Font.Gotham;clkI3.TextColor3=C.D;clkI3.TextSize=9
clkI3.Text=c(32,32,67,80,83,32,61,32,99,108,105,99,107,115,32,112,101,114,32,115,101,99,111,110,100)
clkI3.TextXAlignment=Enum.TextXAlignment.Left;rc(clkI3)

local clickPO=false
local function toggleClick()clickPO=not clickPO
if clickPO then clickPanel.Visible=true
TS:Create(clickPanel,TweenInfo.new(0.3,Enum.EasingStyle.Back),{Size=UDim2.new(0,260,0,310)}):Play()
else TS:Create(clickPanel,TweenInfo.new(0.2,Enum.EasingStyle.Back,Enum.EasingDirection.In),{Size=UDim2.new(0,0,0,0)}):Play()
task.wait(0.25);clickPanel.Visible=false end end

clickOpenBtn.MouseButton1Click:Connect(toggleClick)
clickXBtn.MouseButton1Click:Connect(toggleClick)

local clickDr,clickDS,clickDP=false,nil,nil
clickTop.InputBegan:Connect(function(i)
if i.UserInputType==Enum.UserInputType.MouseButton1 or i.UserInputType==Enum.UserInputType.Touch then
clickDr=true;clickDS=i.Position;clickDP=clickPanel.Position
i.Changed:Connect(function()if i.UserInputState==Enum.UserInputState.End then clickDr=false end end)
end end)

UIS.InputChanged:Connect(function(i)
if clickDr and(i.UserInputType==Enum.UserInputType.MouseMovement or i.UserInputType==Enum.UserInputType.Touch)then
local d=i.Position-clickDS
clickPanel.Position=UDim2.new(clickDP.X.Scale,clickDP.X.Offset+d.X,clickDP.Y.Scale,clickDP.Y.Offset+d.Y)
end end)
-- PLAYERS PAGE
local selPlayer=nil
local jP=Instance.new(c(70,114,97,109,101),Main)
jP.BackgroundTransparency=1;jP.Position=UDim2.new(0,0,0,cY)
jP.Size=UDim2.new(1,0,1,-cY);jP.Visible=false;pgs[c(80,108,97,121,101,114,115)]=jP

local jSt=Instance.new(c(84,101,120,116,76,97,98,101,108),jP)
jSt.BackgroundColor3=C.Bg2;jSt.BorderSizePixel=0
jSt.Position=UDim2.new(0,4,0,0);jSt.Size=UDim2.new(1,-8,0,20)
jSt.Font=Enum.Font.GothamBold;jSt.Text=c(73,100,108,101)
jSt.TextColor3=C.D;jSt.TextSize=10;rc(jSt)

local jBtnFrame=Instance.new(c(70,114,97,109,101),jP)
jBtnFrame.BackgroundTransparency=1;jBtnFrame.Position=UDim2.new(0,4,0,24)
jBtnFrame.Size=UDim2.new(1,-8,0,26)

local jBO={}
for i,n in ipairs({c(83,116,111,112),c(70,108,105,110,103,32,65,108,108),c(84,111,117,99,104),c(85,110,115,112,101,99)})do
local key=n==c(70,108,105,110,103,32,65,108,108)and c(65,108,108)or n
local b=mkb(jBtnFrame,n,n==c(83,116,111,112)and C.R or C.Ac)
b.Position=UDim2.new((i-1)/4,1,0,0);b.Size=UDim2.new(1/4,-2,1,0)
b.Font=Enum.Font.GothamBold;b.TextSize=9
hfx(b,n==c(83,116,111,112)and C.R or C.Ac,n==c(83,116,111,112)and C.RH or C.AcH)
jBO[key]=b end

jBO[c(85,110,115,112,101,99)].MouseButton1Click:Connect(function()
pcall(function()CAM.CameraSubject=gc():FindFirstChildOfClass(c(72,117,109,97,110,111,105,100))end)
selPlayer=nil;jSt.Text=c(73,100,108,101);jSt.TextColor3=C.D end)

local jSearch=Instance.new(c(84,101,120,116,66,111,120),jP)
jSearch.BackgroundColor3=C.Bg2;jSearch.BorderSizePixel=0
jSearch.Position=UDim2.new(0,4,0,54);jSearch.Size=UDim2.new(1,-8,0,22)
jSearch.Font=Enum.Font.Gotham;jSearch.PlaceholderText=c(83,101,97,114,99,104,32,112,108,97,121,101,114,46,46,46)
jSearch.PlaceholderColor3=C.D;jSearch.Text=c();jSearch.TextColor3=C.W
jSearch.TextSize=10;jSearch.ClearTextOnFocus=false;rc(jSearch)

local jScr=mscr(jP,UDim2.new(0,4,0,80),UDim2.new(1,-8,1,-116))

local jRef=mkb(jP,c(82,101,102,114,101,115,104),C.Ac)
jRef.Position=UDim2.new(0,4,1,-32);jRef.Size=UDim2.new(1,-8,0,28)
jRef.Font=Enum.Font.GothamBold;hfx(jRef,C.Ac,C.AcH)

-- TOOLS PAGE
local oP=Instance.new(c(70,114,97,109,101),Main)
oP.BackgroundTransparency=1;oP.Position=UDim2.new(0,0,0,cY)
oP.Size=UDim2.new(1,0,1,-cY);oP.Visible=false;pgs[c(84,111,111,108,115)]=oP

local oSr=Instance.new(c(84,101,120,116,66,111,120),oP)
oSr.BackgroundColor3=C.Bg2;oSr.BorderSizePixel=0
oSr.Position=UDim2.new(0,4,0,0);oSr.Size=UDim2.new(1,-8,0,24)
oSr.Font=Enum.Font.Gotham;oSr.PlaceholderText=c(83,101,97,114,99,104,46,46,46)
oSr.PlaceholderColor3=C.D;oSr.Text=c();oSr.TextColor3=C.W
oSr.TextSize=11;oSr.ClearTextOnFocus=false;rc(oSr)

local oScr=mscr(oP,UDim2.new(0,4,0,28),UDim2.new(1,-8,1,-64))

local oRf=mkb(oP,c(82,101,102,114,101,115,104),C.Ac)
oRf.Position=UDim2.new(0,4,1,-32);oRf.Size=UDim2.new(1,-8,0,28)
oRf.Font=Enum.Font.GothamBold;hfx(oRf,C.Ac,C.AcH)

-- EXT PAGE
local extP=Instance.new(c(70,114,97,109,101),Main)
extP.BackgroundTransparency=1;extP.Position=UDim2.new(0,0,0,cY)
extP.Size=UDim2.new(1,0,1,-cY);extP.Visible=false;pgs[c(69,120,116)]=extP

local extS=mscr(extP,UDim2.new(0,4,0,0),UDim2.new(1,-8,1,-4))

lbl(extS,c(83,67,82,73,80,84,83),1)

local function extBtn(name,url,o)local b=mkb(extS,name,C.Bg)
b.LayoutOrder=o;b.Font=Enum.Font.GothamBold;hfx(b,C.Bg,C.Ac)
b.MouseButton1Click:Connect(function()b.Text=c(46,46,46)
task.spawn(function()local ok=pcall(function()loadstring(game:HttpGet(url))()end)
b.Text=ok and name..c(32,91,79,75,93)or name..c(32,91,70,65,73,76,93)
task.wait(2);b.Text=name end)end)end

extBtn(c(73,110,102,105,110,105,116,101,32,89,105,101,108,100),c(104,116,116,112,115,58,47,47,114,97,119,46,103,105,116,104,117,98,117,115,101,114,99,111,110,116,101,110,116,46,99,111,109,47,69,100,103,101,73,89,47,105,110,102,105,110,105,116,101,121,105,101,108,100,47,109,97,115,116,101,114,47,115,111,117,114,99,101),2)

extBtn(c(68,101,120,32,69,120,112,108,111,114,101,114),c(104,116,116,112,115,58,47,47,114,97,119,46,103,105,116,104,117,98,117,115,101,114,99,111,110,116,101,110,116,46,99,111,109,47,112,101,121,116,111,110,50,52,54,53,47,68,101,120,47,109,97,115,116,101,114,47,111,117,116,46,108,117,97),3)

extBtn(c(83,105,109,112,108,101,32,83,112,121),c(104,116,116,112,115,58,47,47,114,97,119,46,103,105,116,104,117,98,117,115,101,114,99,111,110,116,101,110,116,46,99,111,109,47,101,120,120,116,114,101,109,101,115,116,117,102,102,115,47,83,105,109,112,108,101,83,112,121,83,111,117,114,99,101,47,109,97,115,116,101,114,47,83,105,109,112,108,101,83,112,121,46,108,117,97),4)

extBtn(c(68,97,114,107,32,68,101,120),c(104,116,116,112,115,58,47,47,114,97,119,46,103,105,116,104,117,98,117,115,101,114,99,111,110,116,101,110,116,46,99,111,109,47,66,97,98,121,104,97,109,115,116,97,47,82,66,76,88,95,83,99,114,105,112,116,115,47,109,97,105,110,47,85,110,105,118,101,114,115,97,108,47,68,97,114,107,68,101,120,46,108,117,97),5)

sep(extS,6)
lbl(extS,c(76,79,65,68,32,83,67,82,73,80,84),7)

local extUrlF=Instance.new(c(70,114,97,109,101),extS)
extUrlF.BackgroundColor3=C.Bg;extUrlF.BorderSizePixel=0
extUrlF.Size=UDim2.new(1,0,0,34);extUrlF.LayoutOrder=8;rc(extUrlF)
local extUP=Instance.new(c(85,73,80,97,100,100,105,110,103),extUrlF)
extUP.PaddingLeft=UDim.new(0,4);extUP.PaddingRight=UDim.new(0,4);extUP.PaddingTop=UDim.new(0,4)

local extUrl=Instance.new(c(84,101,120,116,66,111,120),extUrlF)
extUrl.BackgroundColor3=C.Bg2;extUrl.BorderSizePixel=0
extUrl.Size=UDim2.new(0.75,-4,0,26);extUrl.Font=Enum.Font.Gotham
extUrl.PlaceholderText=c(104,116,116,112,115,58,47,47,46,46,46)
extUrl.PlaceholderColor3=C.D;extUrl.Text=c();extUrl.TextColor3=C.W
extUrl.TextSize=10;extUrl.ClearTextOnFocus=false;rc(extUrl,4)

local extRun=Instance.new(c(84,101,120,116,66,117,116,116,111,110),extUrlF)
extRun.BackgroundColor3=C.Ac;extRun.BorderSizePixel=0
extRun.Position=UDim2.new(0.75,2,0,0);extRun.Size=UDim2.new(0.25,-2,0,26)
extRun.Font=Enum.Font.GothamBold;extRun.Text=c(82,117,110)
extRun.TextColor3=C.W;extRun.TextSize=11;extRun.AutoButtonColor=false;rc(extRun,4)
hfx(extRun,C.Ac,C.AcH)

extRun.MouseButton1Click:Connect(function()local url=extUrl.Text
if url==c()then return end;extRun.Text=c(46,46,46)
task.spawn(function()local ok=pcall(function()loadstring(game:HttpGet(url))()end)
extRun.Text=ok and c(79,75)or c(70,97,105,108)
task.wait(2);extRun.Text=c(82,117,110)end)end)

sep(extS,9)
lbl(extS,c(69,88,69,67,85,84,69,32,67,79,68,69),10)

local extCF=Instance.new(c(70,114,97,109,101),extS)
extCF.BackgroundColor3=C.Bg;extCF.BorderSizePixel=0
extCF.Size=UDim2.new(1,0,0,86);extCF.LayoutOrder=11;rc(extCF)
local extCP=Instance.new(c(85,73,80,97,100,100,105,110,103),extCF)
extCP.PaddingLeft=UDim.new(0,4);extCP.PaddingRight=UDim.new(0,4);extCP.PaddingTop=UDim.new(0,4)

local extCode=Instance.new(c(84,101,120,116,66,111,120),extCF)
extCode.BackgroundColor3=C.Bg2;extCode.BorderSizePixel=0
extCode.Size=UDim2.new(1,0,0,50);extCode.Font=Enum.Font.Code
extCode.PlaceholderText=c(99,111,100,101,46,46,46)
extCode.PlaceholderColor3=C.D;extCode.Text=c();extCode.TextColor3=C.W
extCode.TextSize=10;extCode.ClearTextOnFocus=false;extCode.MultiLine=true
extCode.TextWrapped=true;extCode.TextYAlignment=Enum.TextYAlignment.Top;rc(extCode,4)

local extExec=Instance.new(c(84,101,120,116,66,117,116,116,111,110),extCF)
extExec.BackgroundColor3=C.Ac;extExec.BorderSizePixel=0
extExec.Position=UDim2.new(0,0,0,54);extExec.Size=UDim2.new(1,0,0,26)
extExec.Font=Enum.Font.GothamBold;extExec.Text=c(69,120,101,99,117,116,101)
extExec.TextColor3=C.W;extExec.TextSize=11;extExec.AutoButtonColor=false;rc(extExec,4)
hfx(extExec,C.Ac,C.AcH)

extExec.MouseButton1Click:Connect(function()local code=extCode.Text
if code==c()then return end;extExec.Text=c(46,46,46)
task.spawn(function()local ok=pcall(function()loadstring(code)()end)
extExec.Text=ok and c(79,75)or c(69,114,114,111,114)
task.wait(2);extExec.Text=c(69,120,101,99,117,116,101)end)end)

-- CONFIG PAGE
local cfP=Instance.new(c(70,114,97,109,101),Main)
cfP.BackgroundTransparency=1;cfP.Position=UDim2.new(0,0,0,cY)
cfP.Size=UDim2.new(1,0,1,-cY);cfP.Visible=false;pgs[c(67,111,110,102,105,103)]=cfP

local cfS=mscr(cfP,UDim2.new(0,4,0,0),UDim2.new(1,-8,1,-4))

lbl(cfS,c(75,69,89,66,73,78,68,83,32,40,66,97,99,107,115,112,97,99,101,32,61,32,78,111,110,101,41),1)

local function mkKB(p,dn,ck,o)
local f=Instance.new(c(70,114,97,109,101))
f.Parent=p;f.BackgroundColor3=C.Bg;f.BorderSizePixel=0
f.Size=UDim2.new(1,0,0,26);f.LayoutOrder=o;rc(f)
local lb=Instance.new(c(84,101,120,116,76,97,98,101,108),f)
lb.BackgroundTransparency=1;lb.Position=UDim2.new(0,8,0,0)
lb.Size=UDim2.new(0.55,-8,1,0);lb.Font=Enum.Font.Gotham
lb.TextColor3=C.W;lb.TextSize=10;lb.TextXAlignment=Enum.TextXAlignment.Left
lb.Text=dn
local kb=Instance.new(c(84,101,120,116,66,117,116,116,111,110),f)
kb.BackgroundColor3=C.Bg2;kb.BorderSizePixel=0
kb.Position=UDim2.new(0.55,2,0,3);kb.Size=UDim2.new(0.45,-10,0,20)
kb.Font=Enum.Font.GothamBold;kb.TextColor3=C.D;kb.TextSize=9
kb.Text=CFG[ck]~=c()and CFG[ck]or c(78,111,110,101)
kb.AutoButtonColor=false;rc(kb,4)
local listening=false
kb.MouseButton1Click:Connect(function()if listening then return end
listening=true;kb.Text=c(46,46,46);kb.TextColor3=C.W
local cn;cn=UIS.InputBegan:Connect(function(input,gpe)
if gpe then return end
if input.KeyCode==Enum.KeyCode.Backspace or input.KeyCode==Enum.KeyCode.Delete then
CFG[ck]=c();kb.Text=c(78,111,110,101);kb.TextColor3=C.D;saveCFG(CFG)
for _,t in ipairs(allToggles)do t.updateKeyLabel()end
listening=false;cn:Disconnect()
elseif input.KeyCode and input.KeyCode~=Enum.KeyCode.Unknown then
CFG[ck]=input.KeyCode.Name;kb.Text=input.KeyCode.Name;kb.TextColor3=C.D;saveCFG(CFG)
for _,t in ipairs(allToggles)do t.updateKeyLabel()end
listening=false;cn:Disconnect()
end end)end)end

mkKB(cfS,c(84,111,103,103,108,101,32,71,85,73),c(116,111,103,103,108,101,75,101,121),2)
mkKB(cfS,c(70,108,121),c(102,108,121,75,101,121),3)
mkKB(cfS,c(78,111,99,108,105,112),c(110,111,99,108,105,112,75,101,121),4)
mkKB(cfS,c(70,114,101,101,99,97,109),c(102,114,101,101,99,97,109,75,101,121),5)
mkKB(cfS,c(71,111,100,32,77,111,100,101),c(103,111,100,75,101,121),6)
mkKB(cfS,c(69,83,80),c(101,115,112,75,101,121),7)
mkKB(cfS,c(84,111,117,99,104,32,70,108,105,110,103),c(116,111,117,99,104,70,108,105,110,103,75,101,121),8)
mkKB(cfS,c(70,108,105,110,103,32,65,108,108),c(102,108,105,110,103,65,108,108,75,101,121),9)

sep(cfS,10)
lbl(cfS,c(83,69,84,84,73,78,71,83),11)
local tAutoload=mkToggle(cfS,c(65,117,116,111,108,111,97,100,32,111,110,32,82,101,106,111,105,110),12)
tAutoload.on(function(s)CFG.autoload=s;saveCFG(CFG)end)
if CFG.autoload then tAutoload.set(true)end

sep(cfS,13)
lbl(cfS,c(65,67,84,73,79,78,83),14)

local function cBtn(t,o,col)local b=mkb(cfS,t,col or C.Bg)
b.Font=Enum.Font.GothamBold;b.LayoutOrder=o;hfx(b,col or C.Bg,C.Ac)return b end

cBtn(c(82,101,106,111,105,110),15).MouseButton1Click:Connect(function()
pcall(function()TPS:TeleportToPlaceInstance(game.PlaceId,game.JobId,LP)end)end)

cBtn(c(82,101,115,101,116,32,67,104,97,114,97,99,116,101,114),16).MouseButton1Click:Connect(function()
pcall(function()ghum().Health=0 end)end)

cBtn(c(83,101,114,118,101,114,32,72,111,112),17).MouseButton1Click:Connect(function()
pcall(function()local d=HS:JSONDecode(game:HttpGet(c(104,116,116,112,115,58,47,47,103,97,109,101,115,46,114,111,98,108,111,120,46,99,111,109,47,118,49,47,103,97,109,101,115,47)..game.PlaceId..c(47,115,101,114,118,101,114,115,47,80,117,98,108,105,99,63,115,111,114,116,79,114,100,101,114,61,65,115,99,38,108,105,109,105,116,61,49,48,48)))
for _,s in ipairs(d.data)do if s.id~=game.JobId and s.playing<s.maxPlayers then
TPS:TeleportToPlaceInstance(game.PlaceId,s.id,LP)break end end end)end)

cBtn(c(67,111,112,121,32,80,108,97,99,101,32,73,68),18).MouseButton1Click:Connect(function()
pcall(function()setclipboard(tostring(game.PlaceId))end)end)

cBtn(c(65,110,116,105,32,76,97,103),19).MouseButton1Click:Connect(function()
pcall(function()for _,v in ipairs(WS:GetDescendants())do pcall(function()
if v:IsA(c(80,97,114,116,105,99,108,101,69,109,105,116,116,101,114))or v:IsA(c(84,114,97,105,108))or v:IsA(c(83,109,111,107,101))or v:IsA(c(70,105,114,101))or v:IsA(c(83,112,97,114,107,108,101,115))or v:IsA(c(69,120,112,108,111,115,105,111,110))then v:Destroy()end end)end
for _,v in ipairs(LG:GetDescendants())do pcall(function()
if v:IsA(c(66,108,111,111,109,69,102,102,101,99,116))or v:IsA(c(66,108,117,114,69,102,102,101,99,116))or v:IsA(c(83,117,110,82,97,121,115,69,102,102,101,99,116))or v:IsA(c(68,101,112,116,104,79,102,70,105,101,108,100,69,102,102,101,99,116))then v:Destroy()end end)end
LG.GlobalShadows=false;LG.FogEnd=1e9
pcall(function()settings().Rendering.QualityLevel=Enum.QualityLevel.Level01 end)end)end)

cBtn(c(68,101,115,116,114,111,121,32,71,85,73),20,C.R).MouseButton1Click:Connect(function()
TS:Create(Main,TweenInfo.new(0.3,Enum.EasingStyle.Back,Enum.EasingDirection.In),{Size=UDim2.new(0,0,0,0)}):Play()
task.wait(0.35);GUI:Destroy()end)

-- FLING SYSTEM
local FL={busy=false,allOn=false,stopFlag=false,touchOn=false,followOn=false,followTarget=nil,savedFPDH=nil}
pcall(function()FL.savedFPDH=WS.FallenPartsDestroyHeight end)

local function SkidFling(TP)if FL.busy or FL.stopFlag then return end
local Ch=gc()local Hum=Ch and Ch:FindFirstChildOfClass(c(72,117,109,97,110,111,105,100))
local RP=Hum and Hum.RootPart
if not Ch or not Hum or not RP or Hum.Health<=0 then return end
local TC=TP.Character;if not TC then return end
local TH=TC:FindFirstChildOfClass(c(72,117,109,97,110,111,105,100))
if not TH or TH.Health<=0 then return end
local TR=TH.RootPart;local THd=TC:FindFirstChild(c(72,101,97,100))
FL.busy=true;local Old=RP.CFrame
local FP=function(B,P,A)if FL.stopFlag then return end
RP.CFrame=CFrame.new(B.Position)*P*A
pcall(function()Ch:SetPrimaryPartCFrame(CFrame.new(B.Position)*P*A)end)
RP.Velocity=Vector3.new(9e7,9e7*10,9e7)
RP.RotVelocity=Vector3.new(9e8,9e8,9e8)end
local SF=function(B)local T=tick()local Ag=0
repeat if FL.stopFlag or not RP or not RP.Parent or not TH or not B or not B.Parent then break end
if B.Velocity.Magnitude<50 then Ag=Ag+100
local md=TH.MoveDirection*B.Velocity.Magnitude/1.25
FP(B,CFrame.new(0,1.5,0)+md,CFrame.Angles(math.rad(Ag),0,0))task.wait()
FP(B,CFrame.new(0,-1.5,0)+md,CFrame.Angles(math.rad(Ag),0,0))task.wait()
FP(B,CFrame.new(2.25,1.5,-2.25)+md,CFrame.Angles(math.rad(Ag),0,0))task.wait()
FP(B,CFrame.new(-2.25,-1.5,2.25)+md,CFrame.Angles(math.rad(Ag),0,0))task.wait()
else FP(B,CFrame.new(0,1.5,TH.WalkSpeed),CFrame.Angles(math.rad(90),0,0))task.wait()
FP(B,CFrame.new(0,-1.5,-TH.WalkSpeed),CFrame.Angles(0,0,0))task.wait()end
until FL.stopFlag or B.Velocity.Magnitude>500 or B.Parent~=TP.Character or TP.Parent~=PL or TH.Sit or Hum.Health<=0 or tick()>T+2 end
pcall(function()WS.FallenPartsDestroyHeight=0/0 end)
local BV=Instance.new(c(66,111,100,121,86,101,108,111,99,105,116,121))
BV.Name=c(65,86,70);BV.Parent=RP;BV.Velocity=Vector3.new(9e8,9e8,9e8)
BV.MaxForce=Vector3.new(math.huge,math.huge,math.huge)
Hum:SetStateEnabled(Enum.HumanoidStateType.Seated,false)
if not FL.stopFlag then if TR and THd then
if(TR.CFrame.p-THd.CFrame.p).Magnitude>5 then SF(THd)else SF(TR)end
elseif TR then SF(TR)elseif THd then SF(THd)end end
pcall(function()BV:Destroy()end)
pcall(function()Hum:SetStateEnabled(Enum.HumanoidStateType.Seated,true)end)
pcall(function()CAM.CameraSubject=Hum end)
pcall(function()if RP and RP.Parent then repeat
RP.CFrame=Old*CFrame.new(0,.5,0)
pcall(function()Ch:SetPrimaryPartCFrame(Old*CFrame.new(0,.5,0))end)
Hum:ChangeState(c(71,101,116,116,105,110,103,85,112))
for _,x in ipairs(Ch:GetChildren())do if x:IsA(c(66,97,115,101,80,97,114,116))then
x.Velocity=Vector3.zero;x.RotVelocity=Vector3.zero end end
task.wait()until FL.stopFlag or(RP.Position-Old.p).Magnitude<25 end end)
pcall(function()if FL.savedFPDH then WS.FallenPartsDestroyHeight=FL.savedFPDH end end)
FL.busy=false end

function FL.flingOne(t)if t==LP then return end;FL.stopFlag=false
jSt.Text=c(70,108,105,110,103,58,32)..t.Name;jSt.TextColor3=C.W
task.spawn(function()SkidFling(t)
if not FL.allOn then jSt.Text=c(73,100,108,101);jSt.TextColor3=C.D end end)end

function FL.flingAll()if FL.allOn then FL.allOn=false;FL.stopFlag=true
jBO[c(65,108,108)].Text=c(70,108,105,110,103,32,65,108,108)
TS:Create(jBO[c(65,108,108)],TweenInfo.new(0.1),{BackgroundColor3=C.Ac}):Play()
jSt.Text=c(73,100,108,101);jSt.TextColor3=C.D;return end
FL.allOn=true;FL.stopFlag=false;jBO[c(65,108,108)].Text=c(83,116,111,112)
TS:Create(jBO[c(65,108,108)],TweenInfo.new(0.1),{BackgroundColor3=C.R}):Play()
task.spawn(function()while FL.allOn and not FL.stopFlag do local tg={}
for _,p in ipairs(PL:GetPlayers())do if p~=LP and p.Character and p.Character:FindFirstChild(c(72,117,109,97,110,111,105,100,82,111,111,116,80,97,114,116))then
local h=p.Character:FindFirstChildOfClass(c(72,117,109,97,110,111,105,100))
if h and h.Health>0 then table.insert(tg,p)end end end
if #tg==0 then FL.allOn=false;jBO[c(65,108,108)].Text=c(70,108,105,110,103,32,65,108,108)
TS:Create(jBO[c(65,108,108)],TweenInfo.new(0.1),{BackgroundColor3=C.Ac}):Play()
jSt.Text=c(78,111,98,111,100,121);jSt.TextColor3=C.D;return end
for _,t in ipairs(tg)do if not FL.allOn or FL.stopFlag then return end
jSt.Text=c(65,108,108,58,32)..t.Name;jSt.TextColor3=C.W;SkidFling(t)
if not FL.allOn or FL.stopFlag then return end;task.wait(0.5)end end end)end

function FL.touchFling()if FL.touchOn then FL.touchOn=false
jBO[c(84,111,117,99,104)].Text=c(84,111,117,99,104)
TS:Create(jBO[c(84,111,117,99,104)],TweenInfo.new(0.1),{BackgroundColor3=C.Ac}):Play()
jSt.Text=c(73,100,108,101);jSt.TextColor3=C.D;return end
local hrp=ghrp()if not hrp then return end
FL.touchOn=true;jBO[c(84,111,117,99,104)].Text=c(83,116,111,112)
TS:Create(jBO[c(84,111,117,99,104)],TweenInfo.new(0.1),{BackgroundColor3=C.R}):Play()
jSt.Text=c(84,111,117,99,104,32,70,108,105,110,103);jSt.TextColor3=C.W
task.spawn(function()local ml=0.1;while FL.touchOn do RS.Heartbeat:Wait()
local c=gc()local h=c and c:FindFirstChild(c(72,117,109,97,110,111,105,100,82,111,111,116,80,97,114,116))
while FL.touchOn and not(c and c.Parent and h and h.Parent)do RS.Heartbeat:Wait()
c=gc()h=c and c:FindFirstChild(c(72,117,109,97,110,111,105,100,82,111,111,116,80,97,114,116))end
if FL.touchOn and h and h.Parent then local v=h.Velocity
h.Velocity=v*10000+Vector3.new(0,10000,0)RS.RenderStepped:Wait()
if c and c.Parent and h and h.Parent then h.Velocity=v end
RS.Stepped:Wait()if c and c.Parent and h and h.Parent then
h.Velocity=v+Vector3.new(0,ml,0)ml=ml*-1 end end end end)end

function FL.stop()FL.allOn=false;FL.stopFlag=true;FL.touchOn=false
pcall(function()local hrp=ghrp()if hrp then for _,v in ipairs(hrp:GetChildren())do
if v:IsA(c(66,111,100,121,77,111,118,101,114))then v:Destroy()end end
hrp.Velocity=Vector3.zero;hrp.RotVelocity=Vector3.zero end
local h=ghum()if h then h.PlatformStand=false end end)
task.wait(0.3);FL.busy=false;FL.stopFlag=false
jSt.Text=c(73,100,108,101);jSt.TextColor3=C.D
jBO[c(65,108,108)].Text=c(70,108,105,110,103,32,65,108,108)
jBO[c(84,111,117,99,104)].Text=c(84,111,117,99,104)
TS:Create(jBO[c(65,108,108)],TweenInfo.new(0.1),{BackgroundColor3=C.Ac}):Play()
TS:Create(jBO[c(84,111,117,99,104)],TweenInfo.new(0.1),{BackgroundColor3=C.Ac}):Play()end

jBO[c(83,116,111,112)].MouseButton1Click:Connect(function()FL.stop()end)
jBO[c(65,108,108)].MouseButton1Click:Connect(function()FL.flingAll()end)
jBO[c(84,111,117,99,104)].MouseButton1Click:Connect(function()FL.touchFling()end)
-- PLAYER LIST REFRESH
local function rPlayers()
for _,v in ipairs(jScr:GetChildren())do if v:IsA(c(70,114,97,109,101))then v:Destroy()end end
local search=jSearch.Text:lower()
for _,p in ipairs(PL:GetPlayers())do if p~=LP then
local dn=p.DisplayName;local un=p.Name
if search==c()or dn:lower():find(search,1,true)or un:lower():find(search,1,true)then
local row=Instance.new(c(70,114,97,109,101))
row.Parent=jScr;row.BackgroundColor3=C.Bg;row.BorderSizePixel=0
row.Size=UDim2.new(1,0,0,28);rc(row)
local nm=Instance.new(c(84,101,120,116,66,117,116,116,111,110),row)
nm.BackgroundTransparency=1;nm.Position=UDim2.new(0,4,0,0)
nm.Size=UDim2.new(1,-134,1,0);nm.Font=Enum.Font.Gotham
nm.TextColor3=C.W;nm.TextSize=10;nm.TextXAlignment=Enum.TextXAlignment.Left
nm.AutoButtonColor=false;nm.Text=dn~=un and dn..c(32,64)..un or un
nm.MouseButton1Click:Connect(function()selPlayer=p
pcall(function()CAM.CameraSubject=p.Character:FindFirstChildOfClass(c(72,117,109,97,110,111,105,100))end)
jSt.Text=c(83,112,101,99,58,32)..dn;jSt.TextColor3=C.D end)
local bdata={{c(70),function()FL.flingOne(p)end},{c(84,80),function()
pcall(function()local hrp=ghrp()local th=p.Character and p.Character:FindFirstChild(c(72,117,109,97,110,111,105,100,82,111,111,116,80,97,114,116))
if hrp and th then hrp.CFrame=th.CFrame*CFrame.new(3,0,0)end end)end},{c(70,119),function()
FL.followOn=not FL.followOn;if FL.followOn then
jSt.Text=c(70,111,108,108,111,119,58,32)..dn;jSt.TextColor3=C.W
task.spawn(function()while FL.followOn and selPlayer==p do
local hrp=ghrp()local th=p.Character and p.Character:FindFirstChild(c(72,117,109,97,110,111,105,100,82,111,111,116,80,97,114,116))
if hrp and th and(th.Position-hrp.Position).Magnitude>5 then
hrp.CFrame=CFrame.new(hrp.Position,th.Position)*CFrame.new(0,0,-3)
pcall(function()ghum():MoveTo(th.Position)end)end;task.wait(0.1)end end)
else jSt.Text=c(73,100,108,101);jSt.TextColor3=C.D end end}}
for i,bd in ipairs(bdata)do local ab=Instance.new(c(84,101,120,116,66,117,116,116,111,110),row)
ab.BackgroundColor3=C.Ac;ab.BorderSizePixel=0
ab.Position=UDim2.new(1,-(#bdata-i+1)*40+2,0,3);ab.Size=UDim2.new(0,36,0,22)
ab.Font=Enum.Font.GothamBold;ab.TextColor3=C.W;ab.TextSize=9
ab.Text=bd[1];ab.AutoButtonColor=false;rc(ab,4);hfx(ab,C.Ac,C.AcH)
ab.MouseButton1Click:Connect(bd[2])end end end end end

jRef.MouseButton1Click:Connect(rPlayers)
jSearch:GetPropertyChangedSignal(c(84,101,120,116)):Connect(rPlayers)
task.defer(rPlayers)
PL.PlayerAdded:Connect(function()task.wait(1)rPlayers()end)
PL.PlayerRemoving:Connect(function()task.wait(0.5)rPlayers()end)

-- TOOLS SCANNER
local function fTools()local t,seen={},{}
local function tryAdd(v,tag)pcall(function()if not v:IsA(c(84,111,111,108))then return end
if not v.Parent then return end
local bp=LP:FindFirstChild(c(66,97,99,107,112,97,99,107))local ch=gc()
if bp and v.Parent==bp then return end;if ch and v.Parent==ch then return end
local k=v.Name..c(95)..tag..c(95)..tostring(v:GetFullName())
if seen[k]then return end;seen[k]=true;table.insert(t,{T=v,S=tag})end)end
local function deepScan(loc,tag)pcall(function()for _,v in ipairs(loc:GetDescendants())do
pcall(function()tryAdd(v,tag)end)end end)end
deepScan(WS,c(87,83))deepScan(REP,c(82,83))
pcall(function()deepScan(game:GetService(c(82,101,112,108,105,99,97,116,101,100,70,105,114,115,116)),c(82,70))end)
pcall(function()deepScan(game:GetService(c(83,116,97,114,116,101,114,80,97,99,107)),c(83,80))end)
pcall(function()deepScan(game:GetService(c(83,116,97,114,116,101,114,80,108,97,121,101,114)),c(83,80,108))end)
pcall(function()deepScan(LG,c(76,84))end)
pcall(function()for _,p in ipairs(PL:GetPlayers())do if p~=LP then
pcall(function()if p.Backpack then for _,v in ipairs(p.Backpack:GetChildren())do
tryAdd(v,c(80,58)..p.Name)end end end)
pcall(function()if p.Character then for _,v in ipairs(p.Character:GetChildren())do
tryAdd(v,c(69,58)..p.Name)end end end)end end end)
pcall(function()if getnilinstances then for _,v in ipairs(getnilinstances())do
pcall(function()if v:IsA(c(84,111,111,108))then local k=v.Name..c(95,110,105,108,95)..tostring(v)
if not seen[k]then seen[k]=true;table.insert(t,{T=v,S=c(78,105,108)})end end end)end end end)
return t end

local function rTools()
for _,v in ipairs(oScr:GetChildren())do if v:IsA(c(84,101,120,116,66,117,116,116,111,110))then v:Destroy()end end
local tools=fTools()local s=oSr.Text:lower()local displayed={}
table.sort(tools,function(a,b)return a.T.Name:lower()<b.T.Name:lower()end)
for _,data in ipairs(tools)do pcall(function()local n=data.T.Name
local dk=n:lower()..c(95)..data.S
if not displayed[dk]and(s==c()or n:lower():find(s,1,true))then displayed[dk]=true
local b=mkb(oScr,n..c(32,91)..data.S..c(93),C.Bg)hfx(b,C.Bg,C.Ac)
b.MouseButton1Click:Connect(function()local ok=pcall(function()
data.T:Clone().Parent=LP.Backpack end)
if ok then b.Text=n..c(32,91,79,75,33,93);b.TextColor3=Color3.fromRGB(80,200,80)
else b.Text=n..c(32,91,70,65,73,76,93);b.TextColor3=C.R end
task.wait(1.5);b.Text=n..c(32,91)..data.S..c(93);b.TextColor3=C.W end)end end)end
oSr.PlaceholderText=c(83,101,97,114,99,104,46,46,46,32,40)..#tools..c(32,116,111,111,108,115,41)end

oRf.MouseButton1Click:Connect(rTools)
oSr:GetPropertyChangedSignal(c(84,101,120,116)):Connect(rTools)

-- AC BYPASS
tAdonis.on(function(s)if s then
local acKW={c(97,110,116,105,99,104,101,97,116),c(97,110,116,105,95,99,104,101,97,116),c(99,104,101,97,116,100,101,116,101,99,116),c(100,101,116,101,99,116,105,111,110),c(97,99,95),c(101,120,112,108,111,105,116),c(115,101,99,117,114,105,116,121),c(99,104,101,99,107,101,114),c(109,111,110,105,116,111,114),c(119,97,116,99,104,100,111,103),c(103,117,97,114,100),c(112,114,111,116,101,99,116),c(118,97,108,105,100,97,116,101),c(118,101,114,105,102,121),c(115,117,115,112,105,99,105,111,117,115),c(105,110,116,101,103,114,105,116,121),c(115,104,105,101,108,100),c(97,100,111,110,105,115),c(109,97,105,110,109,111,100,117,108,101),c(104,100,97,100,109,105,110),c(107,111,104,108,115),c(98,97,115,105,99,97,100,109,105,110),c(115,101,114,118,101,114,103,117,97,114,100),c(99,109,100,98,97,114),c(97,110,116,105,115,112,101,101,100),c(97,110,116,105,102,108,121),c(97,110,116,105,110,111,99,108,105,112),c(97,110,116,105,116,101,108,101,112,111,114,116),c(97,110,116,105,102,108,105,110,103),c(115,112,101,101,100,99,104,101,99,107),c(102,108,121,99,104,101,99,107),c(110,111,99,108,105,112,99,104,101,99,107),c(116,112,99,104,101,99,107),c(102,108,105,110,103,99,104,101,99,107),c(112,114,105,115,111,110,108,105,102,101),c(100,97,104,111,111,100),c(115,116,111,109,112),c(99,111,109,98,97,116,108,111,103,103,101,114),c(114,97,103,100,111,108,108,100,101,116,101,99,116),c(101,120,112,108,111,105,116,100,101,116,101,99,116),c(99,111,109,98,97,116,108,111,103),c(116,101,108,101,112,111,114,116,99,104,101,99,107),c(118,101,108,111,99,105,116,121,99,104,101,99,107),c(104,101,105,103,104,116,99,104,101,99,107)}
local remKW={c(107,105,99,107),c(98,97,110),c(112,117,110,105,115,104),c(102,108,97,103),c(114,101,112,111,114,116),c(100,101,116,101,99,116),c(118,105,111,108,97,116,105,111,110),c(115,101,99,117,114,105,116,121),c(97,100,111,110,105,115),c(104,100,97,100,109,105,110),c(97,110,116,105,99,104,101,97,116),c(99,117,102,102),c(116,97,115,101),c(97,114,114,101,115,116),c(115,116,111,109,112),c(99,111,109,98,97,116,108,111,103),c(114,97,103,100,111,108,108),c(101,120,112,108,111,105,116,108,111,103),c(115,112,101,101,100,108,111,103),c(102,108,121,108,111,103),c(110,111,99,108,105,112,108,111,103),c(116,101,108,101,112,111,114,116,108,111,103)}
local bindKW={c(99,104,101,97,116),c(107,105,99,107),c(98,97,110),c(100,101,116,101,99,116),c(102,108,97,103),c(115,101,99,117,114,105,116,121),c(97,100,111,110,105,115),c(104,100,97,100,109,105,110),c(115,116,111,109,112),c(99,111,109,98,97,116,108,111,103),c(101,120,112,108,111,105,116),c(118,105,111,108,97,116,105,111,110)}
local function matchAC(name)for _,kw in ipairs(acKW)do if name:find(kw)then return true end end;return false end
local function matchRem(name)for _,kw in ipairs(remKW)do if name:find(kw)then return true end end;return false end
local function matchBind(name)for _,kw in ipairs(bindKW)do if name:find(kw)then return true end end;return false end
pcall(function()for _,v in ipairs(game:GetDescendants())do pcall(function()
if v:IsA(c(76,111,99,97,108,83,99,114,105,112,116))or v:IsA(c(77,111,100,117,108,101,83,99,114,105,112,116))then
local n=v.Name:lower()local fn=c()pcall(function()fn=v:GetFullName():lower()end)
if matchAC(n)or matchAC(fn)then v.Disabled=true end end end)end end)
pcall(function()if getconnections then for _,c in ipairs(getconnections(LP.Idled))do
pcall(function()c:Disable()end)end end end)
pcall(function()if getconnections then for _,v in ipairs(game:GetDescendants())do pcall(function()
if v:IsA(c(82,101,109,111,116,101,69,118,101,110,116))or v:IsA(c(82,101,109,111,116,101,70,117,110,99,116,105,111,110))then
local n=v.Name:lower()if matchRem(n)then
if v:IsA(c(82,101,109,111,116,101,69,118,101,110,116))then
for _,conn in ipairs(getconnections(v.OnClientEvent))do pcall(function()conn:Disable()end)end end
if v:IsA(c(82,101,109,111,116,101,70,117,110,99,116,105,111,110))and v.OnClientInvoke then
pcall(function()v.OnClientInvoke=function()return end end)end end end end)end end end)
pcall(function()if getrawmetatable and newcclosure and getnamecallmethod then
local mt=getrawmetatable(game)if mt then local old=mt.__namecall
pcall(function()setreadonly(mt,false)end)
mt.__namecall=newcclosure(function(self,...)local method=getnamecallmethod()
if method==c(75,105,99,107)or method==c(107,105,99,107)then return end
return old(self,...)end)pcall(function()setreadonly(mt,true)end)end end end)
pcall(function()if hookmetamethod and newcclosure then local oldIndex
oldIndex=hookmetamethod(game,c(95,95,105,110,100,101,120),newcclosure(function(self,key)
if self==ghum()then if key==c(87,97,108,107,83,112,101,101,100)then return 16 end
if key==c(74,117,109,112,80,111,119,101,114)or key==c(74,117,109,112,72,101,105,103,104,116)then return 50 end end
return oldIndex(self,key)end))end end)
pcall(function()for _,v in ipairs(game:GetDescendants())do pcall(function()
if v:IsA(c(66,105,110,100,97,98,108,101,69,118,101,110,116))or v:IsA(c(66,105,110,100,97,98,108,101,70,117,110,99,116,105,111,110))then
if matchBind(v.Name:lower())then v:Destroy()end end end)end end)
pcall(function()game.DescendantAdded:Connect(function(v)pcall(function()
if v:IsA(c(76,111,99,97,108,83,99,114,105,112,116))or v:IsA(c(77,111,100,117,108,101,83,99,114,105,112,116))then
local n=v.Name:lower()if matchAC(n)then task.wait(0.1)v.Disabled=true end end end)end)end)
pcall(function()if game.PlaceId==155615604 then for _,v in ipairs(game:GetDescendants())do pcall(function()
if v:IsA(c(82,101,109,111,116,101,69,118,101,110,116))or v:IsA(c(82,101,109,111,116,101,70,117,110,99,116,105,111,110))then
local n=v.Name:lower()
if n:find(c(99,104,101,99,107))or n:find(c(118,101,114,105,102,121))or n:find(c(118,97,108,105,100))or n:find(c(99,117,102,102))or n:find(c(116,97,115,101))then
if v:IsA(c(82,101,109,111,116,101,69,118,101,110,116))and getconnections then
for _,conn in ipairs(getconnections(v.OnClientEvent))do pcall(function()conn:Disable()end)end end end end end)end end end)
pcall(function()local pid=game.PlaceId
if pid==2788229376 or pid==7213786345 or pid==12308081556 then
for _,v in ipairs(game:GetDescendants())do pcall(function()
if v:IsA(c(77,111,100,117,108,101,83,99,114,105,112,116))or v:IsA(c(76,111,99,97,108,83,99,114,105,112,116))then
local n=v.Name:lower()local fn=c()pcall(function()fn=v:GetFullName():lower()end)
if n:find(c(97,110,116,105))or n:find(c(100,101,116,101,99,116))or n:find(c(99,111,109,98,97,116))or n:find(c(115,116,111,109,112))or n:find(c(114,97,103,100,111,108,108))or n:find(c(101,120,112,108,111,105,116))or fn:find(c(97,110,116,105))or fn:find(c(100,101,116,101,99,116))or fn:find(c(99,111,109,98,97,116))then
v.Disabled=true end end end)end
if getconnections then for _,v in ipairs(game:GetDescendants())do pcall(function()
if v:IsA(c(82,101,109,111,116,101,69,118,101,110,116))then local n=v.Name:lower()
if n:find(c(100,101,116,101,99,116))or n:find(c(102,108,97,103))or n:find(c(114,101,112,111,114,116))or n:find(c(107,105,99,107))or n:find(c(98,97,110))or n:find(c(99,111,109,98,97,116))or n:find(c(108,111,103))or n:find(c(115,116,111,109,112))or n:find(c(114,97,103,100,111,108,108))then
for _,conn in ipairs(getconnections(v.OnClientEvent))do pcall(function()conn:Disable()end)end end end end)end end end end)
pcall(function()if hookmetamethod and newcclosure then local oldNewIndex
oldNewIndex=hookmetamethod(game,c(95,95,110,101,119,105,110,100,101,120),newcclosure(function(self,key,value)
if self:IsA(c(72,117,109,97,110,111,105,100))then
if key==c(87,97,108,107,83,112,101,101,100)and value<16 then return oldNewIndex(self,key,16)end
if key==c(74,117,109,112,80,111,119,101,114)and value<50 then return oldNewIndex(self,key,50)end end
return oldNewIndex(self,key,value)end))end end)
game:GetService(c(83,116,97,114,116,101,114,71,117,105)):SetCore(c(83,101,110,100,78,111,116,105,102,105,99,97,116,105,111,110),{
Title=c(65,67,32,66,121,112,97,115,115),Text=c(65,100,118,97,110,99,101,100,32,98,121,112,97,115,115,32,97,99,116,105,118,101),Duration=3})
end end)

-- ALL LOGIC
local flying,ncOn=false,false
local flyBV,flyBG,flyC,ncC,godC,espC,fcC,avoidC,slowC,fogC,brightC,hitboxC,spinC
local keys={}local spdA=false;local origFog,origAmb
local fcYaw,fcPitch=0,0;local fcPos=Vector3.zero

UIS.InputBegan:Connect(function(i,g)if not g and i.KeyCode then keys[i.KeyCode]=true
local kn=i.KeyCode.Name
if kn==CFG.toggleKey then Main.Visible=not Main.Visible end
if CFG.flyKey~=c()and kn==CFG.flyKey then tFly.toggle()end
if CFG.noclipKey~=c()and kn==CFG.noclipKey then tNoclip.toggle()end
if CFG.freecamKey~=c()and kn==CFG.freecamKey then tFreecam.toggle()end
if CFG.godKey~=c()and kn==CFG.godKey then tGod.toggle()end
if CFG.espKey~=c()and kn==CFG.espKey then tESP.toggle()end
if CFG.touchFlingKey~=c()and kn==CFG.touchFlingKey then FL.touchFling()end
if CFG.flingAllKey~=c()and kn==CFG.flingAllKey then FL.flingAll()end end end)

UIS.InputEnded:Connect(function(i)if i.KeyCode then keys[i.KeyCode]=nil end
if i.UserInputType==Enum.UserInputType.MouseButton1 or i.UserInputType==Enum.UserInputType.Touch then
for _,s in ipairs(sliders)do s.dragging=false end end end)

UIS.InputChanged:Connect(function(i)
if i.UserInputType==Enum.UserInputType.MouseMovement or i.UserInputType==Enum.UserInputType.Touch then
for _,s in ipairs(sliders)do if s.dragging then
local r=math.clamp((i.Position.X-s.bg.AbsolutePosition.X)/s.bg.AbsoluteSize.X,0,1)
s.fill.Size=UDim2.new(r,0,1,0)s.val=math.floor(s.min+r*(s.max-s.min))
s.label.Text=s.name..c(58,32)..s.val;if s.cb then s.cb(s.val)end end end end end)

tFly.on(function(s)if s then local hrp=ghrp()local hum=ghum()
if not hrp or not hum then tFly.set(false)return end;flying=true
if not ncOn then tNoclip.set(true)end;hum.PlatformStand=true
flyBV=Instance.new(c(66,111,100,121,86,101,108,111,99,105,116,121))
flyBV.MaxForce=Vector3.new(math.huge,math.huge,math.huge)flyBV.Velocity=Vector3.zero
flyBV.P=9000;flyBV.Parent=hrp;flyBG=Instance.new(c(66,111,100,121,71,121,114,111))
flyBG.MaxTorque=Vector3.new(math.huge,math.huge,math.huge)flyBG.D=200;flyBG.P=40000;flyBG.Parent=hrp
flyC=RS.Heartbeat:Connect(function()if not flying then return end;pcall(function()
local cf=CAM.CFrame;local d=Vector3.zero
if keys[Enum.KeyCode.W]or keys[Enum.KeyCode.Z]then d=d+cf.LookVector end
if keys[Enum.KeyCode.S]then d=d-cf.LookVector end
if keys[Enum.KeyCode.A]or keys[Enum.KeyCode.Q]then d=d-cf.RightVector end
if keys[Enum.KeyCode.D]then d=d+cf.RightVector end
if keys[Enum.KeyCode.E]or keys[Enum.KeyCode.Space]then d=d+Vector3.yAxis end
if keys[Enum.KeyCode.C]or keys[Enum.KeyCode.LeftShift]then d=d-Vector3.yAxis end
flyBV.Velocity=d.Magnitude>0 and d.Unit*sFlySpd.val or Vector3.zero;flyBG.CFrame=cf end)end)
else flying=false;if flyC then flyC:Disconnect()flyC=nil end
pcall(function()if flyBV then flyBV:Destroy()end end)
pcall(function()if flyBG then flyBG:Destroy()end end)
pcall(function()ghum().PlatformStand=false end)if ncOn then tNoclip.set(false)end end end)

tNoclip.on(function(s)ncOn=s;if ncC then ncC:Disconnect()ncC=nil end;if s then
ncC=RS.Stepped:Connect(function()pcall(function()local c=gc()if not c then return end
for _,p in ipairs(c:GetDescendants())do if p:IsA(c(66,97,115,101,80,97,114,116))then
p.CanCollide=false end end end)end)end end)

UIS.JumpRequest:Connect(function()if tInfJ.get()then
pcall(function()ghum():ChangeState(Enum.HumanoidStateType.Jumping)end)end end)

tGod.on(function(s)if godC then godC:Disconnect()godC=nil end;if s then
godC=RS.Heartbeat:Connect(function()pcall(function()local h=ghum()
if h then h.Health=h.MaxHealth end;local hrp=ghrp()if hrp then
hrp.Velocity=Vector3.new(math.clamp(hrp.Velocity.X,-100,100),math.clamp(hrp.Velocity.Y,-100,100),math.clamp(hrp.Velocity.Z,-100,100))end end)end)end end)

tAntiVoid.on(function(s)if avoidC then avoidC:Disconnect()avoidC=nil end;if s then
avoidC=RS.Heartbeat:Connect(function()pcall(function()local hrp=ghrp()
if hrp and hrp.Position.Y<-50 then hrp.CFrame=CFrame.new(hrp.Position.X,50,hrp.Position.Z)
hrp.Velocity=Vector3.zero end end)end)end end)

tSpin.on(function(s)if spinC then spinC:Disconnect()spinC=nil end
pcall(function()local hrp=ghrp()if hrp then for _,v in ipairs(hrp:GetChildren())do
if v.Name==c(65,86,83,80,73,78)then v:Destroy()end end end end)if s then local hrp=ghrp()
if hrp then local bav=Instance.new(c(66,111,100,121,65,110,103,117,108,97,114,86,101,108,111,99,105,116,121))
bav.Name=c(65,86,83,80,73,78)bav.MaxTorque=Vector3.new(0,math.huge,0)
bav.AngularVelocity=Vector3.new(0,sSpinSpd.val,0)bav.P=500;bav.Parent=hrp
spinC=RS.Heartbeat:Connect(function()pcall(function()
local b=ghrp()and ghrp():FindFirstChild(c(65,86,83,80,73,78))
if b then b.AngularVelocity=Vector3.new(0,sSpinSpd.val,0)end end)end)end end end)

tHitbox.on(function(s)if hitboxC then hitboxC:Disconnect()hitboxC=nil end;if s then
hitboxC=RS.Stepped:Connect(function()pcall(function()local sz=sHitbox.val
for _,p in ipairs(PL:GetPlayers())do if p~=LP and p.Character then
local head=p.Character:FindFirstChild(c(72,101,97,100))if head then
head.Size=Vector3.new(sz,sz,sz)head.Transparency=0.5;head.CanCollide=false
head.Massless=true;head.Material=Enum.Material.ForceField
local mesh=head:FindFirstChildOfClass(c(83,112,101,99,105,97,108,77,101,115,104))
if mesh then mesh:Destroy()end end end end end)end)
else pcall(function()for _,p in ipairs(PL:GetPlayers())do if p~=LP and p.Character then
local head=p.Character:FindFirstChild(c(72,101,97,100))if head then
head.Size=Vector3.new(2,1,1)head.Transparency=0;head.Material=Enum.Material.Plastic end end end end)end end)

-- ESP
tESP.on(function(s)if espC then espC:Disconnect()espC=nil end;if s then
local function cleanESP(c)if c then local e=c:FindFirstChild(c(65,86,69,83,80))
if e then e:Destroy()end;local head=c:FindFirstChild(c(72,101,97,100))
if head then local n=head:FindFirstChild(c(65,86,69,83,80,78))if n then n:Destroy()end end end end
local function applyESP(p)pcall(function()if p==LP then return end;local c=p.Character
if not c then return end;local espColor=C.W;pcall(function()
if p.Team and p.TeamColor then espColor=p.TeamColor.Color end end)
local esp=c:FindFirstChild(c(65,86,69,83,80))if not esp then
esp=Instance.new(c(72,105,103,104,108,105,103,104,116))esp.Name=c(65,86,69,83,80)
esp.FillTransparency=0.8;esp.Parent=c end;esp.FillColor=espColor;esp.OutlineColor=espColor
local head=c:FindFirstChild(c(72,101,97,100))if not head then return end
local espN=head:FindFirstChild(c(65,86,69,83,80,78))if not espN then
espN=Instance.new(c(66,105,108,108,98,111,97,114,100,71,117,105))espN.Name=c(65,86,69,83,80,78)
espN.Parent=head;espN.Size=UDim2.new(0,200,0,30)espN.StudsOffset=Vector3.new(0,2.5,0)
espN.AlwaysOnTop=true;espN.MaxDistance=1000
local nl=Instance.new(c(84,101,120,116,76,97,98,101,108),espN)nl.Name=c(78,97,109,101,76)
nl.BackgroundTransparency=1;nl.Size=UDim2.new(1,0,0.5,0)nl.Font=Enum.Font.GothamBold
nl.TextStrokeTransparency=0.5;nl.TextStrokeColor3=Color3.new(0,0,0)nl.TextSize=14
local dl=Instance.new(c(84,101,120,116,76,97,98,101,108),espN)dl.Name=c(68,105,115,116,76)
dl.BackgroundTransparency=1;dl.Size=UDim2.new(1,0,0.5,0)dl.Position=UDim2.new(0,0,0.5,0)
dl.Font=Enum.Font.Gotham;dl.TextColor3=C.D;dl.TextStrokeTransparency=0.5
dl.TextStrokeColor3=Color3.new(0,0,0)dl.TextSize=10 end
local nameL=espN:FindFirstChild(c(78,97,109,101,76))if nameL then
nameL.TextColor3=espColor;nameL.Text=p.DisplayName end
if ghrp()and head then local distL=espN:FindFirstChild(c(68,105,115,116,76))if distL then
local dist=math.floor((ghrp().Position-head.Position).Magnitude)
local hum2=c:FindFirstChildOfClass(c(72,117,109,97,110,111,105,100))
local hp=hum2 and math.floor(hum2.Health)or 0
distL.Text=c(72,80,58,32)..hp..c(32,124,32)..dist..c(109)end end end)end
for _,p in ipairs(PL:GetPlayers())do if p~=LP then pcall(function()
p.CharacterAdded:Connect(function()task.wait(1)if tESP.get()then applyESP(p)end end)end)end end
PL.PlayerAdded:Connect(function(p)if p~=LP then task.wait(2)if tESP.get()then applyESP(p)end
p.CharacterAdded:Connect(function()task.wait(1)if tESP.get()then applyESP(p)end end)end end)
PL.PlayerRemoving:Connect(function(p)pcall(function()cleanESP(p.Character)end)end)
espC=RS.Heartbeat:Connect(function()for _,p in ipairs(PL:GetPlayers())do
if p~=LP then applyESP(p)end end end)
else for _,p in ipairs(PL:GetPlayers())do pcall(function()local c=p.Character;if c then
local e=c:FindFirstChild(c(65,86,69,83,80))if e then e:Destroy()end
local head=c:FindFirstChild(c(72,101,97,100))if head then
local n=head:FindFirstChild(c(65,86,69,83,80,78))if n then n:Destroy()end end end end)end end end)

tFullbright.on(function(s)if brightC then brightC:Disconnect()brightC=nil end;if s then
origAmb=LG.Ambient;brightC=RS.Heartbeat:Connect(function()pcall(function()
LG.Ambient=Color3.new(1,1,1)LG.Brightness=2;LG.OutdoorAmbient=Color3.new(1,1,1)end)end)
else pcall(function()if origAmb then LG.Ambient=origAmb end;LG.Brightness=1 end)end end)

tNoFog.on(function(s)if fogC then fogC:Disconnect()fogC=nil end;if s then origFog=LG.FogEnd
fogC=RS.Heartbeat:Connect(function()pcall(function()LG.FogEnd=1e9 end)end)
else pcall(function()if origFog then LG.FogEnd=origFog end end)end end)

tAntiSlow.on(function(s)if slowC then slowC:Disconnect()slowC=nil end;if s then
slowC=RS.Heartbeat:Connect(function()pcall(function()local h=ghum()
if h and h.WalkSpeed<16 then h.WalkSpeed=spdA and sSpd.val or 16 end end)end)end end)

tAntiAfk.on(function(s)if s then pcall(function()if getconnections then
for _,c in ipairs(getconnections(LP.Idled))do c:Disable()end end end)end end)

tFreecam.on(function(s)if fcC then fcC:Disconnect()fcC=nil end;if s then pcall(function()
local cf=CAM.CFrame;fcPos=cf.Position;local _,y,_=cf:ToEulerAnglesYXZ()fcYaw=y;fcPitch=0
CAM.CameraType=Enum.CameraType.Scriptable;UIS.MouseBehavior=Enum.MouseBehavior.LockCenter
local h=ghum()if h then h.WalkSpeed=0 end end)
fcC=RS.RenderStepped:Connect(function(dt)pcall(function()local delta=UIS:GetMouseDelta()
fcYaw=fcYaw-delta.X*0.004;fcPitch=math.clamp(fcPitch-delta.Y*0.004,-1.4,1.4)
local rot=CFrame.Angles(0,fcYaw,0)*CFrame.Angles(fcPitch,0,0)local speed=60*dt;local d=Vector3.zero
if keys[Enum.KeyCode.W]or keys[Enum.KeyCode.Z]then d=d+rot.LookVector end
if keys[Enum.KeyCode.S]then d=d-rot.LookVector end
if keys[Enum.KeyCode.A]or keys[Enum.KeyCode.Q]then d=d-rot.RightVector end
if keys[Enum.KeyCode.D]then d=d+rot.RightVector end
if keys[Enum.KeyCode.E]or keys[Enum.KeyCode.Space]then d=d+Vector3.yAxis end
if keys[Enum.KeyCode.C]or keys[Enum.KeyCode.LeftShift]then d=d-Vector3.yAxis end
if d.Magnitude>0 then fcPos=fcPos+d.Unit*speed end;CAM.CFrame=CFrame.new(fcPos)*rot
UIS.MouseBehavior=Enum.MouseBehavior.LockCenter end)end)
else pcall(function()CAM.CameraType=Enum.CameraType.Custom
UIS.MouseBehavior=Enum.MouseBehavior.Default;CAM.CameraSubject=gc():FindFirstChildOfClass(c(72,117,109,97,110,111,105,100))
local h=ghum()if h then h.WalkSpeed=spdA and sSpd.val or 16 end end)end end)

-- AIMBOT
local aimCache=nil;local aimCacheTime=0
local function GetAimTarget()local now=tick()
if now-aimCacheTime<0.05 and aimCache and aimCache.Parent then return aimCache end;aimCacheTime=now
local best,bd=nil,AIM.fov;local m=UIS:GetMouseLocation()
if AIM.tgtP then for _,p in ipairs(PL:GetPlayers())do if p~=LP and p.Character then
if not(AIM.team and p.Team and p.Team==LP.Team)then pcall(function()
local h=p.Character:FindFirstChildOfClass(c(72,117,109,97,110,111,105,100))
if not h or h.Health<=0 then return end;local head=p.Character:FindFirstChild(c(72,101,97,100))
if not head then return end;local sp,on=CAM:WorldToViewportPoint(head.Position)if not on then return end
local d=(Vector2.new(sp.X,sp.Y)-m).Magnitude;if d<bd then
if AIM.wall and not LOS(CAM.CFrame.Position,head.Position)then return end;best=head;bd=d end end)end end end end
if AIM.tgtN then for _,v in ipairs(WS:GetChildren())do pcall(function()
if v:IsA(c(77,111,100,101,108))and v~=gc()and not PL:GetPlayerFromCharacter(v)then
local h=v:FindFirstChildOfClass(c(72,117,109,97,110,111,105,100))if h and h.Health>0 then
local head=v:FindFirstChild(c(72,101,97,100))or v:FindFirstChild(c(72,117,109,97,110,111,105,100,82,111,111,116,80,97,114,116))
if head then local sp,on=CAM:WorldToViewportPoint(head.Position)if on then
local d=(Vector2.new(sp.X,sp.Y)-m).Magnitude;if d<bd then
if AIM.wall and not LOS(CAM.CFrame.Position,head.Position)then return end;best=head;bd=d end end end end end end)end end
aimCache=best;return best end

RS.RenderStepped:Connect(function()if FC then pcall(function()local m=UIS:GetMouseLocation()
FC.Visible=AIM.showFov and AIM.on;if FC.Visible then FC.Position=Vector2.new(m.X,m.Y)FC.Radius=AIM.fov end end)end
if AIM.on then pcall(function()if UIS:IsMouseButtonPressed(Enum.UserInputType.MouseButton2)then
local t=GetAimTarget()if t and t.Parent then local ap=t.Position;if AIM.pred then
local vel=t.AssemblyLinearVelocity;if vel then ap=ap+vel*AIM.predV end end
if AIM.smooth then CAM.CFrame=CAM.CFrame:Lerp(CFrame.new(CAM.CFrame.Position,ap),AIM.smoothV)
else CAM.CFrame=CFrame.new(CAM.CFrame.Position,ap)end end end end)end end)

-- AUTOCLICK
local clickActive=false
tAutoClick.on(function(s)clickActive=s;if s then task.spawn(function()local VIM
pcall(function()VIM=game:GetService(c(86,105,114,116,117,97,108,73,110,112,117,116,77,97,110,97,103,101,114))end)
if not VIM then pcall(function()VIM=game:FindService(c(86,105,114,116,117,97,108,73,110,112,117,116,77,97,110,97,103,101,114))end)end
if not VIM then pcall(function()if cloneref then VIM=cloneref(game:GetService(c(86,105,114,116,117,97,108,73,110,112,117,116,77,97,110,97,103,101,114)))end end)end
local useVIM=VIM~=nil;while clickActive do local shouldClick=true
if tClickHold.get()then shouldClick=UIS:IsMouseButtonPressed(Enum.UserInputType.MouseButton1)end
if shouldClick then local mx,my=MOUSE.X,MOUSE.Y;local button=tClickRight.get()and 1 or 0
if useVIM then pcall(function()VIM:SendMouseButtonEvent(mx,my,button,true,game,0)end)task.wait(0.016)
pcall(function()VIM:SendMouseButtonEvent(mx,my,button,false,game,0)end)
else pcall(function()if mouse1click then mouse1click()end end)end end
local cps=math.max(sClickSpd.val,1)local baseDelay=1/cps;local jitterPct=sClickJitter.val/100
if jitterPct>0 then baseDelay=baseDelay+(math.random()-0.5)*2*baseDelay*jitterPct
baseDelay=math.max(baseDelay,0.01)end;task.wait(baseDelay)end end)end end)

sSpd.cb=function(v)spdA=v~=16;pcall(function()ghum().WalkSpeed=v end)end
sFov.cb=function(v)pcall(function()CAM.FieldOfView=v end)end
RS.Heartbeat:Connect(function()pcall(function()local h=ghum()
if h and not tFreecam.get()then if spdA then h.WalkSpeed=sSpd.val end end end)end)
LP.CharacterAdded:Connect(function()if flying then tFly.set(false)end
if ncOn then tNoclip.set(false)end;if tFreecam.get()then tFreecam.set(false)end
if tSpin.get()then tSpin.set(false)end;FL.stop()task.wait(2)FL.busy=false end)

stab(c(77,111,118,101))
game:GetService(c(83,116,97,114,116,101,114,71,117,105)):SetCore(c(83,101,110,100,78,111,116,105,102,105,99,97,116,105,111,110),{
Title=c(65,118,111,99,97,116,32,72,117,98),
Text=c(86,49,46,48,32,108,111,97,100,101,100,32,45,32,80,114,111,116,101,99,116,101,100,32,97,117,32,109,97,120,105,109,117,109,32,58,41),
Duration=4})
