# getloadedmodules: () -> {ModuleScript}
Returns every ModuleScript that has been required.
```lua
for _, Module in getloadedmodules() do
	print(Module:GetFullName())
end
```
# Aliases
| Library | Name |
| :- | :- |
| | get_loaded_modules |
# Returns
| {[ModuleScript](https://create.roblox.com/docs/reference/engine/classes/ModuleScript)}&emsp;&emsp;&emsp;&emsp;&emsp;&emsp; | An array of ModuleScripts.&emsp;&emsp;&emsp;&emsp;&emsp;&emsp; |
| :-------- | :------- |
