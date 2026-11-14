# writecustomasset: (Path: string, Data: string) -> string
> [!NOTE]
> **Niche**
>
> This function is not widely implemented by executors, so scripts should implement proper handling in the case of an executor being unable to use this.

Writes a file to the workspace folder and returns an asset id that Roblox can load.
```lua
local ImageLabel = Instance.new("ImageLabel")
ImageLabel.Image = writecustomasset("Image.png", ImageData)
```
# Parameters
| Parameter&emsp;&emsp;&emsp;&emsp;&emsp;&emsp; | Description&emsp;&emsp;&emsp;&emsp;&emsp;&emsp; |
| :-------- | :------- |
| Path: [string](https://create.roblox.com/docs/luau/strings) | The path of the file. |
| Data: [string](https://create.roblox.com/docs/luau/strings) | The file's contents. |
# Returns
| Type&emsp;&emsp;&emsp;&emsp;&emsp;&emsp; | Description&emsp;&emsp;&emsp;&emsp;&emsp;&emsp; |
| :-------- | :------- |
| [string](https://create.roblox.com/docs/luau/strings) | The rbxasset:// id. |

# Test requirements
To pass the writecustomasset test, the function must:
- Write the file it's given.
- Return an `rbxasset://` id for the file.
- Return an id that loads successfully as an asset.
