function Register()
    return "89 47 08 33 DB 48 8D 0D ?? ?? ?? ??"
end

function OnMatchFound(matchAddress)
    local lea = matchAddress + 0x5
    local displacement = DerefToInt32(lea + 0x3)
    return lea + 0x7 + displacement
end
