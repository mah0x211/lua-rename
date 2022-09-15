require('luacov')
local assert = require('assert')
local errno = require('errno')
local rmdir = require('rmdir')
local rename = require('rename')

local testcase = {}

function testcase.rename_file()
    local msg = string.format('hello %d', os.time())
    local f = assert(io.open('hello.txt', 'w+'))
    f:write(msg)
    f:close()

    -- test that rename file
    local ok, err = rename('hello.txt', 'world.txt')
    assert.is_true(ok)
    assert.is_nil(err)
    -- confirm
    f = assert(io.open('world.txt', 'r'))
    local data = f:read('*a')
    f:close()
    assert.equal(data, msg)

    -- test that return error if oldname is not exists
    ok, err = rename('not_exist.txt', 'hello.txt')
    assert.is_false(ok)
    assert.equal(err.type, errno.ENOENT)

    -- test that return error if newname is invalid
    local null = string.char(0)
    ok, err = rename('world.txt', 'test/' .. null .. 'hello/world.txt', true)
    assert.is_false(ok)
    assert.equal(err.type, errno.EILSEQ)
    os.remove('world.txt')

    -- test that throws an error if oldname is not string
    err = assert.throws(rename, 1)
    assert.match(err, 'oldname must be non-empty string')

    -- test that throws an error if newname is not string
    err = assert.throws(rename, 'hello.txt', '   ')
    assert.match(err, 'newname must be non-empty string')

    -- test that throws an error if parents is not boolean
    err = assert.throws(rename, 'hello.txt', 'world.txt', {})
    assert.match(err, 'parents must be boolean')
end

function testcase.rename_file_into_dir()
    local msg = string.format('hello %d', os.time())
    local f = assert(io.open('hello.txt', 'w+'))
    f:write(msg)
    f:close()

    -- test that rename file
    local ok, err = rename('hello.txt', 'test/foo/bar/hello/world.txt', true)
    assert.is_true(ok)
    assert.is_nil(err)
    -- confirm
    f = assert(io.open('test/foo/bar/hello/world.txt', 'r'))
    local data = f:read('*a')
    f:close()
    os.remove('test/foo/bar/hello/world.txt')
    rmdir('test/foo', true)
    assert.equal(data, msg)
end

for fname, func in pairs(testcase) do
    local ok, err = xpcall(func, debug.traceback)
    if not ok then
        print(string.format('%s failed', fname))
        print(err)
    else
        print(string.format('%s ok', fname))
    end
end
