# keyrelease: (KeyCode: number) -> ()
Releases a key held down with [keypress](keypress.md). It works even when the Roblox window isn't focused, and never sends input to other windows.
```lua
keypress(0x41)
task.wait(1)
keyrelease(0x41)
```
# Aliases
| Name |
| :- |
| key_release |
# Parameters
| KeyCode: [number](https://create.roblox.com/docs/luau/numbers)&emsp;&emsp;&emsp;&emsp;&emsp;&emsp; | The Windows key code, such as 0x41 for A.&emsp;&emsp;&emsp;&emsp;&emsp;&emsp; |
| :-------- | :------- |

# Test requirements
To pass the keyrelease test, the function must:
- Release a key held down by [keypress](keypress.md), firing an `InputEnded` event that Roblox detects.
- Leave the key no longer held down.
- Reach Roblox even when the Roblox window isn't focused, without sending input to other windows.
