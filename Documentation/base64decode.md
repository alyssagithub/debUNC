# base64decode: (Encoded: string) -> string
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
| Parameter&emsp;&emsp;&emsp;&emsp;&emsp;&emsp; | Description&emsp;&emsp;&emsp;&emsp;&emsp;&emsp; |
| :-------- | :------- |
| Encoded: [string](https://create.roblox.com/docs/luau/strings) | The encoded string to decode. |
# Returns
| Type&emsp;&emsp;&emsp;&emsp;&emsp;&emsp; | Description&emsp;&emsp;&emsp;&emsp;&emsp;&emsp; |
| :-------- | :------- |
| [string](https://create.roblox.com/docs/luau/strings) | The decoded string. |
# Test requirements
To pass the base64decode test, the function must:
- Decode a random string the same way `EncodingService:Base64Decode` does.
- Give back every byte from 0 to 255 unchanged.
- Return an empty string when it's given an empty string.
