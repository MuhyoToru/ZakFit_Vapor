//
//  AlimentController.swift
//  ZakFit_Vapor
//
//  Created by Apprenant 141 on 05/12/2024.
//

import Fluent
import Vapor

struct NotificationTypeController: RouteCollection {
    func boot(routes: Vapor.RoutesBuilder) throws {
        let notificationTypes = routes.grouped("notificationTypes")

        let authGroupToken = notificationTypes.grouped(TokenSession.authenticator(), TokenSession.guardMiddleware())
        
        authGroupToken.get(use: self.index)
        authGroupToken.post(use: self.create)
        authGroupToken.group(":notificationsTypeID") { notificationType in
            notificationType.delete(use: self.delete)
        }
    }

    @Sendable func index(req: Request) async throws -> [NotificationType] {
        return try await NotificationType.query(on: req.db).all()
    }

    @Sendable func create(req: Request) async throws -> NotificationType {
        let notificationType = try req.content.decode(NotificationType.self)

        try await notificationType.save(on: req.db)
        return notificationType
    }

    @Sendable func delete(req: Request) async throws -> HTTPStatus {
        guard let notificationType = try await NotificationType.find(req.parameters.get("notificationTypeID"), on: req.db) else {
            throw Abort(.notFound)
        }

        try await notificationType.delete(on: req.db)
        return .noContent
    }
}
