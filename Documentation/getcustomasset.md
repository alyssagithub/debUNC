# getcustomasset: (Path: string) -> string
Turns a file in the workspace folder into an asset id that Roblox can load.
```lua
local ImageLabel = Instance.new("ImageLabel")
ImageLabel.Image = getcustomasset("Image.png")
```
# Aliases
| Name |
| :- |
| get_custom_asset |
# Parameters
| Parameter&emsp;&emsp;&emsp;&emsp;&emsp;&emsp; | Description&emsp;&emsp;&emsp;&emsp;&emsp;&emsp; |
| :-------- | :------- |
| Path: [string](https://create.roblox.com/docs/luau/strings) | The path of the file. |
# Returns
| Type&emsp;&emsp;&emsp;&emsp;&emsp;&emsp; | Description&emsp;&emsp;&emsp;&emsp;&emsp;&emsp; |
| :-------- | :------- |
| [string](https://create.roblox.com/docs/luau/strings) | The rbxasset:// id. |

# Test requirements
To pass the getcustomasset test, the function must:
- Return an asset id without erroring.
- Return a string.
- Return an id that starts with `rbxasset://`.
- Return an id that loads successfully for an image file.
