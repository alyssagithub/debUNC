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
| Parameter&emsp;&emsp;&emsp;&emsp;&emsp;&emsp; | Description&emsp;&emsp;&emsp;&emsp;&emsp;&emsp; |
| :-------- | :------- |
| Compressed: [string](https://create.roblox.com/docs/luau/strings) | The compressed string. |
| Size: [number](https://create.roblox.com/docs/luau/numbers) | The size of the original string. |
# Returns
| Type&emsp;&emsp;&emsp;&emsp;&emsp;&emsp; | Description&emsp;&emsp;&emsp;&emsp;&emsp;&emsp; |
| :-------- | :------- |
| [string](https://create.roblox.com/docs/luau/strings) | The decompressed string. |

# Test requirements
To pass the lz4decompress test, the function must:
- Decompress ``"`debUNC"`` to `"debUNC"`.
- Decompress a known block that uses a back reference to 20 copies of `"a"`.
- Return the original string for random data compressed with [lz4compress](lz4compress.md).
- Keep every byte from 0 to 255 the same after compressing and decompressing.
