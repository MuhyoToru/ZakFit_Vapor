//
//  AlimentController.swift
//  ZakFit_Vapor
//
//  Created by Apprenant 141 on 05/12/2024.
//

import Fluent
import Vapor

struct PhysicalActivityController: RouteCollection {
    func boot(routes: Vapor.RoutesBuilder) throws {
        let physicalActivitys = routes.grouped("physicalActivitys")

        let authGroupToken = physicalActivitys.grouped(TokenSession.authenticator(), TokenSession.guardMiddleware())
        
        authGroupToken.get(use: self.getByUserId)
        authGroupToken.post("create", use: self.create)
        authGroupToken.post("update", use: self.update)
        authGroupToken.get("delete", ":idPhysicalActivity", use: self.delete)
    }

    @Sendable func index(req: Request) async throws -> [PhysicalActivity] {
        return try await PhysicalActivity.query(on: req.db).all()
    }

    @Sendable func create(req: Request) async throws -> PhysicalActivity {
        let physicalActivity = try req.content.decode(PhysicalActivity.self)

        try await physicalActivity.save(on: req.db)
        return physicalActivity
    }

    @Sendable func delete(req: Request) async throws -> HTTPStatus {
        guard let physicalActivity = try await PhysicalActivity.find(req.parameters.get("idPhysicalActivity"), on: req.db) else {
            throw Abort(.notFound)
        }

        try await physicalActivity.delete(on: req.db)
        return .ok
    }
    
    @Sendable func getByUserId(req: Request) async throws -> [PhysicalActivity] {
        let idUser = try await DecodeRequest().getIdFromJWT(req: req)
        
        let physicalActivitys = try await PhysicalActivity.query(on: req.db).all().filter({$0.idUser == idUser})
        
        return physicalActivitys
    }
    
    @Sendable func update(req: Request) async throws -> HTTPStatus {
        let updatedPhysicalActivity = try req.content.decode(PhysicalActivity.self)
        
        guard let physicalActivity = try await PhysicalActivity.find(updatedPhysicalActivity.id, on: req.db) else {
            throw Abort(.notFound)
        }
        
        physicalActivity.caloriesBurned = updatedPhysicalActivity.caloriesBurned
        physicalActivity.date = updatedPhysicalActivity.date
        physicalActivity.duration = updatedPhysicalActivity.duration
        physicalActivity.idIntensity = updatedPhysicalActivity.idIntensity
        physicalActivity.idActivityType = updatedPhysicalActivity.idActivityType
        
        try await physicalActivity.save(on: req.db)
        return .ok
    }
}
