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
| Parameter&emsp;&emsp;&emsp;&emsp;&emsp;&emsp; | Description&emsp;&emsp;&emsp;&emsp;&emsp;&emsp; |
| :-------- | :------- |
| Script: [LuaSourceContainer](https://create.roblox.com/docs/reference/engine/classes/LuaSourceContainer) | The script to read. |
# Returns
| Type&emsp;&emsp;&emsp;&emsp;&emsp;&emsp; | Description&emsp;&emsp;&emsp;&emsp;&emsp;&emsp; |
| :-------- | :------- |
| {[string]: any} | The script's environment. |
# Test requirements
To pass the getsenv test, the function must:
- Return the environment of a running LocalScript.
- Set `script` in the returned environment to that LocalScript.
- Include globals the running script sets.
- Return an environment when the script's parent is `nil`, with `script` still set to that LocalScript.
