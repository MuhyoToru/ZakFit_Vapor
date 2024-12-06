//
//  AlimentController.swift
//  ZakFit_Vapor
//
//  Created by Apprenant 141 on 05/12/2024.
//

import Fluent
import Vapor

struct ChosenPeriodController: RouteCollection {
    func boot(routes: Vapor.RoutesBuilder) throws {
        let chosenPeriods = routes.grouped("chosenPeriods")

        chosenPeriods.get(use: self.index)
        chosenPeriods.post(use: self.create)
        chosenPeriods.group(":chosenPeriodID") { chosenPeriod in
            chosenPeriod.delete(use: self.delete)
        }
    }

    @Sendable func index(req: Request) async throws -> [ChosenPeriod] {
        return try await ChosenPeriod.query(on: req.db).all()
    }

    @Sendable func create(req: Request) async throws -> ChosenPeriod {
        let chosenPeriod = try req.content.decode(ChosenPeriod.self)

        try await chosenPeriod.save(on: req.db)
        return chosenPeriod
    }

    @Sendable func delete(req: Request) async throws -> HTTPStatus {
        guard let chosenPeriod = try await ChosenPeriod.find(req.parameters.get("chosenPeriodID"), on: req.db) else {
            throw Abort(.notFound)
        }

        try await chosenPeriod.delete(on: req.db)
        return .noContent
    }
}
