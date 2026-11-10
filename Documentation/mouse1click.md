# mouse1click: () -> ()
Clicks the left mouse button. It works even when the Roblox window isn't focused, and never sends input to other windows.
```lua
mouse1click()
```
# Aliases
| Name |
| :- |
| mouse_1_click |

# Test requirements
To pass the mouse1click test, the function must:
- Fire a `MouseButton1` input that Roblox detects (or a touch, for the left button).
- Release the left mouse button again, so it isn't left held down.
- Reach Roblox even when the Roblox window isn't focused, without sending input to other windows.
