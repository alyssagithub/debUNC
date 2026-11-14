# getmenv: (Module: ModuleScript) -> {[string]: any}
Returns the environment of a ModuleScript.
```lua
local PlayerModule = game.Players.LocalPlayer.PlayerScripts.PlayerModule
print(getmenv(PlayerModule).script == PlayerModule) --> true
```
# Aliases
| Name |
| :- |
| get_module_environment |
| getmoduleenvironment |
# Parameters
| Parameter&emsp;&emsp;&emsp;&emsp;&emsp;&emsp; | Description&emsp;&emsp;&emsp;&emsp;&emsp;&emsp; |
| :-------- | :------- |
| Module: [ModuleScript](https://create.roblox.com/docs/reference/engine/classes/ModuleScript) | The ModuleScript to read. |
# Returns
| Type&emsp;&emsp;&emsp;&emsp;&emsp;&emsp; | Description&emsp;&emsp;&emsp;&emsp;&emsp;&emsp; |
| :-------- | :------- |
| {[string]: any} | The module's environment. |
# Test requirements
To pass the getmenv test, the function must:
- Return a table for the PlayerModule's CameraWrapper ModuleScript.
- Set `script` in the returned environment to that module.
- Return the same environment that the module's functions use.
