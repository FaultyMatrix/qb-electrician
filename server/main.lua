local QBCore = exports['qb-core']:GetCoreObject()

RegisterNetEvent('qb-electrician:server:Payslip', function(drops)
    local src = source
    local Player = QBCore.Functions.GetPlayer(src)
    local drops = tonumber(drops)
    local bonus = 0
    if drops > 1 then
        bonus = math.ceil((Config.JobPrice / 10) * 5) + 300
    elseif drops > 2 then
        bonus = math.ceil((Config.JobPrice / 10) * 7) + 400
    elseif drops > 3 then
        bonus = math.ceil((Config.JobPrice / 10) * 10) + 500
    elseif drops > 4 then
        bonus = math.ceil((Config.JobPrice / 10) * 12) + 600
    end
    local price = (Config.JobPrice * drops) + bonus
    local taxAmount = math.ceil((price / 100) * Config.PaymentTax)
    local payment = price - taxAmount
    Player.Functions.AddMoney("bank", payment, "electrician-salary")
    TriggerClientEvent('QBCore:Notify', src, 'You were paid $'..payment.. ' - Payment: $'..price.. ' minus $' ..taxAmount.. 'in taxes.', 'success')
end)