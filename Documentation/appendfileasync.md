# appendfileasync: (Path: string, Data: string) -> ()
> [!NOTE]
> **Niche**
>
> This function is not widely implemented by executors, so scripts should implement proper handling in the case of an executor being unable to use this.

Adds text to the end of a file without blocking other scripts.
```lua
writefile("Log.txt", "Hello")
appendfileasync("Log.txt", " world!")
```
# Parameters
| Parameter&emsp;&emsp;&emsp;&emsp;&emsp;&emsp; | Description&emsp;&emsp;&emsp;&emsp;&emsp;&emsp; |
| :-------- | :------- |
| Path: [string](https://create.roblox.com/docs/luau/strings) | The path of the file. |
| Data: [string](https://create.roblox.com/docs/luau/strings) | The text to add. |
# Test requirements
To pass the appendfileasync test, the function must:
- Add the text to the end of the file within 2 seconds, without changing what was already in it.
