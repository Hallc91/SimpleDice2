local rollFrame = CreateFrame("Frame")
rollFrame:SetScript("OnEvent",function(self,event,...)
	local arg1 = select(1,...)
	if arg1 then
		local name,roll,minRoll,maxRoll = arg1:match("^(.+) "..SD2.LocaleTable[SD2.Locale]["Rolls"].." (%d+) %((%d+)%-(%d+)%)$")
    minRoll = tonumber(minRoll)
    maxRoll = tonumber(maxRoll)
    if maxRoll == SD2.db.char.roll["High"] and minRoll == SD2.db.char.roll["Low"] and name == SD2.PlayerName then SD2.Roll = tonumber(roll) end
	end
end)
rollFrame:RegisterEvent("CHAT_MSG_SYSTEM")

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

local function getTargetString()
	if SD2.db.char.roll["Target"] == "" then return "" end
	return " on "..SD2.db.char.roll["Target"]
end

local function formatModifier(modifier)
  if modifier == 0 then return "" end;
  if modifier < 0 then return modifier end;
  return string.format("+%i", modifier);
end

local function formatAttribute(attribute)
  if attribute == "None" then return "" end
  return "("..attribute..")"
end

local function formatRollOutput(roll, totalRoll, Skill, Attribute, Temp)
	if roll == totalRoll then return roll end
	return string.format("%s%s%s%s=%s",roll,Skill,Attribute,Temp,totalRoll)
end

local function formatOutputMessage(reCalc, skillName, abType, target, dcCheck, output, damage)
	return string.format("%sRolling %s%s%s. %s(%s)%s",reCalc,skillName,abType,target,dcCheck,output,damage)
end

local function getPassFail(Total)
  local Outcome = ""
  if SD2.db.char.roll["DC"] == 0 then return Outcome end
  if Total >= SD2.db.char.roll["DC"] then Outcome = "Pass" end
  if Total < SD2.db.char.roll["DC"] then Outcome = "Fail" end
  return string.format("[%s on DC:%s] ",Outcome,SD2.db.char.roll["DC"]), Outcome
end

local function getDamage(Damage,Target,PF)
  if PF == "Fail" or Damage == 0 or Target == "" then return "" end
  return string.format("(%d damage%s)",Damage,Target)
end

local function SendOutputMessage(Message)
	if IsInRaid() then
		SendChatMessage(Message, "RAID");
		return;
	end;
	if IsInGroup(LE_PARTY_CATEGORY_HOME) then
		SendChatMessage(Message, "PARTY");
		return;
	end;
	SELECTED_CHAT_FRAME:AddMessage(Message);
end

local function roll()
  if IsModifierKeyDown() then
    SD2.Recalc = "[ReCalc]"
    SD2.Roll = SD2.Roll
  else
    SD2.Recalc = ""
    RandomRoll(SD2.db.char.roll["Low"], SD2.db.char.roll["High"])
  end
end

local function attributeCalculation(Attribute)
  local AttribName, AttribValue, Temp = SD2.db.char.attribute[Attribute]["Name"], SD2.db.char.attribute[Attribute]["Value"], SD2.db.char.roll["Temp"]
  local Target = getTargetString()
  local TotalRoll = SD2.Roll + AttribValue + Temp
  local Outcome = getPassFail(TotalRoll)
  local TempText = formatModifier(Temp)
  local AttribText = formatModifier(AttribValue)
  local AttribType = formatAttribute(AttribName)
  local OutputRoll = formatRollOutput(SD2.Roll, TotalRoll, "", AttribText, TempText)
  local OutputMessage = formatOutputMessage(SD2.Recalc,AttribName,"",Target,Outcome,OutputRoll,"")
  SendOutputMessage(OutputMessage)
end

local function skillCalculation(Skill)
  local AttribName, AttribValue = SD2.db.char.attribute[SD2.db.char.skill[Skill]["Attribute"]]["Name"],SD2.db.char.attribute[SD2.db.char.skill[Skill]["Attribute"]]["Value"]
  local Name, Modifier, Damage, Temp = SD2.db.char.skill[Skill]["Name"], SD2.db.char.skill[Skill]["Modifier"], SD2.db.char.skill[Skill]["Damage"], SD2.db.char.roll["Temp"]
  local Target = getTargetString()
  local TotalRoll = SD2.Roll + Modifier + AttribValue + Temp
  local Outcome, PF = getPassFail(TotalRoll)
  local DamageText = getDamage(Damage,Target,PF)
  local ModifierText = formatModifier(Modifier)
  local TempText = formatModifier(Temp)
  local AttribText = formatModifier(AttribValue)
  local AttribType = formatAttribute(AttribName)
  local OutputRoll = formatRollOutput(SD2.Roll, TotalRoll, ModifierText, AttribText, TempText)
  local OutputMessage = formatOutputMessage(SD2.Recalc,Name,AttribType,Target,Outcome,OutputRoll,DamageText)
  SendOutputMessage(OutputMessage)
end

local function rollClick(Type,Number)
  roll()
  C_Timer.After(1.5, function()
    if Type == "Skill" then skillCalculation(Number) end
    if Type == "Attribute" then attributeCalculation(Number) end
  end)
end

local statGroup = {}
local function statisticsButtons(container, stat)
  statGroup[stat] = {}
  local maxstat = "Max"..stat

  statGroup[stat]["group"] = SD2GUI:Create("SimpleGroup")
  statGroup[stat]["group"]:SetLayout("Flow")
  statGroup[stat]["group"]:SetFullWidth(true)

  statGroup[stat]["label"] = SD2GUI:Create("Label")
  statGroup[stat]["label"]:SetText("  "..stat..": "..SD2.db.char.statistics[stat])
  statGroup[stat]["label"]:SetWidth(65)

  statGroup[stat]["sub"] = SD2GUI:Create("Button")
  statGroup[stat]["sub"]:SetText("-")
  statGroup[stat]["sub"]:SetWidth(40)
  statGroup[stat]["sub"]:SetCallback("OnClick", function()
    if IsShiftKeyDown() then
      SD2.db.char.statistics[stat] = SD2.db.char.statistics[stat] - 5
    elseif IsControlKeyDown() then
      SD2.db.char.statistics[stat] = SD2.db.char.statistics[stat] - 10
    else
      SD2.db.char.statistics[stat] = SD2.db.char.statistics[stat] - 1
    end
    if SD2.db.char.statistics[stat] < 0 then SD2.db.char.statistics[stat] = 0 end
    statGroup[stat]["label"]:SetText("  "..stat..": "..SD2.db.char.statistics[stat])
  end)

  statGroup[stat]["add"] = SD2GUI:Create("Button")
  statGroup[stat]["add"]:SetText("+")
  statGroup[stat]["add"]:SetWidth(40)
  statGroup[stat]["add"]:SetCallback("OnClick", function()
    if IsShiftKeyDown() then
      SD2.db.char.statistics[stat] = SD2.db.char.statistics[stat] + 5
    elseif IsControlKeyDown() then
      SD2.db.char.statistics[stat] = SD2.db.char.statistics[stat] + 10
    else
      SD2.db.char.statistics[stat] = SD2.db.char.statistics[stat] + 1
    end
    if SD2.db.char.statistics[stat] > SD2.db.char.statistics[maxstat] then SD2.db.char.statistics[stat] = SD2.db.char.statistics[maxstat] end
    statGroup[stat]["label"]:SetText("  "..stat..": "..SD2.db.char.statistics[stat])
  end)

  container:AddChild(statGroup[stat]["group"])
  statGroup[stat]["group"]:AddChild(statGroup[stat]["sub"])
  statGroup[stat]["group"]:AddChild(statGroup[stat]["label"])
  statGroup[stat]["group"]:AddChild(statGroup[stat]["add"])
end

local function statisticsGroup(container)
  if SD2.db.char.statistics["MaxHP"] > 0 then statisticsButtons(container,"HP") end
  if SD2.db.char.statistics["MaxMP"] > 0 then statisticsButtons(container,"MP") end
  if SD2.db.char.statistics["MaxEnergy"] > 0 then statisticsButtons(container,"Energy") end
end

local function attributeGroup(container)
  local attributeButton = {}
  for i = 2,9 do
    if SD2.db.char.attribute[i]["Name"] ~= "" then
      attributeButton[i] = SD2GUI:Create("Button")
      attributeButton[i]:SetText(SD2.db.char.attribute[i]["Name"])
      attributeButton[i]:SetWidth(120)
      attributeButton[i]:SetCallback("OnClick", function() rollClick("Attribute",i) end)
      container:AddChild(attributeButton[i])
    end
  end
end

local function skillGroup(container)
  local skillButton = {}
  for i = 1,20 do
    if SD2.db.char.skill[i]["Name"] ~= "" then
      skillButton[i] = SD2GUI:Create("Button")
      skillButton[i]:SetText(SD2.db.char.skill[i]["Name"])
      skillButton[i]:SetWidth(120)
      skillButton[i]:SetCallback("OnClick", function() rollClick("Skill",i) end)
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
  elseif group == "stats" then
    statisticsGroup(container)
  end
end

local function rollPanel()
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

    SD2.escapeFrame = CreateFrame("Frame")
    SD2.escapeFrame:EnableKeyboard(true)
    SD2.escapeFrame:SetFrameStrata("DIALOG")
    SD2.escapeFrame:SetPropagateKeyboardInput(true)
    SD2.escapeFrame:SetScript("OnKeyDown", function(self, key) if key == "ESCAPE" and SD2.mainWindow then SD2.mainWindow:Hide() SD2.mainWindow = nil end end)

    local targetBox = SD2GUI:Create("EditBox")
    targetBox:SetText(SD2.db.char.roll["Target"])
    targetBox:SetWidth(140)
    targetBox:SetLabel("Target:")
    targetBox:DisableButton(true)
    targetBox:SetCallback("OnTextChanged", function(info, callback, val) SD2.db.char.roll["Target"] = val end)
    SD2.mainWindow:AddChild(targetBox)

    local dcBox = SD2GUI:Create("EditBox")
    dcBox:SetText(SD2.db.char.roll["DC"])
    dcBox:SetWidth(40)
    dcBox:SetLabel("DC:")
    dcBox:DisableButton(true)
    dcBox:SetCallback("OnTextChanged", function(info, callback, val) if val == "" then val = 0 end; SD2.db.char.roll["DC"] = tonumber(val); end)
    SD2.mainWindow:AddChild(dcBox)

    local tempBox = SD2GUI:Create("EditBox")
    tempBox:SetText(SD2.db.char.roll["Temp"])
    tempBox:SetWidth(55)
    tempBox:SetLabel("Temp Mod:")
    tempBox:DisableButton(true)
    tempBox:SetCallback("OnTextChanged", function(info, callback, val) if val == "" then val = 0 end; SD2.db.char.roll["Temp"] = tonumber(val) end)
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
	OnClick = function(self, button)
    if button == "RightButton" then
      InterfaceOptionsFrame_OpenToCategory("Simple Dice 2.0")
    else
      rollPanel()
    end
  end,
}

local SD2LDB = LibStub("LibDataBroker-1.1"):NewDataObject("Simple Dice 2", SD2.LDBTable)

function SD2:OnInitialize()
  -- Code that you want to run when the addon is first loaded goes here.
  self.db = LibStub("AceDB-3.0"):New("SD2DB", self.Preset);
  getSkillOptions() getAttributeOptions()
  self.ConfigRegistry = LibStub("AceConfig-3.0"):RegisterOptionsTable("SD2", self.Options);
  self.optionsFrame = LibStub("AceConfigDialog-3.0"):AddToBlizOptions("SD2", "Simple Dice 2.0");
  SD2Icon:Register("Simple Dice 2", SD2LDB, self.db.char.minimap);
end

function SD2:OnEnable()
    -- Called when the addon is enabled
end

function SD2:OnDisable()
    -- Called when the addon is disabled
end

SD2:RegisterChatCommand("SimpleDice",rollPanel)
