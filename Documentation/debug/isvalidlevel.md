# debug.isvalidlevel: (Level: number) -> boolean
Returns whether or not a level exists on the call stack.
```lua
print(debug.isvalidlevel(1)) --> true
print(debug.isvalidlevel(500)) --> false
```
# Aliases
| Library | Name |
| :- | :- |
| debug | is_valid_level |
| | is_valid_level |
| | isvalidlevel |
# Parameters
| Level: [number](https://create.roblox.com/docs/luau/numbers)&emsp;&emsp;&emsp;&emsp;&emsp;&emsp; | The stack level to check.&emsp;&emsp;&emsp;&emsp;&emsp;&emsp; |
| :-------- | :------- |
# Returns
| [boolean](https://create.roblox.com/docs/luau/booleans)&emsp;&emsp;&emsp;&emsp;&emsp;&emsp; | Whether or not the level exists.&emsp;&emsp;&emsp;&emsp;&emsp;&emsp; |
| :-------- | :------- |
