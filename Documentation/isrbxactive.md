# isrbxactive: () -> boolean
Returns whether or not the Roblox window is focused.
> [!NOTE]
> To react when focus changes, use [UserInputService.WindowFocused](https://create.roblox.com/docs/reference/engine/classes/UserInputService#WindowFocused) and [UserInputService.WindowFocusReleased](https://create.roblox.com/docs/reference/engine/classes/UserInputService#WindowFocusReleased) instead of checking this in a loop.

```lua
print(isrbxactive())
```
# Aliases
| Name |
| :- |
| is_game_active |
| is_rbx_active |
| isgameactive |
| iswindowactive |
# Returns
| [boolean](https://create.roblox.com/docs/luau/booleans)&emsp;&emsp;&emsp;&emsp;&emsp;&emsp; | Whether or not the window is focused.&emsp;&emsp;&emsp;&emsp;&emsp;&emsp; |
| :-------- | :------- |

# Test requirements
To pass the isrbxactive test, the function must:
- Return a boolean.
- Return `false` within a second after the Roblox window loses focus.
