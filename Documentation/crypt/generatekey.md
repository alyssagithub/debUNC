# crypt.generatekey: () -> string
Generates a random 32 byte key for [crypt.encrypt](encrypt.md), encoded in Base64.
```lua
local Key = crypt.generatekey()
print(#base64decode(Key)) --> 32
```
# Returns
| Type&emsp;&emsp;&emsp;&emsp;&emsp;&emsp; | Description&emsp;&emsp;&emsp;&emsp;&emsp;&emsp; |
| :-------- | :------- |
| [string](https://create.roblox.com/docs/luau/strings) | The key encoded in Base64. |
# Test requirements
To pass the crypt.generatekey test, the function must:
- Return a base64 string that decodes to 32 bytes.
- Return a different key each time, over 32 keys.
- Return random bytes, not the same byte over and over or a counter.
