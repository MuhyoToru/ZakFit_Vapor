//
//  AlimentController.swift
//  ZakFit_Vapor
//
//  Created by Apprenant 141 on 05/12/2024.
//

import Fluent
import FluentSQL
import Vapor

struct MealController: RouteCollection {
    func boot(routes: Vapor.RoutesBuilder) throws {
        let meals = routes.grouped("meals")
        
        let authGroupToken = meals.grouped(TokenSession.authenticator(), TokenSession.guardMiddleware())
        
        authGroupToken.get(use: self.getByUserId)
        authGroupToken.post("create", use: self.create)
        authGroupToken.post("update", use: self.update)
        authGroupToken.get("delete", ":idMeal", use: self.delete)
    }

    @Sendable func index(req: Request) async throws -> [Meal] {
        return try await Meal.query(on: req.db).all()
    }

    @Sendable func create(req: Request) async throws -> HTTPStatus {
        let meal = try req.content.decode(Meal.self)

        try await meal.save(on: req.db)
        print("Meal Create")
        
        return .ok
    }

    @Sendable func delete(req: Request) async throws -> HTTPStatus {
        var alimentQuantitys : [AlimentQuantity] = []
        var aqMealLinks : [AQMealLink] = []
        
        
        guard let idMeal = req.parameters.get("idMeal") else {
            throw Abort(.notFound)
        }
        
        guard let meal = try await Meal.find(UUID(uuidString: idMeal), on: req.db) else {
            throw Abort(.notFound)
        }
        
        if let sql = req.db as? SQLDatabase {
            alimentQuantitys = try await sql.raw("""
                SELECT aliment_quantitys.* 
                FROM aliment_quantitys
                JOIN aq_meal_links ON aliment_quantitys.id = aq_meal_links.id_aliment_quantity
                JOIN meals ON aq_meal_links.id_meal = meals.id
                WHERE meals.id = UNHEX(REPLACE(\(bind: idMeal), '-', ''))
            """).all(decodingFluent: AlimentQuantity.self)
            
            aqMealLinks = try await sql.raw("""
                SELECT aq_meal_links.* 
                FROM aq_meal_links
                JOIN meals ON aq_meal_links.id_meal = meals.id
                WHERE meals.id = UNHEX(REPLACE(\(bind: idMeal), '-', ''))
            """).all(decodingFluent: AQMealLink.self)
        }
        
        for aqMealLink in aqMealLinks {
            try await aqMealLink.delete(on: req.db)
        }
        
        for alimentQuantity in alimentQuantitys {
            try await alimentQuantity.delete(on: req.db)
        }
        
        try await meal.delete(on: req.db)
        return .ok
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
