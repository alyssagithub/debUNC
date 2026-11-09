# fireclickdetector: (ClickDetector: ClickDetector, Distance: number?, Event: string?) -> ()
Fires a ClickDetector as if the player clicked on it, or fires one of its other events.
```lua
local ClickDetector = workspace.Button.ClickDetector
fireclickdetector(ClickDetector)
fireclickdetector(ClickDetector, 0, "RightMouseClick")
```
# Aliases
| Name |
| :- |
| fire_click_detector |
# Parameters
| ClickDetector: [ClickDetector](https://create.roblox.com/docs/reference/engine/classes/ClickDetector)&emsp;&emsp;&emsp;&emsp;&emsp;&emsp; | The ClickDetector to fire.&emsp;&emsp;&emsp;&emsp;&emsp;&emsp; |
| :-------- | :------- |
| Distance: [number?](https://create.roblox.com/docs/luau/numbers) | How far away the click comes from. |
| Event: [string?](https://create.roblox.com/docs/luau/strings) | Which event to fire: MouseClick, RightMouseClick, MouseHoverEnter or MouseHoverLeave. Defaults to MouseClick. |

# Test requirements
To pass the fireclickdetector test, the function must:
- Fire `MouseClick` with the local player.
- Fire `RightMouseClick`, `MouseHoverEnter`, and `MouseHoverLeave` when they're passed as the event.
- Fire for a ClickDetector 10,000 studs away.
- Leave the ClickDetector's `MaxActivationDistance` unchanged after firing.
