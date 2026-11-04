# request: (Options: {Url: string, Method: string?, Headers: {[string]: string}?, Body: string?}) -> {Success: boolean, StatusCode: number, StatusMessage: string, Headers: {[string]: string}, Body: string}
Sends an HTTP request.
```lua
local Response = request({
	Url = "https://httpbin.org/get",
	Method = "GET",
})

print(Response.StatusCode) --> 200
print(Response.Body)
```
# Aliases
| Library | Name |
| :- | :- |
| http | request |
| | http_request |
| | httprequest |
# Parameters
| Options: <pre>{<br>&nbsp;&nbsp;&nbsp;&nbsp;Url: string,<br>&nbsp;&nbsp;&nbsp;&nbsp;Method: string?,<br>&nbsp;&nbsp;&nbsp;&nbsp;Headers: {[string]: string}?,<br>&nbsp;&nbsp;&nbsp;&nbsp;Body: string?,<br>}</pre>&emsp;&emsp;&emsp;&emsp;&emsp;&emsp; | The Url, Method, Headers and Body of the request.&emsp;&emsp;&emsp;&emsp;&emsp;&emsp; |
| :-------- | :------- |
# Returns
| <pre>{<br>&nbsp;&nbsp;&nbsp;&nbsp;Success: boolean,<br>&nbsp;&nbsp;&nbsp;&nbsp;StatusCode: number,<br>&nbsp;&nbsp;&nbsp;&nbsp;StatusMessage: string,<br>&nbsp;&nbsp;&nbsp;&nbsp;Headers: {[string]: string},<br>&nbsp;&nbsp;&nbsp;&nbsp;Body: string,<br>}</pre>&emsp;&emsp;&emsp;&emsp;&emsp;&emsp; | The response. Each key is explained below.&emsp;&emsp;&emsp;&emsp;&emsp;&emsp; |
| :-------- | :------- |
# Options
| Url: [string](https://create.roblox.com/docs/luau/strings)&emsp;&emsp;&emsp;&emsp;&emsp;&emsp; | The url to request.&emsp;&emsp;&emsp;&emsp;&emsp;&emsp; |
| :-------- | :------- |
| Method: [string?](https://create.roblox.com/docs/luau/strings) | The HTTP method, such as GET or POST. |
| Headers: [table?](https://create.roblox.com/docs/luau/tables) | The headers to send. |
| Body: [string?](https://create.roblox.com/docs/luau/strings) | The body to send. |
# Response
| Success: [boolean](https://create.roblox.com/docs/luau/booleans)&emsp;&emsp;&emsp;&emsp;&emsp;&emsp; | Whether or not the request worked. This is false for a status like 404.&emsp;&emsp;&emsp;&emsp;&emsp;&emsp; |
| :-------- | :------- |
| StatusCode: [number](https://create.roblox.com/docs/luau/numbers) | The status code, such as 200. |
| StatusMessage: [string](https://create.roblox.com/docs/luau/strings) | The status message, such as OK. |
| Headers: [table](https://create.roblox.com/docs/luau/tables) | The headers that came back. |
| Body: [string](https://create.roblox.com/docs/luau/strings) | The body that came back. |
