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
TalentTreeWindow = CreateFrame("Frame", nil, TalentTreeWindow);
TalentTreeWindow:SetSize(settings.width, settings.headerheight); --- LEFT/RIGHT -- --UP/DOWN --
TalentTreeWindow:SetPoint("TOPLEFT", GetScreenWidth() / 20, -GetScreenHeight() / 10); --- LEFT/RIGHT -- --UP/DOWN --
TalentTreeWindow:SetFrameStrata("DIALOG")
TalentTreeWindow:EnableMouse(true)
TalentTreeWindow:SetMovable(true)
TalentTreeWindow:SetFrameLevel(1)
TalentTreeWindow:SetClampedToScreen(true)
TalentTreeWindow:SetScale(1)
TalentTreeWindow:RegisterEvent("VARIABLES_LOADED")
TalentTreeWindow:RegisterEvent("UI_SCALE_CHANGED")
TalentTreeWindow:SetScript("OnEvent", function(self)
    self:SetScale(1)
end)
TalentTreeWindow:Hide()

TalentTreeWindow.header = CreateFrame("BUTTON", nil, TalentTreeWindow)
TalentTreeWindow.header:SetSize(settings.width, settings.headerheight)
TalentTreeWindow.header:SetPoint("TOP", 0, 0);
TalentTreeWindow.header:SetFrameLevel(4)
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
TalentTreeWindow.header.close:SetSize(settings.headerheight, settings.headerheight)
TalentTreeWindow.header.close:SetPoint("TOPRIGHT", TalentTreeWindow.header, "TOPRIGHT")
TalentTreeWindow.header.close:SetScript("OnClick", function()
    TalentTreeWindow:Hide()
end)
TalentTreeWindow.header.close:SetFrameLevel(TalentTreeWindow.header:GetFrameLevel() + 1)

TalentTreeWindow.header.title = TalentTreeWindow.header:CreateFontString("OVERLAY");
TalentTreeWindow.header.title:SetPoint("CENTER", TalentTreeWindow.header, "CENTER");
TalentTreeWindow.header.title:SetFont(PATH .. "Fonts\\Expressway.TTF", 10);
TalentTreeWindow.header.title:SetText("Talents");
TalentTreeWindow.header.title:SetTextColor(188 / 255, 150 / 255, 28 / 255, 1); -- rgb(188, 150, 28)

TalentTreeWindow.body = CreateFrame("Frame", TalentTreeWindow.body, TalentTreeWindow);
TalentTreeWindow.body:SetSize(settings.width, settings.height - settings.headerheight); -- Talent Tree Window's Background --
TalentTreeWindow.body:SetPoint("TOP", 0, -settings.headerheight);
TalentTreeWindow.body:SetFrameLevel(2);

TalentTreeWindow.body.ChoiceSpecs = CreateFrame("Frame", TalentTreeWindow.body.ChoiceSpecs, TalentTreeWindow.body);
TalentTreeWindow.body.ChoiceSpecs:SetSize(TalentTreeWindow.body:GetWidth(), settings.headerheight);
TalentTreeWindow.body.ChoiceSpecs:SetPoint("TOP", 0, 0);
TalentTreeWindow.body.ChoiceSpecs:SetFrameLevel(TalentTreeWindow.body:GetFrameLevel() + 1)
SetTemplate(TalentTreeWindow.body.ChoiceSpecs);

TalentTreeWindow.body.bgbox = CreateFrame("ScrollFrame", TalentTreeWindow.body.bgbox, TalentTreeWindow.body)
TalentTreeWindow.body.bgbox:SetPoint("TOP", 0, -(TalentTreeWindow.body.ChoiceSpecs:GetHeight() - 1));
TalentTreeWindow.body.bgbox:SetSize(TalentTreeWindow.body:GetWidth(), TalentTreeWindow.body:GetHeight() -
    (TalentTreeWindow.body.ChoiceSpecs:GetHeight() - 4))

TalentTreeWindow.body.bgbox.bg = CreateFrame("FRAME", TalentTreeWindow.body.bgbox.bg, TalentTreeWindow.body.bgbox)
TalentTreeWindow.body.bgbox.bg:SetPoint("TOP", 0, 0);
TalentTreeWindow.body.bgbox.bg:SetFrameLevel(3)
TalentTreeWindow.body.bgbox.bg:SetSize(TalentTreeWindow.body:GetHeight() -
                                           (TalentTreeWindow.body.ChoiceSpecs:GetHeight() - 1),
    TalentTreeWindow.body:GetHeight() - (TalentTreeWindow.body.ChoiceSpecs:GetHeight() - 1))

TalentTreeWindow.body.bgbox.bg.texture = TalentTreeWindow.body.bgbox.bg:CreateTexture(nil, "OVERLAY");
TalentTreeWindow.body.bgbox.bg.texture:SetAllPoints();

TalentTreeWindow.body.bgbox:SetScrollChild(TalentTreeWindow.body.bgbox.bg)

-- Reset Talents --
local resetButton = CreateFrame("Button", "ResetTalentsButton", TalentTreeWindow.header, "UIPanelButtonTemplate")
resetButton:SetSize(settings.headerheight, settings.headerheight) -- Set the size of the button
resetButton:SetPoint("TOPLEFT", 8, 0) -- Position the button at the top right of the TalentTreeWindow
resetButton:SetText("R")

resetButton:SetScript("OnClick", function()
    UnlearnTalents()
    PushForgeMessage(ForgeTopic.UNLEARN_TALENT, "-1" .. ";" .. TalentTree.FORGE_SELECTED_TAB.Id);
end)

local prestigeButton = CreateFrame("Button", prestigeButton, TalentTreeWindow.header, "UIPanelButtonTemplate")
prestigeButton:SetSize(settings.headerheight, settings.headerheight) -- Set the size of the button
prestigeButton:SetPoint("TOPLEFT", settings.headerheight + 16, 0)
prestigeButton:SetText("P") -- Set the text of the button

prestigeButton:SetScript("OnClick", function()
    PushForgeMessage(ForgeTopic.PRESTIGE, "");
end)
