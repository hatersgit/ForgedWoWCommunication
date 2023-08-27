PATH = "Interface\\AddOns\\ForgedWoWCommunication\\UI\\"
CONSTANTS = {
    classIcon = {
        WARRIOR = "Interface\\Icons\\INV_Sword_27",
        PALADIN = "Interface\\Icons\\Ability_Paladin_HammeroftheRighteous",
        HUNTER = "Interface\\Icons\\INV_Weapon_Bow_07",
        ROGUE = "Interface\\Icons\\inv_throwingknife_04",
        PRIEST = "Interface\\Icons\\INV_Staff_30",
        ['DEATH KNIGHT'] = "Interface\\Icons\\spell_deathknight_classicon",
        SHAMAN = "Interface\\Icons\\Spell_Nature_BloodLust",
        MAGE = "Interface\\Icons\\INV_Staff_13",
        WARLOCK = "Interface\\Icons\\Spell_Nature_FaerieFire",
        DRUID = "Interface\\Icons\\INV_Misc_MonsterClaw_04"
    },
    UI = {
        SPECIALIZATION_BUTTON_BG_NORMAL = PATH .. "Buttons\\normal_button",
        SPECIALIZATION_BUTTON_BG_HOVER_OR_PUSHED = PATH .. "Buttons\\hover_button",
        -- SPECIALIZATION_BUTTON_BG_ACTIVE = PATH .. "Buttons\\active_button",
        SPECIALIZATION_BUTTON_BG_DISABLED = PATH .. "Buttons\\locked_button",
        DEFAULT_BOOK = PATH .. "tabBG\\spellbook_base",
        SPEC_RING = PATH .. "spec_ring",
        RING_POINTS = PATH .. "tab_points",
        MAIN_BG = PATH .. "background_empty",
        NORMAL_TEXTURE_BTN = PATH .. "ui-microbutton-ej-up",
        PUSHED_TEXTURE_BTN = PATH .. "ui-microbutton-ej-down",
        EMPTY_PROGRESS_BAR = PATH .. "main_bar",
        COLORED_PROGRESS_BAR = PATH .. "colored_bar",
        SHADOW_TEXTURE = PATH .. "shadow_effect",
        RANK_PLACEHOLDER = PATH .. "rank_placeholder",
        BORDER_CLOSE_BTN = PATH .. "NodeBorder\\border_close",
        CONNECTOR = PATH .. "connector",
        CONNECTOR_DISABLED = PATH .. "connector_disabled",
        BORDER_ACTIVE = PATH .. "NodeBorder\\border_active",
        BORDER_LOCKED = PATH .. "NodeBorder\\border_locked",
        BORDER_UNLOCKED = PATH .. "NodeBorder\\border_unlocked",
        BORDER_EXCLUSIVITY = PATH .. "exclusive",
        BACKGROUND_SPECS = PATH .. "tabsUI\\specsUI"
    },
    PERK = {
        star = PATH .. "Perk\\star",
        hourglass = PATH .. "Perk\\hourglass",
        highlight = PATH .. "Perk\\highlight"
    },
    CLASS = UnitClass("player")
}

settings = {
    selectionIconSize = 60,
    width = GetScreenWidth() / 5,
    height = GetScreenHeight() / 1.8,
    headerheight = (GetScreenHeight() / 1.8) / 25
}
