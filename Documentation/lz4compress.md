# lz4compress: (Text: string) -> string
Compresses a string with LZ4.
```lua
local Compressed = lz4compress(string.rep("Hello", 100))
print(#Compressed < 500) --> true
```
# Aliases
| Library | Name |
| :- | :- |
| crypt | lz4compress |
| | lz4_compress |
# Parameters
| Text: [string](https://create.roblox.com/docs/luau/strings)&emsp;&emsp;&emsp;&emsp;&emsp;&emsp; | The string to compress.&emsp;&emsp;&emsp;&emsp;&emsp;&emsp; |
| :-------- | :------- |
# Returns
| [string](https://create.roblox.com/docs/luau/strings)&emsp;&emsp;&emsp;&emsp;&emsp;&emsp; | The compressed string.&emsp;&emsp;&emsp;&emsp;&emsp;&emsp; |
| :-------- | :------- |
