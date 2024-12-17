//
//  AlimentController.swift
//  ZakFit_Vapor
//
//  Created by Apprenant 141 on 05/12/2024.
//

import Fluent
import Vapor

struct MealController: RouteCollection {
    func boot(routes: Vapor.RoutesBuilder) throws {
        let meals = routes.grouped("meals")
        
        let authGroupToken = meals.grouped(TokenSession.authenticator(), TokenSession.guardMiddleware())
        
        authGroupToken.get(use: self.getByUserId)
        authGroupToken.post("create", use: self.create)
        authGroupToken.post("update", use: self.update)
    }

    @Sendable func index(req: Request) async throws -> [Meal] {
        return try await Meal.query(on: req.db).all()
    }

    @Sendable func create(req: Request) async throws -> Meal {
        let meal = try req.content.decode(Meal.self)

        try await meal.save(on: req.db)
        return meal
    }

    @Sendable func delete(req: Request) async throws -> HTTPStatus {
        guard let meal = try await Meal.find(req.parameters.get("mealID"), on: req.db) else {
            throw Abort(.notFound)
        }

        try await meal.delete(on: req.db)
        return .noContent
    }
    
    @Sendable func getByUserId(req: Request) async throws -> [Meal] {
        let idUser = try await DecodeRequest().getIdFromJWT(req: req)
        
        let filterQuery : FilterQuery = try req.query.decode(FilterQuery.self)
        var meals = try await Meal.query(on: req.db).all().filter({$0.idUser == idUser})
        
        if filterQuery.date != nil {
            meals = searchByDate(meals, filterQuery.date!)
        }
        
        return meals
    }
    
    @Sendable func update(req: Request) async throws -> HTTPStatus {
        let updatedMeal = try req.content.decode(Meal.self)
        
        guard let meal = try await Meal.find(updatedMeal.id, on: req.db) else {
            throw Abort(.notFound)
        }
        
        meal.name = updatedMeal.name
        meal.date = updatedMeal.date
        meal.totalCalories = updatedMeal.totalCalories
        meal.totalProteins = updatedMeal.totalProteins
        meal.totalCarbohydrates = updatedMeal.totalCarbohydrates
        meal.totalLipids = updatedMeal.totalLipids
        meal.idMealType = updatedMeal.idMealType
        
        try await meal.save(on: req.db)
        return .ok
    }
    
    func searchByDate(_ meals : [Meal], _ date : String) -> [Meal] {
        var filteredMeals : [Meal] = []
        
        for meal in meals {
            if meal.date.ISO8601Format().split(separator: "T").first! == date {
                filteredMeals.append(meal)
            }
        }
        
        return filteredMeals
    }
}
