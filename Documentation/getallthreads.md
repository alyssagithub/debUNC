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
- Include the thread that calls it.
- Return more than one thread.
