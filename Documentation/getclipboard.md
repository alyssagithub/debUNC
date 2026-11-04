# getclipboard: () -> string
Returns the text currently on the clipboard. It only gives the latest copy, not older ones, and takes no parameters. If the clipboard holds something that isn't text, like an image, it returns an empty string.
```lua
setclipboard("Hello world!")
print(getclipboard()) --> Hello world!
```
# Returns
| [string](https://create.roblox.com/docs/luau/strings)&emsp;&emsp;&emsp;&emsp;&emsp;&emsp; | The clipboard's text, or an empty string if there's no text.&emsp;&emsp;&emsp;&emsp;&emsp;&emsp; |
| :-------- | :------- |
