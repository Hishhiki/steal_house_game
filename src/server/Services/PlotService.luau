local PlotService = {}

function PlotService:AssignPlot(player)
    local plotsFolder = workspace:WaitForChild("Plots")

    for _, plot in plotsFolder:GetChildren() do
        if plot:IsA("Model") and plot:GetAttribute("OwnerId") == nil then
            plot:SetAttribute("OwnerId", player.UserId)

            print(player.Name, "получил участок", plot.Name)
            return plot
        end
    end

    warn("Нет свободного участка для", player.Name)
    return nil
end

function PlotService:ReleasePlot(player)
    local plotsFolder = workspace:FindFirstChild("Plots")
    if not plotsFolder then
        return
    end

    for _, plot in plotsFolder:GetChildren() do
        if plot:IsA("Model")
            and plot:GetAttribute("OwnerId") == player.UserId then

            plot:SetAttribute("OwnerId", nil)
            print(player.Name, "освободил участок", plot.Name)
            return
        end
    end
end

return PlotService