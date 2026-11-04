# decompile: (Script: LuaSourceContainer) -> string
Turns a script's bytecode into readable code. It's a rebuilt version and not the original source, so things like comments and local variable names are lost.
```lua
local Source = decompile(game.StarterPlayer.StarterPlayerScripts.PlayerModule)
print(Source)
```
# Parameters
| Script: [LuaSourceContainer](https://create.roblox.com/docs/reference/engine/classes/LuaSourceContainer)&emsp;&emsp;&emsp;&emsp;&emsp;&emsp; | The script to decompile.&emsp;&emsp;&emsp;&emsp;&emsp;&emsp; |
| :-------- | :------- |
# Returns
| [string](https://create.roblox.com/docs/luau/strings)&emsp;&emsp;&emsp;&emsp;&emsp;&emsp; | The decompiled code.&emsp;&emsp;&emsp;&emsp;&emsp;&emsp; |
| :-------- | :------- |
