--
-- Copyright (C) 2022 Masatoshi Fukunaga
--
-- Permission is hereby granted, free of charge, to any person obtaining a copy
-- of this software and associated documentation files (the "Software"), to deal
-- in the Software without restriction, including without limitation the rights
-- to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
-- copies of the Software, and to permit persons to whom the Software is
-- furnished to do so, subject to the following conditions:
--
-- The above copyright notice and this permission notice shall be included in
-- all copies or substantial portions of the Software.
--
-- THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
-- IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
-- FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT.  IN NO EVENT SHALL THE
-- AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
-- LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
-- OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN
-- THE SOFTWARE.
--
local concat = table.concat
local match = string.match
local gsub = string.gsub
local os_rename = os.rename
local type = type
local new_errno = require('errno').new
local fstat = require('fstat')
local mkdir = require('mkdir')
local split = require('string.split')

--- check_filename
--- @param filename any
local function check_filename(filename)
    if type(filename) == 'string' then
        -- trim spaces
        filename = match(filename, '^%s*(.-)%s*$')
        -- remove multiple slashes
        filename = gsub(filename, '/+', '/')
        if #filename > 0 then
            return filename
        end
    end
end

--- rename
--- @param oldname string
--- @param newname string
--- @param parents boolean|nil
--- @return boolean ok
--- @return any err
local function rename(oldname, newname, parents)
    oldname = check_filename(oldname)
    newname = check_filename(newname)
    if not oldname then
        error('oldname must be non-empty string', 2)
    elseif not newname then
        error('newname must be non-empty string', 2)
    elseif parents ~= nil and type(parents) ~= 'boolean' then
        error('parents must be boolean', 2)
    end

    -- check existing
    local stat, err = fstat(oldname)
    if not stat then
        return false, err
    end

    -- create parent directories
    if parents then
        local segments = split(newname, '/')
        if #segments > 1 then
            local dirname = concat(segments, '/', 1, #segments - 1)
            local ok
            ok, err = mkdir(dirname, nil, true)
            if not ok then
                return false, err
            end
        end
    end

    local ok, eno
    ok, err, eno = os_rename(oldname, newname)
    if not ok then
        return new_errno(eno, nil, 'rename')
    end
    return true
end

return rename
