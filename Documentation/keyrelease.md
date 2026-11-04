# keyrelease: (KeyCode: number) -> ()
Releases a key held down with [keypress](keypress.md). The Roblox window has to be focused.
```lua
keypress(0x41)
task.wait(1)
keyrelease(0x41)
```
# Aliases
| Library | Name |
| :- | :- |
| | key_release |
# Parameters
| KeyCode: [number](https://create.roblox.com/docs/luau/numbers)&emsp;&emsp;&emsp;&emsp;&emsp;&emsp; | The Windows key code, such as 0x41 for A.&emsp;&emsp;&emsp;&emsp;&emsp;&emsp; |
| :-------- | :------- |
