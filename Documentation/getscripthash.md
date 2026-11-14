# getscripthash: (Script: LuaSourceContainer) -> string
Returns the SHA-384 hash of a script's bytecode.
```lua
local Hash = getscripthash(game.Players.LocalPlayer.PlayerScripts.PlayerModule)
print(#Hash) --> 96
```
# Aliases
| Name |
| :- |
| get_script_hash |
# Parameters
| Parameter&emsp;&emsp;&emsp;&emsp;&emsp;&emsp; | Description&emsp;&emsp;&emsp;&emsp;&emsp;&emsp; |
| :-------- | :------- |
| Script: [LuaSourceContainer](https://create.roblox.com/docs/reference/engine/classes/LuaSourceContainer) | The script to hash. |
# Returns
| Type&emsp;&emsp;&emsp;&emsp;&emsp;&emsp; | Description&emsp;&emsp;&emsp;&emsp;&emsp;&emsp; |
| :-------- | :------- |
| [string](https://create.roblox.com/docs/luau/strings) | The hash in hexadecimal. |
# Test requirements
To pass the getscripthash test, the function must:
- Return a string for a LocalScript.
- Return a hash that isn't empty.
- Return the same hash each time for the same script.
- Return different hashes for different scripts.
- Return a 96 character hexadecimal SHA-384 hash.
- Match the SHA-384 of the script's bytecode from [getscriptbytecode](getscriptbytecode.md).
