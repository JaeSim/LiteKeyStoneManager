local addonName, KeyStoneManager = ...;
-- Minimap button 
local minibtn = CreateFrame("Button", nil, Minimap)
minibtn:SetFrameLevel(8)
minibtn:SetSize(32,32)
minibtn:SetMovable(true)

local uiflag = 0

ksmDb = KeyStoneManager.defaultsDb

--minibtn:SetBackdrop( {
			--edgeFile = [[Interface\Tooltips\UI-Tooltip-Border]],
			--edgeSize = 10,
			--insets = { left = 4, right = 3, top = 4, bottom = 4}
			--} )
minibtn:SetNormalTexture("Interface\\Icons\\inv_relics_hourglass")
minibtn:SetPushedTexture("Interface\\Icons\\inv_relics_hourglass")
minibtn:SetHighlightTexture("Interface\\Icons\\inv_relics_hourglass")


local myIconPos = -38.157263

-- Minimap button postion..
local function UpdateMapBtn()
    local Xpoa, Ypoa = GetCursorPosition()
    local Xmin, Ymin = Minimap:GetLeft(), Minimap:GetBottom()
    Xpoa = Xmin - Xpoa / Minimap:GetEffectiveScale() + 70
    Ypoa = Ypoa / Minimap:GetEffectiveScale() - Ymin - 70
    myIconPos = math.deg(math.atan2(Ypoa, Xpoa))
    minibtn:ClearAllPoints()
    minibtn:SetPoint("TOPLEFT", Minimap, "TOPLEFT", 52 - (80 * cos(myIconPos)), (80 * sin(myIconPos)) - 52)
end
 
-- Minimap button left clicked
minibtn:RegisterForDrag("LeftButton")
minibtn:SetScript("OnDragStart", function()
    minibtn:StartMoving()
    minibtn:SetScript("OnUpdate", UpdateMapBtn)
end)
 
minibtn:SetScript("OnDragStop", function()
    minibtn:StopMovingOrSizing();
    minibtn:SetScript("OnUpdate", nil)
    UpdateMapBtn();
end)
 
-- Minimap Set position
minibtn:ClearAllPoints();
minibtn:SetPoint("TOPLEFT", Minimap, "TOPLEFT", 52 - (80 * cos(myIconPos)),(80 * sin(myIconPos)) - 52)
  
-- Minimap Control clicks
minibtn:SetScript("OnClick", function()
    uiflag = 1 - uiflag
	if uiflag == 1 then 
		UpdateUI()
	elseif uiflag == 0 then
		--updateButton:Hide()
		uiFrame:Hide()
		--KeyStoneManager.clearc()
	end

end)


function UpdateUI()
	-- create UI frame
	-- Todo: get size from configuration.
	-- Todo: get position from configuration.
	if (uiflag == 1) then 
		if uiFrame ~= nil then
			uiFrame:Hide()
		end
		uiFrameSizeX = 250
		uiFrameSizeY = 180
		uiFrame = CreateFrame("Frame", "uiFrame", UIParent)
		
		uiFrame:SetSize(uiFrameSizeX, uiFrameSizeY)
		ksmDb = keystone_table
		
		if ksmDb.config.uiPositionL == nil or ksmDb.config.uiPositionB == nil then
			uiFrame:SetPoint("CENTER")
			ksmDb.config.uiPositionL = uiFrame:GetLeft()
			ksmDb.config.uiPositionB = uiFrame:GetBottom()
		end 
		
		uiFrame:SetPoint("BOTTOMLEFT", ksmDb.config.uiPositionL, ksmDb.config.uiPositionB)
		uiFrame:SetBackdrop( {
			bgFile = "Interface\\Tooltips\\UI-Tooltip-Background",
			tile = true,
			tilesize = 5,
			edgeFile = "Interface\\Tooltips\\UI-Tooltip-Border",
			edgeSize = 10,
			insets = { left = 4, right = 3, top = 4, bottom = 3}
			} )
		uiFrame:SetBackdropColor(0.2,0.2,0.2,0.7)

		uiFrame:SetMovable(true)
		uiFrame:EnableMouse(true)
		uiFrame:RegisterForDrag("LeftButton")
		uiFrame:SetScript("OnDragStart", function()
			uiFrame:StartMoving()
		end)
		
		uiFrame:SetScript("OnDragStop", function(self)
			uiFrame:StopMovingOrSizing();
			ksmDb.config.uiPositionL = self:GetLeft()
			ksmDb.config.uiPositionB = self:GetBottom()
		end)
		--TEXT --

		
		local nameFull = "이름\n" local itemlevelFull = "템렙\n" local dgnameFull = "던전\n" local dglevelFull = "단수\n" local parkLevelFull = "주차\n"
		for _, node in pairs(keystone_table.node) do
			--nameFull = nameFull .. format('%s %d  %s %2d단 주차- %2d\n', node.name, node.itemlevel, node.dgname, node.dglevel,
			--                                      node.parkLevel)
			--nameFull = nameFull .. format('|c%s%s|r\n', RAID_CLASS_COLORS[node.cl], node.name)
			nameFull = nameFull .. format('|c%s%s|r\n', RAID_CLASS_COLORS[node.cl].colorStr, node.name)
			itemlevelFull = itemlevelFull .. format('|c%s%d|r\n', select(4,GetItemQualityColor(4)), node.itemlevel)
			dgnameFull = dgnameFull .. format('|c%s%s|r\n', select(4,GetItemQualityColor(4)), node.dgname)
			dglevelFull = dglevelFull .. format('|c%s%d|r\n', select(4,GetItemQualityColor(4)), node.dglevel)
			
			if (node.parkLevel == 0) then
				parkLevelFull = parkLevelFull .. format('NO\n')
			else
				parkLevelFull = parkLevelFull .. format('|c%s%d|r\n', select(4,GetItemQualityColor(2)),node.parkLevel)
			end
		end
		
		local nameFame = CreateFrame("Frame", nil, uiFrame)
		nameFame:SetWidth(1) 
		nameFame:SetHeight(1) 
		nameFame:SetPoint("TOPLEFT", 10,-10)
		nameFame.text = nameFame:CreateFontString(nil,"ARTWORK") 
		nameFame.text:SetFont([[Fonts\2002.TTF]], 13, "OUTLINE")
		nameFame.text:SetPoint("TOPLEFT")
		nameFame.text:SetJustifyH("LEFT"); -- 좌우 정렬
		nameFame.text:SetJustifyV("TOP"); -- 상하 정렬
		nameFame.text:SetText(nameFull)
		
		local itemLevel = CreateFrame("Frame", nil, uiFrame)
		itemLevel:SetWidth(1) 
		itemLevel:SetHeight(1) 
		itemLevel:SetPoint("TOPLEFT", 10 + 80,-10)
		itemLevel.text = itemLevel:CreateFontString(nil,"ARTWORK") 
		itemLevel.text:SetFont([[Fonts\2002.TTF]], 13, "OUTLINE")
		itemLevel.text:SetPoint("TOPLEFT")
		itemLevel.text:SetJustifyH("LEFT"); -- 좌우 정렬
		itemLevel.text:SetJustifyV("TOP"); -- 상하 정렬
		itemLevel.text:SetText(itemlevelFull)

		local dgname = CreateFrame("Frame", nil, uiFrame)
		dgname:SetWidth(1) 
		dgname:SetHeight(1) 
		dgname:SetPoint("TOPLEFT", 10 + 80 + 40,-10)
		dgname.text = dgname:CreateFontString(nil,"ARTWORK") 
		dgname.text:SetFont([[Fonts\2002.TTF]], 13, "OUTLINE")
		dgname.text:SetPoint("TOPLEFT")
		dgname.text:SetJustifyH("LEFT"); -- 좌우 정렬
		dgname.text:SetJustifyV("TOP"); -- 상하 정렬
		dgname.text:SetText(dgnameFull)
		
		local dglevel = CreateFrame("Frame", nil, uiFrame)
		dglevel:SetWidth(1) 
		dglevel:SetHeight(1) 
		dglevel:SetPoint("TOPLEFT", 10 + 80 + 40 + 60,-10)
		dglevel.text = dglevel:CreateFontString(nil,"ARTWORK") 
		dglevel.text:SetFont([[Fonts\2002.TTF]], 13, "OUTLINE")
		dglevel.text:SetPoint("TOPRIGHT")
		dglevel.text:SetJustifyH("RIGHT"); -- 좌우 정렬
		dglevel.text:SetJustifyV("TOP"); -- 상하 정렬
		dglevel.text:SetText(dglevelFull)
		
		local parkLevel = CreateFrame("Frame", nil, uiFrame)
		parkLevel:SetWidth(1) 
		parkLevel:SetHeight(1) 
		parkLevel:SetPoint("TOPLEFT", 10 + 80 + 40 + 60 + 50,-10)
		parkLevel.text = parkLevel:CreateFontString(nil,"ARTWORK") 
		parkLevel.text:SetFont([[Fonts\2002.TTF]], 13, "OUTLINE")
		parkLevel.text:SetPoint("TOPRIGHT")
		parkLevel.text:SetJustifyH("RIGHT"); -- 좌우 정렬
		parkLevel.text:SetJustifyV("TOP"); -- 상하 정렬
		parkLevel.text:SetText(parkLevelFull)
		
		--Button--
		buttonSizeX = 60
		buttonSizeY = 20
		updateButton = CreateFrame("Button", "updateButton", uiFrame, "OptionsButtonTemplate")
		updateButton:SetText("Update")
		updateButton:SetSize(buttonSizeX, buttonSizeY)
		updateButton:SetPoint("BOTTOM", 0 - buttonSizeX - 5 , 5) 
		updateButton:SetScript("OnClick", KeyStoneManager.OnClick_UpdateButton) 
		
		clearButton = CreateFrame("Button", "clearButton", uiFrame, "OptionsButtonTemplate")
		clearButton:SetText("Clear")
		clearButton:SetSize(buttonSizeX, buttonSizeY)
		clearButton:SetPoint("BOTTOM", 0, 5) 
		clearButton:SetScript("OnClick", KeyStoneManager.clearc) 
		
		chatButton = CreateFrame("Button", "chatButton", uiFrame, "OptionsButtonTemplate")
		chatButton:SetText("Chat")
		chatButton:SetSize(buttonSizeX, buttonSizeY)
		chatButton:SetPoint("BOTTOM", 0 + buttonSizeX + 5, 5) 
		chatButton:SetScript("OnClick", nil) 
	end
end