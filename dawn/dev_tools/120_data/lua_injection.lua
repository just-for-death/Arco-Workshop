--[[
Sample output: https://pastebin.com/raw/ciay6HXj

File name: "no message" (no extension)

Instructions:
	Symlink this file into the GI working directory
	That's usually where GenshinImpact.exe is.

Function description:
	sb_1184180413  c-call function with args

Hints for modifying this script:
	1) There is mostly no error handling in GI!
	2) Run the script in Lua CLI (i.e. 'lua "no message"') to check for syntax errors
	3) Uncomment functions until you see basic log information again
]]

local HOOK_RECURSIVE = true -- more precise hooks, but may stall the game
local DUMP_ON_XPCALL = true -- xpcall is called once after login. dump _G there

local LH = {} -- file-wide access

local function dump(val, depth, seen)
	depth = depth or 0
	seen = seen or {}
	if seen[val] then return "<CIRCULAR REF>" end
	if depth > 10 then return "<TOO DEEP>" end
	if val == nil then return "nil" end

	local txt = {}
	if type(val) == "table" then
		seen[val] = true
		txt[#txt + 1] = "{"
		for k, v in pairs(val) do
			txt[#txt + 1] = string.rep("\t", depth + 1) ..
				("[\"%s\"] = %s"):format(tostring(k), dump(v, depth + 1, seen))
		end
		txt[#txt + 1] = string.rep("\t", depth) .. "}"
	elseif type(val) == "string" then
		txt[#txt + 1] =  '"' .. val:gsub('\n', "$LF"):gsub('"', '\\"') .. '"'
	else
		txt[#txt + 1] = tostring(val) 
	end
	return table.concat(txt, "\n")
end

local sb_c_exec, sb_alt_time = sb_1184180413, os.time
LH.get_time = function()
	if true or not sb_c_exec then
		-- Special func missing (for script dry run)
		return sb_alt_time()
	end
	-- I don't know why, but os.time() yields better results
	return sb_c_exec("GetTickCount64") / 1000
end

local F = io.open("lualog_" .. os.date("%H%M-%S") .. ".txt", "a")
F:write("=== LOG START: " .. os.date() .. "\n")

local start_time = LH.get_time()
local function LOG(msg)
	if LH and LH.get_time then
		F:write(("[%.2f] "):format(LH.get_time() - start_time))
	end
	F:write(msg)
	F:write("\n")
	F:flush() -- Causes delays but that's okay
end

-- HOOK FUNCTIONS
table.unpack = table.unpack or unpack -- Lua compatibility

local function hook_wrapper(func, name, ...)
	-- These must not be logged -> deadlock
	local no_log = (name == "getmetatable" or name == "setmetatable"
		or name == "rawset" or name == "rawget")

	LOG(("> CALL %s = %s"):format(name, no_log and "<>" or dump({...}, 1)))
	local ret_vals = {func(...)}
	LOG(("< RET  %s = %s"):format(name, no_log and "<>" or dump(ret_vals, 1)))

	LH.interval_func()

	if DUMP_ON_XPCALL and name == "xpcall" then
		LOG("=== XPCALL!!")
		LOG(dump(_G))
	end
	return table.unpack(ret_vals)
end

local hooked = {}
local recursion_depth = 0
local function hook_recursive(tb, name, v, path_text, seen)
	path = path or ""
	v = v or tb[name] or tb
	path_text = path_text or ""

	if not seen and recursion_depth > 0 then
		return -- Recursion still ongoing
	end
	seen = seen or {} -- For circular references

	-- If a custom table is provided, hook all functions
	if type(v) == "table" then
		if not HOOK_RECURSIVE and v ~= _G then
			return
		end

		if seen[v] or v == table or v == io or v == math
				or v == package.searchers
				or v == debug or v == string then
			return
		end

		-- Traverse table to hook all functions
		recursion_depth = recursion_depth + 1
		seen[v] = true
		for k2, v2 in pairs(v) do
			if type(v2) == "table" then
				hook_recursive(v, k2, v2, path_text .. k2 .. ".", seen)
			else
				hook_recursive(v, k2, v2, path_text, seen)
			end
		end
		recursion_depth = recursion_depth - 1
		return
	end

	if hooked[v] or type(v) ~= "function" then
		return
	end

	-- Do not hook common functions to avoid recursion
	local k = name
	if k == "tostring" or k == "tonumber" or k == "type" or k == "typeof"
			or k == "ipairs" or k == "pairs" or k == "next" or k == "select"
			or k == "rawget" or k == "getmetatable"
			or k == "print" then
		return
	end
	LOG("HOOK " .. path_text .. name)
	tb[name] = function(...)
		return hook_wrapper(v, path_text .. name, ...)
	end
	hooked[tb[name]] = true
end


-- INTERVAL-TRIGGERED FUNCTIONS

local last_time = 0
local func_locked = false
local my_pcall = pcall -- Not hooked
local my_sethook = debug.sethook

LH.cfuncs = {}
LH.ctimers = {}
LH.interval_func = function()
	if func_locked then return end

	my_sethook(LH.interval_func, "r", 1E10)

	local new_time = LH.get_time()
	if new_time < last_time + 0.1 then
		return
	end
	-- Lock it to avoid recursion deadlocks
	func_locked = true
	last_time = new_time

	hook_recursive(_G)

	LOG("==> Running " .. #LH.cfuncs .. " callbacks")
	for i, func in ipairs(LH.cfuncs) do
		local due = LH.ctimers[i] or 0
		if due <= new_time then
			-- Trigger it!
			local ok, delay = my_pcall(func)
			if not ok then
				LOG("==> Callback error:")
				LOG(delay)
				-- Retry later
				delay = nil
			end

			-- Trigger again in at least X or 10 seconds
			LH.ctimers[i] = new_time + (delay or 13)
		end
	end

	func_locked = false
end

local function reg_interval_func(start_delay, func)
	LH.cfuncs[#LH.cfuncs + 1] = func
	LH.ctimers[#LH.cfuncs] = LH.get_time() + (start_delay or 0)
end

reg_interval_func(0.1, function()
	-- This is pretty huge.
	LOG("=== DUMP OF _G")
	LOG(dump(_G))
	return 99 -- never again
end)

reg_interval_func(0, function()
	if not sb_75657375 then
		return 0 -- Call asap again
	end

	-- Use launch arg "-nolog" to see this (Linux)
	io.stdout:write(">>> CALLING FUNCTIONS\n")

	local ok, pkg = pcall(require, "Hotfix/Hotfix")
	if okg then
		pkg.PrintTime()
		LOG(dump(pkg.GetPatchTable()))
	end

	local ok, console = pcall(require, "Console")
	if ok then
		--[[
			"ConsolePrint"
			"onSocketData"
			"onSocketConnected"
			"socketCrFunc"
		]]
	end
	--[[if xlua then
		xlua.load_assembly("")
	end]]
	return 0.1
end)


-- FINAL: SET HOOK READY, START FUNCS
LH.interval_func()
