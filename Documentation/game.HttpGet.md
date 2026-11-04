# game.HttpGet: (Url: string) -> string
Sends a GET request and returns the body of the response.
```lua
local Body = game:HttpGet("https://httpbin.org/get")
print(Body)
```
# Parameters
| Url: [string](https://create.roblox.com/docs/luau/strings)&emsp;&emsp;&emsp;&emsp;&emsp;&emsp; | The url to request.&emsp;&emsp;&emsp;&emsp;&emsp;&emsp; |
| :-------- | :------- |
# Returns
| [string](https://create.roblox.com/docs/luau/strings)&emsp;&emsp;&emsp;&emsp;&emsp;&emsp; | The body of the response.&emsp;&emsp;&emsp;&emsp;&emsp;&emsp; |
| :-------- | :------- |
