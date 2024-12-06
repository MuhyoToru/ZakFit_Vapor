//
//  ActivityTypeModel.swift
//  ZakFit_Vapor
//
//  Created by Apprenant 141 on 05/12/2024.
//

import Vapor
import Fluent

final class UserWeight: Model, Content, @unchecked Sendable {
    static let schema = "user_weights"
    
    @ID(key: .id)
    var id: UUID?

    @Field(key: "weight")
    var weight: Double
    
    @Field(key: "date")
    var date: Date
    
    @Field(key: "id_user")
    var idUser: UUID
    
    init() { }

    init(id: UUID? = nil, weight: Double, date: Date, idUser: UUID) {
        self.id = id ?? UUID()
        self.weight = weight
        self.date = date
        self.idUser = idUser
    }
}
