# saveinstance: () -> string
Saves the game to a file in the workspace folder and returns the file's name.
```lua
local FileName = saveinstance()
print(isfile(FileName)) --> true
```
# Returns
| [string](https://create.roblox.com/docs/luau/strings)&emsp;&emsp;&emsp;&emsp;&emsp;&emsp; | The name of the saved file.&emsp;&emsp;&emsp;&emsp;&emsp;&emsp; |
| :-------- | :------- |
