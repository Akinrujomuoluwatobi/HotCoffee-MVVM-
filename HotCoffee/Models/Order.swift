//
//  Order.swift
//  HotCoffee
//
//  Created by MAC on 05/04/2021.
//

import Foundation

enum CoffeeType: String, Codable, CaseIterable {
    case cappucino
    case latte
    case espressino
    case cortado
}

enum CoffeeSize: String, Codable, CaseIterable {
    case small
    case medium
    case large
}

struct Order: Codable {
    let name: String
    let email: String
    let type: CoffeeType
    let size: CoffeeSize
}

extension Order {
    
    static var all: Resource<[Order]> = {
        guard let url = URL(string: "https://guarded-retreat-82533.herokuapp.com/orders") else { fatalError("Url not valid")
            
        }
        
        return Resource<[Order]>(url: url)
    
    }()
    
    static func create(_ vm: AddCoffeeOrderViewModel) -> Resource<Order?>{
        let order = Order(vm)
        
        guard let url = URL(string: "https://guarded-retreat-82533.herokuapp.com/orders") else { fatalError("Invalid url provided") }
        
        guard let data = try? JSONEncoder().encode(order) else { fatalError("Error encoding order") }
        
        var resource = Resource<Order?>(url: url)
        resource.httpMethod = HttpMethods.post
        resource.body = data
        
        return resource
    }
}

extension Order {
    init?(_ vm: AddCoffeeOrderViewModel) {
        guard let name = vm.name, let email = vm.email, let selectedSize = CoffeeSize(rawValue: vm.selectedSize!.lowercased()), let selectedType = CoffeeType(rawValue: vm.selectedType!.lowercased())  else { return nil }
        
        self.name = name
        self.email = email
        self.size = selectedSize
        self.type = selectedType
    }
}
