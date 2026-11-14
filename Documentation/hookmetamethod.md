# hookmetamethod: (Object: userdata | table, Metamethod: string, Hook: (...any) -> ...any) -> (...any) -> ...any
Replaces a metamethod, and returns a function that still runs the original.
```lua
local Original
Original = hookmetamethod(game, "__index", function(...)
	return Original(...)
end)
```
# Aliases
| Name |
| :- |
| hook_meta_method |
# Parameters
| Parameter&emsp;&emsp;&emsp;&emsp;&emsp;&emsp; | Description&emsp;&emsp;&emsp;&emsp;&emsp;&emsp; |
| :-------- | :------- |
| Object: userdata \| table | The object with the metamethod. |
| Metamethod: [string](https://create.roblox.com/docs/luau/strings) | The name of the metamethod. |
| Hook: (...any) -> ...any | The function to run instead. It's given the same values the original would get, and what it returns is used. |
# Returns
| Type&emsp;&emsp;&emsp;&emsp;&emsp;&emsp; | Description&emsp;&emsp;&emsp;&emsp;&emsp;&emsp; |
| :-------- | :------- |
| (...any) -> ...any | A function that runs the original. Give it the same values you'd give the original. |
# Test requirements
To pass the hookmetamethod test, the function must:
- Return the original metamethod function.
- Make the object return the hook's result.
- Replace only the metamethod's proto, so the metatable keeps the same function.
- Undo the hook when the metamethod is hooked back to the returned original.
- Catch a `game:GetService` call made by the executor when `game`'s `__namecall` is hooked, with [getnamecallmethod](getnamecallmethod.md) giving `GetService`.
- Return the right result from `game:GetService` while the hook calls the original.
- Give the same errors as before for bad calls to `game`'s captured `__index` and `__namecall`, without running the hook for them, when called from a game script's thread.
- Keep the `__namecall` hook from being found on the stack from an error handler.
- Let `WaitForChild` yield through a hooked `__namecall`.
