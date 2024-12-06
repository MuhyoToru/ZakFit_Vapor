//
//  ActivityTypeModel.swift
//  ZakFit_Vapor
//
//  Created by Apprenant 141 on 05/12/2024.
//

import Vapor
import Fluent

final class WeightGoal: Model, Content, @unchecked Sendable {
    static let schema = "weight_goals"
    
    @ID(key: .id)
    var id: UUID?

    @Field(key: "weight_goal")
    var weight: Double
    
    @Field(key: "id_chosen_period")
    var idChosenPeriod: UUID
    
    @Field(key: "id_user")
    var idUser: UUID
    
    init() { }

    init(id: UUID? = nil, weight: Double, idChosenPeriod: UUID, idUser: UUID) {
        self.id = id ?? UUID()
        self.weight = weight
        self.idChosenPeriod = idChosenPeriod
        self.idUser = idUser
    }
}
