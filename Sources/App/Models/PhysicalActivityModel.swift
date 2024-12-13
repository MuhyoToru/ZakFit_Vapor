//
//  ActivityTypeModel.swift
//  ZakFit_Vapor
//
//  Created by Apprenant 141 on 05/12/2024.
//

import Vapor
import Fluent

final class PhysicalActivity: Model, Content, @unchecked Sendable {
    static let schema = "physical_activitys"
    
    @ID(key: .id)
    var id: UUID?

    @Field(key: "date")
    var date: Date
    
    @Field(key: "duration")
    var duration: Double
    
    @Field(key: "calories_burned")
    var caloriesBurned: Double
    
    @Field(key: "id_user")
    var idUser: UUID
    
    @Field(key: "id_intensity")
    var idIntensity: UUID
    
    @Field(key: "id_activity_type")
    var idActivityType: UUID
    
    init() { }

    init(id: UUID? = nil, date: Date, duration: Double, caloriesBurned: Double, idUser: UUID, idIntensity: UUID, idActivityType: UUID) {
        self.id = id ?? UUID()
        self.date = date
        self.duration = duration
        self.caloriesBurned = caloriesBurned
        self.idUser = idUser
        self.idIntensity = idIntensity
        self.idActivityType = idActivityType
    }
}
