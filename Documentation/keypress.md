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
