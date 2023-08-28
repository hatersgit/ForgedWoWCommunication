function InitializePerkExplorer()
    if (PerkExplorer) then
        return
    end

    PerkExplorer = CreateFrame("FRAME", "PerkExplorer", UIParent);
    PerkExplorer:SetSize(settings.width / 3, 30);
    PerkExplorer:SetPoint("CENTER", 0, 0);
    PerkExplorer:SetFrameStrata("DIALOG")
    PerkExplorer:SetToplevel(true)
    PerkExplorer:EnableMouse(true)
    PerkExplorer:SetMovable(true)
    PerkExplorer:SetFrameLevel(99)
    PerkExplorer:SetClampedToScreen(true)
    PerkExplorer:RegisterEvent("UNIT_LEVEL")
    PerkExplorer:SetScript("OnEvent", function()
        PushForgeMessage(ForgeTopic.OFFER_SELECTION, GetSpecID());
    end)

    PerkExplorer.header = CreateFrame("BUTTON", nil, PerkExplorer)
    PerkExplorer.header:SetSize(settings.width, 30)
    PerkExplorer.header:SetPoint("TOP", 0, 0);
    PerkExplorer.header:SetFrameLevel(PerkExplorer:GetFrameLevel() + 2)
    PerkExplorer.header:EnableMouse(true)
    PerkExplorer.header:RegisterForClicks("AnyUp", "AnyDown")
    PerkExplorer.header:SetScript("OnMouseDown", function()
        PerkExplorer:StartMoving()
    end)
    PerkExplorer.header:SetScript("OnMouseUp", function()
        PerkExplorer:StopMovingOrSizing()
    end)
    SetTemplate(PerkExplorer.header);

    PerkExplorer.header.close = CreateFrame("BUTTON", "InstallCloseButton", PerkExplorer.header, "UIPanelCloseButton")
    PerkExplorer.header.close:SetPoint("TOPRIGHT", PerkExplorer.header, "TOPRIGHT")
    PerkExplorer.header.close:SetNormalTexture(assets.maximize)
    PerkExplorer.header.close:SetPushedTexture(assets.maxPushed)
    PerkExplorer.header.close:SetScript("OnClick", function()
        ToggleBox(PerkExplorer.body:IsVisible())
    end)
    PerkExplorer.header.close:SetFrameLevel(PerkExplorer.header:GetFrameLevel() + 2)

    PerkExplorer.header.title = PerkExplorer.header:CreateFontString("OVERLAY");
    PerkExplorer.header.title:SetPoint("CENTER", PerkExplorer.header, "CENTER");
    PerkExplorer.header.title:SetFont(PATH .. "Fonts\\Expressway.TTF", 18);
    PerkExplorer.header.title:SetText("Perk Explorer");
    PerkExplorer.header.title:SetTextColor(1, 1, 1, 1);

    PerkExplorer.body = CreateFrame("FRAME", "PerkExplorerBody", PerkExplorer)
    PerkExplorer.body:SetSize(settings.width, settings.height - 30)
    PerkExplorer.body:SetPoint("TOP", 0, -30);
    PerkExplorer.body:SetFrameLevel(PerkExplorer:GetFrameLevel() + 2)

    PerkExplorer.body.subheader = CreateFrame("FRAME", nil, PerkExplorer.body)
    PerkExplorer.body.subheader:SetSize(settings.width, 30)
    PerkExplorer.body.subheader:SetPoint("TOP", 0, 0);
    PerkExplorer.body.subheader:SetFrameLevel(PerkExplorer.body:GetFrameLevel() + 2)
    SetTemplate(PerkExplorer.body.subheader);

    --createArchtype()
    createYourPerks()
    createCatalog()
    ToggleBox(true);
end

function createArchtype()
    -- ARCHTYPE TAB
    PerkExplorer.body.subheader.archtypeTab = CreateTab("Archtype")
    PerkExplorer.body.subheader.archtypeTab:SetPoint("TOPLEFT", 0, 0);
    PerkExplorer.body.subheader.archtypeTab:SetScript("OnClick", function()
        PerkExplorer.body.subheader.archtypeTab:SetButtonState("PUSHED", 1);
        PerkExplorer.body.subheader.catalogue:SetButtonState("NORMAL");
        PerkExplorer.body.subheader.yourPerksTab:SetButtonState("NORMAL");
        PerkExplorer.body.archtype:Show();
        PerkExplorer.body.catalogue:Hide();
        PerkExplorer.body.perkbox:Hide();
    end)

    PerkExplorer.body.archtype = CreateFrame("FRAME", nil, PerkExplorer.body)
    PerkExplorer.body.archtype:SetSize(settings.width, settings.height - 120);
    PerkExplorer.body.archtype:SetPoint("TOP", 0, -30);
    PerkExplorer.body.archtype:SetFrameLevel(PerkExplorer.body:GetFrameLevel() + 2);
    SetTemplate(PerkExplorer.body.archtype);

    PerkExplorer.body.archtype.yourArchtype = CreateFrame("FRAME", nil, PerkExplorer.body.archtype)
    PerkExplorer.body.archtype.yourArchtype:SetSize(settings.width - 16, (settings.height - 90) / 3)
    PerkExplorer.body.archtype.yourArchtype:SetPoint("TOP", 0, 0)
    PerkExplorer.body.archtype.yourArchtype:SetFrameLevel(PerkExplorer.body.archtype:GetFrameLevel() + 2)

    PerkExplorer.body.archtype.archtypes = {}
    local iconSize = (settings.width - settings.gap) / (settings.iconsPerRow * .5)
    for i = 1, 3 do
        local iconFrame = CreateFrame("BUTTON", "iconFrame" .. i, PerkExplorer.body.archtype.yourArchtype)
        iconFrame:SetHighlightTexture("Interface\\Buttons\\CheckButtonHilight")
        iconFrame:SetFrameLevel(PerkExplorer.body:GetFrameLevel() + 2)
        iconFrame:SetSize(iconSize, iconSize)
        iconFrame:SetPoint("CENTER", 0, iconSize - ((iconSize + 10) * i))

        local texture = iconFrame:CreateTexture(nil, "ARTWORK")
        texture:SetAllPoints(iconFrame)
        texture:SetPoint("CENTER")
        texture:SetTexture(assets.maximize)

        iconFrame.Texture = texture
        PerkExplorer.body.archtype.archtypes[i] = iconFrame
        iconFrame:Hide()
    end
end

function createYourPerks()
    PerkExplorer.body.subheader.yourPerksTab = CreateTab("Your Perks")
    PerkExplorer.body.subheader.yourPerksTab:SetPoint("TOPLEFT", 0, 0);
    PerkExplorer.body.subheader.yourPerksTab:SetScript("OnClick", function()
        PerkExplorer.body.subheader.yourPerksTab:SetButtonState("PUSHED", 1);
        PerkExplorer.body.subheader.catalogue:SetButtonState("NORMAL");
       -- PerkExplorer.body.subheader.archtypeTab:SetButtonState("NORMAL");
        PerkExplorer.body.perkbox:Show();
        PerkExplorer.body.catalogue:Hide();
        --PerkExplorer.body.archtype:Hide();
    end)
    PerkExplorer.body.subheader.yourPerksTab:SetButtonState("PUSHED", 1);

    -- PERKS LIST
    PerkExplorer.body.perkbox = CreateFrame("FRAME", nil, PerkExplorer.body)
    PerkExplorer.body.perkbox:SetSize(settings.width, settings.height - 120);
    PerkExplorer.body.perkbox:SetPoint("TOP", 0, -30);
    PerkExplorer.body.perkbox:SetFrameLevel(PerkExplorer.body:GetFrameLevel() + 2);
    SetTemplate(PerkExplorer.body.perkbox);

    PerkExplorer.body.perkbox.yourPerks = CreateFrame("FRAME", nil, PerkExplorer.body.perkbox)
    PerkExplorer.body.perkbox.yourPerks:SetSize(settings.width - 16, (settings.height - 90) / 3)
    PerkExplorer.body.perkbox.yourPerks:SetPoint("TOP", 0, 0)
    PerkExplorer.body.perkbox.yourPerks:SetFrameLevel(PerkExplorer.body.perkbox:GetFrameLevel() + 2)

    PerkExplorer.body.perkbox.yourPerks.perks = {}
    local iconSize = (settings.width - settings.gap) / (settings.iconsPerRow * 1.18)
    local depth = iconSize
    for i = 1, 40 do
        local num = (i - 1) % settings.iconsPerRow + 1
        if num == 1 then
            depth = depth - (settings.gap + iconSize)
        end

        local iconFrame = CreateFrame("BUTTON", "iconFrame" .. i, PerkExplorer.body.perkbox)
        iconFrame:SetHighlightTexture("Interface\\Buttons\\CheckButtonHilight")
        iconFrame:SetFrameLevel(PerkExplorer.body:GetFrameLevel() + 2)
        iconFrame:SetSize(iconSize, iconSize)
        iconFrame:SetPoint("TOPLEFT", settings.gap * (num - 1) + (num - 1) * iconSize, depth)

        local texture = iconFrame:CreateTexture(nil, "ARTWORK")
        texture:SetAllPoints(iconFrame)
        texture:SetPoint("CENTER")

        iconFrame.Texture = texture
        PerkExplorer.body.perkbox.yourPerks.perks[i] = iconFrame
        iconFrame:Hide()
    end
end

function createCatalog()
    -- CATALOGUE TAB
    PerkExplorer.body.subheader.catalogue = CreateTab("Perk Catalogue") -- CreateFrame("BUTTON", nil, PerkExplorer.body.subheader)
    PerkExplorer.body.subheader.catalogue:SetPoint("TOPRIGHT", 0, 0);
    PerkExplorer.body.subheader.catalogue:SetScript("OnClick", function()
        PerkExplorer.body.subheader.catalogue:SetButtonState("PUSHED", 1);
        PerkExplorer.body.subheader.yourPerksTab:SetButtonState("NORMAL");
       -- PerkExplorer.body.subheader.archtypeTab:SetButtonState("NORMAL");
        PerkExplorer.body.catalogue:Show();
        PerkExplorer.body.perkbox:Hide();
       -- PerkExplorer.body.archtype:Hide();
    end)

    PerkExplorer.body.catalogue = CreateFrame("FRAME", nil, PerkExplorer.body)
    PerkExplorer.body.catalogue:SetSize(settings.width, settings.height - 120);
    PerkExplorer.body.catalogue:SetPoint("TOP", 0, -30)
    SetTemplate(PerkExplorer.body.catalogue);

    PerkExplorer.body.catalogue.searchBar = CreateFrame("EditBox", nil, PerkExplorer.body.catalogue)
    PerkExplorer.body.catalogue.searchBar:SetSize(115, 30);
    PerkExplorer.body.catalogue.searchBar:SetPoint("TOPLEFT", 15, 0)
    PerkExplorer.body.catalogue.searchBar:SetMultiLine(false)
    PerkExplorer.body.catalogue.searchBar:SetFontObject(ChatFontNormal)
    PerkExplorer.body.catalogue.searchBar:SetWidth(300)
    PerkExplorer.body.catalogue.searchBar:SetFont("Fonts\\ARIALN.TTF", 14);
    PerkExplorer.body.catalogue.searchBar:SetMaxLetters(90);
    PerkExplorer.body.catalogue.searchBar:SetAutoFocus(false)
    PerkExplorer.body.catalogue.searchBar:SetScript("OnTextChanged", function(self, input)
        if (input) then
            LoadAllPerksList(string.upper(self:GetText()))
        end
    end)
    PerkExplorer.body.catalogue.searchBar:SetScript("OnEscapePressed", function(self, input)
        self:ClearFocus()
    end)

    searchtexBox = PerkExplorer.body.catalogue.searchBar:CreateTexture("", "BACKGROUND");
    searchtexBox:SetTexture("Interface\\COMMON\\Common-Input-Border.blp");
    searchtexBox:SetPoint("CENTER", PerkExplorer.body.catalogue.searchBar, "CENTER", -5, -5);
    searchtexBox:SetSize(300, 30);

    PerkExplorer.body.catalogue.clipframe = CreateFrame("FRAME", nil, PerkExplorer.body.catalogue)
    PerkExplorer.body.catalogue.clipframe:SetSize(settings.width, settings.height - 160)
    PerkExplorer.body.catalogue.clipframe:SetPoint("TOP", 0, -40)

    PerkExplorer.body.catalogue.clipframe.scroll = CreateFrame("ScrollFrame", "perkScroll",
        PerkExplorer.body.catalogue.clipframe, "UIPanelScrollFrameTemplate")
    PerkExplorer.body.catalogue.clipframe.scroll:SetPoint("TOPLEFT", -30, 10);
    PerkExplorer.body.catalogue.clipframe.scroll:SetPoint("BOTTOMRIGHT", -30, 10);

    local scrollcat = CreateFrame("FRAME");
    scrollcat:SetSize(settings.width, settings.height)
    scrollcat.perks = {}
    PerkExplorer.body.catalogue.clipframe.scroll:SetScrollChild(scrollcat);
    PerkExplorer.body.catalogue:Hide();
end

function CreateTab(titleText)
    local tab = CreateFrame("BUTTON", nil, PerkExplorer.body.subheader)
    tab:SetHighlightTexture("Interface\\Buttons\\WHITE8x8");
    tab:SetPushedTexture("Interface\\Buttons\\WHITE8x8");
    tab:SetSize(settings.width / settings.tabCount, 30)
    tab:SetFrameLevel(PerkExplorer.body.subheader:GetFrameLevel() + 2)
    SetTemplate(tab);
    tab.title = tab:CreateFontString("OVERLAY");
    tab.title:SetPoint("CENTER", tab, "CENTER");
    tab.title:SetFont(PATH .. "Fonts\\Expressway.TTF", 16);
    tab.title:SetText(titleText);
    tab.title:SetTextColor(1, 1, 1, 1);
    return tab
end

function ToggleBox(visible)
    if (visible) then
        PerkExplorer.body:Hide();
        PerkExplorer.header:SetSize(settings.width / 3, 30)
        PerkExplorer.header.close:SetNormalTexture(assets.maximize)
        PerkExplorer.header.close:SetPushedTexture(assets.maxPushed)
    else
        PerkExplorer.header:SetSize(settings.width, 30)
        PerkExplorer.body:Show(settings.width, 30);
        PerkExplorer.header.close:SetNormalTexture(assets.minimize)
        PerkExplorer.header.close:SetPushedTexture(assets.minPushed)
    end
end

function LoadAllPerksList(filterText)
    local iconsPerRow = 14;
    local i = 1;
    local rowCount = 1;
    local iconSize = ((settings.width - 130) / 15)
    local depth = iconSize;
    local xOffset = 40

    local perkFrame = PerkExplorer.body.catalogue.clipframe.scroll:GetScrollChild();
    for i, v in ipairs(perkFrame.perks) do
        v:Hide()
    end

    for spellId, meta in pairs(PerkExplorerInternal.PERKS_ALL) do
        local metainfo = meta[1];
        local name, _, icon = GetSpellInfo(spellId);

        if (rowCount > iconsPerRow) then
            rowCount = 1
        end

        if name then
            if (string.match(string.upper(name), filterText) or filterText == "") then
                perkFrame.perks[i] = CreateFrame("BUTTON", perkFrame.perks[i], perkFrame);
                perkFrame.perks[i]:SetHighlightTexture("Interface\\Buttons\\CheckButtonHilight");
                perkFrame.perks[i]:SetFrameLevel(perkFrame:GetFrameLevel());
                perkFrame.perks[i]:SetSize(iconSize, iconSize);
                perkFrame.perks[i]:SetPoint("TOPLEFT", settings.gap * rowCount + (rowCount - 1) * iconSize + xOffset,
                    -math.floor(i / (iconsPerRow + 1)) * (iconSize + settings.gap + 5));
                perkFrame.perks[i].Texture = perkFrame.perks[i]:CreateTexture();
                perkFrame.perks[i].Texture:SetAllPoints();
                perkFrame.perks[i].Texture:SetPoint("CENTER", 0, 0);
                perkFrame.perks[i].Texture:SetTexture(icon);

                local unique = metainfo.unique;
                if unique > 0 then
                    perkFrame.perks[i]:HookScript("OnEnter", function()
                        local side, _, _, xOfs = PerkExplorer:GetPoint()
                        if (side == "LEFT" or ((xOfs > -(GetScreenWidth() * .1879) and xOfs < 0) and side == "CENTER")) then
                            SetUpSingleTooltip(PerkExplorer.body.perkbox, spellId, "ANCHOR_RIGHT");
                        else
                            SetUpSingleTooltip(PerkExplorer.body.perkbox, spellId, "ANCHOR_LEFT");
                        end
                    end);
                else
                    perkFrame.perks[i]:HookScript("OnEnter", function()

                        local side, _, _, xOfs = PerkExplorer:GetPoint()
                        if (side == "LEFT" or ((xOfs > -(GetScreenWidth() * .1879) and xOfs < 0) and side == "CENTER")) then
                            SetUpRankedTooltip(PerkExplorer.body.perkbox, spellId, "ANCHOR_RIGHT");
                        else
                            SetUpRankedTooltip(PerkExplorer.body.perkbox, spellId, "ANCHOR_LEFT");
                        end
                    end);
                end
                perkFrame.perks[i]:SetScript("OnLeave", function()
                    clearTooltips()
                end);
                perkFrame.perks[i]:Show();
                rowCount = rowCount + 1;
                i = i + 1;

            else
                if perkFrame.perks[i] then
                    perkFrame.perks[i]:Hide();
                end
            end
        end
    end
    perkFrame:SetSize(settings.width, -1 * (depth - (iconSize + settings.gap)));
end

function LoadCurrentPerks(spec)
    HideCharPerks();
    local i = 1;
    for specId, perk in ipairs(PerkExplorerInternal.PERKS_SPEC) do
        for spellId, meta in pairs(PerkExplorerInternal.PERKS_SPEC[specId]) do
            local name, _, icon = GetSpellInfo(spellId);
            local rank = meta[1].rank;
            local current = PerkExplorer.body.perkbox.yourPerks.perks[i]
            current.Texture:SetTexture(icon);
            SetRankTexture(current, rank)

            current:HookScript("OnEnter", function()
                local side, _, _, xOfs = PerkExplorer:GetPoint()
                if (side == "LEFT" or ((xOfs > -(GetScreenWidth() * .1879) and xOfs < 0) and side == "CENTER")) then
                    SetUpRankedTooltip(PerkExplorer.body.perkbox, spellId, "ANCHOR_RIGHT");
                else
                    SetUpRankedTooltip(PerkExplorer.body.perkbox, spellId, "ANCHOR_LEFT");
                end
            end);
            current:SetScript("OnLeave", function()
                clearTooltips()
            end);
            current:SetScript("OnClick", function()
                lastSelectedSpell = spellId
                StaticPopup_Show("REROLL_PERK", name)
            end);
            current:Show()
            i = i + 1;
        end
    end
end

function HideCharPerks()
    for i = 1, 40, 1 do
        PerkExplorer.body.perkbox.yourPerks.perks[i]:Hide();
    end
end
