//
//  AlimentModel.swift
//  ZakFit_Vapor
//
//  Created by Apprenant 141 on 05/12/2024.
//

import Vapor
import Fluent

final class Aliment: Model, Content, @unchecked Sendable {
    static let schema = "aliments"
    
    @ID(key: .id)
    var id: UUID?

    @Field(key: "name")
    var name: String
    
    @Field(key: "description")
    var description: String
    
    @Field(key: "image")
    var image: String
    
    @Field(key: "calories_kg")
    var caloriesKg: Double?
    
    @Field(key: "calories_unit")
    var caloriesUnit: Double?
    
    @Field(key: "proteins")
    var proteins: Double?
    
    @Field(key: "carbohydrates")
    var carbohydrates: Double?
    
    @Field(key: "lipids")
    var lipids: Double?

    init() { }

    init(id: UUID? = nil, name: String, description: String, image: String, caloriesKg: Double? = nil, caloriesUnit: Double? = nil, proteins: Double? = nil, carbohydrates: Double? = nil, lipids: Double? = nil) {
        self.id = id ?? UUID()
        self.name = name
        self.description = description
        self.image = image
        self.caloriesKg = caloriesKg
        self.caloriesUnit = caloriesUnit
        self.proteins = proteins
        self.carbohydrates = carbohydrates
        self.lipids = lipids
    }
}
