![image](https://cdn.jsdelivr.net/gh/imchivie/my-assets@refs/heads/main/cv-blackout.png)

# CV-Blackout

A lightweight blackout system for QBCore servers using `qb-weathersync`, featuring dramatic power outage effects, screen flashes, light flickering, camera shake, and optional update checking.

## Features

- Toggle city-wide blackouts
- Dramatic power outage and restore effects
- Random light flickering during blackouts
- Export and event support for other resources
- Optional notifications
- GitHub version checking

## Dependencies

- qb-core
- qb-weathersync
- InteractSound (optional, for blackout sounds)

## Installation

1. Place `cv-blackout` in your resources folder.
2. Ensure the resource after `qb-core` and `qb-weathersync`.
3. Add to your server.cfg:

```cfg
ensure cv-blackout
```

## Command

```text
/blackouttoggle
```

*Requires admin permission.*
- add_ace group.admin command.blackouttoggle allow

## Exports

```lua
exports['cv-blackout']:ToggleBlackout()
exports['cv-blackout']:ToggleBlackout(true)
exports['cv-blackout']:ToggleBlackout(false)
```

## Events

### Toggle Blackout

```lua
TriggerEvent('cv-blackout:server:toggle')
```

### Set Blackout State

```lua
TriggerEvent('cv-blackout:server:set', true)  -- Enable
TriggerEvent('cv-blackout:server:set', false) -- Disable
```

## Configuration

```lua
Config.Notify = false
Config.checkUpdates = true
Config.volume = 1
```

## Credits

Created by **imchivie**

GitHub:
https://github.com/imchivie
