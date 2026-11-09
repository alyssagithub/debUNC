# keyclick: (KeyCode: number) -> ()
Presses and releases a key. The Roblox window has to be focused.
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
| KeyCode: [number](https://create.roblox.com/docs/luau/numbers)&emsp;&emsp;&emsp;&emsp;&emsp;&emsp; | The Windows key code, such as 0x41 for A.&emsp;&emsp;&emsp;&emsp;&emsp;&emsp; |
| :-------- | :------- |

# Test requirements
To pass the keyclick test, the function must:
- Press the key for the given key code (`0x4A` is J) so Roblox detects it.
- Release the key again, so it isn't left held down.
