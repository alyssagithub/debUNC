# writefileasync: (Path: string, Data: string) -> ()
> [!NOTE]
> **Niche**
>
> This function is not widely implemented by executors, so scripts should implement proper handling in the case of an executor being unable to use this.

Writes text to a file without blocking other scripts.
```lua
writefileasync("Log.txt", "Hello world!")
```
# Parameters
| Parameter&emsp;&emsp;&emsp;&emsp;&emsp;&emsp; | Description&emsp;&emsp;&emsp;&emsp;&emsp;&emsp; |
| :-------- | :------- |
| Path: [string](https://create.roblox.com/docs/luau/strings) | The path of the file. |
| Data: [string](https://create.roblox.com/docs/luau/strings) | The text to write. |

# Test requirements
To pass the writefileasync test, the function must:
- Run in the background instead of blocking until it finishes.
- Finish within 5 seconds without erroring.
- Write the text so [readfile](readfile.md) returns it within 2 seconds.
