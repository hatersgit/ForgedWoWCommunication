function InitializeSelectionWindow()
    selR1PerkTooltip = CreateFrame("GameTooltip", "selR1PerkTooltip", UIParent, "GameTooltipTemplate");
    SetTemplate(selR1PerkTooltip);
    selR2PerkTooltip = CreateFrame("GameTooltip", "selR2PerkTooltip", UIParent, "GameTooltipTemplate");
    SetTemplate(selR2PerkTooltip);
    selR3PerkTooltip = CreateFrame("GameTooltip", "selR3PerkTooltip", UIParent, "GameTooltipTemplate");
    SetTemplate(selR3PerkTooltip);

    PerkSelectionWindow = CreateFrame("FRAME", "PerkSelectionWindow", UIParent);
    PerkSelectionWindow:SetSize(10, 10);
    PerkSelectionWindow:SetPoint("CENTER", 0, 0);
    PerkSelectionWindow:SetFrameLevel(1);
    PerkSelectionWindow:SetFrameStrata("LOW");

    PerkSelectionWindow.Title = PerkSelectionWindow:CreateFontString(nil, "OVERLAY", "GameFontHighlight");
    PerkSelectionWindow.Title:SetPoint("CENTER", nil, "CENTER", 0, (GetScreenHeight()/2)-100);
    PerkSelectionWindow.Title:SetFont("Fonts\\AvQest.TTF", 72);
    PerkSelectionWindow.Title:SetShadowOffset(1, -1);
    PerkSelectionWindow.Title:SetText("Select a perk:");

    PerkSelectionWindow.SelectionPool = CreateFrame("FRAME", PerkSelectionWindow.SelectionPool, PerkSelectionWindow);
    PerkSelectionWindow.SelectionPool:SetPoint("TOP", 0, (GetScreenHeight()/2)-150);
    PerkSelectionWindow.SelectionPool.Pool = {};

    for i=1,4,1 do
        PerkSelectionWindow.SelectionPool.Pool[i] = CreateFrame("Button",
        PerkSelectionWindow.SelectionPool.Pool[i], PerkSelectionWindow.SelectionPool);
        PerkSelectionWindow.SelectionPool.Pool[i]:SetHighlightTexture("Interface\\Buttons\\WHITE8x8");
        PerkSelectionWindow.SelectionPool.Pool[i]:SetFrameLevel(1);
        PerkSelectionWindow.SelectionPool.Pool[i]:SetSize(settings.iconCont, settings.iconCont);
        SetTemplate(PerkSelectionWindow.SelectionPool.Pool[i]);

        PerkSelectionWindow.SelectionPool.Pool[i].Icon = CreateFrame("FRAME", PerkSelectionWindow.SelectionPool.Pool[i].Icon, PerkSelectionWindow.SelectionPool.Pool[i]);
        PerkSelectionWindow.SelectionPool.Pool[i].Icon:SetPoint("CENTER", 0, 0)
        PerkSelectionWindow.SelectionPool.Pool[i].Icon:SetFrameLevel(2);
        PerkSelectionWindow.SelectionPool.Pool[i].Icon:SetSize(settings.spacer, settings.spacer);

        PerkSelectionWindow.SelectionPool.Pool[i].Icon.Texture = PerkSelectionWindow.SelectionPool.Pool[i].Icon:CreateTexture(nil, "ARTWORK");
        PerkSelectionWindow.SelectionPool.Pool[i].Icon.Texture:SetAllPoints();
        PerkSelectionWindow.SelectionPool.Pool[i].Icon.Texture:SetTexCoord(.08, .92, .08, .92);

        PerkSelectionWindow.SelectionPool.Pool[i].Icon.Carried = PerkSelectionWindow.SelectionPool.Pool[i].Icon:CreateTexture(nil, "OVERLAY");
        PerkSelectionWindow.SelectionPool.Pool[i].Icon.Carried:SetSize(settings.spacer/2, settings.spacer/2);
        PerkSelectionWindow.SelectionPool.Pool[i].Icon.Carried:SetPoint("BOTTOM", 0, -settings.spacer/4);
        PerkSelectionWindow.SelectionPool.Pool[i].Icon.Carried:SetTexture(assets.hourglass);
        PerkSelectionWindow.SelectionPool.Pool[i].Icon.Carried:Hide();
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
    local name, rank, icon, castTime, minRange, maxRange, spellID = GetSpellInfo(id);

    PerkSelectionWindow.SelectionPool.Pool[index]:SetFrameLevel(1);
    PerkSelectionWindow.SelectionPool.Pool[index]:SetPoint("TOPLEFT", (index-1)*(settings.spacer+settings.spacer), 0);
    PerkSelectionWindow.SelectionPool.Pool[index]:SetSize(settings.spacer, settings.spacer);

    PerkSelectionWindow.SelectionPool.Pool[index].Icon.Texture:SetTexture(icon);
    if (carryover > 0) then
        PerkSelectionWindow.SelectionPool.Pool[index].Icon.Carried:Show();
    else
        PerkSelectionWindow.SelectionPool.Pool[index].Icon.Carried:Hide();
    end

    PerkSelectionWindow.SelectionPool.Pool[index]:HookScript("OnEnter", function() 
        SetUpRankedTooltip(PerkSelectionWindow.SelectionPool.Pool[index], id, selR1PerkTooltip, selR2PerkTooltip, selR3PerkTooltip, "ANCHOR_BOTTOM");
    end);
    PerkSelectionWindow.SelectionPool.Pool[index]:SetScript("OnLeave", function() 
        selR1PerkTooltip:Hide();
        selR2PerkTooltip:Hide();
        selR3PerkTooltip:Hide();
    end);
    PerkSelectionWindow.SelectionPool.Pool[index]:SetScript("OnClick", function()
        PushForgeMessage(ForgeTopic.LEARN_PERK, GetSpecialization()..";"..id);
        PerkSelectionWindow:Hide();
    end);
end