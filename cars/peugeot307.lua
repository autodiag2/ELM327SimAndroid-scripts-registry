-- data from peugeot 307, April 5 2026
function response(req)
  -- SAEJ1979 response
  -- Mode 01 PID 0C (engine RPM)
  if req[1] == 0x01 and req[2] == 0x0C then
    local rpm = 3000
    local value = rpm * 4 
    return { 0x41, 0x0C, math.floor(value / 256), value % 256 } 
  end
  -- supported PIDs
  if req[1] == 0x00 or req[1] == 0x20 then
    return { 0x41, req[1], 0xFF, 0xFF, 0xFF, 0xFF}
  end
  -- vehicle specific command - unknown meaning
  if req[1] == 0x81 then
    return {0xC1, 0xEF, 0x8F}
  end
  -- security access maybe
  if req[1] == 0x27 then
    if req[2] == 0x01 then
      return {0x67, 0x01, 0x00, 0x00}
    end
    if req[1] == 0x02 and req[1] == 0x12 and req[2] == 0x34 then
      return {0x7F, 0x27, 0x12}
    end
  end
  -- unsupported services
  if req[1] == 0x21 or req[1] == 0x18 or req[1] == 0x19 or req[1] == 0x30 then
    return {0x7F, req[1], 0x11}
  end  
end
