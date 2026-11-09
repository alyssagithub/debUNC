# setclipboard: (Text: string) -> ()
Copies text to the clipboard.
```lua
setclipboard("Hello world!")
```
# Aliases
| Name |
| :- |
| set_clipboard |
| to_clipboard |
| toclipboard |
# Parameters
| Text: [string](https://create.roblox.com/docs/luau/strings)&emsp;&emsp;&emsp;&emsp;&emsp;&emsp; | The text to copy.&emsp;&emsp;&emsp;&emsp;&emsp;&emsp; |
| :-------- | :------- |

# Test requirements
To pass the setclipboard test, the function must:
- Copy the text it's given, so [getclipboard](getclipboard.md) returns it within 1 second.
