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
| Parameter&emsp;&emsp;&emsp;&emsp;&emsp;&emsp; | Description&emsp;&emsp;&emsp;&emsp;&emsp;&emsp; |
| :-------- | :------- |
| FPSCap: [number](https://create.roblox.com/docs/luau/numbers) | The frame rate cap. |

# Test requirements
To pass the setfpscap test, the function must:
- Keep the frame rate at or below the cap it's given, averaged over a second.
