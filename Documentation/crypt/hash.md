# crypt.hash: (Text: string, Algorithm: string) -> string
Hashes text with the given algorithm.
```lua
print(crypt.hash("abc", "sha256")) --> ba7816bf8f01cfea414140de5dae2223b00361a396177a9cb410ff61f20015ad
```
# Parameters
| Text: [string](https://create.roblox.com/docs/luau/strings)&emsp;&emsp;&emsp;&emsp;&emsp;&emsp; | The text to hash.&emsp;&emsp;&emsp;&emsp;&emsp;&emsp; |
| :-------- | :------- |
| Algorithm: [string](https://create.roblox.com/docs/luau/strings) | The algorithm to use, such as sha256 or sha384. |
# Returns
| [string](https://create.roblox.com/docs/luau/strings)&emsp;&emsp;&emsp;&emsp;&emsp;&emsp; | The hash in hexadecimal.&emsp;&emsp;&emsp;&emsp;&emsp;&emsp; |
| :-------- | :------- |
