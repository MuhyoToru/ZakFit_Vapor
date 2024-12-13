//
//  UserController.swift
//  ZakFit_Vapor
//
//  Created by Apprenant 141 on 05/12/2024.
//

import Fluent
import Vapor

struct UserWeightController: RouteCollection {
    func boot(routes: Vapor.RoutesBuilder) throws {
        let userWeights = routes.grouped("userWeights")

        let authGroupToken = userWeights.grouped(TokenSession.authenticator(), TokenSession.guardMiddleware())
        
        authGroupToken.get(use: self.getByUserId)
        authGroupToken.post("create", use: self.create)
        authGroupToken.post("update", use: self.update)
    }

    @Sendable func index(req: Request) async throws -> [UserWeight] {
        return try await UserWeight.query(on: req.db).all()
    }

    @Sendable func create(req: Request) async throws -> UserWeight {
        let userWeight = try req.content.decode(UserWeight.self)
        
        userWeight.idUser = try await DecodeRequest().getIdFromJWT(req: req)

        try await userWeight.save(on: req.db)
        return userWeight
    }

    @Sendable func delete(req: Request) async throws -> HTTPStatus {
        guard let userWeight = try await UserWeight.find(req.parameters.get("userWeightID"), on: req.db) else {
            throw Abort(.notFound)
        }

        try await userWeight.delete(on: req.db)
        return .noContent
    }
    
    @Sendable func getByUserId(req: Request) async throws -> [UserWeight] {
        let idUser = try await DecodeRequest().getIdFromJWT(req: req)
        
        let userWeights = try await UserWeight.query(on: req.db).all().filter({$0.idUser == idUser})
        
        return userWeights
    }
    
    @Sendable func update(req: Request) async throws -> HTTPStatus {
        let updatedUserWeight = try req.content.decode(UserWeight.self)
        
        guard let userWeight = try await UserWeight.find(updatedUserWeight.id, on: req.db) else {
            throw Abort(.notFound)
        }
        
        userWeight.weight = updatedUserWeight.weight
        
        try await userWeight.save(on: req.db)
        return .ok
    }
}
