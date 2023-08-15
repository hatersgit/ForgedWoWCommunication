TalentTree = {
    FORGE_TABS = {},
    FORGE_ACTIVE_SPEC = {},
    FORGE_SPECS_TAB = {},
    FORGE_SPEC_SLOTS = {},
    FORGE_SELECTED_TAB = nil,
    FORGE_SPELLS_PAGES = {},
    FORGE_CURRENT_PAGE = 0,
    FORGE_MAX_PAGE = nil,
    FORGE_TALENTS = nil,
    SPEC_PERKS = nil,
    INITIALIZED = false
}

TalentTreeWindow = CreateFrame("Frame", TalentTreeWindow, UIParent);
TalentTreeWindow:SetSize(settings.width, 30); --- LEFT/RIGHT -- --UP/DOWN --
TalentTreeWindow:SetPoint("LEFT", GetScreenWidth() / 10, 7 * GetScreenHeight() / 10); --- LEFT/RIGHT -- --UP/DOWN --
TalentTreeWindow:SetFrameStrata("DIALOG")
TalentTreeWindow:SetToplevel(true)
TalentTreeWindow:EnableMouse(true)
TalentTreeWindow:SetMovable(true)
TalentTreeWindow:SetFrameLevel(1)
TalentTreeWindow:SetClampedToScreen(true)
TalentTreeWindow:Hide()

TalentTreeWindow.header = CreateFrame("BUTTON", nil, TalentTreeWindow)
TalentTreeWindow.header:SetSize(settings.width, 30)
TalentTreeWindow.header:SetPoint("TOP", 0, 0);
TalentTreeWindow.header:SetFrameLevel(TalentTreeWindow:GetFrameLevel() + 1)
TalentTreeWindow.header:EnableMouse(true)
TalentTreeWindow.header:RegisterForClicks("AnyUp", "AnyDown")
TalentTreeWindow.header:SetScript("OnMouseDown", function()
    TalentTreeWindow:StartMoving()
end)
TalentTreeWindow.header:SetScript("OnMouseUp", function()
    TalentTreeWindow:StopMovingOrSizing()
end)
SetTemplate(TalentTreeWindow.header);

TalentTreeWindow.header.close = CreateFrame("BUTTON", "InstallCloseButton", TalentTreeWindow.header,
    "UIPanelCloseButton")
TalentTreeWindow.header.close:SetPoint("TOPRIGHT", TalentTreeWindow.header, "TOPRIGHT")
TalentTreeWindow.header.close:SetScript("OnClick", function()
    TalentTreeWindow:Hide()
end)
TalentTreeWindow.header.close:SetFrameLevel(TalentTreeWindow.header:GetFrameLevel() + 1)

TalentTreeWindow.header.title = TalentTreeWindow.header:CreateFontString("OVERLAY");
TalentTreeWindow.header.title:SetPoint("CENTER", TalentTreeWindow.header, "CENTER");
TalentTreeWindow.header.title:SetFont("Fonts\\AvQest.TTF", 22);
TalentTreeWindow.header.title:SetText("Talents");
TalentTreeWindow.header.title:SetTextColor(188 / 255, 150 / 255, 28 / 255, 1); -- rgb(188, 150, 28)

TalentTreeWindow.body = CreateFrame("Frame", TalentTreeWindow.body, TalentTreeWindow);
TalentTreeWindow.body:SetSize(settings.width, settings.height - 30); -- Talent Tree Window's Background --
TalentTreeWindow.body:SetPoint("TOP", 0, -30);
TalentTreeWindow.body:SetFrameLevel(2);
SetTemplate(TalentTreeWindow.body);

TalentTreeWindow.body.ChoiceSpecs = CreateFrame("Frame", TalentTreeWindow.body.ChoiceSpecs, TalentTreeWindow.body);
TalentTreeWindow.body.ChoiceSpecs:SetSize(TalentTreeWindow.body:GetWidth() - 4, 30);
TalentTreeWindow.body.ChoiceSpecs:SetPoint("TOP", 0, 0);
TalentTreeWindow.body.ChoiceSpecs:SetFrameLevel(TalentTreeWindow.body:GetFrameLevel() + 1)
TalentTreeWindow.body.ChoiceSpecs.Spec = {};

-- Reset Talents --
local resetButton = CreateFrame("Button", "ResetTalentsButton", TalentTreeWindow.header, "UIPanelButtonTemplate")
resetButton:SetSize(90, 30) -- Set the size of the button
resetButton:SetPoint("TOPLEFT", 8, 0) -- Position the button at the top right of the TalentTreeWindow
resetButton:SetText("Reset Talents")

resetButton:SetScript("OnClick", function()
    -- Call the UnlearnTalents function when the button is clicked
    UnlearnTalents()
    PushForgeMessage(ForgeTopic.UNLEARN_TALENT, "-1" .. ";" .. TalentTree.FORGE_SELECTED_TAB.Id);
end)

local prestigeButton = CreateFrame("Button", prestigeButton, TalentTreeWindow.header, "UIPanelButtonTemplate")
prestigeButton:SetSize(65, 30) -- Set the size of the button
prestigeButton:SetPoint("TOPLEFT", 106, 0)
prestigeButton:SetText("Prestige") -- Set the text of the button

prestigeButton:SetScript("OnClick", function()
    PushForgeMessage(ForgeTopic.PRESTIGE, "");
end)
