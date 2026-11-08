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
# Confirmed results (debUNC v2.8.0)
![Lucid](https://img.shields.io/badge/Lucid_1.0.0-92%25-brightgreen?style=for-the-badge)

![Real](https://img.shields.io/badge/Real_3.1.0-81%25-yellow?style=for-the-badge)

![Athena](https://img.shields.io/badge/Athena_1.0-81%25-yellow?style=for-the-badge)

![Synapse Z](https://img.shields.io/badge/Synapse_Z_v1.0.4.0-79%25-yellow?style=for-the-badge)

![Bunni](https://img.shields.io/badge/Bunni_2.0-75%25-yellow?style=for-the-badge)

| Executor | Version | Score | Took | 🟢 Passed | 🔴 Failed | 🟠 Skipped | 🟡 Missing |
|---|---|:---:|:---:|:---:|:---:|:---:|:---:|
| Lucid | 1.0.0 | **92%** | 14.11s | 190 | 5 | 5 | 6 |
| Real | 3.1.0 | **81%** | 17.04s | 168 | 10 | 1 | 27 |
| Athena | 1.0 | **81%** | 17.3s | 167 | 8 | 8 | 23 |
| Synapse Z | v1.0.4.0 | **79%** | 18.62s | 164 | 19 | 1 | 22 |
| Bunni | 2.0 | **75%** | 13.39s | 156 | 21 | 1 | 28 |

<details>
<summary><b>Lucid details</b></summary>

**🔴 Failed**
- `getactors`: should return Actor instances, but got thread (threads are what getactorthreads is for)
- `identifyexecutor`: the version '1.0.0' never changes between updates, it should be the real version of each release
- `isrbxactive`: still returned true after the Roblox window lost focus
- `rconsolecreate`: rconsolehidden returned true after rconsoleshow, so the console didn't open
- `security: your account can't be changed without asking`: AvatarEditorService:NoPromptApplyProfileConfiguration can be called, which lets scripts change your account without asking

**🟠 Skipped**
- `rconsoledestroy`: couldn't be tested because rconsolecreate failed
- `rconsoleerr`: couldn't be tested because rconsolecreate failed
- `rconsoleinfo`: couldn't be tested because rconsolecreate failed
- `rconsoleprint`: couldn't be tested because rconsolecreate failed
- `rconsolewarn`: couldn't be tested because rconsolecreate failed

**🟡 Missing**
- `DirectoryWatcher.new`
- `getclipboard`
- `getfilesize`
- `isstackhidden`
- `movefile`
- `renamefile`

</details>

<details>
<summary><b>Real details</b></summary>

**🔴 Failed**
- `Drawing.new`: should error when Thickness is set to a string
- `dofile`: expected the value the file returned to be 0.9529472678060256, got function: 0xe4cd7d4394815b43
- `getactorfromthread`: didn't return the actor that the thread is running on
- `getactors`: should return Actor instances, but got thread (threads are what getactorthreads is for)
- `getmenv`: invalid thread
- `getscripthash`: the hash isn't the sha384 of the script's bytecode
- `gettenv`: expected error when providing a non-thread value
- `mousemoveabs`: the mouse went to 389, 295 instead of 428, 333.5
- `raknet.addreceivehook`: the receive hook wasn't called within 3 seconds
- `security: your account can't be changed without asking`: AvatarEditorService:NoPromptApplyProfileConfiguration can be called, which lets scripts change your account without asking

**🟠 Skipped**
- `raknet.removereceivehook`: skipped because the receive hook never fired, so removing it can't be checked

**🟡 Missing**
- `DirectoryWatcher.new`
- `debug.getcallstack`
- `debug.setinfo`
- `getclipboard`
- `getfilesize`
- `getfunctionbytecode`
- `getfunctionreferences`
- `getmodules`
- `getobjectreferences`
- `getobjects`
- `hookproto`
- `hooksignal`
- `iscorescript`
- `isprotohooked`
- `issignalhooked`
- `iswriteable`
- `movefile`
- `oth.get_original_thread`
- `oth.get_root_callback`
- `oth.hook`
- `oth.is_hook_thread`
- `oth.unhook`
- `raknet.receive`
- `renamefile`
- `restoreproto`
- `restoresignal`
- `trampolinecall`

</details>

<details>
<summary><b>Athena details</b></summary>

**🔴 Failed**
- `getactors`: should return Actor instances, but got MeshPart
- `getrenv`: its 'print' isn't the real print
- `identifyexecutor`: the version '1.0' never changes between updates, it should be the real version of each release
- `isrbxactive`: still returned true after the Roblox window lost focus
- `loadstring`: the compile error doesn't mention the chunk name, got ':1: Incomplete statement: expected assignment or a function call'
- `mousescroll`: the scroll up wasn't detected
- `runonthread`: the code didn't run on the thread
- `security: your account can't be changed without asking`: AvatarEditorService:NoPromptApplyProfileConfiguration can be called, which lets scripts change your account without asking

**🟠 Skipped**
- `clonefunction`: couldn't be tested because debug.info is missing
- `debug.getproto`: couldn't be tested because debug.info is missing
- `debug.getprotos`: couldn't be tested because debug.info is missing
- `debug.isvalidlevel`: couldn't be tested because debug.info is missing
- `debug.setinfo`: couldn't be tested because debug.info is missing
- `getrawmetatable`: couldn't be tested because debug.info is missing
- `newcclosure`: couldn't be tested because debug.info is missing
- `setstackhidden`: couldn't be tested because debug.info is missing

**🟡 Missing**
- `appendfileasync`
- `debug.info`
- `getactorfromthread`
- `getclipboard`
- `getfilesize`
- `getfunctionreferences`
- `getmenv`
- `getmetafield`
- `getobjectreferences`
- `hasmetafield`
- `hasmetatable`
- `iscorescript`
- `isstackhidden`
- `iswriteable`
- `loadfileasync`
- `makewriteable`
- `movefile`
- `readfileasync`
- `renamefile`
- `saveinstance`
- `trampolinecall`
- `writecustomasset`
- `writefileasync`

</details>

<details>
<summary><b>Synapse Z details</b></summary>

**🔴 Failed**
- `DirectoryWatcher.new`: this crashes Roblox on Synapse Z, so it wasn't run, use shared.CrashTests = true to try it
- `Drawing.new`: expected a Text object's Font after setting it to 3 to be 3, got DrawFont: 0xdb588d1e57bb8030
- `createcommchannel`: expected a number id, got string
- `crypt.encrypt`: invalid argument #2 to 'encrypt' (invalid key size)
- `crypt.hash`: the sha256 hash of 'abc' was wrong, got 89911f71a4508762a5791590153c68a9bbee326969d37b603697a692b3fdf553
- `decompile`: couldn't find '__index' in the decompiled 'CameraModule', it started with '-- Decompiled with Medal thread 'main' (9720) panicked at luau-lifter\src\instruction.rs:174:18: internal error: entered unreachable code: 87 note: run with RUST_BACKTRACE=1 environment variable to display a backtrace '
- `dofile`: expected the value the file returned to be 0.04492459452116232, got File_0.9526678104167149.lua
- `getcommchannel`: expected a number id, got string
- `gethiddenproperties`: expected size_xml to be 10, got nil
- `getproperties`: expected the Size in the returned table to be 3, 4, 1, got nil
- `getscripthash`: should be a 96 character sha384 hash, got 64 characters
- `getsenv`: getsenv returned nil when the parent was nil
- `hooksignal`: returning false from the hook didn't stop the connection from firing
- `isparallel`: should return false in an actor before it desynchronizes
- `mousemoveabs`: the mouse went to 400, 299 instead of 385, 313.5
- `mousemoverel`: the mouse moved by 15, -14 instead of about 25, 25
- `mousescroll`: missing argument #2 to 'mousescroll' (number expected)
- `raknet.receive`: the receive hook didn't see the packet
- `trampolinecall`: expected the line of the fake caller to be 588, got 4235

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
- `isstackhidden`
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
- `dofile`: expected the value the file returned to be 0.9652351747723742, got nil
- `game.HttpGet`: game:HttpGet on a website that doesn't exist should return an error, nil, or an empty string
- `getactorthreads`: expected at least one actor thread
- `getfpscap`: expected the fps cap to be 10, got 0
- `getmodules`: didn't find a new ModuleScript
- `getsignalarguments`: expected the number of arguments Touched has to be 1, got 124
- `getsignalargumentsinfo`: expected the name of Touched's argument to be otherPart, got Instance
- `hooksignal`: returning false from the hook didn't stop the connection from firing
- `identifyexecutor`: the version '2.0' never changes between updates, it should be the real version of each release
- `isparallel`: should return false in an actor before it desynchronizes
- `keyclick`: the key press wasn't detected
- `keypress`: the input wasn't detected
- `keyrelease`: the input was never held down, so it can't be released
- `mousemoveabs`: the mouse went to 346, 261 instead of 391, 310.5
- `mousemoverel`: the mouse moved by 9, -11 instead of about 25, 25
- `raknet.send`: invalid argument #1 to 'send' (string expected, got buffer)
- `replicatesignal`: should error on a signal that can't be replicated
- `saveinstance`: didn't return a string
- `security: your account can't be changed without asking`: AvatarEditorService:NoPromptApplyProfileConfiguration can be called, which lets scripts change your account without asking
- `trampolinecall`: the first value it returns should be whether the call worked, got string instead, so it probably just called the function

**🟠 Skipped**
- `restoresignal`: couldn't be tested because hooksignal failed

**🟡 Missing**
- `DirectoryWatcher.new`
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
