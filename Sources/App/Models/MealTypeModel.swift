//
//  ActivityTypeModel.swift
//  ZakFit_Vapor
//
//  Created by Apprenant 141 on 05/12/2024.
//

import Vapor
import Fluent

final class MealType: Model, Content, @unchecked Sendable {
    static let schema = "meal_types"
    
    @ID(key: .id)
    var id: UUID?

    @Field(key: "name")
    var name: String
    
    init() { }

    init(id: UUID? = nil, name: String) {
        self.id = id ?? UUID()
        self.name = name
    }
}
