local laptopScreen = "Color LCD"
-- local otherDisplay = "U28D590"
local otherDisplay = "ASUS VP28U"

hs.window.animationDuration = 0

positions = {
  maximized = hs.layout.maximized,
  middle_wide = {x=0.15, y=0, w=0.7, h=1},
  left25 = { x=0, y=0, w=0.5, h=1}

}

local windowLayoutLaptop = {
	{"Safari",  nil,          laptopScreen, positions.maximized,    nil, nil},
	{"Mail",    nil,          laptopScreen, positions.maximized,   nil, nil},
	{"OmniFocus",  nil,     laptopScreen, positions.maximized, nil, nil},
	{"Google Chrome",  nil,     laptopScreen, positions.maximized, nil, nil},
	{"Calendar",  nil,     laptopScreen, positions.maximized, nil, nil},
	{"PyCharm",  nil,     laptopScreen, positions.maximized, nil, nil},
	{"PyCharm",  "Project",     laptopScreen, positions.left25, nil, nil},

	{"Skype",  nil,     laptopScreen, positions.maximized, nil, nil},
	{"Tower",  nil,     laptopScreen, positions.maximized, nil, nil},
	{"Sublime Text",  nil,     laptopScreen, positions.maximized, nil, nil},
	{"Querious",  nil,     laptopScreen, positions.maximized, nil, nil},
	{"Path Finder",  nil,     laptopScreen, positions.maximized, nil, nil},	

	{"Slack",  nil,     laptopScreen, positions.middle_wide, nil, nil},	
}

local windowLayoutBigDisplay = {
	{"Safari",  nil,          otherDisplay, positions.maximized,    nil, nil},
	{"Mail",    nil,          otherDisplay, positions.maximized,   nil, nil},
	{"OmniFocus",  nil,     otherDisplay, positions.middle_wide, nil, nil},
	{"Google Chrome",  nil,     otherDisplay, positions.maximized, nil, nil},
	{"Calendar",  nil,     otherDisplay, positions.maximized, nil, nil},
	{"PyCharm",  nil,     otherDisplay, positions.maximized, nil, nil},
	{"PyCharm",  "Project",     otherDisplay, positions.left25, nil, nil},
	{"Skype",  nil,     otherDisplay, positions.maximized, nil, nil},
	{"Tower",  nil,     otherDisplay, positions.maximized, nil, nil},
	{"Sublime Text",  nil,     otherDisplay, positions.maximized, nil, nil},
	{"Querious",  nil,     otherDisplay, positions.maximized, nil, nil},
	{"Path Finder",  nil,     otherDisplay, positions.maximized, nil, nil},	
	{"Slack",  nil,     otherDisplay, positions.middle_wide, nil, nil},	
}

function applyMyLayout()

	have_big_display = false
	screens = hs.screen.allScreens()
	for k,v in pairs(screens) do 
		print(k,v)
		if v == "U28D590" then
			have_big_display = true
			print("have big")
		end
	end
	if have_big_display then
		print("Applying laptop layout")
		hs.layout.apply(windowLayoutLaptop)
	else
		print("Applying desktop layout")
		hs.layout.apply(windowLayoutBigDisplay)
	end


end

applyMyLayout()

k = hs.hotkey.modal.new({"ctrl"}, "h")

function hideAllApps()
	for _,app in pairs(hs.application.runningApplications()) do
		app:hide()
	end
	k:exit()
end

function hideOthersAndResize()
	local frontWindows = hs.application.frontmostApplication():visibleWindows()
	frame = hs.screen.mainScreen():frame()
	frame.x2 = frame.x2 - 150
	for _,window in pairs(frontWindows) do
		window:setFrame(frame)
	end
	for _,app in pairs(hs.application.runningApplications()) do
		if app ~= hs.application.frontmostApplication() then
			app:hide()
		end
	end
	k:exit()
end

function fullScreen()
	local frame = hs.window.focusedWindow():screen():frame()
	hs.window.focusedWindow():setFrame(frame)
	k:exit()
end

function leftScreen()
	local frame = hs.window.focusedWindow():screen():frame()
	frame.x2 = frame.x1 + (frame.x2 - frame.x1) / 2
	hs.window.focusedWindow():setFrame(frame)
	k:exit()
end

function rightScreen()
	local frame = hs.window.focusedWindow():screen():frame()
	frame.x1 = frame.x1 + (frame.x2 - frame.x1) / 2
	frame.w = frame.w / 2
	hs.window.focusedWindow():setFrame(frame)
	k:exit()
end

function throwLeft()	
	hs.window.focusedWindow():moveOneScreenWest()
	k:exit()
end


function throwRight()	
	hs.window.focusedWindow():moveOneScreenEast()
	k:exit()
end

function throwUp()	
	hs.window.focusedWindow():moveOneScreenNorth()
	k:exit()
end


function throwDown()	
	hs.window.focusedWindow():moveOneScreenSouth()
	k:exit()
end


function middleScreen()
	local frame = hs.window.focusedWindow():screen():frame()
	frame.x1 = frame.x1 + frame.w / 4
	frame.x2 = frame.x1 + frame.w * 0.5
	hs.window.focusedWindow():setFrame(frame)
	k:exit()
end

k:bind({}, 'h', nil, hideAllApps)
k:bind({}, 'w', nil, hideOthersAndResize)
k:bind({}, 't', nil, fullScreen)
k:bind({}, 'c', nil, leftScreen)
k:bind({}, 'r', nil, rightScreen)
k:bind({}, 'm', nil, middleScreen)
k:bind({}, 'g', nil, throwLeft)
k:bind({}, 'l', nil, throwRight)

function reloadConfig(files)
    doReload = false
    for _,file in pairs(files) do
        if file:sub(-4) == ".lua" then
            doReload = true
        end
    end
    if doReload then
        hs.reload()
    end
end
myWatcher = hs.pathwatcher.new(os.getenv("HOME") .. "/.hammerspoon/", reloadConfig):start()
hs.alert.show("Config loaded")




