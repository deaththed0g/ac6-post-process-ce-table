{$lua}

--[[
================================================================
==== ACE COMBAT 6: FIRES OF LIBERATION - DISABLE HDR SCRIPT ====
================================================================
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

-- HDR modifier script
function AC6paramHDR_outSortieCheck(AC6paramHDR_outSortieCheckTimer)

	-- Run script as long the [CLICK HERE START] script is active.
	if IsAC6mainCheckEnabled then

		-- If the "AC6paramAddress" variable contains an address then read its value.
		-- Else skip function until the players enters a mission again which in turn
		-- a new address will be assigned to this variable.
		if readInteger(AC6paramAddress) ~= nil then

			-- Begin HDR parameter modification if the player is in a mission.
			if readInteger(XENIAMEM_AC6mainCheck[1] + 0x8C98C0) == 2164260864 then

				-- Pause "out-of-mission" checker script.
				AC6paramHDR_outSortieCheckTimer.Enabled = false

				-- Clear table, get HDR parameter address list, read and store original values.
				for k, v in pairs(AC6paramHDR_dataList) do AC6paramHDR_dataList[k] = nil end
				
				AC6paramHDR_dataList[#AC6paramHDR_dataList + 1] = AC6paramAddress + 0xC4
				AC6paramHDR_dataList[#AC6paramHDR_dataList + 1] = readBytes(AC6paramAddress + 0xC4, 0x24, true)

				-- Write custom data.
				writeBytes(AC6paramAddress + 0xC4, {0x00, 0x00, 0x00, 0x00, 0x3F, 0x80, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x3F, 0x80, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00})

				-- "in-mission" check script.
				function AC6paramHDR_inSortieCheck(AC6paramHDR_inSortieCheckTimer)

					-- Run function as long the "Click here to start" script is active.
					if IsAC6mainCheckEnabled then

						-- Pause the "in-mission" checker script, resume the "out-of-mission" checker script if the player is not in a mission.
						if readInteger(XENIAMEM_AC6mainCheck[1] + 0x8C98C0) == 2164260864 then

							local function AC6paramHDR_writeValue()

								writeBytes(AC6paramAddress + 0xC4, {0x00, 0x00, 0x00, 0x00, 0x3F, 0x80, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x3F, 0x80, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00})

							end

							-- Create a timer that calls the function above every 5 seconds
							-- to write the modified data in case the player resets the mission.
							-- The parameters are reset to their default value every time the mission is restarted.
							if AC6paramHDR_writeValue_Timer == nil then

								AC6paramHDR_writeValue_Timer = createTimer()
								AC6paramHDR_writeValue_Timer.Interval = 5000
								AC6paramHDR_writeValue_Timer.onTimer = AC6paramHDR_writeValue
								AC6paramHDR_writeValue_Timer.Enabled = true

							end

						else

							-- Destroy timer object that was created to write data every 5 seconds.
							if AC6paramHDR_writeValue_Timer ~= nil then

								AC6paramHDR_writeValue_Timer.destroy()
								AC6paramHDR_writeValue_Timer = nil

							end

							-- Pause the "out-of-mission"  checker script, resume the "in-mission" checker script if the player is not in a mission.
							AC6paramHDR_inSortieCheckTimer.Enabled = false

							AC6paramHDR_outSortieCheckTimer.Enabled = true

						end

					else

						getAddressList().getMemoryRecordByDescription("Disable HDR").Active = false

					end

				end

				-- Start the "in-mission" checker script, resume if a timer object was found.
				if AC6paramHDR_inSortieCheck_Timer == nil then

					AC6paramHDR_inSortieCheck_Timer = createTimer()
					AC6paramHDR_inSortieCheck_Timer.Interval = 500
					AC6paramHDR_inSortieCheck_Timer.onTimer = AC6paramHDR_inSortieCheck
					AC6paramHDR_inSortieCheck_Timer.Enabled = true

				else

					AC6paramHDR_inSortieCheck_Timer.Enabled = true

				end

			end

		end

	else

		getAddressList().getMemoryRecordByDescription("Disable HDR").Active = false

	end

end

-----------------+
---- [CHECK] ----+
-----------------+

-- Proceed with the rest of the script if the [CLICK HERE TO START] script is enabled.
if IsAC6mainCheckEnabled then

	IsAC6paramHDREnabled = true

else

	showMessage("<< Enable the [CLICK HERE TO START] script first! >>")

end

----------------+
---- [MAIN] ----+
----------------+

if IsAC6paramHDREnabled then

	-- Initialize a table to store address and values.
	AC6paramHDR_dataList = {}

	-- Create the timer object if the player is in or out of a mission.
	AC6paramHDR_outSortieCheck_Timer = createTimer()
	AC6paramHDR_outSortieCheck_Timer.Interval = 500
	AC6paramHDR_outSortieCheck_Timer.onTimer = AC6paramHDR_outSortieCheck
	AC6paramHDR_outSortieCheck_Timer.Enabled = true

end

[DISABLE]

if syntaxcheck then return end

-- Destroy active timer objects, restore modified data and clear flags on script deactivation.
if IsAC6paramHDREnabled then

	if AC6paramHDR_writeValue_Timer ~= nil then

		AC6paramHDR_writeValue_Timer.destroy()
		AC6paramHDR_writeValue_Timer = nil

	end

	if AC6paramHDR_inSortieCheck_Timer ~= nil then

		AC6paramHDR_inSortieCheck_Timer.destroy()
		AC6paramHDR_inSortieCheck_Timer = nil

	end

	if AC6paramHDR_outSortieCheck_Timer ~= nil then

		AC6paramHDR_outSortieCheck_Timer.destroy()
		AC6paramHDR_outSortieCheck_Timer = nil

	end

	if readInteger(AC6paramHDR_dataList[1]) ~= nil then

		for i = 1, #AC6paramHDR_dataList, 2 do

			writeBytes(AC6paramHDR_dataList[1], AC6paramHDR_dataList[2])

		end

	end

	AC6paramHDR_dataList = nil
	IsAC6paramHDREnabled = nil

end