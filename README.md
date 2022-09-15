# lua-rename

[![test](https://github.com/mah0x211/lua-rename/actions/workflows/test.yml/badge.svg)](https://github.com/mah0x211/lua-rename/actions/workflows/test.yml)
[![codecov](https://codecov.io/gh/mah0x211/lua-rename/branch/master/graph/badge.svg)](https://codecov.io/gh/mah0x211/lua-rename)

change the name of a file.

## Installation

```
luarocks install rename
```

## Usage

```lua
local rename = require('rename')
assert(rename('hello.txt', 'hello/world.txt', true))
```

## Error Handling

the following functions return the `error` object created by https://github.com/mah0x211/lua-errno module.


## ok, err = rename( oldname, newname [, parents] )

change the name of a file.

**Parameters**

- `oldname:string`: pathname of the target file or directory.
- `newname:string`: pathname of the new file or diretory.
- `parents:boolean`: make parent directories as needed. (default: `false`)

**Returns**

- `ok:boolean`: `true` on success.
- `err:error`: error object.
