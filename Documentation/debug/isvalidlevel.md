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
| Parameter&emsp;&emsp;&emsp;&emsp;&emsp;&emsp; | Description&emsp;&emsp;&emsp;&emsp;&emsp;&emsp; |
| :-------- | :------- |
| Level: [number](https://create.roblox.com/docs/luau/numbers) | The stack level to check. |
# Returns
| Type&emsp;&emsp;&emsp;&emsp;&emsp;&emsp; | Description&emsp;&emsp;&emsp;&emsp;&emsp;&emsp; |
| :-------- | :------- |
| [boolean](https://create.roblox.com/docs/luau/booleans) | Whether or not the level exists. |

# Test requirements
To pass the debug.isvalidlevel test, the function must:
- Return `true` for level 1.
- Return `false` for level 500.
- Return `true` for the deepest level that exists on the current stack.
- Return `false` for the first level past the end of the stack.
