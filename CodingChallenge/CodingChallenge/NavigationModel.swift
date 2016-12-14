//
//  NavigationModel.swift
//  CodingChallenge
//
//  Created by Reiner Pittinger on 14.12.16.
//  Copyright © 2016 clapp GmbH. All rights reserved.
//

import Foundation
import JSONUtilities

protocol Entry {
    var label: String { get }
    var children: [Entry] { get }
}

extension Entry {
    
    var sections: [Section] {
        return children.flatMap { $0 as? Section }
    }
    
    var nodes: [Node] {
        return children.flatMap { $0 as? Node }
    }
    
    var links: [Link] {
        return children.flatMap { $0 as? Link }
    }
}

class NavigationEntry : Entry, JSONObjectConvertible {
    let label: String
    let children: [Entry]
    
    init(label: String = "", children: [Entry] = []) {
        self.label = label
        self.children = children
    }
    
    required init(jsonDictionary: JSONDictionary) throws {
        self.label = jsonDictionary.json(atKeyPath: "label") ?? ""
        
        guard let rawChilds: [JSONDictionary] = jsonDictionary.json(atKeyPath: "children") else {
            self.children = []
            return
        }
        
        self.children = rawChilds.flatMap({ (jsonDict) -> NavigationEntry? in
            let type: String = jsonDict.json(atKeyPath: "type") ?? ""
            
            do {
                switch(type.lowercased()) {
                case "section":
                    return try Section(jsonDictionary: jsonDict)
                case "node":
                    return try Node(jsonDictionary: jsonDict)
                case "link":
                    return try Link(jsonDictionary: jsonDict)
                default:
                    return nil
                }
            } catch {
                return nil
            }
        })
    }
}

class Section: NavigationEntry {
    
}

class Node : NavigationEntry {
    
}

class Link : NavigationEntry {
    private(set) var url: URL? = nil
    
    required init(jsonDictionary: JSONDictionary) throws {
        try super.init(jsonDictionary: jsonDictionary)
        
        guard let urlString: String = jsonDictionary.json(atKeyPath: "url") else { return }
        
        self.url = URL(string: urlString)
    }
}
