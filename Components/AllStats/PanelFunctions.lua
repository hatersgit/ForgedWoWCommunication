local tertiaryStatLabel = {
    [17] = "Thorns",
    [18] = "Mastery",
    [19] = "Avoidance",
    [20] = "Speed",
    [21] = "Leech"
}

local tertiaryStatDescription = {
    [17] = "Applies damage of %d to any melee attackers.",
    [18] = "Increases Mastery value by %d%%",
    [19] = "%d%% chance to reduce damage by 50%%.",
    [20] = "Increases movespeed by %d%%.",
    [21] = "Heals you for %d%% of damage dealt."
}

local curTertiaryStatValue = {
    [17] = 133,
    [18] = 223,
    [19] = 12,
    [20] = 19,
    [21] = 7
}

-- use to get stats?
-- SubscribeToForgeTopic(ForgeTopic.GET_TOOLTIPS, function(msg)
--     local tt = DeserializeMessage(DeserializerDefinitions.GET_TOOLTIPS, msg);
--     -- headers
--     -- body
-- end)

function SetTertiaryStat(statFrame, statID)
    _G[statFrame:GetName() .. "Label"]:SetText(tertiaryStatLabel[statID])
    PaperDollFormatStat(tertiaryStatLabel[statID], 0, curTertiaryStatValue[statID], 0, statFrame,
        _G[statFrame:GetName() .. "StatText"]);
    statFrame.tooltip2 = format(tertiaryStatDescription[statID], curTertiaryStatValue[statID])
end

function PrintStats()
    local statNames = { -- Base Stats
    {AllStatsFrameStat1, PaperDollFrame_SetStat, 1}, {AllStatsFrameStat2, PaperDollFrame_SetStat, 2},
    {AllStatsFrameStat3, PaperDollFrame_SetStat, 3}, {AllStatsFrameStat4, PaperDollFrame_SetStat, 4},
    {AllStatsFrameStat5, PaperDollFrame_SetStat, 5}, {AllStatsFrameStatMeleeDamage, PaperDollFrame_SetDamage},
    {AllStatsFrameStatMeleeSpeed, PaperDollFrame_SetAttackSpeed},
    {AllStatsFrameStatMeleePower, PaperDollFrame_SetAttackPower},
    {AllStatsFrameStatMeleeHit, PaperDollFrame_SetRating, CR_HIT_MELEE},
    {AllStatsFrameStatMeleeCrit, PaperDollFrame_SetMeleeCritChance},
    {AllStatsFrameStatMeleeExpert, PaperDollFrame_SetExpertise},
    {AllStatsFrameStatRangeDamage, PaperDollFrame_SetRangedDamage},
    {AllStatsFrameStatRangeSpeed, PaperDollFrame_SetRangedAttackSpeed},
    {AllStatsFrameStatRangePower, PaperDollFrame_SetRangedAttackPower},
    {AllStatsFrameStatRangeHit, PaperDollFrame_SetRating, CR_HIT_RANGED},
    {AllStatsFrameStatRangeCrit, PaperDollFrame_SetRangedCritChance},
    {AllStatsFrameStatSpellDamage, PaperDollFrame_SetSpellBonusDamage},
    {AllStatsFrameStatSpellHeal, PaperDollFrame_SetSpellBonusHealing},
    {AllStatsFrameStatSpellHit, PaperDollFrame_SetRating, CR_HIT_SPELL},
    {AllStatsFrameStatSpellCrit, PaperDollFrame_SetSpellCritChance, CR_HIT_SPELL},
    {AllStatsFrameStatSpellHaste, PaperDollFrame_SetSpellHaste},
    {AllStatsFrameStatSpellRegen, PaperDollFrame_SetManaRegen}, {AllStatsFrameStatArmor, PaperDollFrame_SetArmor},
    {AllStatsFrameStatDefense, PaperDollFrame_SetDefense}, {AllStatsFrameStatDodge, PaperDollFrame_SetDodge},
    {AllStatsFrameStatParry, PaperDollFrame_SetParry}, {AllStatsFrameStatBlock, PaperDollFrame_SetBlock},
    {AllStatsFrameStatResil, PaperDollFrame_SetResilience}, {AllStatsFrameStatThorns, SetTertiaryStat, 17},
    {AllStatsFrameStatMastery, SetTertiaryStat, 18}, {AllStatsFrameStatAvoidance, SetTertiaryStat, 19},
    {AllStatsFrameStatSpeed, SetTertiaryStat, 20}, {AllStatsFrameStatLeech, SetTertiaryStat, 21}}

    local onEnterScripts = { --
    {AllStatsFrameStatMeleeDamage, CharacterDamageFrame_OnEnter},
    {AllStatsFrameStatRangeDamage, CharacterRangedDamageFrame_OnEnter},
    {AllStatsFrameStatSpellDamage, CharacterSpellBonusDamage_OnEnter},
    {AllStatsFrameStatSpellCrit, CharacterSpellCritChance_OnEnter}}

    for _, v in ipairs(statNames) do
        v[2](v[1], v[3])
    end
    for _, v in ipairs(onEnterScripts) do
        v[1]:SetScript("OnEnter", v[2])
    end
end
