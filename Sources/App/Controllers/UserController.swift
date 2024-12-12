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
        
        let authGroupBasic = users.grouped(User.authenticator(), User.guardMiddleware())
        authGroupBasic.get("login",use: login)
        
        let authGroupToken = users.grouped(TokenSession.authenticator(), TokenSession.guardMiddleware())
        authGroupToken.get("id", use: getById)
        authGroupToken.post("update", use: update)
    }
    
    @Sendable func create(req: Request) async throws -> HTTPStatus {
        let user = try req.content.decode(User.self)
        
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
    
    @Sendable func update(req: Request) async throws -> HTTPStatus {
        guard let user = try await User.find(DecodeRequest().getIdFromJWT(req: req), on: req.db) else {
            throw Abort(.notFound)
        }
        
        let updatedUser = try req.content.decode(UserDTO.self)
        
        user.name = updatedUser.name
        user.firstname = updatedUser.firstname
        user.email = updatedUser.email
        user.notificationTime = updatedUser.notificationTime
        user.birthday = updatedUser.birthday
        user.size = updatedUser.size
        user.idFoodPreference = updatedUser.idFoodPreference
        user.idGender = updatedUser.idGender
        
        try await user.save(on: req.db)
        return .ok
    }
}
