# keyclick: (KeyCode: number) -> ()
Presses and releases a key. It works even when the Roblox window isn't focused, and never sends input to other windows.
```lua
keyclick(0x41)
```
# Aliases
| Name |
| :- |
| key_click |
| key_tap |
| keytap |
# Parameters
| Parameter&emsp;&emsp;&emsp;&emsp;&emsp;&emsp; | Description&emsp;&emsp;&emsp;&emsp;&emsp;&emsp; |
| :-------- | :------- |
| KeyCode: [number](https://create.roblox.com/docs/luau/numbers) | The Windows key code, such as 0x41 for A. |

# Test requirements
To pass the keyclick test, the function must:
- Press the key for the given key code (`0x7C` is F13) so Roblox detects it.
- Release the key again, so it isn't left held down.
- Reach Roblox even when the Roblox window isn't focused, without sending input to other windows.
