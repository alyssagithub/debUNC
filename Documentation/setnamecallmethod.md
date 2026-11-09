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
| Name |
| :- |
| set_namecall_method |
# Parameters
| Method: [string](https://create.roblox.com/docs/luau/strings)&emsp;&emsp;&emsp;&emsp;&emsp;&emsp; | The new method name.&emsp;&emsp;&emsp;&emsp;&emsp;&emsp; |
| :-------- | :------- |

# Test requirements
To pass the setnamecallmethod test, the function must:
- Change the namecall method inside a `__namecall` call, so [getnamecallmethod](getnamecallmethod.md) returns the new method.
- Change the method used when game's `__namecall` is called directly, so setting it to `GetFullName` returns the same result as `game:GetFullName()`.
