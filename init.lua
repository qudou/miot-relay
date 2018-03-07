-- init.lua
local wifiReady = 0
print('Setting up WIFI...')
station_cfg={}
station_cfg.ssid="A+store"
station_cfg.pwd="a+store11"
wifi.setmode(wifi.STATION)
wifi.sta.config(station_cfg)
wifi.sta.connect()
wifi.sta.autoconnect(1)

tmr.alarm(1, 2000, tmr.ALARM_AUTO, function()
    if wifi.sta.getip() == nil then
        wifiReady = 0
        print('Waiting for IP ...')
    elseif wifiReady == 0 then
        wifiReady = 1
        print('IP is ' .. wifi.sta.getip())
        dofile("mqtt.lua")
    end
end)
