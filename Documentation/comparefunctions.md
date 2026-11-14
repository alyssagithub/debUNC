# comparefunctions: (First: function, Second: function) -> boolean
Returns whether or not two values are the same function.
```lua
local function Greet() end
print(comparefunctions(Greet, Greet)) --> true
print(comparefunctions(Greet, print)) --> false
```
# Parameters
| Parameter&emsp;&emsp;&emsp;&emsp;&emsp;&emsp; | Description&emsp;&emsp;&emsp;&emsp;&emsp;&emsp; |
| :-------- | :------- |
| First: [function](https://create.roblox.com/docs/luau/functions) | The first function. |
| Second: [function](https://create.roblox.com/docs/luau/functions) | The second function. |
# Returns
| Type&emsp;&emsp;&emsp;&emsp;&emsp;&emsp; | Description&emsp;&emsp;&emsp;&emsp;&emsp;&emsp; |
| :-------- | :------- |
| [boolean](https://create.roblox.com/docs/luau/booleans) | Whether or not they're the same function. |
# Test requirements
To pass the comparefunctions test, the function must:
- Return true when a function is compared with itself.
- Return false for two different functions.
