# hookfunction: (Function: function, Hook: (...any) -> ...any) -> (...any) -> ...any
Replaces a function with another function, and returns a function that still runs the original.
```lua
local function Greet()
	return "Hello"
end

local Original = hookfunction(Greet, function()
	return "Goodbye"
end)

print(Greet()) --> Goodbye
print(Original()) --> Hello
```
# Aliases
| Name |
| :- |
| hook_closure |
| hook_func |
| hook_function |
| hookclosure |
| hookfunc |
| replace_closure |
| replaceclosure |
# Parameters
| Parameter&emsp;&emsp;&emsp;&emsp;&emsp;&emsp; | Description&emsp;&emsp;&emsp;&emsp;&emsp;&emsp; |
| :-------- | :------- |
| Function: [function](https://create.roblox.com/docs/luau/functions) | The function to hook. |
| Hook: (...any) -> ...any | The function to run instead. It's given the same values the original would get, and what it returns is used. |
# Returns
| Type&emsp;&emsp;&emsp;&emsp;&emsp;&emsp; | Description&emsp;&emsp;&emsp;&emsp;&emsp;&emsp; |
| :-------- | :------- |
| (...any) -> ...any | A function that runs the original. Give it the same values you'd give the original. |
# Test requirements
To pass the hookfunction test, the function must:
- Return a function that gives the original result.
- Make the hooked function return the hook's result.
- Restore the function when it's hooked back to the returned original.
- Pass every argument through, including trailing `nil` values, when the hook yields and calls the original.
- Make the original returned by a second hook call the first hook.
- Pass an error object thrown inside a hook to the caller unchanged.
- Error when no hook is given.
- Error when it's given something that isn't a function.
- Hook a LuaClosure with a C function, such as `tick`.
- Hook a LuaClosure with a NewCClosure.
- Hook a C function, such as `tostring`, with another C function, such as `tonumber`.
- Hook a C function, such as `tonumber`, with a LuaClosure.
- Hook a C function, such as `table.create`, with a NewCClosure.
- Hook a NewCClosure with a NewCClosure.
- Hook a NewCClosure with a LuaClosure, and keep it showing as `[C]` in `debug.info`.
- Hook a NewCClosure with a C function, such as `task.wait`.
- Run the hook once per call without also running the original, and return an original that isn't the hooked function itself.
- Pass the hook every argument the hooked function was called with, including `game` for `game.IsLoaded`.
- Keep the hooked function's environment, so `getfenv` from a game script's thread doesn't give the hook's environment.
- Hook and restore `game.IsLoaded`, and work when `game.GetFullName` is used as the hook.
- Keep the hooked function's `tostring` address and `debug.info` name after hooking it with a NewCClosure.
