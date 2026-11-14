# getloadedmodules: () -> {ModuleScript}
Returns every ModuleScript that has been required.
```lua
for _, Module in getloadedmodules() do
	print(Module:GetFullName())
end
```
# Aliases
| Name |
| :- |
| get_loaded_modules |
# Returns
| Type&emsp;&emsp;&emsp;&emsp;&emsp;&emsp; | Description&emsp;&emsp;&emsp;&emsp;&emsp;&emsp; |
| :-------- | :------- |
| {[ModuleScript](https://create.roblox.com/docs/reference/engine/classes/ModuleScript)} | An array of ModuleScripts. |

# Test requirements
To pass the getloadedmodules test, the function must:
- Return a table.
- Return only ModuleScripts.
- List each module only once.
- Include `PlayerScripts.PlayerModule`.
- Leave out modules that were never required.
- Include a module after it's required.
