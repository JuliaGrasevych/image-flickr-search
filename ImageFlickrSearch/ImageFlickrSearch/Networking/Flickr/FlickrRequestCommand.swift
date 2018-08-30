//
//  FlickrRequestCommand.swift
//  ImageFlickrSearch
//
//  Created by Iuliia.Grasevych on 8/27/18.
//  Copyright © 2018 JuliaG. All rights reserved.
//

import Foundation

protocol FlickrRequestCommand {
    associatedtype Handler
    
    var operation: Operation? { get set }
    var isExecuting: Bool { get }
    
    func start(completion: Handler)
    func cancel()
}

extension FlickrRequestCommand {
    func cancel() {
        operation?.cancel()
    }
    var isExecuting: Bool {
        return operation?.isExecuting ?? false
    }
}
