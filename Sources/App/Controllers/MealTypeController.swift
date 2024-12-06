//
//  AlimentController.swift
//  ZakFit_Vapor
//
//  Created by Apprenant 141 on 05/12/2024.
//

import Fluent
import Vapor

struct MealTypeController: RouteCollection {
    func boot(routes: Vapor.RoutesBuilder) throws {
        let mealTypes = routes.grouped("mealTypes")

        mealTypes.get(use: self.index)
        mealTypes.post(use: self.create)
        mealTypes.group(":mealTypeID") { mealType in
            mealType.delete(use: self.delete)
        }
    }

    @Sendable func index(req: Request) async throws -> [MealType] {
        return try await MealType.query(on: req.db).all()
    }

    @Sendable func create(req: Request) async throws -> MealType {
        let mealType = try req.content.decode(MealType.self)

        try await mealType.save(on: req.db)
        return mealType
    }

    @Sendable func delete(req: Request) async throws -> HTTPStatus {
        guard let mealType = try await MealType.find(req.parameters.get("mealTypeID"), on: req.db) else {
            throw Abort(.notFound)
        }

        try await mealType.delete(on: req.db)
        return .noContent
    }
}
