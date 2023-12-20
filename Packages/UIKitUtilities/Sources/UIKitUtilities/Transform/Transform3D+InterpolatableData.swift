//
//  Transform3D+InterpolatableData.swift
//
//
//  Created by Ruslan Lutfullin on 13/04/23.
//

extension Transform3D: InterpolatableData {
    
    public func mixed(with other: Self, using factor: Double) -> Self {
        .init(components: components.mixed(with: other.components, using: factor))
    }
}
