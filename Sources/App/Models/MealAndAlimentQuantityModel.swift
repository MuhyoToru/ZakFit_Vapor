//
//  MealAndAlimentQuantity.swift
//  ZakFit_Vapor
//
//  Created by Apprenant 141 on 19/12/2024.
//

import Vapor
import Fluent

struct MealAndAlimentQuantity: Content {
    var meal: Meal
    var alimentQuantity: AlimentQuantity
}
