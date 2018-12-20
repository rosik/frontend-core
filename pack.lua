#!/usr/bin/env tarantool

local log = require('log')
local fio = require('fio')
local ffi = require('ffi')
local json = require('json')

local src_json = arg[1]
local dst_name = arg[2]

if not src_json or not dst_name then
    error("Usage: pack.lua SRC.json DST.lua")
end

local abspath = fio.abspath(src_json)
assert(fio.stat(abspath), 'Error: can not pack %s: file does not exist')

log.info('-- Pack %s', abspath)
local f = io.open(abspath, "r")
local body = f:read('*a')
f:close()

local function pack(value)
    if type(value) == 'string' then
        return string.format('%q', value)
    elseif type(value) == 'boolean' then
        return tostring(value)
    elseif type(value) == 'number' then
        return tostring(value)
    elseif value == nil then
        return 'box.NULL'
    elseif type(value) == 'table' then
        local ret = {}
        for k, v in pairs(value) do
            table.insert(ret, string.format("[%s] = %s", pack(k), pack(v)))
        end
        return string.format('{\n%s\n}', table.concat(ret, ',\n'))
    else
        error(string.format('Can not pack %s %q', type(value), value))
    end
end


local function deepcmp(got, expected, extra)
    if extra == nil then
        extra = {}
    end

    if type(expected) == "number" or type(got) == "number" then
        extra.got = got
        extra.expected = expected
        if got ~= got and expected ~= expected then
            return true -- nan
        end
        return got == expected
    end

    if ffi.istype('bool', got) then got = (got == 1) end
    if ffi.istype('bool', expected) then expected = (expected == 1) end
    if got == nil and expected == nil then return true end

    if type(got) ~= type(expected) then
        extra.got = type(got)
        extra.expected = type(expected)
        return false
    end

    if type(got) ~= 'table' then
        extra.got = got
        extra.expected = expected
        return got == expected
    end

    local path = extra.path or '/'

    for i, v in pairs(got) do
        extra.path = path .. '/' .. i
        if not deepcmp(v, expected[i], extra) then
            return false
        end
    end

    for i, v in pairs(expected) do
        extra.path = path .. '/' .. i
        if not deepcmp(got[i], v, extra) then
            return false
        end
    end

    extra.path = path

    return true
end


local data = json.decode(body)
local mod_str = string.format('return %s', pack(data))
assert(deepcmp(data, loadstring(mod_str)()))
log.info('-- Save %s', dst_name)

log.info('Total: %.0f KiB', (#mod_str)/1024)

local f = assert(io.open(dst_name, "wb"))
assert(f:write(mod_str))
assert(f:close())
os.exit(0)
