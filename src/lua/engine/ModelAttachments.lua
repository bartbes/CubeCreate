function modelAttachment (tag, _name)
    assert(not string.find(tag, ","))
    assert(not string.find(_name, ","))

    return tag .. "," .. _name
end
