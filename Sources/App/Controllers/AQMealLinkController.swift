//
//  AlimentController.swift
//  ZakFit_Vapor
//
//  Created by Apprenant 141 on 05/12/2024.
//

import Fluent
import FluentSQL
import Vapor

struct AQMealLinkController: RouteCollection {
    func boot(routes: Vapor.RoutesBuilder) throws {
        let aqMealLinks = routes.grouped("aqMealLinks")
        
        let authGroupToken = aqMealLinks.grouped(TokenSession.authenticator(), TokenSession.guardMiddleware())

        authGroupToken.post("createAQCreateMeal", use: self.createAQCreateMeal)
        authGroupToken.post("createAQUpdateMeal", use: self.createAQUpdateMeal)
        authGroupToken.post("updateAQUpdateMeal", use: self.updateAQUpdateMeal)
        authGroupToken.post("onlyCreateAQ", use: self.onlyCreateAQ)
    }
    
    @Sendable func onlyCreateAQ(req: Request) async throws -> HTTPStatus {
        let mealAndAlimentQuantity = try req.content.decode(MealAndAlimentQuantity.self)
        
        let meal = mealAndAlimentQuantity.meal
        
        let alimentQuantity = mealAndAlimentQuantity.alimentQuantity

        try await alimentQuantity.save(on: req.db)
        print("AlimentQuantity Create")
        
        let aqMealLink = AQMealLink(idMeal: meal.id!, idAlimentQuantity: alimentQuantity.id!)
        
        try await aqMealLink.save(on: req.db)
        print("AQMealLink Create")
        
        return .ok
    }
    
    @Sendable func createAQCreateMeal(req: Request) async throws -> HTTPStatus {
        let mealAndAlimentQuantity = try req.content.decode(MealAndAlimentQuantity.self)
        
        let meal = mealAndAlimentQuantity.meal
        
        try await meal.save(on: req.db)
        print("Meal Create")
        
        let alimentQuantity = mealAndAlimentQuantity.alimentQuantity

        try await alimentQuantity.save(on: req.db)
        print("AlimentQuantity Create")
        
        let aqMealLink = AQMealLink(idMeal: meal.id!, idAlimentQuantity: alimentQuantity.id!)
        
        try await aqMealLink.save(on: req.db)
        print("AQMealLink Create")
        
        return .ok
    }
    
    @Sendable func createAQUpdateMeal(req: Request) async throws -> HTTPStatus {
        let mealAndAlimentQuantity = try req.content.decode(MealAndAlimentQuantity.self)
        
        let updatedMeal = mealAndAlimentQuantity.meal
        
        guard let meal = try await Meal.find(updatedMeal.id, on: req.db) else {
            throw Abort(.notFound)
        }
        
        meal.name = updatedMeal.name
        meal.date = updatedMeal.date
        meal.image = updatedMeal.image
        meal.totalCalories = updatedMeal.totalCalories
        meal.totalProteins = updatedMeal.totalProteins
        meal.totalCarbohydrates = updatedMeal.totalCarbohydrates
        meal.totalLipids = updatedMeal.totalLipids
        meal.idUser = updatedMeal.idUser
        meal.idMealType = updatedMeal.idMealType
        
        try await meal.save(on: req.db)
        print("Meal Update")
        
        let alimentQuantity = mealAndAlimentQuantity.alimentQuantity
        
        try await alimentQuantity.save(on: req.db)
        print("AlimentQuantity Create")
        
        let aqMealLink = AQMealLink(idMeal: meal.id!, idAlimentQuantity: alimentQuantity.id!)
        
        try await aqMealLink.save(on: req.db)
        print("AQMealLink Create")
        
        return .ok
    }
    
    @Sendable func updateAQUpdateMeal(req: Request) async throws -> HTTPStatus {
        let mealAndAlimentQuantity = try req.content.decode(MealAndAlimentQuantity.self)
        
        let updatedMeal = mealAndAlimentQuantity.meal
        
        guard let meal = try await Meal.find(updatedMeal.id, on: req.db) else {
            throw Abort(.notFound)
        }
        
        meal.name = updatedMeal.name
        meal.date = updatedMeal.date
        meal.image = updatedMeal.image
        meal.totalCalories = updatedMeal.totalCalories
        meal.totalProteins = updatedMeal.totalProteins
        meal.totalCarbohydrates = updatedMeal.totalCarbohydrates
        meal.totalLipids = updatedMeal.totalLipids
        meal.idUser = updatedMeal.idUser
        meal.idMealType = updatedMeal.idMealType
        
        try await meal.save(on: req.db)
        print("Meal Update")
        
        let updatedAlimentQuantity = mealAndAlimentQuantity.alimentQuantity
        
        guard let alimentQuantity = try await AlimentQuantity.find(updatedAlimentQuantity.id, on: req.db) else {
            throw Abort(.notFound)
        }
        
        alimentQuantity.quantity = updatedAlimentQuantity.quantity
        alimentQuantity.weightOrUnit = updatedAlimentQuantity.weightOrUnit
        print(alimentQuantity.idAliment)
        print(updatedAlimentQuantity.idAliment)
        alimentQuantity.idAliment = updatedAlimentQuantity.idAliment
        
        try await alimentQuantity.save(on: req.db)
        print("AlimentQuantity Update")
        
        return .ok
    }
}
