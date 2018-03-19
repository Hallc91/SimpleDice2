SD2.NumberTable = {"One","Two","Three","Four","Five","Six","Seven","Eight","Nine","Ten","Eleven","Twelve","Thirteen","Fourteen","Fifteen","Sixteen","Seventeen","Eighteen","Nineteen","Twenty"}
SD2.FullSkillTable = {skillheader = {name = "Skills",type = "header",order = 0},}
SD2.FullAttributeTable = {attributeheader = {name = "Attributes",type = "header",order = 0},}

SD2.Options = {
  name = "Simple Dice 2",
  handler = SD2,
  type = 'group',
  childGroups = "tab",

  args = {

    coreconfig = {

      type        = "group",
      name        = "Core Settings",
      cmdHidden   = true,
      order       = 0,
      childGroups = "tree",
      args        = {

          diceheader = {
            name       = "Basic Dice Settings",
            type       = "header",
            order      = 0
          },

          dicelow = {

            name        = "Lower Roll Range",
            desc        = "The lower value for your dice rolls.",
            type        = "range",
            min         = 1,
            max         = 100,
            softMin     = 1,
            softMax     = 100,
            step        = 1,
            set         = function(info, val)
              if val >= SD2.db.char.roll["High"]
              then SD2.db.char.roll["Low"] = SD2.db.char.roll["High"] - 1
              else SD2.db.char.roll["Low"] = val
              end;
            end,
            get         = function(info) return SD2.db.char.roll["Low"]; end,
            cmdHidden   = true,
            order       = 1

          },

          dicehigh = {

            name        = "Upper Roll Range",
            desc        = "The upper value for your dice rolls.",
            type        = "range",
            min         = 1,
            max         = 100,
            softMin     = 1,
            softMax     = 100,
            step        = 1,
            set         = function(info, val)
              if val <= SD2.db.char.roll["Low"]
              then SD2.db.char.roll["High"] = SD2.db.char.roll["Low"] + 1
              else SD2.db.char.roll["High"] = val
              end;
            end,
            get         = function(info) return SD2.db.char.roll["High"]; end,
            cmdHidden   = true,
            order       = 2

          },

      }

    },

    attributeconfig = {

      type        = "group",
      name        = "Attribute Settings",
      cmdHidden   = true,
      order       = 1,
      childGroups = "tree",
      args        = SD2.FullAttributeTable

    },

    skillconfig = {

      type        = "group",
      name        = "Skill Settings",
      cmdHidden   = true,
      order       = 2,
      childGroups = "tree",
      args        = SD2.FullSkillTable
    },

    options = {

      type        = "group",
      name        = "Options",
      cmdHidden   = true,
      order       = 3,
      childGroups = "tree",
      args        = {

          optheader = {
            name       = "Options",
            type       = "header",
            order      = 0
          },

          dicehigh = {
             name        = "Hide Minimap Button",
             desc        = "The upper value for your dice rolls.",
             type        = "toggle",
             set         = function(info, val) SD2.db.char.minimap.hide = val; if val then SD2Icon:Hide("Simple Dice 2") else SD2Icon:Show("Simple Dice 2") end; end,
             get         = function(info) return SD2.db.char.minimap.hide; end,
             cmdHidden   = true,
             order       = 1
           },

      }

    }

  }

}

SD2.Preset = {
  char = {

    minimap = {
      hide = false,
    },

    roll = {
      ["Low"] = 1,
      ["High"] = 100,
      ["Temp"] = 0,
      ["Target"] = ""
    },

    attribute = {

      {
        ["Name"] = "None",
        ["Value"] = 0,
      }

    },

    skill = {},

  }

}
local skilltable = {["Name"] = "",["Attribute"] = 1,["Modifier"] = 0,["Damage"] = 0,}
local attributetable = {["Name"] = "",["Value"] = 0,}
for i = 1,20 do
  table.insert(SD2.Preset.char.skill,skilltable)
end
for i = 2,9 do
  table.insert(SD2.Preset.char.attribute,i,attributetable)
end



SD2.PlayerName = UnitName("Player")
SD2.TempModifier = {}
