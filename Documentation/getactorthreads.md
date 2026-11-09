# getactorthreads: () -> {thread}
Returns the threads that code can run on inside of Actors.
```lua
print(#getactorthreads())
```
# Returns
| {thread}&emsp;&emsp;&emsp;&emsp;&emsp;&emsp; | An array of threads.&emsp;&emsp;&emsp;&emsp;&emsp;&emsp; |
| :-------- | :------- |

# Test requirements
To pass the getactorthreads test, the function must:
- Return a table.
- Return at least one thread when code is running on an Actor.
- Leave out threads that aren't on an Actor.
- Return only threads.
