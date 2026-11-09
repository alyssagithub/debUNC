# Drawing.Fonts: {UI: number, System: number, Plex: number, Monospace: number}
The fonts that a Text object can use.
```lua
local Text = Drawing.new("Text")
Text.Font = Drawing.Fonts.Monospace
```
# Returns
| <pre>{<br>&nbsp;&nbsp;&nbsp;&nbsp;UI: number,<br>&nbsp;&nbsp;&nbsp;&nbsp;System: number,<br>&nbsp;&nbsp;&nbsp;&nbsp;Plex: number,<br>&nbsp;&nbsp;&nbsp;&nbsp;Monospace: number,<br>}</pre>&emsp;&emsp;&emsp;&emsp;&emsp;&emsp; | UI is 0, System is 1, Plex is 2 and Monospace is 3.&emsp;&emsp;&emsp;&emsp;&emsp;&emsp; |
| :-------- | :------- |
# Test requirements
To pass the Drawing.Fonts test, the function must:
- Be a table.
- Have `UI` set to 0, `System` set to 1, `Plex` set to 2, and `Monospace` set to 3.
