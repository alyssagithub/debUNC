# mousemoveabs: (X: number, Y: number) -> ()
Moves the mouse to a position in the Roblox window. The Roblox window has to be focused.
```lua
mousemoveabs(100, 100)
```
# Aliases
| Name |
| :- |
| mouse_move_abs |
# Parameters
| X: [number](https://create.roblox.com/docs/luau/numbers)&emsp;&emsp;&emsp;&emsp;&emsp;&emsp; | The X position.&emsp;&emsp;&emsp;&emsp;&emsp;&emsp; |
| :-------- | :------- |
| Y: [number](https://create.roblox.com/docs/luau/numbers) | The Y position. |

# Test requirements
To pass the mousemoveabs test, the function must:
- Move the mouse to the given screen position, with movement that scales the same on both axes.
- Place the mouse within 2 pixels of where the target position should be.
