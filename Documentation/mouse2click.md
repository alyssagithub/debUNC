# mouse2click: () -> ()
Clicks the right mouse button. It works even when the Roblox window isn't focused, and never sends input to other windows.
```lua
mouse2click()
```
# Aliases
| Name |
| :- |
| mouse_2_click |

# Test requirements
To pass the mouse2click test, the function must:
- Fire a `MouseButton2` input that Roblox detects.
- Release the right mouse button again, so it isn't left held down.
- Reach Roblox even when the Roblox window isn't focused, without sending input to other windows.
