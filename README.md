# debUNC (debunk Unified Naming Convention)
like sUNC and UNC but better (made by vice (@wtits) on discord)

feel free to make an issue or PR whenever you have a suggestion, bug, or feedback you think would improve your use of this

all custom functions that debUNC tests are documented in [Documentation](Documentation)

reasons why i made this:
1. sUNC is obfuscated, sure u can ask the developers for the source code in order to debug but that's just an unnecessary step
2. sUNC's tests fail even though the function works, which atp what is the test even for?
3. sUNC and UNC don't test ALL of the functions many scripts use, only the most necessary, which makes it so even with a 100% score it's not supporting every script's function use
4. sUNC and UNC don't display the executor's version in test results, making it easy for people to misinform with outdated results
5. sUNC and UNC aren't made by me (i want to be famous)
# Loadstring
```lua
loadstring(game:HttpGet("https://github.com/alyssagithub/debUNC/raw/main/debUNC.luau"))()
```
# Confirmed results (debUNC v2.4.0)
![Lucid](https://img.shields.io/badge/Lucid_1.0.0-97%25-brightgreen?style=for-the-badge)

![Synapse Z](https://img.shields.io/badge/Synapse_Z_v1.0.3.9-81%25-yellow?style=for-the-badge)

![Bunni](https://img.shields.io/badge/Bunni_2.0-77%25-yellow?style=for-the-badge)

| Executor | Version | Score | Took | 🟢 Passed | 🔴 Failed | 🟠 Skipped | 🟡 Missing |
|---|---|:---:|:---:|:---:|:---:|:---:|:---:|
| Lucid | 1.0.0 | **97%** | 12.42s | 202 | 2 | 0 | 4 |
| Synapse Z | v1.0.3.9 | **81%** | 16.17s | 169 | 17 | 1 | 21 |
| Bunni | 2.0 | **77%** | 9.91s | 161 | 19 | 1 | 27 |

<details>
<summary><b>Lucid details</b></summary>

**🔴 Failed**
- `getactors`: should return Actor instances, but got a thread (threads are what getactorthreads is for)
- `identifyexecutor`: the version '1.0.0' never changes between updates, it should be the real version of each release

**🟡 Missing**
- `getclipboard`
- `getfilesize`
- `movefile`
- `renamefile`

</details>

<details>
<summary><b>Synapse Z details</b></summary>

**🔴 Failed**
- `createcommchannel`: expected a number id, got a string
- `crypt.encrypt`: invalid argument #2 to 'encrypt' (invalid key size)
- `crypt.hash`: the sha256 hash of 'abc' was wrong, got 89911f71a4508762a5791590153c68a9bbee326969d37b603697a692b3fdf553
- `decompile`: couldn't find '__index' in the decompiled 'CameraModule', it started with '-- Decompiled with Medal thread 'main' (3064) panicked at luau-lifter\src\instruction.rs:174:18: internal error: entered unreachable code: 87 note: run with RUST_BACKTRACE=1 environment variable to display a backtrace'
- `dofile`: expected the value the file returned to be 0.6094110861208102, got File_0.13667204146883877.lua
- `Drawing.new`: expected a Text object's Font after setting it to 3 to be 3, got DrawFont: 0x33316ca90b2d9905
- `getcommchannel`: expected a number id, got a string
- `gethiddenproperties`: expected size_xml to be 17, got nil
- `getproperties`: expected the Size in the returned table to be 4, 2, 5, got nil
- `getscripthash`: should be a 96 character sha384 hash, got 64 characters
- `getsenv`: getsenv returned nil when the parent was nil
- `hooksignal`: returning false from the hook didn't stop the connection from firing
- `isparallel`: should return false in an actor before it desynchronizes
- `mousemoveabs`: the mouse went to 400, 299 instead of 406, 346.5
- `mousemoverel`: the mouse moved by -6, -47 instead of about 25, 25
- `mousescroll`: missing argument #2 to 'mousescroll' (number expected)
- `raknet.receive`: the receive hook didn't see the packet

**🟠 Skipped**
- `crypt.decrypt`: couldn't be tested because crypt.encrypt failed

**🟡 Missing**
- `appendfileasync`
- `clearqueueonteleport`
- `comparefunctions`
- `crypt.hmac`
- `getactorfromthread`
- `getactorthreads`
- `getclipboard`
- `getfilesize`
- `getmenv`
- `getmetafield`
- `getmodules`
- `getsignalwhitelist`
- `hasmetafield`
- `hasmetatable`
- `loadfileasync`
- `movefile`
- `readfileasync`
- `renamefile`
- `saveinstance`
- `writecustomasset`
- `writefileasync`

</details>

<details>
<summary><b>Bunni details</b></summary>

**🔴 Failed**
- `cansignalreplicate`: should return true for Player.Kill
- `dofile`: expected the value the file returned to be 0.6385579215606689, got nil
- `game.HttpGet`: httpgetting a website that doesn't exist should return an error, nil, or an empty string
- `getactorthreads`: expected at least one actor thread
- `getfpscap`: expected the fps cap to be 10, got 0
- `getmenv`: .script doesn't point to the module
- `getmodules`: didn't find a new ModuleScript
- `getsignalarguments`: expected the number of arguments Touched has to be 1, got 125
- `getsignalargumentsinfo`: expected the name of Touched's argument to be otherPart, got Instance
- `hooksignal`: returning false from the hook didn't stop the connection from firing
- `identifyexecutor`: the version '2.0' never changes between updates, it should be the real version of each release
- `isparallel`: should return false in an actor before it desynchronizes
- `keyclick`: the key press wasn't detected
- `keypress`: the input wasn't detected
- `keyrelease`: the input was never held down, so it can't be released
- `mousemoveabs`: the mouse went to 439, 280 instead of 448, 312.5
- `raknet.send`: invalid argument #1 to 'send' (string expected, got buffer)
- `replicatesignal`: should error on a signal that can't be replicated
- `saveinstance`: didn't return a string

**🟠 Skipped**
- `restoresignal`: couldn't be tested because hooksignal failed

**🟡 Missing**
- `appendfileasync`
- `createcommchannel`
- `debug.getcallstack`
- `debug.isvalidlevel`
- `debug.setinfo`
- `getactorfromthread`
- `getcommchannel`
- `getfunctionbytecode`
- `getfunctionreferences`
- `gethwid`
- `getobjectreferences`
- `gettenv`
- `hookproto`
- `iscorescript`
- `isprotohooked`
- `issignalhooked`
- `loadfileasync`
- `raknet.addreceivehook`
- `raknet.addsendhook`
- `raknet.receive`
- `raknet.removereceivehook`
- `raknet.removesendhook`
- `readfileasync`
- `restoreproto`
- `runonthread`
- `writecustomasset`
- `writefileasync`

</details>
