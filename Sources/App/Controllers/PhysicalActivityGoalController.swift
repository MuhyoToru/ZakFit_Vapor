//
//  AlimentController.swift
//  ZakFit_Vapor
//
//  Created by Apprenant 141 on 05/12/2024.
//

import Fluent
import Vapor

struct PhysicalActivityGoalController: RouteCollection {
    func boot(routes: Vapor.RoutesBuilder) throws {
        let physicalActivityGoals = routes.grouped("physicalActivityGoals")

        physicalActivityGoals.get(use: self.index)
        physicalActivityGoals.post(use: self.create)
        physicalActivityGoals.group(":physicalActivityGoalID") { physicalActivityGoal in
            physicalActivityGoal.delete(use: self.delete)
        }
    }

    @Sendable func index(req: Request) async throws -> [PhysicalActivityGoal] {
        return try await PhysicalActivityGoal.query(on: req.db).all()
    }

    @Sendable func create(req: Request) async throws -> PhysicalActivityGoal {
        let physicalActivityGoal = try req.content.decode(PhysicalActivityGoal.self)

        try await physicalActivityGoal.save(on: req.db)
        return physicalActivityGoal
    }

    @Sendable func delete(req: Request) async throws -> HTTPStatus {
        guard let physicalActivityGoal = try await PhysicalActivityGoal.find(req.parameters.get("physicalActivityGoalID"), on: req.db) else {
            throw Abort(.notFound)
        }

        try await physicalActivityGoal.delete(on: req.db)
        return .noContent
    }
}
