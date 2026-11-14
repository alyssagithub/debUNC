# crypt.decrypt: (Encrypted: string, Key: string, InitializationVector: string) -> string
Decrypts text that was encrypted with [crypt.encrypt](encrypt.md).
```lua
local Key = crypt.generatekey()
local Encrypted, InitializationVector = crypt.encrypt("Hello world!", Key)
print(crypt.decrypt(Encrypted, Key, InitializationVector)) --> Hello world!
```
# Parameters
| Parameter&emsp;&emsp;&emsp;&emsp;&emsp;&emsp; | Description&emsp;&emsp;&emsp;&emsp;&emsp;&emsp; |
| :-------- | :------- |
| Encrypted: [string](https://create.roblox.com/docs/luau/strings) | The encrypted text. |
| Key: [string](https://create.roblox.com/docs/luau/strings) | The key it was encrypted with. |
| InitializationVector: [string](https://create.roblox.com/docs/luau/strings) | The initialization vector from crypt.encrypt. |
# Returns
| Type&emsp;&emsp;&emsp;&emsp;&emsp;&emsp; | Description&emsp;&emsp;&emsp;&emsp;&emsp;&emsp; |
| :-------- | :------- |
| [string](https://create.roblox.com/docs/luau/strings) | The decrypted text. |
# Test requirements
To pass the crypt.decrypt test, the function must:
- Give back the original text for random strings of 1 to 64 bytes encrypted with [crypt.encrypt](encrypt.md).
- Fail to give back the original text when it's given the wrong key.
- Decrypt the published AES-256 CTR test vector correctly.
