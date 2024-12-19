//
//  ActivityTypeModel.swift
//  ZakFit_Vapor
//
//  Created by Apprenant 141 on 05/12/2024.
//

import Vapor
import Fluent

final class AlimentQuantity: Model, Content, @unchecked Sendable {
    static let schema = "aliment_quantitys"
    
    @ID(key: .id)
    var id: UUID?

    @Field(key: "quantity")
    var quantity: Double
    
    @Field(key: "weight_or_unit")
    var weightOrUnit: String
    
    @Field(key: "id_aliment")
    var idAliment: UUID

    init() { }

    init(id: UUID? = nil, quantity: Double, weightOrUnit: String, idAliment: UUID) {
        self.id = id ?? UUID()
        self.quantity = quantity
        self.weightOrUnit = weightOrUnit
        self.idAliment = idAliment
    }
}
