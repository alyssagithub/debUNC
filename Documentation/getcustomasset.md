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
| Path: [string](https://create.roblox.com/docs/luau/strings)&emsp;&emsp;&emsp;&emsp;&emsp;&emsp; | The path of the file.&emsp;&emsp;&emsp;&emsp;&emsp;&emsp; |
| :-------- | :------- |
# Returns
| [string](https://create.roblox.com/docs/luau/strings)&emsp;&emsp;&emsp;&emsp;&emsp;&emsp; | The rbxasset:// id.&emsp;&emsp;&emsp;&emsp;&emsp;&emsp; |
| :-------- | :------- |
