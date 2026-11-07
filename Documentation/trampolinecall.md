# trampolinecall: (Target: function, CallStack: table, ThreadOptions: table, ...any) -> (boolean, ...any)
Calls a function with a fake call stack and thread details, so it looks like something else called it. The real callers are hidden, and the current thread's identity isn't changed.
```lua
local Player = game:GetService("Players").LocalPlayer
local Animate = Player.Character.Animate
local GetIdentity = getthreadidentity
local GetCallingScript = getcallingscript
local CheckCaller = checkcaller

local function Target(Text)
	print(Text, GetIdentity(), GetCallingScript(), CheckCaller())
	return "Done"
end

print(trampolinecall(Target, {}, {thread = getscriptthread(Animate)}, "Hello"))
--> Hello 2 Animate false
--> true Done
```
# Aliases
| Library | Name |
| :- | :- |
| | trampoline_call |
| syn | trampoline_call |
# Parameters
| Target: [function](https://create.roblox.com/docs/luau/functions)&emsp;&emsp;&emsp;&emsp;&emsp;&emsp; | The function to call. C functions work too.&emsp;&emsp;&emsp;&emsp;&emsp;&emsp; |
| :-------- | :------- |
| CallStack: [table](https://create.roblox.com/docs/luau/tables) | An array of stack entries, starting from the closest caller. Can be empty. |
| ThreadOptions: [table](https://create.roblox.com/docs/luau/tables) | Details for the call. Can be empty. |
| ...: any | The values to pass to the function. |
# Stack entries
| func: [function](https://create.roblox.com/docs/luau/functions)&emsp;&emsp;&emsp;&emsp;&emsp;&emsp; | Required. The function to show in the stack.&emsp;&emsp;&emsp;&emsp;&emsp;&emsp; |
| :-------- | :------- |
| currentline: [number](https://create.roblox.com/docs/luau/numbers) | Required. The line to show. |
# Thread options
| identity: [number](https://create.roblox.com/docs/luau/numbers)&emsp;&emsp;&emsp;&emsp;&emsp;&emsp; | The identity to run with.&emsp;&emsp;&emsp;&emsp;&emsp;&emsp; |
| :-------- | :------- |
| script: Instance | The script that `getcallingscript` returns. |
| env: [table](https://create.roblox.com/docs/luau/tables) | The global environment. |
| thread: thread | A thread to copy details from, which also makes `checkcaller` return false. Its environment replaces yours, so store executor functions in locals first. |
# Returns
| [boolean](https://create.roblox.com/docs/luau/booleans)&emsp;&emsp;&emsp;&emsp;&emsp;&emsp; | Whether the function ran without erroring.&emsp;&emsp;&emsp;&emsp;&emsp;&emsp; |
| :-------- | :------- |
| ...any | What the function returned, or the error message. |
