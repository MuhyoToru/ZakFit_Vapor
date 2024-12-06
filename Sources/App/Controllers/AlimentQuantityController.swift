//
//  AlimentController.swift
//  ZakFit_Vapor
//
//  Created by Apprenant 141 on 05/12/2024.
//

import Fluent
import Vapor

struct AlimentQuantityController: RouteCollection {
    func boot(routes: Vapor.RoutesBuilder) throws {
        let alimentQuantitys = routes.grouped("alimentQuantitys")

        alimentQuantitys.get(use: self.index)
        alimentQuantitys.post(use: self.create)
        alimentQuantitys.group(":alimentQuantityID") { alimentQuantity in
            alimentQuantity.delete(use: self.delete)
        }
    }

    @Sendable func index(req: Request) async throws -> [AlimentQuantity] {
        return try await AlimentQuantity.query(on: req.db).all()
    }

    @Sendable func create(req: Request) async throws -> AlimentQuantity {
        let alimentQuantity = try req.content.decode(AlimentQuantity.self)

        try await alimentQuantity.save(on: req.db)
        return alimentQuantity
    }

    @Sendable func delete(req: Request) async throws -> HTTPStatus {
        guard let alimentQuantity = try await AlimentQuantity.find(req.parameters.get("alimentQuantityID"), on: req.db) else {
            throw Abort(.notFound)
        }

        try await alimentQuantity.delete(on: req.db)
        return .noContent
    }
}
