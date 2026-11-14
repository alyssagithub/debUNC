# getactors: () -> {Actor | thread}
Returns every Actor that scripts can run in. Some executors return the actors' threads instead.
```lua
for _, Actor in getactors() do
	print(Actor:GetFullName())
end
```
# Aliases
| Name |
| :- |
| get_actors |
# Returns
| Type&emsp;&emsp;&emsp;&emsp;&emsp;&emsp; | Description&emsp;&emsp;&emsp;&emsp;&emsp;&emsp; |
| :-------- | :------- |
| {[Actor](https://create.roblox.com/docs/reference/engine/classes/Actor)} | An array of Actors, or their threads. |

# Test requirements
To pass the getactors test, the function must:
- Return only Actors or actor threads.
- Find a new Actor within 2 seconds after code runs on it.
