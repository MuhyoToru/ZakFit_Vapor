//
//  ActivityTypeModel.swift
//  ZakFit_Vapor
//
//  Created by Apprenant 141 on 05/12/2024.
//

import Vapor
import Fluent

final class Notification: Model, Content, @unchecked Sendable {
    static let schema = "notifications"
    
    @ID(key: .id)
    var id: UUID?

    @Field(key: "message")
    var message: String
    
    @Field(key: "id_notification_type")
    var idNotificationType: UUID
    
    init() { }

    init(id: UUID? = nil, message: String, idNotificationType: UUID) {
        self.id = id ?? UUID()
        self.message = message
        self.idNotificationType = idNotificationType
    }
}
