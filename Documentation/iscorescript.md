# iscorescript: (Script: LuaSourceContainer) -> boolean
Returns whether or not a script is one of Roblox's core scripts.
```lua
print(iscorescript(game.Players.LocalPlayer.PlayerScripts.PlayerModule)) --> false
```
# Aliases
| Name |
| :- |
| is_core_script |
# Parameters
| Script: [LuaSourceContainer](https://create.roblox.com/docs/reference/engine/classes/LuaSourceContainer)&emsp;&emsp;&emsp;&emsp;&emsp;&emsp; | The script to check.&emsp;&emsp;&emsp;&emsp;&emsp;&emsp; |
| :-------- | :------- |
# Returns
| [boolean](https://create.roblox.com/docs/luau/booleans)&emsp;&emsp;&emsp;&emsp;&emsp;&emsp; | Whether or not it's a core script.&emsp;&emsp;&emsp;&emsp;&emsp;&emsp; |
| :-------- | :------- |
# Test requirements
To pass the iscorescript test, the function must:
- Return `false` for the PlayerModule, which isn't a core script.
- Return `true` for a ModuleScript in CoreGui.
