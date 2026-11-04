# crypt.encrypt: (Text: string, Key: string) -> (string, string)
Encrypts text with a key. Each call makes a new random initialization vector, which you need to decrypt the text.
```lua
local Key = crypt.generatekey()
local Encrypted, InitializationVector = crypt.encrypt("Hello world!", Key)
```
# Parameters
| Text: [string](https://create.roblox.com/docs/luau/strings)&emsp;&emsp;&emsp;&emsp;&emsp;&emsp; | The text to encrypt.&emsp;&emsp;&emsp;&emsp;&emsp;&emsp; |
| :-------- | :------- |
| Key: [string](https://create.roblox.com/docs/luau/strings) | The key from crypt.generatekey. |
# Returns
| [string](https://create.roblox.com/docs/luau/strings)&emsp;&emsp;&emsp;&emsp;&emsp;&emsp; | The encrypted text.&emsp;&emsp;&emsp;&emsp;&emsp;&emsp; |
| :-------- | :------- |
| [string](https://create.roblox.com/docs/luau/strings) | The initialization vector, which you need to decrypt the text. |
