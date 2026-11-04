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
| Function: [function](https://create.roblox.com/docs/luau/functions)&emsp;&emsp;&emsp;&emsp;&emsp;&emsp; | The function to change.&emsp;&emsp;&emsp;&emsp;&emsp;&emsp; |
| :-------- | :------- |
| Info: <pre>{<br>&nbsp;&nbsp;&nbsp;&nbsp;name: string?,<br>}</pre> | The information to set, such as name. |
