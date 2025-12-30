# MPBEKING CW306BLE

https://www.amazon.com/dp/B094FKXKQS

Android app is [IKeeping](https://play.google.com/store/apps/details?id=com.lefu.ikeep)

The scale broadcasts data constantly upon wake up with advertisement manufacturer data (may receive multiple with same content), device is not connectable

Seems like there is no battery state reported

```
All multi byte data is in small endian

 CE 01 02 00 00 00 00 00 00 01 CC FF
|MD|HR|HF| WEI |  IMPD  |DU|ST|CK|..|

MD: Device model (ca, cb, cc, ce, cf)
HR: Heartrate value
HF: If 0xC0 then HR byte is valid
WEI: Weight expressed always in kg multipled by 100 (e.g. BD 02 = 3026 = 30.26kg)
IMPD: Impedance for body fat calc, 0 if not supported
DU: Display unit, 0=kg 1=lb
ST: State, 0=stable 1=measuring
CK: Check byte (MD to ST XOR'ed)
```
```yaml
esphome:
  on_boot:
    priority: -100
    then:
      lambda: |-
        id(body_scale_weight).publish_state(id(last_published_weight));
        id(body_scale_last_update).publish_state(id(last_published_time) > 0 ? id(last_published_time) : NAN);

esp32:
  board: esp32dev
  framework:
    type: esp-idf

api:
  encryption:
    key: ...

logger:

wifi:
  ssid: !secret wifi_ssid
  password: !secret wifi_password

ota:
  - platform: esphome
    password: ...

time:
  - platform: sntp
    id: sntp_time
    servers:
      - 0.pool.ntp.org
      - 1.pool.ntp.org
      - 2.pool.ntp.org
  - platform: homeassistant
    id: ha_time

globals:
  - id: is_receiving
    type: bool
    restore_value: no
    initial_value: "false"
  - id: last_received_millis
    type: uint32_t
    restore_value: no
    initial_value: "0"
  - id: last_received_weight
    type: float
    restore_value: no
    initial_value: "0.0"
  - id: last_published_weight
    type: float
    restore_value: yes
    initial_value: "NAN"
  - id: last_published_time
    type: uint32_t
    restore_value: yes
    initial_value: "NAN"

bluetooth_proxy:

sensor:
  - id: body_scale_weight
    platform: template
    name: "Body Scale Weight"
    device_class: weight
    unit_of_measurement: kg
    lambda: "return id(last_published_weight);"
    update_interval: never

  - id: body_scale_last_update
    platform: template
    name: "Body Scale Last Update"
    device_class: timestamp
    lambda: "return id(last_published_time);"
    update_interval: never

esp32_ble_tracker:
  on_ble_manufacturer_data_advertise:
    - mac_address: "CE:E8:03:09:00:63"
      manufacturer_id: "0000"
      then:
        - lambda: |-
            // Validate length
            if(x.size() < 17)
              return;
            
            // Validate check byte
            uint8_t check = 0x00;
            for(uint8_t i = 6; i < 16; ++i)
              check ^= x[i];
            if(x[16] != check)
              return;

            // Validate stable
            if(x[15] != 0x00)
              return;

            // Record weight and timestamp
            id(last_received_weight) = ((uint16_t)(x[10] << 8 | x[9])) / 100.0;
            id(last_received_millis) = millis();
            id(is_receiving) = true;
            ESP_LOGD("ble_scale", "Received weight: %f kg at millis=%u", id(last_received_weight), id(last_received_millis));

interval:
  - interval: 1s
    then:
      - if:
          condition:
            lambda: "return id(is_receiving) && millis() - id(last_received_millis) > 5000;"
          then:
            - lambda: |-
                id(last_published_weight) = id(last_received_weight);
                id(last_published_time) = id(ha_time).utcnow().is_valid()
                                            ? id(ha_time).utcnow().timestamp
                                            : id(sntp_time).utcnow().is_valid()
                                            ? id(sntp_time).utcnow().timestamp 
                                            : 0;
                id(is_receiving) = false;
                id(body_scale_weight).publish_state(id(last_published_weight));
                id(body_scale_last_update).publish_state(id(last_published_time) > 0 ? id(last_published_time) : NAN);
                ESP_LOGI("ble_scale", "Published weight: %f kg at %u", id(last_published_weight), id(last_published_time));
```
