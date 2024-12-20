//
//  AlimentController.swift
//  ZakFit_Vapor
//
//  Created by Apprenant 141 on 05/12/2024.
//

import Fluent
import FluentSQL
import Vapor

struct AlimentQuantityController: RouteCollection {
    func boot(routes: Vapor.RoutesBuilder) throws {
        let alimentQuantitys = routes.grouped("alimentQuantitys")
        
        let authGroupToken = alimentQuantitys.grouped(TokenSession.authenticator(), TokenSession.guardMiddleware())
        
        authGroupToken.get(use: self.index)
        authGroupToken.get("idMeal",":idMeal", use: self.getByMealId)
        authGroupToken.post("createWithIdMeal", ":idMeal", use: self.create)
        authGroupToken.post("update", use: self.update)
    }
    
    @Sendable func index(req: Request) async throws -> [AlimentQuantity] {
        return try await AlimentQuantity.query(on: req.db).all()
    }
    
    @Sendable func create(req: Request) async throws -> HTTPStatus {
        let alimentQuantity = try req.content.decode(AlimentQuantity.self)
        
        try await alimentQuantity.save(on: req.db)
        print("AlimentQuantity Create")
        
        return .ok
    }
    
    @Sendable func update(req: Request) async throws -> HTTPStatus {
        let updatedAlimentQuantity = try req.content.decode(AlimentQuantity.self)
        
        guard let alimentQuantity = try await AlimentQuantity.find(updatedAlimentQuantity.id, on: req.db) else {
            throw Abort(.notFound)
        }
        
        alimentQuantity.quantity = updatedAlimentQuantity.quantity
        alimentQuantity.weightOrUnit = updatedAlimentQuantity.weightOrUnit
        alimentQuantity.idAliment = updatedAlimentQuantity.idAliment
        
        try await alimentQuantity.save(on: req.db)
        return .ok
    }
    
    @Sendable func getByMealId(req: Request) async throws -> [AlimentQuantity] {
        guard let idMeal = req.parameters.get("idMeal") else {
            throw Abort(.notFound)
        }
        
        if let sql = req.db as? SQLDatabase {
            let alimentQuantitys = try await sql.raw("""
                SELECT aliment_quantitys.* 
                FROM aliment_quantitys
                JOIN aq_meal_links ON aliment_quantitys.id = aq_meal_links.id_aliment_quantity
                JOIN meals ON aq_meal_links.id_meal = meals.id
                WHERE meals.id = UNHEX(REPLACE(\(bind: idMeal), '-', ''))
            """).all(decodingFluent: AlimentQuantity.self)
            return alimentQuantitys
        }
        
        throw Abort(.internalServerError, reason: "La base de données n'est pas SQL.")
    }
}
