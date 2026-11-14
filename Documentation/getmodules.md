# getmodules: () -> {ModuleScript}
Returns every ModuleScript.
```lua
for _, Module in getmodules() do
	print(Module:GetFullName())
end
```
# Returns
| Type&emsp;&emsp;&emsp;&emsp;&emsp;&emsp; | Description&emsp;&emsp;&emsp;&emsp;&emsp;&emsp; |
| :-------- | :------- |
| {[ModuleScript](https://create.roblox.com/docs/reference/engine/classes/ModuleScript)} | An array of ModuleScripts. |
# Test requirements
To pass the getmodules test, the function must:
- Return a table.
- Include the PlayerModule, which is always loaded.
- Include a new ModuleScript right after it's parented to `workspace`.
- Return only ModuleScripts.
