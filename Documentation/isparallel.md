# isparallel: () -> boolean
Returns whether or not the current thread is running in parallel.
```lua
print(isparallel()) --> false
```
# Aliases
| Name |
| :- |
| checkparallel |
| is_parallel |
# Returns
| [boolean](https://create.roblox.com/docs/luau/booleans)&emsp;&emsp;&emsp;&emsp;&emsp;&emsp; | Whether or not the thread is running in parallel.&emsp;&emsp;&emsp;&emsp;&emsp;&emsp; |
| :-------- | :------- |

# Test requirements
To pass the isparallel test, the function must:
- Return `false` outside of an actor.
- Return `false` in an actor before it desynchronizes.
- Return `true` in an actor after `task.desynchronize()`.
