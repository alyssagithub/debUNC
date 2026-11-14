# debug.setinfo: (Function: function, Info: {name: string?}) -> ()
Changes the information of a function.
```lua
local function Greet() end
debug.setinfo(Greet, {name = "Hello"})
print(debug.info(Greet, "n")) --> Hello
```
# Aliases
| Library | Name |
| :- | :- |
| debug | set_info |
# Parameters
| Parameter&emsp;&emsp;&emsp;&emsp;&emsp;&emsp; | Description&emsp;&emsp;&emsp;&emsp;&emsp;&emsp; |
| :-------- | :------- |
| Function: [function](https://create.roblox.com/docs/luau/functions) | The function to change. |
| Info: <pre>{<br>&nbsp;&nbsp;&nbsp;&nbsp;name: string?,<br>}</pre> | The information to set, such as name. |

# Test requirements
To pass the debug.setinfo test, the function must:
- Change the function's name, so `debug.info` returns the new name.
