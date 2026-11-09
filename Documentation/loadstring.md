# loadstring: (Source: string, ChunkName: string?) -> (function?, string?)
Compiles Luau source code into a function you can call. If the code has an error, it returns nil and the error message instead.
```lua
local Add = loadstring("return 1 + 2")
print(Add()) --> 3

local Broken, Error = loadstring("local x x", "MyChunk")
print(Broken, Error) --> nil, [string "MyChunk"]:1: ...
```
# Parameters
| Source: [string](https://create.roblox.com/docs/luau/strings)&emsp;&emsp;&emsp;&emsp;&emsp;&emsp; | The code to compile.&emsp;&emsp;&emsp;&emsp;&emsp;&emsp; |
| :-------- | :------- |
| ChunkName: [string?](https://create.roblox.com/docs/luau/strings) | The name shown in error messages for this code. |
# Returns
| [function?](https://create.roblox.com/docs/luau/functions)&emsp;&emsp;&emsp;&emsp;&emsp;&emsp; | The compiled code, or nil if it couldn't be compiled.&emsp;&emsp;&emsp;&emsp;&emsp;&emsp; |
| :-------- | :------- |
| [string?](https://create.roblox.com/docs/luau/strings) | The compile error, if there was one. |
# Test requirements
To pass the loadstring test, the function must:
- Return a function that runs the compiled code.
- Return nil when the code has an error, instead of erroring.
- Include the chunk name in the compile error.
- Let the compiled code use globals like `game`.
- Work with `setfenv`, so the compiled code reads globals from the environment it's given.
- Compile current Luau syntax, like type aliases, generics, `continue`, `+=`, `//`, if-expressions and string interpolation.
