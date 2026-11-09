# crypt.random: (Length: number) -> string
Generates random bytes.
```lua
print(#crypt.random(16)) --> 16
```
# Parameters
| Length: [number](https://create.roblox.com/docs/luau/numbers)&emsp;&emsp;&emsp;&emsp;&emsp;&emsp; | The number of bytes to generate.&emsp;&emsp;&emsp;&emsp;&emsp;&emsp; |
| :-------- | :------- |
# Returns
| [string](https://create.roblox.com/docs/luau/strings)&emsp;&emsp;&emsp;&emsp;&emsp;&emsp; | The random bytes.&emsp;&emsp;&emsp;&emsp;&emsp;&emsp; |
| :-------- | :------- |
# Test requirements
To pass the crypt.random test, the function must:
- Return the requested number of bytes.
- Return different bytes each time.
- Return bytes with more than 8 different values out of 64.
