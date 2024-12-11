//
//  UserController.swift
//  ZakFit_Vapor
//
//  Created by Apprenant 141 on 05/12/2024.
//

import Fluent
import Vapor

struct UserController: RouteCollection {
    func boot(routes: Vapor.RoutesBuilder) throws {
        let users = routes.grouped("users")

        users.post(use: self.create)
        users.group(":userID") { user in
            user.delete(use: self.delete)
        }
        
        let authGroupBasic = users.grouped(User.authenticator(), User.guardMiddleware())
        authGroupBasic.get("login",use: login)
        
        let authGroupToken = users.grouped(TokenSession.authenticator(), TokenSession.guardMiddleware())
        authGroupToken.get(use: index)
        authGroupToken.get("id", use: getById)
    }

    @Sendable func index(req: Request) async throws -> [UserDTO] {
        return try await User.query(on: req.db).all().map { $0.toDTO() }
    }
    
    @Sendable func create(req: Request) async throws -> HTTPStatus {
        let user = try req.content.decode(User.self)
        
        print(user)
        
        user.password = try Bcrypt.hash(user.password)
        
        try await user.save(on: req.db)
        return .ok
    }

    @Sendable func delete(req: Request) async throws -> HTTPStatus {
        guard let user = try await User.find(req.parameters.get("userID"), on: req.db) else {
            throw Abort(.notFound)
        }

        try await user.delete(on: req.db)
        return .noContent
    }
    
    @Sendable func login(req: Request) async throws -> [String:String] {
        let user = try req.auth.require(User.self)
        let payload = try TokenSession(with: user)
        let token = try await req.jwt.sign(payload)
        return ["token": token]
    }
    
    @Sendable func getById(req: Request) async throws -> UserDTO {
        guard let user = try await User.find(DecodeRequest().getIdFromJWT(req: req), on: req.db) else {
            throw Abort(.notFound)
        }
        
        return user.toDTO()
    }
}
