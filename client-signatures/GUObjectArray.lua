function Register()
    return "48 8D 0D ?? ?? ?? ?? 48 8B D7 89 5C 24 20 44 8D 4B ??"
end

function OnMatchFound(matchAddress)
    local displacement = DerefToInt32(matchAddress + 0x3)
    return matchAddress + 0x7 + displacement
end
