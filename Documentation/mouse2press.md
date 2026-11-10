# mouse2press: () -> ()
Presses the right mouse button and holds it down until [mouse2release](mouse2release.md) is called. It works even when the Roblox window isn't focused, and never sends input to other windows.
```lua
mouse2press()
task.wait(1)
mouse2release()
```
# Aliases
| Name |
| :- |
| mouse_2_press |

# Test requirements
To pass the mouse2press test, the function must:
- Fire a `MouseButton2` input that Roblox detects.
- Hold the right mouse button down until [mouse2release](mouse2release.md) releases it.
- Reach Roblox even when the Roblox window isn't focused, without sending input to other windows.
