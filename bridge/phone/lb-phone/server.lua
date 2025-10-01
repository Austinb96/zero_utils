local phone = {}

function phone.sendEmail(src, data)
    local number = exports["lb-phone"]:GetEquippedPhoneNumber(src)
        local player = exports["lb-phone"]:GetEmailAddress(number)
        local success, id = exports["lb-phone"]:SendMail({
            to = player,
            sender = data.sender,
            subject = data.subject,
            message = data.message,
        })
    return true
end

return phone

