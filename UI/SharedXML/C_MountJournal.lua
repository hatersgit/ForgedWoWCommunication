C_MountJournal = C_MountJournal or { };

local _mountIDs = { };
local _mountIDToCompanionIndex = { };
local _filteredMountIDs = { };
local _showCollected = nil;
local _showUncollected = nil;
local _showUnusable = nil;
local _showGround = nil;
local _showFlying = nil;
local _showAquatic = nil;
local _sources = { };
local _search = nil;
local _macroBody = "/click MountJournalSummonRandomFavoriteButton";

--[[
    ezCollections.Mounts[id][2] = type (non-blizzlike):
    0x1 - Flying-only
    0x2 - Can go underwater
    0x4 - Scripted ground/flying mounts (treated as flying type in UI, allowed to be summoned in non-flyable areas, favored in flyable areas)

    ezCollections.Mounts[id][3] = flags (Mount.db2):
    0x001 - Server Only
    0x002 - Is Self Mount
    0x004 - Exclude from Journal if faction doesn't match
    0x008 - Allow mounted combat
    0x010 - Summon Random: Favor While Underwater
    0x020 - Summon Random: Favor While at Water Surface
    0x040 - Exclude from Journal if not learned
    0x080 - Summon Random: Do NOT Favor When Grounded
    0x100 - Show in Spellbook
    0x200 - Add to Action Bar on Learn
    0x400 - NOT for use as a taxi (non-standard mount anim)
]]

local function PrepareFilter()
    _showCollected = C_MountJournal.GetCollectedFilterSetting(LE_MOUNT_JOURNAL_FILTER_COLLECTED);
    _showUncollected = C_MountJournal.GetCollectedFilterSetting(LE_MOUNT_JOURNAL_FILTER_NOT_COLLECTED);
    _showUnusable = C_MountJournal.GetCollectedFilterSetting(LE_MOUNT_JOURNAL_FILTER_UNUSABLE);
    _showGround = C_MountJournal.IsTypeChecked(1);
    _showFlying = C_MountJournal.IsTypeChecked(2);
    _showAquatic = C_MountJournal.IsTypeChecked(3);
    for filterIndex = 1, C_PetJournal.GetNumPetSources() do
        _sources[filterIndex] = C_MountJournal.IsSourceChecked(filterIndex);
    end
    _search = ezCollections:PrepareSearchQuery(_search);
end

local function MatchesFilter(mountID)
    local name, spellID, icon, isActive, isUsable, sourceType, isFavorite, isFactionSpecific, faction, shouldHideOnChar, isCollected, _, usableFunc = C_MountJournal.GetMountInfoByID(mountID);

    -- Completely hide certain mounts from the list
    if shouldHideOnChar and not ezCollections.Config.Wardrobe.MountsShowHidden then
        return false;
    end

    if not (_showCollected and isCollected or _showUncollected and not isCollected) then
        return false;
    end

    if not _showUnusable then
        -- Check for usability in current terrain (non-blizzlike)
        if ezCollections.Config.Wardrobe.MountsUnusableInZone then
            -- Collected mounts have is already evaluated in isUsable
            if isCollected and not isUsable then
                return false;
            end

            -- Uncollected mounts must be evaluated manually
            if not isCollected then
                return false;
            end
        end

        -- Check faction (mounts with "Exclude from Journal if faction doesn't match" flag were already filtered out at shouldHideOnChar stage, this check is for mounts without the flag, they should be shown in the list if player opts to view unusable mounts) (currently only applied to uncollected mounts, as necessary checks are not implemented on the server)
        if isFactionSpecific and not isCollected then
            local playerFaction = UnitFactionGroup("player");
            if playerFaction == "Horde" and faction ~= 0
            or playerFaction == "Alliance" and faction ~= 1 then
                return false;
            end
        end

        -- Other checks (class, race, profession, etc) (currently only applied to uncollected mounts, as necessary checks are not implemented on the server)
        if usableFunc and not isCollected and not usableFunc() then
            return false;
        end
    end

    if not _sources[sourceType] then
        return false;
    end

    if not ezCollections:TextMatchesSearch(name, _search) then
        return false;
    end

    return true;
end


local function FindFavoriteMacro()
    LoadAddOn("Blizzard_MacroUI");
    local lowPriority;
    for i = 1, MAX_ACCOUNT_MACROS + MAX_CHARACTER_MACROS do
        local body = GetMacroBody(i);
        if body == _macroBody then
            return i;
        elseif body and body:find(_macroBody) then
            lowPriority = i;
        end
    end
    return lowPriority;
end

local function FindMacroIcon(icon)
    icon = icon:lower():gsub("/", "\\");
    for i = 1, GetNumMacroIcons() do
        if (GetMacroIconInfo(i) or ""):lower():gsub("/", "\\") == icon then
            return i;
        end
    end
end

local function CreateFavoriteMacro(perChar)
    local macro = CreateMacro(ezCollections.L["Macro.Mount"], FindMacroIcon([[Interface\Icons\Ability_Mount_RidingHorse]]) or 1, _macroBody, perChar);
    MacroFrame_Update();
    return macro;
end

local function ShowMacroPopup()
    LoadAddOn("Blizzard_MacroUI");
    StaticPopupDialogs["EZCOLLECTIONS_MOUNT_MACRO_CREATE"].OnAccept = function(self)
        C_Timer.After(0, function()
            if InCombatLockdown() then
                StaticPopup_Show("EZCOLLECTIONS_ERROR", ezCollections.L["Popup.Error.Mount.Macro.Combat"]);
                return;
            end
            local numGlobal, numChar = GetNumMacros();
            if numGlobal < MAX_ACCOUNT_MACROS then
                local macro = CreateFavoriteMacro(false);
                if macro then
                    PickupMacro(macro);
                end
            elseif numChar < MAX_CHARACTER_MACROS then
                StaticPopup_Show("EZCOLLECTIONS_MOUNT_MACRO_PERCHARACTER");
            else
                StaticPopup_Show("EZCOLLECTIONS_ERROR", ezCollections.L["Popup.Error.Mount.Macro.NoSpace"]);
            end
        end);
    end;
    StaticPopupDialogs["EZCOLLECTIONS_MOUNT_MACRO_PERCHARACTER"].OnAccept = function(self)
        C_Timer.After(0, function()
            if InCombatLockdown() then
                StaticPopup_Show("EZCOLLECTIONS_ERROR", ezCollections.L["Popup.Error.Mount.Macro.Combat"]);
                return;
            end
            local _, numChar = GetNumMacros();
            if numChar < MAX_CHARACTER_MACROS then
                local macro = CreateFavoriteMacro(true);
                if macro then
                    PickupMacro(macro);
                end
            else
                StaticPopup_Show("EZCOLLECTIONS_ERROR", ezCollections.L["Popup.Error.Mount.Macro.NoSpace"]);
            end
        end);
    end;

    StaticPopup_Show("EZCOLLECTIONS_MOUNT_MACRO_CREATE");
end

function C_MountJournal.RefreshMounts() -- Custom
    local oldMounts;
    if next(_mountIDToCompanionIndex) then
        oldMounts = CopyTable(_mountIDToCompanionIndex);
    end

    table.wipe(_mountIDs);
    table.wipe(_mountIDToCompanionIndex);
    table.wipe(_filteredMountIDs);

    PrepareFilter();

    if not ezCollections.Mounts then
        ezCollections.Mounts = { }
    end

    for mountID, info in pairs(ezCollections.Mounts) do
        local _, _, name = unpack(info);
        if name then
            table.insert(_mountIDs, mountID);
        end
    end

    for companionIndex = 1, GetNumCompanions("MOUNT") do
        local mountID = select(3, GetCompanionInfo("MOUNT", companionIndex));
        if not tContains(_mountIDs, mountID) then
            table.insert(_mountIDs, mountID);
        end
        _mountIDToCompanionIndex[mountID] = companionIndex;
        if oldMounts and not oldMounts[mountID] then
            ezCollections:GetMountNeedFanfareContainer()[mountID] = true;
        end
    end

    for _, mountID in ipairs(_mountIDs) do
        if MatchesFilter(mountID) then
            table.insert(_filteredMountIDs, mountID);
        end
    end

    table.sort(_filteredMountIDs, function(a, b)
        local nameA, _, _, _, _, _, isFavoriteA, _, _, _, isCollectedA = C_MountJournal.GetMountInfoByID(a);
        local nameB, _, _, _, _, _, isFavoriteB, _, _, _, isCollectedB = C_MountJournal.GetMountInfoByID(b);

        if isFavoriteA ~= isFavoriteB then
            return isFavoriteA;
        end

        if isCollectedA ~= isCollectedB then
            return isCollectedA;
        end

        return nameA < nameB;
    end);
end

function C_MountJournal.ClearFanfare(mountID)
    ezCollections:GetMountNeedFanfareContainer()[mountID] = nil;
end

function C_MountJournal.ClearRecentFanfares()
    table.wipe(ezCollections:GetMountNeedFanfareContainer());
end

function C_MountJournal.Dismiss()
    DismissCompanion("MOUNT");
end

function C_MountJournal.GetCollectedFilterSetting(filterIndex)
    return not ezCollections:GetCVarBitfield("mountJournalGeneralFilters", filterIndex);
end

function C_MountJournal.GetDisplayedMountInfo(displayIndex)
    local mountID = _filteredMountIDs[displayIndex];
    if mountID then
        return C_MountJournal.GetMountInfoByID(mountID);
    end
end

function C_MountJournal.GetDisplayedMountInfoExtra(mountIndex)
    local mountID = _filteredMountIDs[mountIndex];
    if mountID then
        return C_MountJournal.GetMountInfoByID(mountID);
    end
end

function C_MountJournal.GetIsFavorite(mountIndex)
    local mountID = _filteredMountIDs[mountIndex];
    local isFavorite = mountID and ezCollections:GetMountFavoritesContainer()[mountID] and true or false;
    local canSetFavorite = true;
    return isFavorite, canSetFavorite;
end

function C_MountJournal.GetMountIDs()
    return _mountIDs;
end

function C_MountJournal.GetMountInfoByID(mountID)
    local _, name, spellID, icon, isActive, isUsable, sourceType, isFavorite, isFactionSpecific, faction, shouldHideOnChar, isCollected, usableFunc;

    local flags;
    _, _, flags, name, _, sourceType, _, faction, usableFunc = ezCollections:GetMountInfo(mountID);
    isFavorite = ezCollections:GetMountFavoritesContainer()[mountID] and true or false;
    isFactionSpecific = faction ~= nil;
    shouldHideOnChar = false;

    local companionIndex = _mountIDToCompanionIndex[mountID];
    if companionIndex then
        _, name, spellID, icon, isActive = GetCompanionInfo("MOUNT", companionIndex);
        isUsable = true;
        isCollected = true;
    else
        spellID = mountID;
        _, _, icon = GetSpellInfo(spellID);
        isActive = false;
        isUsable = false;
        isCollected = false;

        -- Exclude from Journal if faction doesn't match
        if isFactionSpecific and flags and bit.band(flags, 0x4) ~= 0 then
            local playerFaction = UnitFactionGroup("player");
            if playerFaction == "Horde" and faction ~= 0
            or playerFaction == "Alliance" and faction ~= 1 then
                shouldHideOnChar = true;
            end
        end

        -- Exclude from Journal if not learned
        if flags and bit.band(flags, 0x40) ~= 0 then
            shouldHideOnChar = true;
        end
    end

    return name or "", spellID, icon, isActive, isUsable, sourceType and sourceType + 1 or 12, isFavorite, isFactionSpecific, faction, shouldHideOnChar, isCollected, mountID, usableFunc;
end

function C_MountJournal.GetMountInfoExtraByID(mountID)
    local _, creatureDisplayInfoID, description, source, isSelfMount;

    local flags;
    creatureDisplayInfoID, _, flags, _, description, _, source = ezCollections:GetMountInfo(mountID);
    isSelfMount = bit.band(flags or 0, 0x2) ~= 0;

    local companionIndex = _mountIDToCompanionIndex[mountID];
    if companionIndex then
        creatureDisplayInfoID = GetCompanionInfo("MOUNT", companionIndex);
    end
    return creatureDisplayInfoID, description or "", source or "", isSelfMount;
end

function C_MountJournal.GetNumDisplayedMounts()
    return #_filteredMountIDs;
end

function C_MountJournal.GetNumMounts()
    return #_mountIDs;
end

function C_MountJournal.IsSourceChecked(filterIndex)
    return not ezCollections:GetCVarBitfield("mountJournalSourcesFilter", filterIndex);
end

function C_MountJournal.IsTypeChecked(filterIndex)
    return not ezCollections:GetCVarBitfield("mountJournalTypeFilter", filterIndex);
end

function C_MountJournal.NeedsFanfare(mountID)
    return ezCollections:GetMountNeedFanfareContainer()[mountID];
end

function C_MountJournal.Pickup(displayIndex)
    if not next(_filteredMountIDs) or not next(_mountIDToCompanionIndex) then
        C_MountJournal.RefreshMounts();
    end

    if displayIndex == 0 then
        local macro = FindFavoriteMacro();
        if macro then
            PickupMacro(macro);
        else
            ShowMacroPopup();
        end
        return;
    end

    local mountID = _filteredMountIDs[displayIndex];
    local companionIndex = mountID and _mountIDToCompanionIndex[mountID];
    if companionIndex then
        PickupCompanion("MOUNT", companionIndex);
    end
end

local function SearchUpdated()
    ezCollections:RaiseEvent("MOUNT_JOURNAL_SEARCH_UPDATED");
    MountJournalResetFiltersButton_UpdateVisibility();
end

function C_MountJournal.SetAllSourceFilters(isChecked)
    for filterIndex = 1, C_PetJournal.GetNumPetSources() do
        ezCollections:SetCVarBitfield("mountJournalSourcesFilter", filterIndex, not isChecked);
    end
    SearchUpdated();
end

function C_MountJournal.SetAllTypeFilters(isChecked)
    for filterIndex = 1, 3 do
        ezCollections:SetCVarBitfield("mountJournalTypeFilter", filterIndex, not isChecked);
    end
    SearchUpdated();
end

function C_MountJournal.SetCollectedFilterSetting(filterIndex, isChecked)
    ezCollections:SetCVarBitfield("mountJournalGeneralFilters", filterIndex, not isChecked);
    SearchUpdated();
end

function C_MountJournal.SetIsFavorite(mountIndex, isFavorite)
    local mountID = _filteredMountIDs[mountIndex];
    if mountID then
        ezCollections:GetMountFavoritesContainer()[mountID] = isFavorite and true or nil;
    end
    SearchUpdated();
end

function C_MountJournal.SetSearch(searchValue)
    _search = searchValue;
    SearchUpdated();
end

function C_MountJournal.SetSourceFilter(filterIndex, isChecked)
    ezCollections:SetCVarBitfield("mountJournalSourcesFilter", filterIndex, not isChecked);
    SearchUpdated();
end

function C_MountJournal.SetTypeFilter(filterIndex, isChecked)
    ezCollections:SetCVarBitfield("mountJournalTypeFilter", filterIndex, not isChecked);
    SearchUpdated();
end

function C_MountJournal.SetDefaultFilters()
    ezCollections:SetCVar("mountJournalGeneralFilters", 0);
    ezCollections:SetCVar("mountJournalSourcesFilter", 0);
    ezCollections:SetCVar("mountJournalTypeFilter", 0);
    SearchUpdated();
end

function C_MountJournal.IsUsingDefaultFilters()
    return ezCollections:GetCVar("mountJournalGeneralFilters") == 0
        and ezCollections:GetCVar("mountJournalSourcesFilter") == 0
        and ezCollections:GetCVar("mountJournalTypeFilter") == 0;
end

function C_MountJournal.SummonByID(mountID)
    if UnitCastingInfo("player") or UnitChannelInfo("player") then
        return;
    end

    if not next(_mountIDToCompanionIndex) then
        C_MountJournal.RefreshMounts();
    end


    -- ezCollections:SendAddonMessage("MOUNT:SCALINGCAST:"..mountID);

    local companionIndex = _mountIDToCompanionIndex[mountID];
    if companionIndex then
        CallCompanion("MOUNT", companionIndex);
    end
end

function C_MountJournal.GetFavoriteMacro() -- Custom
    return FindFavoriteMacro();
end
