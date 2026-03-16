local Players = game:GetService("Players");
local TweenService = game:GetService("TweenService");
local UIS = game:GetService("UserInputService");
local CoreGui = game:GetService("CoreGui");
local RunService = game:GetService("RunService");
local WS = game:GetService("Workspace");
local RS = game:GetService("ReplicatedStorage");
local TS = game:GetService("TeleportService");
local HS = game:GetService("HttpService");
local Lighting = game:GetService("Lighting");
local lp = Players.LocalPlayer;
local cam = WS.CurrentCamera;
local mouse = lp:GetMouse();
pcall(function()
	if CoreGui:FindFirstChild("AvocatHub") then
		CoreGui:FindFirstChild("AvocatHub"):Destroy();
	end
end);
pcall(function()
	settings().Physics.AllowSleep = false;
end);
pcall(function()
	settings().Physics.PhysicsEnvironmentalThrottle = Enum.EnviromentalPhysicsThrottle.Disabled;
end);
local SKEY = "AvocatHubCFG";
local DEF = {toggleKey="RightShift",flyKey="F5",noclipKey="N",freecamKey="F6",godKey="G",espKey="",touchFlingKey="T",flingAllKey="",infJumpKey="",antiVoidKey="",fullbrightKey="",noFogKey="",antiAfkKey="",antiSlowKey="",autoload=false};
local function loadCFG()
	local FlatIdent_378D0 = 0;
	local s;
	while true do
		if (FlatIdent_378D0 == 1) then
			if not s then
				s = {};
			end
			for k, v in pairs(DEF) do
				if (s[k] == nil) then
					s[k] = v;
				end
			end
			FlatIdent_378D0 = 2;
		end
		if (FlatIdent_378D0 == 2) then
			return s;
		end
		if (FlatIdent_378D0 == 0) then
			s = nil;
			pcall(function()
				if readfile then
					s = HS:JSONDecode(readfile(SKEY .. ".json"));
				end
			end);
			FlatIdent_378D0 = 1;
		end
	end
end
local function saveCFG(s)
	pcall(function()
		if writefile then
			writefile(SKEY .. ".json", HS:JSONEncode(s));
		end
	end);
end
local CFG = loadCFG();
local gui = Instance.new("ScreenGui");
gui.Name = "AvocatHub";
gui.ZIndexBehavior = Enum.ZIndexBehavior.Sibling;
gui.ResetOnSpawn = false;
gui.Parent = lp:WaitForChild("PlayerGui");
local C = {Bg=Color3.fromRGB(10, 10, 10),Bg2=Color3.fromRGB(18, 18, 18),Bg3=Color3.fromRGB(28, 28, 28),Ac=Color3.fromRGB(48, 48, 48),AcH=Color3.fromRGB(62, 62, 62),AcL=Color3.fromRGB(35, 35, 35),W=Color3.fromRGB(255, 255, 255),D=Color3.fromRGB(130, 130, 130),R=Color3.fromRGB(160, 35, 35),RH=Color3.fromRGB(200, 50, 50)};
local AIM = {on=false,fov=150,showFov=true,smooth=false,smoothV=0.15,pred=false,predV=0.165,team=false,wall=false,tgtP=true,tgtN=false};
local FC;
pcall(function()
	FC = Drawing.new("Circle");
	FC.Radius = 150;
	FC.Color = C.W;
	FC.Thickness = 1.5;
	FC.Filled = false;
	FC.Visible = false;
end);
local RP_AIM = RaycastParams.new();
RP_AIM.FilterType = Enum.RaycastFilterType.Exclude;
local function LOS(o, t)
	local FlatIdent_12703 = 0;
	local r;
	while true do
		if (FlatIdent_12703 == 0) then
			RP_AIM.FilterDescendantsInstances = {(lp.Character or {})};
			r = WS:Raycast(o, t - o, RP_AIM);
			FlatIdent_12703 = 1;
		end
		if (FlatIdent_12703 == 1) then
			return not r or (r.Distance >= ((t - o).Magnitude * 0.95));
		end
	end
end
local function gc()
	return lp.Character;
end
local function ghrp()
	local FlatIdent_475BC = 0;
	local c;
	while true do
		if (FlatIdent_475BC == 0) then
			c = gc();
			return c and c:FindFirstChild("HumanoidRootPart");
		end
	end
end
local function ghum()
	local FlatIdent_60EA1 = 0;
	local c;
	while true do
		if (FlatIdent_60EA1 == 0) then
			c = gc();
			return c and c:FindFirstChildOfClass("Humanoid");
		end
	end
end
local function rc(p, r)
	Instance.new("UICorner", p).CornerRadius = UDim.new(0, r or 6);
end
local function mkb(p, t, col)
	local FlatIdent_31A5A = 0;
	local b;
	while true do
		if (FlatIdent_31A5A == 2) then
			b.TextSize = 11;
			b.AutoButtonColor = false;
			b.Text = t;
			FlatIdent_31A5A = 3;
		end
		if (3 == FlatIdent_31A5A) then
			b.Parent = p;
			rc(b);
			return b;
		end
		if (FlatIdent_31A5A == 1) then
			b.Size = UDim2.new(1, 0, 0, 28);
			b.Font = Enum.Font.Gotham;
			b.TextColor3 = C.W;
			FlatIdent_31A5A = 2;
		end
		if (FlatIdent_31A5A == 0) then
			b = Instance.new("TextButton");
			b.BackgroundColor3 = col or C.Ac;
			b.BorderSizePixel = 0;
			FlatIdent_31A5A = 1;
		end
	end
end
local function hfx(b, ba, ho)
	b.MouseEnter:Connect(function()
		TweenService:Create(b, TweenInfo.new(0.08), {BackgroundColor3=ho}):Play();
	end);
	b.MouseLeave:Connect(function()
		TweenService:Create(b, TweenInfo.new(0.08), {BackgroundColor3=ba}):Play();
	end);
end
local function sep(p, o)
	local FlatIdent_61B23 = 0;
	local s;
	while true do
		if (FlatIdent_61B23 == 1) then
			s.BackgroundColor3 = C.Ac;
			s.BorderSizePixel = 0;
			FlatIdent_61B23 = 2;
		end
		if (2 == FlatIdent_61B23) then
			s.Size = UDim2.new(1, 0, 0, 1);
			s.LayoutOrder = o;
			break;
		end
		if (FlatIdent_61B23 == 0) then
			s = Instance.new("Frame");
			s.Parent = p;
			FlatIdent_61B23 = 1;
		end
	end
end
local function lbl(p, t, o)
	local FlatIdent_40CF = 0;
	local l;
	while true do
		if (FlatIdent_40CF == 2) then
			l.Font = Enum.Font.GothamBold;
			l.TextColor3 = C.D;
			FlatIdent_40CF = 3;
		end
		if (FlatIdent_40CF == 1) then
			l.BackgroundTransparency = 1;
			l.Size = UDim2.new(1, 0, 0, 18);
			FlatIdent_40CF = 2;
		end
		if (FlatIdent_40CF == 0) then
			l = Instance.new("TextLabel");
			l.Parent = p;
			FlatIdent_40CF = 1;
		end
		if (FlatIdent_40CF == 4) then
			l.Text = "  " .. t;
			l.LayoutOrder = o;
			break;
		end
		if (FlatIdent_40CF == 3) then
			l.TextSize = 10;
			l.TextXAlignment = Enum.TextXAlignment.Left;
			FlatIdent_40CF = 4;
		end
	end
end
local function mscr(p, pos, sz)
	local FlatIdent_33EA4 = 0;
	local sf;
	local pd;
	local l;
	while true do
		if (FlatIdent_33EA4 == 1) then
			sf.BackgroundColor3 = C.Bg2;
			sf.BorderSizePixel = 0;
			sf.Position = pos;
			FlatIdent_33EA4 = 2;
		end
		if (FlatIdent_33EA4 == 6) then
			l.Padding = UDim.new(0, 2);
			l:GetPropertyChangedSignal("AbsoluteContentSize"):Connect(function()
				sf.CanvasSize = UDim2.new(0, 0, 0, l.AbsoluteContentSize.Y + 8);
			end);
			return sf;
		end
		if (FlatIdent_33EA4 == 0) then
			sf = Instance.new("ScrollingFrame");
			sf.Parent = p;
			sf.Active = true;
			FlatIdent_33EA4 = 1;
		end
		if (FlatIdent_33EA4 == 3) then
			sf.CanvasSize = UDim2.new(0, 0, 0, 0);
			rc(sf, 8);
			pd = Instance.new("UIPadding", sf);
			FlatIdent_33EA4 = 4;
		end
		if (FlatIdent_33EA4 == 4) then
			pd.PaddingTop = UDim.new(0, 4);
			pd.PaddingBottom = UDim.new(0, 4);
			pd.PaddingLeft = UDim.new(0, 4);
			FlatIdent_33EA4 = 5;
		end
		if (FlatIdent_33EA4 == 2) then
			sf.Size = sz;
			sf.ScrollBarThickness = 3;
			sf.ScrollBarImageColor3 = C.Ac;
			FlatIdent_33EA4 = 3;
		end
		if (FlatIdent_33EA4 == 5) then
			pd.PaddingRight = UDim.new(0, 4);
			l = Instance.new("UIListLayout", sf);
			l.SortOrder = Enum.SortOrder.LayoutOrder;
			FlatIdent_33EA4 = 6;
		end
	end
end
local sliders = {};
local function mkSlider(p, name, mn, mx, def, o)
	local f = Instance.new("Frame");
	f.Parent = p;
	f.BackgroundColor3 = C.Bg;
	f.BorderSizePixel = 0;
	f.Size = UDim2.new(1, 0, 0, 34);
	f.LayoutOrder = o;
	rc(f);
	local lb = Instance.new("TextLabel", f);
	lb.BackgroundTransparency = 1;
	lb.Position = UDim2.new(0, 8, 0, 0);
	lb.Size = UDim2.new(1, -16, 0, 16);
	lb.Font = Enum.Font.Gotham;
	lb.TextColor3 = C.D;
	lb.TextSize = 10;
	lb.TextXAlignment = Enum.TextXAlignment.Left;
	lb.Text = name .. ": " .. def;
	local bg = Instance.new("Frame", f);
	bg.BackgroundColor3 = C.Bg2;
	bg.BorderSizePixel = 0;
	bg.Position = UDim2.new(0, 8, 0, 19);
	bg.Size = UDim2.new(1, -16, 0, 10);
	rc(bg, 4);
	local fl = Instance.new("Frame", bg);
	fl.BackgroundColor3 = C.Ac;
	fl.BorderSizePixel = 0;
	fl.Size = UDim2.new(math.clamp((def - mn) / (mx - mn), 0, 1), 0, 1, 0);
	rc(fl, 4);
	local s = {bg=bg,fill=fl,label=lb,name=name,min=mn,max=mx,val=def,dragging=false,cb=nil};
	bg.InputBegan:Connect(function(i)
		if ((i.UserInputType == Enum.UserInputType.MouseButton1) or (i.UserInputType == Enum.UserInputType.Touch)) then
			s.dragging = true;
		end
	end);
	table.insert(sliders, s);
	return s;
end
local allToggles = {};
local function mkToggle(p, name, o, cfgK)
	local f = Instance.new("Frame");
	f.Parent = p;
	f.BackgroundColor3 = C.Bg;
	f.BorderSizePixel = 0;
	f.Size = UDim2.new(1, 0, 0, 26);
	f.LayoutOrder = o;
	rc(f);
	local lb = Instance.new("TextLabel", f);
	lb.BackgroundTransparency = 1;
	lb.Position = UDim2.new(0, 8, 0, 0);
	lb.Size = UDim2.new(1, -100, 1, 0);
	lb.Font = Enum.Font.Gotham;
	lb.TextColor3 = C.W;
	lb.TextSize = 11;
	lb.TextXAlignment = Enum.TextXAlignment.Left;
	lb.Text = name;
	local kl = Instance.new("TextLabel", f);
	kl.BackgroundTransparency = 1;
	kl.Position = UDim2.new(1, -96, 0, 0);
	kl.Size = UDim2.new(0, 46, 1, 0);
	kl.Font = Enum.Font.Gotham;
	kl.TextColor3 = C.D;
	kl.TextSize = 8;
	kl.TextXAlignment = Enum.TextXAlignment.Right;
	local ks = (cfgK and CFG[cfgK]) or "";
	kl.Text = ((ks ~= "") and ("[" .. ks .. "]")) or "";
	local b = Instance.new("TextButton", f);
	b.BackgroundColor3 = C.Bg2;
	b.BorderSizePixel = 0;
	b.Position = UDim2.new(1, -44, 0, 3);
	b.Size = UDim2.new(0, 36, 0, 20);
	b.Font = Enum.Font.GothamBold;
	b.TextColor3 = C.D;
	b.TextSize = 9;
	b.Text = "OFF";
	b.AutoButtonColor = false;
	rc(b, 4);
	local st = false;
	local cb = nil;
	local function tog()
		local FlatIdent_6B983 = 0;
		while true do
			if (FlatIdent_6B983 == 2) then
				if cb then
					cb(st);
				end
				break;
			end
			if (FlatIdent_6B983 == 1) then
				TweenService:Create(b, TweenInfo.new(0.12), {BackgroundColor3=((st and C.Ac) or C.Bg2)}):Play();
				b.TextColor3 = (st and C.W) or C.D;
				FlatIdent_6B983 = 2;
			end
			if (FlatIdent_6B983 == 0) then
				st = not st;
				b.Text = (st and "ON") or "OFF";
				FlatIdent_6B983 = 1;
			end
		end
	end
	b.MouseButton1Click:Connect(tog);
	local obj = {set=function(s)
		if (s ~= st) then
			tog();
		end
	end,get=function()
		return st;
	end,on=function(c)
		cb = c;
	end,toggle=tog,cfgKey=cfgK,updateKeyLabel=function()
		local FlatIdent_2D88C = 0;
		local k;
		while true do
			if (FlatIdent_2D88C == 0) then
				k = (cfgK and CFG[cfgK]) or "";
				kl.Text = ((k ~= "") and ("[" .. k .. "]")) or "";
				break;
			end
		end
	end};
	table.insert(allToggles, obj);
	return obj;
end
local Main = Instance.new("Frame");
Main.Parent = gui;
Main.Active = true;
Main.BackgroundColor3 = C.Bg;
Main.BorderSizePixel = 0;
Main.AnchorPoint = Vector2.new(0.5, 0.5);
Main.Position = UDim2.new(0.5, 0, 0.5, 0);
Main.Size = UDim2.new(0, 0, 0, 0);
Main.ClipsDescendants = true;
rc(Main, 10);
Instance.new("UIStroke", Main).Color = C.Ac;
TweenService:Create(Main, TweenInfo.new(0.4, Enum.EasingStyle.Back), {Size=UDim2.new(0, 380, 0, 470)}):Play();
task.wait(0.3);
local Top = Instance.new("Frame");
Top.Parent = Main;
Top.BackgroundColor3 = C.Bg2;
Top.BorderSizePixel = 0;
Top.Size = UDim2.new(1, 0, 0, 30);
rc(Top, 10);
local ttl = Instance.new("TextLabel", Top);
ttl.BackgroundTransparency = 1;
ttl.Position = UDim2.new(0, 10, 0, 0);
ttl.Size = UDim2.new(0.6, 0, 1, 0);
ttl.Font = Enum.Font.GothamBold;
ttl.Text = "Avocat Hub";
ttl.TextColor3 = C.W;
ttl.TextSize = 13;
ttl.TextXAlignment = Enum.TextXAlignment.Left;
local xB = Instance.new("TextButton", Top);
xB.BackgroundColor3 = C.Bg2;
xB.BorderSizePixel = 0;
xB.Position = UDim2.new(1, -28, 0, 0);
xB.Size = UDim2.new(0, 28, 0, 30);
xB.Font = Enum.Font.GothamBold;
xB.Text = "X";
xB.TextColor3 = C.D;
xB.TextSize = 11;
xB.AutoButtonColor = false;
rc(xB, 6);
xB.MouseButton1Click:Connect(function()
	local FlatIdent_D79D = 0;
	while true do
		if (0 == FlatIdent_D79D) then
			TweenService:Create(Main, TweenInfo.new(0.3, Enum.EasingStyle.Back, Enum.EasingDirection.In), {Size=UDim2.new(0, 0, 0, 0)}):Play();
			task.wait(0.35);
			FlatIdent_D79D = 1;
		end
		if (FlatIdent_D79D == 1) then
			gui:Destroy();
			break;
		end
	end
end);
hfx(xB, C.Bg2, C.R);
local mBt = Instance.new("TextButton", Top);
mBt.BackgroundColor3 = C.Bg2;
mBt.BorderSizePixel = 0;
mBt.Position = UDim2.new(1, -52, 0, 0);
mBt.Size = UDim2.new(0, 24, 0, 30);
mBt.Font = Enum.Font.GothamBold;
mBt.Text = "-";
mBt.TextColor3 = C.D;
mBt.TextSize = 14;
mBt.AutoButtonColor = false;
local mni = false;
mBt.MouseButton1Click:Connect(function()
	mni = not mni;
	TweenService:Create(Main, TweenInfo.new(0.15), {Size=((mni and UDim2.new(0, 380, 0, 30)) or UDim2.new(0, 380, 0, 470))}):Play();
	mBt.Text = (mni and "+") or "-";
end);
local tabN = {"Move","Combat","Players","Tools","Ext","Config"};
local tbs, pgs = {}, {};
local tabF = Instance.new("Frame", Main);
tabF.BackgroundTransparency = 1;
tabF.Position = UDim2.new(0, 4, 0, 33);
tabF.Size = UDim2.new(1, -8, 0, 22);
for i, n in ipairs(tabN) do
	local FlatIdent_28F1 = 0;
	local t;
	while true do
		if (FlatIdent_28F1 == 3) then
			t.AutoButtonColor = false;
			rc(t);
			tbs[n] = t;
			break;
		end
		if (FlatIdent_28F1 == 0) then
			t = Instance.new("TextButton", tabF);
			t.BackgroundColor3 = ((i == 1) and C.Ac) or C.Bg2;
			t.BorderSizePixel = 0;
			FlatIdent_28F1 = 1;
		end
		if (FlatIdent_28F1 == 2) then
			t.Text = n;
			t.TextColor3 = ((i == 1) and C.W) or C.D;
			t.TextSize = 9;
			FlatIdent_28F1 = 3;
		end
		if (FlatIdent_28F1 == 1) then
			t.Position = UDim2.new((i - 1) / #tabN, 1, 0, 0);
			t.Size = UDim2.new(1 / #tabN, -2, 1, 0);
			t.Font = Enum.Font.GothamBold;
			FlatIdent_28F1 = 2;
		end
	end
end
local function stab(name)
	local FlatIdent_7F121 = 0;
	while true do
		if (FlatIdent_7F121 == 0) then
			for n, t in pairs(tbs) do
				local FlatIdent_206F8 = 0;
				local s;
				while true do
					if (FlatIdent_206F8 == 1) then
						t.TextColor3 = (s and C.W) or C.D;
						break;
					end
					if (0 == FlatIdent_206F8) then
						s = n == name;
						TweenService:Create(t, TweenInfo.new(0.12), {BackgroundColor3=((s and C.Ac) or C.Bg2)}):Play();
						FlatIdent_206F8 = 1;
					end
				end
			end
			for n, p in pairs(pgs) do
				p.Visible = n == name;
			end
			break;
		end
	end
end
for n, t in pairs(tbs) do
	t.MouseButton1Click:Connect(function()
		stab(n);
	end);
end
local cY = 58;
local drag, ds, dp = false, nil, nil;
Main.InputBegan:Connect(function(i)
	if ((i.UserInputType == Enum.UserInputType.MouseButton1) or (i.UserInputType == Enum.UserInputType.Touch)) then
		drag = true;
		ds = i.Position;
		dp = Main.Position;
		i.Changed:Connect(function()
			if (i.UserInputState == Enum.UserInputState.End) then
				drag = false;
			end
		end);
	end
end);
UIS.InputChanged:Connect(function(i)
	if (drag and ((i.UserInputType == Enum.UserInputType.MouseMovement) or (i.UserInputType == Enum.UserInputType.Touch))) then
		local FlatIdent_466B2 = 0;
		local d;
		while true do
			if (FlatIdent_466B2 == 0) then
				d = i.Position - ds;
				Main.Position = UDim2.new(dp.X.Scale, dp.X.Offset + d.X, dp.Y.Scale, dp.Y.Offset + d.Y);
				break;
			end
		end
	end
end);
local mvP = Instance.new("Frame", Main);
mvP.BackgroundTransparency = 1;
mvP.Position = UDim2.new(0, 0, 0, cY);
mvP.Size = UDim2.new(1, 0, 1, -cY);
mvP.Visible = true;
pgs['Move'] = mvP;
local mvS = mscr(mvP, UDim2.new(0, 4, 0, 0), UDim2.new(1, -8, 1, -4));
lbl(mvS, "MOVEMENT", 1);
local tFly = mkToggle(mvS, "Fly", 2, "flyKey");
local sFlySpd = mkSlider(mvS, "Fly Speed", 10, 300, 80, 3);
local tNoclip = mkToggle(mvS, "Noclip", 4, "noclipKey");
local tInfJ = mkToggle(mvS, "Infinite Jump", 5, "infJumpKey");
local sSpd = mkSlider(mvS, "WalkSpeed", 16, 500, 16, 6);
local tSpin = mkToggle(mvS, "Spin", 7);
local sSpinSpd = mkSlider(mvS, "Spin Speed", 1, 100, 20, 8);
sep(mvS, 9);
lbl(mvS, "CAMERA", 10);
local tFreecam = mkToggle(mvS, "Freecam", 11, "freecamKey");
local sFov = mkSlider(mvS, "FOV", 70, 120, 70, 12);
sep(mvS, 13);
lbl(mvS, "TELEPORT", 14);
local tpFrame = Instance.new("Frame", mvS);
tpFrame.BackgroundColor3 = C.Bg;
tpFrame.BorderSizePixel = 0;
tpFrame.Size = UDim2.new(1, 0, 0, 56);
tpFrame.LayoutOrder = 15;
rc(tpFrame);
local tpPad = Instance.new("UIPadding", tpFrame);
tpPad.PaddingLeft = UDim.new(0, 6);
tpPad.PaddingRight = UDim.new(0, 6);
tpPad.PaddingTop = UDim.new(0, 4);
local tpLbl = Instance.new("TextLabel", tpFrame);
tpLbl.BackgroundTransparency = 1;
tpLbl.Size = UDim2.new(1, 0, 0, 14);
tpLbl.Font = Enum.Font.Gotham;
tpLbl.TextColor3 = C.D;
tpLbl.TextSize = 9;
tpLbl.TextXAlignment = Enum.TextXAlignment.Left;
tpLbl.Text = "Coordinates X Y Z";
local tpX = Instance.new("TextBox", tpFrame);
tpX.BackgroundColor3 = C.Bg2;
tpX.BorderSizePixel = 0;
tpX.Position = UDim2.new(0, 0, 0, 18);
tpX.Size = UDim2.new(0.25, -4, 0, 26);
tpX.Font = Enum.Font.Gotham;
tpX.PlaceholderText = "X";
tpX.PlaceholderColor3 = C.D;
tpX.Text = "";
tpX.TextColor3 = C.W;
tpX.TextSize = 11;
rc(tpX, 4);
local tpY = Instance.new("TextBox", tpFrame);
tpY.BackgroundColor3 = C.Bg2;
tpY.BorderSizePixel = 0;
tpY.Position = UDim2.new(0.25, 2, 0, 18);
tpY.Size = UDim2.new(0.25, -4, 0, 26);
tpY.Font = Enum.Font.Gotham;
tpY.PlaceholderText = "Y";
tpY.PlaceholderColor3 = C.D;
tpY.Text = "";
tpY.TextColor3 = C.W;
tpY.TextSize = 11;
rc(tpY, 4);
local tpZ = Instance.new("TextBox", tpFrame);
tpZ.BackgroundColor3 = C.Bg2;
tpZ.BorderSizePixel = 0;
tpZ.Position = UDim2.new(0.5, 2, 0, 18);
tpZ.Size = UDim2.new(0.25, -4, 0, 26);
tpZ.Font = Enum.Font.Gotham;
tpZ.PlaceholderText = "Z";
tpZ.PlaceholderColor3 = C.D;
tpZ.Text = "";
tpZ.TextColor3 = C.W;
tpZ.TextSize = 11;
rc(tpZ, 4);
local tpGo = Instance.new("TextButton", tpFrame);
tpGo.BackgroundColor3 = C.Ac;
tpGo.BorderSizePixel = 0;
tpGo.Position = UDim2.new(0.75, 2, 0, 18);
tpGo.Size = UDim2.new(0.25, -2, 0, 26);
tpGo.Font = Enum.Font.GothamBold;
tpGo.Text = "TP";
tpGo.TextColor3 = C.W;
tpGo.TextSize = 11;
tpGo.AutoButtonColor = false;
rc(tpGo, 4);
hfx(tpGo, C.Ac, C.AcH);
tpGo.MouseButton1Click:Connect(function()
	pcall(function()
		local hrp = ghrp();
		if hrp then
			hrp.CFrame = CFrame.new(tonumber(tpX.Text) or 0, tonumber(tpY.Text) or 0, tonumber(tpZ.Text) or 0);
		end
	end);
end);
local tpCopy = mkb(mvS, "Copy Position", C.Bg);
tpCopy.LayoutOrder = 16;
tpCopy.Font = Enum.Font.Gotham;
tpCopy.TextSize = 10;
hfx(tpCopy, C.Bg, C.Ac);
tpCopy.MouseButton1Click:Connect(function()
	pcall(function()
		local FlatIdent_1A54 = 0;
		local hrp;
		while true do
			if (0 == FlatIdent_1A54) then
				hrp = ghrp();
				if hrp then
					local p = hrp.Position;
					tpX.Text = tostring(math.floor(p.X));
					tpY.Text = tostring(math.floor(p.Y));
					tpZ.Text = tostring(math.floor(p.Z));
					pcall(function()
						if setclipboard then
							setclipboard(math.floor(p.X) .. "," .. math.floor(p.Y) .. "," .. math.floor(p.Z));
						end
					end);
				end
				break;
			end
		end
	end);
end);
local cbP = Instance.new("Frame", Main);
cbP.BackgroundTransparency = 1;
cbP.Position = UDim2.new(0, 0, 0, cY);
cbP.Size = UDim2.new(1, 0, 1, -cY);
cbP.Visible = false;
pgs['Combat'] = cbP;
local cbS = mscr(cbP, UDim2.new(0, 4, 0, 0), UDim2.new(1, -8, 1, -4));
lbl(cbS, "DEFENSE", 1);
local tGod = mkToggle(cbS, "God Mode", 2, "godKey");
local tAntiVoid = mkToggle(cbS, "Anti Void", 3, "antiVoidKey");
sep(cbS, 4);
lbl(cbS, "HITBOX", 5);
local tHitbox = mkToggle(cbS, "Hitbox Expander", 6);
local sHitbox = mkSlider(cbS, "Hitbox Size", 1, 20, 5, 7);
sep(cbS, 8);
lbl(cbS, "AIM & CLICK", 9);
local aimOpenBtn = mkb(cbS, "Aimbot Settings", C.Bg);
aimOpenBtn.LayoutOrder = 10;
aimOpenBtn.Font = Enum.Font.GothamBold;
hfx(aimOpenBtn, C.Bg, C.Ac);
local clickOpenBtn = mkb(cbS, "AutoClick Settings", C.Bg);
clickOpenBtn.LayoutOrder = 11;
clickOpenBtn.Font = Enum.Font.GothamBold;
hfx(clickOpenBtn, C.Bg, C.Ac);
sep(cbS, 12);
lbl(cbS, "VISUALS", 13);
local tESP = mkToggle(cbS, "ESP", 14, "espKey");
local tFullbright = mkToggle(cbS, "Fullbright", 15, "fullbrightKey");
local tNoFog = mkToggle(cbS, "No Fog", 16, "noFogKey");
sep(cbS, 17);
lbl(cbS, "AC BYPASS", 18);
local tAdonis = mkToggle(cbS, "AC Bypass", 19);
sep(cbS, 20);
lbl(cbS, "MISC", 21);
local tAntiAfk = mkToggle(cbS, "Anti AFK", 22, "antiAfkKey");
local tAntiSlow = mkToggle(cbS, "Anti Slowdown", 23, "antiSlowKey");
local aimPanel = Instance.new("Frame");
aimPanel.Parent = gui;
aimPanel.BackgroundColor3 = C.Bg;
aimPanel.BorderSizePixel = 0;
aimPanel.AnchorPoint = Vector2.new(0.5, 0.5);
aimPanel.Position = UDim2.new(0.5, 200, 0.5, -60);
aimPanel.Size = UDim2.new(0, 0, 0, 0);
aimPanel.ClipsDescendants = true;
aimPanel.Visible = false;
aimPanel.Active = true;
rc(aimPanel, 10);
Instance.new("UIStroke", aimPanel).Color = C.Ac;
local aimTop = Instance.new("Frame", aimPanel);
aimTop.BackgroundColor3 = C.Bg2;
aimTop.BorderSizePixel = 0;
aimTop.Size = UDim2.new(1, 0, 0, 28);
rc(aimTop, 10);
local aimTtl = Instance.new("TextLabel", aimTop);
aimTtl.BackgroundTransparency = 1;
aimTtl.Position = UDim2.new(0, 10, 0, 0);
aimTtl.Size = UDim2.new(1, -40, 1, 0);
aimTtl.Font = Enum.Font.GothamBold;
aimTtl.Text = "Aimbot Settings";
aimTtl.TextColor3 = C.W;
aimTtl.TextSize = 11;
aimTtl.TextXAlignment = Enum.TextXAlignment.Left;
local aimX = Instance.new("TextButton", aimTop);
aimX.BackgroundColor3 = C.Bg2;
aimX.BorderSizePixel = 0;
aimX.Position = UDim2.new(1, -26, 0, 0);
aimX.Size = UDim2.new(0, 26, 0, 28);
aimX.Font = Enum.Font.GothamBold;
aimX.Text = "X";
aimX.TextColor3 = C.D;
aimX.TextSize = 10;
aimX.AutoButtonColor = false;
rc(aimX, 6);
hfx(aimX, C.Bg2, C.R);
local aimScr = mscr(aimPanel, UDim2.new(0, 4, 0, 32), UDim2.new(1, -8, 1, -36));
local tAimbot = mkToggle(aimScr, "Aimbot", 1);
local tShowFov = mkToggle(aimScr, "Show FOV Circle", 2);
local tAimSmooth = mkToggle(aimScr, "Smoothing", 3);
local tAimPred = mkToggle(aimScr, "Prediction", 4);
local tAimTeam = mkToggle(aimScr, "Team Check", 5);
local tAimWall = mkToggle(aimScr, "Wall Check", 6);
sep(aimScr, 7);
lbl(aimScr, "TARGETING", 8);
local tTgtPlayers = mkToggle(aimScr, "Target Players", 9);
local tTgtNPCs = mkToggle(aimScr, "Target NPCs", 10);
sep(aimScr, 11);
lbl(aimScr, "VALUES", 12);
local sAimFov = mkSlider(aimScr, "FOV", 10, 800, 150, 13);
local sAimSmooth = mkSlider(aimScr, "Smoothing", 1, 100, 15, 14);
local sAimPred = mkSlider(aimScr, "Prediction", 1, 100, 16, 15);
local aimInfo = Instance.new("TextLabel", aimScr);
aimInfo.BackgroundColor3 = C.Bg;
aimInfo.Size = UDim2.new(1, 0, 0, 20);
aimInfo.LayoutOrder = 16;
aimInfo.Font = Enum.Font.Gotham;
aimInfo.TextColor3 = C.D;
aimInfo.TextSize = 9;
aimInfo.Text = "  Right click = aim nearest head";
aimInfo.TextXAlignment = Enum.TextXAlignment.Left;
rc(aimInfo);
tTgtPlayers.set(true);
tAimbot.on(function(s)
	local FlatIdent_61800 = 0;
	while true do
		if (FlatIdent_61800 == 0) then
			AIM.on = s;
			if FC then
				pcall(function()
					FC.Visible = AIM.showFov and s;
				end);
			end
			break;
		end
	end
end);
tShowFov.on(function(s)
	AIM.showFov = s;
	if FC then
		pcall(function()
			FC.Visible = s and AIM.on;
		end);
	end
end);
tAimSmooth.on(function(s)
	AIM.smooth = s;
end);
tAimPred.on(function(s)
	AIM.pred = s;
end);
tAimTeam.on(function(s)
	AIM.team = s;
end);
tAimWall.on(function(s)
	AIM.wall = s;
end);
tTgtPlayers.on(function(s)
	AIM.tgtP = s;
end);
tTgtNPCs.on(function(s)
	AIM.tgtN = s;
end);
sAimFov.cb = function(v)
	local FlatIdent_90A41 = 0;
	while true do
		if (FlatIdent_90A41 == 0) then
			AIM.fov = v;
			if FC then
				pcall(function()
					FC.Radius = v;
				end);
			end
			break;
		end
	end
end;
sAimSmooth.cb = function(v)
	AIM.smoothV = v / 100;
end;
sAimPred.cb = function(v)
	AIM.predV = v / 100;
end;
local aimPO = false;
local function toggleAim()
	local FlatIdent_6D9D2 = 0;
	while true do
		if (FlatIdent_6D9D2 == 0) then
			aimPO = not aimPO;
			if aimPO then
				local FlatIdent_6225E = 0;
				while true do
					if (FlatIdent_6225E == 0) then
						aimPanel.Visible = true;
						TweenService:Create(aimPanel, TweenInfo.new(0.3, Enum.EasingStyle.Back), {Size=UDim2.new(0, 260, 0, 420)}):Play();
						break;
					end
				end
			else
				TweenService:Create(aimPanel, TweenInfo.new(0.2, Enum.EasingStyle.Back, Enum.EasingDirection.In), {Size=UDim2.new(0, 0, 0, 0)}):Play();
				task.wait(0.25);
				aimPanel.Visible = false;
			end
			break;
		end
	end
end
aimOpenBtn.MouseButton1Click:Connect(toggleAim);
aimX.MouseButton1Click:Connect(toggleAim);
local aimDr, aimDS, aimDP = false, nil, nil;
aimTop.InputBegan:Connect(function(i)
	if ((i.UserInputType == Enum.UserInputType.MouseButton1) or (i.UserInputType == Enum.UserInputType.Touch)) then
		aimDr = true;
		aimDS = i.Position;
		aimDP = aimPanel.Position;
		i.Changed:Connect(function()
			if (i.UserInputState == Enum.UserInputState.End) then
				aimDr = false;
			end
		end);
	end
end);
UIS.InputChanged:Connect(function(i)
	if (aimDr and ((i.UserInputType == Enum.UserInputType.MouseMovement) or (i.UserInputType == Enum.UserInputType.Touch))) then
		local FlatIdent_21DDC = 0;
		local d;
		while true do
			if (FlatIdent_21DDC == 0) then
				d = i.Position - aimDS;
				aimPanel.Position = UDim2.new(aimDP.X.Scale, aimDP.X.Offset + d.X, aimDP.Y.Scale, aimDP.Y.Offset + d.Y);
				break;
			end
		end
	end
end);
local clickPanel = Instance.new("Frame");
clickPanel.Parent = gui;
clickPanel.BackgroundColor3 = C.Bg;
clickPanel.BorderSizePixel = 0;
clickPanel.AnchorPoint = Vector2.new(0.5, 0.5);
clickPanel.Position = UDim2.new(0.5, 200, 0.5, 120);
clickPanel.Size = UDim2.new(0, 0, 0, 0);
clickPanel.ClipsDescendants = true;
clickPanel.Visible = false;
clickPanel.Active = true;
rc(clickPanel, 10);
Instance.new("UIStroke", clickPanel).Color = C.Ac;
local clickTop = Instance.new("Frame", clickPanel);
clickTop.BackgroundColor3 = C.Bg2;
clickTop.BorderSizePixel = 0;
clickTop.Size = UDim2.new(1, 0, 0, 28);
rc(clickTop, 10);
local clickTtl = Instance.new("TextLabel", clickTop);
clickTtl.BackgroundTransparency = 1;
clickTtl.Position = UDim2.new(0, 10, 0, 0);
clickTtl.Size = UDim2.new(1, -40, 1, 0);
clickTtl.Font = Enum.Font.GothamBold;
clickTtl.Text = "AutoClick Settings";
clickTtl.TextColor3 = C.W;
clickTtl.TextSize = 11;
clickTtl.TextXAlignment = Enum.TextXAlignment.Left;
local clickXBtn = Instance.new("TextButton", clickTop);
clickXBtn.BackgroundColor3 = C.Bg2;
clickXBtn.BorderSizePixel = 0;
clickXBtn.Position = UDim2.new(1, -26, 0, 0);
clickXBtn.Size = UDim2.new(0, 26, 0, 28);
clickXBtn.Font = Enum.Font.GothamBold;
clickXBtn.Text = "X";
clickXBtn.TextColor3 = C.D;
clickXBtn.TextSize = 10;
clickXBtn.AutoButtonColor = false;
rc(clickXBtn, 6);
hfx(clickXBtn, C.Bg2, C.R);
local clickScr = mscr(clickPanel, UDim2.new(0, 4, 0, 32), UDim2.new(1, -8, 1, -36));
local tAutoClick = mkToggle(clickScr, "Auto Click", 1);
local tClickHold = mkToggle(clickScr, "Hold Mode", 2);
local tClickRight = mkToggle(clickScr, "Right Click", 3);
local sClickSpd = mkSlider(clickScr, "Speed (CPS)", 1, 100, 10, 4);
local sClickJitter = mkSlider(clickScr, "Jitter (%)", 0, 50, 0, 5);
sep(clickScr, 6);
lbl(clickScr, "INFO", 7);
local clkI1 = Instance.new("TextLabel", clickScr);
clkI1.BackgroundColor3 = C.Bg;
clkI1.Size = UDim2.new(1, 0, 0, 20);
clkI1.LayoutOrder = 8;
clkI1.Font = Enum.Font.Gotham;
clkI1.TextColor3 = C.D;
clkI1.TextSize = 9;
clkI1.Text = "  Auto = continuous clicking";
clkI1.TextXAlignment = Enum.TextXAlignment.Left;
rc(clkI1);
local clkI2 = Instance.new("TextLabel", clickScr);
clkI2.BackgroundColor3 = C.Bg;
clkI2.Size = UDim2.new(1, 0, 0, 20);
clkI2.LayoutOrder = 9;
clkI2.Font = Enum.Font.Gotham;
clkI2.TextColor3 = C.D;
clkI2.TextSize = 9;
clkI2.Text = "  Hold = click while mouse held";
clkI2.TextXAlignment = Enum.TextXAlignment.Left;
rc(clkI2);
local clkI3 = Instance.new("TextLabel", clickScr);
clkI3.BackgroundColor3 = C.Bg;
clkI3.Size = UDim2.new(1, 0, 0, 20);
clkI3.LayoutOrder = 10;
clkI3.Font = Enum.Font.Gotham;
clkI3.TextColor3 = C.D;
clkI3.TextSize = 9;
clkI3.Text = "  CPS = clicks per second";
clkI3.TextXAlignment = Enum.TextXAlignment.Left;
rc(clkI3);
local clickPO = false;
local function toggleClick()
	local FlatIdent_FA88 = 0;
	while true do
		if (FlatIdent_FA88 == 0) then
			clickPO = not clickPO;
			if clickPO then
				local FlatIdent_580CB = 0;
				while true do
					if (FlatIdent_580CB == 0) then
						clickPanel.Visible = true;
						TweenService:Create(clickPanel, TweenInfo.new(0.3, Enum.EasingStyle.Back), {Size=UDim2.new(0, 260, 0, 310)}):Play();
						break;
					end
				end
			else
				local FlatIdent_20FE3 = 0;
				while true do
					if (FlatIdent_20FE3 == 1) then
						clickPanel.Visible = false;
						break;
					end
					if (FlatIdent_20FE3 == 0) then
						TweenService:Create(clickPanel, TweenInfo.new(0.2, Enum.EasingStyle.Back, Enum.EasingDirection.In), {Size=UDim2.new(0, 0, 0, 0)}):Play();
						task.wait(0.25);
						FlatIdent_20FE3 = 1;
					end
				end
			end
			break;
		end
	end
end
clickOpenBtn.MouseButton1Click:Connect(toggleClick);
clickXBtn.MouseButton1Click:Connect(toggleClick);
local clickDr, clickDS, clickDP = false, nil, nil;
clickTop.InputBegan:Connect(function(i)
	if ((i.UserInputType == Enum.UserInputType.MouseButton1) or (i.UserInputType == Enum.UserInputType.Touch)) then
		local FlatIdent_8ABD6 = 0;
		while true do
			if (FlatIdent_8ABD6 == 0) then
				clickDr = true;
				clickDS = i.Position;
				FlatIdent_8ABD6 = 1;
			end
			if (FlatIdent_8ABD6 == 1) then
				clickDP = clickPanel.Position;
				i.Changed:Connect(function()
					if (i.UserInputState == Enum.UserInputState.End) then
						clickDr = false;
					end
				end);
				break;
			end
		end
	end
end);
UIS.InputChanged:Connect(function(i)
	if (clickDr and ((i.UserInputType == Enum.UserInputType.MouseMovement) or (i.UserInputType == Enum.UserInputType.Touch))) then
		local d = i.Position - clickDS;
		clickPanel.Position = UDim2.new(clickDP.X.Scale, clickDP.X.Offset + d.X, clickDP.Y.Scale, clickDP.Y.Offset + d.Y);
	end
end);
local selPlayer = nil;
local jP = Instance.new("Frame", Main);
jP.BackgroundTransparency = 1;
jP.Position = UDim2.new(0, 0, 0, cY);
jP.Size = UDim2.new(1, 0, 1, -cY);
jP.Visible = false;
pgs['Players'] = jP;
local jSt = Instance.new("TextLabel", jP);
jSt.BackgroundColor3 = C.Bg2;
jSt.BorderSizePixel = 0;
jSt.Position = UDim2.new(0, 4, 0, 0);
jSt.Size = UDim2.new(1, -8, 0, 20);
jSt.Font = Enum.Font.GothamBold;
jSt.Text = "Idle";
jSt.TextColor3 = C.D;
jSt.TextSize = 10;
rc(jSt);
local jBtnFrame = Instance.new("Frame", jP);
jBtnFrame.BackgroundTransparency = 1;
jBtnFrame.Position = UDim2.new(0, 4, 0, 24);
jBtnFrame.Size = UDim2.new(1, -8, 0, 26);
local jBO = {};
for i, n in ipairs({"Stop","Fling All","Touch","Unspec"}) do
	local FlatIdent_2E34E = 0;
	local key;
	local b;
	while true do
		if (FlatIdent_2E34E == 3) then
			hfx(b, ((n == "Stop") and C.R) or C.Ac, ((n == "Stop") and C.RH) or C.AcH);
			jBO[key] = b;
			break;
		end
		if (FlatIdent_2E34E == 1) then
			b.Position = UDim2.new((i - 1) / 4, 1, 0, 0);
			b.Size = UDim2.new(1 / 4, -2, 1, 0);
			FlatIdent_2E34E = 2;
		end
		if (FlatIdent_2E34E == 0) then
			key = ((n == "Fling All") and "All") or n;
			b = mkb(jBtnFrame, n, ((n == "Stop") and C.R) or C.Ac);
			FlatIdent_2E34E = 1;
		end
		if (FlatIdent_2E34E == 2) then
			b.Font = Enum.Font.GothamBold;
			b.TextSize = 9;
			FlatIdent_2E34E = 3;
		end
	end
end
jBO['Unspec'].MouseButton1Click:Connect(function()
	local FlatIdent_42BD8 = 0;
	while true do
		if (FlatIdent_42BD8 == 1) then
			jSt.Text = "Idle";
			jSt.TextColor3 = C.D;
			break;
		end
		if (FlatIdent_42BD8 == 0) then
			pcall(function()
				cam.CameraSubject = gc():FindFirstChildOfClass("Humanoid");
			end);
			selPlayer = nil;
			FlatIdent_42BD8 = 1;
		end
	end
end);
local jSearch = Instance.new("TextBox", jP);
jSearch.BackgroundColor3 = C.Bg2;
jSearch.BorderSizePixel = 0;
jSearch.Position = UDim2.new(0, 4, 0, 54);
jSearch.Size = UDim2.new(1, -8, 0, 22);
jSearch.Font = Enum.Font.Gotham;
jSearch.PlaceholderText = "Search player...";
jSearch.PlaceholderColor3 = C.D;
jSearch.Text = "";
jSearch.TextColor3 = C.W;
jSearch.TextSize = 10;
jSearch.ClearTextOnFocus = false;
rc(jSearch);
local jScr = mscr(jP, UDim2.new(0, 4, 0, 80), UDim2.new(1, -8, 1, -116));
local jRef = mkb(jP, "Refresh", C.Ac);
jRef.Position = UDim2.new(0, 4, 1, -32);
jRef.Size = UDim2.new(1, -8, 0, 28);
jRef.Font = Enum.Font.GothamBold;
hfx(jRef, C.Ac, C.AcH);
local oP = Instance.new("Frame", Main);
oP.BackgroundTransparency = 1;
oP.Position = UDim2.new(0, 0, 0, cY);
oP.Size = UDim2.new(1, 0, 1, -cY);
oP.Visible = false;
pgs['Tools'] = oP;
local oSr = Instance.new("TextBox", oP);
oSr.BackgroundColor3 = C.Bg2;
oSr.BorderSizePixel = 0;
oSr.Position = UDim2.new(0, 4, 0, 0);
oSr.Size = UDim2.new(1, -8, 0, 24);
oSr.Font = Enum.Font.Gotham;
oSr.PlaceholderText = "Search...";
oSr.PlaceholderColor3 = C.D;
oSr.Text = "";
oSr.TextColor3 = C.W;
oSr.TextSize = 11;
oSr.ClearTextOnFocus = false;
rc(oSr);
local oScr = mscr(oP, UDim2.new(0, 4, 0, 28), UDim2.new(1, -8, 1, -64));
local oRf = mkb(oP, "Refresh", C.Ac);
oRf.Position = UDim2.new(0, 4, 1, -32);
oRf.Size = UDim2.new(1, -8, 0, 28);
oRf.Font = Enum.Font.GothamBold;
hfx(oRf, C.Ac, C.AcH);
local extP = Instance.new("Frame", Main);
extP.BackgroundTransparency = 1;
extP.Position = UDim2.new(0, 0, 0, cY);
extP.Size = UDim2.new(1, 0, 1, -cY);
extP.Visible = false;
pgs['Ext'] = extP;
local extS = mscr(extP, UDim2.new(0, 4, 0, 0), UDim2.new(1, -8, 1, -4));
lbl(extS, "SCRIPTS", 1);
local function extBtn(name, url, o)
	local FlatIdent_869A9 = 0;
	local b;
	while true do
		if (FlatIdent_869A9 == 2) then
			b.MouseButton1Click:Connect(function()
				local FlatIdent_69C4C = 0;
				while true do
					if (FlatIdent_69C4C == 0) then
						b.Text = "...";
						task.spawn(function()
							local FlatIdent_8B272 = 0;
							local ok;
							while true do
								if (0 == FlatIdent_8B272) then
									ok = pcall(function()
										loadstring(game:HttpGet(url))();
									end);
									b.Text = (ok and (name .. " [OK]")) or (name .. " [FAIL]");
									FlatIdent_8B272 = 1;
								end
								if (FlatIdent_8B272 == 1) then
									task.wait(2);
									b.Text = name;
									break;
								end
							end
						end);
						break;
					end
				end
			end);
			break;
		end
		if (FlatIdent_869A9 == 1) then
			b.Font = Enum.Font.GothamBold;
			hfx(b, C.Bg, C.Ac);
			FlatIdent_869A9 = 2;
		end
		if (FlatIdent_869A9 == 0) then
			b = mkb(extS, name, C.Bg);
			b.LayoutOrder = o;
			FlatIdent_869A9 = 1;
		end
	end
end
extBtn("Infinite Yield", "https://raw.githubusercontent.com/EdgeIY/infiniteyield/master/source", 2);
extBtn("Dex Explorer", "https://raw.githubusercontent.com/peyton2465/Dex/master/out.lua", 3);
extBtn("Simple Spy", "https://raw.githubusercontent.com/exxtremestuffs/SimpleSpySource/master/SimpleSpy.lua", 4);
extBtn("Dark Dex", "https://raw.githubusercontent.com/Babyhamsta/RBLX_Scripts/main/Universal/DarkDex.lua", 5);
sep(extS, 6);
lbl(extS, "LOAD SCRIPT", 7);
local extUrlF = Instance.new("Frame", extS);
extUrlF.BackgroundColor3 = C.Bg;
extUrlF.BorderSizePixel = 0;
extUrlF.Size = UDim2.new(1, 0, 0, 34);
extUrlF.LayoutOrder = 8;
rc(extUrlF);
local extUP = Instance.new("UIPadding", extUrlF);
extUP.PaddingLeft = UDim.new(0, 4);
extUP.PaddingRight = UDim.new(0, 4);
extUP.PaddingTop = UDim.new(0, 4);
local extUrl = Instance.new("TextBox", extUrlF);
extUrl.BackgroundColor3 = C.Bg2;
extUrl.BorderSizePixel = 0;
extUrl.Size = UDim2.new(0.75, -4, 0, 26);
extUrl.Font = Enum.Font.Gotham;
extUrl.PlaceholderText = "https://...";
extUrl.PlaceholderColor3 = C.D;
extUrl.Text = "";
extUrl.TextColor3 = C.W;
extUrl.TextSize = 10;
extUrl.ClearTextOnFocus = false;
rc(extUrl, 4);
local extRun = Instance.new("TextButton", extUrlF);
extRun.BackgroundColor3 = C.Ac;
extRun.BorderSizePixel = 0;
extRun.Position = UDim2.new(0.75, 2, 0, 0);
extRun.Size = UDim2.new(0.25, -2, 0, 26);
extRun.Font = Enum.Font.GothamBold;
extRun.Text = "Run";
extRun.TextColor3 = C.W;
extRun.TextSize = 11;
extRun.AutoButtonColor = false;
rc(extRun, 4);
hfx(extRun, C.Ac, C.AcH);
extRun.MouseButton1Click:Connect(function()
	local FlatIdent_7873D = 0;
	local url;
	while true do
		if (1 == FlatIdent_7873D) then
			extRun.Text = "...";
			task.spawn(function()
				local FlatIdent_92F66 = 0;
				local ok;
				while true do
					if (FlatIdent_92F66 == 1) then
						task.wait(2);
						extRun.Text = "Run";
						break;
					end
					if (FlatIdent_92F66 == 0) then
						ok = pcall(function()
							loadstring(game:HttpGet(url))();
						end);
						extRun.Text = (ok and "OK") or "Fail";
						FlatIdent_92F66 = 1;
					end
				end
			end);
			break;
		end
		if (FlatIdent_7873D == 0) then
			url = extUrl.Text;
			if (url == "") then
				return;
			end
			FlatIdent_7873D = 1;
		end
	end
end);
sep(extS, 9);
lbl(extS, "EXECUTE CODE", 10);
local extCF = Instance.new("Frame", extS);
extCF.BackgroundColor3 = C.Bg;
extCF.BorderSizePixel = 0;
extCF.Size = UDim2.new(1, 0, 0, 86);
extCF.LayoutOrder = 11;
rc(extCF);
local extCP = Instance.new("UIPadding", extCF);
extCP.PaddingLeft = UDim.new(0, 4);
extCP.PaddingRight = UDim.new(0, 4);
extCP.PaddingTop = UDim.new(0, 4);
local extCode = Instance.new("TextBox", extCF);
extCode.BackgroundColor3 = C.Bg2;
extCode.BorderSizePixel = 0;
extCode.Size = UDim2.new(1, 0, 0, 50);
extCode.Font = Enum.Font.Code;
extCode.PlaceholderText = "code...";
extCode.PlaceholderColor3 = C.D;
extCode.Text = "";
extCode.TextColor3 = C.W;
extCode.TextSize = 10;
extCode.ClearTextOnFocus = false;
extCode.MultiLine = true;
extCode.TextWrapped = true;
extCode.TextYAlignment = Enum.TextYAlignment.Top;
rc(extCode, 4);
local extExec = Instance.new("TextButton", extCF);
extExec.BackgroundColor3 = C.Ac;
extExec.BorderSizePixel = 0;
extExec.Position = UDim2.new(0, 0, 0, 54);
extExec.Size = UDim2.new(1, 0, 0, 26);
extExec.Font = Enum.Font.GothamBold;
extExec.Text = "Execute";
extExec.TextColor3 = C.W;
extExec.TextSize = 11;
extExec.AutoButtonColor = false;
rc(extExec, 4);
hfx(extExec, C.Ac, C.AcH);
extExec.MouseButton1Click:Connect(function()
	local FlatIdent_94AF7 = 0;
	local code;
	while true do
		if (FlatIdent_94AF7 == 0) then
			code = extCode.Text;
			if (code == "") then
				return;
			end
			FlatIdent_94AF7 = 1;
		end
		if (FlatIdent_94AF7 == 1) then
			extExec.Text = "...";
			task.spawn(function()
				local FlatIdent_6E549 = 0;
				local ok;
				while true do
					if (FlatIdent_6E549 == 1) then
						task.wait(2);
						extExec.Text = "Execute";
						break;
					end
					if (FlatIdent_6E549 == 0) then
						ok = pcall(function()
							loadstring(code)();
						end);
						extExec.Text = (ok and "OK") or "Error";
						FlatIdent_6E549 = 1;
					end
				end
			end);
			break;
		end
	end
end);
local cfP = Instance.new("Frame", Main);
cfP.BackgroundTransparency = 1;
cfP.Position = UDim2.new(0, 0, 0, cY);
cfP.Size = UDim2.new(1, 0, 1, -cY);
cfP.Visible = false;
pgs['Config'] = cfP;
local cfS = mscr(cfP, UDim2.new(0, 4, 0, 0), UDim2.new(1, -8, 1, -4));
lbl(cfS, "KEYBINDS (Backspace = None)", 1);
local function mkKB(p, dn, ck, o)
	local f = Instance.new("Frame");
	f.Parent = p;
	f.BackgroundColor3 = C.Bg;
	f.BorderSizePixel = 0;
	f.Size = UDim2.new(1, 0, 0, 26);
	f.LayoutOrder = o;
	rc(f);
	local lb = Instance.new("TextLabel", f);
	lb.BackgroundTransparency = 1;
	lb.Position = UDim2.new(0, 8, 0, 0);
	lb.Size = UDim2.new(0.55, -8, 1, 0);
	lb.Font = Enum.Font.Gotham;
	lb.TextColor3 = C.W;
	lb.TextSize = 10;
	lb.TextXAlignment = Enum.TextXAlignment.Left;
	lb.Text = dn;
	local kb = Instance.new("TextButton", f);
	kb.BackgroundColor3 = C.Bg2;
	kb.BorderSizePixel = 0;
	kb.Position = UDim2.new(0.55, 2, 0, 3);
	kb.Size = UDim2.new(0.45, -10, 0, 20);
	kb.Font = Enum.Font.GothamBold;
	kb.TextColor3 = C.D;
	kb.TextSize = 9;
	kb.Text = ((CFG[ck] ~= "") and CFG[ck]) or "None";
	kb.AutoButtonColor = false;
	rc(kb, 4);
	local listening = false;
	kb.MouseButton1Click:Connect(function()
		if listening then
			return;
		end
		listening = true;
		kb.Text = "...";
		kb.TextColor3 = C.W;
		local cn;
		cn = UIS.InputBegan:Connect(function(input, gpe)
			local FlatIdent_D14D = 0;
			while true do
				if (FlatIdent_D14D == 0) then
					if gpe then
						return;
					end
					if ((input.KeyCode == Enum.KeyCode.Backspace) or (input.KeyCode == Enum.KeyCode.Delete)) then
						local FlatIdent_803FB = 0;
						while true do
							if (FlatIdent_803FB == 3) then
								cn:Disconnect();
								break;
							end
							if (FlatIdent_803FB == 0) then
								CFG[ck] = "";
								kb.Text = "None";
								FlatIdent_803FB = 1;
							end
							if (FlatIdent_803FB == 2) then
								for _, t in ipairs(allToggles) do
									t.updateKeyLabel();
								end
								listening = false;
								FlatIdent_803FB = 3;
							end
							if (FlatIdent_803FB == 1) then
								kb.TextColor3 = C.D;
								saveCFG(CFG);
								FlatIdent_803FB = 2;
							end
						end
					elseif (input.KeyCode and (input.KeyCode ~= Enum.KeyCode.Unknown)) then
						local FlatIdent_835BC = 0;
						while true do
							if (FlatIdent_835BC == 2) then
								for _, t in ipairs(allToggles) do
									t.updateKeyLabel();
								end
								listening = false;
								FlatIdent_835BC = 3;
							end
							if (FlatIdent_835BC == 1) then
								kb.TextColor3 = C.D;
								saveCFG(CFG);
								FlatIdent_835BC = 2;
							end
							if (0 == FlatIdent_835BC) then
								CFG[ck] = input.KeyCode.Name;
								kb.Text = input.KeyCode.Name;
								FlatIdent_835BC = 1;
							end
							if (FlatIdent_835BC == 3) then
								cn:Disconnect();
								break;
							end
						end
					end
					break;
				end
			end
		end);
	end);
end
mkKB(cfS, "Toggle GUI", "toggleKey", 2);
mkKB(cfS, "Fly", "flyKey", 3);
mkKB(cfS, "Noclip", "noclipKey", 4);
mkKB(cfS, "Freecam", "freecamKey", 5);
mkKB(cfS, "God Mode", "godKey", 6);
mkKB(cfS, "ESP", "espKey", 7);
mkKB(cfS, "Touch Fling", "touchFlingKey", 8);
mkKB(cfS, "Fling All", "flingAllKey", 9);
sep(cfS, 10);
lbl(cfS, "SETTINGS", 11);
local tAutoload = mkToggle(cfS, "Autoload on Rejoin", 12);
tAutoload.on(function(s)
	CFG.autoload = s;
	saveCFG(CFG);
end);
if CFG.autoload then
	tAutoload.set(true);
end
sep(cfS, 13);
lbl(cfS, "ACTIONS", 14);
local function cBtn(t, o, col)
	local FlatIdent_65194 = 0;
	local b;
	while true do
		if (FlatIdent_65194 == 2) then
			return b;
		end
		if (FlatIdent_65194 == 0) then
			b = mkb(cfS, t, col or C.Bg);
			b.Font = Enum.Font.GothamBold;
			FlatIdent_65194 = 1;
		end
		if (1 == FlatIdent_65194) then
			b.LayoutOrder = o;
			hfx(b, col or C.Bg, C.Ac);
			FlatIdent_65194 = 2;
		end
	end
end
cBtn("Rejoin", 15).MouseButton1Click:Connect(function()
	pcall(function()
		TS:TeleportToPlaceInstance(game.PlaceId, game.JobId, lp);
	end);
end);
cBtn("Reset Character", 16).MouseButton1Click:Connect(function()
	pcall(function()
		ghum().Health = 0;
	end);
end);
cBtn("Server Hop", 17).MouseButton1Click:Connect(function()
	pcall(function()
		local FlatIdent_56F59 = 0;
		local d;
		while true do
			if (FlatIdent_56F59 == 0) then
				d = HS:JSONDecode(game:HttpGet("https://games.roblox.com/v1/games/" .. game.PlaceId .. "/servers/Public?sortOrder=Asc&limit=100"));
				for _, s in ipairs(d.data) do
					if ((s.id ~= game.JobId) and (s.playing < s.maxPlayers)) then
						TS:TeleportToPlaceInstance(game.PlaceId, s.id, lp);
						break;
					end
				end
				break;
			end
		end
	end);
end);
cBtn("Copy Place ID", 18).MouseButton1Click:Connect(function()
	pcall(function()
		setclipboard(tostring(game.PlaceId));
	end);
end);
cBtn("Anti Lag", 19).MouseButton1Click:Connect(function()
	pcall(function()
		local FlatIdent_3121 = 0;
		while true do
			if (FlatIdent_3121 == 2) then
				pcall(function()
					settings().Rendering.QualityLevel = Enum.QualityLevel.Level01;
				end);
				break;
			end
			if (FlatIdent_3121 == 0) then
				for _, v in ipairs(WS:GetDescendants()) do
					pcall(function()
						if (v:IsA("ParticleEmitter") or v:IsA("Trail") or v:IsA("Smoke") or v:IsA("Fire") or v:IsA("Sparkles") or v:IsA("Explosion")) then
							v:Destroy();
						end
					end);
				end
				for _, v in ipairs(Lighting:GetDescendants()) do
					pcall(function()
						if (v:IsA("BloomEffect") or v:IsA("BlurEffect") or v:IsA("SunRaysEffect") or v:IsA("DepthOfFieldEffect")) then
							v:Destroy();
						end
					end);
				end
				FlatIdent_3121 = 1;
			end
			if (FlatIdent_3121 == 1) then
				Lighting.GlobalShadows = false;
				Lighting.FogEnd = 1000000000;
				FlatIdent_3121 = 2;
			end
		end
	end);
end);
cBtn("Destroy GUI", 20, C.R).MouseButton1Click:Connect(function()
	local FlatIdent_5AB84 = 0;
	while true do
		if (FlatIdent_5AB84 == 1) then
			gui:Destroy();
			break;
		end
		if (FlatIdent_5AB84 == 0) then
			TweenService:Create(Main, TweenInfo.new(0.3, Enum.EasingStyle.Back, Enum.EasingDirection.In), {Size=UDim2.new(0, 0, 0, 0)}):Play();
			task.wait(0.35);
			FlatIdent_5AB84 = 1;
		end
	end
end);
local function fTools()
	local FlatIdent_5077 = 0;
	local t;
	local seen;
	local tryAdd;
	local deepScan;
	while true do
		if (FlatIdent_5077 == 1) then
			function deepScan(loc, tag)
				pcall(function()
					for _, v in ipairs(loc:GetDescendants()) do
						pcall(function()
							tryAdd(v, tag);
						end);
					end
				end);
			end
			deepScan(WS, "WS");
			deepScan(RS, "RS");
			pcall(function()
				deepScan(game:GetService("ReplicatedFirst"), "RF");
			end);
			FlatIdent_5077 = 2;
		end
		if (FlatIdent_5077 == 0) then
			t, seen = {}, {};
			tryAdd = nil;
			function tryAdd(v, tag)
				pcall(function()
					if not v:IsA("Tool") then
						return;
					end
					if not v.Parent then
						return;
					end
					local bp = lp:FindFirstChild("Backpack");
					local ch = gc();
					if (bp and (v.Parent == bp)) then
						return;
					end
					if (ch and (v.Parent == ch)) then
						return;
					end
					local k = v.Name .. "_" .. tag .. "_" .. tostring(v:GetFullName());
					if seen[k] then
						return;
					end
					seen[k] = true;
					table.insert(t, {T=v,S=tag});
				end);
			end
			deepScan = nil;
			FlatIdent_5077 = 1;
		end
		if (FlatIdent_5077 == 2) then
			pcall(function()
				deepScan(game:GetService("StarterPack"), "SP");
			end);
			pcall(function()
				deepScan(game:GetService("StarterPlayer"), "SPl");
			end);
			pcall(function()
				deepScan(Lighting, "LT");
			end);
			pcall(function()
				for _, p in ipairs(Players:GetPlayers()) do
					if (p ~= lp) then
						pcall(function()
							if p.Backpack then
								for _, v in ipairs(p.Backpack:GetChildren()) do
									tryAdd(v, "P:" .. p.Name);
								end
							end
						end);
						pcall(function()
							if p.Character then
								for _, v in ipairs(p.Character:GetChildren()) do
									tryAdd(v, "E:" .. p.Name);
								end
							end
						end);
					end
				end
			end);
			FlatIdent_5077 = 3;
		end
		if (3 == FlatIdent_5077) then
			pcall(function()
				if getnilinstances then
					for _, v in ipairs(getnilinstances()) do
						pcall(function()
							if v:IsA("Tool") then
								local k = v.Name .. "_nil_" .. tostring(v);
								if not seen[k] then
									local FlatIdent_84B7E = 0;
									while true do
										if (FlatIdent_84B7E == 0) then
											seen[k] = true;
											table.insert(t, {T=v,S="Nil"});
											break;
										end
									end
								end
							end
						end);
					end
				end
			end);
			pcall(function()
				for _, v in ipairs(game:GetDescendants()) do
					pcall(function()
						if v:IsA("Tool") then
							tryAdd(v, "Game");
						end
					end);
				end
			end);
			return t;
		end
	end
end
local function rTools()
	for _, v in ipairs(oScr:GetChildren()) do
		if v:IsA("TextButton") then
			v:Destroy();
		end
	end
	local tools = fTools();
	local s = oSr.Text:lower();
	local displayed = {};
	table.sort(tools, function(a, b)
		return a.T.Name:lower() < b.T.Name:lower();
	end);
	for _, data in ipairs(tools) do
		pcall(function()
			local FlatIdent_1454F = 0;
			local n;
			local dk;
			while true do
				if (FlatIdent_1454F == 0) then
					n = data.T.Name;
					dk = n:lower() .. "_" .. data.S;
					FlatIdent_1454F = 1;
				end
				if (FlatIdent_1454F == 1) then
					if (not displayed[dk] and ((s == "") or n:lower():find(s, 1, true))) then
						local FlatIdent_37555 = 0;
						local b;
						while true do
							if (FlatIdent_37555 == 1) then
								hfx(b, C.Bg, C.Ac);
								b.MouseButton1Click:Connect(function()
									local FlatIdent_2DB3E = 0;
									local ok;
									while true do
										if (FlatIdent_2DB3E == 1) then
											task.wait(1.5);
											b.Text = n .. " [" .. data.S .. "]";
											FlatIdent_2DB3E = 2;
										end
										if (FlatIdent_2DB3E == 0) then
											ok = pcall(function()
												data.T:Clone().Parent = lp.Backpack;
											end);
											if ok then
												b.Text = n .. " [OK!]";
												b.TextColor3 = Color3.fromRGB(80, 200, 80);
											else
												local FlatIdent_6F99F = 0;
												while true do
													if (FlatIdent_6F99F == 0) then
														b.Text = n .. " [FAIL]";
														b.TextColor3 = C.R;
														break;
													end
												end
											end
											FlatIdent_2DB3E = 1;
										end
										if (2 == FlatIdent_2DB3E) then
											b.TextColor3 = C.W;
											break;
										end
									end
								end);
								break;
							end
							if (FlatIdent_37555 == 0) then
								displayed[dk] = true;
								b = mkb(oScr, n .. " [" .. data.S .. "]", C.Bg);
								FlatIdent_37555 = 1;
							end
						end
					end
					break;
				end
			end
		end);
	end
	oSr.PlaceholderText = "Search... (" .. #tools .. " tools)";
end
oRf.MouseButton1Click:Connect(rTools);
oSr:GetPropertyChangedSignal("Text"):Connect(rTools);
tAdonis.on(function(s)
	if s then
		local acKeywords = {"anticheat","anti_cheat","anti-cheat","cheatdetect","detection","ac_","exploit","security","checker","monitor","watchdog","guard","protect","validate","verify","suspicious","integrity","shield","adonis","mainmodule","hdadmin","hd_admin","kohls","kohl","basicadmin","basic_admin","serverguard","server_guard","cmdbar","adminloader","bsod","antispeed","anti_speed","antifly","anti_fly","antinoclip","anti_noclip","antiteleport","anti_teleport","antifling","anti_fling","speedcheck","flycheck","noclipcheck","tpcheck","flingcheck","prisonlife","prison_life","dahood","da_hood","stomp","combatlogger","combat_logger","ragdolldetect","speeddetect","flingdetect","exploitdetect","noclipdetect","combatlog","teleportcheck","velocitycheck","heightcheck"};
		local remoteKeywords = {"kick","ban","punish","flag","report","detect","violation","security","adonis","hdadmin","anticheat","cuff","tase","arrest","stomp","combatlog","ragdoll","exploitlog","speedlog","flylog","nocliplog","teleportlog"};
		local bindKeywords = {"cheat","kick","ban","detect","flag","security","adonis","hdadmin","stomp","combatlog","exploit","violation"};
		local function matchAC(name)
			local FlatIdent_8A8EC = 0;
			while true do
				if (0 == FlatIdent_8A8EC) then
					for _, kw in ipairs(acKeywords) do
						if name:find(kw) then
							return true;
						end
					end
					return false;
				end
			end
		end
		local function matchRemote(name)
			local FlatIdent_253F0 = 0;
			while true do
				if (0 == FlatIdent_253F0) then
					for _, kw in ipairs(remoteKeywords) do
						if name:find(kw) then
							return true;
						end
					end
					return false;
				end
			end
		end
		local function matchBind(name)
			local FlatIdent_810B1 = 0;
			while true do
				if (FlatIdent_810B1 == 0) then
					for _, kw in ipairs(bindKeywords) do
						if name:find(kw) then
							return true;
						end
					end
					return false;
				end
			end
		end
		pcall(function()
			for _, v in ipairs(game:GetDescendants()) do
				pcall(function()
					if (v:IsA("LocalScript") or v:IsA("ModuleScript")) then
						local FlatIdent_679D2 = 0;
						local n;
						local fn;
						while true do
							if (FlatIdent_679D2 == 1) then
								pcall(function()
									fn = v:GetFullName():lower();
								end);
								if (matchAC(n) or matchAC(fn)) then
									v.Disabled = true;
								end
								break;
							end
							if (FlatIdent_679D2 == 0) then
								n = v.Name:lower();
								fn = "";
								FlatIdent_679D2 = 1;
							end
						end
					end
				end);
			end
		end);
		pcall(function()
			if getconnections then
				for _, c in ipairs(getconnections(lp.Idled)) do
					pcall(function()
						c:Disable();
					end);
				end
			end
		end);
		pcall(function()
			if getconnections then
				for _, v in ipairs(game:GetDescendants()) do
					pcall(function()
						if (v:IsA("RemoteEvent") or v:IsA("RemoteFunction")) then
							local FlatIdent_322B4 = 0;
							local n;
							while true do
								if (FlatIdent_322B4 == 0) then
									n = v.Name:lower();
									if matchRemote(n) then
										local FlatIdent_9851B = 0;
										while true do
											if (FlatIdent_9851B == 0) then
												if v:IsA("RemoteEvent") then
													for _, conn in ipairs(getconnections(v.OnClientEvent)) do
														pcall(function()
															conn:Disable();
														end);
													end
												end
												if (v:IsA("RemoteFunction") and v.OnClientInvoke) then
													pcall(function()
														v.OnClientInvoke = function()
															return;
														end;
													end);
												end
												break;
											end
										end
									end
									break;
								end
							end
						end
					end);
				end
			end
		end);
		pcall(function()
			if (getrawmetatable and newcclosure and getnamecallmethod) then
				local FlatIdent_3E44E = 0;
				local mt;
				while true do
					if (FlatIdent_3E44E == 0) then
						mt = getrawmetatable(game);
						if mt then
							local FlatIdent_23521 = 0;
							local old;
							while true do
								if (1 == FlatIdent_23521) then
									mt.__namecall = newcclosure(function(self, ...)
										local FlatIdent_974E = 0;
										local method;
										while true do
											if (FlatIdent_974E == 0) then
												method = getnamecallmethod();
												if ((method == "Kick") or (method == "kick")) then
													return;
												end
												FlatIdent_974E = 1;
											end
											if (FlatIdent_974E == 1) then
												return old(self, ...);
											end
										end
									end);
									pcall(function()
										setreadonly(mt, true);
									end);
									break;
								end
								if (FlatIdent_23521 == 0) then
									old = mt.__namecall;
									pcall(function()
										setreadonly(mt, false);
									end);
									FlatIdent_23521 = 1;
								end
							end
						end
						break;
					end
				end
			end
		end);
		pcall(function()
			if (hookmetamethod and newcclosure) then
				local FlatIdent_129E6 = 0;
				local oldIndex;
				while true do
					if (0 == FlatIdent_129E6) then
						oldIndex = nil;
						oldIndex = hookmetamethod(game, "__index", newcclosure(function(self, key)
							local FlatIdent_2C0A2 = 0;
							while true do
								if (FlatIdent_2C0A2 == 0) then
									if (self == ghum()) then
										local FlatIdent_2B986 = 0;
										while true do
											if (FlatIdent_2B986 == 0) then
												if (key == "WalkSpeed") then
													return 16;
												end
												if ((key == "JumpPower") or (key == "JumpHeight")) then
													return 50;
												end
												break;
											end
										end
									end
									return oldIndex(self, key);
								end
							end
						end));
						break;
					end
				end
			end
		end);
		pcall(function()
			for _, v in ipairs(game:GetDescendants()) do
				pcall(function()
					if (v:IsA("BindableEvent") or v:IsA("BindableFunction")) then
						if matchBind(v.Name:lower()) then
							v:Destroy();
						end
					end
				end);
			end
		end);
		pcall(function()
			game.DescendantAdded:Connect(function(v)
				pcall(function()
					if (v:IsA("LocalScript") or v:IsA("ModuleScript")) then
						local n = v.Name:lower();
						if matchAC(n) then
							local FlatIdent_C79F = 0;
							while true do
								if (0 == FlatIdent_C79F) then
									task.wait(0.1);
									v.Disabled = true;
									break;
								end
							end
						end
					end
				end);
			end);
		end);
		pcall(function()
			if (game.PlaceId == 155615604) then
				for _, v in ipairs(game:GetDescendants()) do
					pcall(function()
						if (v:IsA("RemoteEvent") or v:IsA("RemoteFunction")) then
							local FlatIdent_47A85 = 0;
							local n;
							while true do
								if (FlatIdent_47A85 == 0) then
									n = v.Name:lower();
									if (n:find("check") or n:find("verify") or n:find("valid") or n:find("cuff") or n:find("tase")) then
										if (v:IsA("RemoteEvent") and getconnections) then
											for _, conn in ipairs(getconnections(v.OnClientEvent)) do
												pcall(function()
													conn:Disable();
												end);
											end
										end
									end
									break;
								end
							end
						end
					end);
				end
			end
		end);
		pcall(function()
			local pid = game.PlaceId;
			if ((pid == 2788229376) or (pid == 7213786345) or (pid == 12308081556)) then
				for _, v in ipairs(game:GetDescendants()) do
					pcall(function()
						if (v:IsA("ModuleScript") or v:IsA("LocalScript")) then
							local FlatIdent_87C42 = 0;
							local n;
							local fn;
							while true do
								if (FlatIdent_87C42 == 1) then
									pcall(function()
										fn = v:GetFullName():lower();
									end);
									if (n:find("anti") or n:find("detect") or n:find("combat") or n:find("stomp") or n:find("ragdoll") or n:find("exploit") or fn:find("anti") or fn:find("detect") or fn:find("combat")) then
										v.Disabled = true;
									end
									break;
								end
								if (0 == FlatIdent_87C42) then
									n = v.Name:lower();
									fn = "";
									FlatIdent_87C42 = 1;
								end
							end
						end
					end);
				end
				if getconnections then
					for _, v in ipairs(game:GetDescendants()) do
						pcall(function()
							if v:IsA("RemoteEvent") then
								local FlatIdent_97B67 = 0;
								local n;
								while true do
									if (FlatIdent_97B67 == 0) then
										n = v.Name:lower();
										if (n:find("detect") or n:find("flag") or n:find("report") or n:find("kick") or n:find("ban") or n:find("combat") or n:find("log") or n:find("stomp") or n:find("ragdoll")) then
											for _, conn in ipairs(getconnections(v.OnClientEvent)) do
												pcall(function()
													conn:Disable();
												end);
											end
										end
										break;
									end
								end
							end
						end);
					end
				end
			end
		end);
		pcall(function()
			if (hookmetamethod and newcclosure) then
				local oldNewIndex;
				oldNewIndex = hookmetamethod(game, "__newindex", newcclosure(function(self, key, value)
					if self:IsA("Humanoid") then
						local FlatIdent_4D69A = 0;
						while true do
							if (0 == FlatIdent_4D69A) then
								if ((key == "WalkSpeed") and (value < 16)) then
									return oldNewIndex(self, key, 16);
								end
								if ((key == "JumpPower") and (value < 50)) then
									return oldNewIndex(self, key, 50);
								end
								break;
							end
						end
					end
					return oldNewIndex(self, key, value);
				end));
			end
		end);
		game:GetService("StarterGui"):SetCore("SendNotification", {Title="AC Bypass",Text="Advanced bypass active",Duration=3});
	end
end);
local FL = {busy=false,allOn=false,stopFlag=false,touchOn=false,followOn=false,followTarget=nil,savedFPDH=nil};
pcall(function()
	FL.savedFPDH = WS.FallenPartsDestroyHeight;
end);
local function SkidFling(TP)
	if (FL.busy or FL.stopFlag) then
		return;
	end
	local Ch = gc();
	local Hum = Ch and Ch:FindFirstChildOfClass("Humanoid");
	local RP = Hum and Hum.RootPart;
	if (not Ch or not Hum or not RP or (Hum.Health <= 0)) then
		return;
	end
	local TC = TP.Character;
	if not TC then
		return;
	end
	local TH = TC:FindFirstChildOfClass("Humanoid");
	if (not TH or (TH.Health <= 0)) then
		return;
	end
	local TR = TH.RootPart;
	local THd = TC:FindFirstChild("Head");
	FL.busy = true;
	local Old = RP.CFrame;
	local FP = function(B, P, A)
		local FlatIdent_42B8B = 0;
		while true do
			if (FlatIdent_42B8B == 2) then
				RP.RotVelocity = Vector3.new(900000000, 900000000, 900000000);
				break;
			end
			if (FlatIdent_42B8B == 0) then
				if FL.stopFlag then
					return;
				end
				RP.CFrame = CFrame.new(B.Position) * P * A;
				FlatIdent_42B8B = 1;
			end
			if (FlatIdent_42B8B == 1) then
				pcall(function()
					Ch:SetPrimaryPartCFrame(CFrame.new(B.Position) * P * A);
				end);
				RP.Velocity = Vector3.new(90000000, 90000000 * 10, 90000000);
				FlatIdent_42B8B = 2;
			end
		end
	end;
	local SF = function(B)
		local FlatIdent_8BF78 = 0;
		local T;
		local Ag;
		while true do
			if (FlatIdent_8BF78 == 1) then
				repeat
					if (FL.stopFlag or not RP or not RP.Parent or not TH or not B or not B.Parent) then
						break;
					end
					if (B.Velocity.Magnitude < 50) then
						local FlatIdent_7FF2C = 0;
						local md;
						while true do
							if (FlatIdent_7FF2C == 1) then
								FP(B, CFrame.new(0, 1.5, 0) + md, CFrame.Angles(math.rad(Ag), 0, 0));
								task.wait();
								FlatIdent_7FF2C = 2;
							end
							if (0 == FlatIdent_7FF2C) then
								Ag = Ag + 100;
								md = (TH.MoveDirection * B.Velocity.Magnitude) / 1.25;
								FlatIdent_7FF2C = 1;
							end
							if (FlatIdent_7FF2C == 3) then
								FP(B, CFrame.new(2.25, 1.5, -2.25) + md, CFrame.Angles(math.rad(Ag), 0, 0));
								task.wait();
								FlatIdent_7FF2C = 4;
							end
							if (FlatIdent_7FF2C == 2) then
								FP(B, CFrame.new(0, -1.5, 0) + md, CFrame.Angles(math.rad(Ag), 0, 0));
								task.wait();
								FlatIdent_7FF2C = 3;
							end
							if (4 == FlatIdent_7FF2C) then
								FP(B, CFrame.new(-2.25, -1.5, 2.25) + md, CFrame.Angles(math.rad(Ag), 0, 0));
								task.wait();
								break;
							end
						end
					else
						FP(B, CFrame.new(0, 1.5, TH.WalkSpeed), CFrame.Angles(math.rad(90), 0, 0));
						task.wait();
						FP(B, CFrame.new(0, -1.5, -TH.WalkSpeed), CFrame.Angles(0, 0, 0));
						task.wait();
					end
				until FL.stopFlag or (B.Velocity.Magnitude > 500) or (B.Parent ~= TP.Character) or (TP.Parent ~= Players) or TH.Sit or (Hum.Health <= 0) or (tick() > (T + 2)) 
				break;
			end
			if (0 == FlatIdent_8BF78) then
				T = tick();
				Ag = 0;
				FlatIdent_8BF78 = 1;
			end
		end
	end;
	pcall(function()
		WS.FallenPartsDestroyHeight = NaN;
	end);
	local BV = Instance.new("BodyVelocity");
	BV.Name = "AVF";
	BV.Parent = RP;
	BV.Velocity = Vector3.new(900000000, 900000000, 900000000);
	BV.MaxForce = Vector3.new(math.huge, math.huge, math.huge);
	Hum:SetStateEnabled(Enum.HumanoidStateType.Seated, false);
	if not FL.stopFlag then
		if (TR and THd) then
			if ((TR.CFrame.p - THd.CFrame.p).Magnitude > 5) then
				SF(THd);
			else
				SF(TR);
			end
		elseif TR then
			SF(TR);
		elseif THd then
			SF(THd);
		end
	end
	pcall(function()
		BV:Destroy();
	end);
	pcall(function()
		Hum:SetStateEnabled(Enum.HumanoidStateType.Seated, true);
	end);
	pcall(function()
		cam.CameraSubject = Hum;
	end);
	pcall(function()
		if (RP and RP.Parent) then
			repeat
				RP.CFrame = Old * CFrame.new(0, 0.5, 0);
				pcall(function()
					Ch:SetPrimaryPartCFrame(Old * CFrame.new(0, 0.5, 0));
				end);
				Hum:ChangeState("GettingUp");
				for _, x in ipairs(Ch:GetChildren()) do
					if x:IsA("BasePart") then
						local FlatIdent_5EF9 = 0;
						while true do
							if (FlatIdent_5EF9 == 0) then
								x.Velocity = Vector3.zero;
								x.RotVelocity = Vector3.zero;
								break;
							end
						end
					end
				end
				task.wait();
			until FL.stopFlag or ((RP.Position - Old.p).Magnitude < 25) 
		end
	end);
	pcall(function()
		if FL.savedFPDH then
			WS.FallenPartsDestroyHeight = FL.savedFPDH;
		end
	end);
	FL.busy = false;
end
FL.flingOne = function(t)
	if (t == lp) then
		return;
	end
	FL.stopFlag = false;
	jSt.Text = "Fling: " .. t.Name;
	jSt.TextColor3 = C.W;
	task.spawn(function()
		local FlatIdent_8CF9A = 0;
		while true do
			if (0 == FlatIdent_8CF9A) then
				SkidFling(t);
				if not FL.allOn then
					local FlatIdent_76EB7 = 0;
					while true do
						if (FlatIdent_76EB7 == 0) then
							jSt.Text = "Idle";
							jSt.TextColor3 = C.D;
							break;
						end
					end
				end
				break;
			end
		end
	end);
end;
FL.flingAll = function()
	if FL.allOn then
		local FlatIdent_994C = 0;
		while true do
			if (FlatIdent_994C == 3) then
				return;
			end
			if (FlatIdent_994C == 0) then
				FL.allOn = false;
				FL.stopFlag = true;
				FlatIdent_994C = 1;
			end
			if (FlatIdent_994C == 2) then
				jSt.Text = "Idle";
				jSt.TextColor3 = C.D;
				FlatIdent_994C = 3;
			end
			if (FlatIdent_994C == 1) then
				jBO['All'].Text = "Fling All";
				TweenService:Create(jBO['All'], TweenInfo.new(0.1), {BackgroundColor3=C.Ac}):Play();
				FlatIdent_994C = 2;
			end
		end
	end
	FL.allOn = true;
	FL.stopFlag = false;
	jBO['All'].Text = "Stop";
	TweenService:Create(jBO['All'], TweenInfo.new(0.1), {BackgroundColor3=C.R}):Play();
	task.spawn(function()
		while FL.allOn and not FL.stopFlag do
			local FlatIdent_2C010 = 0;
			local tg;
			while true do
				if (FlatIdent_2C010 == 1) then
					if (#tg == 0) then
						FL.allOn = false;
						jBO['All'].Text = "Fling All";
						TweenService:Create(jBO['All'], TweenInfo.new(0.1), {BackgroundColor3=C.Ac}):Play();
						jSt.Text = "Nobody";
						jSt.TextColor3 = C.D;
						return;
					end
					for _, t in ipairs(tg) do
						local FlatIdent_4CEEC = 0;
						while true do
							if (FlatIdent_4CEEC == 2) then
								if (not FL.allOn or FL.stopFlag) then
									return;
								end
								task.wait(0.5);
								break;
							end
							if (FlatIdent_4CEEC == 1) then
								jSt.TextColor3 = C.W;
								SkidFling(t);
								FlatIdent_4CEEC = 2;
							end
							if (FlatIdent_4CEEC == 0) then
								if (not FL.allOn or FL.stopFlag) then
									return;
								end
								jSt.Text = "All: " .. t.Name;
								FlatIdent_4CEEC = 1;
							end
						end
					end
					break;
				end
				if (FlatIdent_2C010 == 0) then
					tg = {};
					for _, p in ipairs(Players:GetPlayers()) do
						if ((p ~= lp) and p.Character and p.Character:FindFirstChild("HumanoidRootPart")) then
							local FlatIdent_185A5 = 0;
							local h;
							while true do
								if (0 == FlatIdent_185A5) then
									h = p.Character:FindFirstChildOfClass("Humanoid");
									if (h and (h.Health > 0)) then
										table.insert(tg, p);
									end
									break;
								end
							end
						end
					end
					FlatIdent_2C010 = 1;
				end
			end
		end
	end);
end;
FL.touchFling = function()
	local FlatIdent_904EC = 0;
	local hrp;
	while true do
		if (FlatIdent_904EC == 2) then
			jBO['Touch'].Text = "Stop";
			TweenService:Create(jBO['Touch'], TweenInfo.new(0.1), {BackgroundColor3=C.R}):Play();
			FlatIdent_904EC = 3;
		end
		if (FlatIdent_904EC == 3) then
			jSt.Text = "Touch Fling";
			jSt.TextColor3 = C.W;
			FlatIdent_904EC = 4;
		end
		if (4 == FlatIdent_904EC) then
			task.spawn(function()
				local FlatIdent_95359 = 0;
				local ml;
				while true do
					if (0 == FlatIdent_95359) then
						ml = 0.1;
						while FL.touchOn do
							local FlatIdent_8384B = 0;
							local c;
							local h;
							while true do
								if (FlatIdent_8384B == 0) then
									RunService.Heartbeat:Wait();
									c = gc();
									FlatIdent_8384B = 1;
								end
								if (FlatIdent_8384B == 1) then
									h = c and c:FindFirstChild("HumanoidRootPart");
									while FL.touchOn and not (c and c.Parent and h and h.Parent) do
										RunService.Heartbeat:Wait();
										c = gc();
										h = c and c:FindFirstChild("HumanoidRootPart");
									end
									FlatIdent_8384B = 2;
								end
								if (FlatIdent_8384B == 2) then
									if (FL.touchOn and h and h.Parent) then
										local v = h.Velocity;
										h.Velocity = (v * 10000) + Vector3.new(0, 10000, 0);
										RunService.RenderStepped:Wait();
										if (c and c.Parent and h and h.Parent) then
											h.Velocity = v;
										end
										RunService.Stepped:Wait();
										if (c and c.Parent and h and h.Parent) then
											local FlatIdent_285D = 0;
											while true do
												if (FlatIdent_285D == 0) then
													h.Velocity = v + Vector3.new(0, ml, 0);
													ml = ml * -1;
													break;
												end
											end
										end
									end
									break;
								end
							end
						end
						break;
					end
				end
			end);
			break;
		end
		if (0 == FlatIdent_904EC) then
			if FL.touchOn then
				FL.touchOn = false;
				jBO['Touch'].Text = "Touch";
				TweenService:Create(jBO['Touch'], TweenInfo.new(0.1), {BackgroundColor3=C.Ac}):Play();
				jSt.Text = "Idle";
				jSt.TextColor3 = C.D;
				return;
			end
			hrp = ghrp();
			FlatIdent_904EC = 1;
		end
		if (FlatIdent_904EC == 1) then
			if not hrp then
				return;
			end
			FL.touchOn = true;
			FlatIdent_904EC = 2;
		end
	end
end;
FL.follow = function(t)
	local FlatIdent_354BC = 0;
	while true do
		if (FlatIdent_354BC == 2) then
			jSt.TextColor3 = C.W;
			task.spawn(function()
				while FL.followOn and (FL.followTarget == t) do
					local hrp = ghrp();
					local th = t.Character and t.Character:FindFirstChild("HumanoidRootPart");
					if (hrp and th and ((th.Position - hrp.Position).Magnitude > 5)) then
						local FlatIdent_3E76B = 0;
						while true do
							if (0 == FlatIdent_3E76B) then
								hrp.CFrame = CFrame.new(hrp.Position, th.Position) * CFrame.new(0, 0, -3);
								pcall(function()
									ghum():MoveTo(th.Position);
								end);
								break;
							end
						end
					end
					task.wait(0.1);
				end
			end);
			break;
		end
		if (0 == FlatIdent_354BC) then
			if (FL.followOn and (FL.followTarget == t)) then
				local FlatIdent_1F1FE = 0;
				while true do
					if (FlatIdent_1F1FE == 1) then
						jSt.Text = "Idle";
						jSt.TextColor3 = C.D;
						FlatIdent_1F1FE = 2;
					end
					if (FlatIdent_1F1FE == 0) then
						FL.followOn = false;
						FL.followTarget = nil;
						FlatIdent_1F1FE = 1;
					end
					if (FlatIdent_1F1FE == 2) then
						return;
					end
				end
			end
			FL.followOn = true;
			FlatIdent_354BC = 1;
		end
		if (FlatIdent_354BC == 1) then
			FL.followTarget = t;
			jSt.Text = "Follow: " .. t.Name;
			FlatIdent_354BC = 2;
		end
	end
end;
FL.stop = function()
	local FlatIdent_7C89 = 0;
	while true do
		if (FlatIdent_7C89 == 0) then
			FL.allOn = false;
			FL.stopFlag = true;
			FL.touchOn = false;
			FL.followOn = false;
			FlatIdent_7C89 = 1;
		end
		if (FlatIdent_7C89 == 2) then
			FL.stopFlag = false;
			jSt.Text = "Idle";
			jSt.TextColor3 = C.D;
			jBO['All'].Text = "Fling All";
			FlatIdent_7C89 = 3;
		end
		if (FlatIdent_7C89 == 3) then
			jBO['Touch'].Text = "Touch";
			TweenService:Create(jBO['All'], TweenInfo.new(0.1), {BackgroundColor3=C.Ac}):Play();
			TweenService:Create(jBO['Touch'], TweenInfo.new(0.1), {BackgroundColor3=C.Ac}):Play();
			break;
		end
		if (FlatIdent_7C89 == 1) then
			FL.followTarget = nil;
			pcall(function()
				local hrp = ghrp();
				if hrp then
					for _, v in ipairs(hrp:GetChildren()) do
						if v:IsA("BodyMover") then
							v:Destroy();
						end
					end
					hrp.Velocity = Vector3.zero;
					hrp.RotVelocity = Vector3.zero;
				end
				local h = ghum();
				if h then
					h.PlatformStand = false;
				end
			end);
			task.wait(0.3);
			FL.busy = false;
			FlatIdent_7C89 = 2;
		end
	end
end;
jBO['Stop'].MouseButton1Click:Connect(function()
	FL.stop();
end);
jBO['All'].MouseButton1Click:Connect(function()
	FL.flingAll();
end);
jBO['Touch'].MouseButton1Click:Connect(function()
	FL.touchFling();
end);
local function rPlayers()
	local FlatIdent_936D7 = 0;
	local search;
	while true do
		if (FlatIdent_936D7 == 1) then
			for _, p in ipairs(Players:GetPlayers()) do
				if (p ~= lp) then
					local FlatIdent_3BBAF = 0;
					local dn;
					local un;
					while true do
						if (0 == FlatIdent_3BBAF) then
							dn = p.DisplayName;
							un = p.Name;
							FlatIdent_3BBAF = 1;
						end
						if (FlatIdent_3BBAF == 1) then
							if ((search == "") or dn:lower():find(search, 1, true) or un:lower():find(search, 1, true)) then
								local FlatIdent_53895 = 0;
								local row;
								local nm;
								local bdata;
								while true do
									if (FlatIdent_53895 == 6) then
										for i, bd in ipairs(bdata) do
											local FlatIdent_643B6 = 0;
											local ab;
											while true do
												if (0 == FlatIdent_643B6) then
													ab = Instance.new("TextButton", row);
													ab.BackgroundColor3 = C.Ac;
													ab.BorderSizePixel = 0;
													ab.Position = UDim2.new(1, (-((#bdata - i) + 1) * 40) + 2, 0, 3);
													FlatIdent_643B6 = 1;
												end
												if (FlatIdent_643B6 == 3) then
													ab.MouseButton1Click:Connect(bd[2]);
													break;
												end
												if (2 == FlatIdent_643B6) then
													ab.Text = bd[1];
													ab.AutoButtonColor = false;
													rc(ab, 4);
													hfx(ab, C.Ac, C.AcH);
													FlatIdent_643B6 = 3;
												end
												if (FlatIdent_643B6 == 1) then
													ab.Size = UDim2.new(0, 36, 0, 22);
													ab.Font = Enum.Font.GothamBold;
													ab.TextColor3 = C.W;
													ab.TextSize = 9;
													FlatIdent_643B6 = 2;
												end
											end
										end
										break;
									end
									if (5 == FlatIdent_53895) then
										nm.Text = ((dn ~= un) and (dn .. " @" .. un)) or un;
										nm.MouseButton1Click:Connect(function()
											local FlatIdent_97F0B = 0;
											while true do
												if (FlatIdent_97F0B == 0) then
													selPlayer = p;
													pcall(function()
														cam.CameraSubject = p.Character:FindFirstChildOfClass("Humanoid");
													end);
													FlatIdent_97F0B = 1;
												end
												if (FlatIdent_97F0B == 1) then
													jSt.Text = "Spec: " .. dn;
													jSt.TextColor3 = C.D;
													break;
												end
											end
										end);
										bdata = {{"F",function()
											FL.flingOne(p);
										end},{"TP",function()
											pcall(function()
												local FlatIdent_63284 = 0;
												local hrp;
												local th;
												while true do
													if (FlatIdent_63284 == 1) then
														if (hrp and th) then
															hrp.CFrame = th.CFrame * CFrame.new(3, 0, 0);
														end
														break;
													end
													if (FlatIdent_63284 == 0) then
														hrp = ghrp();
														th = p.Character and p.Character:FindFirstChild("HumanoidRootPart");
														FlatIdent_63284 = 1;
													end
												end
											end);
										end},{"Fw",function()
											FL.follow(p);
										end}};
										FlatIdent_53895 = 6;
									end
									if (2 == FlatIdent_53895) then
										nm = Instance.new("TextButton", row);
										nm.BackgroundTransparency = 1;
										nm.Position = UDim2.new(0, 4, 0, 0);
										FlatIdent_53895 = 3;
									end
									if (FlatIdent_53895 == 1) then
										row.BorderSizePixel = 0;
										row.Size = UDim2.new(1, 0, 0, 28);
										rc(row);
										FlatIdent_53895 = 2;
									end
									if (FlatIdent_53895 == 0) then
										row = Instance.new("Frame");
										row.Parent = jScr;
										row.BackgroundColor3 = C.Bg;
										FlatIdent_53895 = 1;
									end
									if (FlatIdent_53895 == 4) then
										nm.TextSize = 10;
										nm.TextXAlignment = Enum.TextXAlignment.Left;
										nm.AutoButtonColor = false;
										FlatIdent_53895 = 5;
									end
									if (FlatIdent_53895 == 3) then
										nm.Size = UDim2.new(1, -134, 1, 0);
										nm.Font = Enum.Font.Gotham;
										nm.TextColor3 = C.W;
										FlatIdent_53895 = 4;
									end
								end
							end
							break;
						end
					end
				end
			end
			break;
		end
		if (FlatIdent_936D7 == 0) then
			for _, v in ipairs(jScr:GetChildren()) do
				if v:IsA("Frame") then
					v:Destroy();
				end
			end
			search = jSearch.Text:lower();
			FlatIdent_936D7 = 1;
		end
	end
end
jRef.MouseButton1Click:Connect(rPlayers);
jSearch:GetPropertyChangedSignal("Text"):Connect(rPlayers);
task.defer(rPlayers);
Players.PlayerAdded:Connect(function()
	local FlatIdent_55482 = 0;
	while true do
		if (FlatIdent_55482 == 0) then
			task.wait(1);
			rPlayers();
			break;
		end
	end
end);
Players.PlayerRemoving:Connect(function()
	local FlatIdent_23A2C = 0;
	while true do
		if (FlatIdent_23A2C == 0) then
			task.wait(0.5);
			rPlayers();
			break;
		end
	end
end);
local flying, ncOn = false, false;
local flyBV, flyBG, flyC, ncC, godC, espC, fcC, avoidC, slowC, fogC, brightC, hitboxC, spinC;
local keys = {};
local spdA = false;
local origFog, origAmb;
local fcYaw, fcPitch = 0, 0;
local fcPos = Vector3.zero;
UIS.InputBegan:Connect(function(i, g)
	if (not g and i.KeyCode) then
		keys[i.KeyCode] = true;
		local kn = i.KeyCode.Name;
		if (kn == CFG.toggleKey) then
			Main.Visible = not Main.Visible;
		end
		if ((CFG.flyKey ~= "") and (kn == CFG.flyKey)) then
			tFly.toggle();
		end
		if ((CFG.noclipKey ~= "") and (kn == CFG.noclipKey)) then
			tNoclip.toggle();
		end
		if ((CFG.freecamKey ~= "") and (kn == CFG.freecamKey)) then
			tFreecam.toggle();
		end
		if ((CFG.godKey ~= "") and (kn == CFG.godKey)) then
			tGod.toggle();
		end
		if ((CFG.espKey ~= "") and (kn == CFG.espKey)) then
			tESP.toggle();
		end
		if ((CFG.touchFlingKey ~= "") and (kn == CFG.touchFlingKey)) then
			FL.touchFling();
		end
		if ((CFG.flingAllKey ~= "") and (kn == CFG.flingAllKey)) then
			FL.flingAll();
		end
	end
end);
UIS.InputEnded:Connect(function(i)
	if i.KeyCode then
		keys[i.KeyCode] = nil;
	end
	if ((i.UserInputType == Enum.UserInputType.MouseButton1) or (i.UserInputType == Enum.UserInputType.Touch)) then
		for _, s in ipairs(sliders) do
			s.dragging = false;
		end
	end
end);
UIS.InputChanged:Connect(function(i)
	if ((i.UserInputType == Enum.UserInputType.MouseMovement) or (i.UserInputType == Enum.UserInputType.Touch)) then
		for _, s in ipairs(sliders) do
			if s.dragging then
				local FlatIdent_23B4 = 0;
				local r;
				while true do
					if (FlatIdent_23B4 == 1) then
						s.val = math.floor(s.min + (r * (s.max - s.min)));
						s.label.Text = s.name .. ": " .. s.val;
						FlatIdent_23B4 = 2;
					end
					if (2 == FlatIdent_23B4) then
						if s.cb then
							s.cb(s.val);
						end
						break;
					end
					if (FlatIdent_23B4 == 0) then
						r = math.clamp((i.Position.X - s.bg.AbsolutePosition.X) / s.bg.AbsoluteSize.X, 0, 1);
						s.fill.Size = UDim2.new(r, 0, 1, 0);
						FlatIdent_23B4 = 1;
					end
				end
			end
		end
	end
end);
tFly.on(function(s)
	if s then
		local FlatIdent_439F8 = 0;
		local hrp;
		local hum;
		while true do
			if (FlatIdent_439F8 == 3) then
				flyBV.P = 9000;
				flyBV.Parent = hrp;
				flyBG = Instance.new("BodyGyro");
				FlatIdent_439F8 = 4;
			end
			if (FlatIdent_439F8 == 1) then
				flying = true;
				if not ncOn then
					tNoclip.set(true);
				end
				hum.PlatformStand = true;
				FlatIdent_439F8 = 2;
			end
			if (2 == FlatIdent_439F8) then
				flyBV = Instance.new("BodyVelocity");
				flyBV.MaxForce = Vector3.new(math.huge, math.huge, math.huge);
				flyBV.Velocity = Vector3.zero;
				FlatIdent_439F8 = 3;
			end
			if (0 == FlatIdent_439F8) then
				hrp = ghrp();
				hum = ghum();
				if (not hrp or not hum) then
					tFly.set(false);
					return;
				end
				FlatIdent_439F8 = 1;
			end
			if (4 == FlatIdent_439F8) then
				flyBG.MaxTorque = Vector3.new(math.huge, math.huge, math.huge);
				flyBG.D = 200;
				flyBG.P = 40000;
				FlatIdent_439F8 = 5;
			end
			if (5 == FlatIdent_439F8) then
				flyBG.Parent = hrp;
				flyC = RunService.Heartbeat:Connect(function()
					local FlatIdent_52478 = 0;
					while true do
						if (FlatIdent_52478 == 0) then
							if not flying then
								return;
							end
							pcall(function()
								local cf = cam.CFrame;
								local d = Vector3.zero;
								if (keys[Enum.KeyCode.W] or keys[Enum.KeyCode.Z]) then
									d = d + cf.LookVector;
								end
								if keys[Enum.KeyCode.S] then
									d = d - cf.LookVector;
								end
								if (keys[Enum.KeyCode.A] or keys[Enum.KeyCode.Q]) then
									d = d - cf.RightVector;
								end
								if keys[Enum.KeyCode.D] then
									d = d + cf.RightVector;
								end
								if (keys[Enum.KeyCode.E] or keys[Enum.KeyCode.Space]) then
									d = d + Vector3.yAxis;
								end
								if (keys[Enum.KeyCode.C] or keys[Enum.KeyCode.LeftShift]) then
									d = d - Vector3.yAxis;
								end
								flyBV.Velocity = ((d.Magnitude > 0) and (d.Unit * sFlySpd.val)) or Vector3.zero;
								flyBG.CFrame = cf;
							end);
							break;
						end
					end
				end);
				break;
			end
		end
	else
		local FlatIdent_7FA00 = 0;
		while true do
			if (FlatIdent_7FA00 == 2) then
				pcall(function()
					ghum().PlatformStand = false;
				end);
				if ncOn then
					tNoclip.set(false);
				end
				break;
			end
			if (FlatIdent_7FA00 == 1) then
				pcall(function()
					if flyBV then
						flyBV:Destroy();
					end
				end);
				pcall(function()
					if flyBG then
						flyBG:Destroy();
					end
				end);
				FlatIdent_7FA00 = 2;
			end
			if (FlatIdent_7FA00 == 0) then
				flying = false;
				if flyC then
					local FlatIdent_67029 = 0;
					while true do
						if (FlatIdent_67029 == 0) then
							flyC:Disconnect();
							flyC = nil;
							break;
						end
					end
				end
				FlatIdent_7FA00 = 1;
			end
		end
	end
end);
tNoclip.on(function(s)
	local FlatIdent_2095C = 0;
	while true do
		if (FlatIdent_2095C == 0) then
			ncOn = s;
			if ncC then
				local FlatIdent_FA0F = 0;
				while true do
					if (FlatIdent_FA0F == 0) then
						ncC:Disconnect();
						ncC = nil;
						break;
					end
				end
			end
			FlatIdent_2095C = 1;
		end
		if (FlatIdent_2095C == 1) then
			if s then
				ncC = RunService.Stepped:Connect(function()
					pcall(function()
						local c = gc();
						if not c then
							return;
						end
						for _, p in ipairs(c:GetDescendants()) do
							if p:IsA("BasePart") then
								p.CanCollide = false;
							end
						end
					end);
				end);
			end
			break;
		end
	end
end);
UIS.JumpRequest:Connect(function()
	if tInfJ.get() then
		pcall(function()
			ghum():ChangeState(Enum.HumanoidStateType.Jumping);
		end);
	end
end);
tGod.on(function(s)
	local FlatIdent_18D84 = 0;
	while true do
		if (FlatIdent_18D84 == 0) then
			if godC then
				godC:Disconnect();
				godC = nil;
			end
			if s then
				godC = RunService.Heartbeat:Connect(function()
					pcall(function()
						local h = ghum();
						if h then
							h.Health = h.MaxHealth;
						end
						local hrp = ghrp();
						if hrp then
							hrp.Velocity = Vector3.new(math.clamp(hrp.Velocity.X, -100, 100), math.clamp(hrp.Velocity.Y, -100, 100), math.clamp(hrp.Velocity.Z, -100, 100));
						end
					end);
				end);
			end
			break;
		end
	end
end);
tAntiVoid.on(function(s)
	if avoidC then
		local FlatIdent_15914 = 0;
		while true do
			if (0 == FlatIdent_15914) then
				avoidC:Disconnect();
				avoidC = nil;
				break;
			end
		end
	end
	if s then
		avoidC = RunService.Heartbeat:Connect(function()
			pcall(function()
				local FlatIdent_4B897 = 0;
				local hrp;
				while true do
					if (0 == FlatIdent_4B897) then
						hrp = ghrp();
						if (hrp and (hrp.Position.Y < -50)) then
							local FlatIdent_8B6F5 = 0;
							while true do
								if (FlatIdent_8B6F5 == 0) then
									hrp.CFrame = CFrame.new(hrp.Position.X, 50, hrp.Position.Z);
									hrp.Velocity = Vector3.zero;
									break;
								end
							end
						end
						break;
					end
				end
			end);
		end);
	end
end);
tSpin.on(function(s)
	if spinC then
		local FlatIdent_5CD30 = 0;
		while true do
			if (0 == FlatIdent_5CD30) then
				spinC:Disconnect();
				spinC = nil;
				break;
			end
		end
	end
	pcall(function()
		local hrp = ghrp();
		if hrp then
			for _, v in ipairs(hrp:GetChildren()) do
				if (v.Name == "AVSPIN") then
					v:Destroy();
				end
			end
		end
	end);
	if s then
		local FlatIdent_3E39 = 0;
		local hrp;
		while true do
			if (FlatIdent_3E39 == 0) then
				hrp = ghrp();
				if hrp then
					local bav = Instance.new("BodyAngularVelocity");
					bav.Name = "AVSPIN";
					bav.MaxTorque = Vector3.new(0, math.huge, 0);
					bav.AngularVelocity = Vector3.new(0, sSpinSpd.val, 0);
					bav.P = 500;
					bav.Parent = hrp;
					spinC = RunService.Heartbeat:Connect(function()
						pcall(function()
							local FlatIdent_9EC6 = 0;
							local b;
							while true do
								if (FlatIdent_9EC6 == 0) then
									b = ghrp() and ghrp():FindFirstChild("AVSPIN");
									if b then
										b.AngularVelocity = Vector3.new(0, sSpinSpd.val, 0);
									end
									break;
								end
							end
						end);
					end);
				end
				break;
			end
		end
	end
end);
tHitbox.on(function(s)
	if hitboxC then
		local FlatIdent_2E3FF = 0;
		while true do
			if (FlatIdent_2E3FF == 0) then
				hitboxC:Disconnect();
				hitboxC = nil;
				break;
			end
		end
	end
	if s then
		hitboxC = RunService.Stepped:Connect(function()
			pcall(function()
				local FlatIdent_5F12F = 0;
				local sz;
				while true do
					if (FlatIdent_5F12F == 0) then
						sz = sHitbox.val;
						for _, p in ipairs(Players:GetPlayers()) do
							if ((p ~= lp) and p.Character) then
								local FlatIdent_6D09C = 0;
								local head;
								while true do
									if (FlatIdent_6D09C == 0) then
										head = p.Character:FindFirstChild("Head");
										if head then
											local FlatIdent_62AB4 = 0;
											local mesh;
											while true do
												if (FlatIdent_62AB4 == 3) then
													if mesh then
														mesh:Destroy();
													end
													break;
												end
												if (FlatIdent_62AB4 == 1) then
													head.CanCollide = false;
													head.Massless = true;
													FlatIdent_62AB4 = 2;
												end
												if (FlatIdent_62AB4 == 2) then
													head.Material = Enum.Material.ForceField;
													mesh = head:FindFirstChildOfClass("SpecialMesh");
													FlatIdent_62AB4 = 3;
												end
												if (FlatIdent_62AB4 == 0) then
													head.Size = Vector3.new(sz, sz, sz);
													head.Transparency = 0.5;
													FlatIdent_62AB4 = 1;
												end
											end
										end
										break;
									end
								end
							end
						end
						break;
					end
				end
			end);
		end);
	else
		pcall(function()
			for _, p in ipairs(Players:GetPlayers()) do
				if ((p ~= lp) and p.Character) then
					local FlatIdent_1F538 = 0;
					local head;
					while true do
						if (FlatIdent_1F538 == 0) then
							head = p.Character:FindFirstChild("Head");
							if head then
								local FlatIdent_2B956 = 0;
								while true do
									if (FlatIdent_2B956 == 0) then
										head.Size = Vector3.new(2, 1, 1);
										head.Transparency = 0;
										FlatIdent_2B956 = 1;
									end
									if (FlatIdent_2B956 == 1) then
										head.Material = Enum.Material.Plastic;
										break;
									end
								end
							end
							break;
						end
					end
				end
			end
		end);
	end
end);
tESP.on(function(s)
	if espC then
		local FlatIdent_D448 = 0;
		while true do
			if (FlatIdent_D448 == 0) then
				espC:Disconnect();
				espC = nil;
				break;
			end
		end
	end
	if s then
		local function cleanESP(c)
			if c then
				local e = c:FindFirstChild("AVESP");
				if e then
					e:Destroy();
				end
				local head = c:FindFirstChild("Head");
				if head then
					local FlatIdent_6DCFD = 0;
					local n;
					while true do
						if (0 == FlatIdent_6DCFD) then
							n = head:FindFirstChild("AVESPN");
							if n then
								n:Destroy();
							end
							break;
						end
					end
				end
			end
		end
		local function applyESP(p)
			pcall(function()
				if (p == lp) then
					return;
				end
				local c = p.Character;
				if not c then
					return;
				end
				local espColor = C.W;
				pcall(function()
					if (p.Team and p.TeamColor) then
						espColor = p.TeamColor.Color;
					end
				end);
				local esp = c:FindFirstChild("AVESP");
				if not esp then
					local FlatIdent_2394 = 0;
					while true do
						if (FlatIdent_2394 == 0) then
							esp = Instance.new("Highlight");
							esp.Name = "AVESP";
							FlatIdent_2394 = 1;
						end
						if (FlatIdent_2394 == 1) then
							esp.FillTransparency = 0.8;
							esp.Parent = c;
							break;
						end
					end
				end
				esp.FillColor = espColor;
				esp.OutlineColor = espColor;
				local head = c:FindFirstChild("Head");
				if not head then
					return;
				end
				local espN = head:FindFirstChild("AVESPN");
				if not espN then
					local FlatIdent_7E46E = 0;
					local nl;
					local dl;
					while true do
						if (6 == FlatIdent_7E46E) then
							dl.Size = UDim2.new(1, 0, 0.5, 0);
							dl.Position = UDim2.new(0, 0, 0.5, 0);
							dl.Font = Enum.Font.Gotham;
							FlatIdent_7E46E = 7;
						end
						if (FlatIdent_7E46E == 0) then
							espN = Instance.new("BillboardGui");
							espN.Name = "AVESPN";
							espN.Parent = head;
							FlatIdent_7E46E = 1;
						end
						if (FlatIdent_7E46E == 5) then
							dl = Instance.new("TextLabel", espN);
							dl.Name = "DistL";
							dl.BackgroundTransparency = 1;
							FlatIdent_7E46E = 6;
						end
						if (FlatIdent_7E46E == 8) then
							dl.TextSize = 10;
							break;
						end
						if (FlatIdent_7E46E == 3) then
							nl.BackgroundTransparency = 1;
							nl.Size = UDim2.new(1, 0, 0.5, 0);
							nl.Font = Enum.Font.GothamBold;
							FlatIdent_7E46E = 4;
						end
						if (1 == FlatIdent_7E46E) then
							espN.Size = UDim2.new(0, 200, 0, 30);
							espN.StudsOffset = Vector3.new(0, 2.5, 0);
							espN.AlwaysOnTop = true;
							FlatIdent_7E46E = 2;
						end
						if (FlatIdent_7E46E == 7) then
							dl.TextColor3 = C.D;
							dl.TextStrokeTransparency = 0.5;
							dl.TextStrokeColor3 = Color3.new(0, 0, 0);
							FlatIdent_7E46E = 8;
						end
						if (FlatIdent_7E46E == 4) then
							nl.TextStrokeTransparency = 0.5;
							nl.TextStrokeColor3 = Color3.new(0, 0, 0);
							nl.TextSize = 14;
							FlatIdent_7E46E = 5;
						end
						if (FlatIdent_7E46E == 2) then
							espN.MaxDistance = 1000;
							nl = Instance.new("TextLabel", espN);
							nl.Name = "NameL";
							FlatIdent_7E46E = 3;
						end
					end
				end
				local nameL = espN:FindFirstChild("NameL");
				if nameL then
					nameL.TextColor3 = espColor;
					nameL.Text = p.DisplayName;
				end
				if (ghrp() and head) then
					local FlatIdent_661EB = 0;
					local distL;
					while true do
						if (FlatIdent_661EB == 0) then
							distL = espN:FindFirstChild("DistL");
							if distL then
								local dist = math.floor((ghrp().Position - head.Position).Magnitude);
								local hum2 = c:FindFirstChildOfClass("Humanoid");
								local hp = (hum2 and math.floor(hum2.Health)) or 0;
								distL.Text = "HP: " .. hp .. " | " .. dist .. "m";
							end
							break;
						end
					end
				end
			end);
		end
		for _, p in ipairs(Players:GetPlayers()) do
			if (p ~= lp) then
				pcall(function()
					p.CharacterAdded:Connect(function()
						task.wait(1);
						if tESP.get() then
							applyESP(p);
						end
					end);
				end);
			end
		end
		Players.PlayerAdded:Connect(function(p)
			if (p ~= lp) then
				task.wait(2);
				if tESP.get() then
					applyESP(p);
				end
				p.CharacterAdded:Connect(function()
					local FlatIdent_2C5B6 = 0;
					while true do
						if (FlatIdent_2C5B6 == 0) then
							task.wait(1);
							if tESP.get() then
								applyESP(p);
							end
							break;
						end
					end
				end);
			end
		end);
		Players.PlayerRemoving:Connect(function(p)
			pcall(function()
				cleanESP(p.Character);
			end);
		end);
		espC = RunService.Heartbeat:Connect(function()
			for _, p in ipairs(Players:GetPlayers()) do
				if (p ~= lp) then
					applyESP(p);
				end
			end
		end);
	else
		for _, p in ipairs(Players:GetPlayers()) do
			pcall(function()
				local FlatIdent_26570 = 0;
				local c;
				while true do
					if (FlatIdent_26570 == 0) then
						c = p.Character;
						if c then
							local FlatIdent_56EE2 = 0;
							local e;
							local head;
							while true do
								if (FlatIdent_56EE2 == 0) then
									e = c:FindFirstChild("AVESP");
									if e then
										e:Destroy();
									end
									FlatIdent_56EE2 = 1;
								end
								if (1 == FlatIdent_56EE2) then
									head = c:FindFirstChild("Head");
									if head then
										local FlatIdent_19705 = 0;
										local n;
										while true do
											if (0 == FlatIdent_19705) then
												n = head:FindFirstChild("AVESPN");
												if n then
													n:Destroy();
												end
												break;
											end
										end
									end
									break;
								end
							end
						end
						break;
					end
				end
			end);
		end
	end
end);
tFullbright.on(function(s)
	local FlatIdent_36690 = 0;
	while true do
		if (FlatIdent_36690 == 0) then
			if brightC then
				local FlatIdent_6128B = 0;
				while true do
					if (0 == FlatIdent_6128B) then
						brightC:Disconnect();
						brightC = nil;
						break;
					end
				end
			end
			if s then
				local FlatIdent_2FA59 = 0;
				while true do
					if (0 == FlatIdent_2FA59) then
						origAmb = Lighting.Ambient;
						brightC = RunService.Heartbeat:Connect(function()
							pcall(function()
								local FlatIdent_41C81 = 0;
								while true do
									if (FlatIdent_41C81 == 1) then
										Lighting.OutdoorAmbient = Color3.new(1, 1, 1);
										break;
									end
									if (FlatIdent_41C81 == 0) then
										Lighting.Ambient = Color3.new(1, 1, 1);
										Lighting.Brightness = 2;
										FlatIdent_41C81 = 1;
									end
								end
							end);
						end);
						break;
					end
				end
			else
				pcall(function()
					local FlatIdent_1B30C = 0;
					while true do
						if (FlatIdent_1B30C == 0) then
							if origAmb then
								Lighting.Ambient = origAmb;
							end
							Lighting.Brightness = 1;
							break;
						end
					end
				end);
			end
			break;
		end
	end
end);
tNoFog.on(function(s)
	local FlatIdent_739F3 = 0;
	while true do
		if (FlatIdent_739F3 == 0) then
			if fogC then
				local FlatIdent_733BE = 0;
				while true do
					if (FlatIdent_733BE == 0) then
						fogC:Disconnect();
						fogC = nil;
						break;
					end
				end
			end
			if s then
				local FlatIdent_65844 = 0;
				while true do
					if (FlatIdent_65844 == 0) then
						origFog = Lighting.FogEnd;
						fogC = RunService.Heartbeat:Connect(function()
							pcall(function()
								Lighting.FogEnd = 1000000000;
							end);
						end);
						break;
					end
				end
			else
				pcall(function()
					if origFog then
						Lighting.FogEnd = origFog;
					end
				end);
			end
			break;
		end
	end
end);
tAntiSlow.on(function(s)
	if slowC then
		slowC:Disconnect();
		slowC = nil;
	end
	if s then
		slowC = RunService.Heartbeat:Connect(function()
			pcall(function()
				local FlatIdent_2789B = 0;
				local h;
				while true do
					if (FlatIdent_2789B == 0) then
						h = ghum();
						if (h and (h.WalkSpeed < 16)) then
							h.WalkSpeed = (spdA and sSpd.val) or 16;
						end
						break;
					end
				end
			end);
		end);
	end
end);
tAntiAfk.on(function(s)
	if s then
		pcall(function()
			if getconnections then
				for _, c in ipairs(getconnections(lp.Idled)) do
					c:Disable();
				end
			end
		end);
	end
end);
tFreecam.on(function(s)
	if fcC then
		fcC:Disconnect();
		fcC = nil;
	end
	if s then
		pcall(function()
			local FlatIdent_9874B = 0;
			local cf;
			local _;
			local y;
			local h;
			while true do
				if (4 == FlatIdent_9874B) then
					if h then
						h.WalkSpeed = 0;
					end
					break;
				end
				if (FlatIdent_9874B == 1) then
					_, y, _ = cf:ToEulerAnglesYXZ();
					fcYaw = y;
					FlatIdent_9874B = 2;
				end
				if (FlatIdent_9874B == 2) then
					fcPitch = 0;
					cam.CameraType = Enum.CameraType.Scriptable;
					FlatIdent_9874B = 3;
				end
				if (FlatIdent_9874B == 3) then
					UIS.MouseBehavior = Enum.MouseBehavior.LockCenter;
					h = ghum();
					FlatIdent_9874B = 4;
				end
				if (FlatIdent_9874B == 0) then
					cf = cam.CFrame;
					fcPos = cf.Position;
					FlatIdent_9874B = 1;
				end
			end
		end);
		fcC = RunService.RenderStepped:Connect(function(dt)
			pcall(function()
				local delta = UIS:GetMouseDelta();
				fcYaw = fcYaw - (delta.X * 0.004);
				fcPitch = math.clamp(fcPitch - (delta.Y * 0.004), -1.4, 1.4);
				local rot = CFrame.Angles(0, fcYaw, 0) * CFrame.Angles(fcPitch, 0, 0);
				local speed = 60 * dt;
				local d = Vector3.zero;
				if (keys[Enum.KeyCode.W] or keys[Enum.KeyCode.Z]) then
					d = d + rot.LookVector;
				end
				if keys[Enum.KeyCode.S] then
					d = d - rot.LookVector;
				end
				if (keys[Enum.KeyCode.A] or keys[Enum.KeyCode.Q]) then
					d = d - rot.RightVector;
				end
				if keys[Enum.KeyCode.D] then
					d = d + rot.RightVector;
				end
				if (keys[Enum.KeyCode.E] or keys[Enum.KeyCode.Space]) then
					d = d + Vector3.yAxis;
				end
				if (keys[Enum.KeyCode.C] or keys[Enum.KeyCode.LeftShift]) then
					d = d - Vector3.yAxis;
				end
				if (d.Magnitude > 0) then
					fcPos = fcPos + (d.Unit * speed);
				end
				cam.CFrame = CFrame.new(fcPos) * rot;
				UIS.MouseBehavior = Enum.MouseBehavior.LockCenter;
			end);
		end);
	else
		pcall(function()
			local FlatIdent_654E4 = 0;
			local h;
			while true do
				if (FlatIdent_654E4 == 1) then
					cam.CameraSubject = gc():FindFirstChildOfClass("Humanoid");
					h = ghum();
					FlatIdent_654E4 = 2;
				end
				if (2 == FlatIdent_654E4) then
					if h then
						h.WalkSpeed = (spdA and sSpd.val) or 16;
					end
					break;
				end
				if (FlatIdent_654E4 == 0) then
					cam.CameraType = Enum.CameraType.Custom;
					UIS.MouseBehavior = Enum.MouseBehavior.Default;
					FlatIdent_654E4 = 1;
				end
			end
		end);
	end
end);
local aimCache = nil;
local aimCacheTime = 0;
local function GetAimTarget()
	local FlatIdent_179D7 = 0;
	local now;
	local best;
	local bd;
	local m;
	while true do
		if (FlatIdent_179D7 == 3) then
			if AIM.tgtN then
				for _, v in ipairs(WS:GetChildren()) do
					pcall(function()
						if (v:IsA("Model") and (v ~= gc()) and not Players:GetPlayerFromCharacter(v)) then
							local FlatIdent_57893 = 0;
							local h;
							while true do
								if (FlatIdent_57893 == 0) then
									h = v:FindFirstChildOfClass("Humanoid");
									if (h and (h.Health > 0)) then
										local FlatIdent_65565 = 0;
										local head;
										while true do
											if (FlatIdent_65565 == 0) then
												head = v:FindFirstChild("Head") or v:FindFirstChild("HumanoidRootPart");
												if head then
													local FlatIdent_47BE5 = 0;
													local sp;
													local on;
													while true do
														if (FlatIdent_47BE5 == 0) then
															sp, on = cam:WorldToViewportPoint(head.Position);
															if on then
																local d = (Vector2.new(sp.X, sp.Y) - m).Magnitude;
																if (d < bd) then
																	local FlatIdent_5550 = 0;
																	while true do
																		if (FlatIdent_5550 == 0) then
																			if (AIM.wall and not LOS(cam.CFrame.Position, head.Position)) then
																				return;
																			end
																			best = head;
																			FlatIdent_5550 = 1;
																		end
																		if (FlatIdent_5550 == 1) then
																			bd = d;
																			break;
																		end
																	end
																end
															end
															break;
														end
													end
												end
												break;
											end
										end
									end
									break;
								end
							end
						end
					end);
				end
			end
			aimCache = best;
			FlatIdent_179D7 = 4;
		end
		if (2 == FlatIdent_179D7) then
			m = UIS:GetMouseLocation();
			if AIM.tgtP then
				for _, p in ipairs(Players:GetPlayers()) do
					if ((p ~= lp) and p.Character) then
						if not (AIM.team and p.Team and (p.Team == lp.Team)) then
							pcall(function()
								local h = p.Character:FindFirstChildOfClass("Humanoid");
								if (not h or (h.Health <= 0)) then
									return;
								end
								local head = p.Character:FindFirstChild("Head");
								if not head then
									return;
								end
								local sp, on = cam:WorldToViewportPoint(head.Position);
								if not on then
									return;
								end
								local d = (Vector2.new(sp.X, sp.Y) - m).Magnitude;
								if (d < bd) then
									local FlatIdent_67611 = 0;
									while true do
										if (FlatIdent_67611 == 1) then
											bd = d;
											break;
										end
										if (FlatIdent_67611 == 0) then
											if (AIM.wall and not LOS(cam.CFrame.Position, head.Position)) then
												return;
											end
											best = head;
											FlatIdent_67611 = 1;
										end
									end
								end
							end);
						end
					end
				end
			end
			FlatIdent_179D7 = 3;
		end
		if (FlatIdent_179D7 == 4) then
			return best;
		end
		if (FlatIdent_179D7 == 0) then
			now = tick();
			if (((now - aimCacheTime) < 0.05) and aimCache and aimCache.Parent) then
				return aimCache;
			end
			FlatIdent_179D7 = 1;
		end
		if (FlatIdent_179D7 == 1) then
			aimCacheTime = now;
			best, bd = nil, AIM.fov;
			FlatIdent_179D7 = 2;
		end
	end
end
RunService.RenderStepped:Connect(function()
	local FlatIdent_57FF4 = 0;
	while true do
		if (FlatIdent_57FF4 == 0) then
			if FC then
				pcall(function()
					local m = UIS:GetMouseLocation();
					FC.Visible = AIM.showFov and AIM.on;
					if FC.Visible then
						local FlatIdent_78D43 = 0;
						while true do
							if (FlatIdent_78D43 == 0) then
								FC.Position = Vector2.new(m.X, m.Y);
								FC.Radius = AIM.fov;
								break;
							end
						end
					end
				end);
			end
			if AIM.on then
				pcall(function()
					if UIS:IsMouseButtonPressed(Enum.UserInputType.MouseButton2) then
						local FlatIdent_3174 = 0;
						local t;
						while true do
							if (FlatIdent_3174 == 0) then
								t = GetAimTarget();
								if (t and t.Parent) then
									local FlatIdent_694C5 = 0;
									local ap;
									while true do
										if (FlatIdent_694C5 == 0) then
											ap = t.Position;
											if AIM.pred then
												local FlatIdent_415E2 = 0;
												local vel;
												while true do
													if (0 == FlatIdent_415E2) then
														vel = t.AssemblyLinearVelocity;
														if vel then
															ap = ap + (vel * AIM.predV);
														end
														break;
													end
												end
											end
											FlatIdent_694C5 = 1;
										end
										if (FlatIdent_694C5 == 1) then
											if AIM.smooth then
												cam.CFrame = cam.CFrame:Lerp(CFrame.new(cam.CFrame.Position, ap), AIM.smoothV);
											else
												cam.CFrame = CFrame.new(cam.CFrame.Position, ap);
											end
											break;
										end
									end
								end
								break;
							end
						end
					end
				end);
			end
			break;
		end
	end
end);
local clickActive = false;
tAutoClick.on(function(s)
	clickActive = s;
	if s then
		task.spawn(function()
			local FlatIdent_5805E = 0;
			local VIM;
			local useVIM;
			while true do
				if (FlatIdent_5805E == 2) then
					useVIM = VIM ~= nil;
					while clickActive do
						local shouldClick = true;
						if tClickHold.get() then
							shouldClick = UIS:IsMouseButtonPressed(Enum.UserInputType.MouseButton1);
						end
						if shouldClick then
							local mx, my = mouse.X, mouse.Y;
							local button = (tClickRight.get() and 1) or 0;
							if useVIM then
								local FlatIdent_9876 = 0;
								while true do
									if (FlatIdent_9876 == 0) then
										pcall(function()
											VIM:SendMouseButtonEvent(mx, my, button, true, game, 0);
										end);
										task.wait(0.016);
										FlatIdent_9876 = 1;
									end
									if (FlatIdent_9876 == 1) then
										pcall(function()
											VIM:SendMouseButtonEvent(mx, my, button, false, game, 0);
										end);
										break;
									end
								end
							else
								pcall(function()
									if mouse1click then
										mouse1click();
									end
								end);
							end
						end
						local cps = math.max(sClickSpd.val, 1);
						local baseDelay = 1 / cps;
						local jitterPct = sClickJitter.val / 100;
						if (jitterPct > 0) then
							local FlatIdent_5B790 = 0;
							while true do
								if (FlatIdent_5B790 == 0) then
									baseDelay = baseDelay + ((math.random() - 0.5) * 2 * baseDelay * jitterPct);
									baseDelay = math.max(baseDelay, 0.01);
									break;
								end
							end
						end
						task.wait(baseDelay);
					end
					break;
				end
				if (FlatIdent_5805E == 1) then
					if not VIM then
						pcall(function()
							VIM = game:FindService("VirtualInputManager");
						end);
					end
					if not VIM then
						pcall(function()
							if cloneref then
								VIM = cloneref(game:GetService("VirtualInputManager"));
							end
						end);
					end
					FlatIdent_5805E = 2;
				end
				if (FlatIdent_5805E == 0) then
					VIM = nil;
					pcall(function()
						VIM = game:GetService("VirtualInputManager");
					end);
					FlatIdent_5805E = 1;
				end
			end
		end);
	end
end);
sSpd.cb = function(v)
	local FlatIdent_91AE4 = 0;
	while true do
		if (FlatIdent_91AE4 == 0) then
			spdA = v ~= 16;
			pcall(function()
				ghum().WalkSpeed = v;
			end);
			break;
		end
	end
end;
sFov.cb = function(v)
	pcall(function()
		cam.FieldOfView = v;
	end);
end;
RunService.Heartbeat:Connect(function()
	pcall(function()
		local FlatIdent_99831 = 0;
		local h;
		while true do
			if (0 == FlatIdent_99831) then
				h = ghum();
				if (h and not tFreecam.get()) then
					if spdA then
						h.WalkSpeed = sSpd.val;
					end
				end
				break;
			end
		end
	end);
end);
lp.CharacterAdded:Connect(function()
	local FlatIdent_5C9D7 = 0;
	while true do
		if (FlatIdent_5C9D7 == 2) then
			FL.stop();
			task.wait(2);
			FlatIdent_5C9D7 = 3;
		end
		if (FlatIdent_5C9D7 == 1) then
			if tFreecam.get() then
				tFreecam.set(false);
			end
			if tSpin.get() then
				tSpin.set(false);
			end
			FlatIdent_5C9D7 = 2;
		end
		if (FlatIdent_5C9D7 == 0) then
			if flying then
				tFly.set(false);
			end
			if ncOn then
				tNoclip.set(false);
			end
			FlatIdent_5C9D7 = 1;
		end
		if (FlatIdent_5C9D7 == 3) then
			FL.busy = false;
			break;
		end
	end
end);
stab("Move");
game:GetService("StarterGui"):SetCore("SendNotification", {Title="Avocat Hub",Text="V1.0 loaded",Duration=3});
