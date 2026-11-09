# writefileasync: (Path: string, Data: string) -> ()
Writes text to a file without blocking other scripts.
```lua
writefileasync("Log.txt", "Hello world!")
```
# Parameters
| Path: [string](https://create.roblox.com/docs/luau/strings)&emsp;&emsp;&emsp;&emsp;&emsp;&emsp; | The path of the file.&emsp;&emsp;&emsp;&emsp;&emsp;&emsp; |
| :-------- | :------- |
| Data: [string](https://create.roblox.com/docs/luau/strings) | The text to write. |

# Test requirements
To pass the writefileasync test, the function must:
- Run in the background instead of blocking until it finishes.
- Finish within 5 seconds without erroring.
- Write the text so [readfile](readfile.md) returns it within 2 seconds.
