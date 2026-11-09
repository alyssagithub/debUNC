# base64decode: (Encoded: string) -> string
> [!WARNING]
> **Deprecated**
>
> This function has been superseded by [EncodingService:Base64Decode](https://create.roblox.com/docs/reference/engine/classes/EncodingService#Base64Decode) which should be used in all new work.

Decodes a string that is encoded in Base64.
```lua
print(base64decode("SGVsbG8gd29ybGQh")) --> Hello world!
```
# Aliases
| Library | Name |
| :- | :- |
| base64 | decode |
| | base64_decode |
| crypt.base64 | decode |
| crypt | base64_decode |
| crypt | base64decode |
# Parameters
| Encoded: [string](https://create.roblox.com/docs/luau/strings)&emsp;&emsp;&emsp;&emsp;&emsp;&emsp; | The encoded string to decode.&emsp;&emsp;&emsp;&emsp;&emsp;&emsp; |
| :-------- | :------- |
# Returns
| [string](https://create.roblox.com/docs/luau/strings)&emsp;&emsp;&emsp;&emsp;&emsp;&emsp; | The decoded string.&emsp;&emsp;&emsp;&emsp;&emsp;&emsp; |
| :-------- | :------- |
# Test requirements
To pass the base64decode test, the function must:
- Decode a random string the same way `EncodingService:Base64Decode` does.
- Give back every byte from 0 to 255 unchanged.
- Return an empty string when it's given an empty string.
