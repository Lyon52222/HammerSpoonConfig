function showFocusAlert(content)
    hs.alert.show(content, hs.alert.defaultStyle, hs.screen.mainScreen(), 0.5)
end

local function keyStroke(mods, key)
    if key == nil then
        key = mods
        mods = {}
    end

    return function() hs.eventtap.keyStroke(mods, key, 1000) end
end

local function remap(mods, key, pressFn)
    return hs.hotkey.bind(mods, key, pressFn, nil, pressFn)
end

local scenarioShortcuts = {
    qq = {
        nextDial = remap({ 'ctrl' }, 'l', keyStroke({ 'ctrl' }, 'tab')),
        prevDial = remap({ 'ctrl' }, 'h', keyStroke({ 'ctrl', 'shift' }, 'tab'))
    }
}


local function enableScenarioShortcuts(scenario)
    for _, value in pairs(scenarioShortcuts[scenario]) do
        value:enable()
    end
end

local function disableScenarioShortcuts(scenario)
    for _, value in pairs(scenarioShortcuts[scenario]) do
        value:disable()
    end
end

function applicationWatcher(appName, eventType, appObject)
    if (eventType == hs.application.watcher.activated) then
        -- 初始化senarioShortcuts
        if (appName == "Finder") then
            -- Bring all Finder windows forward when one gets activated
            appObject:selectMenuItem({ "Window", "Bring All to Front" })
        end
        if (appName == "QQ") then
            enableScenarioShortcuts('qq')
        end
    end
    print('current' .. serializeTable(scenarioShortcuts))
end

appWatcher = hs.application.watcher.new(applicationWatcher)
appWatcher:start()
