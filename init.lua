function listap(t)
      for k,v in pairs(t) do
        print(k.." : "..v)
      end
end

function connectWIFI()

    if (wifi.sta.status() ~= wifi.STA_CONNECTING) then

        wifi.setmode(wifi.STATION)
        --wifi.sta.config("VIVO-1AEA","J609122547")
        wifi.sta.config({ssid='VIVO-1AEA', pwd='J609122547'})
        wifi.sta.connect()
    end
    
    tmr.delay(1000000)   -- wait 1,000,000 us = 1 second

    print("STATUS: " .. wifi.sta.status())
    print("IPS: " .. wifi.sta.getip())
end

function connectWIFIWaiting()
        tmr.alarm(
            0,
            1000,
            tmr.ALARM_SINGLE,
                function (t)
                    if (wifi.STA_CONNECTING ~= wifi.sta.status()) then
                        print("Not connection internet. Status:" .. wifi.sta.status())
                        connectWIFIWaiting()
                    else
                        print("Current Status: " .. wifi.sta.status())
                    end
                end
        )
end

function actionLed(pin, action)
    gpio.mode(pin, gpio.OUTPUT)

    if action then
        print("Power on " .. pin)
        gpio.write(pin, gpio.HIGH)
    else
        print("Power off " .. pin)
        gpio.write(pin, gpio.LOW)
    end
end

mqttBroker = nil
function connectMqtt(id, server, port)
    print("# MQTT ID: " .. id)
    print("# MQTT HOST: " .. server)
    print("# MQTT PORT: " .. port)
    
    -- init mqtt client without logins, keepalive timer 120s
    mqttBroker = mqtt.Client(id, 120)

    -- Connect to broker
    mqttBroker:connect(server, port, 0, 0, function(con) 
        -- And then pings each 1000 milliseconds
        print("### connected ####")

        end,
        function (client, reason) 
            print("## Not Connection: " .. reason)

            if (reason ~= 0) then
                connectMqtt(id, server, port)
            end
        end
    )

    mqttBroker:on("message", function(conn, topic, data) 
      if data ~= nil then
        print("##" .. topic .. ": " .. data)

        -- ledsON
        if (topic == '/ledsON') then
            if (data ~= nil) then
                actionLed(data, 1);
            end
        end

        -- ledsOFF
        if (topic == '/ledsOFF') then
            if (data ~= nil) then
                actionLed(data, false);
            end
        end
        
        -- do something, we have received a message
      end
    end)
    
    -- setup Last Will and Testament (optional)
    -- Broker will publish a message with qos = 0, retain = 0, data = "offline" 
    -- to topic "/lwt" if client don't send keepalive packet
    mqttBroker:lwt("/lwt", "offline", 0, 0)
    
    mqttBroker:on("connect",
        function(client)
            print ("## connected") 

            mqttBroker:subscribe("/ledsON", 0, function(client, topic, data) 
                print("->ledsON: ")
            end)
            mqttBroker:subscribe("/ledsOFF", 0, function(client, topic, data) 
               print("->ledsOFF: ")
            end)
        end
    )
    
    mqttBroker:on("offline", 
        function(client) 
            print ("## offline") 
        end
    ) 
    -- m:close();
   
end

-- Configs
-- local MQTT_SERVER = '192.168.15.6'
--  local MQTT_PORT = 32773
local MQTT_SERVER = '192.168.15.6'
local MQTT_PORT = 1883
local MQTT_ID = 'nodeMCU'
local chanel = 'leds'
local ledRed = 1
local ledYello = 2
local ledBlue = 3

print("Waiting 3 seconds")
tmr.delay(3000000)

-- actionLed(1, false)
-- wifi.sta.getap(listap)
print("Start connection WIFI")
connectWIFI()
connectWIFIWaiting()

wifi.eventmon.register(wifi.eventmon.STA_CONNECTED, function(T)
    print("Start connection MQTT")
    connectMqtt(MQTT_ID, MQTT_SERVER, MQTT_PORT)
end)

