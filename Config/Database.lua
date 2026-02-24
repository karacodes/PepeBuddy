local _, pb = ...

pb.defaultOptions = {
    profile = {
        debugMode = false,
        isMovable = true,
        size = 300,
        scale = 1,
        selectedPepe = 1,
        minimapIcon = {
            hide = false,
        },
    },
}

function PepeBuddy:SetupDatabase()
    self.db = LibStub("AceDB-3.0"):New(pb.preferenceName, pb.defaultOptions)
    pb.debugMode = (self.db and self.db.profile and self.db.profile.debugMode) and true or false
end
