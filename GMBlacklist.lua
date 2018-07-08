local GMBlacklistLog = {}
local GMBlacklist = CreateFrame("Frame")
GMBlacklist:RegisterEvent("ADDON_LOADED")
GMBlacklist:SetScript("OnEvent", function()
  for i=1,NUM_CHAT_WINDOWS do
    local ChatFrame = getglobal("ChatFrame"..i)

    if not ChatFrame.GMBlacklistHook then
      ChatFrame.GMBlacklistHook = ChatFrame.AddMessage
      ChatFrame.AddMessage = function (frame, text, ...)
        -- arg1 = text, arg2 = name
        if arg1 and arg2 then
          GMBlacklistLog[arg2] = arg1
        end
        frame.GMBlacklistHook(frame, text, unpack(arg))
      end
    end
  end
end)

-- [[ GUI ]] --
local GMBlacklistGUI = CreateFrame("Frame", "pfBlackListGUI", UIParent)
GMBlacklistGUI:SetPoint("CENTER", 0, 100)
GMBlacklistGUI:SetWidth(500)
GMBlacklistGUI:SetHeight(100)
GMBlacklistGUI:SetBackdrop({
  bgFile = "Interface\\Tooltips\\UI-Tooltip-Background", tile = true, tileSize = 32,
  edgeFile = "Interface\\Tooltips\\UI-Tooltip-Border", edgeSize = 16,
  insets = {left = 3, right = 3, top = 3, bottom = 3},
})

GMBlacklistGUI:Hide()
GMBlacklistGUI:SetMovable(true)
GMBlacklistGUI:EnableMouse(true)
GMBlacklistGUI:SetScript("OnMouseDown",function()
  GMBlacklistGUI:StartMoving()
end)

GMBlacklistGUI:SetScript("OnMouseUp",function()
  GMBlacklistGUI:StopMovingOrSizing()
end)

GMBlacklistGUI:SetBackdropColor(0,0,0,1)
GMBlacklistGUI:SetBackdropBorderColor(.5,.5,.5,1)

GMBlacklistGUI.name = GMBlacklistGUI:CreateFontString("GMBlacklistGUIName", "LOW", "GameFontNormal")
GMBlacklistGUI.name:SetPoint("TOPLEFT", 10, -10)
GMBlacklistGUI.name:SetText("NAME")

GMBlacklistGUI.message = GMBlacklistGUI:CreateFontString("GMBlacklistGUIMessage", "LOW", "GameFontWhite")
GMBlacklistGUI.message:SetPoint("TOPLEFT", 10, -30)
GMBlacklistGUI.message:SetText("MESSAGE")

GMBlacklistGUI.snippet = GMBlacklistGUI:CreateFontString("GMBlacklistGUISnippet", "LOW", "GameFontWhite")
GMBlacklistGUI.snippet:SetPoint("TOPLEFT", 10, -50)
GMBlacklistGUI.snippet:SetText("MESSAGE")
GMBlacklistGUI.snippet:SetTextColor(1,.5,.5,1)

GMBlacklistGUI.startl = GMBlacklistGUI:CreateFontString("GMBlacklistGUIStartLabel", "LOW", "GameFontWhite")
GMBlacklistGUI.startl:SetPoint("BOTTOMLEFT", 10, 14)
GMBlacklistGUI.startl:SetText("Start")
GMBlacklistGUI.startl:SetTextColor(.7,.7,.7,1)

GMBlacklistGUI.start = CreateFrame("EditBox", "GMBlacklistGUIStart", GMBlacklistGUI, "InputBoxTemplate")
GMBlacklistGUI.start:SetAutoFocus(false)
GMBlacklistGUI.start:SetHeight(20)
GMBlacklistGUI.start:SetWidth(30)
GMBlacklistGUI.start:SetPoint("BOTTOMLEFT", 45, 10)
GMBlacklistGUI.start:SetText("0")
GMBlacklistGUI.start:SetScript("OnEscapePressed", function(self) this:ClearFocus() end)
GMBlacklistGUI.start:SetScript("OnTextChanged", function(self)
  if tonumber(GMBlacklistGUI.start:GetText()) and tonumber(GMBlacklistGUI.limit:GetText()) then
    local text  = GMBlacklistLog[GMBlacklistGUI.name:GetText()]
    local start = tonumber(GMBlacklistGUI.start:GetText())
    local limit = tonumber(GMBlacklistGUI.limit:GetText())
    local snipp = strsub(text, start, limit)
    GMBlacklistGUI.snippet:SetText(gsub(snipp, "%|", "||"))
  end
end)

GMBlacklistGUI.startup = CreateFrame("Button", "GMBlacklistGUIStartUp", GMBlacklistGUI, "UIPanelButtonTemplate")
GMBlacklistGUI.startup:SetWidth(10)
GMBlacklistGUI.startup:SetHeight(10)
GMBlacklistGUI.startup:SetPoint("TOPLEFT", GMBlacklistGUI.start, "TOPRIGHT", 0, 0)
GMBlacklistGUI.startup:SetText("+")
GMBlacklistGUI.startup:SetScript("OnClick", function()
  if tonumber(GMBlacklistGUI.start:GetText()) then
    GMBlacklistGUI.start:SetText(tonumber(GMBlacklistGUI.start:GetText()) + 1)
  end
end)

GMBlacklistGUI.startdown = CreateFrame("Button", "GMBlacklistGUIStartDown", GMBlacklistGUI, "UIPanelButtonTemplate")
GMBlacklistGUI.startdown:SetWidth(10)
GMBlacklistGUI.startdown:SetHeight(10)
GMBlacklistGUI.startdown:SetPoint("BOTTOMLEFT", GMBlacklistGUI.start, "BOTTOMRIGHT", 0, 0)
GMBlacklistGUI.startdown:SetText("-")
GMBlacklistGUI.startdown:SetScript("OnClick", function()
  if tonumber(GMBlacklistGUI.start:GetText()) > 0 then
    GMBlacklistGUI.start:SetText(tonumber(GMBlacklistGUI.start:GetText()) - 1)
  end
end)

GMBlacklistGUI.limitl = GMBlacklistGUI:CreateFontString("GMBlacklistGUIStartLabel", "LOW", "GameFontWhite")
GMBlacklistGUI.limitl:SetPoint("BOTTOMLEFT", 95, 14)
GMBlacklistGUI.limitl:SetText("End")
GMBlacklistGUI.limitl:SetTextColor(.7,.7,.7,1)

GMBlacklistGUI.limit = CreateFrame("EditBox", "GMBlacklistGUILimit", GMBlacklistGUI, "InputBoxTemplate")
GMBlacklistGUI.limit:SetAutoFocus(false)
GMBlacklistGUI.limit:SetHeight(20)
GMBlacklistGUI.limit:SetWidth(30)
GMBlacklistGUI.limit:SetPoint("BOTTOMLEFT", 125, 10)
GMBlacklistGUI.limit:SetText("0")
GMBlacklistGUI.limit:SetScript("OnEscapePressed", function(self) this:ClearFocus() end)
GMBlacklistGUI.limit:SetScript("OnTextChanged", function(self)
  if tonumber(GMBlacklistGUI.start:GetText()) and tonumber(GMBlacklistGUI.limit:GetText()) then
    local text  = GMBlacklistLog[GMBlacklistGUI.name:GetText()]
    local start = tonumber(GMBlacklistGUI.start:GetText())
    local limit = tonumber(GMBlacklistGUI.limit:GetText())
    local snipp = strsub(text, start, limit)
    GMBlacklistGUI.snippet:SetText(gsub(snipp, "%|", "||"))
  end
end)
GMBlacklistGUI.limitup = CreateFrame("Button", "GMBlacklistGUILimitUp", GMBlacklistGUI, "UIPanelButtonTemplate")
GMBlacklistGUI.limitup:SetWidth(10)
GMBlacklistGUI.limitup:SetHeight(10)
GMBlacklistGUI.limitup:SetPoint("TOPLEFT", GMBlacklistGUI.limit, "TOPRIGHT", 0, 0)
GMBlacklistGUI.limitup:SetText("+")
GMBlacklistGUI.limitup:SetScript("OnClick", function()
  if tonumber(GMBlacklistGUI.limit:GetText()) then
    GMBlacklistGUI.limit:SetText(tonumber(GMBlacklistGUI.limit:GetText()) + 1)
  end
end)

GMBlacklistGUI.limitdown = CreateFrame("Button", "GMBlacklistGUILimitDown", GMBlacklistGUI, "UIPanelButtonTemplate")
GMBlacklistGUI.limitdown:SetWidth(10)
GMBlacklistGUI.limitdown:SetHeight(10)
GMBlacklistGUI.limitdown:SetPoint("BOTTOMLEFT", GMBlacklistGUI.limit, "BOTTOMRIGHT", 0, 0)
GMBlacklistGUI.limitdown:SetText("-")
GMBlacklistGUI.limitdown:SetScript("OnClick", function()
  if tonumber(GMBlacklistGUI.limit:GetText()) > 0 then
    GMBlacklistGUI.limit:SetText(tonumber(GMBlacklistGUI.limit:GetText()) - 1)
  end
end)

GMBlacklistGUI.limitdown = CreateFrame("Button", "GMBlacklistGUILimitDown", GMBlacklistGUI, "UIPanelButtonTemplate")
GMBlacklistGUI.limitdown:SetWidth(50)
GMBlacklistGUI.limitdown:SetHeight(22)
GMBlacklistGUI.limitdown:SetPoint("BOTTOMLEFT", 175, 9)
GMBlacklistGUI.limitdown:SetText("Blacklist")
GMBlacklistGUI.limitdown:SetScript("OnClick", function()

  local text  = GMBlacklistLog[GMBlacklistGUI.name:GetText()]
  local start = tonumber(GMBlacklistGUI.start:GetText())
  local limit = tonumber(GMBlacklistGUI.limit:GetText())
  local snipp = strsub(text, start, limit)
  local forma = gsub(snipp, "%|", "||")

  StaticPopupDialogs["GM_BLACKLIST"] = {
    text = "\"|cffff5555" .. forma .. "|r\"\nWill be blacklisted. Proceed?",
    button1 = "Yes",
    button2 = "No",
    OnAccept = function()
      SendChatMessage(".anticheat blacklist " .. snipp)
    end,

    timeout = 0,
    whileDead = true,
    hideOnEscape = true,
    preferredIndex = 3,
  }

  StaticPopup_Show ("GM_BLACKLIST")
end)

GMBlacklistGUI.close = CreateFrame("Button", "GMBlacklistGUIClose", GMBlacklistGUI, "UIPanelCloseButton")
GMBlacklistGUI.close:SetWidth(20)
GMBlacklistGUI.close:SetHeight(20)
GMBlacklistGUI.close:SetPoint("TOPRIGHT", 0,0)
GMBlacklistGUI.close:SetScript("OnClick", function()
  GMBlacklistGUI:Hide()
end)

function GMBlacklistCMD(name)
  if GMBlacklistLog[name] then
    GMBlacklistGUI.name:SetText(name)
    GMBlacklistGUI.message:SetText(gsub(GMBlacklistLog[name], "%|", "||"))
    GMBlacklistGUI.snippet:SetText(gsub(GMBlacklistLog[name], "%|", "||"))
    local width = GMBlacklistGUI.message:GetStringWidth() + 20
    GMBlacklistGUI:SetWidth(width < 250 and 250 or width)

    GMBlacklistGUI.start:SetText(0)
    GMBlacklistGUI.limit:SetText(strlen(GMBlacklistLog[name]))
    GMBlacklistGUI:Show()
  end
end

-- [[ dropdown menus ]] --
UnitPopupButtons["GM_BLACKLIST"] = { text = TEXT("|cffffaaaa" .. "BLACKLIST"), dist = 0 }
table.insert(UnitPopupMenus["FRIEND"], "GM_BLACKLIST")
local HookUnitPopup_OnClick = UnitPopup_OnClick
function UnitPopup_OnClick()
 local dropdownFrame = getglobal(UIDROPDOWNMENU_INIT_MENU)
 local button = this.value
 local unit = dropdownFrame.unit
 local name = dropdownFrame.name
 local server = dropdownFrame.server

 if button == "GM_BLACKLIST" then
   GMBlacklistCMD(name)
   return
 end

 HookUnitPopup_OnClick()
end

