local TweenService     = game:GetService("TweenService")
local UserInputService = game:GetService("UserInputService")
local Players          = game:GetService("Players")
local HttpService      = game:GetService("HttpService")
local CoreGui          = game:GetService("CoreGui")

local Lithium = {}
Lithium.__index = Lithium
Lithium.Version = "0.0.1"
Lithium.Flags   = {}

Lithium.Themes = {
	Dark = {
		Bg          = Color3.fromRGB(10, 10, 13),
		Surface     = Color3.fromRGB(16, 16, 20),
		SurfaceAlt  = Color3.fromRGB(21, 21, 27),
		SurfaceHov  = Color3.fromRGB(26, 26, 34),
		Border      = Color3.fromRGB(32, 32, 44),
		BorderHov   = Color3.fromRGB(50, 50, 68),
		Accent      = Color3.fromRGB(124, 99, 255),
		AccentHov   = Color3.fromRGB(144, 119, 255),
		AccentDim   = Color3.fromRGB(60, 45, 130),
		Text        = Color3.fromRGB(232, 232, 244),
		TextSub     = Color3.fromRGB(145, 145, 168),
		TextMuted   = Color3.fromRGB(75, 75, 98),
		Success     = Color3.fromRGB(72, 200, 130),
		Warning     = Color3.fromRGB(255, 180, 45),
		Error       = Color3.fromRGB(255, 78, 78),
		ToggleOn    = Color3.fromRGB(124, 99, 255),
		ToggleOff   = Color3.fromRGB(36, 36, 50),
		SliderFill  = Color3.fromRGB(124, 99, 255),
		SliderBg    = Color3.fromRGB(26, 26, 36),
		TabActive   = Color3.fromRGB(124, 99, 255),
		TabInactive = Color3.fromRGB(75, 75, 98),
		TabBg       = Color3.fromRGB(12, 12, 16),
		Scrollbar   = Color3.fromRGB(44, 44, 62),
	},
	Midnight = {
		Bg          = Color3.fromRGB(6, 8, 14),
		Surface     = Color3.fromRGB(11, 13, 22),
		SurfaceAlt  = Color3.fromRGB(15, 18, 30),
		SurfaceHov  = Color3.fromRGB(20, 24, 40),
		Border      = Color3.fromRGB(28, 32, 52),
		BorderHov   = Color3.fromRGB(44, 50, 80),
		Accent      = Color3.fromRGB(56, 136, 255),
		AccentHov   = Color3.fromRGB(76, 156, 255),
		AccentDim   = Color3.fromRGB(24, 68, 150),
		Text        = Color3.fromRGB(228, 232, 248),
		TextSub     = Color3.fromRGB(135, 142, 172),
		TextMuted   = Color3.fromRGB(65, 72, 105),
		Success     = Color3.fromRGB(60, 196, 124),
		Warning     = Color3.fromRGB(255, 178, 40),
		Error       = Color3.fromRGB(255, 72, 72),
		ToggleOn    = Color3.fromRGB(56, 136, 255),
		ToggleOff   = Color3.fromRGB(28, 32, 52),
		SliderFill  = Color3.fromRGB(56, 136, 255),
		SliderBg    = Color3.fromRGB(20, 24, 40),
		TabActive   = Color3.fromRGB(56, 136, 255),
		TabInactive = Color3.fromRGB(65, 72, 105),
		TabBg       = Color3.fromRGB(8, 10, 18),
		Scrollbar   = Color3.fromRGB(36, 42, 70),
	},
	Rose = {
		Bg          = Color3.fromRGB(10, 7, 10),
		Surface     = Color3.fromRGB(16, 11, 16),
		SurfaceAlt  = Color3.fromRGB(22, 15, 22),
		SurfaceHov  = Color3.fromRGB(28, 19, 28),
		Border      = Color3.fromRGB(40, 26, 40),
		BorderHov   = Color3.fromRGB(60, 38, 60),
		Accent      = Color3.fromRGB(224, 76, 124),
		AccentHov   = Color3.fromRGB(244, 96, 144),
		AccentDim   = Color3.fromRGB(112, 34, 64),
		Text        = Color3.fromRGB(240, 228, 234),
		TextSub     = Color3.fromRGB(158, 134, 146),
		TextMuted   = Color3.fromRGB(90, 68, 80),
		Success     = Color3.fromRGB(72, 200, 130),
		Warning     = Color3.fromRGB(255, 180, 45),
		Error       = Color3.fromRGB(255, 78, 78),
		ToggleOn    = Color3.fromRGB(224, 76, 124),
		ToggleOff   = Color3.fromRGB(40, 26, 40),
		SliderFill  = Color3.fromRGB(224, 76, 124),
		SliderBg    = Color3.fromRGB(28, 18, 28),
		TabActive   = Color3.fromRGB(224, 76, 124),
		TabInactive = Color3.fromRGB(90, 68, 80),
		TabBg       = Color3.fromRGB(12, 8, 12),
		Scrollbar   = Color3.fromRGB(52, 34, 52),
	},
}
Lithium.CurrentTheme = "Dark"

local function tween(o, p, t, s, d)
	local tw = TweenService:Create(o, TweenInfo.new(t or 0.2, s or Enum.EasingStyle.Quart, d or Enum.EasingDirection.Out), p)
	tw:Play(); return tw
end
local function spring(o, p, t) return tween(o, p, t or 0.35, Enum.EasingStyle.Back, Enum.EasingDirection.Out) end
local function lerp(a,b,t) return a+(b-a)*t end
local function lerpC(a,b,t) return Color3.new(lerp(a.R,b.R,t),lerp(a.G,b.G,t),lerp(a.B,b.B,t)) end

local function corner(p, r) local c=Instance.new("UICorner",p); c.CornerRadius=UDim.new(0,r or 8); return c end
local function stroke(p, c, th, tr) local s=Instance.new("UIStroke",p); s.Color=c; s.Thickness=th or 1; s.Transparency=tr or 0; return s end
local function padding(p, t, b, l, r)
	local pad=Instance.new("UIPadding",p)
	pad.PaddingTop=UDim.new(0,t or 0); pad.PaddingBottom=UDim.new(0,b or 0)
	pad.PaddingLeft=UDim.new(0,l or 0); pad.PaddingRight=UDim.new(0,r or 0)
	return pad
end
local function listLayout(p, fd, ha, va, pad)
	local l=Instance.new("UIListLayout",p)
	l.SortOrder=Enum.SortOrder.LayoutOrder
	l.FillDirection=fd or Enum.FillDirection.Vertical
	l.HorizontalAlignment=ha or Enum.HorizontalAlignment.Left
	l.VerticalAlignment=va or Enum.VerticalAlignment.Top
	if pad then l.Padding=UDim.new(0,pad) end
	return l
end

local function makeFrame(p, s, pos, c, r, n, zindex)
	local f=Instance.new("Frame")
	f.Name=n or "Frame"; f.Size=s; f.Position=pos
	f.BackgroundColor3=c; f.BorderSizePixel=0
	if zindex then f.ZIndex=zindex end
	f.Parent=p; corner(f,r); return f
end

local function makeLabel(p, txt, s, pos, c, ts, font, xa, n)
	local l=Instance.new("TextLabel")
	l.Name=n or "Lbl"; l.Size=s; l.Position=pos
	l.BackgroundTransparency=1; l.BorderSizePixel=0
	l.Text=txt; l.TextColor3=c; l.TextSize=ts or 13
	l.Font=font or Enum.Font.Gotham
	l.TextXAlignment=xa or Enum.TextXAlignment.Left
	l.TextYAlignment=Enum.TextYAlignment.Center
	l.Parent=p; return l
end

local function makeBtn(p, s, pos, c, r, n)
	local b=Instance.new("TextButton")
	b.Name=n or "Btn"; b.Size=s; b.Position=pos
	b.BackgroundColor3=c; b.BorderSizePixel=0
	b.Text=""; b.AutoButtonColor=false; b.Parent=p
	corner(b,r); return b
end

local function makeShadow(p)
	local s=Instance.new("ImageLabel",p)
	s.Name="Shadow"; s.BackgroundTransparency=1
	s.Image="rbxassetid://6014261993"
	s.ImageColor3=Color3.new(0,0,0); s.ImageTransparency=0.55
	s.ScaleType=Enum.ScaleType.Slice; s.SliceCenter=Rect.new(49,49,450,450)
	s.Size=UDim2.new(1,46,1,46); s.Position=UDim2.new(0,-23,0,6)
	s.ZIndex=math.max(1,p.ZIndex-1); return s
end

local function ripple(btn, x, y, col)
	local r=Instance.new("Frame",btn)
	r.BackgroundColor3=col or Color3.new(1,1,1)
	r.BackgroundTransparency=0.85; r.BorderSizePixel=0
	r.ZIndex=btn.ZIndex+10
	local ap=btn.AbsolutePosition; local as=btn.AbsoluteSize
	local rx=x-ap.X; local ry=y-ap.Y
	r.Size=UDim2.new(0,0,0,0); r.Position=UDim2.new(0,rx,0,ry)
	corner(r,999)
	local ms=math.max(as.X,as.Y)*2.8
	tween(r,{Size=UDim2.new(0,ms,0,ms),Position=UDim2.new(0,rx-ms/2,0,ry-ms/2),BackgroundTransparency=1},0.55,Enum.EasingStyle.Quad)
	task.delay(0.6,function() r:Destroy() end)
end

local notifHolder

local function getNotifHolder()
	if notifHolder and notifHolder.Parent then return notifHolder end
	local pg=Players.LocalPlayer:FindFirstChildOfClass("PlayerGui")
	local sg=Instance.new("ScreenGui")
	sg.Name="LithiumNotifs"; sg.ResetOnSpawn=false
	sg.DisplayOrder=9998; sg.ZIndexBehavior=Enum.ZIndexBehavior.Sibling
	pcall(function() sg.Parent=CoreGui end)
	if not sg.Parent then sg.Parent=pg end
	local holder=Instance.new("Frame",sg)
	holder.Name="Holder"; holder.BackgroundTransparency=1
	holder.Size=UDim2.new(0,300,1,0)
	holder.Position=UDim2.new(1,-312,0,0)
	holder.BorderSizePixel=0
	local ul=listLayout(holder,Enum.FillDirection.Vertical,Enum.HorizontalAlignment.Left,Enum.VerticalAlignment.Bottom,8)
	ul.VerticalAlignment=Enum.VerticalAlignment.Bottom
	padding(holder,0,14,0,0)
	notifHolder=holder
	return holder
end

function Lithium:Notify(opts)
	opts=opts or {}
	local theme=self.Themes[self.CurrentTheme]
	local title=opts.Title or "Notification"
	local content=opts.Content or ""
	local duration=opts.Duration or 4
	local ntype=opts.Type or "Info"

	local acCol=({Info=theme.Accent,Success=theme.Success,Warning=theme.Warning,Error=theme.Error})[ntype] or theme.Accent
	local icons=({Info="i",Success="✓",Warning="!",Error="✕"})

	local holder=getNotifHolder()

	local card=makeFrame(holder,UDim2.new(1,0,0,68),UDim2.new(0,0,0,0),theme.Surface,10,"Notif")
	card.ClipsDescendants=false
	stroke(card,theme.Border,1,0)
	makeShadow(card)

	local bar=makeFrame(card,UDim2.new(0,3,0,42),UDim2.new(0,8,0,13),acCol,2,"Bar")

	local iconF=makeFrame(card,UDim2.new(0,20,0,20),UDim2.new(0,18,0,14),acCol,10,"Icon")
	iconF.BackgroundTransparency=0.78
	makeLabel(iconF,icons[ntype] or "i",UDim2.new(1,0,1,0),UDim2.new(0,0,0,0),acCol,10,Enum.Font.GothamBold,Enum.TextXAlignment.Center)

	makeLabel(card,title,UDim2.new(1,-56,0,18),UDim2.new(0,46,0,10),theme.Text,12,Enum.Font.GothamBold)
	local cl=makeLabel(card,content,UDim2.new(1,-56,0,28),UDim2.new(0,46,0,28),theme.TextSub,11,Enum.Font.Gotham)
	cl.TextWrapped=true; cl.TextYAlignment=Enum.TextYAlignment.Top

	local progBg=makeFrame(card,UDim2.new(1,-16,0,2),UDim2.new(0,8,1,-4),theme.Border,1,"PBg")
	local prog=makeFrame(progBg,UDim2.new(1,0,1,0),UDim2.new(0,0,0,0),acCol,1,"P")

	card.Position=UDim2.new(1,16,0,0)
	card.BackgroundTransparency=0.06
	spring(card,{Position=UDim2.new(0,0,0,0)},0.42)
	tween(prog,{Size=UDim2.new(0,0,1,0)},duration,Enum.EasingStyle.Linear,Enum.EasingDirection.In)

	card.InputBegan:Connect(function(i)
		if i.UserInputType==Enum.UserInputType.MouseButton1 then
			tween(card,{Position=UDim2.new(1,16,0,0),BackgroundTransparency=1},0.22)
			task.delay(0.24,function() card:Destroy() end)
		end
	end)
	task.delay(duration,function()
		if card and card.Parent then
			tween(card,{Position=UDim2.new(1,16,0,0),BackgroundTransparency=1},0.28)
			task.delay(0.3,function() if card then card:Destroy() end end)
		end
	end)
end

function Lithium:CreateWindow(opts)
	opts=opts or {}
	local themeName=opts.Theme or self.CurrentTheme
	local T=self.Themes[themeName] or self.Themes.Dark
	self.CurrentTheme=themeName

	local title=opts.Title or "Lithium"
	local subtitle=opts.Subtitle or ""
	local W=opts.Size and opts.Size.X.Offset or 580
	local H=opts.Size and opts.Size.Y.Offset or 460
	local toggleKey=opts.ToggleKey or Enum.KeyCode.J
	local configName=opts.ConfigName
	local ksOpts=opts.KeySystem

	local pg=Players.LocalPlayer:FindFirstChildOfClass("PlayerGui")
	local sg=Instance.new("ScreenGui")
	sg.Name="Lithium_"..title; sg.ResetOnSpawn=false
	sg.ZIndexBehavior=Enum.ZIndexBehavior.Sibling; sg.DisplayOrder=100
	pcall(function() sg.Parent=CoreGui end)
	if not sg.Parent then sg.Parent=pg end

	local Main=Instance.new("Frame",sg)
	Main.Name="Main"; Main.Size=UDim2.new(0,W,0,H)
	Main.Position=UDim2.new(0.5,-W/2,0.5,-H/2)
	Main.BackgroundColor3=T.Bg; Main.BorderSizePixel=0
	Main.ClipsDescendants=false; Main.ZIndex=2
	corner(Main,16); stroke(Main,T.Border,1,0)
	makeShadow(Main)

	local TBar=makeFrame(Main,UDim2.new(1,0,0,46),UDim2.new(0,0,0,0),T.Surface,14,"TBar",3)
	local tfix=Instance.new("Frame",TBar)
	tfix.Size=UDim2.new(1,0,0,14); tfix.Position=UDim2.new(0,0,1,-14)
	tfix.BackgroundColor3=T.Surface; tfix.BorderSizePixel=0; tfix.ZIndex=TBar.ZIndex

	local topDivider=makeFrame(Main,UDim2.new(1,0,0,1),UDim2.new(0,0,0,46),T.Border,0,"TopDiv",3)

	local acLine=makeFrame(TBar,UDim2.new(0,28,0,2),UDim2.new(0,14,1,-1),T.Accent,1,"AcLine",TBar.ZIndex+1)

	local logoBox=makeFrame(TBar,UDim2.new(0,26,0,26),UDim2.new(0,14,0.5,-13),T.Accent,7,"Logo",TBar.ZIndex+2)
	makeLabel(logoBox,"L",UDim2.new(1,0,1,0),UDim2.new(0,0,0,0),Color3.new(1,1,1),15,Enum.Font.GothamBlack,Enum.TextXAlignment.Center,"LLbl").ZIndex=logoBox.ZIndex+1

	local titleLbl=makeLabel(TBar,title,UDim2.new(0,240,0,20),UDim2.new(0,48,0,6),T.Text,14,Enum.Font.GothamBold,Enum.TextXAlignment.Left,"TitleLbl")
	titleLbl.ZIndex=TBar.ZIndex+2
	local subLbl=makeLabel(TBar,subtitle,UDim2.new(0,240,0,14),UDim2.new(0,48,0,26),T.TextMuted,11,Enum.Font.Gotham,Enum.TextXAlignment.Left,"SubLbl")
	subLbl.ZIndex=TBar.ZIndex+2

	local closeBtn=Instance.new("TextButton",TBar)
	closeBtn.Name="Close"; closeBtn.Size=UDim2.new(0,28,0,28)
	closeBtn.Position=UDim2.new(1,-36,0.5,-14)
	closeBtn.BackgroundColor3=T.SurfaceAlt; closeBtn.BorderSizePixel=0
	closeBtn.Text="✕"; closeBtn.TextColor3=T.TextSub; closeBtn.TextSize=13
	closeBtn.Font=Enum.Font.GothamBold; closeBtn.AutoButtonColor=false
	closeBtn.ZIndex=TBar.ZIndex+3; corner(closeBtn,6)
	closeBtn.MouseEnter:Connect(function() tween(closeBtn,{BackgroundColor3=T.Error,TextColor3=Color3.new(1,1,1)},0.15) end)
	closeBtn.MouseLeave:Connect(function() tween(closeBtn,{BackgroundColor3=T.SurfaceAlt,TextColor3=T.TextSub},0.15) end)

	local minBtn=Instance.new("TextButton",TBar)
	minBtn.Name="Min"; minBtn.Size=UDim2.new(0,28,0,28)
	minBtn.Position=UDim2.new(1,-70,0.5,-14)
	minBtn.BackgroundColor3=T.SurfaceAlt; minBtn.BorderSizePixel=0
	minBtn.Text="−"; minBtn.TextColor3=T.TextSub; minBtn.TextSize=16
	minBtn.Font=Enum.Font.GothamBold; minBtn.AutoButtonColor=false
	minBtn.ZIndex=TBar.ZIndex+3; corner(minBtn,6)
	minBtn.MouseEnter:Connect(function() tween(minBtn,{BackgroundColor3=T.Warning,TextColor3=Color3.new(0,0,0)},0.15) end)
	minBtn.MouseLeave:Connect(function() tween(minBtn,{BackgroundColor3=T.SurfaceAlt,TextColor3=T.TextSub},0.15) end)

	local Content=Instance.new("Frame",Main)
	Content.Name="Content"; Content.BorderSizePixel=0
	Content.Size=UDim2.new(1,0,1,-94)
	Content.Position=UDim2.new(0,0,0,47)
	Content.BackgroundTransparency=1
	Content.ClipsDescendants=true
	Content.ZIndex=2

	local TabBar=makeFrame(Main,UDim2.new(1,0,0,48),UDim2.new(0,0,1,-48),T.TabBg,14,"TabBar",3)
	local tbfix2=Instance.new("Frame",TabBar)
	tbfix2.Size=UDim2.new(1,0,0,14); tbfix2.Position=UDim2.new(0,0,0,0)
	tbfix2.BackgroundColor3=T.TabBg; tbfix2.BorderSizePixel=0; tbfix2.ZIndex=TabBar.ZIndex

	local botDivider=makeFrame(Main,UDim2.new(1,0,0,1),UDim2.new(0,0,1,-49),T.Border,0,"BotDiv",3)

	local tabListHolder=Instance.new("Frame",TabBar)
	tabListHolder.Name="TabList"; tabListHolder.BackgroundTransparency=1
	tabListHolder.Size=UDim2.new(1,-16,1,0); tabListHolder.Position=UDim2.new(0,8,0,0)
	tabListHolder.BorderSizePixel=0; tabListHolder.ZIndex=TabBar.ZIndex+1
	local tll=listLayout(tabListHolder,Enum.FillDirection.Horizontal,Enum.HorizontalAlignment.Left,Enum.VerticalAlignment.Center,2)

	local indicator=makeFrame(TabBar,UDim2.new(0,40,0,2),UDim2.new(0,8,0,1),T.TabActive,1,"Ind",TabBar.ZIndex+8)

	local dragging,dragStart,startPos=false,nil,nil
	TBar.InputBegan:Connect(function(i)
		if i.UserInputType==Enum.UserInputType.MouseButton1 then
			dragging=true; dragStart=i.Position; startPos=Main.Position
		end
	end)
	UserInputService.InputChanged:Connect(function(i)
		if dragging and i.UserInputType==Enum.UserInputType.MouseMovement then
			local d=i.Position-dragStart
			Main.Position=UDim2.new(startPos.X.Scale,startPos.X.Offset+d.X,startPos.Y.Scale,startPos.Y.Offset+d.Y)
		end
	end)
	UserInputService.InputEnded:Connect(function(i)
		if i.UserInputType==Enum.UserInputType.MouseButton1 then dragging=false end
	end)

	local visible=true
	local minimized=false

	local function openUI()
		visible=true; Main.Visible=true
		Main.BackgroundTransparency=0.8
		Main.Size=UDim2.new(0,W,0,H*0.94)
		Content.Visible=true; TabBar.Visible=true
		tween(Main,{Size=UDim2.new(0,W,0,H),BackgroundTransparency=0},0.38,Enum.EasingStyle.Quint)
	end

	local function closeUI()
		visible=false
		tween(Main,{Size=UDim2.new(0,W,0,H*0.96),BackgroundTransparency=1},0.28,Enum.EasingStyle.Quint)
		task.delay(0.3,function()
			if not visible then
				Main.Visible=false
				Main.Size=UDim2.new(0,W,0,H)
				Main.BackgroundTransparency=0
			end
		end)
	end

	minBtn.MouseButton1Click:Connect(function()
		minimized=not minimized
		if minimized then
			Content.Visible=false; TabBar.Visible=false
			tween(Main,{Size=UDim2.new(0,W,0,46)},0.32,Enum.EasingStyle.Quint)
		else
			tween(Main,{Size=UDim2.new(0,W,0,H)},0.38,Enum.EasingStyle.Quint)
			task.delay(0.18,function() Content.Visible=true; TabBar.Visible=true end)
		end
	end)

	closeBtn.MouseButton1Click:Connect(function()
		tween(Main,{Size=UDim2.new(0,W,0,H*0.96),BackgroundTransparency=1},0.28,Enum.EasingStyle.Quint)
		task.delay(0.32,function() sg:Destroy() end)
	end)

	UserInputService.InputBegan:Connect(function(i,p)
		if not p and i.KeyCode==toggleKey then
			if visible then closeUI() else openUI() end
		end
	end)

	local Win={
		_sg=sg, _main=Main, _content=Content,
		_tabBar=TabBar, _tabList=tabListHolder, _indicator=indicator,
		_tabs={}, _active=nil, _theme=T, _config=configName,
		_W=W, _H=H,
	}

	function Win:SetTheme(name)
		local t=Lithium.Themes[name]; if not t then return end
		T=t; Lithium.CurrentTheme=name; self._theme=t
		Main.BackgroundColor3=t.Bg
		TBar.BackgroundColor3=t.Surface; tfix.BackgroundColor3=t.Surface
		topDivider.BackgroundColor3=t.Border; acLine.BackgroundColor3=t.Accent
		logoBox.BackgroundColor3=t.Accent; titleLbl.TextColor3=t.Text
		subLbl.TextColor3=t.TextMuted
		closeBtn.BackgroundColor3=t.SurfaceAlt; closeBtn.TextColor3=t.TextSub
		minBtn.BackgroundColor3=t.SurfaceAlt; minBtn.TextColor3=t.TextSub
		TabBar.BackgroundColor3=t.TabBg; tbfix2.BackgroundColor3=t.TabBg
		botDivider.BackgroundColor3=t.Border; indicator.BackgroundColor3=t.TabActive
	end

	function Win:AddTab(tabOpts)
		tabOpts=tabOpts or {}
		local tabName=tabOpts.Name or ("Tab "..#self._tabs+1)
		local th=self._theme

		local tabBtn=Instance.new("TextButton",self._tabList)
		tabBtn.Name="Tab_"..tabName
		tabBtn.Size=UDim2.new(0,80,0,40)
		tabBtn.BackgroundTransparency=1; tabBtn.BorderSizePixel=0
		tabBtn.Text=""; tabBtn.AutoButtonColor=false
		tabBtn.ZIndex=self._tabList.ZIndex+2
		local tabLbl=makeLabel(tabBtn,tabName,UDim2.new(1,0,1,0),UDim2.new(0,0,0,0),th.TabInactive,11,Enum.Font.GothamMedium,Enum.TextXAlignment.Center,"TLbl")
		tabLbl.ZIndex=tabBtn.ZIndex+1

		local dot=Instance.new("Frame",tabBtn)
		dot.Name="Dot"; dot.Size=UDim2.new(0,4,0,4)
		dot.Position=UDim2.new(0.5,-2,1,-7)
		dot.BackgroundColor3=th.TabInactive; dot.BackgroundTransparency=1
		dot.BorderSizePixel=0; dot.ZIndex=tabBtn.ZIndex+1
		corner(dot,2)

		local tabContent=Instance.new("Frame",self._content)
		tabContent.Name="TC_"..tabName
		tabContent.Size=UDim2.new(1,0,1,0)
		tabContent.Position=UDim2.new(0,0,0,0)
		tabContent.BackgroundTransparency=1; tabContent.BorderSizePixel=0
		tabContent.Visible=false; tabContent.ZIndex=2

		local leftScroll=Instance.new("ScrollingFrame",tabContent)
		leftScroll.Name="Left"; leftScroll.Size=UDim2.new(0.5,-8,1,-8)
		leftScroll.Position=UDim2.new(0,8,0,4)
		leftScroll.BackgroundTransparency=1; leftScroll.BorderSizePixel=0
		leftScroll.ScrollBarThickness=2; leftScroll.ScrollBarImageColor3=th.Scrollbar
		leftScroll.CanvasSize=UDim2.new(0,0,0,0); leftScroll.AutomaticCanvasSize=Enum.AutomaticSize.Y
		leftScroll.ScrollingDirection=Enum.ScrollingDirection.Y; leftScroll.ZIndex=2
		local ll=listLayout(leftScroll); ll.Padding=UDim.new(0,5)
		padding(leftScroll,4,8,0,4)

		local rightScroll=Instance.new("ScrollingFrame",tabContent)
		rightScroll.Name="Right"; rightScroll.Size=UDim2.new(0.5,-8,1,-8)
		rightScroll.Position=UDim2.new(0.5,2,0,4)
		rightScroll.BackgroundTransparency=1; rightScroll.BorderSizePixel=0
		rightScroll.ScrollBarThickness=2; rightScroll.ScrollBarImageColor3=th.Scrollbar
		rightScroll.CanvasSize=UDim2.new(0,0,0,0); rightScroll.AutomaticCanvasSize=Enum.AutomaticSize.Y
		rightScroll.ScrollingDirection=Enum.ScrollingDirection.Y; rightScroll.ZIndex=2
		local rl=listLayout(rightScroll); rl.Padding=UDim.new(0,5)
		padding(rightScroll,4,8,4,0)

		local Tab={
			_btn=tabBtn, _lbl=tabLbl, _dot=dot,
			_content=tabContent, _left=leftScroll, _right=rightScroll,
			_altRight=false, _theme=th, _win=self,
		}

		local function selectTab()
			if self._active==Tab then return end
			if self._active then
				tween(self._active._lbl,{TextColor3=th.TabInactive},0.2)
				tween(self._active._dot,{BackgroundTransparency=1},0.2)
				self._active._content.Visible=false
			end
			self._active=Tab
			tabContent.Visible=true
			tween(tabLbl,{TextColor3=th.TabActive},0.2)
			tween(dot,{BackgroundTransparency=0,BackgroundColor3=th.TabActive},0.2)
			task.defer(function()
				local bp=tabBtn.AbsolutePosition; local tlp=self._tabList.AbsolutePosition
				local relX=bp.X-tlp.X
				tween(self._indicator,{Size=UDim2.new(0,tabBtn.AbsoluteSize.X-16,0,2),Position=UDim2.new(0,relX+8,0,1)},0.25)
			end)
		end

		tabBtn.MouseButton1Click:Connect(function()
			selectTab()
			local mp=UserInputService:GetMouseLocation()
			ripple(tabBtn,mp.X,mp.Y,th.TabActive)
		end)
		tabBtn.MouseEnter:Connect(function()
			if self._active~=Tab then tween(tabLbl,{TextColor3=lerpC(th.TabInactive,th.TabActive,0.5)},0.15) end
		end)
		tabBtn.MouseLeave:Connect(function()
			if self._active~=Tab then tween(tabLbl,{TextColor3=th.TabInactive},0.15) end
		end)

		if #self._tabs==0 then task.defer(selectTab) end
		table.insert(self._tabs,Tab)

		function Tab:AddSection(sOpts)
			sOpts=sOpts or {}
			local sName=sOpts.Name or "Section"
			local side=sOpts.Side
			if not side then side=self._altRight and "Right" or "Left"; self._altRight=not self._altRight end
			local parent=(side=="Right") and self._right or self._left
			local t=self._theme

			local sec=Instance.new("Frame",parent)
			sec.Name="Sec_"..sName; sec.Size=UDim2.new(1,0,0,0)
			sec.AutomaticSize=Enum.AutomaticSize.Y
			sec.BackgroundColor3=t.SurfaceAlt; sec.BorderSizePixel=0
			corner(sec,12); stroke(sec,t.Border,1,0)
			sec.LayoutOrder=999

			local hdr=Instance.new("Frame",sec)
			hdr.Name="Hdr"; hdr.Size=UDim2.new(1,0,0,34)
			hdr.BackgroundTransparency=1; hdr.BorderSizePixel=0

			local hAccent=makeFrame(hdr,UDim2.new(0,2,0,14),UDim2.new(0,12,0.5,-7),t.Accent,1)
			makeLabel(hdr,sName,UDim2.new(1,-30,0,34),UDim2.new(0,22,0,0),t.TextSub,11,Enum.Font.GothamBold)

			local items=Instance.new("Frame",sec)
			items.Name="Items"; items.Size=UDim2.new(1,0,0,0)
			items.AutomaticSize=Enum.AutomaticSize.Y
			items.Position=UDim2.new(0,0,0,34)
			items.BackgroundTransparency=1; items.BorderSizePixel=0
			listLayout(items); items.ZIndex=sec.ZIndex
			padding(items,0,8,10,10)

			local S={_frame=sec,_items=items,_theme=t,_count=0}

			local function mkRow(n,h,autoY)
				local r=Instance.new("Frame",items)
				r.Name="R_"..n
				if autoY then
					r.Size=UDim2.new(1,0,0,0); r.AutomaticSize=Enum.AutomaticSize.Y
				else
					r.Size=UDim2.new(1,0,0,h or 32)
				end
				r.BackgroundTransparency=1; r.BorderSizePixel=0
				S._count+=1; r.LayoutOrder=S._count
				return r
			end

			function S:AddLabel(o)
				o=o or {}
				local r=mkRow(o.Text or "lbl",26)
				makeLabel(r,o.Text or "Label",UDim2.new(1,-4,1,0),UDim2.new(0,2,0,0),o.Color or t.TextSub,12,Enum.Font.Gotham)
				return r
			end

			function S:AddSeparator(o)
				o=o or {}
				local r=mkRow("sep",20)
				local line=makeFrame(r,UDim2.new(1,0,0,1),UDim2.new(0,0,0.5,0),t.Border,0)
				if o.Label and o.Label~="" then
					local lb=makeLabel(r," "..o.Label.." ",UDim2.new(0,0,1,0),UDim2.new(0.5,-30,0,0),t.TextMuted,10,Enum.Font.GothamMedium,Enum.TextXAlignment.Center)
					lb.AutomaticSize=Enum.AutomaticSize.X
					lb.BackgroundColor3=t.SurfaceAlt; lb.BackgroundTransparency=0
				end
				return r
			end

			function S:AddParagraph(o)
				o=o or {}
				local r=mkRow("para",0,true)
				padding(r,4,4,2,2)
				local inner=Instance.new("Frame",r)
				inner.Size=UDim2.new(1,0,0,0); inner.AutomaticSize=Enum.AutomaticSize.Y
				inner.BackgroundTransparency=1; inner.BorderSizePixel=0
				listLayout(inner); inner.Padding=UDim.new(0,2)
				if o.Title and o.Title~="" then
					local tl=makeLabel(inner,o.Title,UDim2.new(1,0,0,16),UDim2.new(0,0,0,0),t.Text,12,Enum.Font.GothamBold)
					tl.LayoutOrder=1
				end
				local cl=Instance.new("TextLabel",inner)
				cl.Size=UDim2.new(1,0,0,0); cl.AutomaticSize=Enum.AutomaticSize.Y
				cl.BackgroundTransparency=1; cl.Text=o.Content or ""
				cl.TextColor3=t.TextSub; cl.TextSize=11; cl.Font=Enum.Font.Gotham
				cl.TextWrapped=true; cl.TextXAlignment=Enum.TextXAlignment.Left
				cl.TextYAlignment=Enum.TextYAlignment.Top; cl.LayoutOrder=2
				return r
			end

			function S:AddButton(o)
				o=o or {}
				local n=o.Name or "Button"; local cb=o.Callback or function() end
				local style=o.Style or "Default"
				local r=mkRow(n,o.Description and 48 or 34)

				local bgCol=({Default=t.SurfaceHov,Filled=t.Accent,Danger=t.Error})[style] or t.SurfaceHov
				local btn=makeBtn(r,UDim2.new(1,0,0,26),UDim2.new(0,0,0,4),bgCol,6,"Btn")
				btn.ZIndex=r.ZIndex+1
				if style=="Default" then stroke(btn,t.Border,1,0) end

				local bl=makeLabel(btn,n,UDim2.new(1,-8,1,0),UDim2.new(0,4,0,0),
					style=="Filled" and Color3.new(1,1,1) or t.Text,12,Enum.Font.GothamMedium,Enum.TextXAlignment.Center)
				bl.ZIndex=btn.ZIndex+1

				if o.Description then
					makeLabel(r,o.Description,UDim2.new(1,0,0,14),UDim2.new(0,2,0,32),t.TextMuted,10,Enum.Font.Gotham)
				end

				btn.MouseEnter:Connect(function() tween(btn,{BackgroundColor3=lerpC(bgCol,Color3.new(1,1,1),0.06)},0.14) end)
				btn.MouseLeave:Connect(function() tween(btn,{BackgroundColor3=bgCol},0.14) end)
				btn.MouseButton1Down:Connect(function() tween(btn,{Size=UDim2.new(1,-4,0,24),Position=UDim2.new(0,2,0,5)},0.08) end)
				btn.MouseButton1Up:Connect(function() tween(btn,{Size=UDim2.new(1,0,0,26),Position=UDim2.new(0,0,0,4)},0.12) end)
				btn.MouseButton1Click:Connect(function()
					local mp=UserInputService:GetMouseLocation()
					ripple(btn,mp.X,mp.Y,style=="Filled" and Color3.new(1,1,1) or t.Accent)
					cb()
				end)
				return r
			end

			function S:AddToggle(o)
				o=o or {}
				local n=o.Name or "Toggle"; local def=o.Default or false
				local cb=o.Callback or function() end; local flag=o.Flag

				local r=mkRow(n,o.Description and 46 or 32)
				makeLabel(r,n,UDim2.new(1,-52,0,28),UDim2.new(0,2,0,2),t.Text,12,Enum.Font.GothamMedium)
				if o.Description then makeLabel(r,o.Description,UDim2.new(1,-52,0,14),UDim2.new(0,2,0,32),t.TextMuted,10,Enum.Font.Gotham) end

				local track=makeBtn(r,UDim2.new(0,36,0,18),UDim2.new(1,-40,0,7),def and t.ToggleOn or t.ToggleOff,9,"Track")
				track.ZIndex=r.ZIndex+2

				local thumb=makeFrame(track,UDim2.new(0,12,0,12),
					def and UDim2.new(1,-15,0.5,-6) or UDim2.new(0,3,0.5,-6),
					Color3.new(1,1,1),6,"Thumb",track.ZIndex+1)
				local ts=Instance.new("UIStroke",thumb); ts.Color=Color3.new(0,0,0); ts.Thickness=1; ts.Transparency=0.88

				local enabled=def
				if flag then Lithium.Flags[flag]=enabled end

				local function setVal(v,anim)
					enabled=v; if flag then Lithium.Flags[flag]=v end
					local d=anim and 0.22 or 0
					tween(track,{BackgroundColor3=v and t.ToggleOn or t.ToggleOff},d)
					spring(thumb,{Position=v and UDim2.new(1,-15,0.5,-6) or UDim2.new(0,3,0.5,-6)},d)
					cb(v)
				end
				track.MouseButton1Click:Connect(function() setVal(not enabled,true) end)

				local obj={Set=function(_,v) setVal(v,true) end,Get=function() return enabled end}
				return obj
			end

			function S:AddSlider(o)
				o=o or {}
				local n=o.Name or "Slider"; local mn=o.Min or 0; local mx=o.Max or 100
				local def=math.clamp(o.Default or mn,mn,mx); local cb=o.Callback or function() end
				local suf=o.Suffix or ""; local dec=o.Decimals or 0; local flag=o.Flag

				local r=mkRow(n,54)
				makeLabel(r,n,UDim2.new(0.62,0,0,18),UDim2.new(0,2,0,2),t.Text,12,Enum.Font.GothamMedium)
				local vLbl=makeLabel(r,tostring(def)..suf,UDim2.new(0.38,-6,0,18),UDim2.new(0.62,0,0,2),t.Accent,12,Enum.Font.GothamBold,Enum.TextXAlignment.Right,"VL")

				local trBg=makeFrame(r,UDim2.new(1,-4,0,4),UDim2.new(0,2,0,30),t.SliderBg,2,"TrBg")
				local fill=makeFrame(trBg,UDim2.new((def-mn)/(mx-mn),0,1,0),UDim2.new(0,0,0,0),t.SliderFill,2,"Fill")
				local knob=makeFrame(trBg,UDim2.new(0,12,0,12),UDim2.new((def-mn)/(mx-mn),-6,0.5,-6),Color3.new(1,1,1),6,"Knob",trBg.ZIndex+3)
				stroke(knob,t.SliderFill,2,0)

				local inputArea=makeBtn(trBg,UDim2.new(1,0,0,20),UDim2.new(0,0,0.5,-10),Color3.new(0,0,0))
				inputArea.BackgroundTransparency=1; inputArea.ZIndex=trBg.ZIndex+5

				local cur=def; if flag then Lithium.Flags[flag]=cur end

				local function setVal(v)
					local cl=math.clamp(v,mn,mx)
					local rd=tonumber(string.format("%."..(dec).."f",cl)); cur=rd
					if flag then Lithium.Flags[flag]=rd end
					local pc=(rd-mn)/(mx-mn)
					tween(fill,{Size=UDim2.new(pc,0,1,0)},0.08)
					tween(knob,{Position=UDim2.new(pc,-6,0.5,-6)},0.08)
					vLbl.Text=tostring(rd)..suf; cb(rd)
				end

				local sliding=false
				inputArea.MouseButton1Down:Connect(function()
					sliding=true
					spring(knob,{Size=UDim2.new(0,15,0,15),Position=UDim2.new((cur-mn)/(mx-mn),-7.5,0.5,-7.5)},0.18)
				end)
				UserInputService.InputEnded:Connect(function(i)
					if i.UserInputType==Enum.UserInputType.MouseButton1 and sliding then
						sliding=false
						spring(knob,{Size=UDim2.new(0,12,0,12),Position=UDim2.new((cur-mn)/(mx-mn),-6,0.5,-6)},0.18)
					end
				end)
				UserInputService.InputChanged:Connect(function(i)
					if sliding and i.UserInputType==Enum.UserInputType.MouseMovement then
						local ap=trBg.AbsolutePosition; local as=trBg.AbsoluteSize
						setVal(mn+(mx-mn)*math.clamp((i.Position.X-ap.X)/as.X,0,1))
					end
				end)

				local obj={Set=function(_,v) setVal(v) end,Get=function() return cur end}
				return obj
			end

			function S:AddDropdown(o)
				o=o or {}
				local n=o.Name or "Dropdown"; local list=o.Items or {}
				local def=o.Default or list[1]; local cb=o.Callback or function() end
				local multi=o.Multi or false; local flag=o.Flag

				local r=mkRow(n,34); r.ZIndex=(r.ZIndex or 1)+10; r.ClipsDescendants=false

				makeLabel(r,n,UDim2.new(0.46,0,0,26),UDim2.new(0,2,0,4),t.Text,12,Enum.Font.GothamMedium)

				local disp=makeBtn(r,UDim2.new(0.52,0,0,22),UDim2.new(0.48,0,0,6),t.Surface,6,"Disp")
				disp.ZIndex=r.ZIndex+2; stroke(disp,t.Border,1,0)

				local dispTxt=makeLabel(disp,tostring(def or "Select..."),UDim2.new(1,-20,1,0),UDim2.new(0,6,0,0),t.Text,11,Enum.Font.GothamMedium,Enum.TextXAlignment.Left,"DT")
				dispTxt.ZIndex=disp.ZIndex+1

				local arrow=makeLabel(disp,"▾",UDim2.new(0,14,1,0),UDim2.new(1,-16,0,0),t.TextMuted,11,Enum.Font.GothamBold,Enum.TextXAlignment.Center,"Arr")
				arrow.ZIndex=disp.ZIndex+1

				local dropF=makeFrame(r,UDim2.new(0.52,0,0,0),UDim2.new(0.48,0,0,30),t.Surface,7,"Drop")
				dropF.ClipsDescendants=true; dropF.ZIndex=r.ZIndex+22; dropF.Visible=false
				stroke(dropF,t.Border,1,0)

				local dScroll=Instance.new("ScrollingFrame",dropF)
				dScroll.Size=UDim2.new(1,0,1,0); dScroll.BackgroundTransparency=1
				dScroll.BorderSizePixel=0; dScroll.ScrollBarThickness=2
				dScroll.ScrollBarImageColor3=t.Scrollbar
				dScroll.CanvasSize=UDim2.new(0,0,0,0); dScroll.AutomaticCanvasSize=Enum.AutomaticSize.Y
				dScroll.ZIndex=dropF.ZIndex+1
				listLayout(dScroll); dScroll.ZIndex=dropF.ZIndex+1
				padding(dScroll,3,3,3,3)

				local sel={}; if def then sel[def]=true end

				local function rebuild()
					for _,c in ipairs(dScroll:GetChildren()) do if c:IsA("TextButton") then c:Destroy() end end
					for i,item in ipairs(list) do
						local ib=Instance.new("TextButton",dScroll)
						ib.Name="I"..i; ib.Size=UDim2.new(1,0,0,22)
						ib.BackgroundColor3=sel[item] and t.AccentDim or t.SurfaceAlt
						ib.BackgroundTransparency=sel[item] and 0.5 or 1
						ib.TextColor3=sel[item] and t.Text or t.TextSub
						ib.Text="  "..tostring(item); ib.TextSize=11; ib.Font=Enum.Font.Gotham
						ib.TextXAlignment=Enum.TextXAlignment.Left; ib.BorderSizePixel=0
						ib.AutoButtonColor=false; ib.LayoutOrder=i; ib.ZIndex=dScroll.ZIndex+1
						corner(ib,5)
						ib.MouseEnter:Connect(function() if not sel[item] then tween(ib,{BackgroundTransparency=0.75,BackgroundColor3=t.SurfaceHov},0.1) end end)
						ib.MouseLeave:Connect(function() if not sel[item] then tween(ib,{BackgroundTransparency=1},0.1) end end)
						ib.MouseButton1Click:Connect(function()
							if multi then sel[item]=not sel[item]
							else sel={}; sel[item]=true
								tween(dropF,{Size=UDim2.new(0.52,0,0,0)},0.18)
								task.delay(0.2,function() dropF.Visible=false end)
								tween(arrow,{Rotation=0},0.18)
							end
							local sv={}; for k,v in pairs(sel) do if v then table.insert(sv,k) end end
							dispTxt.Text=#sv==0 and "Select..." or (#sv==1 and tostring(sv[1]) or sv[1].." +"..#sv-1)
							if flag then Lithium.Flags[flag]=multi and sv or sv[1] end
							cb(multi and sv or sv[1]); rebuild()
						end)
					end
				end
				rebuild()

				local open=false
				disp.MouseButton1Click:Connect(function()
					open=not open
					if open then
						dropF.Visible=true
						local mh=math.min(#list*25+6,130)
						tween(dropF,{Size=UDim2.new(0.52,0,0,mh)},0.22)
						tween(arrow,{Rotation=180},0.18)
					else
						tween(dropF,{Size=UDim2.new(0.52,0,0,0)},0.18)
						task.delay(0.2,function() dropF.Visible=false end)
						tween(arrow,{Rotation=0},0.18)
					end
				end)

				local obj={
					Set=function(_,v) sel={}; if multi and type(v)=="table" then for _,i in ipairs(v) do sel[i]=true end else sel[v]=true end; rebuild() end,
					Refresh=function(_,nl) list=nl; sel={}; dispTxt.Text="Select..."; rebuild() end,
					Get=function() local sv={}; for k,v in pairs(sel) do if v then table.insert(sv,k) end end; return multi and sv or sv[1] end,
				}
				return obj
			end

			function S:AddTextbox(o)
				o=o or {}
				local n=o.Name or "Input"; local cb=o.Callback or function() end; local flag=o.Flag

				local r=mkRow(n,50)
				makeLabel(r,n,UDim2.new(1,-4,0,18),UDim2.new(0,2,0,2),t.Text,12,Enum.Font.GothamMedium)

				local bg=makeFrame(r,UDim2.new(1,0,0,24),UDim2.new(0,0,0,22),t.Surface,6,"TbBg")
				local tbS=stroke(bg,t.Border,1,0)

				local tb=Instance.new("TextBox",bg)
				tb.Size=UDim2.new(1,-12,1,0); tb.Position=UDim2.new(0,6,0,0)
				tb.BackgroundTransparency=1; tb.Text=o.Default or ""
				tb.PlaceholderText=o.Placeholder or "Type here..."
				tb.PlaceholderColor3=t.TextMuted; tb.TextColor3=t.Text
				tb.TextSize=11; tb.Font=Enum.Font.Gotham
				tb.TextXAlignment=Enum.TextXAlignment.Left
				tb.ClearTextOnFocus=o.ClearOnFocus~=false; tb.BorderSizePixel=0

				tb.Focused:Connect(function() tween(tbS,{Color=t.Accent},0.18) end)
				tb.FocusLost:Connect(function(enter)
					tween(tbS,{Color=t.Border},0.18)
					local v=o.Numeric and (tonumber(tb.Text) or 0) or tb.Text
					if flag then Lithium.Flags[flag]=v end; cb(v,enter)
				end)

				local obj={Set=function(_,v) tb.Text=tostring(v) end,Get=function() return tb.Text end}
				return obj
			end

			function S:AddKeybind(o)
				o=o or {}
				local n=o.Name or "Keybind"; local def=o.Default or Enum.KeyCode.Unknown
				local cb=o.Callback or function() end; local flag=o.Flag

				local r=mkRow(n,32)
				makeLabel(r,n,UDim2.new(1,-80,0,28),UDim2.new(0,2,0,2),t.Text,12,Enum.Font.GothamMedium)

				local kBtn=makeBtn(r,UDim2.new(0,64,0,20),UDim2.new(1,-68,0,6),t.Surface,6,"KBtn")
				kBtn.ZIndex=r.ZIndex+1; local kS=stroke(kBtn,t.Border,1,0)
				local kLbl=makeLabel(kBtn,def.Name or "None",UDim2.new(1,0,1,0),UDim2.new(0,0,0,0),t.Text,10,Enum.Font.GothamMedium,Enum.TextXAlignment.Center,"KL")
				kLbl.ZIndex=kBtn.ZIndex+1

				local listening=false; local cur=def
				if flag then Lithium.Flags[flag]=cur end

				kBtn.MouseButton1Click:Connect(function()
					if listening then return end
					listening=true; kLbl.Text="..."
					tween(kS,{Color=t.Accent},0.15)
					tween(kBtn,{BackgroundColor3=lerpC(t.Surface,t.Accent,0.12)},0.15)
				end)
				UserInputService.InputBegan:Connect(function(i,p)
					if listening and i.UserInputType==Enum.UserInputType.Keyboard then
						listening=false; cur=i.KeyCode; kLbl.Text=i.KeyCode.Name
						if flag then Lithium.Flags[flag]=cur end
						tween(kS,{Color=t.Border},0.15); tween(kBtn,{BackgroundColor3=t.Surface},0.15)
					elseif not p and i.KeyCode==cur then cb(cur) end
				end)

				local obj={Set=function(_,k) cur=k; kLbl.Text=k.Name end,Get=function() return cur end}
				return obj
			end

			function S:AddColorPicker(o)
				o=o or {}
				local n=o.Name or "Color"; local def=o.Default or Color3.fromRGB(124,99,255)
				local cb=o.Callback or function() end; local flag=o.Flag

				local r=mkRow(n,32)
				makeLabel(r,n,UDim2.new(1,-54,0,28),UDim2.new(0,2,0,2),t.Text,12,Enum.Font.GothamMedium)

				local prev=makeBtn(r,UDim2.new(0,42,0,20),UDim2.new(1,-46,0,6),def,7,"Prev")
				stroke(prev,t.Border,1,0)

				local popup=makeFrame(r,UDim2.new(0,180,0,0),UDim2.new(1,-184,0,30),t.Surface,8,"Pop")
				popup.ClipsDescendants=true; popup.ZIndex=r.ZIndex+20; popup.Visible=false
				stroke(popup,t.Border,1,0)

				local svArea=Instance.new("ImageLabel",popup)
				svArea.Size=UDim2.new(1,-12,0,96); svArea.Position=UDim2.new(0,6,0,8)
				svArea.BorderSizePixel=0; svArea.Image="rbxassetid://4155801252"
				svArea.ZIndex=popup.ZIndex+1; corner(svArea,5)

				local hueBg=makeFrame(popup,UDim2.new(1,-12,0,10),UDim2.new(0,6,0,112),t.Accent,4,"HueBg")
				hueBg.ZIndex=popup.ZIndex+1
				local hg=Instance.new("UIGradient",hueBg)
				hg.Color=ColorSequence.new({
					ColorSequenceKeypoint.new(0,Color3.fromRGB(255,0,0)),
					ColorSequenceKeypoint.new(0.167,Color3.fromRGB(255,255,0)),
					ColorSequenceKeypoint.new(0.333,Color3.fromRGB(0,255,0)),
					ColorSequenceKeypoint.new(0.5,Color3.fromRGB(0,255,255)),
					ColorSequenceKeypoint.new(0.667,Color3.fromRGB(0,0,255)),
					ColorSequenceKeypoint.new(0.833,Color3.fromRGB(255,0,255)),
					ColorSequenceKeypoint.new(1,Color3.fromRGB(255,0,0)),
				})

				local hexLbl=makeLabel(popup,"#"..string.format("%02X%02X%02X",math.floor(def.R*255),math.floor(def.G*255),math.floor(def.B*255)),
					UDim2.new(1,-12,0,14),UDim2.new(0,6,0,130),t.TextSub,10,Enum.Font.RobotoMono,Enum.TextXAlignment.Left,"Hex")
				hexLbl.ZIndex=popup.ZIndex+2

				local cH,cS,cV=Color3.toHSV(def); local curCol=def
				if flag then Lithium.Flags[flag]=curCol end

				local function upd()
					curCol=Color3.fromHSV(cH,cS,cV); prev.BackgroundColor3=curCol
					hexLbl.Text="#"..string.format("%02X%02X%02X",math.floor(curCol.R*255),math.floor(curCol.G*255),math.floor(curCol.B*255))
					if flag then Lithium.Flags[flag]=curCol end; cb(curCol)
				end

				local svCursor=Instance.new("Frame",svArea)
				svCursor.Name="SVCursor"; svCursor.Size=UDim2.new(0,10,0,10)
				svCursor.Position=UDim2.new(cS,-5,1-cV,-5)
				svCursor.BackgroundColor3=Color3.new(1,1,1); svCursor.BorderSizePixel=0
				svCursor.ZIndex=svArea.ZIndex+2; corner(svCursor,5)
				local svcs=Instance.new("UIStroke",svCursor); svcs.Color=Color3.new(0,0,0); svcs.Thickness=1; svcs.Transparency=0.5

				local svOverlay=Instance.new("Frame",svArea)
				svOverlay.Size=UDim2.new(1,0,1,0); svOverlay.BackgroundTransparency=1
				svOverlay.BorderSizePixel=0; svOverlay.ZIndex=svArea.ZIndex+1
				local svInput=Instance.new("TextButton",svOverlay)
				svInput.Size=UDim2.new(1,0,1,0); svInput.BackgroundTransparency=1
				svInput.Text=""; svInput.BorderSizePixel=0; svInput.ZIndex=svOverlay.ZIndex+1

				local svd=false
				svInput.InputBegan:Connect(function(i) if i.UserInputType==Enum.UserInputType.MouseButton1 then svd=true end end)
				UserInputService.InputEnded:Connect(function(i) if i.UserInputType==Enum.UserInputType.MouseButton1 then svd=false end end)
				UserInputService.InputChanged:Connect(function(i)
					if svd and i.UserInputType==Enum.UserInputType.MouseMovement then
						local ap=svArea.AbsolutePosition; local as=svArea.AbsoluteSize
						cS=math.clamp((i.Position.X-ap.X)/as.X,0,1)
						cV=1-math.clamp((i.Position.Y-ap.Y)/as.Y,0,1)
						svCursor.Position=UDim2.new(cS,-5,1-cV,-5)
						upd()
					end
				end)

				local popOpen=false
				prev.MouseButton1Click:Connect(function()
					popOpen=not popOpen
					if popOpen then popup.Visible=true; tween(popup,{Size=UDim2.new(0,180,0,152)},0.22)
					else tween(popup,{Size=UDim2.new(0,180,0,0)},0.18); task.delay(0.2,function() popup.Visible=false end) end
				end)
				local hd=false
				hueBg.InputBegan:Connect(function(i) if i.UserInputType==Enum.UserInputType.MouseButton1 then hd=true end end)
				UserInputService.InputEnded:Connect(function(i) if i.UserInputType==Enum.UserInputType.MouseButton1 then hd=false end end)
				UserInputService.InputChanged:Connect(function(i)
					if hd and i.UserInputType==Enum.UserInputType.MouseMovement then
						local ap=hueBg.AbsolutePosition; local as=hueBg.AbsoluteSize
						cH=math.clamp((i.Position.X-ap.X)/as.X,0,1)
						svArea.ImageColor3=Color3.fromHSV(cH,1,1)
						svCursor.Position=UDim2.new(cS,-5,1-cV,-5)
						upd()
					end
				end)

				local obj={Set=function(_,c) curCol=c; cH,cS,cV=Color3.toHSV(c); prev.BackgroundColor3=c; if flag then Lithium.Flags[flag]=c end end,Get=function() return curCol end}
				return obj
			end

			return S
		end

		return Tab
	end

	function Win:SaveConfig(name)
		local fn=name or configName; if not fn then return end
		local data={}
		for k,v in pairs(Lithium.Flags) do
			local vt=type(v)
			if vt=="boolean" or vt=="number" or vt=="string" then data[k]={t=vt,v=v} end
		end
		pcall(function() writefile(fn..".lithcfg",HttpService:JSONEncode(data)) end)
		Lithium:Notify({Title="Saved",Content=fn..".lithcfg",Type="Success",Duration=2})
	end

	function Win:LoadConfig(name)
		local fn=name or configName; if not fn then return end
		local ok,data=pcall(function() return HttpService:JSONDecode(readfile(fn..".lithcfg")) end)
		if ok and data then
			for k,v in pairs(data) do Lithium.Flags[k]=v.v end
			Lithium:Notify({Title="Loaded",Content=fn..".lithcfg",Type="Success",Duration=2})
		else
			Lithium:Notify({Title="Error",Content="Failed to load config.",Type="Error"})
		end
	end

	function Win:Destroy()
		tween(Main,{Size=UDim2.new(0,W,0,0),BackgroundTransparency=1},0.28,Enum.EasingStyle.Quint)
		task.delay(0.32,function() sg:Destroy() end)
	end

	if ksOpts and ksOpts.Enabled~=false then
		local ks=ksOpts
		local kpg=Players.LocalPlayer:FindFirstChildOfClass("PlayerGui")
		local ksg=Instance.new("ScreenGui")
		ksg.Name="LithiumKey"; ksg.ResetOnSpawn=false
		ksg.DisplayOrder=9999; ksg.ZIndexBehavior=Enum.ZIndexBehavior.Sibling
		pcall(function() ksg.Parent=CoreGui end)
		if not ksg.Parent then ksg.Parent=kpg end

		Main.Active=false
		for _,v in ipairs(Main:GetDescendants()) do
			if v:IsA("TextButton") or v:IsA("TextBox") or v:IsA("ScrollingFrame") then
				v.Active=false
			end
		end
		local keyBlur=Instance.new("BlurEffect",game:GetService("Lighting"))
		keyBlur.Size=0
		tween(keyBlur,{Size=20},0.45,Enum.EasingStyle.Quint)
		local overlay=Instance.new("Frame",ksg)
		overlay.Size=UDim2.new(1,0,1,0); overlay.BackgroundColor3=Color3.new(0,0,0)
		overlay.BackgroundTransparency=1; overlay.BorderSizePixel=0
		tween(overlay,{BackgroundTransparency=0.5},0.38)

		local kBox=makeFrame(overlay,UDim2.new(0,340,0,0),UDim2.new(0.5,-170,0.5,-100),T.Bg,14,"KBox")
		kBox.BackgroundTransparency=0.05; kBox.ClipsDescendants=true; stroke(kBox,T.Border,1,0); makeShadow(kBox)

		local topGlow=makeFrame(kBox,UDim2.new(1,0,0,2),UDim2.new(0,0,0,0),T.Accent,0)
		local tgc=Instance.new("UICorner",topGlow); tgc.CornerRadius=UDim.new(0,14)
		local tgfix=makeFrame(topGlow,UDim2.new(1,0,0.5,0),UDim2.new(0,0,0.5,0),T.Accent,0)

		local kLogo=makeFrame(kBox,UDim2.new(0,34,0,34),UDim2.new(0.5,-17,0,16),T.Accent,10,"KLogo")
		makeLabel(kLogo,"L",UDim2.new(1,0,1,0),UDim2.new(0,0,0,0),Color3.new(1,1,1),18,Enum.Font.GothamBlack,Enum.TextXAlignment.Center).ZIndex=kLogo.ZIndex+1

		makeLabel(kBox,ks.Title or "Key Required",UDim2.new(1,-20,0,20),UDim2.new(0,10,0,58),T.Text,14,Enum.Font.GothamBold,Enum.TextXAlignment.Center)
		makeLabel(kBox,ks.Subtitle or "Enter your key to continue",UDim2.new(1,-20,0,14),UDim2.new(0,10,0,80),T.TextSub,11,Enum.Font.Gotham,Enum.TextXAlignment.Center)

		local iBg=makeFrame(kBox,UDim2.new(1,-28,0,30),UDim2.new(0,14,0,104),T.Surface,8)
		local iS=stroke(iBg,T.Border,1,0)
		local kTb=Instance.new("TextBox",iBg)
		kTb.Size=UDim2.new(1,-16,1,0); kTb.Position=UDim2.new(0,8,0,0)
		kTb.BackgroundTransparency=1; kTb.Text=""; kTb.PlaceholderText="Enter key..."
		kTb.PlaceholderColor3=T.TextMuted; kTb.TextColor3=T.Text
		kTb.TextSize=12; kTb.Font=Enum.Font.GothamMedium
		kTb.TextXAlignment=Enum.TextXAlignment.Center; kTb.ClearTextOnFocus=true; kTb.BorderSizePixel=0
		kTb.Focused:Connect(function() tween(iS,{Color=T.Accent},0.18) end)
		kTb.FocusLost:Connect(function() tween(iS,{Color=T.Border},0.18) end)

		local statusLbl=makeLabel(kBox,ks.Note or "",UDim2.new(1,-20,0,14),UDim2.new(0,10,0,144),T.TextMuted,10,Enum.Font.Gotham,Enum.TextXAlignment.Center,"Stat")

		local hasGetKey = ks.GrabKey and ks.GrabKey ~= ""
		local kBoxH = hasGetKey and 260 or 218

		local confBtn=makeBtn(kBox,UDim2.new(1,-28,0,30),UDim2.new(0,14,0,162),T.Accent,8,"Conf")
		makeLabel(confBtn,"Confirm",UDim2.new(1,0,1,0),UDim2.new(0,0,0,0),Color3.new(1,1,1),13,Enum.Font.GothamBold,Enum.TextXAlignment.Center).ZIndex=confBtn.ZIndex+1
		confBtn.MouseEnter:Connect(function() tween(confBtn,{BackgroundColor3=T.AccentHov},0.14) end)
		confBtn.MouseLeave:Connect(function() tween(confBtn,{BackgroundColor3=T.Accent},0.14) end)

		if hasGetKey then
			local divLine = makeFrame(kBox, UDim2.new(1,-28,0,1), UDim2.new(0,14,0,202), T.Border, 0, "Div")

			local gBtn = makeBtn(kBox, UDim2.new(1,-28,0,30), UDim2.new(0,14,0,212), T.SurfaceAlt, 8, "GetKey")
			stroke(gBtn, T.Border, 1, 0)
			gBtn.ZIndex = kBox.ZIndex+2

			makeLabel(gBtn, "🔑", UDim2.new(0,22,1,0), UDim2.new(0,10,0,0), T.Accent, 13, Enum.Font.Gotham, Enum.TextXAlignment.Center, "Icon").ZIndex = gBtn.ZIndex+1
			local gLbl = makeLabel(gBtn, "Get Key", UDim2.new(1,-50,1,0), UDim2.new(0,34,0,0), T.Text, 12, Enum.Font.GothamMedium, Enum.TextXAlignment.Left, "GL")
			gLbl.ZIndex = gBtn.ZIndex+1
			local copyLbl = makeLabel(gBtn, "Copy Link →", UDim2.new(0,70,1,0), UDim2.new(1,-74,0,0), T.Accent, 11, Enum.Font.GothamMedium, Enum.TextXAlignment.Right, "CL")
			copyLbl.ZIndex = gBtn.ZIndex+1

			gBtn.MouseEnter:Connect(function()
				tween(gBtn, {BackgroundColor3=T.SurfaceHov}, 0.14)
				tween(copyLbl, {TextColor3=T.AccentHov}, 0.14)
			end)
			gBtn.MouseLeave:Connect(function()
				tween(gBtn, {BackgroundColor3=T.SurfaceAlt}, 0.14)
				tween(copyLbl, {TextColor3=T.Accent}, 0.14)
			end)
			gBtn.MouseButton1Down:Connect(function()
				tween(gBtn, {Size=UDim2.new(1,-32,0,28), Position=UDim2.new(0,16,0,213)}, 0.08)
			end)
			gBtn.MouseButton1Up:Connect(function()
				tween(gBtn, {Size=UDim2.new(1,-28,0,30), Position=UDim2.new(0,14,0,212)}, 0.12)
			end)
			gBtn.MouseButton1Click:Connect(function()
				pcall(function() setclipboard(ks.GrabKey) end)
				tween(gBtn, {BackgroundColor3=lerpC(T.SurfaceAlt, T.Success, 0.18)}, 0.15)
				tween(copyLbl, {TextColor3=T.Success}, 0.15)
				local origLbl = copyLbl.Text
				copyLbl.Text = "Copied! ✓"
				task.delay(1.8, function()
					tween(gBtn, {BackgroundColor3=T.SurfaceAlt}, 0.2)
					tween(copyLbl, {TextColor3=T.Accent}, 0.2)
					copyLbl.Text = origLbl
				end)
				Lithium:Notify({Title="Link Copied", Content="Key link copied to your clipboard.", Type="Success", Duration=3})
			end)
		end

		kBox.Size=UDim2.new(0,340,0,0)
		spring(kBox,{Size=UDim2.new(0,340,0,kBoxH)},0.45)

		local validated=false
		confBtn.MouseButton1Click:Connect(function()
			if kTb.Text==ks.Key then
				validated=true
				statusLbl.Text="✓ Access granted"; statusLbl.TextColor3=T.Success
				tween(confBtn,{BackgroundColor3=T.Success},0.2)
				task.delay(0.6, function()
					tween(keyBlur,{Size=0},0.4,Enum.EasingStyle.Quint)
					tween(overlay,{BackgroundTransparency=1},0.35)
					tween(kBox,{Size=UDim2.new(0,340,0,0),BackgroundTransparency=1},0.32,Enum.EasingStyle.Quint)
					task.delay(0.38,function()
						keyBlur:Destroy(); ksg:Destroy()
						Main.Active=true
						for _,v in ipairs(Main:GetDescendants()) do
							if v:IsA("TextButton") or v:IsA("TextBox") or v:IsA("ScrollingFrame") then
								v.Active=true
							end
						end
						showMainWindow()
					end)
				end)
			else
				statusLbl.Text="✕ Invalid key"; statusLbl.TextColor3=T.Error
				tween(kBox,{Position=UDim2.new(0.5,-178,0.5,-112)},0.06)
				task.delay(0.06,function() tween(kBox,{Position=UDim2.new(0.5,-162,0.5,-112)},0.06) end)
				task.delay(0.12,function() tween(kBox,{Position=UDim2.new(0.5,-170,0.5,-112)},0.1) end)
				task.delay(2.5,function() statusLbl.Text=ks.Note or ""; statusLbl.TextColor3=T.TextMuted end)
			end
		end)
	end

	local function showMainWindow()
		Main.Visible = true
		Main.BackgroundTransparency = 1
		Main.Size = UDim2.new(0, W, 0, H * 0.88)
		Main.Position = UDim2.new(0.5, -W/2, 0.5, -H/2 + 18)
		tween(Main, {
			BackgroundTransparency = 0,
			Size     = UDim2.new(0, W, 0, H),
			Position = UDim2.new(0.5, -W/2, 0.5, -H/2),
		}, 0.42, Enum.EasingStyle.Quint, Enum.EasingDirection.Out)
		task.delay(0.44, function()
			tween(Main, {
				Size     = UDim2.new(0, W, 0, H - 5),
				Position = UDim2.new(0.5, -W/2, 0.5, -H/2 + 2),
			}, 0.1, Enum.EasingStyle.Quad, Enum.EasingDirection.Out)
			task.delay(0.11, function()
				spring(Main, {
					Size     = UDim2.new(0, W, 0, H),
					Position = UDim2.new(0.5, -W/2, 0.5, -H/2),
				}, 0.38)
			end)
		end)
		task.delay(0.55, function()
			Lithium:Notify({
				Title   = "Lithium",
				Content = "Press "..toggleKey.Name.." to close/open the UI",
				Type    = "Info", Duration = 5,
			})
		end)
	end

	if ksOpts and ksOpts.Enabled ~= false then
		Main.Visible = false
	else
		showMainWindow()
	end

	return Win
end

function Lithium:SetTheme(n) self.CurrentTheme=n end
function Lithium:RegisterTheme(n,t) self.Themes[n]=t end

return Lithium
