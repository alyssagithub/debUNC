# getactorfromthread: (Thread: thread) -> Actor?
Returns the Actor that a thread belongs to.
```lua
local Actor = Instance.new("Actor")
Actor.Parent = workspace

runonactor(Actor, "print(getactorfromthread(coroutine.running()))")
```
# Parameters
| Parameter&emsp;&emsp;&emsp;&emsp;&emsp;&emsp; | Description&emsp;&emsp;&emsp;&emsp;&emsp;&emsp; |
| :-------- | :------- |
| Thread: [thread](https://create.roblox.com/docs/reference/engine/libraries/coroutine) | The thread to check. |
# Returns
| Type&emsp;&emsp;&emsp;&emsp;&emsp;&emsp; | Description&emsp;&emsp;&emsp;&emsp;&emsp;&emsp; |
| :-------- | :------- |
| [Actor?](https://create.roblox.com/docs/reference/engine/classes/Actor) | The Actor, or nil if it doesn't belong to one. |

# Test requirements
To pass the getactorfromthread test, the function must:
- Return the Actor that a thread is running on.
- Return `nil` for a thread that isn't on an Actor.
