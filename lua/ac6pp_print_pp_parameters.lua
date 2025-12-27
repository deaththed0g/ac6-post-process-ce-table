{$lua}

--[[
==============================================================================
==== ACE COMBAT 6: FIRES OF LIBERATION - PRINT POST PROCESSING PARAMETERS ====
==============================================================================
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

-- Create memory record
local function create_memory_record(is_header, header_name, header_options, base_address, offset_list, ctn_list, description_list, is_append, append_to_entry)

	if is_header then

		memory_record = getAddressList().createMemoryRecord()

		memory_record.Description = header_name
        memory_record.isGroupHeader = true

		if header_options then

			memory_record.options = "[moAllowManualCollapseAndExpand, moManualExpandCollapse]"

		end

		if is_append then

			memory_record.appendToEntry(append_to_entry)

		end

	else

		for i = 1, #offset_list do

			memory_record = getAddressList().createMemoryRecord()

			memory_record.Description = description_list[i]
			memory_record.setAddress(base_address + offset_list[i])

			if type(ctn_list[i]) == "table" then

				if ctn_list [i][1] == vtByteArray then

					memory_record.Type = vtByteArray
					memory_record.Aob.Size = ctn_list[i][2]
					memory_record.ShowAsHex = true

				elseif ctn_list [i][1] == vtString then

					memory_record.Type = vtString
					memory_record.String.Size = ctn_list[i][2]

				end

			else

				memory_record.Type = vtCustom
				memory_record.CustomTypeName = ctn_list[i]

			end

			if is_append then

				memory_record.appendToEntry(append_to_entry)

			end

		end

	end

    return memory_record

end

-- Print post-processing parameters script
function AC6printPostProcessParam_outSortieCheck(AC6printPostProcessParam_outSortieCheckTimer)

	-- Run script as long the [CLICK HERE START] script is active.
	if IsAC6mainCheckEnabled then

		-- If the "AC6paramAddress" variable contains an address then read its value.
		-- Else skip function until the players enters a mission again which in turn
		-- a new address will be assigned to this variable.
		if readInteger(AC6paramAddress) ~= nil then

			-- If the player is in a mission then proceed to modify data.
			if readInteger(XENIAMEM_AC6mainCheck[1] + 0x8C98C0) == 2164260864 then

				-- Pause "out-of-mission" checker script.
				AC6printPostProcessParam_outSortieCheckTimer.Enabled = false

				-- Create header + memory records to display and let the user edit the data.
				AC6postProcessParam_mainHeader = create_memory_record(true, "Ace Combat 6: Fires of Liberation - Post process effects parameters", true, nil, nil, nil, nil, nil, nil)

				local description_list = {"HDR.fMinLuminance", "HDR.fMaxLuminance", "HDR.fAdaptationSpeed", "HDR.fBrightPassThreshold", "HDR.fBrightPassOffset", "HDR.fBloomBrightness", "HDR.fBloomSigma", "HDR.fBloomScale", "HDR.fStarScale", "Vignetting.fRadiusRatio", "Vignetting.fFovRatio", "LevelCorrection.In.Min.R", "LevelCorrection.In.Min.G", "LevelCorrection.In.Min.B", "LevelCorrection.In.Gamma.R", "LevelCorrection.In.Gamma.G", "LevelCorrection.In.Gamma.B", "LevelCorrection.In.Max.R", "LevelCorrection.In.Max.G", "LevelCorrection.In.Max.B", "LevelCorrection.Out.Min.R", "LevelCorrection.Out.Min.G", "LevelCorrection.Out.Min.B", "LevelCorrection.Out.Max.R", "LevelCorrection.Out.Max.G", "LevelCorrection.Out.Max.B"}
				local offset_list = {0x0, 0x4, 0x8, 0xC, 0x10, 0x14, 0x18, 0x1C, 0x20, 0x28, 0x2C, 0x34, 0x38, 0x3C, 0x40, 0x44, 0x48, 0x4C, 0x50, 0x54, 0x58, 0x5C, 0x60, 0x64, 0x68, 0x6C}
				local ctn_list = {"Float Big Endian", "Float Big Endian", "Float Big Endian", "Float Big Endian", "Float Big Endian", "Float Big Endian", "Float Big Endian", "Float Big Endian", "Float Big Endian", "Float Big Endian", "Float Big Endian", "Float Big Endian", "Float Big Endian", "Float Big Endian", "Float Big Endian", "Float Big Endian", "Float Big Endian", "Float Big Endian", "Float Big Endian", "Float Big Endian", "Float Big Endian", "Float Big Endian", "Float Big Endian", "Float Big Endian", "Float Big Endian", "Float Big Endian"}

				local sub_header = create_memory_record(true, "Parameter set list", true, nil, nil, nil, nil, true, AC6postProcessParam_mainHeader)
				create_memory_record(nil, nil, nil, AC6paramAddress + 0xC4, offset_list, ctn_list, description_list, true, sub_header)

				-- "in-mission" check script.
				function AC6printPostProcessParam_inSortieCheck(AC6printPostProcessParam_inSortieCheckTimer)

					-- Run function as long the "Click here to start" script is active.
					if IsAC6mainCheckEnabled then

						-- Pause the "in-mission" checker script, resume the "out-of-mission" checker script if the player is not in a mission.
						if readInteger(XENIAMEM_AC6mainCheck[1] + 0x8C98C0) ~= 2164260864 then
							
							-- Destroy main header along with its child memory records to make space for the next one.
							AC6postProcessParam_mainHeader.destroy()

							-- Pause the "out-of-mission"  checker script, resume the "in-mission" checker script if the player is not in a mission.
							AC6printPostProcessParam_inSortieCheckTimer.Enabled = false

							AC6printPostProcessParam_outSortieCheckTimer.Enabled = true

						end

					else

						getAddressList().getMemoryRecordByDescription("Print post processing parameters").Active = false

					end

				end

				-- Start the "in-mission" checker script, resume if a timer object was found.
				if AC6printPostProcessParam_inSortieCheck_Timer == nil then

					AC6printPostProcessParam_inSortieCheck_Timer = createTimer()
					AC6printPostProcessParam_inSortieCheck_Timer.Interval = 500
					AC6printPostProcessParam_inSortieCheck_Timer.onTimer = AC6printPostProcessParam_inSortieCheck
					AC6printPostProcessParam_inSortieCheck_Timer.Enabled = true

				else

					AC6printPostProcessParam_inSortieCheck_Timer.Enabled = true

				end

			end

		end

	else

		getAddressList().getMemoryRecordByDescription("Print post processing parameters").Active = false

	end

end


-----------------+
---- [CHECK] ----+
-----------------+

-- Proceed with the rest of the script if the [CLICK HERE TO START] script is enabled.
if IsAC6mainCheckEnabled then

	IsAC6printPostProcessParamEnabled = true

else

	showMessage("<< Enable the [CLICK HERE TO START] script first! >>")

end

----------------+
---- [MAIN] ----+
----------------+

if IsAC6printPostProcessParamEnabled then

	-- Create the timer object if the player is in or out of a mission.
	AC6printPostProcessParam_outSortieCheck_Timer = createTimer()
	AC6printPostProcessParam_outSortieCheck_Timer.Interval = 500
	AC6printPostProcessParam_outSortieCheck_Timer.onTimer = AC6printPostProcessParam_outSortieCheck
	AC6printPostProcessParam_outSortieCheck_Timer.Enabled = true

end

[DISABLE]

if syntaxcheck then return end

-- Destroy active timer objects, restore modified data and clear flags on script deactivation.
if IsAC6printPostProcessParamEnabled then

	AC6postProcessParam_mainHeader.destroy()

	if AC6printPostProcessParam_inSortieCheck_Timer ~= nil then

		AC6printPostProcessParam_inSortieCheck_Timer.destroy()
		AC6printPostProcessParam_inSortieCheck_Timer = nil

	end

	if AC6printPostProcessParam_outSortieCheck_Timer ~= nil then

		AC6printPostProcessParam_outSortieCheck_Timer.destroy()
		AC6printPostProcessParam_outSortieCheck_Timer = nil

	end

	IsAC6printPostProcessParamEnabled = nil

end