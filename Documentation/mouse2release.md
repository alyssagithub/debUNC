# mouse2release: () -> ()
Releases the right mouse button. The Roblox window has to be focused.
```lua
mouse2press()
task.wait(1)
mouse2release()
```
# Aliases
| Name |
| :- |
| mouse_2_release |

# Test requirements
To pass the mouse2release test, the function must:
- Release the right mouse button after [mouse2press](mouse2press.md) holds it down, firing an `InputEnded` event that Roblox detects.
- Leave the right mouse button no longer held down.
