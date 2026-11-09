# fireproximityprompt: (ProximityPrompt: ProximityPrompt) -> ()
Triggers a ProximityPrompt as if the player used it.
```lua
local ProximityPrompt = workspace.Door.ProximityPrompt
fireproximityprompt(ProximityPrompt)
```
# Aliases
| Name |
| :- |
| fire_proximity_prompt |
# Parameters
| ProximityPrompt: [ProximityPrompt](https://create.roblox.com/docs/reference/engine/classes/ProximityPrompt)&emsp;&emsp;&emsp;&emsp;&emsp;&emsp; | The ProximityPrompt to trigger.&emsp;&emsp;&emsp;&emsp;&emsp;&emsp; |
| :-------- | :------- |

# Test requirements
To pass the fireproximityprompt test, the function must:
- Leave the prompt's `HoldDuration`, `MaxActivationDistance`, `RequiresLineOfSight`, and `Enabled` unchanged after firing.
- Fire `Triggered` with the local player within a second, for a prompt 10,000 studs away with a 5 second `HoldDuration`.
