//
//  ActivityTypeModel.swift
//  ZakFit_Vapor
//
//  Created by Apprenant 141 on 05/12/2024.
//

import Vapor
import Fluent

final class AQMealLink: Model, Content, @unchecked Sendable {
    static let schema = "aq_meal_links"
    
    @ID(key: .id)
    var id: UUID?

    @Field(key: "id_meal")
    var idMeal: UUID
    
    @Field(key: "id_aliment_quantity")
    var idAlimentQuantity: UUID

    init() { }

    init(id: UUID? = nil, idMeal: UUID, idAlimentQuantity: UUID) {
        self.id = id
        self.idMeal = idMeal
        self.idAlimentQuantity = idAlimentQuantity
    }
}
