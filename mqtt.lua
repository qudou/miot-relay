local ID = "17736a05-70c8-458c-9fa5-7bc413e1fe36"
local Gateway = "bbfc469e-f0d8-4dd0-b140-76983b58ebcb"

if m == nil then
    m = mqtt.Client(Gateway, 120, 'user', 'pass')
else
    m:close()
end

m:on("connect",function(m)
	print("connection "..node.heap())
	m:subscribe(ID,0,function(m) print("sub done") end)
end )

m:on("message", function(client, topic, data) 
    print(topic .. ':')
    if data ~= nil then
        t = sjson.decode(data)
        gpio.mode(0, gpio.OUTPUT)
        if t.body.stat == "open" then
            gpio.write(0, gpio.HIGH)
        else
            gpio.write(0, gpio.LOW)
        end
        message = {}
        message.ssid = ID
        message.data = t.body
        message = sjson.encode(message)
        if t.topic == "control" then
            m:publish("to-gateway",message,1,1, function(client) print("sent") end)
        end
    end
end)

m:connect('192.168.1.52',1883,0,1)
