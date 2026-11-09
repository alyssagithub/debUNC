# gethui: () -> Instance
Returns a container for GUIs that the game can't easily find.
```lua
local ScreenGui = Instance.new("ScreenGui")
ScreenGui.Parent = gethui()
```
# Aliases
| Name |
| :- |
| get_hidden_gui |
| get_hui |
| gethiddengui |
# Returns
| [Instance](https://create.roblox.com/docs/reference/engine/classes/Instance)&emsp;&emsp;&emsp;&emsp;&emsp;&emsp; | The hidden container.&emsp;&emsp;&emsp;&emsp;&emsp;&emsp; |
| :-------- | :------- |

# Test requirements
To pass the gethui test, the function must:
- Return a container a ScreenGui can be parented to.
- Return a container that isn't inside `PlayerGui`, where games can see it.
