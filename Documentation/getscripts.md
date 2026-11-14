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
| Type&emsp;&emsp;&emsp;&emsp;&emsp;&emsp; | Description&emsp;&emsp;&emsp;&emsp;&emsp;&emsp; |
| :-------- | :------- |
| {[LuaSourceContainer](https://create.roblox.com/docs/reference/engine/classes/LuaSourceContainer)} | An array of scripts. |
# Test requirements
To pass the getscripts test, the function must:
- Include the PlayerModule.
- Include every running LocalScript in PlayerScripts.
- Return only instances.
- Return only scripts and ModuleScripts.
- List each script only once.
- Return a table.
