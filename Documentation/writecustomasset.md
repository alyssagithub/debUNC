# writecustomasset: (Path: string, Data: string) -> string
Writes a file to the workspace folder and returns an asset id that Roblox can load.
```lua
local ImageLabel = Instance.new("ImageLabel")
ImageLabel.Image = writecustomasset("Image.png", ImageData)
```
# Parameters
| Path: [string](https://create.roblox.com/docs/luau/strings)&emsp;&emsp;&emsp;&emsp;&emsp;&emsp; | The path of the file.&emsp;&emsp;&emsp;&emsp;&emsp;&emsp; |
| :-------- | :------- |
| Data: [string](https://create.roblox.com/docs/luau/strings) | The file's contents. |
# Returns
| [string](https://create.roblox.com/docs/luau/strings)&emsp;&emsp;&emsp;&emsp;&emsp;&emsp; | The rbxasset:// id.&emsp;&emsp;&emsp;&emsp;&emsp;&emsp; |
| :-------- | :------- |

# Test requirements
To pass the writecustomasset test, the function must:
- Write the file it's given.
- Return an `rbxasset://` id for the file.
- Return an id that loads successfully as an asset.
