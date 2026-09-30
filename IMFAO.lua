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
--  "'manufacturer3@name3@'",
    "'_generic@dimmer__8bit@'",
    "'_generic@nodim@'",
    "'adj@focus_flex@25_standard_rgbw'",
    "'astera_led_technology@fp1_titan_tube@rgb_rgb_16_pixel_-_strobe_off'",
    "'clay_paky@aleda_b-eye_k20@shapes'",
    "'clay_paky@sharpy_wash_330@standard_-_lamp_on'",
    "'coemar@pinlite_led@00'",
    "'dts@fos_100_power@6_channel'",
    "'elation@fuze_max_profile@extended'",
    "'etc@colorsource_par_deep_blue@direct'",
    "'fsp@track_talent_switch@'",
    "'generic@led_-_brg@8_bit'",
    "'generic@led_-_cwww@8_bit'",
    "'generic@led_-_rgb@8_bit'",
    "'icolor@icolor_cove@8_bit'",
    "'jb_lighting@sparx7@mode_2'",
    "'jb_lighting@sparx18@mode_2'",
    "'jb-lighting@varyscan_p18@mode_2'",
    "'litecraft@powerbar_x15@'",
    "'ma_lighting@stage_marker@'",
    "'opti@madmapper@'",
    "'optikalusion@optilinegen@'",
    "'optikalusion@optimetaballs@'",
    "'optikalusion@optipixellayer@'",
    "'optikalusion@optislicecolor@'",
    "'optikalusion@optividrouter@'",
    "'portman@p3@'",
    "'resolume@resolume_layer@v7_lay_opti'",
    "'resolume@resolume_master@opti'",
    "'resolume@resolume_slice@opti'",
    "'robe@robin_colourstrobe@mode_3'",
    "'robe@robin_megapointe@mode_1'",
    "'robe@robin_pointe@mode_1'",
    "'robe_lighting@robin_forte@mode_2_-_enhanced_gobo_control'",
    "'robe_lighting@robin_painte@mode_2_-_enhanced_gobo_control'",
    "'robe_lighting@robin_tetra2@mode_4-pixel_rgbw'",
    "'robe_lighting@robin_tetrax@mode_4-pixel_rgbw'",
    "'roxx@b.flex@19_channel_rgb'",
    "'showline@sl_bar_520@rgbw_16_bit_6_group'",
    "'showtec@spectral_pc_600z_ip@tr16'",
    "'showtec@sunstrip_active_l-r@10_channel'",
    "'stairville@par_36_led_par@00'",
    "'tcm@tcm_rgb@8_bit'",
    "'tcm@tcm_rgbw@8_bit'"
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