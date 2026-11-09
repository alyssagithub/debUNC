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
| Module: [ModuleScript](https://create.roblox.com/docs/reference/engine/classes/ModuleScript)&emsp;&emsp;&emsp;&emsp;&emsp;&emsp; | The ModuleScript to read.&emsp;&emsp;&emsp;&emsp;&emsp;&emsp; |
| :-------- | :------- |
# Returns
| {[string]: any}&emsp;&emsp;&emsp;&emsp;&emsp;&emsp; | The module's environment.&emsp;&emsp;&emsp;&emsp;&emsp;&emsp; |
| :-------- | :------- |
# Test requirements
To pass the getmenv test, the function must:
- Return a table for the PlayerModule's CameraWrapper ModuleScript.
- Set `script` in the returned environment to that module.
- Return the same environment that the module's functions use.
