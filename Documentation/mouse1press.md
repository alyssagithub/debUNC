# mouse1press: () -> ()
Presses the left mouse button and holds it down until [mouse1release](mouse1release.md) is called. The Roblox window has to be focused.
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
