# game.HttpGet: (Url: string, NoCache: boolean?) -> string
Sends a GET request and returns the body of the response. Requests to the same url are cached unless NoCache is true.
```lua
local Body = game:HttpGet("https://httpbin.org/get")
print(Body)
```
# Parameters
| Url: [string](https://create.roblox.com/docs/luau/strings)&emsp;&emsp;&emsp;&emsp;&emsp;&emsp; | The url to request.&emsp;&emsp;&emsp;&emsp;&emsp;&emsp; |
| :-------- | :------- |
| NoCache: [boolean](https://create.roblox.com/docs/luau/booleans)? | Whether to skip a cached response from an earlier request to the same url. |
# Returns
| [string](https://create.roblox.com/docs/luau/strings)&emsp;&emsp;&emsp;&emsp;&emsp;&emsp; | The body of the response.&emsp;&emsp;&emsp;&emsp;&emsp;&emsp; |
| :-------- | :------- |
