# crypt.hmac: (Key: string, Text: string, Algorithm: string) -> string
Signs text with a key using the given algorithm.
```lua
print(crypt.hmac("key", "The quick brown fox jumps over the lazy dog", "sha256"))
--> 97yD9DBThCSxMpjmqm+xQ+9NWaFJRhdZl0edvC0aPNg=
```
# Parameters
| Key: [string](https://create.roblox.com/docs/luau/strings)&emsp;&emsp;&emsp;&emsp;&emsp;&emsp; | The key to sign with.&emsp;&emsp;&emsp;&emsp;&emsp;&emsp; |
| :-------- | :------- |
| Text: [string](https://create.roblox.com/docs/luau/strings) | The text to sign. |
| Algorithm: [string](https://create.roblox.com/docs/luau/strings) | The algorithm to use, such as sha256. |
# Returns
| [string](https://create.roblox.com/docs/luau/strings)&emsp;&emsp;&emsp;&emsp;&emsp;&emsp; | The signature encoded in Base64.&emsp;&emsp;&emsp;&emsp;&emsp;&emsp; |
| :-------- | :------- |
# Test requirements
To pass the crypt.hmac test, the function must:
- Match the published HMAC-SHA256 value, in base64, for the key "key" and the text "The quick brown fox jumps over the lazy dog".
- Match the published HMAC-SHA256 value, in base64, for the key "Jefe" and the text "what do ya want for nothing?".
- Return the same result every time for the same key and data.
- Return different results for different keys.
