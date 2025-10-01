local banking = {}

function banking.getBalance(cid)
    return exports["fd_banking"]:getPersonalAccount(cid)
end

function banking.getSocietyBalance(job)
    return exports["fd_banking"]:getBusinessAccount(job).balance
end

function banking.depositSociety(job, amount, reason, src)
    local result = exports["fd_banking"]:AddMoney(job, amount, reason)
    if result then
        zutils.notify(src, "success", ("Deposited $%s into %s account"):format(amount, job))
    else
        zutils.notify(src, "error", ("Failed to deposit %s to %s account not found"):format(amount, job))
        return PrintUtils.PrintError("Failed to deposit %s to %s account not found", amount, job)
    end

    return result
end

function banking.withdrawSociety(job, amount, reason, src)
    local result = exports["fd_banking"]:RemoveMoney(job, amount, reason)
    if result then
        zutils.notify(src, "success", ("Withdrew $%s from %s account"):format(amount, job))
    else
        zutils.notify(src, "error", ("Failed to withdraw from %s account not found"):format(job))
        return false, "Failed to withdraw. account not found"
    end

    return result
end

return banking