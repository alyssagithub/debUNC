# mousescroll: (Delta: number) -> ()
Scrolls the mouse wheel. It works even when the Roblox window isn't focused, and never sends input to other windows.
```lua
mousescroll(120)
```
# Aliases
| Name |
| :- |
| mouse_scroll |
# Parameters
| Parameter&emsp;&emsp;&emsp;&emsp;&emsp;&emsp; | Description&emsp;&emsp;&emsp;&emsp;&emsp;&emsp; |
| :-------- | :------- |
| Delta: [number](https://create.roblox.com/docs/luau/numbers) | How far to scroll, positive for up and negative for down. |

# Test requirements
To pass the mousescroll test, the function must:
- Fire a mouse wheel input that scrolls up for a positive amount, and none that scroll down.
- Fire a mouse wheel input that scrolls down for a negative amount, and none that scroll up.
- Reach Roblox even when the Roblox window isn't focused, without sending input to other windows.
