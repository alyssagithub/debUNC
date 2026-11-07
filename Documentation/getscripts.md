# getscripts: () -> {LuaSourceContainer}
Returns every script, including ModuleScripts.
```lua
for _, Script in getscripts() do
	print(Script:GetFullName())
end
```
# Aliases
| Name |
| :- |
| get_scripts |
# Returns
| {[LuaSourceContainer](https://create.roblox.com/docs/reference/engine/classes/LuaSourceContainer)}&emsp;&emsp;&emsp;&emsp;&emsp;&emsp; | An array of scripts.&emsp;&emsp;&emsp;&emsp;&emsp;&emsp; |
| :-------- | :------- |
