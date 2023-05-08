# Installation

You can install zero_utils in two ways:
1. Download: You can download the script [Here](https://github.com/Austinb96/zero_utils/archive/refs/heads/master.zip).
2. Git Clone: Alternatively, you can use Git to clone the repository directly into your resources folder.
```bash
git clone https://github.com/Austinb96/zero_utils.git

--then you can update simply with
git pull
```

To install zero_utils, simply add it into your resources and ensure that it's loaded before any scripts that use zero_utils and after [qb].
```lua
ensure [qb]
ensure [standalone]
ensure [voice]
ensure [defaultmaps]

ensure zero_utils
--scripts that uses zero_utils --
```


# Developers

To access zero_utils functions, you can export it like so:
```lua
exports.zero_utils:GetForwardVector(180)

--or you can do something like this
--I would also put this in shared.lua

ZeroUtils = exports.zero_utils
ZeroUtils:GetForwardVector(180)
```

All functions will default to QB, so to overwrite them you can either change them inside zero_utils or use the SetUp function.
```lua
Config = {
    Notify = "QB",
    Inventory = "QB",
    Menu = "QB",
    ...ect
}
ZeroUtils:SetUp(Config)

--or

ZeroUtils:SetUp({
    Notify = "QB",
    Inventory = "QB",
    Menu = "QB",
    ...ect
})
```
### VSCode Autocomplete

To get autocomplete inside VSCode, you can add the following to your .vscode/settings.json file:
```json
{
  "Lua.workspace.library": [
    "/path/to/server/txData/QBCore/resources/zero_utils"
  ],
}
```

## PrintUtils
To use PrintUtils, you can use it like so:
```lua
PrintUtils = exports.zero_utils:GetPrintUtils(true or false) --pass in your bool for any debug
Color = PrintUtils.GetColors() --just a table of colors you can use

PrintUtils.PrintDebug("This is a test Debug") --will print a debug based off the bool you passed in earlier
PrintUtils.Print("Color Change", Color.Green) --will change the color of text to Green
```

There are a lot of different ways to use this. You can open Shared/Utils/PrintUtils.lua to see everything available.








