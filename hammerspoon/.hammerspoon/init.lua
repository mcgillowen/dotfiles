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
                   show_in_menubar = false,
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

  if hs.battery.isCharging() then
    if chargeTime == -1 then
      displayString = string.format("Time: %02d:%02d\nDate: %02d.%02d.%02d\nPercentage: %02.0f%%\nCharging: calculating", time.hour, time.min, time.day, time.month, time.year, battery)
      hs.alert(displayString,3)
    else
      chargeHours = math.floor(chargeTime//60)
      chargeMinutes = math.floor(chargeTime%60)

      displayString = string.format("Time: %02d:%02d\nDate: %02d.%02d.%02d\nPercentage: %02.0f%%\nCharging: %02.0f:%02.0f", time.hour, time.min, time.day, time.month, time.year, battery, chargeHours, chargeMinutes)
      hs.alert(displayString,3)
    end
  elseif not hs.battery.isCharged() then
    if timeLeft == -1 then
      displayString = string.format("Time: %02d:%02d\nDate: %02d.%02d.%02d\nPercentage: %02.0f%%\nDischarging: calculating", time.hour, time.min, time.day, time.month, time.year, battery)
      hs.alert(displayString,3)
    else
      batteryHours = math.floor(timeLeft//60)
      batteryMinutes = math.floor(timeLeft%60)

      displayString = string.format("Time: %02d:%02d\nDate: %02d.%02d.%02d\nPercentage: %02.0f%%\nDischarging: %02.0f:%02.0f", time.hour, time.min, time.day, time.month, time.year, battery, batteryHours, batteryMinutes)
      hs.alert(displayString,3)
    end
  else
    displayString = string.format("Time: %02d:%02d\nDate: %02d.%02d.%02d", time.hour, time.min, time.day, time.month, time.year)
    hs.alert(displayString,3)
  end
end

function getNetworkInfo()
  addresses = hs.network.addresses()
  displayString = ""
  for k, v in pairs(addresses) do
    if k == 1 then
      displayString = string.format("%s%s - %s", displayString, k, v)
    else
      displayString = string.format("%s\n%s - %s", displayString, k, v)
    end
  end
  hs.alert(displayString,3)
end



function reloadConfig(paths)
  hs.reload()
  hs.notify.new({title="Hammerspoon config reloaded", informativeText="Manually via keyboard shortcut"}):send()
  spoon.TextClipboardHistory:clearAll()
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
