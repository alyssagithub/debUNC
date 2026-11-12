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
# Test requirements
To pass the crypt.encrypt test, the function must:
- Return encrypted text that doesn't contain the original text.
- Return encrypted text and an IV that [crypt.decrypt](decrypt.md) can turn back into the original text.
- Use a new IV each time, so encrypting the same text twice gives different results.
- Produce encrypted text that a different key can't decrypt.
- Round trip empty text and 16 byte text through [crypt.decrypt](decrypt.md).
- Support CTR mode and match the published AES-256 CTR test vector.
- Support CBC mode and match the first block of the NIST SP 800-38A AES-256 CBC test vector.
