//
//  ConnectedGraph.swift
//  ConnectedGraph
//
//  Created by Алексей Лысенко on 11.02.18.
//  Copyright © 2018 Alexey Lysenko. All rights reserved.
//

import Foundation

typealias VertexId = String

protocol Vertex {
    var id: VertexId { get }
}

class ConnectedGraph {
    private(set) var vertexes: [Vertex] = []
    private(set) var edges: [(first: VertexId, second: VertexId)] = []
    
    func add(vertex: Vertex) {
        vertexes.append(vertex)
    }
    
    func join(first: VertexId, second: VertexId) {
        edges.append((first: first, second: second))
    }
    
}
