//
//  FilterQueryModel.swift
//  ZakFit_Vapor
//
//  Created by Apprenant 141 on 16/12/2024.
//

import Foundation
import Vapor

struct FilterQuery: Content {
    var search : String?
    var date : String?
}
