# getallthreads: () -> {thread}
Returns every thread.
```lua
print(table.find(getallthreads(), coroutine.running()) ~= nil) --> true
```
# Aliases
| Name |
| :- |
| get_all_threads |
# Returns
| {thread}&emsp;&emsp;&emsp;&emsp;&emsp;&emsp; | An array of threads.&emsp;&emsp;&emsp;&emsp;&emsp;&emsp; |
| :-------- | :------- |

# Test requirements
To pass the getallthreads test, the function must:
- Return a table of only threads.
- Include the thread that calls it.
- Include a thread that was spawned and is waiting.
- Return more than one thread.
