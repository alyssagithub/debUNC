# keypress: (KeyCode: number) -> ()
Presses a key and holds it down until [keyrelease](keyrelease.md) is called. The Roblox window has to be focused.
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
| KeyCode: [number](https://create.roblox.com/docs/luau/numbers)&emsp;&emsp;&emsp;&emsp;&emsp;&emsp; | The Windows key code, such as 0x41 for A.&emsp;&emsp;&emsp;&emsp;&emsp;&emsp; |
| :-------- | :------- |

# Test requirements
To pass the keypress test, the function must:
- Press the key for the given key code (`0x4A` is J) so Roblox detects it.
- Hold the key down until [keyrelease](keyrelease.md) releases it.
