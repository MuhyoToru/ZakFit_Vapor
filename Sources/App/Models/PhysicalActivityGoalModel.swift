//
//  ActivityTypeModel.swift
//  ZakFit_Vapor
//
//  Created by Apprenant 141 on 05/12/2024.
//

import Vapor
import Fluent

final class PhysicalActivityGoal: Model, Content, @unchecked Sendable {
    static let schema = "physical_activity_goals"
    
    @ID(key: .id)
    var id: UUID?

    @Field(key: "activity_frequency")
    var activityFrequency: Int
    
    @Field(key: "calories_burned")
    var caloriesBurned: Double
    
    @Field(key: "session_duration")
    var sessionDuration: Double
    
    @Field(key: "progression_wanted")
    var progressionWanted: Double
    
    @Field(key: "id_chosen_period")
    var idChosenPeriod: UUID
    
    @Field(key: "id_user")
    var idUser: UUID
    
    init() { }

    init(id: UUID? = nil, activityFrequency: Int, caloriesBurned: Double, sessionDuration: Double, progressionWanted: Double, idChosenPeriod: UUID, idUser: UUID) {
        self.id = id ?? UUID()
        self.activityFrequency = activityFrequency
        self.caloriesBurned = caloriesBurned
        self.sessionDuration = sessionDuration
        self.progressionWanted = progressionWanted
        self.idChosenPeriod = idChosenPeriod
        self.idUser = idUser
    }
}
