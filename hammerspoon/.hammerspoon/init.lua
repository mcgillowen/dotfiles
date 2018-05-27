--------------------------------------------
-- Set up
-------------------------------------------

local hyper ={"shift","cmd","alt","ctrl"}

local super = {"cmd", "shift"}

--------------------------------------------
-- Install Spoons
-------------------------------------------

hs.loadSpoon("SpoonInstall")

Install = spoon.SpoonInstall

Install.use_syncinstall = true

Install:updateAllRepos()

---------------------------------------------

-------------------------------------------
Install:andUse("TextClipboardHistory",
               {
                 config = {
                   show_in_menubar = true,
                 },
                 hotkeys = {
                   toggle_clipboard = { super, "v" } },
                 start = true,
               }
)
-------------------------------------------
-- Functions
-------------------------------------------

function showTimeAndBattery()
  time = os.date("*t")
  battery = hs.battery.percentage()
  timeLeft = hs.battery.timeRemaining()
  chargeTime = hs.battery.timeToFullCharge()
  if chargeTime == -2 then
    chargeTime = 0
  end

  if hs.battery.isCharging() then

    chargeHours = math.floor(chargeTime/60)
    chargeMinutes = chargeTime%60

    displayString = string.format("Time: %02d:%02d\nDate: %02d.%02d.%02d\nPercentage: %02d%%\nCharging: %02d:%02d", time.hour, time.min, time.day, time.month, time.year, battery, chargeHours, chargeMinutes)
    hs.alert(displayString,3)
  elseif not hs.battery.isCharged() then

    batteryHours = math.floor(timeLeft/60)
    batteryMinutes = timeLeft%60

    displayString = string.format("Time: %02d:%02d\nDate: %02d.%02d.%02d\nPercentage: %02d%%\nDischarging: %02d:%02d", time.hour, time.min, time.day, time.month, time.year, battery, batteryHours, batteryMinutes)
    hs.alert(displayString,3)
  else
    displayString = string.format("Time: %02d:%02d\nDate: %02d.%02d.%02d", time.hour, time.min, time.day, time.month, time.year)
    hs.alert(displayString,3)
  end
end

function getNetworkInfo()
  addresses = hs.network.addresses()
  hs.alert(addresses,3)
end



function reloadConfig(paths)
  hs.reload()
  hs.notify.new({title="Hammerspoon config reloaded", informativeText="Manually via keyboard shortcut"}):send()
end


hs.pathwatcher.new(os.getenv("HOME") .. "/.hammerspoon/", reloadConfig):start()

---------------------------------------
----------- Hotkey binding ------------
---------------------------------------

--------- Hammerspoon builtins --------
hs.hotkey.bind(hyper, 'l', function() hs.caffeinate.lockScreen() end)

---------- Custom functions -----------
hs.hotkey.bind(hyper, 't', showTimeAndBattery)
hs.hotkey.bind(hyper, 'o', getNetworkInfo)
