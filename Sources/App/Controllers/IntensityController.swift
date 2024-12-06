//
//  AlimentController.swift
//  ZakFit_Vapor
//
//  Created by Apprenant 141 on 05/12/2024.
//

import Fluent
import Vapor

struct IntensityController: RouteCollection {
    func boot(routes: Vapor.RoutesBuilder) throws {
        let intensitys = routes.grouped("intensitys")

        intensitys.get(use: self.index)
        intensitys.post(use: self.create)
        intensitys.group(":intensityID") { intensity in
            intensity.delete(use: self.delete)
        }
    }

    @Sendable func index(req: Request) async throws -> [Intensity] {
        return try await Intensity.query(on: req.db).all()
    }

    @Sendable func create(req: Request) async throws -> Intensity {
        let intensity = try req.content.decode(Intensity.self)

        try await intensity.save(on: req.db)
        return intensity
    }

    @Sendable func delete(req: Request) async throws -> HTTPStatus {
        guard let intensity = try await Intensity.find(req.parameters.get("intensityID"), on: req.db) else {
            throw Abort(.notFound)
        }

        try await intensity.delete(on: req.db)
        return .noContent
    }
}
