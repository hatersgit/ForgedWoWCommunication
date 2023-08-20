function InitializeSelectionWindow()
    PerkSelectionWindow = CreateFrame("FRAME", "PerkSelectionWindow", UIParent);
    PerkSelectionWindow:SetSize(10, 10);
    PerkSelectionWindow:SetPoint("CENTER", 0, 0);
    PerkSelectionWindow:SetFrameLevel(1);
    PerkSelectionWindow:SetFrameStrata("HIGH");

    PerkSelectionWindow.Title = PerkSelectionWindow:CreateFontString(nil, "OVERLAY", "GameFontHighlight");
    PerkSelectionWindow.Title:SetPoint("CENTER", nil, "CENTER", 0, (GetScreenHeight() / 2) - 100);
    PerkSelectionWindow.Title:SetFont(PATH.."Fonts\\Expressway.TTF", 72);
    PerkSelectionWindow.Title:SetShadowOffset(1, -1);
    PerkSelectionWindow.Title:SetText("Select A Perk");

    PerkSelectionWindow.background = CreateFrame("Frame", nil, PerkSelectionWindow)
    PerkSelectionWindow.background:SetPoint("CENTER", PerkSelectionWindow.Title, "CENTER", 0, -50)
    PerkSelectionWindow.background:SetSize(350, 150)
    PerkSelectionWindow.background:SetBackdrop({
        bgFile = "Interface/TutorialFrame/TutorialFrameBackground",
        edgeFile = "Interface/Tooltips/UI-Tooltip-Border",
        tile = true,
        edgeSize = 22,
        tileSize = 22,
        insets = {
            left = 4,
            right = 4,
            top = 4,
            bottom = 4
        }
    })
    PerkSelectionWindow.background:SetFrameStrata("LOW");

    PerkSelectionWindow.SelectionPool = CreateFrame("FRAME", PerkSelectionWindow.SelectionPool, PerkSelectionWindow);
    PerkSelectionWindow.SelectionPool:SetPoint("TOP", 0, (GetScreenHeight() / 2) - 150);
    PerkSelectionWindow.SelectionPool.Pool = {};

    for i = 1, 4, 1 do
        PerkSelectionWindow.SelectionPool.Pool[i] = CreateFrame("Button", PerkSelectionWindow.SelectionPool.Pool[i],
            PerkSelectionWindow.SelectionPool);
        local cur = PerkSelectionWindow.SelectionPool.Pool[i]

        cur.Icon = CreateFrame("FRAME", cur.Icon, cur);
        cur.Icon:SetPoint("CENTER", 0, 0)
        cur.Icon:SetFrameLevel(2);
        cur.Icon:SetSize(settings.selectionIconSize, settings.selectionIconSize);

        cur.Icon.Texture = cur.Icon:CreateTexture(nil, "ARTWORK");
        cur.Icon.Texture:SetAllPoints();
        -- cur.Icon.Texture:SetTexCoord(.08, .92, .08, .92);

        cur.Icon.Carried = cur.Icon:CreateTexture(nil, "OVERLAY");
        cur.Icon.Carried:SetSize(settings.selectionIconSize / 2, settings.selectionIconSize / 2);
        cur.Icon.Carried:SetPoint("BOTTOM", 0, -settings.selectionIconSize / 4);
        cur.Icon.Carried:SetTexture(assets.hourglass);
        cur.Icon.Carried:Hide();
    end
    PerkSelectionWindow:Hide();
end

function TogglePerkSelectionFrame(off)
    if (off) then
        PerkSelectionWindow:Hide()
        PlaySound("TalentScreenClose");
    else
        PerkSelectionWindow:Show()
        PlaySound("TalentScreenOpen");
    end
end

function AddSelectCard(id, index, count, carryover)
    local _, _, icon = GetSpellInfo(id);
    local curPool = PerkSelectionWindow.SelectionPool.Pool[index]
    curPool:SetFrameLevel(1);
    curPool:SetPoint("TOPLEFT", (index - 1) * (settings.selectionIconSize + settings.selectionIconSize), 0);
    curPool:SetSize(settings.selectionIconSize, settings.selectionIconSize);
    curPool.Icon.Texture:SetTexture(icon);
    if (carryover > 0) then
        curPool.Icon.Carried:Show();
    else
        curPool.Icon.Carried:Hide();
    end

    curPool:HookScript("OnEnter", function()
        SetUpRankedTooltip(curPool, id, "ANCHOR_BOTTOM");
    end);
    curPool:SetScript("OnLeave", function()
        clearTooltips()
    end);
    curPool:SetScript("OnClick", function()
        if (PerkExplorerInternal.PERKS_ALL[id][1]["unique"] == 1) then
            for specId, perk in ipairs(PerkExplorerInternal.PERKS_SPEC) do
                for spellId, meta in pairs(PerkExplorerInternal.PERKS_SPEC[specId]) do
                    if (id == spellId) then
                        print("You already have this unique!")
                        return
                    end
                end
            end
        end
        PushForgeMessage(ForgeTopic.LEARN_PERK, GetSpecID() .. ";" .. id);
        PerkSelectionWindow:Hide();
    end);
end
