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
    
    func start(completion: Handler)
}
