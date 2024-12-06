//
//  AlimentController.swift
//  ZakFit_Vapor
//
//  Created by Apprenant 141 on 05/12/2024.
//

import Fluent
import Vapor

struct MealController: RouteCollection {
    func boot(routes: Vapor.RoutesBuilder) throws {
        let meals = routes.grouped("meals")

        meals.get(use: self.index)
        meals.post(use: self.create)
        meals.group(":mealID") { meal in
            meal.delete(use: self.delete)
        }
    }

    @Sendable func index(req: Request) async throws -> [Meal] {
        return try await Meal.query(on: req.db).all()
    }

    @Sendable func create(req: Request) async throws -> Meal {
        let meal = try req.content.decode(Meal.self)

        try await meal.save(on: req.db)
        return meal
    }

    @Sendable func delete(req: Request) async throws -> HTTPStatus {
        guard let meal = try await Meal.find(req.parameters.get("mealID"), on: req.db) else {
            throw Abort(.notFound)
        }

        try await meal.delete(on: req.db)
        return .noContent
    }
}
