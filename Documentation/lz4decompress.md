# lz4decompress: (Compressed: string, Size: number) -> string
Decompresses a string compressed with LZ4.
```lua
local Text = string.rep("Hello", 100)
print(lz4decompress(lz4compress(Text), #Text) == Text) --> true
```
# Aliases
| Library | Name |
| :- | :- |
| crypt | lz4decompress |
| | lz4_decompress |
# Parameters
| Compressed: [string](https://create.roblox.com/docs/luau/strings)&emsp;&emsp;&emsp;&emsp;&emsp;&emsp; | The compressed string.&emsp;&emsp;&emsp;&emsp;&emsp;&emsp; |
| :-------- | :------- |
| Size: [number](https://create.roblox.com/docs/luau/numbers) | The size of the original string. |
# Returns
| [string](https://create.roblox.com/docs/luau/strings)&emsp;&emsp;&emsp;&emsp;&emsp;&emsp; | The decompressed string.&emsp;&emsp;&emsp;&emsp;&emsp;&emsp; |
| :-------- | :------- |
