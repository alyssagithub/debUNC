# mousescroll: (Delta: number) -> ()
Scrolls the mouse wheel. The Roblox window has to be focused.
```lua
mousescroll(120)
```
# Aliases
| Name |
| :- |
| mouse_scroll |
# Parameters
| Delta: [number](https://create.roblox.com/docs/luau/numbers)&emsp;&emsp;&emsp;&emsp;&emsp;&emsp; | How far to scroll, positive for up and negative for down.&emsp;&emsp;&emsp;&emsp;&emsp;&emsp; |
| :-------- | :------- |

# Test requirements
To pass the mousescroll test, the function must:
- Fire a mouse wheel input that scrolls up for a positive amount.
- Fire a mouse wheel input that scrolls down for a negative amount.
