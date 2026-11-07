# getsenv: (Script: LuaSourceContainer) -> {[string]: any}
Returns the environment of a running script.
```lua
local Script = game.Players.LocalPlayer.Character.Animate
print(getsenv(Script).script == Script) --> true
```
# Aliases
| Name |
| :- |
| get_script_environment |
| get_senv |
| getscriptenvironment |
# Parameters
| Script: [LuaSourceContainer](https://create.roblox.com/docs/reference/engine/classes/LuaSourceContainer)&emsp;&emsp;&emsp;&emsp;&emsp;&emsp; | The script to read.&emsp;&emsp;&emsp;&emsp;&emsp;&emsp; |
| :-------- | :------- |
# Returns
| {[string]: any}&emsp;&emsp;&emsp;&emsp;&emsp;&emsp; | The script's environment.&emsp;&emsp;&emsp;&emsp;&emsp;&emsp; |
| :-------- | :------- |
