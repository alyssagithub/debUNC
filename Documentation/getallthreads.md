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
