//
//  SettingsViewModel.swift
//  HealthMate
//

import Foundation
import CoreData

final class SettingsViewModel: ObservableObject {
    @Published var useMifflinStJeor: Bool = true
    @Published var useMetricUnits: Bool = true

    private let viewContext: NSManagedObjectContext

    init(context: NSManagedObjectContext) {
        self.viewContext = context
        load()
    }

    func load() {
        let request: NSFetchRequest<UserProfile> = UserProfile.fetchRequest()
        request.fetchLimit = 1
        if let profile = try? viewContext.fetch(request).first {
            useMifflinStJeor = profile.useMifflinStJeor
            useMetricUnits = profile.useMetricUnits
        }
    }

    func save() {
        let request: NSFetchRequest<UserProfile> = UserProfile.fetchRequest()
        request.fetchLimit = 1
        let profile = (try? viewContext.fetch(request).first) ?? UserProfile(context: viewContext)
        if profile.id == nil { profile.id = UUID(); profile.createdAt = Date() }
        profile.useMifflinStJeor = useMifflinStJeor
        profile.useMetricUnits = useMetricUnits
        try? viewContext.save()
    }
}


