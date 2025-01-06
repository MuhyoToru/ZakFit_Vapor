//
//  AlimentController.swift
//  ZakFit_Vapor
//
//  Created by Apprenant 141 on 05/12/2024.
//

import Fluent
import Vapor

struct CaloriesGoalController: RouteCollection {
    func boot(routes: Vapor.RoutesBuilder) throws {
        let caloriesGoals = routes.grouped("caloriesGoals")
        
        let authGroupToken = caloriesGoals.grouped(TokenSession.authenticator(), TokenSession.guardMiddleware())

        authGroupToken.get(use: self.index)
        authGroupToken.post(use: self.create)
        authGroupToken.group(":caloriesGoalID") { caloriesGoal in
            caloriesGoal.delete(use: self.delete)
        }
    }

    @Sendable func index(req: Request) async throws -> [CaloriesGoal] {
        return try await CaloriesGoal.query(on: req.db).all()
    }

    @Sendable func create(req: Request) async throws -> CaloriesGoal {
        let caloriesGoal = try req.content.decode(CaloriesGoal.self)

        try await caloriesGoal.save(on: req.db)
        return caloriesGoal
    }

    @Sendable func delete(req: Request) async throws -> HTTPStatus {
        guard let caloriesGoal = try await CaloriesGoal.find(req.parameters.get("caloriesGoalID"), on: req.db) else {
            throw Abort(.notFound)
        }

        try await caloriesGoal.delete(on: req.db)
        return .noContent
    }
}
