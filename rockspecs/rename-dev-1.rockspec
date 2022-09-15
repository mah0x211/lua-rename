package = "rename"
version = "dev-1"
source = {
    url = "git+https://github.com/mah0x211/rename.git",
}
description = {
    summary = "change the name of a file.",
    homepage = "https://github.com/mah0x211/rename",
    license = "MIT/X11",
    maintainer = "Masatoshi Fukunaga",
}
dependencies = {
    "lua >= 5.1",
    "errno >= 0.3.0",
    "fstat >= 0.2.2",
    "mkdir >= 0.2.2",
    "string-split >= 0.3.0",
}
build = {
    type = "builtin",
    modules = {
        rename = "rename.lua",
    },
}
