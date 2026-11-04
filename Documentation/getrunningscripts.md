# getrunningscripts: () -> {LuaSourceContainer}
Returns every script that's currently running.
```lua
for _, RunningScript in getrunningscripts() do
	print(RunningScript:GetFullName())
end
```
# Aliases
| Library | Name |
| :- | :- |
| | get_running_scripts |
# Returns
| {[LuaSourceContainer](https://create.roblox.com/docs/reference/engine/classes/LuaSourceContainer)}&emsp;&emsp;&emsp;&emsp;&emsp;&emsp; | An array of scripts.&emsp;&emsp;&emsp;&emsp;&emsp;&emsp; |
| :-------- | :------- |
