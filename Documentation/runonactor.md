# runonactor: (Actor: Actor, Code: string, ...: any) -> ()
Runs code inside of an Actor, passing it any extra values.
```lua
local Actor = Instance.new("Actor")
Actor.Parent = workspace

runonactor(Actor, "print(...)", "Hello world!") --> Hello world!
```
# Aliases
| Name |
| :- |
| run_on_actor |
# Parameters
| Actor: [Actor](https://create.roblox.com/docs/reference/engine/classes/Actor)&emsp;&emsp;&emsp;&emsp;&emsp;&emsp; | The Actor to run in.&emsp;&emsp;&emsp;&emsp;&emsp;&emsp; |
| :-------- | :------- |
| Code: [string](https://create.roblox.com/docs/luau/strings) | The code to run. |
| ...: any | The values to pass to the code. |
