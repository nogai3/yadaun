local script_name = "{ff00fb}Yadaun "
local scriptVersion = "{ff00fb}1.1 "
local script_tag = "{ff00fb}[YADAUN.LUA]: "

require("lib.moonloader");
local imgui = require('mimgui');
local ffi = require("ffi");
local ASState = require("lib.moonloader").audiostream_state;
local encoding = require("encoding");
local dlStatus = require("moonloader").download_status;
local sampev = require("lib.samp.events");
local inicfg = require("inicfg");
encoding.default = 'CP1251';
local u8 = encoding.UTF8;

local scary_active = false;
local scary_timer = 0;

local target_call_id = nil;
local dialog_eat_processed = false;

local script_path = getWorkingDirectory() .. "\\PIZDAK\\";
if (not doesDirectoryExist(script_path)) then createDirectory(script_path) end

local config_path = script_path .. "\\CONFIG\\";
if (not doesDirectoryExist(config_path)) then createDirectory(config_path) end;

local files = {
  {
    url = "https://nogai3.github.io/LighSync/assets/yadaun/tajik_image.png",
    file_name = "tajik_image.png"
  },
  {
    url = "https://nogai3.github.io/LighSync/assets/yadaun/tajik_sound.mp3",
    file_name = "tajik_sound.mp3"
  }
}

local config_files = {
  {
    url = "https://nogai3.github.io/LighSync/assets/yadaun/config/gunsettings.ini",
    file_name = "gunsettings.ini"
  },
  {
    url = "https://nogai3.github.io/LighSync/assets/yadaun/config/servercommands.ini",
    file_name = "servercommands.ini"
  }
}

local tajik_image = renderLoadTextureFromFile(script_path .. "tajik_image.png"); assert(tajik_image, "Image not found!");
local tajik_sound = loadAudioStream(script_path .. "tajik_sound.mp3"); assert(tajik_image, "Sound not found!");

local accent_enabled = false;
local accent = "[Àøîòèêîâñêèé àêöåíò]: ";

local screen_width, screen_height = getScreenResolution();
local weapons = {
  [0] = "fist", [1] = "kastet",
  [2] = "cone", [3] = "stick",
  [4] = "knife", [5] = "bat",
  [6] = "shovel", [7] = "cue",
  [8] = "katana", [9] = "chainsaw",
  [10] = "dildo_1", [11] = "dildo_2",
  [13] = "dildo_3", [14] = "flowers",
  [15] = "cane", [16] = "grenade",
  [17] = "gas_grenade", [18] = "molotov",
  [22] = "pistol_9mm", [23] = "silenced_pistol",
  [24] = "deagle", [25] = "shotgun", 
  [26] = "sawn_off", [27] = "spas", 
  [28] = "uzi", [29] = "mp5", 
  [30] = "ak47", [31] = "m4", 
  [32] = "tec9", [33] = "cuntgun",
  [34] = "sniper_rifle", [35] = "rpg",
  [36] = "hs", [37] = "flamethrower",
  [38] = "minigun", [39] = "tnt_bag",
  [40] = "detonator", [41] = "color_balloon",
  [42] = "extinguisher", [43] = "camera",
  [44] = "night_vision", [45] = "thermal_imager",
  [46] = "parachute"
};
local rp_guns_enabled = false;
local last_weapon_id = nil;
local last_weapon_name = nil;
local gun_rp_config = {}
local rp_cooldown = 1500;

local server_commands_rp_config = {}

local nick = "Ãëåá Óñòèìåíêî"
local faction = "ÔÁĞ"
local rank = "Ìëàäøèé àãåíò"
local current_target = nil;

--[[local purple = ff00fb;
local vipadv = fd446f;
local titan = f6495ed;
local premium = f345fc; 
--]]
function main()
    while not isSampAvailable() do wait(0) end
    if (not isSampLoaded() or not isSampfuncsLoaded()) then return end
    print(script_name .. script_tag .. "ÅÁÀÒÜ ÊÀÊ ÎÍ ÊĞÓÒÎ ÇÀÃĞÓÆÅÍ!!!");
    downloadHandler("files", files);
    downloadHandler("config", config_files);
    gun_rp_config = inicfg.load(nil, config_path .. "gunsettings.ini");;
    server_commands_rp_config = inicfg.load(nil, config_path .. "servercommands.ini");
    sampRegisterChatCommand("poshelnahuy", function()
        sampAddChatMessage(script_tag .. "{ffffff}ÏÎØ¨Ë ÍÀÕÓÉ ÏÈÄÎĞÀÑ!!!", -1);
        scary_active = true;
        scary_timer = os.clock() + 4.5;
        setAudioStreamState(tajik_sound, ASState.PLAY);
    end);
    sampRegisterChatCommand("aboutyadaun", function() sampAddChatMessage(script_tag .. "{ffffff}ÑÊĞÈÏÒ ßÄÀÓÍ.ËÓÀ! ÀÂÒÎĞ: ÃËÀÊÓÑ. ÂÈĞÑÈß: " .. scriptVersion .. "{ffffff} ÑÀÌÛÉ ÀÕÓÅÍÍÛÉ ÑÊĞÈÏÒ ÍÀ ÄÈÊÎÌ ÑĞÀÌÏÅ!!!", -1); end);
    sampRegisterChatCommand("poslatnahuy", function(id) poslat_nahuy(id, "nothing") end);
    sampRegisterChatCommand("poslatnahuyvr", function(id) poslat_nahuy(id, "vr") end);
    sampRegisterChatCommand("poslatnahuyb", function(id) poslat_nahuy(id, "b") end);
    sampRegisterChatCommand("poslatnahuys", function(id) poslat_nahuy(id, "s") end);
    sampRegisterChatCommand("poslatnahuyr", function(id) poslat_nahuy(id, "r") end);
    sampRegisterChatCommand("poslatnahuyrb", function(id) poslat_nahuy(id, "rb") end);
    sampRegisterChatCommand("poslatnahuym", function(id) poslat_nahuy(id, "m") end);
    sampRegisterChatCommand("poslatnahuyg", function(id) poslat_nahuy(id, "g") end);
    sampRegisterChatCommand("poslatnahuyj", function(id) poslat_nahuy(id, "j") end);
    sampRegisterChatCommand("poslatnahuyjb", function(id) poslat_nahuy(id, "jb") end);
    sampRegisterChatCommand("poslatnahuygd", function(id) poslat_nahuy(id, "gd") end);
    sampRegisterChatCommand("poslatnahuyfam", function(id) poslat_nahuy(id, "fam") end);
    sampRegisterChatCommand("poslatnahuyal", function(id) poslat_nahuy(id, "al") end);
    sampRegisterChatCommand("chips", function() 
      dialog_eat_processed = false;
      sampSendChat("/eat");
    end);
    sampRegisterChatCommand("settarget", function(id)
      id = tonumber(id);
      if id == nil or id < 0 or id > 999 then
        sampAddChatMessage(script_tag.. "{FFFFFF}ÒÛ ×ÒÎ ÂÎÎÁÙÅ ÊÎÍ×ÅÍÍÛÉ ÀÓÒÈÑÒ???? ÀÉÄÈ ÄÎËÆÅÍ ÁÛÒÜ >= 0 È <= 999 ÀÓÒßĞÀ", -1);
      elseif not sampIsPlayerConnected(id) then
        sampAddChatMessage(script_tag .. "{FFFFFF}ÈÃĞÎÊ ÎÔÔËÀÉÍ ÍÀÕÓÉ!", -1);
      end
      current_target = id; 
      local parsed_tag = parseTags(", À ÍÈÊ Å¨: !targetrnick"); 
      sampAddChatMessage(script_tag .. "{FFFFFF}ÖÅËÜ ÓÑÏÅØÍÎ ÓÑÒÀÍÎÂËÅÍÀ!!! Å¨ ÀÉÄÈ: " .. id .. parsed_tag, -1) 
    end);
    sampRegisterChatCommand("cc", function() for i = 0, 20 do sampAddChatMessage("", -1); end end);
    sampRegisterChatCommand("test", function() sampShowDialog(1, "Âîïğîñ æèçíè è ñìåğòè!", "Ñîñàë?", "Ïîäâåğäèòü", "Âûéòè", 1); end);
    sampRegisterChatCommand("test_load", function()
      local parsed_tag = parseTags("/b Ïğèâåò, ÿ !nick, à ıòî ãîâîğèò ìîé ïàğñåğ òåãîâ! Òàêæå âîò ìîé: !rank è ôğàêöèÿ: !faction");
      sampSendChat(parsed_tag);
    end);
    sampRegisterChatCommand("testcall", function(id) call(id) end);
    sampRegisterChatCommand("cuff", function(id) current_target = id; playServerCommand(id, "cuff"); end);
    sampRegisterChatCommand("gotome", function(id) current_target = id; playServerCommand(id, "gotome") end);
    sampRegisterChatCommand("incar", function(id) current_target = id; playServerCommand(id, "incar") end);
    sampRegisterChatCommand("frisk", function(id) current_target = id; playServerCommand(id, "frisk") end);
    sampRegisterChatCommand("arrest", function(id) current_target = id; playServerCommand(id, "arrest") end);
    sampRegisterChatCommand("meg", function(id) current_target = id; playServerCommand(id, "meg") end);
    sampRegisterChatCommand("usedrugs", function(id) current_target = id; playServerCommand(id, "usedrugs") end);
    sampAddChatMessage(script_tag .. "{ffffff}ÑÊĞÈÏÒ ßÄÀÓÍ.ËÓÀ ÇÀÃĞÓÇÈÂÑß!!! ÂÈĞÑÈß: " .. scriptVersion .. "{ffffff}ÑÀÌÛÉ ÀÕÓÅÍÍÛÉ ÑÊĞÈÏÒ ÍÀ ÄÈÊÎÌ ÑĞÀÌÏÅ" , -1);
    
  while true do
        if scary_active then
            renderDrawTexture(tajik_image, 0, 0, screen_width, screen_height, 0, 0xFFffffff);
            if os.clock() > scary_timer then
                scary_active = false;
                setAudioStreamState(tajik_sound, ASState.STOP);
            end
        end
        wait(0);
        if rp_guns_enabled then
          rpgun();
        end
    end
end

function downloadHandler(type, filevar)
  if type == "config" then
    for k, v in pairs(filevar) do
      if v['file_name'] and v['url'] then
        local path = config_path .. v['file_name']
        if not doesFileExist(path) then
          sampAddChatMessage(script_tag .. "{FFFFFF}ÇÀÃĞÓÆÀŞ ÊÎÍÔÈÃ Ñ ÑÅĞÂÅĞÀ ËÈÃÕÑÓÍÊ: " .. v['file_name'], -1)
          downloadUrlToFile(v['url'], path, function(id, success, response)
            if success then
              sampAddChatMessage(script_tag .. "{FFFFFF}ÇÀÃĞÓÇÈË ÍÀÕÓÉ: " .. v['file_name'], -1)
            else
              sampAddChatMessage(script_tag .. "{FFFFFF}ÏÈÇÄÀ ËÎÏÀÒÀ ÎØÈÁÊÀ ÁËßßßßßßß: " .. v['file_name'], -1)
            end
          end)
        end
      end
    end

  elseif type == "files" then
    for k, v in ipairs(filevar) do
      if v['file_name'] and v['url'] then
        local path = script_path .. v['file_name']
        if not doesFileExist(path) then
          sampAddChatMessage(script_tag .. "{FFFFFF}ÇÀÃĞÓÆÀŞ ÔÀÉË Ñ ÑÅĞÂÅĞÀ ËÈÃÕÑÓÍÊ: " .. v['file_name'], -1)
          downloadUrlToFile(v['url'], path, function(id, success, response)
            if success then
              sampAddChatMessage(script_tag .. "{FFFFFF}ÇÀÃĞÓÇÈË ÍÀÕÓÉ: " .. v['file_name'], -1)
            else
              sampAddChatMessage(script_tag .. "{FFFFFF}ÏÈÇÄÀ ËÎÏÀÒÀ ÎØÈÁÊÀ ÁËßßßßßßß: " .. v['file_name'], -1)
            end
          end)
        end
      end
    end

  else
    sampAddChatMessage(script_tag .. "{FFFFFF}ÍÅ ÅÁÓ ×ÒÎ ÇÀ ÒÈÏ ÔÀÉËÀ ÅÁÀÒÜ!", -1)
    print(script_tag .. "{FFFFFF}ÍÅ ÅÁÓ ×ÒÎ ÇÀ ÒÈÏ ÔÀÉËÀ ÅÁÀÒÜ!!!!!!!")
  end
end

function parseTags(line)
    local rnick = nil;
    local tags = {
    ["!nick"] = nick,
    ["!faction"] = faction,
    ["!rank"] = rank,
    ["!target"] = current_target,
    ["!targetnick"] = sampGetPlayerNickname(current_target),
    ["!targetrnick"] = sampGetPlayerNickname(current_target):gsub("_", " ")
  };
  for tag, value in pairs(tags) do
    line = line:gsub(tag, value)
  end
  return line;
end

function playServerCommand(id, action_key)
  id = tonumber(id);
  if id == nil or id < 0 or id > 999 then sampAddChatMessage(script_tag .. "{FFFFFF}ÒÛ ×ÒÎ ÂÎÎÁÙÅ ÊÎÍ×ÅÍÍÛÉ ÀÓÒÈÑÒ???? ÀÉÄÈ ÄÎËÆÅÍ ÁÛÒÜ >= 0 È <= 999 ÀÓÒßĞÀ", -1);
  elseif not sampIsPlayerConnected(id) then sampAddChatMessage(script_tag .. "{FFFFFF}ÈÃĞÎÊ ÎÔÔËÀÉÍ ÍÀÕÓÉ!", -1);
  end
  local action = server_commands_rp_config.ServerCommands[action_key];
  if action and action ~= "" then
    lua_thread.create(function()
      for line in action:gsub("\\n", "\n"):gmatch("[^\n]+") do
          local parsed_tag = parseTags(line);
          sampAddChatMessage("[DEBUG]: " .. parsed_tag, -1);
          sampSendChat(parsed_tag);
          wait(rp_cooldown);
      end
    end)
  end
end

function poslat_nahuy(id, chatType)
  id = tonumber(id);
  if id == nil or id < 0 or id > 999 then sampAddChatMessage(script_tag .. "{ffffff}ÄÀËÁÀÅÁ ÈÑÏÎËÜÇÓÉ /poslatnahuy è ID ÍÀÕÓÉ", -1);
  elseif not sampIsPlayerConnected(id) then sampAddChatMessage(script_tag .. "{FFFFFF}ÒÛ ÊÎÍ×ÅÍÍÛÉ???? ÈÃĞÎÊ ÎÔÔËÀÉÍ ÍÀÕÓÉ!", -1);
  else
    local nick = sampGetPlayerNickname(id);
    nick = string.gsub(nick, "_", " ");
    local chatTypes = {
      nothing = function() sampSendChat(nick .. ", ïîø¸ë íàõóé!") end,
      vr = function() sampSendChat("/vr " .. nick .. ", ïîø¸ë íàõóé!") end,
      b = function() sampSendChat("/b " .. nick .. ", ïîø¸ë íàõóé!") end,
      s = function() sampSendChat("/s " .. nick .. ", ïîø¸ë íàõóé!") end,
      r = function() sampSendChat("/r " .. nick .. ", ïîø¸ë íàõóé!") end,
      rb = function() sampSendChat("/rb " .. nick .. ", ïîø¸ë íàõóé!") end,
      m = function() sampSendChat("/m " .. nick .. ", ïîø¸ë íàõóé!") end,
      g = function() sampSendChat("/g " .. nick .. ", ïîø¸ë íàõóé!") end,
      j = function() sampSendChat("/j " .. nick .. ", ïîø¸ë íàõóé!") end,
      jb = function() sampSendChat("/jb " .. nick .. ", ïîø¸ë íàõóé!") end,
      gd = function() sampSendChat("/gd " .. nick .. ", ïîø¸ë íàõóé!") end,
      fam = function() sampSendChat("/fam " .. nick .. ", ïîø¸ë íàõóé!") end,
      al = function() sampSendChat("/al " .. nick .. ", ïîø¸ë íàõóé!") end
    }
    if chatTypes[chatType] then
      chatTypes[chatType]()
    end
  end
end

function call(id)
  id = tonumber(id);
  if not id then
    sampAddChatMessage(script_tag .. "{FFFFFF}ID ÍÅ ÓÊÀÇÀÍ ÅÁËÀÍÈÙÅ!!!", -1);
    return
  end
  target_call_id = id;
  sampSendChat("/number " .. id);
end

function sampev.onShowDialog(dialogId, style, title, button1, button2, text)
  if title:find("Òåëåôîííàÿ êíèãà") and text:find("Íîìåğ òåëåôîíà") then
    sampSendDialogResponse(dialogId, 1, 0, "");
    return false;
  end
  if not dialog_eat_processed and title:find("Êóøàòü") and text:find("×èïñû") then
    dialog_eat_processed = true;
    sampSendDialogResponse(dialogId, 1, 0, "");
    return false;
  end
end

function sampev.onServerMessage(color, text)
  local nick, id_str, number = text:match("(%S+)%[(%d+)%]%:%s+{.-}(%d+)");
  local id = tonumber(id_str);
  number = tonumber(number);

  if nick and id and number then
    sampAddChatMessage(string.format("{FF00FF}[DEBUG]: {FFFFFF}Íèê: %s | ID: %d | Íîìåğ: %d", nick, id, number), -1)
    if target_call_id and id == target_call_id then
      sampAddChatMessage(script_tag .. "{00FF00}Çâîíş " .. nick .. " ïî íîìåğó " .. number, -1);
      sampSendChat("/call " .. number);
      target_call_id = nil;
    end
  end
end

function rpgun()
  local weaponid = getCurrentCharWeapon(playerPed);

  if weaponid ~= last_weapon_id then
    local new_weapon_name = weapons[weaponid] or "unknown";
    local old_weapon_name = weapons[last_weapon_id] or "unknown";

    if  old_weapon_name ~= "unknown" then
      local take_key = old_weapon_name .. "_take";
      local take_action = gun_rp_config.GunSettings[take_key];
      if take_action and take_action ~= "" then
        sampSendChat(take_action);
        wait(rp_cooldown);
      end
    end

    if weaponid ~= 0 and new_weapon_name ~= "unknown" then
      local get_key = new_weapon_name .. "_get";
      local get_action = gun_rp_config.GunSettings[get_key];
      if get_action and get_action ~= "" then
        sampSendChat(get_action);
        wait(rp_cooldown);
      end
    end

    last_weapon_id = weaponid;
  end
end