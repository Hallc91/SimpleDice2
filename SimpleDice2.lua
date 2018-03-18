function getSkillOptions()
  for i = 1,20 do
    local NumberText = SD2.NumberTable[i]
    SD2.FullSkillTable[NumberText] = {
              type        = "group",
              name        = "Skill "..NumberText,
              cmdHidden   = true,
              inline      = true,
              order       = i,
              childGroups = "tree",
              args        = {

                skillname = {
                  name        = "Skill Name",
                  desc        = "The name for your Skill.",
                  type        = "input",
                  set         = function(info, val) SD2.db.char.skill[i]["Name"] = val; end,
                  get         = function(info) return SD2.db.char.skill[i]["Name"]; end,
                  width       = "normal",
                  cmdHidden   = true,
                  order       = 0
                },

                skillmod = {
                  name        = "Skill Modifier",
                  desc        = "The modifier for your Skill.",
                  type        = "input",
                  set         = function(info, val) SD2.db.char.skill[i]["Modifier"] = tonumber(val); end,
                  get         = function(info) return tostring(SD2.db.char.skill[i]["Modifier"]); end,
                  width       = "half",
                  cmdHidden   = true,
                  order       = 1
                },

                skilldamage = {
                  name        = "Skill Damage",
                  desc        = "The damage for your Skill.",
                  type        = "input",
                  set         = function(info, val) SD2.db.char.skill[i]["Damage"] = tonumber(val); end,
                  get         = function(info) return tostring(SD2.db.char.skill[i]["Damage"]); end,
                  width       = "half",
                  cmdHidden   = true,
                  order       = 2
                },

                attributeselect = {
                  name        = "Skill Attribute",
                  desc        = "The attribute associated with this skill, set to none if your system doesn't use this.",
                  type        = "select",
                  values      = function() local AttribTable = {};
                    for i = 1,#SD2.db.char.attribute do
                      if SD2.db.char.attribute[i]["Name"] ~= ""
                      then table.insert(AttribTable,SD2.db.char.attribute[i]["Name"]) end
                    end;
                    return AttribTable;
                  end,
                  set         = function(info, val) SD2.db.char.skill[i]["Attribute"] = val; end,
                  get         = function(info) return SD2.db.char.skill[i]["Attribute"]; end,
                  width       = "0.75",
                  cmdHidden   = true,
                  order       = 3

                }

              }

            }
  end
end

function getAttributeOptions()
  for i = 2,9 do
    local NumberText = SD2.NumberTable[i-1]
    SD2.FullAttributeTable[NumberText] = {
        type        = "group",
        name        = "Attribute "..NumberText,
        cmdHidden   = true,
        inline      = true,
        order       = i,
        childGroups = "tree",
        args        = {

          attributename = {
            name        = "Attribute Name",
            desc        = "The name for your Attribute.",
            type        = "input",
            set         = function(info, val) SD2.db.char.attribute[i]["Name"] = val; end,
            get         = function(info) return SD2.db.char.attribute[i]["Name"]; end,
            width       = "normal",
            cmdHidden   = true,
            order       = 0
          },

          attributevalue = {
            name        = "Attribute Value",
            desc        = "The modifier value for your attribute.",
            type        = "input",
            set         = function(info, val) SD2.db.char.attribute[i]["Value"] = tonumber(val); end,
            get         = function(info) return tostring(SD2.db.char.attribute[i]["Value"]); end,
            width       = "half",
            cmdHidden   = true,
            order       = 1
          }

        }

      }
  end
end

local function rollCalculation(Skill)
  local Attribute = SD2.db.char.skill[Skill]["Attribute"]
  local string = string.format("Skill Name: %s. Mod: %s. Damage: %s. Attribute Name: %s. Attribute Value: %s.",SD2.db.char.skill[Skill]["Name"],SD2.db.char.skill[Skill]["Modifier"],SD2.db.char.skill[Skill]["Damage"],SD2.db.char.attribute[Attribute]["Name"],SD2.db.char.attribute[Attribute]["Value"])
  print(string)
end

local function attributeGroup(container)
  local button = SD2GUI:Create("Button")
  button:SetText("Tab 1 Button")
  button:SetWidth(150)
  container:AddChild(button)
end

local function skillGroup(container)
  -- scrollcontainer = SD2GUI:Create("SimpleGroup")
  -- scrollcontainer:SetFullWidth(true)
  -- scrollcontainer:SetFullHeight(true)
  -- scrollcontainer:SetLayout("Fill")
  -- container:AddChild(scrollcontainer)
  --

  -- local scroll = SD2GUI:Create("ScrollFrame")
  -- scroll:SetLayout("Flow")
  -- scrollcontainer:AddChild(scroll)
  local skillButton = {}
  for i = 1,20 do
    if SD2.db.char.skill[i]["Name"] ~= "" then
      skillButton[i] = SD2GUI:Create("Button")
      skillButton[i]:SetText(SD2.db.char.skill[i]["Name"])
      skillButton[i]:SetWidth(120)
      skillButton[i]:SetCallback("OnClick", function() rollCalculation(i) end)
      container:AddChild(skillButton[i])
    end
  end
end

local function SelectGroup(container, event, group)
   container:ReleaseChildren()
   if group == "attrib" then
      attributeGroup(container)
   elseif group == "skill" then
      skillGroup(container)
   end
end

local function createFrame()
  if SD2.mainWindow then
    SD2.mainWindow:Hide()
    SD2.mainWindow = nil
  else

    local mainHeight = 160
    local count = 0
    for i = 1,20 do
      if SD2.db.char.skill[i]["Name"] ~= "" then
        count = count + 1
      end
    end
    local totalCount = math.ceil(count/2)
    mainHeight = mainHeight + (totalCount * 26)

    SD2.mainWindow = SD2GUI:Create("Window")
    SD2.mainWindow:SetTitle("Roll Window")
    SD2.mainWindow:SetCallback("OnClose", function(widget) SD2GUI:Release(widget) SD2.mainWindow = nil end)
    SD2.mainWindow:SetLayout("Flow")
    SD2.mainWindow:SetWidth(290)
    SD2.mainWindow:SetHeight(mainHeight)
    SD2.mainWindow:SetAutoAdjustHeight(true)
    SD2.mainWindow:EnableResize(false)

    local targetBox = SD2GUI:Create("EditBox")
    targetBox:SetText(SD2.db.char.roll["Target"])
    targetBox:SetWidth(120)
    targetBox:SetLabel("Target:")
    targetBox:DisableButton(true)
    targetBox:SetCallback("OnTextChanged", function(info, callback, val) SD2.db.char.roll["Target"] = val end)
    SD2.mainWindow:AddChild(targetBox)

    local tempBox = SD2GUI:Create("EditBox")
    tempBox:SetText(SD2.db.char.roll["Temp"])
    tempBox:SetWidth(60)
    tempBox:SetLabel("Temp Mod:")
    tempBox:DisableButton(true)
    tempBox:SetCallback("OnTextChanged", function(info, callback, val) SD2.db.char.roll["Temp"] = tonumber(val) end)
    SD2.mainWindow:AddChild(tempBox)

    local skillWindow = SD2GUI:Create("SimpleGroup")
    skillWindow:SetLayout("Flow")
    skillWindow:SetFullWidth(true)
    skillWindow:SetFullHeight(true)
    SD2.mainWindow:AddChild(skillWindow)

    local tab = SD2GUI:Create("TabGroup")
    tab:SetLayout("Flow")
    tab:SetFullWidth(true)
    tab:SetTabs({{text="Statistics", value="stats"}, {text="Attributes", value="attrib"}, {text="Skills", value="skill"}})
    tab:SetCallback("OnGroupSelected", SelectGroup)
    tab:SelectTab("skill")
    skillWindow:AddChild(tab)

  end
end

SD2.LDBTable = {
	type = "data source",
	text = "Simple Dice 2",
	icon = "Interface\\Icons\\INV_Misc_Dice_01",
	OnClick = function() createFrame() end,
}

local SD2LDB = LibStub("LibDataBroker-1.1"):NewDataObject("Simple Dice 2", SD2.LDBTable)

function SD2:OnInitialize()
  -- Code that you want to run when the addon is first loaded goes here.
  self.db = LibStub("AceDB-3.0"):New("SD2DB", self.Preset);
  getSkillOptions() getAttributeOptions()
  self.ConfigRegistry = LibStub("AceConfig-3.0"):RegisterOptionsTable("SD2", self.Options);
  self.optionsFrame = LibStub("AceConfigDialog-3.0"):AddToBlizOptions("SD2", "Simple Dice 2.0");
  SD2Map:Register("Simple Dice 2", SD2LDB, self.db.profile.minimap)
end

function SD2:OnEnable()
    -- Called when the addon is enabled
end

function SD2:OnDisable()
    -- Called when the addon is disabled
end
