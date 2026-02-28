local TweenService    = game:GetService("TweenService")
local UserInputService= game:GetService("UserInputService")
local RunService      = game:GetService("RunService")
local Players         = game:GetService("Players")
local HttpService     = game:GetService("HttpService")
local CoreGui         = game:GetService("CoreGui")

local Lithium = {}
Lithium.__index = Lithium
Lithium.Version  = "1.0.0"
Lithium.Windows  = {}
Lithium.Flags    = {}
Lithium.Connections = {}

Lithium.Themes = {
    Dark = {
        Background      = Color3.fromRGB(14, 14, 18),
        Surface         = Color3.fromRGB(20, 20, 26),
        SurfaceVariant  = Color3.fromRGB(28, 28, 36),
        Border          = Color3.fromRGB(42, 42, 54),
        BorderLight     = Color3.fromRGB(58, 58, 72),
        Accent          = Color3.fromRGB(99, 179, 237),
        AccentDark      = Color3.fromRGB(66, 139, 202),
        AccentGlow      = Color3.fromRGB(99, 179, 237),
        Text            = Color3.fromRGB(240, 240, 248),
        TextSecondary   = Color3.fromRGB(160, 160, 180),
        TextMuted       = Color3.fromRGB(100, 100, 120),
        Success         = Color3.fromRGB(72, 199, 142),
        Warning         = Color3.fromRGB(255, 189, 46),
        Error           = Color3.fromRGB(252, 100, 100),
        ToggleOn        = Color3.fromRGB(99, 179, 237),
        ToggleOff       = Color3.fromRGB(50, 50, 65),
        SliderFill      = Color3.fromRGB(99, 179, 237),
        SliderBack      = Color3.fromRGB(35, 35, 48),
        TabActive       = Color3.fromRGB(99, 179, 237),
        TabInactive     = Color3.fromRGB(100, 100, 120),
        TabBar          = Color3.fromRGB(18, 18, 24),
        Scrollbar       = Color3.fromRGB(60, 60, 80),
        NotifBg         = Color3.fromRGB(24, 24, 32),
        Shadow          = Color3.fromRGB(0, 0, 0),
    },
    Light = {
        Background      = Color3.fromRGB(245, 245, 252),
        Surface         = Color3.fromRGB(255, 255, 255),
        SurfaceVariant  = Color3.fromRGB(238, 238, 248),
        Border          = Color3.fromRGB(210, 210, 228),
        BorderLight     = Color3.fromRGB(190, 190, 215),
        Accent          = Color3.fromRGB(59, 130, 246),
        AccentDark      = Color3.fromRGB(37, 99, 235),
        AccentGlow      = Color3.fromRGB(59, 130, 246),
        Text            = Color3.fromRGB(20, 20, 40),
        TextSecondary   = Color3.fromRGB(80, 80, 110),
        TextMuted       = Color3.fromRGB(130, 130, 160),
        Success         = Color3.fromRGB(34, 197, 94),
        Warning         = Color3.fromRGB(234, 179, 8),
        Error           = Color3.fromRGB(239, 68, 68),
        ToggleOn        = Color3.fromRGB(59, 130, 246),
        ToggleOff       = Color3.fromRGB(200, 200, 220),
        SliderFill      = Color3.fromRGB(59, 130, 246),
        SliderBack      = Color3.fromRGB(218, 218, 235),
        TabActive       = Color3.fromRGB(59, 130, 246),
        TabInactive     = Color3.fromRGB(130, 130, 160),
        TabBar          = Color3.fromRGB(235, 235, 248),
        Scrollbar       = Color3.fromRGB(190, 190, 215),
        NotifBg         = Color3.fromRGB(255, 255, 255),
        Shadow          = Color3.fromRGB(100, 100, 130),
    },
}
Lithium.CurrentTheme = "Dark"

local Utility = {}

function Utility.Tween(instance, props, duration, easingStyle, easingDir, delay)
    local tweenInfo = TweenInfo.new(
        duration or 0.2,
        easingStyle or Enum.EasingStyle.Quart,
        easingDir   or Enum.EasingDirection.Out,
        0, false,
        delay or 0
    )
    local tween = TweenService:Create(instance, tweenInfo, props)
    tween:Play()
    return tween
end

function Utility.SpringTween(instance, props, duration)
    return Utility.Tween(instance, props, duration or 0.35, Enum.EasingStyle.Back, Enum.EasingDirection.Out)
end

function Utility.SmoothTween(instance, props, duration)
    return Utility.Tween(instance, props, duration or 0.25, Enum.EasingStyle.Quint, Enum.EasingDirection.Out)
end

function Utility.Lerp(a, b, t)
    return a + (b - a) * t
end

function Utility.LerpColor(a, b, t)
    return Color3.new(
        Utility.Lerp(a.R, b.R, t),
        Utility.Lerp(a.G, b.G, t),
        Utility.Lerp(a.B, b.B, t)
    )
end

function Utility.RoundedFrame(parent, size, position, color, radius, name)
    local f = Instance.new("Frame")
    f.Name              = name or "Frame"
    f.Size              = size
    f.Position          = position
    f.BackgroundColor3  = color
    f.BorderSizePixel   = 0
    f.Parent            = parent
    local corner        = Instance.new("UICorner", f)
    corner.CornerRadius = UDim.new(0, radius or 8)
    return f
end

function Utility.Label(parent, text, size, position, color, textSize, font, name, xAlignment)
    local l = Instance.new("TextLabel")
    l.Name              = name or "Label"
    l.Size              = size
    l.Position          = position
    l.BackgroundTransparency = 1
    l.Text              = text
    l.TextColor3        = color
    l.TextSize          = textSize or 14
    l.Font              = font or Enum.Font.Gotham
    l.TextXAlignment    = xAlignment or Enum.TextXAlignment.Left
    l.TextYAlignment    = Enum.TextYAlignment.Center
    l.Parent            = parent
    return l
end

function Utility.Button(parent, size, position, color, name)
    local b = Instance.new("TextButton")
    b.Name              = name or "Button"
    b.Size              = size
    b.Position          = position
    b.BackgroundColor3  = color
    b.BorderSizePixel   = 0
    b.Text              = ""
    b.AutoButtonColor   = false
    b.Parent            = parent
    local corner        = Instance.new("UICorner", b)
    corner.CornerRadius = UDim.new(0, 8)
    return b
end

function Utility.CreateStroke(parent, color, thickness, transparency)
    local stroke = Instance.new("UIStroke", parent)
    stroke.Color        = color
    stroke.Thickness    = thickness or 1
    stroke.Transparency = transparency or 0
    return stroke
end

function Utility.Ripple(button, x, y, theme)
    local ripple = Instance.new("Frame")
    ripple.Name              = "Ripple"
    ripple.BackgroundColor3  = theme.Accent
    ripple.BackgroundTransparency = 0.7
    ripple.BorderSizePixel   = 0
    ripple.ZIndex            = button.ZIndex + 5
    ripple.Size              = UDim2.new(0, 0, 0, 0)
    local absSize            = button.AbsoluteSize
    local absPos             = button.AbsolutePosition
    local relX               = x - absPos.X
    local relY               = y - absPos.Y
    ripple.Position          = UDim2.new(0, relX, 0, relY)
    local corner             = Instance.new("UICorner", ripple)
    corner.CornerRadius      = UDim.new(1, 0)
    ripple.Parent            = button
    local maxSize = math.max(absSize.X, absSize.Y) * 2.2
    Utility.Tween(ripple, {
        Size = UDim2.new(0, maxSize, 0, maxSize),
        Position = UDim2.new(0, relX - maxSize/2, 0, relY - maxSize/2),
        BackgroundTransparency = 1,
    }, 0.5, Enum.EasingStyle.Quad, Enum.EasingDirection.Out)
    task.delay(0.5, function() ripple:Destroy() end)
end

function Utility.Clip(parent)
    local clip = Instance.new("Frame")
    clip.Name                    = "ClipFrame"
    clip.Size                    = UDim2.new(1, 0, 1, 0)
    clip.BackgroundTransparency  = 1
    clip.ClipsDescendants        = true
    clip.BorderSizePixel         = 0
    clip.Parent                  = parent
    return clip
end

function Lithium:Theme()
    return self.Themes[self.CurrentTheme] or self.Themes.Dark
end

local NotifHolder
local NotifCount = 0

function Lithium:Notify(options)
    local theme = self:Theme()
    options = options or {}
    local title    = options.Title    or "Notification"
    local content  = options.Content  or ""
    local duration = options.Duration or 4
    local ntype    = options.Type     or "Info"
    local icon     = options.Icon

    if not NotifHolder or not NotifHolder.Parent then
        NotifHolder = Instance.new("Frame")
        NotifHolder.Name                 = "LithiumNotifHolder"
        NotifHolder.BackgroundTransparency = 1
        NotifHolder.Size                 = UDim2.new(0, 300, 1, 0)
        NotifHolder.Position             = UDim2.new(1, -316, 0, 0)
        NotifHolder.BorderSizePixel      = 0
        NotifHolder.ZIndex               = 999
        NotifHolder.Parent               = CoreGui:FindFirstChild("RobloxGui") or Players.LocalPlayer:WaitForChild("PlayerGui")
        local layout = Instance.new("UIListLayout", NotifHolder)
        layout.SortOrder              = Enum.SortOrder.LayoutOrder
        layout.VerticalAlignment      = Enum.VerticalAlignment.Bottom
        layout.Padding                = UDim.new(0, 8)
        local pad = Instance.new("UIPadding", NotifHolder)
        pad.PaddingBottom = UDim.new(0, 12)
    end

    NotifCount += 1
    local accentColor = ({
        Info    = theme.Accent,
        Success = theme.Success,
        Warning = theme.Warning,
        Error   = theme.Error,
    })[ntype] or theme.Accent

    local card = Instance.new("Frame")
    card.Name                 = "Notif_"..NotifCount
    card.BackgroundColor3     = theme.NotifBg
    card.BorderSizePixel      = 0
    card.Size                 = UDim2.new(1, 0, 0, 72)
    card.BackgroundTransparency = 0.08
    card.LayoutOrder           = NotifCount
    card.Parent               = NotifHolder

    local corner = Instance.new("UICorner", card)
    corner.CornerRadius = UDim.new(0, 10)
    Utility.CreateStroke(card, theme.Border, 1, 0.3)

    local bar = Instance.new("Frame", card)
    bar.Name              = "AccentBar"
    bar.Size              = UDim2.new(0, 3, 0.8, 0)
    bar.Position          = UDim2.new(0, 8, 0.1, 0)
    bar.BackgroundColor3  = accentColor
    bar.BorderSizePixel   = 0
    local bc = Instance.new("UICorner", bar)
    bc.CornerRadius = UDim.new(1, 0)

    local titleLabel = Utility.Label(card, title,
        UDim2.new(1, -28, 0, 22),
        UDim2.new(0, 20, 0, 8),
        theme.Text, 14, Enum.Font.GothamBold, "Title")

    local contentLabel = Utility.Label(card, content,
        UDim2.new(1, -28, 0, 36),
        UDim2.new(0, 20, 0, 30),
        theme.TextSecondary, 12, Enum.Font.Gotham, "Content")
    contentLabel.TextWrapped = true
    contentLabel.TextYAlignment = Enum.TextYAlignment.Top

    local progBack = Instance.new("Frame", card)
    progBack.Name             = "ProgressBack"
    progBack.Size             = UDim2.new(1, -16, 0, 2)
    progBack.Position         = UDim2.new(0, 8, 1, -4)
    progBack.BackgroundColor3 = theme.Border
    progBack.BorderSizePixel  = 0
    local pc = Instance.new("UICorner", progBack); pc.CornerRadius = UDim.new(1,0)

    local progFill = Instance.new("Frame", progBack)
    progFill.Name             = "ProgressFill"
    progFill.Size             = UDim2.new(1, 0, 1, 0)
    progFill.BackgroundColor3 = accentColor
    progFill.BorderSizePixel  = 0
    local pfc = Instance.new("UICorner", progFill); pfc.CornerRadius = UDim.new(1,0)

    local shadow = Instance.new("ImageLabel", card)
    shadow.Name               = "Shadow"
    shadow.BackgroundTransparency = 1
    shadow.Image              = "rbxassetid://6014261993"
    shadow.ImageColor3        = theme.Shadow
    shadow.ImageTransparency  = 0.5
    shadow.ScaleType          = Enum.ScaleType.Slice
    shadow.SliceCenter        = Rect.new(49, 49, 450, 450)
    shadow.Size               = UDim2.new(1, 24, 1, 24)
    shadow.Position           = UDim2.new(0, -12, 0, 4)
    shadow.ZIndex             = card.ZIndex - 1

    card.Position = UDim2.new(1, 16, 0, 0)
    Utility.SpringTween(card, {Position = UDim2.new(0, 0, 0, 0)}, 0.4)

    Utility.Tween(progFill, {Size = UDim2.new(0, 0, 1, 0)}, duration, Enum.EasingStyle.Linear, Enum.EasingDirection.In)

    local mouseIn = false
    card.InputBegan:Connect(function(i)
        if i.UserInputType == Enum.UserInputType.MouseButton1 then
            Utility.SmoothTween(card, {BackgroundTransparency = 1, Position = UDim2.new(1, 16, 0, 0)}, 0.25)
            task.delay(0.3, function() card:Destroy() end)
        end
    end)
    card.MouseEnter:Connect(function() mouseIn = true end)
    card.MouseLeave:Connect(function() mouseIn = false end)

    task.delay(duration, function()
        if card and card.Parent then
            Utility.SmoothTween(card, {BackgroundTransparency = 1, Position = UDim2.new(1, 16, 0, 0)}, 0.3)
            task.delay(0.35, function() if card then card:Destroy() end end)
        end
    end)

    return card
end

function Lithium:CreateWindow(options)
    options = options or {}
    local theme = self:Theme()
    local windowTitle    = options.Title    or "Lithium"
    local windowSubtitle = options.Subtitle or ""
    local windowSize     = options.Size     or UDim2.new(0, 560, 0, 440)
    local toggleKey      = options.ToggleKey or Enum.KeyCode.RightShift
    local configName     = options.ConfigName
    local onClose        = options.OnClose
    local defaultTheme   = options.Theme    or "Dark"

    self.CurrentTheme = defaultTheme

    local ScreenGui = Instance.new("ScreenGui")
    ScreenGui.Name                = "LithiumUI_"..windowTitle
    ScreenGui.ResetOnSpawn        = false
    ScreenGui.ZIndexBehavior      = Enum.ZIndexBehavior.Sibling
    ScreenGui.DisplayOrder        = 100
    pcall(function() ScreenGui.Parent = CoreGui end)
    if not ScreenGui.Parent then
        ScreenGui.Parent = Players.LocalPlayer:WaitForChild("PlayerGui")
    end

    local MainFrame = Instance.new("Frame")
    MainFrame.Name              = "MainFrame"
    MainFrame.Size              = windowSize
    MainFrame.Position          = UDim2.new(0.5, -windowSize.X.Offset/2, 0.5, -windowSize.Y.Offset/2)
    MainFrame.BackgroundColor3  = theme.Background
    MainFrame.BorderSizePixel   = 0
    MainFrame.ClipsDescendants  = false
    MainFrame.Parent            = ScreenGui
    local mainCorner = Instance.new("UICorner", MainFrame)
    mainCorner.CornerRadius = UDim.new(0, 12)
    Utility.CreateStroke(MainFrame, theme.Border, 1, 0)

    local shadowImg = Instance.new("ImageLabel", MainFrame)
    shadowImg.Name               = "DropShadow"
    shadowImg.BackgroundTransparency = 1
    shadowImg.Image              = "rbxassetid://6014261993"
    shadowImg.ImageColor3        = Color3.new(0,0,0)
    shadowImg.ImageTransparency  = 0.4
    shadowImg.ScaleType          = Enum.ScaleType.Slice
    shadowImg.SliceCenter        = Rect.new(49, 49, 450, 450)
    shadowImg.Size               = UDim2.new(1, 60, 1, 60)
    shadowImg.Position           = UDim2.new(0, -30, 0, 10)
    shadowImg.ZIndex             = MainFrame.ZIndex - 1

    local TitleBar = Instance.new("Frame", MainFrame)
    TitleBar.Name             = "TitleBar"
    TitleBar.Size             = UDim2.new(1, 0, 0, 48)
    TitleBar.BackgroundColor3 = theme.Surface
    TitleBar.BorderSizePixel  = 0
    local tbc = Instance.new("UICorner", TitleBar)
    tbc.CornerRadius = UDim.new(0, 12)

    local tbClipFix = Instance.new("Frame", TitleBar)
    tbClipFix.Name              = "BottomFix"
    tbClipFix.Size              = UDim2.new(1, 0, 0.5, 0)
    tbClipFix.Position          = UDim2.new(0, 0, 0.5, 0)
    tbClipFix.BackgroundColor3  = theme.Surface
    tbClipFix.BorderSizePixel   = 0
    tbClipFix.ZIndex            = TitleBar.ZIndex + 1

    local tbDivider = Instance.new("Frame", MainFrame)
    tbDivider.Name              = "TitleDivider"
    tbDivider.Size              = UDim2.new(1, 0, 0, 1)
    tbDivider.Position          = UDim2.new(0, 0, 0, 48)
    tbDivider.BackgroundColor3  = theme.Border
    tbDivider.BorderSizePixel   = 0

    local accentLine = Instance.new("Frame", TitleBar)
    accentLine.Name             = "AccentLine"
    accentLine.Size             = UDim2.new(0, 32, 0, 2)
    accentLine.Position         = UDim2.new(0, 14, 1, -1)
    accentLine.BackgroundColor3 = theme.Accent
    accentLine.BorderSizePixel  = 0
    accentLine.ZIndex           = TitleBar.ZIndex + 2
    local alc = Instance.new("UICorner", accentLine); alc.CornerRadius = UDim.new(1,0)

    local logoFrame = Instance.new("Frame", TitleBar)
    logoFrame.Name              = "LogoFrame"
    logoFrame.Size              = UDim2.new(0, 28, 0, 28)
    logoFrame.Position          = UDim2.new(0, 12, 0.5, -14)
    logoFrame.BackgroundColor3  = theme.Accent
    logoFrame.BorderSizePixel   = 0
    logoFrame.ZIndex            = TitleBar.ZIndex + 2
    local lfc = Instance.new("UICorner", logoFrame); lfc.CornerRadius = UDim.new(0, 6)
    local logoLetter = Utility.Label(logoFrame, "L",
        UDim2.new(1, 0, 1, 0), UDim2.new(0,0,0,0),
        Color3.new(1,1,1), 16, Enum.Font.GothamBlack, "Logo", Enum.TextXAlignment.Center)
    logoLetter.ZIndex = logoFrame.ZIndex + 1

    local titleLabel = Utility.Label(TitleBar, windowTitle,
        UDim2.new(0.5, 0, 0, 20),
        UDim2.new(0, 50, 0, 6),
        theme.Text, 15, Enum.Font.GothamBold, "Title")
    titleLabel.ZIndex = TitleBar.ZIndex + 2

    local subtitleLabel = Utility.Label(TitleBar, windowSubtitle,
        UDim2.new(0.5, 0, 0, 14),
        UDim2.new(0, 50, 0, 26),
        theme.TextMuted, 11, Enum.Font.Gotham, "Subtitle")
    subtitleLabel.ZIndex = TitleBar.ZIndex + 2

    local controlsFrame = Instance.new("Frame", TitleBar)
    controlsFrame.Name              = "Controls"
    controlsFrame.Size              = UDim2.new(0, 80, 0, 24)
    controlsFrame.Position          = UDim2.new(1, -88, 0.5, -12)
    controlsFrame.BackgroundTransparency = 1
    controlsFrame.ZIndex            = TitleBar.ZIndex + 3
    local ctrlLayout = Instance.new("UIListLayout", controlsFrame)
    ctrlLayout.FillDirection  = Enum.FillDirection.Horizontal
    ctrlLayout.HorizontalAlignment = Enum.HorizontalAlignment.Right
    ctrlLayout.VerticalAlignment = Enum.VerticalAlignment.Center
    ctrlLayout.Padding = UDim.new(0, 6)

    local function makeCtrlBtn(name, color, symbol)
        local btn = Instance.new("TextButton", controlsFrame)
        btn.Name              = name
        btn.Size              = UDim2.new(0, 24, 0, 24)
        btn.BackgroundColor3  = color
        btn.BorderSizePixel   = 0
        btn.Text              = symbol
        btn.TextColor3        = Color3.new(1,1,1)
        btn.TextSize          = 11
        btn.Font              = Enum.Font.GothamBold
        btn.AutoButtonColor   = false
        local c = Instance.new("UICorner", btn); c.CornerRadius = UDim.new(1,0)
        btn.MouseEnter:Connect(function()
            Utility.SmoothTween(btn, {BackgroundTransparency = 0.3}, 0.15)
        end)
        btn.MouseLeave:Connect(function()
            Utility.SmoothTween(btn, {BackgroundTransparency = 0}, 0.15)
        end)
        return btn
    end

    local minimizeBtn = makeCtrlBtn("Minimize", Color3.fromRGB(255, 189, 46), "−")
    local closeBtn    = makeCtrlBtn("Close",    Color3.fromRGB(252, 100, 100), "×")

    local ContentFrame = Instance.new("Frame", MainFrame)
    ContentFrame.Name             = "ContentFrame"
    ContentFrame.Size             = UDim2.new(1, 0, 1, -96)
    ContentFrame.Position         = UDim2.new(0, 0, 0, 49)
    ContentFrame.BackgroundTransparency = 1
    ContentFrame.BorderSizePixel  = 0
    ContentFrame.ClipsDescendants = true

    local TabBar = Instance.new("Frame", MainFrame)
    TabBar.Name             = "TabBar"
    TabBar.Size             = UDim2.new(1, 0, 0, 48)
    TabBar.Position         = UDim2.new(0, 0, 1, -48)
    TabBar.BackgroundColor3 = theme.TabBar
    TabBar.BorderSizePixel  = 0
    local tbarc = Instance.new("UICorner", TabBar)
    tbarc.CornerRadius = UDim.new(0, 12)

    local tbarTopFix = Instance.new("Frame", TabBar)
    tbarTopFix.Size             = UDim2.new(1, 0, 0.5, 0)
    tbarTopFix.BackgroundColor3 = theme.TabBar
    tbarTopFix.BorderSizePixel  = 0

    local tbarDivider = Instance.new("Frame", MainFrame)
    tbarDivider.Name             = "TabDivider"
    tbarDivider.Size             = UDim2.new(1, 0, 0, 1)
    tbarDivider.Position         = UDim2.new(0, 0, 1, -49)
    tbarDivider.BackgroundColor3 = theme.Border
    tbarDivider.BorderSizePixel  = 0

    local tabListLayout = Instance.new("UIListLayout", TabBar)
    tabListLayout.FillDirection       = Enum.FillDirection.Horizontal
    tabListLayout.HorizontalAlignment = Enum.HorizontalAlignment.Center
    tabListLayout.VerticalAlignment   = Enum.VerticalAlignment.Center
    tabListLayout.Padding             = UDim.new(0, 4)

    local tabIndicator = Instance.new("Frame", TabBar)
    tabIndicator.Name             = "TabIndicator"
    tabIndicator.BackgroundColor3 = theme.Accent
    tabIndicator.BorderSizePixel  = 0
    tabIndicator.Size             = UDim2.new(0, 0, 0, 2)
    tabIndicator.Position         = UDim2.new(0, 0, 1, -2)
    tabIndicator.ZIndex           = TabBar.ZIndex + 5
    local tic = Instance.new("UICorner", tabIndicator); tic.CornerRadius = UDim.new(1, 0)

    local dragging, dragStart, startPos = false, nil, nil
    TitleBar.InputBegan:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.MouseButton1 then
            dragging  = true
            dragStart = input.Position
            startPos  = MainFrame.Position
        end
    end)
    UserInputService.InputChanged:Connect(function(input)
        if dragging and input.UserInputType == Enum.UserInputType.MouseMovement then
            local delta = input.Position - dragStart
            MainFrame.Position = UDim2.new(
                startPos.X.Scale,
                startPos.X.Offset + delta.X,
                startPos.Y.Scale,
                startPos.Y.Offset + delta.Y
            )
        end
    end)
    UserInputService.InputEnded:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.MouseButton1 then
            dragging = false
        end
    end)

    local minimized = false
    local originalSize = windowSize

    minimizeBtn.MouseButton1Click:Connect(function()
        minimized = not minimized
        if minimized then
            Utility.SmoothTween(MainFrame, {Size = UDim2.new(0, windowSize.X.Offset, 0, 48)}, 0.3)
            ContentFrame.Visible = false
            TabBar.Visible       = false
        else
            ContentFrame.Visible = true
            TabBar.Visible       = true
            Utility.SmoothTween(MainFrame, {Size = windowSize}, 0.35)
        end
    end)

    closeBtn.MouseButton1Click:Connect(function()
        Utility.SmoothTween(MainFrame, {Size = UDim2.new(0, windowSize.X.Offset, 0, 0), BackgroundTransparency = 1}, 0.25)
        task.delay(0.3, function()
            ScreenGui:Destroy()
            if onClose then onClose() end
        end)
    end)

    local toggled = true
    UserInputService.InputBegan:Connect(function(input, processed)
        if not processed and input.KeyCode == toggleKey then
            toggled = not toggled
            MainFrame.Visible = toggled
        end
    end)

    local Window = {
        _gui         = ScreenGui,
        _main        = MainFrame,
        _content     = ContentFrame,
        _tabBar      = TabBar,
        _tabIndicator= tabIndicator,
        _tabs        = {},
        _activeTab   = nil,
        _theme       = theme,
        _configName  = configName,
    }

    function Window:AddTab(tabOptions)
        tabOptions = tabOptions or {}
        local tabName = tabOptions.Name or ("Tab "..tostring(#self._tabs + 1))
        local tabIcon = tabOptions.Icon

        local tabBtn = Instance.new("TextButton", self._tabBar)
        tabBtn.Name             = "TabBtn_"..tabName
        tabBtn.Size             = UDim2.new(0, 90, 0, 40)
        tabBtn.BackgroundTransparency = 1
        tabBtn.Text             = ""
        tabBtn.AutoButtonColor  = false
        tabBtn.BorderSizePixel  = 0
        tabBtn.ZIndex           = self._tabBar.ZIndex + 2

        local btnLayout = Instance.new("UIListLayout", tabBtn)
        btnLayout.FillDirection       = Enum.FillDirection.Vertical
        btnLayout.HorizontalAlignment = Enum.HorizontalAlignment.Center
        btnLayout.VerticalAlignment   = Enum.VerticalAlignment.Center
        btnLayout.Padding             = UDim.new(0, 2)

        if tabIcon then
            local iconImg = Instance.new("ImageLabel", tabBtn)
            iconImg.Size                 = UDim2.new(0, 18, 0, 18)
            iconImg.BackgroundTransparency = 1
            iconImg.Image                = tabIcon
            iconImg.ImageColor3          = theme.TabInactive
            iconImg.ZIndex               = tabBtn.ZIndex + 1
        end

        local tabLabel = Utility.Label(tabBtn, tabName,
            UDim2.new(1, 0, 0, 14),
            UDim2.new(0,0,0,0),
            theme.TabInactive, 11, Enum.Font.GothamMedium, "TabLabel",
            Enum.TextXAlignment.Center)
        tabLabel.ZIndex = tabBtn.ZIndex + 1

        local tabContent = Instance.new("Frame", self._content)
        tabContent.Name             = "Tab_"..tabName
        tabContent.Size             = UDim2.new(1, 0, 1, 0)
        tabContent.BackgroundTransparency = 1
        tabContent.BorderSizePixel  = 0
        tabContent.Visible          = false

        local leftScroll = Instance.new("ScrollingFrame", tabContent)
        leftScroll.Name                  = "LeftScroll"
        leftScroll.Size                  = UDim2.new(0.5, -6, 1, 0)
        leftScroll.Position              = UDim2.new(0, 8, 0, 0)
        leftScroll.BackgroundTransparency = 1
        leftScroll.BorderSizePixel       = 0
        leftScroll.ScrollBarThickness    = 3
        leftScroll.ScrollBarImageColor3  = theme.Scrollbar
        leftScroll.CanvasSize            = UDim2.new(0, 0, 0, 0)
        leftScroll.AutomaticCanvasSize   = Enum.AutomaticSize.Y
        leftScroll.ScrollingDirection    = Enum.ScrollingDirection.Y
        local leftLayout = Instance.new("UIListLayout", leftScroll)
        leftLayout.SortOrder = Enum.SortOrder.LayoutOrder
        leftLayout.Padding   = UDim.new(0, 6)
        local leftPad = Instance.new("UIPadding", leftScroll)
        leftPad.PaddingTop    = UDim.new(0, 8)
        leftPad.PaddingBottom = UDim.new(0, 8)
        leftPad.PaddingRight  = UDim.new(0, 4)

        local rightScroll = Instance.new("ScrollingFrame", tabContent)
        rightScroll.Name                  = "RightScroll"
        rightScroll.Size                  = UDim2.new(0.5, -6, 1, 0)
        rightScroll.Position              = UDim2.new(0.5, 2, 0, 0)
        rightScroll.BackgroundTransparency = 1
        rightScroll.BorderSizePixel       = 0
        rightScroll.ScrollBarThickness    = 3
        rightScroll.ScrollBarImageColor3  = theme.Scrollbar
        rightScroll.CanvasSize            = UDim2.new(0, 0, 0, 0)
        rightScroll.AutomaticCanvasSize   = Enum.AutomaticSize.Y
        rightScroll.ScrollingDirection    = Enum.ScrollingDirection.Y
        local rightLayout = Instance.new("UIListLayout", rightScroll)
        rightLayout.SortOrder = Enum.SortOrder.LayoutOrder
        rightLayout.Padding   = UDim.new(0, 6)
        local rightPad = Instance.new("UIPadding", rightScroll)
        rightPad.PaddingTop    = UDim.new(0, 8)
        rightPad.PaddingBottom = UDim.new(0, 8)
        rightPad.PaddingLeft   = UDim.new(0, 4)

        local Tab = {
            _btn       = tabBtn,
            _label     = tabLabel,
            _content   = tabContent,
            _left      = leftScroll,
            _right     = rightScroll,
            _useRight  = false,
            _window    = self,
            _theme     = theme,
            _sections  = {},
        }

        local function selectTab()
            if self._activeTab == Tab then return end
            if self._activeTab then

                Utility.SmoothTween(self._activeTab._label, {TextColor3 = theme.TabInactive}, 0.2)
                self._activeTab._content.Visible = false

                for _, c in ipairs(self._activeTab._btn:GetChildren()) do
                    if c:IsA("ImageLabel") then
                        Utility.SmoothTween(c, {ImageColor3 = theme.TabInactive}, 0.2)
                    end
                end
            end
            self._activeTab = Tab
            tabContent.Visible = true

            Utility.SmoothTween(tabLabel, {TextColor3 = theme.TabActive}, 0.2)
            for _, c in ipairs(tabBtn:GetChildren()) do
                if c:IsA("ImageLabel") then
                    Utility.SmoothTween(c, {ImageColor3 = theme.TabActive}, 0.2)
                end
            end

            local btnAbsPos = tabBtn.AbsolutePosition
            local barAbsPos = self._tabBar.AbsolutePosition
            local relX = btnAbsPos.X - barAbsPos.X
            Utility.SmoothTween(self._tabIndicator, {
                Size     = UDim2.new(0, tabBtn.AbsoluteSize.X - 20, 0, 2),
                Position = UDim2.new(0, relX + 10, 1, -2),
            }, 0.25)
        end

        tabBtn.MouseButton1Click:Connect(function()
            selectTab()
            Utility.Ripple(tabBtn, UserInputService:GetMouseLocation().X, UserInputService:GetMouseLocation().Y, theme)
        end)

        table.insert(self._tabs, Tab)

        if #self._tabs == 1 then
            task.defer(selectTab)
        end

        function Tab:AddSection(sectionOptions)
            sectionOptions = sectionOptions or {}
            local sectionName = sectionOptions.Name or "Section"
            local side        = sectionOptions.Side or (self._useRight and "Right" or "Left")
            self._useRight = not self._useRight

            local parentScroll = (side == "Right") and self._right or self._left

            local sectionFrame = Instance.new("Frame", parentScroll)
            sectionFrame.Name             = "Section_"..sectionName
            sectionFrame.Size             = UDim2.new(1, 0, 0, 32)
            sectionFrame.BackgroundColor3 = theme.SurfaceVariant
            sectionFrame.BorderSizePixel  = 0
            sectionFrame.AutomaticSize    = Enum.AutomaticSize.Y
            sectionFrame.LayoutOrder      = #self._sections + 1
            local sc = Instance.new("UICorner", sectionFrame); sc.CornerRadius = UDim.new(0, 10)
            Utility.CreateStroke(sectionFrame, theme.Border, 1, 0.2)

            local headerFrame = Instance.new("Frame", sectionFrame)
            headerFrame.Name             = "Header"
            headerFrame.Size             = UDim2.new(1, 0, 0, 32)
            headerFrame.BackgroundTransparency = 1
            headerFrame.BorderSizePixel  = 0

            local sectionAccent = Instance.new("Frame", headerFrame)
            sectionAccent.Size            = UDim2.new(0, 2, 0, 14)
            sectionAccent.Position        = UDim2.new(0, 10, 0.5, -7)
            sectionAccent.BackgroundColor3 = theme.Accent
            sectionAccent.BorderSizePixel  = 0
            local sac = Instance.new("UICorner", sectionAccent); sac.CornerRadius = UDim.new(1,0)

            Utility.Label(headerFrame, sectionName,
                UDim2.new(1, -32, 0, 32),
                UDim2.new(0, 20, 0, 0),
                theme.TextSecondary, 11, Enum.Font.GothamBold, "SectionLabel")

            local itemsContainer = Instance.new("Frame", sectionFrame)
            itemsContainer.Name             = "Items"
            itemsContainer.Size             = UDim2.new(1, 0, 0, 0)
            itemsContainer.BackgroundTransparency = 1
            itemsContainer.BorderSizePixel  = 0
            itemsContainer.AutomaticSize    = Enum.AutomaticSize.Y
            itemsContainer.Position         = UDim2.new(0, 0, 0, 32)
            local itemLayout = Instance.new("UIListLayout", itemsContainer)
            itemLayout.SortOrder = Enum.SortOrder.LayoutOrder
            local itemPad = Instance.new("UIPadding", itemsContainer)
            itemPad.PaddingLeft   = UDim.new(0, 8)
            itemPad.PaddingRight  = UDim.new(0, 8)
            itemPad.PaddingBottom = UDim.new(0, 8)

            local Section = {
                _frame    = sectionFrame,
                _items    = itemsContainer,
                _theme    = theme,
                _tab      = self,
                _elements = {},
            }

            local function makeItemRow(name, height)
                local row = Instance.new("Frame", itemsContainer)
                row.Name             = "Row_"..name
                row.Size             = UDim2.new(1, 0, 0, height or 38)
                row.BackgroundTransparency = 1
                row.BorderSizePixel  = 0
                row.LayoutOrder      = #Section._elements + 1
                return row
            end

            function Section:AddLabel(labelOptions)
                labelOptions = labelOptions or {}
                local text     = labelOptions.Text or "Label"
                local color    = labelOptions.Color or theme.TextSecondary
                local fontSize = labelOptions.Size  or 13

                local row = makeItemRow(text, 30)
                Utility.Label(row, text,
                    UDim2.new(1, -10, 1, 0),
                    UDim2.new(0, 8, 0, 0),
                    color, fontSize, Enum.Font.Gotham, "LabelText")
                table.insert(self._elements, row)
                return row
            end

            function Section:AddSeparator(sepOptions)
                sepOptions = sepOptions or {}
                local label = sepOptions.Label or ""

                local row = makeItemRow("Separator", 24)
                row.Size = UDim2.new(1, 0, 0, 24)

                local line = Instance.new("Frame", row)
                line.Size             = UDim2.new(1, -16, 0, 1)
                line.Position         = UDim2.new(0, 8, 0.5, 0)
                line.BackgroundColor3 = theme.Border
                line.BorderSizePixel  = 0

                if label ~= "" then
                    local sepLabel = Utility.Label(row, " "..label.." ",
                        UDim2.new(0, 0, 1, 0),
                        UDim2.new(0.5, -40, 0, 0),
                        theme.TextMuted, 10, Enum.Font.GothamMedium, "SepLabel",
                        Enum.TextXAlignment.Center)
                    sepLabel.AutomaticSize = Enum.AutomaticSize.X
                    sepLabel.BackgroundColor3 = theme.SurfaceVariant
                    sepLabel.BackgroundTransparency = 0
                end

                table.insert(self._elements, row)
                return row
            end

            function Section:AddButton(btnOptions)
                btnOptions = btnOptions or {}
                local text     = btnOptions.Name     or "Button"
                local callback = btnOptions.Callback or function() end
                local style    = btnOptions.Style    or "Filled"
                local desc     = btnOptions.Description

                local row = makeItemRow(text, desc and 52 or 38)

                local btnBgColor = ({
                    Filled   = theme.Accent,
                    Outlined = theme.SurfaceVariant,
                    Danger   = theme.Error,
                })[style] or theme.Accent

                local btn = Utility.Button(row,
                    UDim2.new(1, 0, 0, 30),
                    UDim2.new(0, 0, 0, 4),
                    btnBgColor, "Btn_"..text)
                btn.ZIndex = row.ZIndex + 1
                Utility.CreateStroke(btn, style == "Outlined" and theme.Accent or Color3.new(0,0,0), 1,
                    style == "Outlined" and 0 or 1)

                local btnLabel = Utility.Label(btn, text,
                    UDim2.new(1, -10, 1, 0),
                    UDim2.new(0, 8, 0, 0),
                    style == "Filled" and Color3.new(1,1,1) or theme.Text,
                    13, Enum.Font.GothamMedium, "BtnLabel",
                    Enum.TextXAlignment.Center)
                btnLabel.ZIndex = btn.ZIndex + 1

                if desc then
                    Utility.Label(row, desc,
                        UDim2.new(1, 0, 0, 14),
                        UDim2.new(0, 4, 0, 36),
                        theme.TextMuted, 10, Enum.Font.Gotham, "Desc")
                end

                btn.MouseEnter:Connect(function()
                    Utility.SmoothTween(btn, {BackgroundColor3 = Utility.LerpColor(btnBgColor, Color3.new(1,1,1), 0.1)}, 0.15)
                end)
                btn.MouseLeave:Connect(function()
                    Utility.SmoothTween(btn, {BackgroundColor3 = btnBgColor}, 0.15)
                end)
                btn.MouseButton1Down:Connect(function()
                    Utility.SmoothTween(btn, {Size = UDim2.new(1, -4, 0, 28), Position = UDim2.new(0, 2, 0, 5)}, 0.1)
                end)
                btn.MouseButton1Up:Connect(function()
                    Utility.SmoothTween(btn, {Size = UDim2.new(1, 0, 0, 30), Position = UDim2.new(0, 0, 0, 4)}, 0.15)
                end)
                btn.MouseButton1Click:Connect(function()
                    local mp = UserInputService:GetMouseLocation()
                    Utility.Ripple(btn, mp.X, mp.Y, theme)
                    callback()
                end)

                table.insert(self._elements, row)
                return row
            end

            function Section:AddToggle(toggleOptions)
                toggleOptions = toggleOptions or {}
                local name     = toggleOptions.Name    or "Toggle"
                local default  = toggleOptions.Default or false
                local callback = toggleOptions.Callback or function() end
                local flag     = toggleOptions.Flag
                local desc     = toggleOptions.Description

                local row = makeItemRow(name, desc and 52 or 38)

                Utility.Label(row, name,
                    UDim2.new(1, -58, 0, 30),
                    UDim2.new(0, 8, 0, 4),
                    theme.Text, 13, Enum.Font.GothamMedium, "ToggleName")

                if desc then
                    Utility.Label(row, desc,
                        UDim2.new(1, -58, 0, 14),
                        UDim2.new(0, 8, 0, 34),
                        theme.TextMuted, 10, Enum.Font.Gotham, "ToggleDesc")
                end

                local trackBtn = Instance.new("TextButton", row)
                trackBtn.Name             = "ToggleTrack"
                trackBtn.Size             = UDim2.new(0, 42, 0, 22)
                trackBtn.Position         = UDim2.new(1, -46, 0, 8)
                trackBtn.BackgroundColor3 = default and theme.ToggleOn or theme.ToggleOff
                trackBtn.BorderSizePixel  = 0
                trackBtn.Text             = ""
                trackBtn.AutoButtonColor  = false
                trackBtn.ZIndex           = row.ZIndex + 1
                local tc = Instance.new("UICorner", trackBtn); tc.CornerRadius = UDim.new(1,0)

                local thumb = Instance.new("Frame", trackBtn)
                thumb.Name             = "Thumb"
                thumb.Size             = UDim2.new(0, 16, 0, 16)
                thumb.Position         = default and UDim2.new(1, -19, 0.5, -8) or UDim2.new(0, 3, 0.5, -8)
                thumb.BackgroundColor3 = Color3.new(1,1,1)
                thumb.BorderSizePixel  = 0
                thumb.ZIndex           = trackBtn.ZIndex + 1
                local thc = Instance.new("UICorner", thumb); thc.CornerRadius = UDim.new(1,0)

                local ts = Instance.new("UIStroke", thumb)
                ts.Color       = Color3.new(0,0,0)
                ts.Thickness   = 1
                ts.Transparency = 0.8

                local enabled = default
                if flag then Lithium.Flags[flag] = enabled end

                local function setToggle(state, animate)
                    enabled = state
                    if flag then Lithium.Flags[flag] = state end
                    local dur = animate and 0.25 or 0
                    Utility.SmoothTween(trackBtn, {BackgroundColor3 = state and theme.ToggleOn or theme.ToggleOff}, dur)
                    Utility.SpringTween(thumb, {
                        Position = state and UDim2.new(1, -19, 0.5, -8) or UDim2.new(0, 3, 0.5, -8)
                    }, dur)
                    callback(state)
                end

                trackBtn.MouseButton1Click:Connect(function()
                    setToggle(not enabled, true)
                end)

                local ToggleObj = { _row = row, _state = function() return enabled end }
                function ToggleObj:Set(v) setToggle(v, true) end
                table.insert(self._elements, row)
                return ToggleObj
            end

            function Section:AddSlider(sliderOptions)
                sliderOptions = sliderOptions or {}
                local name     = sliderOptions.Name    or "Slider"
                local min      = sliderOptions.Min     or 0
                local max      = sliderOptions.Max     or 100
                local default  = sliderOptions.Default or min
                local callback = sliderOptions.Callback or function() end
                local suffix   = sliderOptions.Suffix  or ""
                local decimals = sliderOptions.Decimals or 0
                local flag     = sliderOptions.Flag

                local row = makeItemRow(name, 52)

                local nameLabel = Utility.Label(row, name,
                    UDim2.new(0.65, 0, 0, 18),
                    UDim2.new(0, 8, 0, 2),
                    theme.Text, 13, Enum.Font.GothamMedium, "SliderName")

                local valLabel = Utility.Label(row, tostring(default)..suffix,
                    UDim2.new(0.35, -8, 0, 18),
                    UDim2.new(0.65, 0, 0, 2),
                    theme.Accent, 13, Enum.Font.GothamBold, "SliderVal",
                    Enum.TextXAlignment.Right)

                local trackBack = Instance.new("Frame", row)
                trackBack.Name             = "TrackBack"
                trackBack.Size             = UDim2.new(1, -16, 0, 6)
                trackBack.Position         = UDim2.new(0, 8, 0, 32)
                trackBack.BackgroundColor3 = theme.SliderBack
                trackBack.BorderSizePixel  = 0
                local tbc2 = Instance.new("UICorner", trackBack); tbc2.CornerRadius = UDim.new(1,0)

                local initFill = math.clamp((default - min)/(max - min), 0, 1)
                local trackFill = Instance.new("Frame", trackBack)
                trackFill.Name             = "TrackFill"
                trackFill.Size             = UDim2.new(initFill, 0, 1, 0)
                trackFill.BackgroundColor3 = theme.SliderFill
                trackFill.BorderSizePixel  = 0
                local tfc = Instance.new("UICorner", trackFill); tfc.CornerRadius = UDim.new(1,0)

                local knob = Instance.new("Frame", trackBack)
                knob.Name             = "Knob"
                knob.Size             = UDim2.new(0, 14, 0, 14)
                knob.Position         = UDim2.new(initFill, -7, 0.5, -7)
                knob.BackgroundColor3 = Color3.new(1,1,1)
                knob.BorderSizePixel  = 0
                knob.ZIndex           = trackBack.ZIndex + 2
                local kc = Instance.new("UICorner", knob); kc.CornerRadius = UDim.new(1,0)
                Utility.CreateStroke(knob, theme.Accent, 2, 0)

                local currentVal = default
                if flag then Lithium.Flags[flag] = currentVal end

                local function setValue(v, animate)
                    local clamped = math.clamp(v, min, max)
                    local rounded = tonumber(string.format("%."..(decimals).."f", clamped))
                    currentVal = rounded
                    if flag then Lithium.Flags[flag] = rounded end
                    local t = (rounded - min)/(max - min)
                    local dur = animate and 0.1 or 0
                    Utility.SmoothTween(trackFill, {Size = UDim2.new(t, 0, 1, 0)}, dur)
                    Utility.SmoothTween(knob,      {Position = UDim2.new(t, -7, 0.5, -7)}, dur)
                    valLabel.Text = tostring(rounded)..suffix
                    callback(rounded)
                end

                local sliding = false
                local inputBtn = Instance.new("TextButton", trackBack)
                inputBtn.Size               = UDim2.new(1, 0, 0, 20)
                inputBtn.Position           = UDim2.new(0, 0, 0.5, -10)
                inputBtn.BackgroundTransparency = 1
                inputBtn.Text               = ""
                inputBtn.ZIndex             = trackBack.ZIndex + 5

                inputBtn.MouseButton1Down:Connect(function()
                    sliding = true
                    Utility.SpringTween(knob, {Size = UDim2.new(0, 18, 0, 18), Position = UDim2.new(
                        (currentVal-min)/(max-min), -9, 0.5, -9)}, 0.2)
                end)
                UserInputService.InputEnded:Connect(function(i)
                    if i.UserInputType == Enum.UserInputType.MouseButton1 and sliding then
                        sliding = false
                        Utility.SpringTween(knob, {Size = UDim2.new(0, 14, 0, 14), Position = UDim2.new(
                            (currentVal-min)/(max-min), -7, 0.5, -7)}, 0.2)
                    end
                end)
                UserInputService.InputChanged:Connect(function(i)
                    if sliding and i.UserInputType == Enum.UserInputType.MouseMovement then
                        local absPos  = trackBack.AbsolutePosition
                        local absSize = trackBack.AbsoluteSize
                        local relX = math.clamp((i.Position.X - absPos.X) / absSize.X, 0, 1)
                        setValue(min + (max - min) * relX)
                    end
                end)

                local SliderObj = {
                    _row  = row,
                    _val  = function() return currentVal end,
                }
                function SliderObj:Set(v) setValue(v, true) end
                table.insert(self._elements, row)
                return SliderObj
            end

            function Section:AddDropdown(ddOptions)
                ddOptions = ddOptions or {}
                local name     = ddOptions.Name     or "Dropdown"
                local items    = ddOptions.Items    or {}
                local default  = ddOptions.Default  or items[1]
                local callback = ddOptions.Callback or function() end
                local multi    = ddOptions.Multi    or false
                local flag     = ddOptions.Flag

                local row = makeItemRow(name, 38)
                row.Size    = UDim2.new(1, 0, 0, 38)
                row.ZIndex  = row.ZIndex + 10

                Utility.Label(row, name,
                    UDim2.new(0.45, 0, 0, 30),
                    UDim2.new(0, 8, 0, 4),
                    theme.Text, 13, Enum.Font.GothamMedium, "DDName")

                local selectedDisplay = Instance.new("TextButton", row)
                selectedDisplay.Name             = "DDDisplay"
                selectedDisplay.Size             = UDim2.new(0.52, 0, 0, 26)
                selectedDisplay.Position         = UDim2.new(0.48, 0, 0, 6)
                selectedDisplay.BackgroundColor3 = theme.Surface
                selectedDisplay.BorderSizePixel  = 0
                selectedDisplay.AutoButtonColor  = false
                selectedDisplay.TextColor3       = theme.Text
                selectedDisplay.Text             = tostring(default or "Select...")
                selectedDisplay.TextSize         = 12
                selectedDisplay.Font             = Enum.Font.GothamMedium
                selectedDisplay.ZIndex           = row.ZIndex + 1
                local ddc = Instance.new("UICorner", selectedDisplay); ddc.CornerRadius = UDim.new(0, 6)
                Utility.CreateStroke(selectedDisplay, theme.Border, 1, 0)

                local arrow = Utility.Label(selectedDisplay, "▾",
                    UDim2.new(0, 16, 1, 0),
                    UDim2.new(1, -18, 0, 0),
                    theme.TextMuted, 12, Enum.Font.Gotham, "Arrow",
                    Enum.TextXAlignment.Center)
                arrow.ZIndex = selectedDisplay.ZIndex + 1

                local dropFrame = Instance.new("Frame", row)
                dropFrame.Name             = "DropList"
                dropFrame.Size             = UDim2.new(0.52, 0, 0, 0)
                dropFrame.Position         = UDim2.new(0.48, 0, 0, 34)
                dropFrame.BackgroundColor3 = theme.Surface
                dropFrame.BorderSizePixel  = 0
                dropFrame.ClipsDescendants = true
                dropFrame.ZIndex           = row.ZIndex + 20
                dropFrame.Visible          = false
                local dfc = Instance.new("UICorner", dropFrame); dfc.CornerRadius = UDim.new(0, 6)
                Utility.CreateStroke(dropFrame, theme.Border, 1, 0)

                local dropScroll = Instance.new("ScrollingFrame", dropFrame)
                dropScroll.Size                 = UDim2.new(1, 0, 1, 0)
                dropScroll.BackgroundTransparency = 1
                dropScroll.BorderSizePixel      = 0
                dropScroll.ScrollBarThickness   = 2
                dropScroll.ScrollBarImageColor3 = theme.Scrollbar
                dropScroll.CanvasSize           = UDim2.new(0, 0, 0, 0)
                dropScroll.AutomaticCanvasSize  = Enum.AutomaticSize.Y
                dropScroll.ZIndex              = dropFrame.ZIndex + 1
                local dsl = Instance.new("UIListLayout", dropScroll)
                dsl.SortOrder = Enum.SortOrder.LayoutOrder
                local dsp = Instance.new("UIPadding", dropScroll)
                dsp.PaddingTop = UDim.new(0, 4); dsp.PaddingBottom = UDim.new(0, 4)

                local selectedValues = {}
                if default then selectedValues[default] = true end

                local function rebuildItems()
                    for _, c in ipairs(dropScroll:GetChildren()) do
                        if c:IsA("TextButton") then c:Destroy() end
                    end
                    for i, item in ipairs(items) do
                        local itemBtn = Instance.new("TextButton", dropScroll)
                        itemBtn.Name             = "Item_"..i
                        itemBtn.Size             = UDim2.new(1, -8, 0, 26)
                        itemBtn.BackgroundColor3 = selectedValues[item] and theme.AccentDark or theme.Surface
                        itemBtn.BackgroundTransparency = selectedValues[item] and 0.6 or 1
                        itemBtn.TextColor3       = selectedValues[item] and theme.Text or theme.TextSecondary
                        itemBtn.Text             = "  "..tostring(item)
                        itemBtn.TextSize         = 12
                        itemBtn.Font             = Enum.Font.Gotham
                        itemBtn.TextXAlignment   = Enum.TextXAlignment.Left
                        itemBtn.BorderSizePixel  = 0
                        itemBtn.AutoButtonColor  = false
                        itemBtn.LayoutOrder      = i
                        itemBtn.ZIndex           = dropScroll.ZIndex + 1
                        local ic = Instance.new("UICorner", itemBtn); ic.CornerRadius = UDim.new(0, 4)
                        local pad2 = Instance.new("UIPadding", itemBtn)
                        pad2.PaddingLeft = UDim.new(0, 4); pad2.PaddingRight = UDim.new(0, 4)

                        itemBtn.MouseEnter:Connect(function()
                            if not selectedValues[item] then
                                Utility.SmoothTween(itemBtn, {BackgroundTransparency = 0.7, BackgroundColor3 = theme.SurfaceVariant}, 0.1)
                            end
                        end)
                        itemBtn.MouseLeave:Connect(function()
                            if not selectedValues[item] then
                                Utility.SmoothTween(itemBtn, {BackgroundTransparency = 1}, 0.1)
                            end
                        end)
                        itemBtn.MouseButton1Click:Connect(function()
                            if multi then
                                selectedValues[item] = not selectedValues[item]
                            else
                                selectedValues = {}
                                selectedValues[item] = true

                                Utility.SmoothTween(dropFrame, {Size = UDim2.new(0.52, 0, 0, 0)}, 0.2)
                                task.delay(0.2, function() dropFrame.Visible = false end)
                                Utility.SmoothTween(arrow, {Rotation = 0}, 0.2)
                            end

                            local selList = {}
                            for k, v in pairs(selectedValues) do if v then table.insert(selList, k) end end
                            if #selList == 0 then
                                selectedDisplay.Text = "Select..."
                            elseif #selList == 1 then
                                selectedDisplay.Text = selList[1]
                            else
                                selectedDisplay.Text = selList[1].." +"..tostring(#selList-1)
                            end

                            if flag then Lithium.Flags[flag] = multi and selList or selList[1] end
                            callback(multi and selList or selList[1])
                            rebuildItems()
                        end)
                    end
                end
                rebuildItems()

                local open = false
                selectedDisplay.MouseButton1Click:Connect(function()
                    open = not open
                    if open then
                        dropFrame.Visible = true
                        local maxH = math.min(#items * 30 + 8, 150)
                        Utility.SmoothTween(dropFrame, {Size = UDim2.new(0.52, 0, 0, maxH)}, 0.25)
                        Utility.SmoothTween(arrow, {Rotation = 180}, 0.2)
                    else
                        Utility.SmoothTween(dropFrame, {Size = UDim2.new(0.52, 0, 0, 0)}, 0.2)
                        task.delay(0.2, function() dropFrame.Visible = false end)
                        Utility.SmoothTween(arrow, {Rotation = 0}, 0.2)
                    end
                end)

                local DropObj = {
                    _row = row,
                    Get  = function()
                        local sel = {}
                        for k, v in pairs(selectedValues) do if v then table.insert(sel, k) end end
                        return multi and sel or sel[1]
                    end
                }
                function DropObj:Set(v)
                    selectedValues = {}
                    if multi and type(v) == "table" then
                        for _, item in ipairs(v) do selectedValues[item] = true end
                    else
                        selectedValues[v] = true
                    end
                    rebuildItems()
                end
                function DropObj:Refresh(newItems)
                    items = newItems
                    selectedValues = {}
                    selectedDisplay.Text = "Select..."
                    rebuildItems()
                end

                table.insert(self._elements, row)
                return DropObj
            end

            function Section:AddTextbox(tbOptions)
                tbOptions = tbOptions or {}
                local name        = tbOptions.Name        or "Input"
                local placeholder = tbOptions.Placeholder or "Type here..."
                local default     = tbOptions.Default     or ""
                local callback    = tbOptions.Callback    or function() end
                local clearOnFocus= tbOptions.ClearOnFocus ~= false
                local numeric     = tbOptions.Numeric     or false
                local flag        = tbOptions.Flag

                local row = makeItemRow(name, 52)

                Utility.Label(row, name,
                    UDim2.new(1, -10, 0, 18),
                    UDim2.new(0, 8, 0, 2),
                    theme.Text, 13, Enum.Font.GothamMedium, "TbName")

                local inputBg = Instance.new("Frame", row)
                inputBg.Name             = "InputBg"
                inputBg.Size             = UDim2.new(1, 0, 0, 26)
                inputBg.Position         = UDim2.new(0, 0, 0, 22)
                inputBg.BackgroundColor3 = theme.Surface
                inputBg.BorderSizePixel  = 0
                local ibc = Instance.new("UICorner", inputBg); ibc.CornerRadius = UDim.new(0, 6)
                local ibStroke = Utility.CreateStroke(inputBg, theme.Border, 1, 0)

                local textBox = Instance.new("TextBox", inputBg)
                textBox.Name              = "TextBox"
                textBox.Size             = UDim2.new(1, -16, 1, 0)
                textBox.Position         = UDim2.new(0, 8, 0, 0)
                textBox.BackgroundTransparency = 1
                textBox.Text             = default
                textBox.PlaceholderText  = placeholder
                textBox.PlaceholderColor3 = theme.TextMuted
                textBox.TextColor3       = theme.Text
                textBox.TextSize         = 12
                textBox.Font             = Enum.Font.Gotham
                textBox.TextXAlignment   = Enum.TextXAlignment.Left
                textBox.ClearTextOnFocus = clearOnFocus
                textBox.BorderSizePixel  = 0

                textBox.Focused:Connect(function()
                    Utility.SmoothTween(ibStroke, {Color = theme.Accent, Transparency = 0}, 0.2)
                end)
                textBox.FocusLost:Connect(function(enter)
                    Utility.SmoothTween(ibStroke, {Color = theme.Border, Transparency = 0}, 0.2)
                    local val = textBox.Text
                    if numeric then val = tonumber(val) or 0 end
                    if flag then Lithium.Flags[flag] = val end
                    callback(val, enter)
                end)

                local TbObj = {
                    _row = row,
                    Get  = function() return textBox.Text end,
                }
                function TbObj:Set(v) textBox.Text = tostring(v) end
                table.insert(self._elements, row)
                return TbObj
            end

            function Section:AddKeybind(kbOptions)
                kbOptions = kbOptions or {}
                local name        = kbOptions.Name     or "Keybind"
                local default     = kbOptions.Default  or Enum.KeyCode.Unknown
                local callback    = kbOptions.Callback or function() end
                local holdCallback= kbOptions.HoldCallback
                local flag        = kbOptions.Flag

                local row = makeItemRow(name, 38)

                Utility.Label(row, name,
                    UDim2.new(1, -80, 0, 30),
                    UDim2.new(0, 8, 0, 4),
                    theme.Text, 13, Enum.Font.GothamMedium, "KbName")

                local kbDisplay = Utility.Button(row,
                    UDim2.new(0, 68, 0, 22),
                    UDim2.new(1, -72, 0, 8),
                    theme.Surface, "KbDisplay")
                kbDisplay.ZIndex = row.ZIndex + 1
                local kbs = Utility.CreateStroke(kbDisplay, theme.Border, 1, 0)

                local kbLabel = Utility.Label(kbDisplay,
                    default.Name or "None",
                    UDim2.new(1, 0, 1, 0),
                    UDim2.new(0,0,0,0),
                    theme.Text, 11, Enum.Font.GothamMedium, "KbLabel",
                    Enum.TextXAlignment.Center)
                kbLabel.ZIndex = kbDisplay.ZIndex + 1

                local listening = false
                local currentKey = default
                if flag then Lithium.Flags[flag] = currentKey end

                kbDisplay.MouseButton1Click:Connect(function()
                    if listening then return end
                    listening = true
                    kbLabel.Text = "..."
                    Utility.SmoothTween(kbs, {Color = theme.Accent}, 0.15)
                    Utility.SmoothTween(kbDisplay, {BackgroundColor3 = Utility.LerpColor(theme.Surface, theme.Accent, 0.15)}, 0.15)
                end)

                UserInputService.InputBegan:Connect(function(input, processed)
                    if listening and input.UserInputType == Enum.UserInputType.Keyboard then
                        listening = false
                        currentKey = input.KeyCode
                        kbLabel.Text = input.KeyCode.Name
                        if flag then Lithium.Flags[flag] = currentKey end
                        Utility.SmoothTween(kbs, {Color = theme.Border}, 0.15)
                        Utility.SmoothTween(kbDisplay, {BackgroundColor3 = theme.Surface}, 0.15)
                    elseif not processed and input.KeyCode == currentKey then
                        callback(currentKey)
                    end
                end)
                if holdCallback then
                    UserInputService.InputEnded:Connect(function(input)
                        if input.KeyCode == currentKey then holdCallback(false) end
                    end)
                end

                local KbObj = {
                    _row = row,
                    Get  = function() return currentKey end
                }
                function KbObj:Set(key)
                    currentKey = key
                    kbLabel.Text = key.Name
                    if flag then Lithium.Flags[flag] = key end
                end
                table.insert(self._elements, row)
                return KbObj
            end

            function Section:AddColorPicker(cpOptions)
                cpOptions = cpOptions or {}
                local name     = cpOptions.Name     or "Color"
                local default  = cpOptions.Default  or Color3.fromRGB(255, 100, 100)
                local callback = cpOptions.Callback or function() end
                local flag     = cpOptions.Flag

                local row = makeItemRow(name, 38)

                Utility.Label(row, name,
                    UDim2.new(1, -60, 0, 30),
                    UDim2.new(0, 8, 0, 4),
                    theme.Text, 13, Enum.Font.GothamMedium, "CpName")

                local colorPreview = Instance.new("TextButton", row)
                colorPreview.Name             = "ColorPreview"
                colorPreview.Size             = UDim2.new(0, 46, 0, 22)
                colorPreview.Position         = UDim2.new(1, -50, 0, 8)
                colorPreview.BackgroundColor3 = default
                colorPreview.BorderSizePixel  = 0
                colorPreview.Text             = ""
                colorPreview.AutoButtonColor  = false
                colorPreview.ZIndex           = row.ZIndex + 1
                local cpc = Instance.new("UICorner", colorPreview); cpc.CornerRadius = UDim.new(0, 6)
                Utility.CreateStroke(colorPreview, theme.Border, 1, 0)

                local popupFrame = Instance.new("Frame", row)
                popupFrame.Name             = "ColorPickerPopup"
                popupFrame.Size             = UDim2.new(0, 180, 0, 0)
                popupFrame.Position         = UDim2.new(1, -184, 0, 34)
                popupFrame.BackgroundColor3 = theme.Surface
                popupFrame.BorderSizePixel  = 0
                popupFrame.ClipsDescendants = true
                popupFrame.ZIndex           = row.ZIndex + 15
                popupFrame.Visible          = false
                local pfc2 = Instance.new("UICorner", popupFrame); pfc2.CornerRadius = UDim.new(0, 8)
                Utility.CreateStroke(popupFrame, theme.Border, 1, 0)

                local hsvArea = Instance.new("ImageLabel", popupFrame)
                hsvArea.Name              = "HSVArea"
                hsvArea.Size             = UDim2.new(1, -12, 0, 100)
                hsvArea.Position         = UDim2.new(0, 6, 0, 8)
                hsvArea.BorderSizePixel  = 0
                hsvArea.Image            = "rbxassetid://4155801252"
                hsvArea.ZIndex           = popupFrame.ZIndex + 1
                local hasc = Instance.new("UICorner", hsvArea); hasc.CornerRadius = UDim.new(0, 4)

                local hueSliderBack = Instance.new("ImageLabel", popupFrame)
                hueSliderBack.Name          = "HueBack"
                hueSliderBack.Size          = UDim2.new(1, -12, 0, 12)
                hueSliderBack.Position      = UDim2.new(0, 6, 0, 116)
                hueSliderBack.Image         = "rbxassetid://4155801252"
                hueSliderBack.BorderSizePixel = 0
                hueSliderBack.ZIndex        = popupFrame.ZIndex + 1
                local hueBg = Instance.new("UIGradient", hueSliderBack)
                hueBg.Color = ColorSequence.new({
                    ColorSequenceKeypoint.new(0,    Color3.fromRGB(255,0,0)),
                    ColorSequenceKeypoint.new(0.167, Color3.fromRGB(255,255,0)),
                    ColorSequenceKeypoint.new(0.333, Color3.fromRGB(0,255,0)),
                    ColorSequenceKeypoint.new(0.5,  Color3.fromRGB(0,255,255)),
                    ColorSequenceKeypoint.new(0.667, Color3.fromRGB(0,0,255)),
                    ColorSequenceKeypoint.new(0.833, Color3.fromRGB(255,0,255)),
                    ColorSequenceKeypoint.new(1,    Color3.fromRGB(255,0,0)),
                })
                hueSliderBack.BackgroundTransparency = 1
                local hsbc = Instance.new("UICorner", hueSliderBack); hsbc.CornerRadius = UDim.new(0, 4)

                local hexLabel = Utility.Label(popupFrame, "#"..string.format("%02X%02X%02X",
                    math.floor(default.R*255), math.floor(default.G*255), math.floor(default.B*255)),
                    UDim2.new(1, -12, 0, 18),
                    UDim2.new(0, 6, 0, 136),
                    theme.TextSecondary, 11, Enum.Font.RobotoMono, "HexLabel",
                    Enum.TextXAlignment.Left)
                hexLabel.ZIndex = popupFrame.ZIndex + 2

                local currentColor = default
                local currentH, currentS, currentV = Color3.toHSV(default)
                if flag then Lithium.Flags[flag] = currentColor end

                local function updateColor()
                    currentColor = Color3.fromHSV(currentH, currentS, currentV)
                    colorPreview.BackgroundColor3 = currentColor
                    hexLabel.Text = "#"..string.format("%02X%02X%02X",
                        math.floor(currentColor.R*255),
                        math.floor(currentColor.G*255),
                        math.floor(currentColor.B*255))
                    if flag then Lithium.Flags[flag] = currentColor end
                    callback(currentColor)
                end

                local popupOpen = false
                colorPreview.MouseButton1Click:Connect(function()
                    popupOpen = not popupOpen
                    if popupOpen then
                        popupFrame.Visible = true
                        Utility.SmoothTween(popupFrame, {Size = UDim2.new(0, 180, 0, 164)}, 0.25)
                    else
                        Utility.SmoothTween(popupFrame, {Size = UDim2.new(0, 180, 0, 0)}, 0.2)
                        task.delay(0.2, function() popupFrame.Visible = false end)
                    end
                end)

                local hueDragging = false
                hueSliderBack.InputBegan:Connect(function(i)
                    if i.UserInputType == Enum.UserInputType.MouseButton1 then
                        hueDragging = true
                    end
                end)
                UserInputService.InputEnded:Connect(function(i)
                    if i.UserInputType == Enum.UserInputType.MouseButton1 then
                        hueDragging = false
                    end
                end)
                UserInputService.InputChanged:Connect(function(i)
                    if hueDragging and i.UserInputType == Enum.UserInputType.MouseMovement then
                        local abs = hueSliderBack.AbsolutePosition
                        local size = hueSliderBack.AbsoluteSize
                        currentH = math.clamp((i.Position.X - abs.X)/size.X, 0, 1)
                        updateColor()
                    end
                end)

                local CpObj = {
                    _row = row,
                    Get  = function() return currentColor end
                }
                function CpObj:Set(c)
                    currentColor = c
                    currentH, currentS, currentV = Color3.toHSV(c)
                    colorPreview.BackgroundColor3 = c
                    if flag then Lithium.Flags[flag] = c end
                end
                table.insert(self._elements, row)
                return CpObj
            end

            function Section:AddParagraph(pOptions)
                pOptions = pOptions or {}
                local title   = pOptions.Title   or ""
                local content = pOptions.Content or ""

                local row = makeItemRow(title or "Para", 0)
                row.AutomaticSize = Enum.AutomaticSize.Y
                row.Size          = UDim2.new(1, 0, 0, 0)

                local inner = Instance.new("Frame", row)
                inner.Size               = UDim2.new(1, 0, 0, 0)
                inner.AutomaticSize      = Enum.AutomaticSize.Y
                inner.BackgroundTransparency = 1
                inner.BorderSizePixel    = 0
                local innerLayout = Instance.new("UIListLayout", inner)
                innerLayout.SortOrder = Enum.SortOrder.LayoutOrder
                local innerPad = Instance.new("UIPadding", inner)
                innerPad.PaddingLeft = UDim.new(0, 8); innerPad.PaddingRight = UDim.new(0, 8)
                innerPad.PaddingTop = UDim.new(0, 4); innerPad.PaddingBottom = UDim.new(0, 4)

                if title ~= "" then
                    local tl = Utility.Label(inner, title,
                        UDim2.new(1, 0, 0, 18),
                        UDim2.new(0,0,0,0),
                        theme.Text, 13, Enum.Font.GothamBold, "ParaTitle")
                    tl.LayoutOrder = 1
                end

                local cl = Instance.new("TextLabel", inner)
                cl.Name              = "ParaContent"
                cl.Size              = UDim2.new(1, 0, 0, 0)
                cl.AutomaticSize     = Enum.AutomaticSize.Y
                cl.BackgroundTransparency = 1
                cl.Text              = content
                cl.TextColor3        = theme.TextSecondary
                cl.TextSize          = 12
                cl.Font              = Enum.Font.Gotham
                cl.TextWrapped       = true
                cl.TextXAlignment    = Enum.TextXAlignment.Left
                cl.TextYAlignment    = Enum.TextYAlignment.Top
                cl.LayoutOrder       = 2

                table.insert(self._elements, row)
                return row
            end

            table.insert(Tab._sections, Section)
            return Section
        end

        return Tab
    end

    function Window:SaveConfig(name)
        if not configName and not name then return end
        local fname = name or configName
        local data = {}
        for k, v in pairs(Lithium.Flags) do
            if type(v) == "boolean" then
                data[k] = {type = "bool", value = v}
            elseif type(v) == "number" then
                data[k] = {type = "num", value = v}
            elseif type(v) == "string" then
                data[k] = {type = "str", value = v}
            end
        end
        local json = HttpService:JSONEncode(data)
        local success, err = pcall(function()
            writefile(fname..".lithcfg", json)
        end)
        if success then
            Lithium:Notify({ Title = "Config Saved", Content = "Saved as '"..fname..".lithcfg'", Type = "Success", Duration = 2 })
        else
            Lithium:Notify({ Title = "Config Error", Content = "Could not save: "..tostring(err), Type = "Error" })
        end
    end

    function Window:LoadConfig(name)
        if not configName and not name then return end
        local fname = name or configName
        local success, data = pcall(function()
            return HttpService:JSONDecode(readfile(fname..".lithcfg"))
        end)
        if success and data then
            for k, v in pairs(data) do
                Lithium.Flags[k] = v.value
            end
            Lithium:Notify({ Title = "Config Loaded", Content = "Loaded '"..fname..".lithcfg'", Type = "Success", Duration = 2 })
        else
            Lithium:Notify({ Title = "Config Error", Content = "Could not load config.", Type = "Error" })
        end
    end

    function Window:Destroy()
        ScreenGui:Destroy()
    end

    table.insert(Lithium.Windows, Window)

    MainFrame.Size = UDim2.new(0, windowSize.X.Offset, 0, 0)
    MainFrame.BackgroundTransparency = 1
    Utility.SmoothTween(MainFrame, {
        Size = windowSize,
        BackgroundTransparency = 0,
    }, 0.45)

    return Window
end

function Lithium:SetTheme(themeName)
    self.CurrentTheme = themeName
end

function Lithium:RegisterTheme(name, themeTable)
    self.Themes[name] = themeTable
end

return Lithium