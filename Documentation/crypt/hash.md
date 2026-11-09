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
# Test requirements
To pass the crypt.hash test, the function must:
- Match the published SHA-256 value for "abc".
- Return SHA-256 hashes as 64 hex characters.
- Return the same hash every time for the same input.
- Return different hashes for different inputs.
- Match the published MD5, SHA-1, SHA-384, and SHA-512 values for "abc".
- Match the published SHA-256 value for an empty string.
- Error or return nil when it's given an algorithm that doesn't exist.
- Match `EncodingService:ComputeBufferHash` for the SHA-256 hash of a random string.
