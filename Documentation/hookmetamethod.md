# hookmetamethod: (Object: any, Metamethod: string, Hook: (...any) -> ...any) -> (...any) -> ...any
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
| Object: any&emsp;&emsp;&emsp;&emsp;&emsp;&emsp; | The object with the metamethod.&emsp;&emsp;&emsp;&emsp;&emsp;&emsp; |
| :-------- | :------- |
| Metamethod: [string](https://create.roblox.com/docs/luau/strings) | The name of the metamethod. |
| Hook: (...any) -> ...any | The function to run instead. It's given the same values the original would get, and what it returns is used. |
# Returns
| (...any) -> ...any&emsp;&emsp;&emsp;&emsp;&emsp;&emsp; | A function that runs the original. Give it the same values you'd give the original.&emsp;&emsp;&emsp;&emsp;&emsp;&emsp; |
| :-------- | :------- |
