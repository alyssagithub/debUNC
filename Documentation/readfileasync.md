# readfileasync: (Path: string) -> string
> [!NOTE]
> **Niche**
>
> This function is not widely implemented by executors, so scripts should implement proper handling in the case of an executor being unable to use this.

Returns the contents of a file without blocking other scripts.
```lua
writefile("Log.txt", "Hello world!")
print(readfileasync("Log.txt")) --> Hello world!
```
# Parameters
| Parameter&emsp;&emsp;&emsp;&emsp;&emsp;&emsp; | Description&emsp;&emsp;&emsp;&emsp;&emsp;&emsp; |
| :-------- | :------- |
| Path: [string](https://create.roblox.com/docs/luau/strings) | The path of the file. |
# Returns
| Type&emsp;&emsp;&emsp;&emsp;&emsp;&emsp; | Description&emsp;&emsp;&emsp;&emsp;&emsp;&emsp; |
| :-------- | :------- |
| [string](https://create.roblox.com/docs/luau/strings) | The file's contents. |

# Test requirements
To pass the readfileasync test, the function must:
- Run in the background instead of blocking until it finishes.
- Finish within 5 seconds without erroring.
- Return the file's text.
