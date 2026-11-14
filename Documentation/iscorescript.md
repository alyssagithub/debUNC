# iscorescript: (Script: LuaSourceContainer) -> boolean
> [!NOTE]
> **Niche**
>
> This function is not widely implemented by executors, so scripts should implement proper handling in the case of an executor being unable to use this.

Returns whether or not a script is one of Roblox's core scripts.
```lua
print(iscorescript(game.Players.LocalPlayer.PlayerScripts.PlayerModule)) --> false
```
# Aliases
| Name |
| :- |
| is_core_script |
# Parameters
| Parameter&emsp;&emsp;&emsp;&emsp;&emsp;&emsp; | Description&emsp;&emsp;&emsp;&emsp;&emsp;&emsp; |
| :-------- | :------- |
| Script: [LuaSourceContainer](https://create.roblox.com/docs/reference/engine/classes/LuaSourceContainer) | The script to check. |
# Returns
| Type&emsp;&emsp;&emsp;&emsp;&emsp;&emsp; | Description&emsp;&emsp;&emsp;&emsp;&emsp;&emsp; |
| :-------- | :------- |
| [boolean](https://create.roblox.com/docs/luau/booleans) | Whether or not it's a core script. |
# Test requirements
To pass the iscorescript test, the function must:
- Return `false` for the PlayerModule, which isn't a core script.
- Return `true` for a ModuleScript in CoreGui.
