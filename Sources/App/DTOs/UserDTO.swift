//
//  UserDTO.swift
//  ZakFit_Vapor
//
//  Created by Apprenant 141 on 05/12/2024.
//

import Fluent
import Vapor

struct UserDTO: Content {
    let id: UUID?
    let name: String
    let firstname: String
    let email: String
    let size: Double
    let birthday: Date
    let notificationTime: String
    let idFoodPreference: UUID
    let idGender: UUID
    
    func toModel() -> User {
        return User(id: id, name: name, firstname: firstname, email: email, password: "default", size: size, birthday: birthday, notificationTime: notificationTime, idFoodPreference: idFoodPreference, idGender: idGender)
    }
}
