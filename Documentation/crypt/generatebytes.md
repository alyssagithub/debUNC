# crypt.generatebytes: (Length: number) -> string
Generates random bytes, encoded in Base64.
```lua
local Bytes = crypt.generatebytes(16)
print(#base64decode(Bytes)) --> 16
```
# Parameters
| Length: [number](https://create.roblox.com/docs/luau/numbers)&emsp;&emsp;&emsp;&emsp;&emsp;&emsp; | The number of bytes to generate.&emsp;&emsp;&emsp;&emsp;&emsp;&emsp; |
| :-------- | :------- |
# Returns
| [string](https://create.roblox.com/docs/luau/strings)&emsp;&emsp;&emsp;&emsp;&emsp;&emsp; | The bytes encoded in Base64.&emsp;&emsp;&emsp;&emsp;&emsp;&emsp; |
| :-------- | :------- |
# Test requirements
To pass the crypt.generatebytes test, the function must:
- Return a base64 string that decodes to the requested number of bytes.
