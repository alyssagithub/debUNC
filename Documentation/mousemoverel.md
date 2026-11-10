# mousemoverel: (X: number, Y: number) -> ()
Moves the mouse a set distance from where it is. It works even when the Roblox window isn't focused, and never sends input to other windows.
```lua
mousemoverel(25, 25)
```
# Aliases
| Name |
| :- |
| mouse_move_rel |
# Parameters
| X: [number](https://create.roblox.com/docs/luau/numbers)&emsp;&emsp;&emsp;&emsp;&emsp;&emsp; | How far to move on the X axis.&emsp;&emsp;&emsp;&emsp;&emsp;&emsp; |
| :-------- | :------- |
| Y: [number](https://create.roblox.com/docs/luau/numbers) | How far to move on the Y axis. |

# Test requirements
To pass the mousemoverel test, the function must:
- Move the mouse by the given amount from where it is, the same amount on both axes.
- Move it twice as far when the amount is doubled.
- Reach Roblox even when the Roblox window isn't focused, without sending input to other windows.
