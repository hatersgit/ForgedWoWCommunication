assets = {
    rankone = "Interface\\AddOns\\ForgedWoW\\UI\\Perk\\rank1",
    ranktwo = "Interface\\AddOns\\ForgedWoW\\UI\\Perk\\rank2",
    rankthree = "Interface\\AddOns\\ForgedWoW\\UI\\Perk\\rank3",
    hourglass = "Interface\\AddOns\\ForgedWoW\\UI\\Perk\\hourglass",
    highlight = "Interface\\AddOns\\ForgedWoW\\UI\\Perk\\highlight", 
}

function InitializePerkExplorer()
    local width = GetScreenWidth()/3;
    local height = GetScreenHeight()/2;

    perkTooltip1 = CreateFrame("GameTooltip", "perkTooltip1", UIParent, "GameTooltipTemplate");
    SetTemplate(perkTooltip1);
    perkTooltip2 = CreateFrame("GameTooltip", "perkTooltip2", UIParent, "GameTooltipTemplate");
    SetTemplate(perkTooltip2);
    perkTooltip3 = CreateFrame("GameTooltip", "perkTooltip3", UIParent, "GameTooltipTemplate");
    SetTemplate(perkTooltip3);

    PerkExplorer = CreateFrame("FRAME", "PerkExplorer", UIParent);
    PerkExplorer:SetSize(width/3, 30);
    PerkExplorer:SetPoint("CENTER", 0, 0);
    PerkExplorer:SetFrameStrata("DIALOG")
    PerkExplorer:SetToplevel(true)
    PerkExplorer:EnableMouse(true)
    PerkExplorer:SetMovable(true)
    PerkExplorer:SetFrameLevel(99)
    PerkExplorer:SetClampedToScreen(true)

    PerkExplorer.header = CreateFrame("BUTTON", nil, PerkExplorer)
    PerkExplorer.header:SetSize(width, 30)
    PerkExplorer.header:SetPoint("TOP", 0, 0);
    PerkExplorer.header:SetFrameLevel(PerkExplorer:GetFrameLevel() + 2)
    PerkExplorer.header:EnableMouse(true)
    PerkExplorer.header:RegisterForClicks("AnyUp", "AnyDown")
    PerkExplorer.header:SetScript("OnMouseDown", function() PerkExplorer:StartMoving() end)
    PerkExplorer.header:SetScript("OnMouseUp", function() PerkExplorer:StopMovingOrSizing() end)
    SetTemplate(PerkExplorer.header);

    PerkExplorer.header.close = CreateFrame("BUTTON","InstallCloseButton", PerkExplorer.header, "UIPanelCloseButton")
    PerkExplorer.header.close:Point("TOPRIGHT", PerkExplorer.header, "TOPRIGHT")
    PerkExplorer.header.close:SetScript("OnClick", function() ToggleBox(PerkExplorer.body:IsVisible()) end)
    PerkExplorer.header.close:SetFrameLevel(PerkExplorer.header:GetFrameLevel() + 2)

    PerkExplorer.header.title = PerkExplorer.header:CreateFontString("OVERLAY");
    PerkExplorer.header.title:Point("CENTER", PerkExplorer.header, "CENTER");
    PerkExplorer.header.title:SetFont("Fonts\\AvQest.TTF", 18);
    PerkExplorer.header.title:SetText("Perk Explorer");
    PerkExplorer.header.title:SetTextColor(1,1,1,1);

    PerkExplorer.body = CreateFrame("FRAME", "PerkExplorerBody", PerkExplorer)
    PerkExplorer.body:SetSize(width, height-30)
    PerkExplorer.body:SetPoint("TOP", 0, -30);
    PerkExplorer.body:SetFrameLevel(PerkExplorer:GetFrameLevel() + 2)

    PerkExplorer.body.subheader = CreateFrame("FRAME", nil, PerkExplorer.body)
    PerkExplorer.body.subheader:SetSize(width, 30)
    PerkExplorer.body.subheader:SetPoint("TOP", 0, 0);
    PerkExplorer.body.subheader:SetFrameLevel(PerkExplorer.body:GetFrameLevel() + 2)
    SetTemplate(PerkExplorer.body.subheader);
    
    -- YOUR PERKS TAB
    PerkExplorer.body.subheader.combat = CreateFrame("BUTTON", nil, PerkExplorer.body.subheader)
    PerkExplorer.body.subheader.combat:SetHighlightTexture("Interface\\Buttons\\WHITE8x8");
    PerkExplorer.body.subheader.combat:SetPushedTexture("Interface\\Buttons\\WHITE8x8");
    PerkExplorer.body.subheader.combat:SetSize(width/2, 30)
    PerkExplorer.body.subheader.combat:SetPoint("TOPLEFT", 0, 0);
    PerkExplorer.body.subheader.combat:SetFrameLevel(PerkExplorer.body.subheader:GetFrameLevel() + 2)
    PerkExplorer.body.subheader.combat:SetScript("OnClick", function()
        PerkExplorer.body.subheader.combat:SetButtonState("PUSHED", 1);
        PerkExplorer.body.subheader.catalogue:SetButtonState("NORMAL");
        PerkExplorer.body.perkbox:Show();
        PerkExplorer.body.catalogue:Hide();
    end)
    PerkExplorer.body.subheader.combat:SetButtonState("PUSHED", 1);
    SetTemplate(PerkExplorer.body.subheader.combat);

    PerkExplorer.body.subheader.combat.title = PerkExplorer.body.subheader.combat:CreateFontString("OVERLAY");
    PerkExplorer.body.subheader.combat.title:Point("CENTER", PerkExplorer.body.subheader.combat, "CENTER");
    PerkExplorer.body.subheader.combat.title:SetFont("Fonts\\AvQest.TTF", 16);
    PerkExplorer.body.subheader.combat.title:SetText("Your Perks");
    PerkExplorer.body.subheader.combat.title:SetTextColor(1,1,1,1);

    -- CATALOGUE TAB
    PerkExplorer.body.subheader.catalogue = CreateFrame("BUTTON", nil, PerkExplorer.body.subheader)
    PerkExplorer.body.subheader.catalogue:SetHighlightTexture("Interface\\Buttons\\WHITE8x8");
    PerkExplorer.body.subheader.catalogue:SetPushedTexture("Interface\\Buttons\\WHITE8x8");
    PerkExplorer.body.subheader.catalogue:SetSize(width/2, 30)
    PerkExplorer.body.subheader.catalogue:SetPoint("TOPRIGHT", 0, 0);
    PerkExplorer.body.subheader.catalogue:SetFrameLevel(PerkExplorer.body.subheader:GetFrameLevel() + 2)
    PerkExplorer.body.subheader.catalogue:SetScript("OnClick", function()
        PerkExplorer.body.subheader.catalogue:SetButtonState("PUSHED", 1);
        PerkExplorer.body.subheader.combat:SetButtonState("NORMAL");
        PerkExplorer.body.catalogue:Show();
        PerkExplorer.body.perkbox:Hide();
    end)
    SetTemplate(PerkExplorer.body.subheader.catalogue);

    PerkExplorer.body.subheader.catalogue.title = PerkExplorer.body.subheader.catalogue:CreateFontString("OVERLAY");
    PerkExplorer.body.subheader.catalogue.title:Point("CENTER", PerkExplorer.body.subheader.catalogue, "CENTER");
    PerkExplorer.body.subheader.catalogue.title:SetFont("Fonts\\AvQest.TTF", 16);
    PerkExplorer.body.subheader.catalogue.title:SetText("Perk Catalogue");
    PerkExplorer.body.subheader.catalogue.title:SetTextColor(1,1,1,1);

    -- PERKS LIST
    PerkExplorer.body.perkbox = CreateFrame("FRAME", nil, PerkExplorer.body)
    PerkExplorer.body.perkbox:SetSize(width, height-120);
    PerkExplorer.body.perkbox:SetPoint("TOP", 0, -30);
    PerkExplorer.body.perkbox:SetFrameLevel(PerkExplorer.body:GetFrameLevel() + 2);
    SetTemplate(PerkExplorer.body.perkbox);

    PerkExplorer.body.perkbox.combat = CreateFrame("FRAME", nil, PerkExplorer.body.perkbox)
    PerkExplorer.body.perkbox.combat:SetSize(width-16, (height-90)/3)
    PerkExplorer.body.perkbox.combat:SetPoint("TOP", 0, 0)
    PerkExplorer.body.perkbox.combat:SetFrameLevel(PerkExplorer.body.perkbox:GetFrameLevel() + 2)

    PerkExplorer.body.perkbox.combat.perks = {};
    local iconsPerRow = 12;
    local gap = 8;
    local iconSize = ((width-10)-gap*(iconsPerRow))/iconsPerRow;
    local rowCount = 1;

    local depth = iconSize;
    for i = 1, 40, 1 do
        if (rowCount > iconsPerRow) then
            rowCount = 1
        end

        local num = math.fmod(i, iconsPerRow);
        if (num == 1) then
            depth = depth - (gap+iconSize)
        end

        local iconFrame = CreateFrame("BUTTON", "iconFrame"..i, PerkExplorer.body.perkbox);
        iconFrame:SetHighlightTexture("Interface\\Buttons\\WHITE8x8");
        iconFrame:SetFrameLevel(PerkExplorer.body.perkbox:GetFrameLevel() + 2);
        iconFrame:SetSize(iconSize, iconSize);
        iconFrame:SetPoint("TOPLEFT", gap*rowCount+(rowCount-1)*iconSize, depth);
        
        local texture = iconFrame:CreateTexture(nil, "ARTWORK", nil, PerkExplorer.body.perkbox:GetFrameLevel() + 3);
        texture:SetAllPoints(iconFrame);
        texture:SetTexCoord(.08, .92, .08, .92);
        texture:SetPoint("CENTER", 0, 0);

        starsize = iconSize/2;
        local star = iconFrame:CreateTexture(nil, "OVERLAY", nil, PerkExplorer.body.perkbox:GetFrameLevel() + 4);
        star:SetPoint("TOP", 0, 0);
        star:SetSize(starsize, starsize);

        iconFrame.Rank = star;
        iconFrame.Texture = texture;
        PerkExplorer.body.perkbox.combat.perks[i] = iconFrame;
        SetTemplate(PerkExplorer.body.perkbox.combat.perks[i]);
        PerkExplorer.body.perkbox.combat.perks[i]:SetAlpha(1);

        PerkExplorer.body.perkbox.combat.perks[i]:Hide();
        rowCount = rowCount + 1;
    end

    ToggleBox(true);

    PerkExplorer.body.catalogue = CreateFrame("FRAME", nil, PerkExplorer.body)
    PerkExplorer.body.catalogue:SetSize(width, height-120);
    PerkExplorer.body.catalogue:SetPoint("TOP", 0, -30)
    SetTemplate(PerkExplorer.body.catalogue);

    PerkExplorer.body.catalogue.clipframe = CreateFrame("FRAME", nil, PerkExplorer.body.catalogue)
    PerkExplorer.body.catalogue.clipframe:SetSize(width, height-160)
    PerkExplorer.body.catalogue.clipframe:SetPoint("TOP", 0, -40)

    PerkExplorer.body.catalogue.clipframe.scroll = CreateFrame("ScrollFrame", "perkScroll", PerkExplorer.body.catalogue.clipframe, "UIPanelScrollFrameTemplate")
    PerkExplorer.body.catalogue.clipframe.scroll:SetPoint("TOPLEFT", 0, 0);
    PerkExplorer.body.catalogue.clipframe.scroll:SetPoint("BOTTOMRIGHT", 0, 0);


    local scrollcat = CreateFrame("FRAME");
    scrollcat:SetSize(width, height)
    scrollcat.perks = {}
    PerkExplorer.body.catalogue.clipframe.scroll:SetScrollChild(scrollcat);

    PerkExplorer.body.catalogue:Hide();
end

function ToggleBox(visible) 
    local width = GetScreenWidth()/3;
    if (visible) then 
        PerkExplorer.body:Hide();
        PerkExplorer.header:SetSize(width/3, 30)
    else
        PerkExplorer.header:SetSize(width, 30)
        PerkExplorer.body:Show(width, 30);
    end
end

function LoadSpecPerks(spec)
    local i = 1;
    for specId, perk in ipairs(PerkExplorerInternal.PERKS_SPEC) do
        for spellId, meta in pairs(PerkExplorerInternal.PERKS_SPEC[specId]) do
            local _, _, icon = GetSpellInfo(spellId);
            local rank = meta[1].rank;
            PerkExplorer.body.perkbox.combat.perks[i].Texture:SetTexture(icon);

            local tex = assets.rankone;
            if rank == 2 then
                tex = assets.ranktwo;
            elseif rank == 3 then
                tex = assets.rankthree;
            end
            PerkExplorer.body.perkbox.combat.perks[i].Rank:SetTexture(tex);

            PerkExplorer.body.perkbox.combat.perks[i]:HookScript("OnEnter", function() 
                SetUpRankedTooltip(PerkExplorer.body.perkbox, spellId, perkTooltip1, perkTooltip2, perkTooltip3, "ANCHOR_LEFT");
            end);
            PerkExplorer.body.perkbox.combat.perks[i]:SetScript("OnLeave", function() 
                perkTooltip1:Hide();
                perkTooltip2:Hide();
                perkTooltip3:Hide();
            end);
            PerkExplorer.body.perkbox.combat.perks[i]:Show()
            i = i + 1;
        end
    end
end

function LoadAllPerks(int)
    local width = GetScreenWidth()/3;
    local height = GetScreenHeight()/2;
    local iconsPerRow = 15;
    local gap = 8;
    local i = 1;
    local rowCount = 1;
    local iconSize = ((width-10)-gap*(iconsPerRow))/iconsPerRow;
    local depth = iconSize;

    local perkFrame = PerkExplorer.body.catalogue.clipframe.scroll:GetScrollChild();
    for spellId, meta in pairs(PerkExplorerInternal.PERKS_ALL) do
        local metainfo = meta[1];
        if (i <= int) then
            local name, rank, icon, castTime, minRange, maxRange, spellID = GetSpellInfo(spellId);

            if (rowCount > iconsPerRow) then
                rowCount = 1
            end

            local num = math.fmod(i, iconsPerRow);

            if (num == 1) then
                depth = depth - (gap+iconSize)
            end

            perkFrame.perks[i] = CreateFrame("BUTTON", perkFrame.perks[i], perkFrame);
            perkFrame.perks[i]:SetHighlightTexture("Interface\\Buttons\\WHITE8x8");
            perkFrame.perks[i]:SetFrameLevel(perkFrame:GetFrameLevel());
            perkFrame.perks[i]:SetSize(iconSize, iconSize);
            perkFrame.perks[i]:SetPoint("TOPLEFT", gap*rowCount+(rowCount-1)*iconSize, depth);
            perkFrame.perks[i].Texture = perkFrame.perks[i]:CreateTexture();
            perkFrame.perks[i].Texture:SetAllPoints();
            perkFrame.perks[i].Texture:SetTexCoord(.08, .92, .08, .92);
            perkFrame.perks[i].Texture:SetPoint("CENTER", 0, 0);
            SetTemplate(perkFrame.perks[i]);
            perkFrame.perks[i]:SetAlpha(1);

            perkFrame.perks[i].Texture:SetTexture(icon);
            perkFrame.perks[i]:Show();

            local unique = metainfo.unique;
            if unique > 0 then
                perkFrame.perks[i]:HookScript("OnEnter", function()
                    SetUpSingleTooltip(PerkExplorer.body.catalogue, spellId, perkTooltip1, "ANCHOR_LEFT");
                end);
            else
                perkFrame.perks[i]:HookScript("OnEnter", function()
                    SetUpRankedTooltip(PerkExplorer.body.catalogue, spellId, perkTooltip1, perkTooltip2, perkTooltip3, "ANCHOR_LEFT");
                end);
            end
            perkFrame.perks[i]:SetScript("OnLeave", function() 
                perkTooltip1:Hide();
                perkTooltip2:Hide();
                perkTooltip3:Hide();
            end);

            rowCount = rowCount + 1;
            i = i + 1;
        end
    end
    perkFrame:SetSize(width, -1*(depth-(iconSize+gap)));
end
