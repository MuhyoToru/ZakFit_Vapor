//
//  AlimentController.swift
//  ZakFit_Vapor
//
//  Created by Apprenant 141 on 05/12/2024.
//

import Fluent
import Vapor

struct GenderController: RouteCollection {
    func boot(routes: Vapor.RoutesBuilder) throws {
        let genders = routes.grouped("genders")

        genders.get(use: self.index)
        genders.post(use: self.create)
        genders.group(":genderID") { gender in
            gender.delete(use: self.delete)
        }
    }

    @Sendable func index(req: Request) async throws -> [Gender] {
        print("Test")
        return try await Gender.query(on: req.db).all()
    }

    @Sendable func create(req: Request) async throws -> Gender {
        print("Test01")
        let gender = try req.content.decode(Gender.self)

        try await gender.save(on: req.db)
        return gender
    }

    @Sendable func delete(req: Request) async throws -> HTTPStatus {
        print("Test02")
        guard let gender = try await Gender.find(req.parameters.get("genderID"), on: req.db) else {
            throw Abort(.notFound)
        }

        try await gender.delete(on: req.db)
        return .noContent
    }
}
