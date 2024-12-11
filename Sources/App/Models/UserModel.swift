//
//  UserModel.swift
//  ZakFit_Vapor
//
//  Created by Apprenant 141 on 05/12/2024.
//

import Vapor
import Fluent

final class User: Model, @unchecked Sendable {
    static let schema = "users"
    
    @ID(key: .id)
    var id: UUID?

    @Field(key: "name")
    var name: String
    
    @Field(key: "firstname")
    var firstname: String
    
    @Field(key: "email")
    var email: String
    
    @Field(key: "password")
    var password: String
    
    @Field(key: "size")
    var size: Double
    
    @Field(key: "birthday")
    var birthday: Date
    
    @Field(key: "notification_time")
    var notificationTime: String
    
    @Field(key: "id_food_preference")
    var idFoodPreference: UUID
    
    @Field(key: "id_gender")
    var idGender: UUID

    init() { }

    init(id: UUID? = nil, name: String, firstname: String, email: String, password: String, size: Double, birthday: Date, notificationTime: String, idFoodPreference: UUID, idGender: UUID) {
        self.id = id ?? UUID()
        self.name = name
        self.firstname = firstname
        self.email = email
        self.password = password
        self.size = size
        self.birthday = birthday
        self.notificationTime = notificationTime
        self.idFoodPreference = idFoodPreference
        self.idGender = idGender
    }
    
    func toDTO() -> UserDTO {
        return UserDTO(id: self.id, name: self.name, firstname: self.firstname, email: self.email, size: self.size, birthday: self.birthday, notificationTime: self.notificationTime, idFoodPreference: self.idFoodPreference, idGender: self.idGender)
    }
}

extension User : ModelAuthenticatable {
    static let usernameKey = \User.$email
    static let passwordHashKey = \User.$password
    
    func verify(password: String) throws -> Bool {
        try Bcrypt.verify(password, created: self.password)
    }
}
