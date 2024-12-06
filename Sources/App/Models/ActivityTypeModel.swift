//
//  ActivityTypeModel.swift
//  ZakFit_Vapor
//
//  Created by Apprenant 141 on 05/12/2024.
//

import Vapor
import Fluent

final class ActivityType: Model, Content, @unchecked Sendable {
    static let schema = "activity_types"
    
    @ID(key: .id)
    var id: UUID?

    @Field(key: "name")
    var name: String
    
    @Field(key: "calories_burned_per_hour")
    var caloriesBurnedPerHour: Double
    
    @Field(key: "image")
    var image: String

    init() { }

    init(id: UUID? = nil, name: String, caloriesBurnedPerHour: Double, image: String) {
        self.id = id ?? UUID()
        self.name = name
        self.caloriesBurnedPerHour = caloriesBurnedPerHour
        self.image = image
    }
}
