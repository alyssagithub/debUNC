# getfilesize: (Path: string) -> number
> [!NOTE]
> **Niche**
>
> This function is not widely implemented by executors, so scripts should implement proper handling in the case of an executor being unable to use this.

Returns the size of a file in the workspace folder in bytes. It's much faster than `#readfile(Path)` on big files, and errors if the file doesn't exist.
```lua
writefile("Log.txt", "Hello")
print(getfilesize("Log.txt")) --> 5
```
# Parameters
| Parameter&emsp;&emsp;&emsp;&emsp;&emsp;&emsp; | Description&emsp;&emsp;&emsp;&emsp;&emsp;&emsp; |
| :-------- | :------- |
| Path: [string](https://create.roblox.com/docs/luau/strings) | The path of the file. |
# Returns
| Type&emsp;&emsp;&emsp;&emsp;&emsp;&emsp; | Description&emsp;&emsp;&emsp;&emsp;&emsp;&emsp; |
| :-------- | :------- |
| [number](https://create.roblox.com/docs/luau/numbers) | The file's size in bytes. |

# Test requirements
To pass the getfilesize test, the function must:
- Return the file's size in bytes.
