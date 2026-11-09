# crypt.generatekey: () -> string
Generates a random 32 byte key for [crypt.encrypt](encrypt.md), encoded in Base64.
```lua
local Key = crypt.generatekey()
print(#base64decode(Key)) --> 32
```
# Returns
| [string](https://create.roblox.com/docs/luau/strings)&emsp;&emsp;&emsp;&emsp;&emsp;&emsp; | The key encoded in Base64.&emsp;&emsp;&emsp;&emsp;&emsp;&emsp; |
| :-------- | :------- |
# Test requirements
To pass the crypt.generatekey test, the function must:
- Return a base64 string that decodes to 32 bytes.
- Return a different key each time.
