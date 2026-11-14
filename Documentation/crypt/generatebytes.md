# crypt.generatebytes: (Length: number) -> string
Generates random bytes, encoded in Base64.
```lua
local Bytes = crypt.generatebytes(16)
print(#base64decode(Bytes)) --> 16
```
# Parameters
| Parameter&emsp;&emsp;&emsp;&emsp;&emsp;&emsp; | Description&emsp;&emsp;&emsp;&emsp;&emsp;&emsp; |
| :-------- | :------- |
| Length: [number](https://create.roblox.com/docs/luau/numbers) | The number of bytes to generate. |
# Returns
| Type&emsp;&emsp;&emsp;&emsp;&emsp;&emsp; | Description&emsp;&emsp;&emsp;&emsp;&emsp;&emsp; |
| :-------- | :------- |
| [string](https://create.roblox.com/docs/luau/strings) | The bytes encoded in Base64. |
# Test requirements
To pass the crypt.generatebytes test, the function must:
- Return a base64 string that decodes to the requested number of bytes.
- Return different bytes each time, over 32 calls.
- Return random bytes, not the same byte over and over or a counter.
