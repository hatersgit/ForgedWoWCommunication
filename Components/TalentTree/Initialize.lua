function ToggleTalentFrame(openPet)
    if openPet and HasPetUI() and PetCanBeAbandoned() then
        TalentFrame_LoadUI();
        if (PlayerTalentFrame_Toggle) then
            PlayerTalentFrame_Toggle(true, 3);
        end
    else
        ToggleMainWindow();
    end
end

function InitializeTalentTree()
    --InitializeGridForForgeSkills();
    InitializeGridForTalent();
    FirstRankToolTip = CreateFrame("GameTooltip", "firstRankToolTip", WorldFrame, "GameTooltipTemplate");
    SecondRankToolTip = CreateFrame("GameTooltip", "secondRankToolTip", WorldFrame, "GameTooltipTemplate");
    PushForgeMessage(ForgeTopic.TalentTree_LAYOUT, "-1")
    PushForgeMessage(ForgeTopic.GET_TALENTS, "-1");
    PushForgeMessage(ForgeTopic.GET_CHARACTER_SPECS, "-1")
    SubscribeToForgeTopic(ForgeTopic.TalentTree_LAYOUT, function(msg)
        GetTalentTreeLayout(msg)
    end);
    SubscribeToForgeTopic(ForgeTopic.GET_CHARACTER_SPECS, function(msg)
        GetCharacterSpecs(msg);
    end);
end

function GetTalentTreeLayout(msg)
    for i, tab in ipairs(DeserializeMessage(DeserializerDefinitions.TalentTree_LAYOUT, msg)) do
        if tab.TalentType == CharacterPointType.TALENT_SKILL_TREE or tab.TalentType == CharacterPointType.RACIAL_TREE or
            tab.TalentType == CharacterPointType.PRESTIGE_TREE or tab.TalentType == CharacterPointType.SKILL_PAGE 
            or tab.TalentType == CharacterPointType.PET_TALENT then
            print(tab.TalentType .. " " .. tab.Id)
            if not TalentTree.FORGE_TABS[tab.Id] then
                TalentTree.FORGE_TABS[tab.Id] = {};
                table.insert(TalentTree.FORGE_TABS[tab.Id], tab);
            else
                local talents = TalentTree.FORGE_TABS[tab.Id][1].Talents
                for index, talent in ipairs(tab.Talents) do
                    talents[#talents+1] = talent
                end
            end
        -- elseif tab.TalentType == CharacterPointType.FORGE_SKILL_TREE then
        --     table.insert(TalentTree.FORGE_SPELLS_PAGES, tab);
        elseif tab.TalentType == CharacterPointType.LEVEL_10_TAB then
            TalentTree.FORGE_SPECS_TAB = tab;
        end
    end
end

function GetCharacterSpecs(msg)
    for i, spec in ipairs(DeserializeMessage(DeserializerDefinitions.GET_CHARACTER_SPECS, msg)) do
        if spec.Active == "1" then
            FORGE_ACTIVE_SPEC = spec;
        else
            table.insert(TalentTree.FORGE_SPEC_SLOTS, spec)
        end
    end
    local classMask = tostring(2^(GetClassId(UnitClass("player"))-1))
    if TalentTree.INITIALIZED and TalentTree.FORGE_SELECTED_TAB then
        local strTalentType = GetStrByCharacterPointType(TalentTree.FORGE_SELECTED_TAB.TalentType);
        ShowTypeTalentPoint(TalentTree.FORGE_SELECTED_TAB.TalentType, strTalentType)
    else
        InitializeTalentLeft();
        InitializeForgePoints();
        --InitializeTabForSpellsToForge(TalentTree.FORGE_SPELLS_PAGES);
        if (TalentTree.FORGE_TABS[classMask]) then
            SelectTab(TalentTree.FORGE_TABS[classMask][1]);
        end
    end
    TalentTree.INITIALIZED = true;
end

function GetClassId (classString)
    if classString == "Warrior" then
        return 1;
    elseif classString == "Paladin" then
        return 2;
    elseif classString == "Hunter" then
        return 3;
    elseif classString == "Rogue" then
        return 4;
    elseif classString == "Priest" then
        return 5;
    elseif classString == "Death Knight" then
        return 6;
    elseif classString == "Shaman" then
        return 7;
    elseif classString == "Mage" then
        return 8;
    elseif classString == "Warlock" then
        return 9;
    else
        return 11;
    end
end

SubscribeToForgeTopic(ForgeTopic.LEARN_TALENT_ERROR, function(msg)
    print("Talent Learn Error: " .. msg);
end)

SubscribeToForgeTopic(ForgeTopic.GET_TALENTS, function(msg)
    if not TalentTree.FORGE_TALENTS then
        TalentTree.FORGE_TALENTS = {};
    end
    --print(msg)
    for i, talent in ipairs(DeserializeMessage(DeserializerDefinitions.GET_TALENTS, msg)) do
        if talent.Talents then
            for spellId, rank in pairs(talent.Talents) do
                if not TalentTree.FORGE_TALENTS[talent.TabId] then
                    TalentTree.FORGE_TALENTS[talent.TabId] = {};
                end
                TalentTree.FORGE_TALENTS[talent.TabId][spellId] = rank;
            end
            UpdateTalent(talent.TabId, talent.Talents)
        end
    end
    UpdateTalentCurrentView();
end)