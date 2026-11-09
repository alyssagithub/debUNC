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
| {[Actor](https://create.roblox.com/docs/reference/engine/classes/Actor)}&emsp;&emsp;&emsp;&emsp;&emsp;&emsp; | An array of Actors, or their threads.&emsp;&emsp;&emsp;&emsp;&emsp;&emsp; |
| :-------- | :------- |

# Test requirements
To pass the getactors test, the function must:
- Return only Actors or actor threads.
- Find a new Actor within 2 seconds after code runs on it.
