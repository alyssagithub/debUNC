# getrenv: () -> {[string]: any}
Returns the environment that the game's scripts run in.
```lua
print(getrenv().game == game) --> true
```
# Aliases
| Name |
| :- |
| get_renv |
| get_roblox_environment |
| getrobloxenvironment |
# Returns
| {[string]: any}&emsp;&emsp;&emsp;&emsp;&emsp;&emsp; | Roblox's environment.&emsp;&emsp;&emsp;&emsp;&emsp;&emsp; |
| :-------- | :------- |
# Test requirements
To pass the getrenv test, the function must:
- Include the Roblox globals `delay`, `elapsedTime`, `printidentity`, `settings`, `spawn`, `stats`, `tick`, `time`, `typeof`, `UserSettings`, `version`, `wait`, `warn`, `ypcall`, `Enum`, `game`, `shared`, `_G`, and `workspace`.
- Use the real `game` and `print`.
- Have its own `_G`, separate from the executor's.
- Return a table that isn't the executor's global environment.
- Leave out executor functions such as `getgenv` and `hookfunction`, so game scripts can't find them.
- Keep a value written to it, so a later call returns it.
- Return a table.
