# saveinstance: () -> string
Saves the game to a file in the workspace folder and returns the file's name.
```lua
local FileName = saveinstance()
print(isfile(FileName)) --> true
```
# Returns
| [string](https://create.roblox.com/docs/luau/strings)&emsp;&emsp;&emsp;&emsp;&emsp;&emsp; | The name of the saved file.&emsp;&emsp;&emsp;&emsp;&emsp;&emsp; |
| :-------- | :------- |

# Test requirements
To pass the saveinstance test, the function must:
- Return the saved file's name as a string.
- Save the place to a file that exists.
- Write more than 1,000 bytes to the file, so it holds the place.
- Start the file with a `<roblox` header.
- Save a folder that was just added to workspace, so the file holds the current game. This isn't checked for binary place files.
