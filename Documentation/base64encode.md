# base64encode: (Text: string) -> string
> [!WARNING]
> **Deprecated**
>
> This function has been superseded by [EncodingService:Base64Encode](https://create.roblox.com/docs/reference/engine/classes/EncodingService#Base64Encode) which should be used in all new work.

Encodes a string in Base64.
```lua
print(base64encode("Hello world!")) --> SGVsbG8gd29ybGQh
```
# Aliases
| Library | Name |
| :- | :- |
| base64 | encode |
| | base64_encode |
| crypt.base64 | encode |
| crypt | base64_encode |
| crypt | base64encode |
# Parameters
| Text: [string](https://create.roblox.com/docs/luau/strings)&emsp;&emsp;&emsp;&emsp;&emsp;&emsp; | The string to encode.&emsp;&emsp;&emsp;&emsp;&emsp;&emsp; |
| :-------- | :------- |
# Returns
| [string](https://create.roblox.com/docs/luau/strings)&emsp;&emsp;&emsp;&emsp;&emsp;&emsp; | The encoded string.&emsp;&emsp;&emsp;&emsp;&emsp;&emsp; |
| :-------- | :------- |
# Test requirements
To pass the base64encode test, the function must:
- Encode a random string the same way `EncodingService:Base64Encode` does.
- Encode every byte from 0 to 255 the same way `EncodingService:Base64Encode` does.
- Return an empty string when it's given an empty string.
