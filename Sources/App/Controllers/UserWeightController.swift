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

        userWeights.get(use: self.index)
        userWeights.post(use: self.create)
        userWeights.group(":userWeightID") { userWeight in
            userWeight.delete(use: self.delete)
        }
    }

    @Sendable func index(req: Request) async throws -> [UserWeight] {
        return try await UserWeight.query(on: req.db).all()
    }

    @Sendable func create(req: Request) async throws -> UserWeight {
        let userWeight = try req.content.decode(UserWeight.self)

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
}
