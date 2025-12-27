{$lua}

--[[
========================================================================
==== ACE COMBAT 6: FIRES OF LIBERATION - BASE ADDRESS FINDER SCRIPT ====
========================================================================
By death_the_d0g (death_the_d0g @ Twitter and deaththed0g @ Github)
This script was written in and is best viewed on Notepad++.
v271125

---out game 2080374784
--- in game 2164260864
]]

setMethodProperty(getMainForm(), "OnCloseQuery", nil) -- Disable CE's save prompt.

[ENABLE]

if syntaxcheck then return end

---------------------+
---- [FUNCTIONS] ----+
---------------------+

-- Memory scanner
local function memscan_func(scanoption, vartype, roundingtype, input1, input2, startAddress, stopAddress, protectionflags, alignmenttype, alignmentparam, isHexadecimalInput, isNotABinaryString, isunicodescan, iscasesensitive)

	local memory_scan = createMemScan()
	memory_scan.firstScan(scanoption, vartype, roundingtype, input1, input2 ,startAddress ,stopAddress ,protectionflags ,alignmenttype, alignmentparam, isHexadecimalInput, isNotABinaryString, isunicodescan, iscasesensitive)
	memory_scan.waitTillDone()
	local found_list = createFoundList(memory_scan)
	found_list.initialize()

	local address_list = {}

	if (found_list ~= nil) then

		for i = 1, found_list.count do

			address_list[#address_list + 1] = getAddress(found_list[i - 1])

		end

	end

	found_list.deinitialize()
	found_list.destroy()
	found_list = nil

	return address_list

end

-- Check current version and amount of active instances of PCSX2, set working RAM region.
local function xenia_check()

	XENIA_AC6_RAM = nil
	local process_found = {}

	for processID, processName in pairs(getProcessList()) do

		if processName == "xenia_canary.exe" then

			process_found[#process_found + 1] = processName
			process_found[#process_found + 1] = processID

		end

	end

	if #process_found ~= 0 then

		if #process_found == 2 then

			if (process_found[2] == getOpenedProcessID()) then

				local tempScan = memscan_func(soExactValue, vtByteArray, nil, "4D 5A 90 00 03 00 00 00 04 00 00 00 FF FF 00 00 B8 00 00 00 00 00 00 00 40 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 10 01 00 00 0E 1F BA 0E 00 B4 09 CD 21 B8 01 4C CD 21 54 68 69 73 20 70 72 6F 67 72 61 6D 20 63 61 6E 6E 6F 74 20 62 65 20 72 75 6E 20 69 6E 20 44 4F 53 20 6D 6F 64 65 2E 0D 0D 0A 24 00 00 00 00 00 00 00", nil, 0x0, 0x7FFFFFFFF, "", 2, "0", true, nil, nil, nil)

				if #tempScan ~= 0 then

					XENIA_AC6_RAM = tempScan[2]

				else

					error_flag = 3

				end

			else

				error_flag = 1

			end

		else

			error_flag = 2

		end

	else

		error_flag = 1

	end

	return {XENIA_AC6_RAM, error_flag}

end

-- Base address finder script.
function AC6mainCheck_outSortieCheck(AC6mainCheck_outSortieCheckTimer)

	-- Run script as long the emulator is up.
	if readInteger(XENIAMEM_AC6mainCheck[1]) ~= nil then

		-- If the player is in a mission then scan for the array needed by the other scripts.
		if readInteger(XENIAMEM_AC6mainCheck[1] + 0x8C98C0) == 2164260864 then

			-- Pause "out-of-mission" script and pause emulator.
			AC6mainCheck_outSortieCheckTimer.Enabled = false
			pause(getOpenedProcessID())

			-- Scan for the bytearray.
			AC6paramAddress = memscan_func(soExactValue, vtByteArray, nil, "00 00 00 00 00 00 00 40 82 05 C? ?0 ?? ?? ?? ?? ?? ?? ?? ?? ?? ?? ?? ?? ?? ?? ?? ?? ?? ?? ?? ?? ?? ?? ?? ?? ?? ?? ?? ?? ?? ?? ?? ?? ?? ?? ?? ?? ?? ?? ?? ?? ?? ?? ?? ?? ?? ?? ?? ?? ?? ?? ?? ?? ?? ?? ?? ?? ?? ?? ?? ?? ?? ?? ?? ?? ?? ?? ?? ?? ?? ?? ?? ?? ?? ?? ?? ?? ?? ?? ?? ?? ?? ?? ?? ?? ?? ?? ?? ?? ?? ?? ?? ?? ?? ?? ?? ?? ?? ?? ?? ?? ?? ?? ?? ?? ?? ?? ?? ?? ?? ?? ?? ?? ?? ?? ?? ?? ?? ?? ?? ?? ?? ?? ?? ?? ?? ?? ?? ?? ?? ?? ?? ?? ?? ?? ?? ?? ?? ?? ?? ?? ?? ?? ?? ?? ?? ?? ?? ?? ?? ?? ?? ?? ?? ?? ?? ?? ?? ?? ?? ?? ?? ?? ?? ?? ?? ?? ?? ?? ?? ?? ?? ?? ?? ?? ?? ?? ?? ?? ?? ?? ?? ?? ?? ?? ?? ?? ?? ?? ?? ?? ?? ?? ?? ?? ?? ?? ?? ?? ?? ?? ?? ?? ?? ?? ?? ?? ?? ?? ?? ?? ?? ?? ?? ?? ?? ?? ?? ?? ?? ?? 82 05 C? ?4", nil, XENIAMEM_AC6mainCheck[1], XENIAMEM_AC6mainCheck[1] + 0x20000000, "", 2, "0", true, nil, nil, nil)[1]

			-- "in-mission" check script.
			function AC6mainCheck_inSortieCheck(AC6mainCheck_inSortieCheckTimer)

				-- Run function as long the emulator is up.
				if readInteger(XENIAMEM_AC6mainCheck[1]) ~= nil then

					-- Pause the "in-mission" checker script, resume the "out-of-mission" checker script if the player is not in a mission.
					-- Clear address variable if the player has exited the mission.
					if readInteger(XENIAMEM_AC6mainCheck[1] + 0x8C98C0) ~= 2164260864 then

						AC6paramAddress = nil

						AC6mainCheck_inSortieCheckTimer.Enabled = false

						AC6mainCheck_outSortieCheckTimer.Enabled = true

					end

				else

					getAddressList().getMemoryRecordByDescription("Click here to start").Active = false

				end

			end

			-- Start the "in-mission" checker script, resume if a timer object was found.
			if AC6mainCheck_inSortieCheck_Timer == nil then

				AC6mainCheck_inSortieCheck_Timer = createTimer()
				AC6mainCheck_inSortieCheck_Timer.Interval = 500
				AC6mainCheck_inSortieCheck_Timer.onTimer = AC6mainCheck_inSortieCheck
				AC6mainCheck_inSortieCheck_Timer.Enabled = true

				unpause(getOpenedProcessID())

			else

				AC6mainCheck_inSortieCheck_Timer.Enabled = true

				unpause(getOpenedProcessID())

			end

		end

	else

		getAddressList().getMemoryRecordByDescription("Click here to start").Active = false

	end

end

-----------------+
---- [CHECK] ----+
-----------------+

-- Check how many instances of PCSX2 are running, the current version of the emulator and if it has a game loaded.
-- Set the working RAM region ranges based on emulator version.
XENIAMEM_AC6mainCheck = xenia_check()

-- Proceed with the rest of the script if all checks were passed.
if (XENIAMEM_AC6mainCheck[1] ~= nil) then

	IsAC6mainCheckEnabled = true

else

	if XENIAMEM_AC6mainCheck[2] == 1 then

		showMessage("<< Attach this table to a running instance of Xenia Canary first. >>")

	elseif XENIAMEM_AC6mainCheck[2] == 2 then

		showMessage("<< Multiple instances of Xenia were detected. Only one is needed. >>")

	elseif XENIAMEM_AC6mainCheck[2] == 3 then

		showMessage("<< Xenia has no ISO file loaded or game you are emulating is not 'Ace Combat 6'. >>")

	end

end

----------------+
---- [MAIN] ----+
----------------+

if IsAC6mainCheckEnabled then

	-- Create a timer object for the function that will check for the game status
	-- and scan its memory for the required data.
	AC6mainCheck_outSortieCheck_Timer = createTimer()
	AC6mainCheck_outSortieCheck_Timer.Interval = 500
	AC6mainCheck_outSortieCheck_Timer.onTimer = AC6mainCheck_outSortieCheck
	AC6mainCheck_outSortieCheck_Timer.Enabled = true

end

[DISABLE]

if syntaxcheck then return end

-- Destroy active timer objects, restore modified data and clear flags on script deactivation.
if IsAC6mainCheckEnabled then

	if AC6mainCheck_inSortieCheck_Timer ~= nil then

		AC6mainCheck_inSortieCheck_Timer.destroy()
		AC6mainCheck_inSortieCheck_Timer = nil

	end

	if AC6mainCheck_outSortieCheck_Timer ~= nil then

		AC6mainCheck_outSortieCheck_Timer.destroy()
		AC6mainCheck_outSortieCheck_Timer = nil

	end

	AC6mainCheck_dataList = nil
	IsAC6mainCheckEnabled = nil

	AC6paramAddress = nil

end

XENIAMEM_AC6mainCheck = nil