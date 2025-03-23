# isluau
Returns whether or not the current thread is running in the luau environment.
```lua
local IsLuau = isluau()
print(IsLuau) --> true
local VersionIsLuau = _VERSION == "Luau"
print(IsLuau == VersionIsLuau) --> true
```
# Returns
| boolean<!--                  -->&emsp;&emsp;&emsp;&emsp;&emsp;&emsp; | Whether or not the current thread is running in the luau environment.<!--                  -->&emsp;&emsp;&emsp;&emsp;&emsp;&emsp; |
| :-------- | :------- |
