//
//  FlickrRequestCommand.swift
//  ImageFlickrSearch
//
//  Created by Iuliia.Grasevych on 8/27/18.
//  Copyright © 2018 JuliaG. All rights reserved.
//

import Foundation
import RxSwift

protocol FlickrRequestCommand {
    associatedtype ResultType
    
    var operation: Operation? { get set }
    var isExecuting: Bool { get }
    
    func start(completion: @escaping (ResultType?, FlickrError?) -> Void)
}

extension FlickrRequestCommand {
    func rx_request() -> Observable<ResultType?> {
        return Observable.create({ observer -> Disposable in
            self.start(completion: { (result, error) in
                if let error = error {
                    observer.onError(error)
                    return
                }
                observer.onNext(result)
                observer.onCompleted()
            })
            return Disposables.create {
                self.cancel()
            }
        })
    }
    
    var isExecuting: Bool {
        return operation?.isExecuting ?? false
    }
    func cancel() {
        if isExecuting {
            operation?.cancel()
        }
    }
}
