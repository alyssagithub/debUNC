# base64encode: (Text: string) -> string
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
| Parameter&emsp;&emsp;&emsp;&emsp;&emsp;&emsp; | Description&emsp;&emsp;&emsp;&emsp;&emsp;&emsp; |
| :-------- | :------- |
| Text: [string](https://create.roblox.com/docs/luau/strings) | The string to encode. |
# Returns
| Type&emsp;&emsp;&emsp;&emsp;&emsp;&emsp; | Description&emsp;&emsp;&emsp;&emsp;&emsp;&emsp; |
| :-------- | :------- |
| [string](https://create.roblox.com/docs/luau/strings) | The encoded string. |
# Test requirements
To pass the base64encode test, the function must:
- Encode a random string the same way `EncodingService:Base64Encode` does.
- Encode every byte from 0 to 255 the same way `EncodingService:Base64Encode` does.
- Return an empty string when it's given an empty string.
