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
        guard let physicalActivity = try await PhysicalActivity.find(req.parameters.get("physicalActivityID"), on: req.db) else {
            throw Abort(.notFound)
        }

        try await physicalActivity.delete(on: req.db)
        return .noContent
    }
    
    @Sendable func getByUserId(req: Request) async throws -> [PhysicalActivity] {
        let idUser = try await DecodeRequest().getIdFromJWT(req: req)
        
        let physicalActivitys = try await PhysicalActivity.query(on: req.db).all().filter({$0.idUser == idUser})
        
        return physicalActivitys
    }
    
    @Sendable func update(req: Request) async throws -> HTTPStatus {
        let updatedPhysicalActivitys = try req.content.decode(PhysicalActivity.self)
        
        guard let physicalActivitys = try await PhysicalActivity.find(updatedPhysicalActivitys.id, on: req.db) else {
            throw Abort(.notFound)
        }
        
        physicalActivitys.caloriesBurned = updatedPhysicalActivitys.caloriesBurned
        physicalActivitys.date = updatedPhysicalActivitys.date
        physicalActivitys.duration = updatedPhysicalActivitys.duration
        physicalActivitys.idIntensity = updatedPhysicalActivitys.idIntensity
        physicalActivitys.idActivityType = updatedPhysicalActivitys.idActivityType
        
        try await physicalActivitys.save(on: req.db)
        return .ok
    }
}
