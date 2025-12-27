{$lua}

--[[
=============================================================================
==== ACE COMBAT 6: FIRES OF LIBERATION - DISABLE LEVEL CORRECTION SCRIPT ====
=============================================================================
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

-- Color correction modifier script
function AC6paramColorCorrection_outSortieCheck(AC6paramColorCorrection_outSortieCheckTimer)

	-- Run script as long the [CLICK HERE START] script is active.
	if IsAC6mainCheckEnabled then

		-- If the "AC6paramAddress" variable contains an address then read its value.
		-- Else skip function until the players enters a mission again which in turn
		-- a new address will be assigned to this variable.
		if readInteger(AC6paramAddress) ~= nil then

			-- If the player is in a mission then proceed to modify data.
			if readInteger(XENIAMEM_AC6mainCheck[1] + 0x8C98C0) == 2164260864 then

				-- Pause "out-of-mission" checker script.
				AC6paramColorCorrection_outSortieCheckTimer.Enabled = false

				-- Clear table, get level correction parameter address list, read and store original values.
				for k, v in pairs(AC6paramColorCorrection_dataList) do AC6paramColorCorrection_dataList[k] = nil end
				
				AC6paramColorCorrection_dataList[#AC6paramColorCorrection_dataList + 1] = AC6paramAddress + 0xF8
				AC6paramColorCorrection_dataList[#AC6paramColorCorrection_dataList + 1] = readBytes(AC6paramAddress + 0xF8, 0x3C, true)

				-- Write custom data.
				writeBytes(AC6paramAddress + 0xF8, {0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x3F, 0x80, 0x00, 0x00, 0x3F, 0x80, 0x00, 0x00, 0x3F, 0x80, 0x00, 0x00, 0x3F, 0x80, 0x00, 0x00, 0x3F, 0x80, 0x00, 0x00, 0x3F, 0x80, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x3F, 0x80, 0x00, 0x00, 0x3F, 0x80, 0x00, 0x00, 0x3F, 0x80, 0x00, 0x00})

				-- "in-mission" check script.
				function AC6paramColorCorrection_inSortieCheck(AC6paramColorCorrection_inSortieCheckTimer)

					-- Run function as long the "Click here to start" script is active.
					if IsAC6mainCheckEnabled then

						-- Pause the "in-mission" checker script, resume the "out-of-mission" checker script if the player is not in a mission.
						if readInteger(XENIAMEM_AC6mainCheck[1] + 0x8C98C0) == 2164260864 then

							local function AC6paramColorCorrection_writeValue()

								writeBytes(AC6paramAddress + 0xF8, {0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x3F, 0x80, 0x00, 0x00, 0x3F, 0x80, 0x00, 0x00, 0x3F, 0x80, 0x00, 0x00, 0x3F, 0x80, 0x00, 0x00, 0x3F, 0x80, 0x00, 0x00, 0x3F, 0x80, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x3F, 0x80, 0x00, 0x00, 0x3F, 0x80, 0x00, 0x00, 0x3F, 0x80, 0x00, 0x00})

							end

							-- Create a timer that calls the function above every 5 seconds
							-- to write the modified data in case the player resets the mission.
							-- The parameters are reset to their default value every time the mission is restarted.
							if AC6paramColorCorrection_writeValue_Timer == nil then

								AC6paramColorCorrection_writeValue_Timer = createTimer()
								AC6paramColorCorrection_writeValue_Timer.Interval = 5000
								AC6paramColorCorrection_writeValue_Timer.onTimer = AC6paramColorCorrection_writeValue
								AC6paramColorCorrection_writeValue_Timer.Enabled = true

							end

						else

							-- Destroy timer object that was created to write data every 5 seconds.
							if AC6paramColorCorrection_writeValue_Timer ~= nil then

								AC6paramColorCorrection_writeValue_Timer.destroy()
								AC6paramColorCorrection_writeValue_Timer = nil

							end

							-- Pause the "out-of-mission"  checker script, resume the "in-mission" checker script if the player is not in a mission.
							AC6paramColorCorrection_inSortieCheckTimer.Enabled = false

							AC6paramColorCorrection_outSortieCheckTimer.Enabled = true

						end

					else

						getAddressList().getMemoryRecordByDescription("Disable level correction").Active = false

					end

				end

				-- Start the "in-mission" checker script, resume if a timer object was found.
				if AC6paramColorCorrection_inSortieCheck_Timer == nil then

					AC6paramColorCorrection_inSortieCheck_Timer = createTimer()
					AC6paramColorCorrection_inSortieCheck_Timer.Interval = 500
					AC6paramColorCorrection_inSortieCheck_Timer.onTimer = AC6paramColorCorrection_inSortieCheck
					AC6paramColorCorrection_inSortieCheck_Timer.Enabled = true

				else

					AC6paramColorCorrection_inSortieCheck_Timer.Enabled = true

				end

			end

		end

	else

		getAddressList().getMemoryRecordByDescription("Disable level correction").Active = false

	end

end


-----------------+
---- [CHECK] ----+
-----------------+

-- Proceed with the rest of the script if the [CLICK HERE TO START] script is enabled.
if IsAC6mainCheckEnabled then

	IsAC6paramColorCorrectionEnabled = true

else

	showMessage("<< Enable the [CLICK HERE TO START] script first! >>")

end

----------------+
---- [MAIN] ----+
----------------+

if IsAC6paramColorCorrectionEnabled then

	-- Initialize a table to store address and values.
	AC6paramColorCorrection_dataList = {}

	-- Create the timer object if the player is in or out of a mission.
	AC6paramColorCorrection_outSortieCheck_Timer = createTimer()
	AC6paramColorCorrection_outSortieCheck_Timer.Interval = 500
	AC6paramColorCorrection_outSortieCheck_Timer.onTimer = AC6paramColorCorrection_outSortieCheck
	AC6paramColorCorrection_outSortieCheck_Timer.Enabled = true

end

[DISABLE]

if syntaxcheck then return end

-- Destroy active timer objects, restore modified data and clear flags on script deactivation.
if IsAC6paramColorCorrectionEnabled then

	if AC6paramColorCorrection_writeValue_Timer ~= nil then

		AC6paramColorCorrection_writeValue_Timer.destroy()
		AC6paramColorCorrection_writeValue_Timer = nil

	end

	if AC6paramColorCorrection_inSortieCheck_Timer ~= nil then

		AC6paramColorCorrection_inSortieCheck_Timer.destroy()
		AC6paramColorCorrection_inSortieCheck_Timer = nil

	end

	if AC6paramColorCorrection_outSortieCheck_Timer ~= nil then

		AC6paramColorCorrection_outSortieCheck_Timer.destroy()
		AC6paramColorCorrection_outSortieCheck_Timer = nil

	end

	if readInteger(AC6paramColorCorrection_dataList[1]) ~= nil then

		for i = 1, #AC6paramColorCorrection_dataList, 2 do

			writeBytes(AC6paramColorCorrection_dataList[1], AC6paramColorCorrection_dataList[2])

		end

	end

	AC6paramColorCorrection_dataList = nil
	IsAC6paramColorCorrectionEnabled = nil

end