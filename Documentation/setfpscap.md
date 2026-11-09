# setfpscap: (FPSCap: number) -> ()
Sets the frame rate cap, where 0 removes it.
```lua
setfpscap(60)
```
# Aliases
| Name |
| :- |
| set_fps_cap |
# Parameters
| FPSCap: [number](https://create.roblox.com/docs/luau/numbers)&emsp;&emsp;&emsp;&emsp;&emsp;&emsp; | The frame rate cap.&emsp;&emsp;&emsp;&emsp;&emsp;&emsp; |
| :-------- | :------- |

# Test requirements
To pass the setfpscap test, the function must:
- Keep the frame rate at or below the cap it's given, averaged over a second.
