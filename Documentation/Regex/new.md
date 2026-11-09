# Regex.new: (Pattern: string) -> Regex
Creates a regular expression that can find and replace text.
```lua
local Pattern = Regex.new("d(e+)b")
local Match = Pattern:Match("xdeeeb")

print(Match.Captures[1]) --> deeeb
print(Match.Captures[2]) --> eee
print(Pattern:Replace("deb deeb", "Z")) --> Z Z
```
# Parameters
| Pattern: [string](https://create.roblox.com/docs/luau/strings)&emsp;&emsp;&emsp;&emsp;&emsp;&emsp; | The regular expression.&emsp;&emsp;&emsp;&emsp;&emsp;&emsp; |
| :-------- | :------- |
# Returns
| Regex&emsp;&emsp;&emsp;&emsp;&emsp;&emsp; | An object with Match and Replace methods.&emsp;&emsp;&emsp;&emsp;&emsp;&emsp; |
| :-------- | :------- |
# Methods
## Match: (Text: string) -> {Captures: {string}}?
Finds the first match in the text. Captures[1] is the whole match and each capture group's text follows it. Returns nil if nothing matches.
## Replace: (Text: string, Replacement: string) -> string
Replaces every match in the text.
# Test requirements
To pass the Regex.new test, the function must:
- Return an object whose Match method returns a table with Captures.
- Put the whole match first in Captures, as "deeeb" for the pattern `d(e+)b` in "xdeeeb deb".
- Put each capture group after it, as "eee" for that same match.
- Return nil from Match when nothing matches.
- Replace every match with Replace, so "deb deeb" becomes "Z Z".
