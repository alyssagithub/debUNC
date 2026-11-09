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

# Test requirements
To pass the lz4compress test, the function must:
- Compress `"debUNC"` to ``"`debUNC"``.
- Shrink a string that repeats 100 times to less than a quarter of its size.
- Return data that [lz4decompress](lz4decompress.md) turns back into the original string.
