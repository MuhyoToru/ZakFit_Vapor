//
//  AlimentController.swift
//  ZakFit_Vapor
//
//  Created by Apprenant 141 on 05/12/2024.
//

import Fluent
import Vapor

struct NotificationController: RouteCollection {
    func boot(routes: Vapor.RoutesBuilder) throws {
        let notifications = routes.grouped("notifications")

        notifications.get(use: self.index)
        notifications.post(use: self.create)
        notifications.group(":notificationsID") { notification in
            notification.delete(use: self.delete)
        }
    }

    @Sendable func index(req: Request) async throws -> [Notification] {
        return try await Notification.query(on: req.db).all()
    }

    @Sendable func create(req: Request) async throws -> Notification {
        let notification = try req.content.decode(Notification.self)

        try await notification.save(on: req.db)
        return notification
    }

    @Sendable func delete(req: Request) async throws -> HTTPStatus {
        guard let notification = try await Notification.find(req.parameters.get("notificationID"), on: req.db) else {
            throw Abort(.notFound)
        }

        try await notification.delete(on: req.db)
        return .noContent
    }
}
