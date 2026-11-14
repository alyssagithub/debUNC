# decompile: (Script: LuaSourceContainer) -> string
Turns a script's bytecode into readable code. It's a rebuilt version and not the original source, so things like comments and local variable names are lost.
```lua
local Source = decompile(game.StarterPlayer.StarterPlayerScripts.PlayerModule)
print(Source)
```
# Parameters
| Parameter&emsp;&emsp;&emsp;&emsp;&emsp;&emsp; | Description&emsp;&emsp;&emsp;&emsp;&emsp;&emsp; |
| :-------- | :------- |
| Script: [LuaSourceContainer](https://create.roblox.com/docs/reference/engine/classes/LuaSourceContainer) | The script to decompile. |
# Returns
| Type&emsp;&emsp;&emsp;&emsp;&emsp;&emsp; | Description&emsp;&emsp;&emsp;&emsp;&emsp;&emsp; |
| :-------- | :------- |
| [string](https://create.roblox.com/docs/luau/strings) | The decompiled code. |

# Test requirements
To pass the decompile test, the function must:
- Return a string.
- Return readable code with no null bytes.
- Include `__index` in the decompiled `CameraModule`.
- Return different code for `CameraModule` and `ControlModule`.
- Keep the script's own string constants in the decompiled code.
