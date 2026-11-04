# debUNC (debunk Unified Naming Convention)
like sUNC and UNC but better (sens if u see this look out ur window)

feel free to make an issue or PR whenever you have a suggestion, bug, or feedback you think would improve your use of this

all custom functions that debUNC tests are documented in [Documentation](Documentation)

reasons why i made this:
1. sUNC is obfuscated, sure u can ask the developers for the source code in order to debug but that's just a unnecessary step
2. sUNC's tests fail even though the function works, which atp what is the test even for?
3. sUNC and UNC don't test ALL of the functions many scripts use, only the most necessary, which makes it so even with a 100% score it's not supporting every script's function use
4. sUNC and UNC don't display the executor's version in test results, making it easy for people to misinform with outdated results
5. sUNC and UNC aren't made by me (i want to be famous)
# Loadstring
```lua
loadstring(game:HttpGet("https://github.com/alyssagithub/debUNC/raw/main/debUNC.luau"))()
```
# Confirmed results (debUNC v2.2.0)
![Lucid](https://img.shields.io/badge/Lucid_1.0.3--build18-98%25-brightgreen?style=for-the-badge)

![Synapse Z](https://img.shields.io/badge/Synapse_Z_v1.0.3.9-84%25-yellow?style=for-the-badge)

| Executor | Version | Score | 🟢 Passed | 🔴 Failed | 🟠 Skipped | 🟡 Missing |
|---|---|:---:|:---:|:---:|:---:|:---:|
| Lucid | 1.0.3-build18 | **98%** | 206 | 1 | 0 | 2 |
| Synapse Z | v1.0.3.9 | **84%** | 176 | 13 | 1 | 19 |

<details>
<summary><b>Lucid details</b></summary>

**🔴 Failed**
- `getactors`: returns threads instead of Actor instances

**🟡 Missing**
- `getfunctionreferences`
- `getobjectreferences`

</details>

<details>
<summary><b>Synapse Z details</b></summary>

**🔴 Failed**
- `createcommchannel`: the id is a string instead of a number
- `crypt.encrypt`: rejects keys from `crypt.generatekey`
- `crypt.hash`: wrong SHA-256 result
- `dofile`: returns the file name first
- `Drawing.new`: a Text object's `Font` reads back as an object instead of a number
- `getcommchannel`: the id is a string instead of a number, and it doesn't return the same channel
- `getproperties`: returns property names without their values
- `getscripthash`: the hash is 64 characters instead of a 96 character SHA-384
- `getsenv`: returns nil for a running script whose parent was set to nil
- `hooksignal`: returning false from the hook doesn't stop the connection from firing
- `mousemoveabs`: the mouse didn't reach the target
- `mousescroll`: needs a second argument
- `raknet.receive`: the receive hook didn't see the packet

**🟠 Skipped**
- `crypt.decrypt`: needs `crypt.encrypt`

**🟡 Missing**
- `appendfileasync`
- `clearqueueonteleport`
- `comparefunctions`
- `crypt.hmac`
- `getactorfromthread`
- `getactorthreads`
- `getmenv`
- `getmetafield`
- `getmodules`
- `getsignalwhitelist`
- `getthreadenvironment`
- `hasmetafield`
- `hasmetatable`
- `loadfileasync`
- `readfileasync`
- `runfile`
- `saveinstance`
- `writecustomasset`
- `writefileasync`

</details>
