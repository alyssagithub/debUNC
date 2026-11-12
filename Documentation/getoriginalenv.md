# getoriginalenv: (Object: (userdata | table)?) -> {[string]: any} | userdata | table
Returns a frozen environment with every function as it originally was, even if it was hooked or replaced. Passing an object or metatable returns it with its original metatable and methods.
```lua
local Original
Original = hookmetamethod(game, "__namecall", function(Self, ...)
	if getnamecallmethod() == "HttpGet" then
		print("Spied on", ...)
	end

	return Original(Self, ...)
end)

game:HttpGet("https://example.com") --> Spied on https://example.com
getoriginalenv(game):HttpGet("https://example.com") --> (nothing printed)
```
# Parameters
| Object: (userdata \| table)?&emsp;&emsp;&emsp;&emsp;&emsp;&emsp; | An object or table to get with its original metatable and methods. Leave it out to get the original environment.&emsp;&emsp;&emsp;&emsp;&emsp;&emsp; |
| :-------- | :------- |
# Returns
| {[string]: any} \| userdata \| table&emsp;&emsp;&emsp;&emsp;&emsp;&emsp; | The original environment, or the object with its original metatable and methods.&emsp;&emsp;&emsp;&emsp;&emsp;&emsp; |
| :-------- | :------- |

# Test requirements
To pass the getoriginalenv test, the function must:
- Return a table that includes the standard globals, like `loadstring`, `game` and `string`.
- Return a frozen table, so nothing in it, including library tables like `string`, can be changed.
- Not be hookable, and not let the functions in it be hooked.
- Not be replaceable in `getgenv()`.
- Give the original `identifyexecutor` after it's hooked or replaced, and the original `string.rep` after it's hooked.
- Let `isfunctionhooked` from it see that `identifyexecutor` was hooked.
- Return an object whose methods and properties skip a hooked `__namecall` and `__index`, including on objects indexed from it.
- Return Instances when indexing children of the object, like `Workspace`.
- Return an object whose methods skip a method hooked with `hookfunction`, like `GetService`.
- Return a table's original metamethods when given a table whose metatable was hooked.
- Error when given something that isn't an object or table.
