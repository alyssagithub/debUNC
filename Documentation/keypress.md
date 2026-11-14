# keypress: (KeyCode: number) -> ()
Presses a key and holds it down until [keyrelease](keyrelease.md) is called. It works even when the Roblox window isn't focused, and never sends input to other windows.
```lua
keypress(0x41)
task.wait(1)
keyrelease(0x41)
```
# Aliases
| Name |
| :- |
| key_press |
# Parameters
| Parameter&emsp;&emsp;&emsp;&emsp;&emsp;&emsp; | Description&emsp;&emsp;&emsp;&emsp;&emsp;&emsp; |
| :-------- | :------- |
| KeyCode: [number](https://create.roblox.com/docs/luau/numbers) | The Windows key code, such as 0x41 for A. |

# Test requirements
To pass the keypress test, the function must:
- Press the key for the given key code (`0x7C` is F13) so Roblox detects it.
- Hold the key down until [keyrelease](keyrelease.md) releases it.
- Reach Roblox even when the Roblox window isn't focused, without sending input to other windows.
