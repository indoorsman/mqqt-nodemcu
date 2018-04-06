local mqttBroker
function connectMqtt(server)
    -- init mqtt client without logins, keepalive timer 120s
    mqttBroker = mqtt.Client(server, 120)
    
    -- setup Last Will and Testament (optional)
    -- Broker will publish a message with qos = 0, retain = 0, data = "offline" 
    -- to topic "/lwt" if client don't send keepalive packet
    mqttBroker:lwt("/lwt", "offline", 0, 0)
    
    mqttBroker:on("connect", function(client) print ("connected") end)
    mqttBroker:on("offline", function(client) print ("offline") end) 

    tmr.delay(2000000)
    -- m:close();
end

function MQTTOn(server, chanel, call)
    -- on publish message receive event
    server:on(chanel, call)
    -- server:on(chanel, function(client, topic, data) 
    --   print(topic .. ":" ) 
    --  if data ~= nil then
    --    print(data)
    --  end
    -- end)
end

-- you can call m:connect again