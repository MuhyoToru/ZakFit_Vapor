//
//  UserController.swift
//  ZakFit_Vapor
//
//  Created by Apprenant 141 on 05/12/2024.
//

import Fluent
import Vapor

struct WeightGoalController: RouteCollection {
    func boot(routes: Vapor.RoutesBuilder) throws {
        let weightGoals = routes.grouped("weightGoals")

        let authGroupToken = weightGoals.grouped(TokenSession.authenticator(), TokenSession.guardMiddleware())
        
        authGroupToken.get(use: self.index)
        authGroupToken.post(use: self.create)
        authGroupToken.group(":weightGoalsID") { weightGoal in
            weightGoal.delete(use: self.delete)
        }
    }

    @Sendable func index(req: Request) async throws -> WeightGoal {
        let idUser = try await DecodeRequest().getIdFromJWT(req: req)
        
//        let physicalActivitys = try await PhysicalActivity.query(on: req.db).all().filter({$0.idUser == idUser})
        
        guard let weightGoal = try await WeightGoal.query(on: req.db).all().filter({ $0.idUser == idUser }).first else {
            throw Abort(.notFound)
        }
        
        return weightGoal
    }

    @Sendable func create(req: Request) async throws -> WeightGoal {
        let weightGoal = try req.content.decode(WeightGoal.self)

        try await weightGoal.save(on: req.db)
        return weightGoal
    }

    @Sendable func delete(req: Request) async throws -> HTTPStatus {
        guard let weightGoal = try await WeightGoal.find(req.parameters.get("weightGoalID"), on: req.db) else {
            throw Abort(.notFound)
        }

        try await weightGoal.delete(on: req.db)
        return .noContent
    }
}
