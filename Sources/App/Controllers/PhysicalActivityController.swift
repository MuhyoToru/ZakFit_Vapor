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

        physicalActivitys.get(use: self.index)
        physicalActivitys.post(use: self.create)
        physicalActivitys.group(":physicalActivityID") { physicalActivity in
            physicalActivity.delete(use: self.delete)
        }
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
}
