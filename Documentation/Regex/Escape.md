# Regex.Escape: (Text: string) -> string
Escapes the special characters in text so it's matched as plain text by [Regex.new](new.md).
```lua
local Pattern = Regex.new(Regex.Escape("a.b*c"))

print(Pattern:Match("a.b*c") ~= nil) --> true
print(Pattern:Match("axb*c") ~= nil) --> false
```
# Parameters
| Parameter&emsp;&emsp;&emsp;&emsp;&emsp;&emsp; | Description&emsp;&emsp;&emsp;&emsp;&emsp;&emsp; |
| :-------- | :------- |
| Text: [string](https://create.roblox.com/docs/luau/strings) | The text to escape. |
# Returns
| Type&emsp;&emsp;&emsp;&emsp;&emsp;&emsp; | Description&emsp;&emsp;&emsp;&emsp;&emsp;&emsp; |
| :-------- | :------- |
| [string](https://create.roblox.com/docs/luau/strings) | The escaped text. |
# Test requirements
To pass the Regex.Escape test, the function must:
- Return a pattern that matches the original text, like "a.b*c".
- Escape every special character, so `.` only matches a real dot and not any character.
- Escape each of `.*+?^$()[]{}|\` so it matches only itself, on its own and all together.
