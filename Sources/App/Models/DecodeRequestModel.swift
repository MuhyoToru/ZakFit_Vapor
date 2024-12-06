//
//  DecodeRequest.swift
//  ZakFit_Vapor
//
//  Created by Apprenant 141 on 05/12/2024.
//

import Vapor
import JWTDecode

struct DecodeRequest {
    func getIdFromJWT(req: Request) async throws -> UUID {
        var id : String = ""
        
        guard let token = req.headers.first(name : "Authorization")?.split(separator: " ").last else {
            throw Abort(.notFound, reason: "JWT Not Found")
        }
        
        let decodedJWT = try decode(jwt: String(token))
        
        for i in decodedJWT.body {
            if i.key == "userId" {
                id = i.value as! String
            }
        }
        
        return UUID(uuidString: id)!
    }
}
