# gethwid: () -> string
Returns an identifier unique to the current hardware.
```lua
local HWID = gethwid()
print(HWID)
```
# Aliases
| Name |
| :- |
| get_hwid |
# Returns
| Type&emsp;&emsp;&emsp;&emsp;&emsp;&emsp; | Description&emsp;&emsp;&emsp;&emsp;&emsp;&emsp; |
| :-------- | :------- |
| [string](https://create.roblox.com/docs/luau/strings) | The hardware's identifier. |

# Test requirements
To pass the gethwid test, the function must:
- Return a string.
- Return a value that isn't empty.
- Return the same value every time it's called.
- Match the fingerprint header that [request](request.md) sends.
