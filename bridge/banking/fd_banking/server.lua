local banking = {}

function banking.getBalance(cid)
    return exports["fd_banking"]:getPersonalAccount(cid)
end

function banking.getSocietyBalance(job)
    return exports["fd_banking"]:getBusinessAccount(job).balance
end

function banking.depositSociety(job, amount, reason)
    local result = exports["fd_banking"]:AddMoney(job, amount, reason)
    if not result then
        return false, ("Failed to deposit %s to %s account not found"):format(amount, job)
    end

    return true
end

function banking.withdrawSociety(job, amount, reason)
    local result = exports["fd_banking"]:RemoveMoney(job, amount, reason)
    if not result then
        return false, "Failed to withdraw. account not found"
    end

    return true
end

return banking