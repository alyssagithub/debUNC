# getscripthash: (Script: LuaSourceContainer) -> string
Returns the SHA-384 hash of a script's bytecode.
```lua
local Hash = getscripthash(game.Players.LocalPlayer.PlayerScripts.PlayerModule)
print(#Hash) --> 96
```
# Aliases
| Library | Name |
| :- | :- |
| | get_script_hash |
# Parameters
| Script: [LuaSourceContainer](https://create.roblox.com/docs/reference/engine/classes/LuaSourceContainer)&emsp;&emsp;&emsp;&emsp;&emsp;&emsp; | The script to hash.&emsp;&emsp;&emsp;&emsp;&emsp;&emsp; |
| :-------- | :------- |
# Returns
| [string](https://create.roblox.com/docs/luau/strings)&emsp;&emsp;&emsp;&emsp;&emsp;&emsp; | The hash in hexadecimal.&emsp;&emsp;&emsp;&emsp;&emsp;&emsp; |
| :-------- | :------- |
