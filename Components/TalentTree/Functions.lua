local headerheight = (GetScreenHeight() / 1.9) / 25;

function HideMainWindow()
    if TalentTreeWindow:IsShown() then
        TalentTreeWindow:Hide()
        TalentMicroButton:SetButtonState("NORMAL");
    end
end

function ToggleMainWindow()
    if TalentTreeWindow:IsShown() then
        TalentTreeWindow:Hide()
        PlaySound("TalentScreenClose");
        TalentMicroButton:SetButtonState("NORMAL");
    else
        TalentTreeWindow:Show()
        PlaySound("TalentScreenOpen");
        TalentMicroButton:SetButtonState("PUSHED", 1);
    end
    if SpellBookFrame:IsShown() then
        SpellBookFrame:Hide();
    end
    if PVPParentFrame:IsShown() then
        PVPParentFrame:Hide();
    end
    if FriendsFrame:IsShown() then
        FriendsFrame:Hide();
    end
    if GlyphFrame:IsShown() then
        GlyphFrame:Hide();
    end
end

TalentTreeWindow:HookScript("OnHide", function()
    TalentMicroButton:SetButtonState("NORMAL");
end)

-- function FindTabInForgeSpell(tabId)
--     for _, page in ipairs(TalentTree.FORGE_SPELLS_PAGES) do
--         for _, tab in pairs(page) do
--             if tonumber(tab.Id) == tonumber(tabId) then
--                 return tab;
--             end
--         end
--     end
-- end

function FindExistingTab(tabId)
    for id, tab in pairs(TalentTree.FORGE_TABS) do
        if tonumber(id) == tonumber(tabId) then
            return tab[1];
        end
    end
--    return FindTabInForgeSpell(tabId);
end

function UpdateTalentCurrentView()
    if not TalentTree.FORGE_SELECTED_TAB then
        return;
    end
    local CurrentTab = FindExistingTab(TalentTree.FORGE_SELECTED_TAB.Id);
    if CurrentTab then
        -- if CurrentTab.TalentType == CharacterPointType.FORGE_SKILL_TREE then
        --     InitializeViewFromGrid(TalentTreeWindow.body.GridForgeSkill, CurrentTab.Talents, CurrentTab.Id, 465);
        -- else
        InitializeViewFromGrid(TalentTreeWindow.body.GridTalent, CurrentTab.Talents, CurrentTab.Id);
        --end
    end
end

function FindTalent(talentId, talents)
    for _, talent in pairs(talents) do
        if talent.SpellId == talentId then
            return talent;
        end
    end
end

function UpdateTalent(tabId, talents)
    if not talents then
        return;
    end
    for spellId, rank in pairs(talents) do
        local tab = FindExistingTab(tabId)
        if tab then
            local talent = FindTalent(spellId, tab.Talents)
            local ColumnIndex = tonumber(talent.ColumnIndex);
            local RowIndex = tonumber(talent.RowIndex);
            if TalentTreeWindow.body.GridTalent.Talents[ColumnIndex] then
                if tab.TalentType == CharacterPointType.FORGE_SKILL_TREE then
                    RankUpTalent(TalentTreeWindow.body.GridForgeSkill.Talents[ColumnIndex][RowIndex], rank, talent,
                        tabId)
                else
                    RankUpTalent(TalentTreeWindow.body.GridTalent.Talents[ColumnIndex][RowIndex], rank, talent, tabId)
                end
            end
            --SetPoints(tabId);
        end
    end
end

function RankUpTalent(frame, rank, talent, tabId)
    if frame then
        frame.Ranks.RankText:SetText(CurrentRankSpell(rank) .. "/" .. talent.NumberOfRanks);
        local CurrentRank, SpellId, NextSpellId = GetSpellIdAndNextRank(tabId, talent);
        if IsUnlocked(tonumber(CurrentRank), tonumber(talent.NumberOfRanks)) then
            frame.Border:SetBackdrop({
                bgFile = CONSTANTS.UI.BORDER_UNLOCKED
            })
        else
            if CurrentRank ~= -1 then
                frame.Border:SetBackdrop({
                    bgFile = CONSTANTS.UI.BORDER_ACTIVE
                })
                if talent.ExclusiveWith[1] then
                    frame.Exclusivity:Show();
                end
            else
                if CurrentRank < 1 then
                    frame.Border:SetBackdrop({
                        bgFile = CONSTANTS.UI.BORDER_LOCKED
                    })
                else
                    frame.Border:SetBackdrop({
                        bgFile = CONSTANTS.UI.BORDER_ACTIVE
                    })
                end
                if talent.ExclusiveWith[1] then
                    frame.Exclusivity:Hide();
                end
            end
        end
        frame:HookScript("OnEnter", function()
            CreateTooltip(talent, SpellId, NextSpellId, frame, CurrentRank);
        end)
        if frame.IsTooltipActive then
            CreateTooltip(talent, SpellId, NextSpellId, frame, CurrentRank);
        end
    end
end

function UpdateOldTabTalents(newTab)
    local oldTab = FindExistingTab(newTab.Id);
    if oldTab then
        oldTab.Talents = newTab.Talents;
    end
end

function GetStrByCharacterPointType(talentType)
    if talentType == CharacterPointType.RACIAL_TREE then
        return "racial";
    end
    if talentType == CharacterPointType.PRESTIGE_TREE then
        return "prestige";
    end
    if talentType == CharacterPointType.TALENT_SKILL_TREE then
        return "talent";
    end
    if talentType == CharacterPointType.FORGE_SKILL_TREE then
        return "forge";
    end
end

function GetPositionXY(frame)
    local position = {
        x = 0,
        y = 0
    }
    local _, _, _, xOfs, yOfs = frame:GetPoint();
    position.x = xOfs;
    position.y = yOfs;
    return position;
end

function IsNodeUnlocked(talent, CurrentRank)
    return CurrentRank ~= -1 or IsUnlocked(tonumber(CurrentRank), tonumber((talent.NumberOfRanks)))
end

-- TODO FIX DRAWING
function DrawNode(startPosition, endPosition, parentFrame, parent, offSet, talent, CurrentRank, previousSpell)
    local length = math.sqrt((endPosition.x - startPosition.x) ^ 2 + (endPosition.y - startPosition.y) ^ 2)
    local iconsize = (TalentTreeWindow.body.GridTalent:GetHeight() - (11) * (headerheight / 1.5)) / 11;

    local cx = ((startPosition.x + endPosition.x) / 2 - length / 2 + iconsize / 2)
    local cy = ((startPosition.y + endPosition.y) / 2)
    local angle = math.deg(math.atan2(startPosition.y - endPosition.y, startPosition.x - endPosition.x))

    if not parentFrame.node[talent.SpellId] then
        parentFrame.node[talent.SpellId] = CreateFrame("Frame", parentFrame.node[talent.SpellId], parent);
        parentFrame.node[talent.SpellId]:SetSize(length, 10);
        parentFrame.node[talent.SpellId]:SetPoint("TOPLEFT", cx, cy);
        if IsNodeUnlocked(talent, CurrentRank) then
            parentFrame.node[talent.SpellId]:SetBackdrop({
                bgFile = CONSTANTS.UI.CONNECTOR
            })
        else
            parentFrame.node[talent.SpellId]:SetBackdrop({
                bgFile = CONSTANTS.UI.CONNECTOR_DISABLED
            })
        end
        parentFrame.node[talent.SpellId].animation = parentFrame.node[talent.SpellId]:CreateAnimationGroup()
        parentFrame.node[talent.SpellId].animation.spin = parentFrame.node[talent.SpellId].animation:CreateAnimation(
            "Rotation")
        parentFrame.node[talent.SpellId].animation.spin:SetOrder(1)
        parentFrame.node[talent.SpellId].animation.spin:SetDuration(0)
        parentFrame.node[talent.SpellId].animation.spin:SetDegrees(angle)
        parentFrame.node[talent.SpellId].animation.spin:SetEndDelay(999999)
        parentFrame.node[talent.SpellId].animation:Play()
    else
        if IsNodeUnlocked(talent, CurrentRank) then
            parentFrame.node[talent.SpellId]:SetBackdrop({
                bgFile = CONSTANTS.UI.CONNECTOR
            })
        else
            parentFrame.node[talent.SpellId]:SetBackdrop({
                bgFile = CONSTANTS.UI.CONNECTOR_DISABLED
            })
        end
        parentFrame.node[talent.SpellId].animation:Stop()
        parentFrame.node[talent.SpellId].animation:Play()
    end
end

function Tablelength(T)
    local count = 0
    for _ in pairs(T) do
        count = count + 1
    end
    return count
end

function SplitSpellsByChunk(array, nb)
    local chunks = {}
    local currentChunk = {}
    for index, value in ipairs(array) do
        table.insert(currentChunk, value)
        if #currentChunk >= nb then
            table.insert(chunks, currentChunk)
            currentChunk = {} -- Start a new chunk
        end
    end
    if #currentChunk > 0 then
        table.insert(chunks, currentChunk)
    end
    return chunks
end

function SelectTab(tab)
    if TalentTree.FORGE_SELECTED_TAB then
        if TalentTreeWindow.body.ChoiceSpecs[TalentTree.FORGE_SELECTED_TAB.Id] then
            TalentTreeWindow.body.ChoiceSpecs[TalentTree.FORGE_SELECTED_TAB.Id]:SetButtonState("NORMAL");
            TalentTreeWindow.body.ChoiceSpecs[TalentTree.FORGE_SELECTED_TAB.Id].Title:SetTextColor(188 / 255, 150 / 255,
                28 / 255, 1);
        end
    end
    TalentTree.FORGE_SELECTED_TAB = tab;
    TalentTreeWindow.body.ChoiceSpecs[TalentTree.FORGE_SELECTED_TAB.Id]:SetButtonState("PUSHED", 1);
    TalentTreeWindow.body.ChoiceSpecs[TalentTree.FORGE_SELECTED_TAB.Id].Title:SetTextColor(1, 1, 1, 1);
    -- if tab.TalentType == CharacterPointType.SKILL_PAGE then
    --     ShowTypeTalentPoint(CharacterPointType.FORGE_SKILL_TREE, "forge")
    --     TalentTreeWindow.SpellBook:Show();
    -- else
    --     TalentTreeWindow.SpellBook:Hide();
    -- end
    if tab.TalentType == CharacterPointType.RACIAL_TREE or tab.TalentType == CharacterPointType.TALENT_SKILL_TREE or
        tab.TalentType == CharacterPointType.PRESTIGE_TREE then
        InitializeGridForTalent();
        if tab.Talents then
            InitializeViewFromGrid(TalentTreeWindow.body.GridTalent, tab.Talents, tab.Id, 392);
        end
        TalentTreeWindow.body.GridTalent:Show();
    else
        TalentTreeWindow.body.GridTalent:Hide();
    end
    local strTalentType = GetStrByCharacterPointType(tab.TalentType);
    if tab.TalentType == CharacterPointType.RACIAL_TREE then
        ShowTypeTalentPoint(CharacterPointType.RACIAL_TREE, strTalentType)
    elseif tab.TalentType == CharacterPointType.PRESTIGE_TREE then
        ShowTypeTalentPoint(CharacterPointType.PRESTIGE_TREE, strTalentType)
    elseif tab.TalentType == CharacterPointType.TALENT_SKILL_TREE then
        ShowTypeTalentPoint(CharacterPointType.TALENT_SKILL_TREE, strTalentType)
    end
    --TalentTreeWindow.body.bgbox.bg.texture:SetTexture(PATH .. "tabBG\\" .. tab.Background);
end

function GetPointByCharacterPointType(type)
    for _, talent in pairs(FORGE_ACTIVE_SPEC.TalentPoints) do
        if tonumber(type) == tonumber(talent.CharacterPointType) then
            return talent;
        end
    end
end

function ShowTypeTalentPoint(CharacterPointType, str)
    local talent = GetPointByCharacterPointType(tostring(CharacterPointType));
    TalentTreeWindow.body.PointsBottom:SetText("Unspent " .. str .. " points: " .. talent.AvailablePoints);
end

function GetPointSpendByTabId(id)
    if FORGE_ACTIVE_SPEC then
        return FORGE_ACTIVE_SPEC.PointsSpent[id]
    end
end

function InitializePreviewSpecialization(tabId)
    TalentTreeWindow.SpecializationPreview = CreateFrame("Frame", TalentTreeWindow.SpecializationPreview,
        TalentTreeWindow)
    TalentTreeWindow.SpecializationPreview:SetSize(40, 40);
end

-- function SetPoints(tabId)
--     local tabButton = TalentTreeWindow.body.ChoiceSpecs[tabId]
--     if tabButton then
--         local pointsSpent = GetPointSpendByTabId(tabId) or 0
--         tabButton.Points:SetText(pointsSpent)
--     end
-- end

function InitializeTalentLeft()
    local x = 2
    local choiceSpecs = TalentTreeWindow.body.ChoiceSpecs
    local choiceSpecsWidth = choiceSpecs:GetWidth()

    for tabId, super in pairs(TalentTree.FORGE_TABS) do
        for index, tab in ipairs (super) do
            local tabButton = choiceSpecs[tabId]
            if not tabButton then
                local name = tab.Name;
                if (tab.TalentType == "0") then 
                    name = "Class" 
                end
                if (tab.TalentType == "8") then 
                    name = "Pet" 
                end
                tabButton = CreateFrame("Button", nil, choiceSpecs)
                tabButton:SetPoint("TOPLEFT", x, 0)
                tabButton:SetFrameLevel(choiceSpecs:GetFrameLevel() + 1)
                tabButton:SetSize((choiceSpecsWidth - 12) / 5, headerheight)
                SetTemplate(tabButton)
                tabButton:SetAlpha(1)
                tabButton.Title = tabButton:CreateFontString(nil, "OVERLAY")
                tabButton.Title:SetFont(PATH .. "Fonts\\Expressway.TTF", headerheight / 2)
                tabButton.Title:SetPoint("CENTER", 0, 0)
                tabButton.Title:SetText(name)
                tabButton.Title:SetTextColor(188 / 255, 150 / 255, 28 / 255, 1)
                tabButton:SetScript("OnEnter", function()
                    tabButton.Title:SetTextColor(1, 1, 1, 1)
                end)
                tabButton:SetScript("OnLeave", function()
                    if TalentTree.FORGE_SELECTED_TAB ~= tab then
                        tabButton.Title:SetTextColor(188 / 255, 150 / 255, 28 / 255, 1)
                    end
                end)
                choiceSpecs[tabId] = tabButton
                -- if tab.TalentType ~= CharacterPointType.SKILL_PAGE then
                --     tabButton.Points = tabButton:CreateFontString(nil, "OVERLAY")
                --     tabButton.Points:SetFont(PATH .. "Fonts\\Expressway.TTF", headerheight / 2)
                --     tabButton.Points:SetPoint("TOPRIGHT", -1, 0)
                --     SetPoints(tab.Id)
                -- end

                tabButton:SetScript("OnClick", function()
                    SelectTab(tab)
                end)
            end
        end
        x = x + (choiceSpecsWidth - 14) / 5 + 2
    end
end

function InitializeForgePoints()
    if TalentTreeWindow.body.PointsBottom then
        return;
    end
    TalentTreeWindow.body.PointsBottom = TalentTreeWindow.header:CreateFontString("OVERLAY")
    TalentTreeWindow.body.PointsBottom:SetFont(PATH .. "Fonts\\Expressway.TTF", 10, "OUTLINE")
    TalentTreeWindow.body.PointsBottom:SetPoint("BOTTOMRIGHT", -3, -settings.height / 1.35);
    TalentTreeWindow.body.PointsBottom:Show()
end

function InitializeGridForTalent()
    local gridtalent = TalentTreeWindow.body.GridTalent
    if gridtalent then
        gridtalent:Hide();
    end
    gridtalent = CreateFrame("Frame", gridtalent, TalentTreeWindow.body);
    gridtalent:SetPoint("TOP", 0, -headerheight);
    gridtalent:SetSize(TalentTreeWindow.body:GetWidth(), TalentTreeWindow.body:GetHeight() - 2 * headerheight);

    if not gridtalent.Talents then
        gridtalent.Talents = {};
    end

    local numIconsPerRow = 15;
    local numRows = 11
    local iconSize = (gridtalent:GetHeight() - ((numRows)*(headerheight / 1.5))) / numRows;
    local xgap = (gridtalent:GetWidth() - numIconsPerRow*iconSize)/numIconsPerRow;
    
    for i = 0, numIconsPerRow do
        if not gridtalent.Talents[i] then
            gridtalent.Talents[i] = {};
        end
        local depth = -headerheight / 1.5;
        for j = 1, numRows do
            local talent = gridtalent.Talents[i][j]
            if not talent then
                talent = CreateFrame("Button", talent, gridtalent);
                talent:SetFrameLevel(gridtalent:GetFrameLevel() + 1);
                talent:SetSize(iconSize, iconSize);
                talent:SetPoint("TOPLEFT", (i)*(xgap) + (i+1)*iconSize, depth)
                talent.TextureIcon = talent:CreateTexture();
                talent.TextureIcon:SetAllPoints()
                talent.Border = CreateFrame("Frame", talent.Border, talent)
                talent.Border:SetPoint("CENTER", 0, 0);
                talent.Border:SetSize(1.5 * iconSize, 1.5 * iconSize);
                talent.Exclusivity = CreateFrame("Frame", talent.Exclusivity, talent)
                talent.Exclusivity:SetPoint("CENTER", 0, 0);
                talent.Exclusivity:SetSize(1.5 * iconSize, 1.5 * iconSize);
                talent.Exclusivity:SetBackdrop({
                    bgFile = CONSTANTS.UI.BORDER_EXCLUSIVITY
                })
                talent.Exclusivity:Hide();
                talent.Ranks = CreateFrame("Frame", talent.Ranks, talent);
                talent.Ranks:SetFrameLevel(talent:GetFrameLevel() + 1);
                talent.Ranks:SetPoint("BOTTOM", 0, -4);
                talent.Ranks:SetSize(headerheight, headerheight * .6);
                talent.Ranks.RankText = talent.Ranks:CreateFontString("OVERLAY")
                talent.Ranks.RankText:SetFont(PATH .. "Fonts\\Expressway.TTF", (headerheight / 2.2), "OUTLINE")
                talent.Ranks.RankText:SetPoint("CENTER", 0, 0)
            end
            talent.node = {};
            talent:Hide();
            depth = depth - (headerheight / 1.5 + iconSize)
            gridtalent.Talents[i][j] = talent
        end
    end
    TalentTreeWindow.body.GridTalent = gridtalent
end

function FindPreReq(spells, spellId)
    for _, spell in ipairs(spells) do
        if spell.SpellId == spellId then
            return spell;
        end
    end
end

function InitializePreReqAndDrawNodes(spells, spellNode, children, parent, offset, CurrentRank)
    for _, pr in pairs(spellNode.Prereqs) do
        local previousSpell = FindPreReq(spells, pr.Talent);
        local startPosition = GetPositionXY(children[tonumber(previousSpell.ColumnIndex)][tonumber(
            previousSpell.RowIndex)]);
        local endPosition = GetPositionXY(children[tonumber(spellNode.ColumnIndex)][tonumber(spellNode.RowIndex)]);
        DrawNode(endPosition, startPosition,
            children[tonumber(previousSpell.ColumnIndex)][tonumber(previousSpell.RowIndex)], parent, offset, spellNode,
            CurrentRank, previousSpell);
    end
end

function LearnTalent(tabId, spell)
    PushForgeMessage(ForgeTopic.LEARN_TALENT, tabId .. ";" .. spell.SpellId)
end

function CreateTooltip(spell, SpellId, NextSpellId, parent, CurrentRank)
    if not SpellId then
        return
    end

    FirstRankToolTip:SetOwner(parent, "ANCHOR_RIGHT")
    SecondRankToolTip:SetOwner(FirstRankToolTip, "ANCHOR_BOTTOM")
    FirstRankToolTip:SetHyperlink('spell:' .. SpellId)

    local rankCost = tonumber(spell.RankCost)
    local numberOfRanks = tonumber(spell.NumberOfRanks)
    if rankCost > 0 and CurrentRank < numberOfRanks then
        FirstRankToolTip:AddLine("Rank cost: " .. rankCost, 1, 1, 1)
        FirstRankToolTip:AddLine("Required Level: " .. spell.RequiredLevel, 1, 1, 1)
    end

    if NextSpellId then
        FirstRankToolTip:AddLine("Next rank:", 1, 1, 1)
        SecondRankToolTip:SetHyperlink('spell:' .. NextSpellId)
        SecondRankToolTip:SetBackdropBorderColor(0, 0, 0, 0)
        SecondRankToolTip:SetBackdropColor(0, 0, 0, 0)
        SecondRankToolTip:AddLine(" ")
        SecondRankToolTip:SetPoint("TOP", FirstRankToolTip, "TOP", 0, -(FirstRankToolTip:GetHeight() + 25))
        FirstRankToolTip:SetSize(FirstRankToolTip:GetWidth(),
            FirstRankToolTip:GetHeight() + SecondRankToolTip:GetHeight() + 30)
    elseif rankCost > 0 and CurrentRank < numberOfRanks then
        FirstRankToolTip:SetSize(FirstRankToolTip:GetWidth(), FirstRankToolTip:GetHeight() + 28)
    end
end

function GetSpellIdAndNextRank(tabId, spell)
    local NextSpellId;
    local SpellId;
    local CurrentRank = 0;

    CurrentRank = tonumber(TalentTree.FORGE_TALENTS[tabId][tostring(spell.SpellId)]);
    if CurrentRank == -1 or CurrentRank == 0 then
        SpellId = tonumber(spell.Ranks["1"]);
    else
        SpellId = tonumber(spell.Ranks[tostring(CurrentRank)]);
        NextSpellId = tonumber(spell.Ranks[tostring(CurrentRank + 1)]);
    end
    return CurrentRank, SpellId, NextSpellId;
end

function IsUnlocked(CurrentRank, NumberOfRanks)
    if NumberOfRanks == 1 and CurrentRank == 1 then
        return CurrentRank == NumberOfRanks;
    end
    if NumberOfRanks > 1 then
        return CurrentRank == NumberOfRanks;
    end
end

function InitializeViewFromGrid(children, spells, tabId)
    local count = 0;
    for _, spell in pairs(spells) do
        count = count + 1
        local frame = children.Talents[tonumber(spell.ColumnIndex)][tonumber(spell.RowIndex)];
        if not frame then
            return;
        end
        local CurrentRank, SpellId, NextSpellId = GetSpellIdAndNextRank(tabId, spell);
        local _, _, icon = GetSpellInfo(spell.SpellId)
        if IsUnlocked(tonumber(CurrentRank), tonumber(spell.NumberOfRanks)) then
            frame.Border:SetBackdrop({
                bgFile = CONSTANTS.UI.BORDER_UNLOCKED
            })
        else
            local bg = CONSTANTS.UI.BORDER_ACTIVE
            if CurrentRank ~= -1 then
                frame.TextureIcon:SetDesaturated(nil);
                if spell.ExclusiveWith[1] then
                    frame.Exclusivity:Show();
                end
            else
                if CurrentRank < 1 then
                    frame.TextureIcon:SetDesaturated(1);
                    bg = CONSTANTS.UI.BORDER_LOCKED
                end
                if spell.ExclusiveWith[1] then
                    frame.Exclusivity:Hide();
                end
            end
            frame.Border:SetBackdrop({
                bgFile = bg
            })
        end
        if spell.Prereqs then
            InitializePreReqAndDrawNodes(spells, spell, children.Talents, children, 0, CurrentRank)
        end
        frame.Init = true;
        frame:SetScript("OnEnter", function()
            CreateTooltip(spell, SpellId, NextSpellId, frame, CurrentRank);
            frame.IsTooltipActive = true;
        end)
        frame:SetScript("OnLeave", function()
            FirstRankToolTip:SetSize(0, 0);
            SecondRankToolTip:SetSize(0, 0);
            FirstRankToolTip:Hide();
            SecondRankToolTip:Hide();
            frame.IsTooltipActive = false;
        end)
        frame.Ranks.RankText:SetText(CurrentRankSpell(CurrentRank) .. "/" .. spell.NumberOfRanks)
        frame:SetScript("OnClick", function()
            LearnTalent(spell.SpecId, spell)
        end)
        SetPortraitToTexture(frame.TextureIcon, icon)
        frame:Show();
    end
    --print(count)
end

function CurrentRankSpell(CurrentRank)
    if tonumber(CurrentRank) == -1 then
        return 0;
    end
    return CurrentRank;
end

-- function InitializeMiddleSpell()
--     if TalentTreeWindow.body.GridForgeSkill.Talents and TalentTreeWindow.body.GridForgeSkill.Talents[11][5].Ranks then
--         TalentTreeWindow.body.GridForgeSkill.Talents[11][5]:SetSize(40, 40);
--         TalentTreeWindow.body.GridForgeSkill.Talents[11][5].Ranks:Hide();
--     end
-- end

-- function InitializeGridForForgeSkills()
--     if TalentTreeWindow.body.GridForgeSkill then
--         TalentTreeWindow.body.GridForgeSkill:Hide();
--     end
--     TalentTreeWindow.body.GridForgeSkill = CreateFrame("Frame", TalentTreeWindow.body.GridForgeSkill,
--         TalentTreeWindow.body);
--     TalentTreeWindow.body.GridForgeSkill:SetPoint("LEFT", -375, 25);
--     TalentTreeWindow.body.GridForgeSkill:SetSize(946, 946);
--     TalentTreeWindow.body.GridForgeSkill.Talents = {};
--     TalentTreeWindow.body.GridForgeSkill:Hide();
--     local posX = 0;
--     for i = 1, 20 do
--         TalentTreeWindow.body.GridForgeSkill.Talents[i] = {};
--         local posY = 0;
--         for j = 1, 9 do
--             TalentTreeWindow.body.GridForgeSkill.Talents[i][j] =
--                 CreateFrame("Button", TalentTreeWindow.body.GridForgeSkill.Talents[i][j],
--                     TalentTreeWindow.body.GridForgeSkill);
--             TalentTreeWindow.body.GridForgeSkill.Talents[i][j]:SetPoint("CENTER", posX, posY)
--             TalentTreeWindow.body.GridForgeSkill.Talents[i][j]:SetFrameLevel(9);
--             TalentTreeWindow.body.GridForgeSkill.Talents[i][j]:SetSize(30, 30);
--             TalentTreeWindow.body.GridForgeSkill.Talents[i][j].TextureIcon =
--                 TalentTreeWindow.body.GridForgeSkill.Talents[i][j]:CreateTexture();
--             TalentTreeWindow.body.GridForgeSkill.Talents[i][j].TextureIcon:SetAllPoints()

--             TalentTreeWindow.body.GridForgeSkill.Talents[i][j].Border =
--                 CreateFrame("Frame", TalentTreeWindow.body.GridForgeSkill.Talents[i][j].Border,
--                     TalentTreeWindow.body.GridForgeSkill.Talents[i][j])
--             TalentTreeWindow.body.GridForgeSkill.Talents[i][j].Border:SetFrameLevel(10);
--             TalentTreeWindow.body.GridForgeSkill.Talents[i][j].Border:SetPoint("CENTER", 0, 0);
--             TalentTreeWindow.body.GridForgeSkill.Talents[i][j].Border:SetSize(48, 48);

--             TalentTreeWindow.body.GridForgeSkill.Talents[i][j].Exclusivity =
--                 CreateFrame("Frame", TalentTreeWindow.body.GridForgeSkill.Talents[i][j].Exclusivity,
--                     TalentTreeWindow.body.GridForgeSkill.Talents[i][j])
--             TalentTreeWindow.body.GridForgeSkill.Talents[i][j].Exclusivity:SetFrameLevel(12);
--             TalentTreeWindow.body.GridForgeSkill.Talents[i][j].Exclusivity:SetPoint("CENTER", 0, 0);
--             TalentTreeWindow.body.GridForgeSkill.Talents[i][j].Exclusivity:SetSize(48, 48);
--             TalentTreeWindow.body.GridForgeSkill.Talents[i][j].Exclusivity:SetBackdrop({
--                 bgFile = CONSTANTS.UI.BORDER_EXCLUSIVITY
--             })
--             TalentTreeWindow.body.GridForgeSkill.Talents[i][j].Exclusivity:Hide();

--             TalentTreeWindow.body.GridForgeSkill.Talents[i][j].Ranks =
--                 CreateFrame("Frame", TalentTreeWindow.body.GridForgeSkill.Talents[i][j].Ranks,
--                     TalentTreeWindow.body.GridForgeSkill.Talents[i][j]);

--             TalentTreeWindow.body.GridForgeSkill.Talents[i][j].Ranks:SetFrameLevel(1001);
--             TalentTreeWindow.body.GridForgeSkill.Talents[i][j].Ranks:SetPoint("BOTTOM", 0, -12);
--             TalentTreeWindow.body.GridForgeSkill.Talents[i][j].Ranks:SetSize(32, 26);
--             TalentTreeWindow.body.GridForgeSkill.Talents[i][j].Ranks:SetBackdrop({
--                 bgFile = PATH .. "rank_placeholder"
--             })
--             TalentTreeWindow.body.GridForgeSkill.Talents[i][j].RankText =
--                 TalentTreeWindow.body.GridForgeSkill.Talents[i][j].Ranks:CreateFontString()
--             TalentTreeWindow.body.GridForgeSkill.Talents[i][j].RankText:SetFont("Fonts\\FRIZQT__.TTF", 9, "OUTLINE")
--             TalentTreeWindow.body.GridForgeSkill.Talents[i][j].RankText:SetPoint("BOTTOM", 0, 8.5)
--             TalentTreeWindow.body.GridForgeSkill.Talents[i][j].node = {};
--             TalentTreeWindow.body.GridForgeSkill.Talents[i][j]:Hide()
--             posY = posY + 40
--         end
--         posX = posX + 40
--     end
-- end

-- function HideForgeSkills()
--     InitializeGridForForgeSkills();
--     TalentTreeWindow.body.GridForgeSkill:Hide();
--     TalentTreeWindow.body.CloseButtonForgeSkills:Hide();
--     TalentTreeWindow.SpellBook:Show();
--     TalentTreeWindow.TabsLeft:Show();
-- end

-- function IsForgeSkillFrameActive()
--     return TalentTreeWindow.body.GridForgeSkill:IsShown();
-- end

-- function ShowForgeSkill(tab)
--     InitializeViewFromGrid(TalentTreeWindow.body.GridForgeSkill, tab.Talents, tab.Id, 465);
--     TalentTreeWindow.body.GridForgeSkill:Show();
--     TalentTreeWindow.SpellBook:Hide();
--     TalentTreeWindow.TabsLeft:Hide();
--     TalentTreeWindow.body.CloseButtonForgeSkills:Show();
--     TalentTree.FORGE_SELECTED_TAB = tab;
-- end

-- function ShowSpellsToForge(spells)
--     local posX = 0;
--     local posY = 0;
--     for index, spell in pairs(spells) do

--         local name, rank, icon, castTime, minRange, maxRange, spellID = GetSpellInfo(spell.SpellIconId)
--         if TalentTreeWindow.SpellBook.Spells[index] then
--             TalentTreeWindow.SpellBook.Spells[index].Icon:Hide();
--             TalentTreeWindow.SpellBook.Spells[index].Icon = nil;
--             TalentTreeWindow.SpellBook.Spells[index].SpellName:Hide();
--             TalentTreeWindow.SpellBook.Spells[index].SpellName = nil;
--             TalentTreeWindow.SpellBook.Spells[index].Texture:Hide();
--             TalentTreeWindow.SpellBook.Spells[index].Texture = nil;
--         end
--         TalentTreeWindow.SpellBook.Spells[index] = {};
--         TalentTreeWindow.SpellBook.Spells[index].Icon = CreateFrame("Button",
--             TalentTreeWindow.SpellBook.Spells[index].Icon, TalentTreeWindow.SpellBook);
--         TalentTreeWindow.SpellBook.Spells[index].Icon:SetPoint("LEFT", posX, posY)
--         TalentTreeWindow.SpellBook.Spells[index].Icon:SetFrameLevel(12);
--         TalentTreeWindow.SpellBook.Spells[index].Icon:SetSize(36, 36);
--         TalentTreeWindow.SpellBook.Spells[index].Icon:SetBackdrop({
--             bgFile = icon
--         });

--         TalentTreeWindow.SpellBook.Spells[index].Points = CreateFrame("Button",
--             TalentTreeWindow.SpellBook.Spells[index].Points, TalentTreeWindow.SpellBook.Spells[index].Icon);
--         TalentTreeWindow.SpellBook.Spells[index].Points:SetPoint("BOTTOMRIGHT", 5, -5)
--         TalentTreeWindow.SpellBook.Spells[index].Points:SetFrameLevel(2000);
--         TalentTreeWindow.SpellBook.Spells[index].Points:SetSize(18, 18);
--         TalentTreeWindow.SpellBook.Spells[index].Points:SetBackdrop({
--             bgFile = CONSTANTS.UI.RING_POINTS
--         });
--         TalentTreeWindow.SpellBook.Spells[index].Points.Text =
--             TalentTreeWindow.SpellBook.Spells[index].Points:CreateFontString();
--         TalentTreeWindow.SpellBook.Spells[index].Points.Text:SetFont("Fonts\\FRIZQT__.TTF", 9, "OUTLINE")
--         TalentTreeWindow.SpellBook.Spells[index].Points.Text:SetPoint("CENTER", 0, 0)
--         TalentTreeWindow.SpellBook.Spells[index].Points.Text:SetText("0");
--         local pointsSpent = GetPointSpendByTabId(spell.Id);
--         if pointsSpent then
--             TalentTreeWindow.SpellBook.Spells[index].Points.Text:SetText(pointsSpent);
--         end
--         TalentTreeWindow.SpellBook.Spells[index].SpellName =
--             TalentTreeWindow.SpellBook.Spells[index].Icon:CreateFontString()
--         TalentTreeWindow.SpellBook.Spells[index].SpellName:SetFont("Fonts\\FRIZQT__.TTF", 10)
--         TalentTreeWindow.SpellBook.Spells[index].SpellName:SetSize(82, 200);
--         TalentTreeWindow.SpellBook.Spells[index].SpellName:SetPoint("RIGHT", 90, 0);
--         TalentTreeWindow.SpellBook.Spells[index].SpellName:SetShadowOffset(1, -1)
--         TalentTreeWindow.SpellBook.Spells[index].SpellName:SetJustifyH("LEFT");
--         TalentTreeWindow.SpellBook.Spells[index].SpellName:SetText(spell.Name)
--         TalentTreeWindow.SpellBook.Spells[index].Texture = CreateFrame("Frame",
--             TalentTreeWindow.SpellBook.Spells[index].Texture, TalentTreeWindow.SpellBook);
--         TalentTreeWindow.SpellBook.Spells[index].Texture:SetPoint("LEFT", posX - 42, posY)
--         TalentTreeWindow.SpellBook.Spells[index].Texture:SetFrameLevel(11);
--         TalentTreeWindow.SpellBook.Spells[index].Texture:SetSize(265, 265);
--         TalentTreeWindow.SpellBook.Spells[index].Texture:SetBackdrop({
--             bgFile = CONSTANTS.UI.SHADOW_TEXTURE
--         });

--         TalentTreeWindow.SpellBook.Spells[index].Spell = CreateFrame("Button",
--             TalentTreeWindow.SpellBook.Spells[index].Spell, TalentTreeWindow.SpellBook);
--         TalentTreeWindow.SpellBook.Spells[index].Spell:SetPoint("LEFT", posX - 6, posY)
--         TalentTreeWindow.SpellBook.Spells[index].Spell:SetFrameLevel(2000);
--         TalentTreeWindow.SpellBook.Spells[index].Spell:SetSize(200, 48);

--         TalentTreeWindow.SpellBook.Spells[index].Hover = CreateFrame("Frame",
--             TalentTreeWindow.SpellBook.Spells[index].Hover, TalentTreeWindow.SpellBook);
--         TalentTreeWindow.SpellBook.Spells[index].Hover:SetPoint("LEFT", posX - 6, posY)
--         TalentTreeWindow.SpellBook.Spells[index].Hover:SetFrameLevel(3000);
--         TalentTreeWindow.SpellBook.Spells[index].Hover:SetSize(48, 50);
--         TalentTreeWindow.SpellBook.Spells[index].Hover:SetBackdrop({
--             bgFile = PATH .. "over-btn-forge"
--         });
--         TalentTreeWindow.SpellBook.Spells[index].Hover:Hide();
--         TalentTreeWindow.SpellBook.Spells[index].Spell:SetScript("OnClick", function()
--             ShowForgeSkill(spell);
--         end)

--         TalentTreeWindow.SpellBook.Spells[index].Spell:SetScript("OnEnter", function()
--             TalentTreeWindow.SpellBook.Spells[index].Hover:Show()
--         end)

--         TalentTreeWindow.SpellBook.Spells[index].Spell:SetScript("OnLeave", function()
--             TalentTreeWindow.SpellBook.Spells[index].Hover:Hide()
--         end)
--         posY = posY - 50
--         if index % 7 == 0 then
--             posY = 0;
--         end
--         if index == 7 then
--             posX = posX + 180
--         end

--         if index == 14 then
--             posX = posX + 220
--         end

--         if index == 21 then
--             posX = posX + 180
--         end
--     end
-- end

function switchPage(nextPage)
    if nextPage then
        if TalentTree.FORGE_CURRENT_PAGE + 1 <= TalentTree.FORGE_MAX_PAGE then
            TalentTree.FORGE_CURRENT_PAGE = TalentTree.FORGE_CURRENT_PAGE + 1
        end
    else
        if TalentTree.FORGE_CURRENT_PAGE - 1 >= 1 then
            TalentTree.FORGE_CURRENT_PAGE = TalentTree.FORGE_CURRENT_PAGE - 1
        end
    end
    local page = TalentTree.FORGE_SPELLS_PAGES[TalentTree.FORGE_CURRENT_PAGE]
    if not page then
        return
    end
    TalentTreeWindow.SpellBook.PreviousArrow:SetEnabled(TalentTree.FORGE_CURRENT_PAGE > 1)
    TalentTreeWindow.SpellBook.NextArrow:SetEnabled(TalentTree.FORGE_CURRENT_PAGE < TalentTree.FORGE_MAX_PAGE)
    ShowSpellsToForge(page)
end

-- function InitializeTabForSpellsToForge(SkillToForges)
--     TalentTreeWindow.SpellBook = CreateFrame("Frame", TalentTreeWindow.SpellBook, TalentTreeWindow);
--     TalentTreeWindow.SpellBook:SetPoint("CENTER", 120, 330);
--     TalentTreeWindow.SpellBook:SetSize(800, 600);
--     TalentTreeWindow.SpellBook.Spells = {};
--     TalentTreeWindow.SpellBook:Hide();
--     TalentTreeWindow.SpellBook.NextArrow = CreateFrame("Button", TalentTreeWindow.SpellBook.NextArrow,
--         TalentTreeWindow.SpellBook);
--     TalentTreeWindow.SpellBook.NextArrow:SetNormalTexture("Interface\\Buttons\\UI-SpellbookIcon-NextPage-Up")
--     TalentTreeWindow.SpellBook.NextArrow:SetPushedTexture("Interface\\Buttons\\UI-SpellbookIcon-NextPage-Down")
--     TalentTreeWindow.SpellBook.NextArrow:SetDisabledTexture("Interface\\Buttons\\UI-SpellbookIcon-NextPage-Disabled")
--     TalentTreeWindow.SpellBook.NextArrow:SetPoint("BOTTOMRIGHT", -100, -40);
--     TalentTreeWindow.SpellBook.NextArrow:SetFrameLevel(1000);
--     TalentTreeWindow.SpellBook.NextArrow:SetSize(32, 32);
--     TalentTreeWindow.SpellBook.NextArrow:SetText("Next page")
--     TalentTreeWindow.SpellBook.NextArrow:SetScript("OnClick", function()
--         switchPage(true);
--     end)
--     TalentTreeWindow.SpellBook.PreviousArrow = CreateFrame("Button", TalentTreeWindow.SpellBook.NextArrow,
--         TalentTreeWindow.SpellBook);

--     TalentTreeWindow.SpellBook.PreviousArrow:SetNormalTexture("Interface\\Buttons\\UI-SpellbookIcon-PrevPage-Up")
--     TalentTreeWindow.SpellBook.PreviousArrow:SetPushedTexture("Interface\\Buttons\\UI-SpellbookIcon-PrevPage-Down")
--     TalentTreeWindow.SpellBook.PreviousArrow:SetDisabledTexture("Interface\\Buttons\\UI-SpellbookIcon-PrevPage-Disabled")
--     TalentTreeWindow.SpellBook.PreviousArrow:SetPoint("BOTTOMLEFT", 15, -40);
--     TalentTreeWindow.SpellBook.PreviousArrow:SetFrameLevel(1000);
--     TalentTreeWindow.SpellBook.PreviousArrow:SetSize(32, 32);
--     TalentTreeWindow.SpellBook.PreviousArrow:SetText("Previous page")
--     TalentTreeWindow.SpellBook.PreviousArrow:SetScript("OnClick", function()
--         switchPage(false);
--     end)
--     TalentTree.FORGE_SPELLS_PAGES = SplitSpellsByChunk(SkillToForges, 27);
--     TalentTree.FORGE_MAX_PAGE = Tablelength(TalentTree.FORGE_SPELLS_PAGES);
--     switchPage(true);
-- end

function UnlearnTalents()
    ConfirmTalentWipe()
end
