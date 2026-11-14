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
| Type&emsp;&emsp;&emsp;&emsp;&emsp;&emsp; | Description&emsp;&emsp;&emsp;&emsp;&emsp;&emsp; |
| :-------- | :------- |
| [number](https://create.roblox.com/docs/luau/numbers) | The frame rate cap. |

# Test requirements
To pass the getfpscap test, the function must:
- Return 10 after [setfpscap](setfpscap.md) sets the cap to 10.
- Return the new cap after it's set to another value.
- Return a different value after the cap is set back to 0.
