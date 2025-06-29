//
//  Item.swift
//  DragonsGame
//
//  Created by Baytik  on 28/6/25.
//

import Foundation

protocol Item: AnyObject, CustomStringConvertible {
    var name: String { get }
    var isCollectible: Bool { get }
}
