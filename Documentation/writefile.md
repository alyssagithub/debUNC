# writefile: (Path: string, Data: string) -> ()
Writes text to a file in the workspace folder, replacing what's already in it.
```lua
writefile("Log.txt", "Hello world!")
print(readfile("Log.txt")) --> Hello world!
```
# Aliases
| Name |
| :- |
| write_file |
# Parameters
| Path: [string](https://create.roblox.com/docs/luau/strings)&emsp;&emsp;&emsp;&emsp;&emsp;&emsp; | The path of the file.&emsp;&emsp;&emsp;&emsp;&emsp;&emsp; |
| :-------- | :------- |
| Data: [string](https://create.roblox.com/docs/luau/strings) | The text to write. |

# Test requirements
To pass the writefile test, the function must:
- Write the exact text it's given, including null characters, so [readfile](readfile.md) returns it.
- Write a 1 MB file of random bytes that reads back unchanged.
- Write every byte from 0 to 255 and `\r\n` line endings without changing them.
- Replace the whole file when it writes shorter text over longer text.
