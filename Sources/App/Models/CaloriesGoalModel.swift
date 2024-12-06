//
//  ActivityTypeModel.swift
//  ZakFit_Vapor
//
//  Created by Apprenant 141 on 05/12/2024.
//

import Vapor
import Fluent

final class CaloriesGoal: Model, Content, @unchecked Sendable {
    static let schema = "calories_goals"
    
    @ID(key: .id)
    var id: UUID?

    @Field(key: "calories_goal")
    var caloriesGoal: Double
    
    @Field(key: "proteins_goal")
    var proteinsGoal: Double
    
    @Field(key: "carbohydrates_goal")
    var carbohydratesGoal: Double
    
    @Field(key: "lipids_goal")
    var lipidsGoal: Double

    @Field(key: "id_chosen_period")
    var idChosenPeriod: UUID
    
    @Field(key: "id_user")
    var idUser: UUID
    
    init() { }

    init(id: UUID? = nil, caloriesGoal: Double, proteinsGoal: Double, carbohydratesGoal: Double, lipidsGoal: Double, idChosenPeriod: UUID, idUser: UUID) {
        self.id = id ?? UUID()
        self.caloriesGoal = caloriesGoal
        self.proteinsGoal = proteinsGoal
        self.carbohydratesGoal = carbohydratesGoal
        self.lipidsGoal = lipidsGoal
        self.idChosenPeriod = idChosenPeriod
        self.idUser = idUser
    }
}
