# setnamecallmethod: (Method: string) -> ()
Changes the method name that [getnamecallmethod](getnamecallmethod.md) returns.
```lua
local Proxy = newproxy(true)

getmetatable(Proxy).__namecall = function()
	setnamecallmethod("Changed")
	print(getnamecallmethod()) --> Changed
end

Proxy:Original()
```
# Aliases
| Library | Name |
| :- | :- |
| | set_namecall_method |
# Parameters
| Method: [string](https://create.roblox.com/docs/luau/strings)&emsp;&emsp;&emsp;&emsp;&emsp;&emsp; | The new method name.&emsp;&emsp;&emsp;&emsp;&emsp;&emsp; |
| :-------- | :------- |
