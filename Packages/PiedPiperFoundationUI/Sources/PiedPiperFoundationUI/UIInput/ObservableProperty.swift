//
//  ObservableProperty.swift
//
//
//  Created by Ruslan Lutfullin on 21/12/23.
//

protocol ObservableProperty {
    
    typealias WillChangeHandler = () -> Void
    
    var willChangeHandler: WillChangeHandler  { get set }
}
