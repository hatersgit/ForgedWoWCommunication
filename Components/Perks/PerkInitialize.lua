function InitializePerks(reloadUI)
    PushForgeMessage(ForgeTopic.GET_PERKS, "-1");
    InitializeSelectionWindow();
    InitializePerkExplorer();

    SubscribeToForgeTopic(ForgeTopic.GET_PERKS, function(msg)
        -- print(msg);
        if (#msg > 3) then
            PerkExplorerInternal.PERKS_SPEC = {};
            local perks = DeserializeMessage(PerkDeserializerDefinitions.PERKCHAR, msg);
            for specId, perk in ipairs(perks) do
                if PerkExplorerInternal.PERKS_SPEC[specId] == nil then
                    PerkExplorerInternal.PERKS_SPEC[specId] = {};
                end
                if perk then
                    -- print(dump(perk))
                    for id, spell in pairs(perk["Perk"]) do
                        if PerkExplorerInternal.PERKS_SPEC[specId][spell["spellId"]] == nil then
                            PerkExplorerInternal.PERKS_SPEC[specId][spell["spellId"]] = {};
                        end
                        table.insert(PerkExplorerInternal.PERKS_SPEC[specId][spell["spellId"]], spell["Meta"][1]);
                    end
                end
            end
            LoadCurrentPerks(GetSpecID());
        else
            print(msg)
        end
    end);

    SubscribeToForgeTopic(ForgeTopic.GET_PERK_CATALOGUE, function(msg)
        local it = 1;
        -- print(msg);
        PerkExplorerInternal.PERKS_ALL = {};
        local perks = DeserializeMessage(PerkDeserializerDefinitions.PERKCAT, msg);
        for i, perk in pairs(perks[1]["Perk"]) do
            if PerkExplorerInternal.PERKS_ALL[perk["spellId"]] == nil then
                PerkExplorerInternal.PERKS_ALL[perk["spellId"]] = {};
            end
            if perk then
                table.insert(PerkExplorerInternal.PERKS_ALL[perk["spellId"]], perk["Meta"][1]);
                it = it + 1;
            end
        end
        LoadAllPerksList("");
    end);

    SubscribeToForgeTopic(ForgeTopic.OFFER_SELECTION, function(msg)
        local perks = DeserializeMessage(PerkDeserializerDefinitions.PERKSEL, msg);
        PerkSelectionWindow.SelectionPool:SetSize(#perks * settings.selectionIconSize + (#perks - 1) *
                                                      settings.selectionIconSize, settings.selectionIconSize);
        for index, perk in ipairs(perks) do
            print(index .. " " .. perk.SpellId)
            AddSelectCard(perk.SpellId, index, #perks, perk.carryover);
        end
        TogglePerkSelectionFrame(false);
    end);

    SubscribeToForgeTopic(ForgeTopic.LEARN_PERK_ERROR, function(msg)
        print("Perk Learn Error: " .. msg);
    end)

    SubscribeToForgeTopic(ForgeTopic.PRESTIGE_ERROR, function(msg)
        print("Prestige halted: " .. msg);
    end)

    PushForgeMessage(ForgeTopic.OFFER_SELECTION, GetSpecID());
end
