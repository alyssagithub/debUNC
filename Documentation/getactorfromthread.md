# getactorfromthread: (Thread: thread) -> Actor?
Returns the Actor that a thread belongs to.
```lua
local Actor = Instance.new("Actor")
Actor.Parent = workspace

runonactor(Actor, "print(getactorfromthread(coroutine.running()))")
```
# Parameters
| Thread: [thread](https://create.roblox.com/docs/reference/engine/libraries/coroutine)&emsp;&emsp;&emsp;&emsp;&emsp;&emsp; | The thread to check.&emsp;&emsp;&emsp;&emsp;&emsp;&emsp; |
| :-------- | :------- |
# Returns
| [Actor?](https://create.roblox.com/docs/reference/engine/classes/Actor)&emsp;&emsp;&emsp;&emsp;&emsp;&emsp; | The Actor, or nil if it doesn't belong to one.&emsp;&emsp;&emsp;&emsp;&emsp;&emsp; |
| :-------- | :------- |

# Test requirements
To pass the getactorfromthread test, the function must:
- Return the Actor that a thread is running on.
- Return `nil` for a thread that isn't on an Actor.
