# crypt.random: (Length: number) -> string
Generates random bytes.
```lua
print(#crypt.random(16)) --> 16
```
# Parameters
| Parameter&emsp;&emsp;&emsp;&emsp;&emsp;&emsp; | Description&emsp;&emsp;&emsp;&emsp;&emsp;&emsp; |
| :-------- | :------- |
| Length: [number](https://create.roblox.com/docs/luau/numbers) | The number of bytes to generate. |
# Returns
| Type&emsp;&emsp;&emsp;&emsp;&emsp;&emsp; | Description&emsp;&emsp;&emsp;&emsp;&emsp;&emsp; |
| :-------- | :------- |
| [string](https://create.roblox.com/docs/luau/strings) | The random bytes. |
# Test requirements
To pass the crypt.random test, the function must:
- Return the requested number of bytes.
- Return different bytes each time.
- Return bytes with more than 8 different values out of 64.
