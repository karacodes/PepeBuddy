local _, pb = ...

pb.defaultOptions = {
    profile = {
        disabledInfo = true,
        isMovable = true,
        scale = 1,
        selectedPepe = 1,
        minimapIcon = {
            hide = false,
        },
    },
}

function PepeBuddy:SetupDatabase()
    self.db = LibStub("AceDB-3.0"):New(pb.preferenceName, pb.defaultOptions)
end
