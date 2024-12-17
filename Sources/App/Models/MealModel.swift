//
//  ActivityTypeModel.swift
//  ZakFit_Vapor
//
//  Created by Apprenant 141 on 05/12/2024.
//

import Vapor
import Fluent

final class Meal: Model, Content, @unchecked Sendable {
    static let schema = "meals"
    
    @ID(key: .id)
    var id: UUID?

    @Field(key: "name")
    var name: String
    
    @Field(key: "image")
    var image: String?
    
    @Field(key: "date")
    var date: Date

    @Field(key: "total_calories")
    var totalCalories: Double
    
    @Field(key: "total_proteins")
    var totalProteins: Double
    
    @Field(key: "total_carbohydrates")
    var totalCarbohydrates: Double
    
    @Field(key: "total_lipids")
    var totalLipids: Double
    
    @Field(key: "id_meal_type")
    var idMealType: UUID
    
    @Field(key: "id_user")
    var idUser: UUID
    
    init() { }

    init(id: UUID? = nil, name: String, image: String, date: Date, totalCalories: Double, totalProteins: Double, totalCarbohydrates: Double, totalLipids: Double, idMealType: UUID, idUser: UUID) {
        self.id = id ?? UUID()
        self.name = name
        self.image = image
        self.date = date
        self.totalCalories = totalCalories
        self.totalProteins = totalProteins
        self.totalCarbohydrates = totalCarbohydrates
        self.totalLipids = totalLipids
        self.idMealType = idMealType
        self.idUser = idUser
    }
}
