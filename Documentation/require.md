# require: (Module: ModuleScript) -> any
Runs a ModuleScript from the executor and returns what it returns, the same way a game script's require does.
```lua
local PlayerModule = require(game.Players.LocalPlayer.PlayerScripts.PlayerModule)
print(PlayerModule:GetControls()) --> ControlModule's table
```
# Parameters
| Module: [ModuleScript](https://create.roblox.com/docs/reference/engine/classes/ModuleScript)&emsp;&emsp;&emsp;&emsp;&emsp;&emsp; | The ModuleScript to run.&emsp;&emsp;&emsp;&emsp;&emsp;&emsp; |
| :-------- | :------- |
# Returns
| any&emsp;&emsp;&emsp;&emsp;&emsp;&emsp; | What the module returns.&emsp;&emsp;&emsp;&emsp;&emsp;&emsp; |
| :-------- | :------- |
# Test requirements
To pass the require test, the function must:
- Return a table for the PlayerModule.
- Return the same result when the same module is required twice.
- Return the real PlayerModule, so its `GetControls` gives the same table as requiring the ControlModule.
- Run a copy of a module on its own, so it doesn't give back the original's result.
- Return the same result when the same copy is required twice.
- Error when given something that isn't a ModuleScript, like a Folder or a LocalScript.