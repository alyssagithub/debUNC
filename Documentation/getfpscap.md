# getfpscap: () -> number
Returns the current frame rate cap.
```lua
setfpscap(60)
print(getfpscap()) --> 60
```
# Aliases
| Name |
| :- |
| get_fps_cap |
# Returns
| [number](https://create.roblox.com/docs/luau/numbers)&emsp;&emsp;&emsp;&emsp;&emsp;&emsp; | The frame rate cap.&emsp;&emsp;&emsp;&emsp;&emsp;&emsp; |
| :-------- | :------- |

# Test requirements
To pass the getfpscap test, the function must:
- Return 10 after [setfpscap](setfpscap.md) sets the cap to 10.
- Return a different value after the cap is set back to 0.
