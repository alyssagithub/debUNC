# getgenv: () -> {[string]: any}
Returns the environment shared between every script the executor runs.
```lua
getgenv().Greeting = "Hello world!"
print(Greeting) --> Hello world!
```
# Aliases
| Name |
| :- |
| get_genv |
| get_global_environment |
| getglobalenvironment |
# Returns
| {[string]: any}&emsp;&emsp;&emsp;&emsp;&emsp;&emsp; | The executor's global environment.&emsp;&emsp;&emsp;&emsp;&emsp;&emsp; |
| :-------- | :------- |
