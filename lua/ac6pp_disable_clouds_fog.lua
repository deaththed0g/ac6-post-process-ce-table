{$lua}

--[[
======================================================================
==== ACE COMBAT 6: FIRES OF LIBERATION - REMOVE FOG/CLOUDS SCRIPT ====
======================================================================
By death_the_d0g (death_the_d0g @ Twitter and deaththed0g @ Github)
This script was written in and is best viewed on Notepad++.
v211225
]]

setMethodProperty(getMainForm(), "OnCloseQuery", nil) -- Disable CE's save prompt.

[ENABLE]

if syntaxcheck then return end

---------------------+
---- [FUNCTIONS] ----+
---------------------+

-- Fog/cloud modifier script
function AC6paramMulti_outSortieCheck(AC6paramMulti_outSortieCheckTimer)

	-- Run script as long the [CLICK HERE START] script is active.
	if IsAC6mainCheckEnabled then

		-- If the "AC6paramAddress" variable contains an address then read its value.
		-- Else skip function until the players enters a mission again which in turn
		-- a new address will be assigned to this variable.
		if readInteger(AC6paramAddress) ~= nil then

			-- If the player is in a mission then proceed to modify data.
			if readInteger(XENIAMEM_AC6mainCheck[1] + 0x8C98C0) == 2164260864 then

				-- Pause "out-of-mission" checker script.
				AC6paramMulti_outSortieCheckTimer.Enabled = false

				-- Clear table, get the parameters addresses, read and store original values.
				for k, v in pairs(AC6paramMulti_dataList) do AC6paramMulti_dataList[k] = nil end

				-- Draw distance/fog parameters
				AC6paramMulti_dataList[#AC6paramMulti_dataList + 1] = AC6paramAddress - 0x73B9C
				AC6paramMulti_dataList[#AC6paramMulti_dataList + 1] = readBytes(AC6paramAddress - 0x73B9C, 0x8, true)

				-- Ground specular parameters?
				AC6paramMulti_dataList[#AC6paramMulti_dataList + 1] = AC6paramMulti_dataList[1] + 0x6C
				AC6paramMulti_dataList[#AC6paramMulti_dataList + 1] = readBytes(AC6paramMulti_dataList[1] + 0x6C, 0x40, true)

				-- Object LoD bias?
				AC6paramMulti_dataList[#AC6paramMulti_dataList + 1] = AC6paramMulti_dataList[1] + 0x1824
				AC6paramMulti_dataList[#AC6paramMulti_dataList + 1] = readBytes(AC6paramMulti_dataList[1] + 0x1824, 0xC, true)

				-- Shadow cloudmap parameter
				AC6paramMulti_dataList[#AC6paramMulti_dataList + 1] = AC6paramMulti_dataList[1] + 0x1084C
				AC6paramMulti_dataList[#AC6paramMulti_dataList + 1] = readBytes(AC6paramMulti_dataList[1] + 0x1084C, 0xC, true)

				-- Clouds and rain/blizzard particle parameters
				AC6paramMulti_dataList[#AC6paramMulti_dataList + 1] = AC6paramMulti_dataList[1] + 0x1C6A74
				AC6paramMulti_dataList[#AC6paramMulti_dataList + 1] = readBytes(AC6paramMulti_dataList[1] + 0x1C6A74, 0x4, true)
				AC6paramMulti_dataList[#AC6paramMulti_dataList + 1] = AC6paramMulti_dataList[1] + 0x1C6A7C
				AC6paramMulti_dataList[#AC6paramMulti_dataList + 1] = readBytes(AC6paramMulti_dataList[1] + 0x1C6A7C, 0x4, true)

				-- Unknown
				AC6paramMulti_dataList[#AC6paramMulti_dataList + 1] = AC6paramMulti_dataList[1] + 0xFD2BC
				AC6paramMulti_dataList[#AC6paramMulti_dataList + 1] = readBytes(AC6paramMulti_dataList[1] + 0xFD2BC, 0x4, true)

				-- Draw distance/fog parameters, second set
				AC6paramMulti_dataList[#AC6paramMulti_dataList + 1] = AC6paramMulti_dataList[1] + 0x320
				AC6paramMulti_dataList[#AC6paramMulti_dataList + 1] = readBytes(AC6paramMulti_dataList[1] + 0x320, 0x8, true)

				-- Write custom data.
				writeBytes(AC6paramMulti_dataList[1], {0x47, 0xC8, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00})
				writeBytes(AC6paramMulti_dataList[3], {0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00})
				writeBytes(AC6paramMulti_dataList[5], {0x47, 0xC8, 0x00, 0x00, 0x47, 0xC8, 0x00, 0x00, 0x47, 0xC8, 0x00, 0x00})
				writeBytes(AC6paramMulti_dataList[7], {0x00, 0x00, 0x00, 0x00})
				writeBytes(AC6paramMulti_dataList[9], {0xC7, 0xC8, 0x00, 0x00})
				writeBytes(AC6paramMulti_dataList[11], {0xC7, 0xC8, 0x00, 0x00})
				writeBytes(AC6paramMulti_dataList[13], {0x47, 0xC8, 0x00, 0x00})
				writeBytes(AC6paramMulti_dataList[15], {0x47, 0xC8, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00})

				-- "in-mission" check script.
				function AC6paramMulti_inSortieCheck(AC6paramMulti_inSortieCheckTimer)

					-- Run function as long the "Click here to start" script is active.
					if IsAC6mainCheckEnabled then

						-- Pause the "in-mission" checker script, resume the "out-of-mission" checker script if the player is not in a mission.
						if readInteger(XENIAMEM_AC6mainCheck[1] + 0x8C98C0) == 2164260864 then

							local function AC6paramMulti_writeValue()

								writeBytes(AC6paramMulti_dataList[1], {0x47, 0xC8, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00})
								writeBytes(AC6paramMulti_dataList[3], {0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00})
								writeBytes(AC6paramMulti_dataList[5], {0x47, 0xC8, 0x00, 0x00, 0x47, 0xC8, 0x00, 0x00, 0x47, 0xC8, 0x00, 0x00})
								writeBytes(AC6paramMulti_dataList[7], {0x00, 0x00, 0x00, 0x00})
								writeBytes(AC6paramMulti_dataList[9], {0xC7, 0xC8, 0x00, 0x00})
								writeBytes(AC6paramMulti_dataList[11], {0xC7, 0xC8, 0x00, 0x00})
								writeBytes(AC6paramMulti_dataList[13], {0x47, 0xC8, 0x00, 0x00})
								writeBytes(AC6paramMulti_dataList[15], {0x47, 0xC8, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00})

							end

							-- Create a timer that calls the function above every 5 seconds
							-- to write the modified data in case the player resets the mission.
							-- The parameters are reset to their default value every time the mission is restarted.
							if AC6paramMulti_writeValue_Timer == nil then

								AC6paramMulti_writeValue_Timer = createTimer()
								AC6paramMulti_writeValue_Timer.Interval = 5000
								AC6paramMulti_writeValue_Timer.onTimer = AC6paramMulti_writeValue
								AC6paramMulti_writeValue_Timer.Enabled = true

							end

						else

							-- Destroy timer object that was created to write data every 5 seconds.
							if AC6paramMulti_writeValue_Timer ~= nil then

								AC6paramMulti_writeValue_Timer.destroy()
								AC6paramMulti_writeValue_Timer = nil

							end

							-- Pause the "out-of-mission"  checker script, resume the "in-mission" checker script if the player is not in a mission.
							AC6paramMulti_inSortieCheckTimer.Enabled = false

							AC6paramMulti_outSortieCheckTimer.Enabled = true

						end

					else

						getAddressList().getMemoryRecordByDescription("Remove fog and clouds").Active = false

					end

				end

				-- Start the "in-mission" checker script, resume if a timer object was found.
				if AC6paramMulti_inSortieCheck_Timer == nil then

					AC6paramMulti_inSortieCheck_Timer = createTimer()
					AC6paramMulti_inSortieCheck_Timer.Interval = 500
					AC6paramMulti_inSortieCheck_Timer.onTimer = AC6paramMulti_inSortieCheck
					AC6paramMulti_inSortieCheck_Timer.Enabled = true

				else

					AC6paramMulti_inSortieCheck_Timer.Enabled = true

				end

			end

		end

	else

		getAddressList().getMemoryRecordByDescription("Remove fog and clouds").Active = false

	end

end


-----------------+
---- [CHECK] ----+
-----------------+

-- Proceed with the rest of the script if the [CLICK HERE TO START] script is enabled.
if IsAC6mainCheckEnabled then

	IsAC6paramMultiEnabled = true

else

	showMessage("<< Enable the [CLICK HERE TO START] script first! >>")

end

----------------+
---- [MAIN] ----+
----------------+

if IsAC6paramMultiEnabled then

	-- Initialize a table to store address and values.
	AC6paramMulti_dataList = {}

	-- Create the timer object if the player is in or out of a mission.
	AC6paramMulti_outSortieCheck_Timer = createTimer()
	AC6paramMulti_outSortieCheck_Timer.Interval = 500
	AC6paramMulti_outSortieCheck_Timer.onTimer = AC6paramMulti_outSortieCheck
	AC6paramMulti_outSortieCheck_Timer.Enabled = true

end

[DISABLE]

if syntaxcheck then return end

-- Destroy active timer objects, restore modified data and clear flags on script deactivation.
if IsAC6paramMultiEnabled then

	if AC6paramMulti_writeValue_Timer ~= nil then

		AC6paramMulti_writeValue_Timer.destroy()
		AC6paramMulti_writeValue_Timer = nil

	end

	if AC6paramMulti_inSortieCheck_Timer ~= nil then

		AC6paramMulti_inSortieCheck_Timer.destroy()
		AC6paramMulti_inSortieCheck_Timer = nil

	end

	if AC6paramMulti_outSortieCheck_Timer ~= nil then

		AC6paramMulti_outSortieCheck_Timer.destroy()
		AC6paramMulti_outSortieCheck_Timer = nil

	end

	if readInteger(AC6paramMulti_dataList[1]) ~= nil then

		for i = 1, #AC6paramMulti_dataList, 2 do

			writeBytes(AC6paramMulti_dataList[i], AC6paramMulti_dataList[i + 1])

		end

	end

	AC6paramMulti_dataList = nil
	IsAC6paramMultiEnabled = nil

end