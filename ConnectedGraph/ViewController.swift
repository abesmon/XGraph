//
//  ViewController.swift
//  ConnectedGraph
//
//  Created by Алексей Лысенко on 10.02.18.
//  Copyright © 2018 Alexey Lysenko. All rights reserved.
//

import UIKit

extension Int: Vertex {
    var id: String { return String(hashValue) }
}

private func mockGraph() -> ConnectedGraph {
    let graph = ConnectedGraph()

    let a = 1
    let b = 2
    let c = 3
    let d = 4
    let e = 5
    
    graph.add(vertex: a)
    graph.add(vertex: b)
    graph.add(vertex: c)
    graph.add(vertex: d)
    graph.add(vertex: e)
    
    graph.join(first: a.id, second: b.id)
    graph.join(first: a.id, second: c.id)
    graph.join(first: a.id, second: d.id)
    
    graph.join(first: c.id, second: b.id)
    
    graph.join(first: b.id, second: e.id)
    graph.join(first: d.id, second: e.id)
    
    return graph
}

class ViewController: UIViewController {
    @IBOutlet private var cg2DView: CG2DView!

    override func viewDidLoad() {
        super.viewDidLoad()
        
        cg2DView.graph = mockGraph()
        // Do any additional setup after loading the view, typically from a nib.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }


}

