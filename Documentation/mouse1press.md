# mouse1press: () -> ()
Presses the left mouse button and holds it down until [mouse1release](mouse1release.md) is called. It works even when the Roblox window isn't focused, and never sends input to other windows.
```lua
mouse1press()
task.wait(1)
mouse1release()
```
# Aliases
| Name |
| :- |
| mouse_1_press |

# Test requirements
To pass the mouse1press test, the function must:
- Fire a `MouseButton1` input that Roblox detects (or a touch, for the left button).
- Hold the left mouse button down until [mouse1release](mouse1release.md) releases it.
- Reach Roblox even when the Roblox window isn't focused, without sending input to other windows.
