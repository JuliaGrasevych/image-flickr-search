//
//  HTTP.swift
//  ImageFlickrSearch
//
//  Created by Iuliia.Grasevych on 8/20/18.
//  Copyright © 2018 JuliaG. All rights reserved.
//

import Foundation
import RxSwift

protocol HTTP {
    func execute(request: Request) -> Observable<Data>
}
