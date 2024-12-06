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

        weightGoals.get(use: self.index)
        weightGoals.post(use: self.create)
        weightGoals.group(":weightGoalsID") { weightGoal in
            weightGoal.delete(use: self.delete)
        }
    }

    @Sendable func index(req: Request) async throws -> [WeightGoal] {
        return try await WeightGoal.query(on: req.db).all()
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
