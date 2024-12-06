//
//  AlimentController.swift
//  ZakFit_Vapor
//
//  Created by Apprenant 141 on 05/12/2024.
//

import Fluent
import Vapor

struct AlimentController: RouteCollection {
    func boot(routes: Vapor.RoutesBuilder) throws {
        let aliments = routes.grouped("aliments")

        aliments.get(use: self.index)
        aliments.post(use: self.create)
        aliments.group(":alimentID") { aliment in
            aliment.delete(use: self.delete)
        }
    }

    @Sendable func index(req: Request) async throws -> [Aliment] {
        return try await Aliment.query(on: req.db).all()
    }

    @Sendable func create(req: Request) async throws -> Aliment {
        let aliment = try req.content.decode(Aliment.self)

        try await aliment.save(on: req.db)
        return aliment
    }

    @Sendable func delete(req: Request) async throws -> HTTPStatus {
        guard let aliment = try await Aliment.find(req.parameters.get("alimentID"), on: req.db) else {
            throw Abort(.notFound)
        }

        try await aliment.delete(on: req.db)
        return .noContent
    }
}
