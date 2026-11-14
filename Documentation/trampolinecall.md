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
| Parameter&emsp;&emsp;&emsp;&emsp;&emsp;&emsp; | Description&emsp;&emsp;&emsp;&emsp;&emsp;&emsp; |
| :-------- | :------- |
| Target: [function](https://create.roblox.com/docs/luau/functions) | The function to call. C functions work too. |
| CallStack: [table](https://create.roblox.com/docs/luau/tables) | An array of stack entries, starting from the closest caller. Can be empty. |
| ThreadOptions: [table](https://create.roblox.com/docs/luau/tables) | Details for the call. Can be empty. |
| ...: any | The values to pass to the function. |
# Stack entries
| Field&emsp;&emsp;&emsp;&emsp;&emsp;&emsp; | Description&emsp;&emsp;&emsp;&emsp;&emsp;&emsp; |
| :-------- | :------- |
| func: [function](https://create.roblox.com/docs/luau/functions) | Required. The function to show in the stack. |
| currentline: [number](https://create.roblox.com/docs/luau/numbers) | Required. The line to show. |
# Thread options
| Field&emsp;&emsp;&emsp;&emsp;&emsp;&emsp; | Description&emsp;&emsp;&emsp;&emsp;&emsp;&emsp; |
| :-------- | :------- |
| identity: [number](https://create.roblox.com/docs/luau/numbers) | The identity to run with. |
| script: Instance | The script that `getcallingscript` returns. |
| env: [table](https://create.roblox.com/docs/luau/tables) | The global environment. |
| thread: thread | A thread to copy details from, which also makes `checkcaller` return false. Its environment replaces yours, so store executor functions in locals first. |
# Returns
| Type&emsp;&emsp;&emsp;&emsp;&emsp;&emsp; | Description&emsp;&emsp;&emsp;&emsp;&emsp;&emsp; |
| :-------- | :------- |
| [boolean](https://create.roblox.com/docs/luau/booleans) | Whether the function ran without erroring. |
| ...any | What the function returned, or the error message. |

# Test requirements
To pass the trampolinecall test, the function must:
- Return whether the call worked as its first value, and `true` when the function doesn't error.
- Use the fake call stack it's given, so `debug.info` shows the fake caller's name and line.
- Pass arguments through to the function and return its results.
- Return `false` and the error message when the function errors.
- Run the function with the environment given in the `env` option.
- Run the function at the identity given in the `identity` option, and restore the original identity after the call.
- Run the function on the thread given in the `thread` option, so [checkcaller](checkcaller.md) returns `false` and [getcallingscript](getcallingscript.md) returns that thread's script.
