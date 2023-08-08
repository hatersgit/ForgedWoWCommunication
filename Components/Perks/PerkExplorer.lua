function InitializePerkExplorer()

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
    PerkExplorer.header.close:SetScript("OnClick", function()
        ToggleBox(PerkExplorer.body:IsVisible())
    end)
    PerkExplorer.header.close:SetFrameLevel(PerkExplorer.header:GetFrameLevel() + 2)

    PerkExplorer.header.title = PerkExplorer.header:CreateFontString("OVERLAY");
    PerkExplorer.header.title:SetPoint("CENTER", PerkExplorer.header, "CENTER");
    -- PerkExplorer.header.title:SetFont("Fonts\\AvQest.TTF", 18);
    PerkExplorer.header.title:SetFont("Fonts\\FRIZQT__.TTF", 18);
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

    -- YOUR PERKS TAB
    PerkExplorer.body.subheader.yourPerksTab = CreateFrame("BUTTON", nil, PerkExplorer.body.subheader)
    PerkExplorer.body.subheader.yourPerksTab:SetHighlightTexture("Interface\\Buttons\\WHITE8x8");
    PerkExplorer.body.subheader.yourPerksTab:SetPushedTexture("Interface\\Buttons\\WHITE8x8");
    PerkExplorer.body.subheader.yourPerksTab:SetSize(settings.width / 2, 30)
    PerkExplorer.body.subheader.yourPerksTab:SetPoint("TOPLEFT", 0, 0);
    PerkExplorer.body.subheader.yourPerksTab:SetFrameLevel(PerkExplorer.body.subheader:GetFrameLevel() + 2)
    PerkExplorer.body.subheader.yourPerksTab:SetScript("OnClick", function()
        PerkExplorer.body.subheader.yourPerksTab:SetButtonState("PUSHED", 1);
        PerkExplorer.body.subheader.catalogue:SetButtonState("NORMAL");
        PerkExplorer.body.perkbox:Show();
        PerkExplorer.body.catalogue:Hide();
    end)
    PerkExplorer.body.subheader.yourPerksTab:SetButtonState("PUSHED", 1);
    SetTemplate(PerkExplorer.body.subheader.yourPerksTab);

    PerkExplorer.body.subheader.yourPerksTab.title =
        PerkExplorer.body.subheader.yourPerksTab:CreateFontString("OVERLAY");
    PerkExplorer.body.subheader.yourPerksTab.title:SetPoint("CENTER", PerkExplorer.body.subheader.yourPerksTab, "CENTER");
    -- PerkExplorer.body.subheader.combat.title:SetFont("Fonts\\AvQest.TTF", 16);
    PerkExplorer.body.subheader.yourPerksTab.title:SetFont("Fonts\\FRIZQT__.TTF", 16)
    PerkExplorer.body.subheader.yourPerksTab.title:SetText("Your Perks");
    PerkExplorer.body.subheader.yourPerksTab.title:SetTextColor(1, 1, 1, 1);

    -- CATALOGUE TAB
    PerkExplorer.body.subheader.catalogue = CreateFrame("BUTTON", nil, PerkExplorer.body.subheader)
    PerkExplorer.body.subheader.catalogue:SetHighlightTexture("Interface\\Buttons\\WHITE8x8");
    PerkExplorer.body.subheader.catalogue:SetPushedTexture("Interface\\Buttons\\WHITE8x8");
    PerkExplorer.body.subheader.catalogue:SetSize(settings.width / 2, 30)
    PerkExplorer.body.subheader.catalogue:SetPoint("TOPRIGHT", 0, 0);
    PerkExplorer.body.subheader.catalogue:SetFrameLevel(PerkExplorer.body.subheader:GetFrameLevel() + 2)
    PerkExplorer.body.subheader.catalogue:SetScript("OnClick", function()
        PerkExplorer.body.subheader.catalogue:SetButtonState("PUSHED", 1);
        PerkExplorer.body.subheader.yourPerksTab:SetButtonState("NORMAL");
        PerkExplorer.body.catalogue:Show();
        PerkExplorer.body.perkbox:Hide();
    end)
    SetTemplate(PerkExplorer.body.subheader.catalogue);

    PerkExplorer.body.subheader.catalogue.title = PerkExplorer.body.subheader.catalogue:CreateFontString("OVERLAY");
    PerkExplorer.body.subheader.catalogue.title:SetPoint("CENTER", PerkExplorer.body.subheader.catalogue, "CENTER");
    -- PerkExplorer.body.subheader.catalogue.title:SetFont("Fonts\\AvQest.TTF", 16);
    PerkExplorer.body.subheader.catalogue.title:SetFont("Fonts\\FRIZQT__.TTF", 16)
    PerkExplorer.body.subheader.catalogue.title:SetText("Perk Catalogue");
    PerkExplorer.body.subheader.catalogue.title:SetTextColor(1, 1, 1, 1);

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

    PerkExplorer.body.perkbox.yourPerks.perks = {};
    local rowCount = 1;
    local iconSize = (settings.width - settings.gap) / (settings.iconsPerRow * 1.18)
    local depth = iconSize;
    for i = 1, 40, 1 do
        if (rowCount > settings.iconsPerRow) then
            rowCount = 1
        end

        local num = math.fmod(i, settings.iconsPerRow);
        if (num == 1) then
            depth = depth - (settings.gap + iconSize)
        end

        local iconFrame = CreateFrame("BUTTON", "iconFrame" .. i, PerkExplorer.body.perkbox);
        iconFrame:SetHighlightTexture("Interface\\Buttons\\CheckButtonHilight");
        iconFrame:SetFrameLevel(PerkExplorer.body.perkbox:GetFrameLevel() + 2);
        iconFrame:SetSize(iconSize, iconSize);
        iconFrame:SetPoint("TOPLEFT", settings.gap * rowCount + (rowCount - 1) * iconSize, depth);

        local texture = iconFrame:CreateTexture(nil, "ARTWORK", nil, PerkExplorer.body.perkbox:GetFrameLevel() + 3);
        texture:SetAllPoints(iconFrame);
        -- texture:SetTexCoord(.08, .92, .08, .92);
        texture:SetPoint("CENTER", 0, 0);

        iconFrame.Texture = texture;
        PerkExplorer.body.perkbox.yourPerks.perks[i] = iconFrame;

        PerkExplorer.body.perkbox.yourPerks.perks[i]:Hide();
        rowCount = rowCount + 1;
    end

    ToggleBox(true);

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
    PerkExplorer.body.catalogue.searchBar:SetMultiLine(false);
    PerkExplorer.body.catalogue.searchBar:SetScript("OnTextChanged", function(self, input)
        if (input) then
            LoadAllPerksList(string.upper(self:GetText()))
        end
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

function ToggleBox(visible)
    if (visible) then
        PerkExplorer.body:Hide();
        PerkExplorer.header:SetSize(settings.width / 3, 30)
    else
        PerkExplorer.header:SetSize(settings.width, 30)
        PerkExplorer.body:Show(settings.width, 30);
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

        if (name ~= nil) then
            if (string.match(string.upper(name), filterText) or filterText == "") then
                perkFrame.perks[i] = CreateFrame("BUTTON", perkFrame.perks[i], perkFrame);
                perkFrame.perks[i]:SetHighlightTexture("Interface\\Buttons\\CheckButtonHilight");
                perkFrame.perks[i]:SetFrameLevel(perkFrame:GetFrameLevel());
                perkFrame.perks[i]:SetSize(iconSize, iconSize);
                perkFrame.perks[i]:SetPoint("TOPLEFT", settings.gap * rowCount + (rowCount - 1) * iconSize + xOffset,
                    -math.floor(i / (iconsPerRow + 1)) * (iconSize + settings.gap + 5));
                perkFrame.perks[i].Texture = perkFrame.perks[i]:CreateTexture();
                perkFrame.perks[i].Texture:SetAllPoints();
                -- perkFrame.perks[i].Texture:SetTexCoord(.08, .92, .08, .92);
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
                if (perkFrame.perks[i] ~= nil) then
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

function SetRankTexture(current, rank)
    if (rank == 1) then
        if current.Rank ~= nil then
            current.Rank:Hide()
        end
        return
    end
    if current.Rank == nil then
        current.Rank = current:CreateTexture(nil, "ARTWORK", nil, current:GetFrameLevel() + 3);
    end
    current.Rank:SetSize((settings.width - settings.gap) / (settings.iconsPerRow * 1.18) * 2,
        (settings.width - settings.gap) / (settings.iconsPerRow * 1.18) * 2)
    current.Rank:SetPoint("CENTER", 0, 0);

    if (rank == 2) then
        current.Rank:SetTexture(assets.ranktwo)
    elseif (rank == 3) then
        current.Rank:SetTexture(assets.rankthree)
    end
end

function HideCharPerks()
    for i = 1, 40, 1 do
        PerkExplorer.body.perkbox.yourPerks.perks[i]:Hide();
    end
end