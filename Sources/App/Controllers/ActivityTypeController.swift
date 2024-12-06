//
//  AlimentController.swift
//  ZakFit_Vapor
//
//  Created by Apprenant 141 on 05/12/2024.
//

import Fluent
import Vapor

struct ActivityTypeController: RouteCollection {
    func boot(routes: Vapor.RoutesBuilder) throws {
        let activityTypes = routes.grouped("activityTypes")

        activityTypes.get(use: self.index)
        activityTypes.post(use: self.create)
        activityTypes.group(":activityTypeID") { activityType in
            activityType.delete(use: self.delete)
        }
    }

    @Sendable func index(req: Request) async throws -> [ActivityType] {
        return try await ActivityType.query(on: req.db).all()
    }

    @Sendable func create(req: Request) async throws -> ActivityType {
        let activityType = try req.content.decode(ActivityType.self)

        try await activityType.save(on: req.db)
        return activityType
    }

    @Sendable func delete(req: Request) async throws -> HTTPStatus {
        guard let activityType = try await ActivityType.find(req.parameters.get("activityTypeID"), on: req.db) else {
            throw Abort(.notFound)
        }

        try await activityType.delete(on: req.db)
        return .noContent
    }
}
