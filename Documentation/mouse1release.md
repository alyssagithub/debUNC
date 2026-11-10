# mouse1release: () -> ()
Releases the left mouse button. It works even when the Roblox window isn't focused, and never sends input to other windows.
```lua
mouse1press()
task.wait(1)
mouse1release()
```
# Aliases
| Name |
| :- |
| mouse_1_release |

# Test requirements
To pass the mouse1release test, the function must:
- Release the left mouse button after [mouse1press](mouse1press.md) holds it down, firing an `InputEnded` event that Roblox detects (or a touch, for the left button).
- Leave the left mouse button no longer held down.
- Reach Roblox even when the Roblox window isn't focused, without sending input to other windows.
