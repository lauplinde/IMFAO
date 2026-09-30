---------------------------------------
---------------------------------------
-- Import Multiple Fixtures At Once  --
-- "IMFAO"                           --
-- By Paul Lindner                   --
-- Tested on grandMA2 onPC 3.9.61.5  --
-- Version: 1.1                      --
---------------------------------------
---------------------------------------

-- Change the destination path to the folder containing your fixtures and insert the file names into the list.
-- To execute this script, use the command [LUA "IMFAO_import_fixtures()"] or call the plugin.

-- For testing:
-- If you want to delete the imported fixtures you can enter [LUA "IMFAO_delete()"]
-- To list all fixturetypes, enter [LUA "IMFAO_list()"]


-- destination path of the fixtures
local path = "'D:/gma2/library'"
  
-- file names of the .xml fixture files ["'filename'"]
-- you can let an AI generate the list from a screenshot of your folder
local fixture = {
-- example:
--  "'manufacturer1@name1@'",
--  "'manufacturer2@name2@'",
--  "'manufacturer3@name3@'"
  }


-- functions for writing the macros

local function write_import_macro(macroID)
  local macroID = tostring(macroID)
  local macrolines = {
    "Store Macro 1."..macroID,
    "Store Macro 1."..macroID..".1",
    "Assign Macro 1."..macroID..".1 /cmd=\"LUA 'IMFAO_import_fixtures()'\"",
    "Label Macro 1."..macroID.." \"Import Fixtures\""
  }
  
  for i=1, #macrolines do
    gma.cmd(macrolines[i])
  end
end



local function write_list_macro(macroID)
  local macroID = macroID + 1
  local macroID = tostring(macroID)
  
  local macrolines = {
    "Store Macro 1."..macroID,
    "Store Macro 1."..macroID..".1",
    "Assign Macro 1."..macroID..".1 /cmd=\"LUA 'IMFAO_list()'\"",
    "Label Macro 1."..macroID.." \"List\""
  }
  
  for i=1, #macrolines do
    gma.cmd(macrolines[i])
  end
end



local function write_delete_macro(macroID)
  local macroID = macroID + 2
  local macroID = tostring(macroID)
  
  local macrolines = {
    "Store Macro 1."..macroID,
    "Store Macro 1."..macroID..".1",
    "Assign Macro 1."..macroID..".1 /cmd=\"LUA 'IMFAO_delete()'\"",
    "Label Macro 1."..macroID.." \"Delete\""
  }
  
  for i=1, #macrolines do
    gma.cmd(macrolines[i])
  end
end



function IMFAO_import_fixtures()
  -- change directory to the fixture settings
  gma.cmd("CD 11")
  gma.cmd("CD 3")
  
  -- import fixtures
  for i=1, #fixture do
    gma.feedback("-- import ".. fixture[i].." --")
    
    gma.cmd("Import ".. fixture[i].. " /p = ".. path)
    
    gma.feedback("-- end --")
  end
  
  gma.cmd("CD /")
end



function IMFAO_list()
  gma.cmd("cd 11")
  gma.cmd("cd 3")
  gma.cmd("list")
  gma.cmd("cd /")
end



function IMFAO_delete()
  gma.feedback("-- start deleting ".. #fixture .. " fixtures --")
  
  gma.cmd("CD 11")
  gma.cmd("CD 3")
  
  for i=1, #fixture do
    gma.feedback("-- delete "..fixture[i].." --")
    gma.cmd("delete 3")
    
  end
  
  gma.cmd("CD /")
  
  gma.feedback("-- finished deleting --")
end



function main()
  local confirmtext = [[
    "Import Multiple Fixtures At Once"
    Please follow the instructions in the code.
    The next step will write three macros. Please keep in mind that the plugin may overwrite existing macros.
    Please back up the showfile before continuing.
  ]]
  local confirm = gma.gui.confirm("IMFAO", confirmtext)
  if confirm ~= true then
    gma.feedback("cancel")
    return
  end
  
  local macroID = gma.textinput("Macro Pool ID Start", "!!Existing macros will be overwritten!!")
  local macroID = tonumber(macroID)
  if macroID == nil then
    gma.feedback("Invalid input")
    return
  end
  
  write_import_macro(macroID)
  write_delete_macro(macroID)
  write_list_macro(macroID)
  
end



return main
