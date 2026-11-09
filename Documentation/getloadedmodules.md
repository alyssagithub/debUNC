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
| {[ModuleScript](https://create.roblox.com/docs/reference/engine/classes/ModuleScript)}&emsp;&emsp;&emsp;&emsp;&emsp;&emsp; | An array of ModuleScripts.&emsp;&emsp;&emsp;&emsp;&emsp;&emsp; |
| :-------- | :------- |

# Test requirements
To pass the getloadedmodules test, the function must:
- Return a table.
- Return only ModuleScripts.
- List each module only once.
- Leave out `StarterPlayerScripts.PlayerModule`.
- Include `PlayerScripts.PlayerModule`.
- Leave out modules that were never required.
