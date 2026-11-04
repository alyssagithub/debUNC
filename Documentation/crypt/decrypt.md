# crypt.decrypt: (Encrypted: string, Key: string, InitializationVector: string) -> string
Decrypts text that was encrypted with [crypt.encrypt](encrypt.md).
```lua
local Key = crypt.generatekey()
local Encrypted, InitializationVector = crypt.encrypt("Hello world!", Key)
print(crypt.decrypt(Encrypted, Key, InitializationVector)) --> Hello world!
```
# Parameters
| Encrypted: [string](https://create.roblox.com/docs/luau/strings)&emsp;&emsp;&emsp;&emsp;&emsp;&emsp; | The encrypted text.&emsp;&emsp;&emsp;&emsp;&emsp;&emsp; |
| :-------- | :------- |
| Key: [string](https://create.roblox.com/docs/luau/strings) | The key it was encrypted with. |
| InitializationVector: [string](https://create.roblox.com/docs/luau/strings) | The initialization vector from crypt.encrypt. |
# Returns
| [string](https://create.roblox.com/docs/luau/strings)&emsp;&emsp;&emsp;&emsp;&emsp;&emsp; | The decrypted text.&emsp;&emsp;&emsp;&emsp;&emsp;&emsp; |
| :-------- | :------- |
