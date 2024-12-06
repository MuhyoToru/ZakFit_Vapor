//
//  AlimentController.swift
//  ZakFit_Vapor
//
//  Created by Apprenant 141 on 05/12/2024.
//

import Fluent
import Vapor

struct FoodPreferenceController: RouteCollection {
    func boot(routes: Vapor.RoutesBuilder) throws {
        let foodPreferences = routes.grouped("foodPreferences")

        foodPreferences.get(use: self.index)
        foodPreferences.post(use: self.create)
        foodPreferences.group(":foodPreferenceID") { foodPreference in
            foodPreference.delete(use: self.delete)
        }
    }

    @Sendable func index(req: Request) async throws -> [FoodPreference] {
        return try await FoodPreference.query(on: req.db).all()
    }

    @Sendable func create(req: Request) async throws -> FoodPreference {
        let foodPreference = try req.content.decode(FoodPreference.self)

        try await foodPreference.save(on: req.db)
        return foodPreference
    }

    @Sendable func delete(req: Request) async throws -> HTTPStatus {
        guard let foodPreference = try await FoodPreference.find(req.parameters.get("foodPreferenceID"), on: req.db) else {
            throw Abort(.notFound)
        }

        try await foodPreference.delete(on: req.db)
        return .noContent
    }
}
