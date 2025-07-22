local script_name = "{ff00fb}Yadaun "
local scriptVersion = "{ff00fb}1.0 "
local script_tag = "{ff00fb}[YADAUN.LUA]: "

require("lib.moonloader");
local imgui = require('mimgui');
local ffi = require("ffi");
local ASState = require("lib.moonloader").audiostream_state;
local encoding = require("encoding");
local dlStatus = require("moonloader").download_status;
local sampev = require("lib.samp.events");
encoding.default = 'CP1251';
local u8 = encoding.UTF8;

local scary_active = false;
local scary_timer = 0;

local target_call_id = nil;

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

for k, v in ipairs(files) do
  if not doesFileExist(script_path .. v['file_name']) then
    sampAddChatMessage(script_tag .. "{FFFFFF}ÇÀÃĞÓÆÀŞ ÔÀÉËÈ Ñ ÑÈÑĞÂÈĞÀ ËÈÃÕÑÓÍÊ!!! ÔÀÉË: " .. v['file_name'], -1);
    downloadUrlToFile(v['url'], script_path .. v['file_name']);
  end
end

local tajik_image = renderLoadTextureFromFile(script_path .. "tajik_image.png"); assert(tajik_image, "Image not found!");
local tajik_sound = loadAudioStream(script_path .. "tajik_sound.mp3"); assert(tajik_image, "Sound not found!");

local accent_enabled = false;
local accent = "[Àøîòèêîâñêèé àêöåíò]: ";

local screen_width, screen_height = getScreenResolution();

--[[local purple = ff00fb;
local vipadv = fd446f;
local titan = f6495ed;
local premium = f345fc; 
--]]
function main()
    while not isSampAvailable() do wait(0) end
    if (not isSampLoaded() or not isSampfuncsLoaded()) then return end
    print(script_name .. script_tag .. "ÅÁÀÒÜ ÊÀÊ ÎÍ ÊĞÓÒÎ ÇÀÃĞÓÆÅÍ!!!");
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
    sampRegisterChatCommand("cc", function() for i = 0, 20 do sampAddChatMessage("", -1); end end);
    sampRegisterChatCommand("");
    sampRegisterChatCommand("test", function() sampShowDialog(1, "Âîïğîñ æèçíè è ñìåğòè!", "Ñîñàë?", "Ïîäâåğäèòü", "Âûéòè", 1); end);
    sampRegisterChatCommand("test_load", function()
      sampAddChatMessage("Hello!", -1);  
    end);
    sampRegisterChatCommand("testcall", function(id) call(id) end);
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
    end
end
function poslat_nahuy(id, chatType)
  id = tonumber(id);
  if id == nil or id < 0 or id > 999 then sampAddChatMessage(script_tag .. "{ffffff}ÄÀËÁÀÅÁ ÈÑÏÎËÜÇÓÉ /poslatnahuy è ID ÍÀÕÓÉ", -1);
  elseif not sampIsPlayerConnected(id) then sampAddChatMessage(script_tag .. "{FFFFFF}ÒÛ ÊÎÍ×ÅÍÍÛÉ???? ÈÃĞÎÊ ÎÔÔËÀÉÍ ÍÀÕÓÉ", -1);
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