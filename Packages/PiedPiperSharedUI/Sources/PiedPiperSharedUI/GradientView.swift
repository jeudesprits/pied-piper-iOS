//
//  GradientView.swift
//
//
//  Created by Ruslan Lutfullin on 16/10/23.
//

import SwiftUtilities
import UIKit
import UIKitUtilities
import FoundationUI
import Tor

public final class GradientView: LayerView<CAGradientLayer> {
    
    @StateObject
    private var state: State
    
    @ConfigurationObject
    public var configuration: Configuration?
    
    public override func layoutSubviews() {
        super.layoutSubviews()
        state.bounds = bounds
    }
    
    public override func setupCommon() {
        super.setupCommon()
        settedLayer.setValue(true, forKey: Tor.decode("IKzFNEMBIEBzy")) // premultiplied
        
        registerForTraitChanges([UITraitUserInterfaceStyle.self]) { (self: Self, previousTraitCollection: UITraitCollection) in
            self.state.userInterfaceStyle = self.traitCollection.userInterfaceStyle
        }
        
        registerForStateChanges(in: $state) { [unowned self] previousState in
            setNeedsUpdateConfigurations()
        }
        
        registerForConfigurationChanges(in: $configuration) { [unowned self] previousConfiguration in
            guard !bounds.isEmpty else { return }
            let styleProperties = configuration?.provideStylePropertiesWith(bounds: bounds, layoutDirection: effectiveUserInterfaceLayoutDirection) ?? .empty
            apply(styleProperties)
        }
    }
    
    public init(frame: CGRect, configuration: Configuration) {
        _state = .init(wrappedValue: State(bounds: CGRect(origin: .zero, size: frame.size), userInterfaceStyle: UITraitCollection.current.userInterfaceStyle))
        _configuration = .init(wrappedValue: configuration)
        super.init(frame: frame)
    }
}

extension GradientView {
    
    private func apply(_ styleProperties: StyleProperties) {
        settedLayer.setValue(styleProperties.colorSpace, forKey: Tor.decode("xHEHKnIvxz")) // colorSpace
        if var colors = styleProperties.colors, var locations = styleProperties.locations {
            convertColors(&colors, to: extendedSRGBCGColorSpace)
            smothingColors(&colors, at: &locations, with: extendedSRGBCGColorSpace, in: styleProperties.colorSpace)
            settedLayer.colors = colors
            settedLayer.locations = locations.map { $0 as NSNumber }
        } else {
            settedLayer.colors = nil
            settedLayer.locations = nil
        }
        settedLayer.startPoint = styleProperties.startPoint
        settedLayer.endPoint = styleProperties.endPoint
        settedLayer.type = styleProperties.type
    }
}

fileprivate func smothingColors(_ colors: inout [CGColor], at locations: inout [CGFloat], with colorSpace: CGColorSpace, in mixColorSpace: CGColorSpace) {
    assert(colors.count == locations.count)
    guard colors.count >= 2 else { return }
    
    var (oldColors, oldLocations) = (colors, locations)
    if colorSpace !== mixColorSpace {
        convertColors(&oldColors, to: mixColorSpace)
    }
    
    for index in colors.indices.dropLast() {
        let (fromColor, toColor) = (oldColors[index], oldColors[index + 1])
        let (fromComponents, toComponents) = (fromColor.components!, toColor.components!)
        let alpha = fromComponents[3].unclampedLinearInterpolate(to: toComponents[3], using: 0.5)
        var components: [CGFloat] = [
            (fromComponents[0] * fromComponents[3]).unclampedLinearInterpolate(to: toComponents[0] * toComponents[3], using: 0.5) / alpha,
            (fromComponents[1] * fromComponents[3]).unclampedLinearInterpolate(to: toComponents[1] * toComponents[3], using: 0.5) / alpha,
            (fromComponents[2] * fromComponents[3]).unclampedLinearInterpolate(to: toComponents[2] * toComponents[3], using: 0.5) / alpha,
            alpha,
        ]
        let color = CGColor(colorSpace: mixColorSpace, components: &components)!
        let newColor: CGColor = if colorSpace !== mixColorSpace {
            color.converted(to: colorSpace, intent: .defaultIntent, options: nil)!
        } else {
            color
        }
        
        let (fromLocation, toLocation) = (oldLocations[index], oldLocations[index + 1])
        let newLocation = fromLocation.unclampedLinearInterpolate(to: toLocation, using: 0.5)
        
        let insertIndex = index * 2 + 1
        colors.insert(newColor, at: insertIndex)
        locations.insert(newLocation, at: insertIndex)
    }
}

fileprivate func convertColors(_ colors: inout [CGColor], to colorSpace: CGColorSpace) {
    for index in colors.indices {
        let color = colors[index]
        if color.colorSpace?.name != colorSpace.name {
            guard let convertedColor = color.converted(to: colorSpace, intent: .defaultIntent, options: nil) else {
                preconditionFailure("Can't convert \(color) to the following \(colorSpace)")
            }
            colors[index] = convertedColor
        }
    }
}

extension GradientView {
    
    fileprivate struct StyleProperties {
        
        internal var type: CAGradientLayerType
        
        internal var startPoint: CGPoint
        
        internal var endPoint: CGPoint
        
        internal var locations: [CGFloat]?
        
        internal var colors: [CGColor]?
        
        internal var colorSpace: CGColorSpace
    }
}

extension GradientView.StyleProperties {
    
    internal static var empty: Self {
        .init(type: .axial, startPoint: CGPoint(x: 0.5, y: 0.0), endPoint: CGPoint(x: 0.5, y: 1.0), colorSpace: extendedLinearSRGBCGColorSpace)
    }
}

extension GradientView {
    
    fileprivate final class State: UIState {
        
        @Invalidating
        internal var bounds: CGRect
        
        @Invalidating
        internal var userInterfaceStyle: UIUserInterfaceStyle
        
        internal init(bounds: CGRect, userInterfaceStyle: UIUserInterfaceStyle) {
            _bounds = .init(wrappedValue: bounds)
            _userInterfaceStyle = .init(wrappedValue: userInterfaceStyle)
            super.init()
        }
        
        internal override func copy() -> Self {
            State(copy: self) as! Self
        }
        
        internal init(copy other: borrowing State) {
            _bounds = other._bounds
            _userInterfaceStyle = other._userInterfaceStyle
            super.init(copy: other)
        }
    }
}

extension GradientView {
    
    public class Configuration: UIConfiguration {
        
        fileprivate func provideStylePropertiesWith(bounds: CGRect, layoutDirection: UIUserInterfaceLayoutDirection) -> GradientView.StyleProperties? {
            _abstract()
        }
        
        @Invalidating
        public final var gradient: Gradient
        
        fileprivate init(gradient: Gradient) {
            _gradient = .init(wrappedValue: gradient)
            super.init()
        }
        
        public override func copy() -> Self {
            Configuration(copy: self) as! Self
        }
        
        public init(copy other: borrowing Configuration) {
            _gradient = other._gradient
            super.init(copy: other)
        }
    }
}

extension GradientView.Configuration {
    
    @_disfavoredOverload
    public static func linear(gradient: Gradient, startPoint: UIUnitPoint, endPoint: UIUnitPoint) -> GradientView.Configuration {
        GradientView.LinearConfiguration(gradient: gradient, startPoint: startPoint, endPoint: endPoint)
    }
    
    @_disfavoredOverload
    public static func linear(stops: [Gradient.Stop], startPoint: UIUnitPoint, endPoint: UIUnitPoint) -> GradientView.Configuration {
        GradientView.LinearConfiguration(gradient: Gradient(stops: stops), startPoint: startPoint, endPoint: endPoint)
    }
    
    @_disfavoredOverload
    public static func linear(colors: [UIColor], startPoint: UIUnitPoint, endPoint: UIUnitPoint) -> GradientView.Configuration {
        GradientView.LinearConfiguration(gradient: Gradient(colors: colors), startPoint: startPoint, endPoint: endPoint)
    }
    
    public static func linear(gradient: Gradient, directionalStartPoint: NSDirectionalUnitPoint, directionalEndPoint: NSDirectionalUnitPoint) -> GradientView.Configuration {
        GradientView.LinearConfiguration(gradient: gradient, directionalStartPoint: directionalStartPoint, directionalEndPoint: directionalEndPoint)
    }
    
    public static func linear(stops: [Gradient.Stop], directionalStartPoint: NSDirectionalUnitPoint, directionalEndPoint: NSDirectionalUnitPoint) -> GradientView.Configuration {
        GradientView.LinearConfiguration(gradient: Gradient(stops: stops), directionalStartPoint: directionalStartPoint, directionalEndPoint: directionalEndPoint)
    }
    
    public static func linear(colors: [UIColor], directionalStartPoint: NSDirectionalUnitPoint, directionalEndPoint: NSDirectionalUnitPoint) -> GradientView.Configuration {
        GradientView.LinearConfiguration(gradient: Gradient(colors: colors), directionalStartPoint: directionalStartPoint, directionalEndPoint: directionalEndPoint)
    }
}

extension GradientView.Configuration {
    
    @_disfavoredOverload
    public static func angular(gradient: Gradient, center: UIUnitPoint = .center, angle: UIAngle = .zero) -> GradientView.Configuration {
        angular(gradient: gradient, center: center, startAngle: angle, endAngle: copy angle)
    }
    
    @_disfavoredOverload
    public static func angular(stops: [Gradient.Stop], center: UIUnitPoint = .center, angle: UIAngle = .zero) -> GradientView.Configuration {
        angular(stops: stops, center: center, startAngle: angle, endAngle: copy angle)
    }
    
    @_disfavoredOverload
    public static func angular(colors: [UIColor], center: UIUnitPoint = .center, angle: UIAngle = .zero) -> GradientView.Configuration {
        angular(colors: colors, center: center, startAngle: angle, endAngle: copy angle)
    }
    
    public static func angular(gradient: Gradient, directionalCenter: NSDirectionalUnitPoint = .center, angle: UIAngle = .zero) -> GradientView.Configuration {
        angular(gradient: gradient, directionalCenter: directionalCenter, startAngle: angle, endAngle: copy angle)
    }
    
    public static func angular(stops: [Gradient.Stop], directionalCenter: NSDirectionalUnitPoint = .center, angle: UIAngle = .zero) -> GradientView.Configuration {
        angular(stops: stops, directionalCenter: directionalCenter, startAngle: angle, endAngle: copy angle)
    }
    
    public static func angular(colors: [UIColor], directionalCenter: NSDirectionalUnitPoint = .center, angle: UIAngle = .zero) -> GradientView.Configuration {
        angular(colors: colors, directionalCenter: directionalCenter, startAngle: angle, endAngle: copy angle)
    }
    
    @_disfavoredOverload
    public static func angular(gradient: Gradient, center: UIUnitPoint = .center, startAngle: UIAngle, endAngle: UIAngle) -> GradientView.Configuration {
        GradientView.AngularConfiguration(gradient: gradient, center: center, startAngle: startAngle, endAngle: endAngle)
    }
    
    @_disfavoredOverload
    public static func angular(stops: [Gradient.Stop], center: UIUnitPoint = .center, startAngle: UIAngle, endAngle: UIAngle) -> GradientView.Configuration {
        GradientView.AngularConfiguration(gradient: Gradient(stops: stops), center: center, startAngle: startAngle, endAngle: endAngle)
    }
    
    @_disfavoredOverload
    public static func angular(colors: [UIColor], center: UIUnitPoint = .center, startAngle: UIAngle, endAngle: UIAngle) -> GradientView.Configuration {
        GradientView.AngularConfiguration(gradient: Gradient(colors: colors), center: center, startAngle: startAngle, endAngle: endAngle)
    }
    
    public static func angular(gradient: Gradient, directionalCenter: NSDirectionalUnitPoint = .center, startAngle: UIAngle, endAngle: UIAngle) -> GradientView.Configuration {
        GradientView.AngularConfiguration(gradient: gradient, directionalCenter: directionalCenter, startAngle: startAngle, endAngle: endAngle)
    }
    
    public static func angular(stops: [Gradient.Stop], directionalCenter: NSDirectionalUnitPoint = .center, startAngle: UIAngle, endAngle: UIAngle) -> GradientView.Configuration {
        GradientView.AngularConfiguration(gradient: Gradient(stops: stops), directionalCenter: directionalCenter, startAngle: startAngle, endAngle: endAngle)
    }
    
    public static func angular(colors: [UIColor], directionalCenter: NSDirectionalUnitPoint = .center, startAngle: UIAngle, endAngle: UIAngle) -> GradientView.Configuration {
        GradientView.AngularConfiguration(gradient: Gradient(colors: colors), directionalCenter: directionalCenter, startAngle: startAngle, endAngle: endAngle)
    }
}

extension GradientView.Configuration {
    
    @_disfavoredOverload
    public static func conic(gradient: Gradient, center: UIUnitPoint = .center, angle: UIAngle = .zero) -> GradientView.Configuration {
        GradientView.ConicConfiguration(gradient: gradient, center: center, angle: angle)
    }
    
    @_disfavoredOverload
    public static func conic(stops: [Gradient.Stop], center: UIUnitPoint = .center, angle: UIAngle = .zero) -> GradientView.Configuration {
        GradientView.ConicConfiguration(gradient: Gradient(stops: stops), center: center, angle: angle)
    }
    
    @_disfavoredOverload
    public static func conic(colors: [UIColor], center: UIUnitPoint = .center, angle: UIAngle = .zero) -> GradientView.Configuration {
        GradientView.ConicConfiguration(gradient: Gradient(colors: colors), center: center, angle: angle)
    }
    
    public static func conic(gradient: Gradient, directionalCenter: NSDirectionalUnitPoint = .center, angle: UIAngle = .zero) -> GradientView.Configuration  {
        GradientView.ConicConfiguration(gradient: gradient, directionalCenter: directionalCenter, angle: angle)
    }
    
    public static func conic(stops: [Gradient.Stop], directionalCenter: NSDirectionalUnitPoint = .center, angle: UIAngle = .zero) -> GradientView.Configuration {
        GradientView.ConicConfiguration(gradient: Gradient(stops: stops), directionalCenter: directionalCenter, angle: angle)
    }
    
    public static func conic(colors: [UIColor], directionalCenter: NSDirectionalUnitPoint = .center, angle: UIAngle = .zero) -> GradientView.Configuration {
        GradientView.ConicConfiguration(gradient: Gradient(colors: colors), directionalCenter: directionalCenter, angle: angle)
    }
}

extension GradientView.Configuration {
    
    @_disfavoredOverload
    public static func elliptical(gradient: Gradient, center: UIUnitPoint = .center, startRadiusFraction: CGFloat = 0.0, endRadiusFraction: CGFloat = 0.5) -> GradientView.Configuration {
        GradientView.EllipticalConfiguration(gradient: gradient, center: center, startRadiusFraction: startRadiusFraction, endRadiusFraction: endRadiusFraction)
    }
    
    @_disfavoredOverload
    public static func elliptical(stops: [Gradient.Stop], center: UIUnitPoint = .center, startRadiusFraction: CGFloat = 0.0, endRadiusFraction: CGFloat = 0.5) -> GradientView.Configuration {
        GradientView.EllipticalConfiguration(gradient: Gradient(stops: stops), center: center, startRadiusFraction: startRadiusFraction, endRadiusFraction: endRadiusFraction)
    }
    
    @_disfavoredOverload
    public static func elliptical(colors: [UIColor], center: UIUnitPoint = .center, startRadiusFraction: CGFloat = 0.0, endRadiusFraction: CGFloat = 0.5) -> GradientView.Configuration {
        GradientView.EllipticalConfiguration(gradient: Gradient(colors: colors), center: center, startRadiusFraction: startRadiusFraction, endRadiusFraction: endRadiusFraction)
    }
    
    public static func elliptical(gradient: Gradient, directionalCenter: NSDirectionalUnitPoint = .center, startRadiusFraction: CGFloat = 0.0, endRadiusFraction: CGFloat = 0.5) -> GradientView.Configuration {
        GradientView.EllipticalConfiguration(gradient: gradient, directionalCenter: directionalCenter, startRadiusFraction: startRadiusFraction, endRadiusFraction: endRadiusFraction)
    }
    
    public static func elliptical(stops: [Gradient.Stop], directionalCenter: NSDirectionalUnitPoint = .center, startRadiusFraction: CGFloat = 0.0, endRadiusFraction: CGFloat = 0.5) -> GradientView.Configuration {
        GradientView.EllipticalConfiguration(gradient: Gradient(stops: stops), directionalCenter: directionalCenter, startRadiusFraction: startRadiusFraction, endRadiusFraction: endRadiusFraction)
    }
    
    public static func elliptical(colors: [UIColor], directionalCenter: NSDirectionalUnitPoint = .center, startRadiusFraction: CGFloat = 0.0, endRadiusFraction: CGFloat = 0.5) -> GradientView.Configuration {
        GradientView.EllipticalConfiguration(gradient: Gradient(colors: colors), directionalCenter: directionalCenter, startRadiusFraction: startRadiusFraction, endRadiusFraction: endRadiusFraction)
    }
}

extension GradientView.Configuration {
    
    @_disfavoredOverload
    public static func radial(gradient: Gradient, center: UIUnitPoint = .center, startRadiusFraction: CGFloat = 0.0, endRadiusFraction: CGFloat = 0.5) -> GradientView.Configuration {
        GradientView.RadialConfiguration(gradient: gradient, center: center, startRadiusFraction: startRadiusFraction, endRadiusFraction: endRadiusFraction)
    }
    
    @_disfavoredOverload
    public static func radial(stops: [Gradient.Stop], center: UIUnitPoint = .center, startRadiusFraction: CGFloat = 0.0, endRadiusFraction: CGFloat = 0.5) -> GradientView.Configuration {
        GradientView.RadialConfiguration(gradient: Gradient(stops: stops), center: center, startRadiusFraction: startRadiusFraction, endRadiusFraction: endRadiusFraction)
    }
    
    @_disfavoredOverload
    public static func radial(colors: [UIColor], center: UIUnitPoint = .center, startRadiusFraction: CGFloat = 0.0, endRadiusFraction: CGFloat = 0.5) -> GradientView.Configuration {
        GradientView.RadialConfiguration(gradient: Gradient(colors: colors), center: center, startRadiusFraction: startRadiusFraction, endRadiusFraction: endRadiusFraction)
    }
    
    public static func radial(gradient: Gradient, directionalCenter: NSDirectionalUnitPoint = .center, startRadiusFraction: CGFloat = 0.0, endRadiusFraction: CGFloat = 0.5) -> GradientView.Configuration {
        GradientView.RadialConfiguration(gradient: gradient, directionalCenter: directionalCenter, startRadiusFraction: startRadiusFraction, endRadiusFraction: endRadiusFraction)
    }
    
    public static func radial(stops: [Gradient.Stop], directionalCenter: NSDirectionalUnitPoint = .center, startRadiusFraction: CGFloat = 0.0, endRadiusFraction: CGFloat = 0.5) -> GradientView.Configuration {
        GradientView.RadialConfiguration(gradient: Gradient(stops: stops), directionalCenter: directionalCenter, startRadiusFraction: startRadiusFraction, endRadiusFraction: endRadiusFraction)
    }
    
    public static func radial(colors: [UIColor], directionalCenter: NSDirectionalUnitPoint = .center, startRadiusFraction: CGFloat = 0.0, endRadiusFraction: CGFloat = 0.5) -> GradientView.Configuration {
        GradientView.RadialConfiguration(gradient: Gradient(colors: colors), directionalCenter: directionalCenter, startRadiusFraction: startRadiusFraction, endRadiusFraction: endRadiusFraction)
    }
}

extension GradientView {
    
    fileprivate final class LinearConfiguration: Configuration {
        
        internal override func provideStylePropertiesWith(bounds _: CGRect, layoutDirection: UIUserInterfaceLayoutDirection) -> GradientView.StyleProperties? {
            let locations: [CGFloat] = gradient.stops.map { $0.location }
            let colors: [CGColor] = gradient.stops.map { $0.color.cgColor }
            let colorSpace = gradient.colorSpace.cgColorSpace
            if let directionalStartPoint, let directionalEndPoint {
                return StyleProperties(
                    type: .axial,
                    startPoint: CGPoint(x: layoutDirection == .rightToLeft ? 1.0 - directionalStartPoint.x : directionalStartPoint.x, y: directionalStartPoint.y),
                    endPoint: CGPoint(x: layoutDirection == .rightToLeft ? 1.0 - directionalEndPoint.x : directionalEndPoint.x, y: directionalEndPoint.y),
                    locations: locations,
                    colors: colors,
                    colorSpace: colorSpace
                )
            } else if let startPoint, let endPoint {
                return StyleProperties(
                    type: .axial,
                    startPoint: CGPoint(x: startPoint.x, y: startPoint.y),
                    endPoint: CGPoint(x: endPoint.x, y: endPoint.y),
                    locations: locations,
                    colors: colors,
                    colorSpace: colorSpace
                )
            } else {
                return nil
            }
        }
        
        @Invalidating
        internal var startPoint: UIUnitPoint?
        
        @Invalidating
        internal var directionalStartPoint: NSDirectionalUnitPoint?
        
        @Invalidating
        internal var endPoint: UIUnitPoint?
        
        @Invalidating
        internal var directionalEndPoint: NSDirectionalUnitPoint?
        
        internal init(gradient: Gradient, startPoint: UIUnitPoint, endPoint: UIUnitPoint) {
            _startPoint = .init(wrappedValue: startPoint)
            _directionalStartPoint = .init(wrappedValue: nil)
            _endPoint = .init(wrappedValue: endPoint)
            _directionalEndPoint = .init(wrappedValue: nil)
            super.init(gradient: gradient)
        }
        
        internal init(gradient: Gradient, directionalStartPoint: NSDirectionalUnitPoint, directionalEndPoint: NSDirectionalUnitPoint) {
            _startPoint = .init(wrappedValue: nil)
            _directionalStartPoint = .init(wrappedValue: directionalStartPoint)
            _endPoint = .init(wrappedValue: nil)
            _directionalEndPoint = .init(wrappedValue: directionalEndPoint)
            super.init(gradient: gradient)
        }
        
        internal override func copy() -> Self {
            LinearConfiguration(copy: self) as! Self
        }
        
        internal init(copy other: borrowing LinearConfiguration) {
            _startPoint = other._startPoint
            _directionalStartPoint = other._directionalStartPoint
            _endPoint = other._endPoint
            _directionalEndPoint = other._directionalEndPoint
            super.init(copy: other)
        }
    }
}

extension GradientView {
    
    fileprivate final class AngularConfiguration: Configuration {
        
        internal override func provideStylePropertiesWith(bounds _: CGRect, layoutDirection: UIUserInterfaceLayoutDirection) -> GradientView.StyleProperties? {
            let endPoint: CGPoint
            let locations: [CGFloat]
            switch abs(endAngle.radians - startAngle.radians) {
            case let radians where radians < 2.0 * .pi:
                let distanceAngle = if startAngle.radians < endAngle.radians {
                    UIAngle(radians: endAngle.radians - startAngle.radians)
                } else {
                    UIAngle(radians: 2.0 * .pi + (endAngle.radians - startAngle.radians))
                }
                let shiftAngle = UIAngle(radians: (2.0 * .pi - distanceAngle.radians) / 2.0)
                let shiftedStartAngle = UIAngle(radians: startAngle.radians - shiftAngle.radians)
                let endPoint_ = UIUnitPoint(angle: shiftedStartAngle)
                endPoint = CGPoint(x: endPoint_.x, y: endPoint_.y)
                
                let shiftValue = shiftAngle.radians / (2.0 * .pi)
                locations = gradient.stops.map { $0.location * (1.0 - 2.0 * shiftValue) + shiftValue }
                
            case let radians where radians >= 2.0 * .pi:
                let distanceAngle = UIAngle(radians: radians)
                let shiftedStartAngle = UIAngle(radians: distanceAngle.radians.remainder(dividingBy: 2.0 * .pi))
                let endPoint_ = UIUnitPoint(angle: shiftedStartAngle)
                endPoint = CGPoint(x: endPoint_.x, y: endPoint_.y)
                
                let shiftValue = distanceAngle.radians / (2.0 * .pi)
                locations = gradient.stops.map { $0.location * shiftValue - (shiftValue - 1.0) }
                
            default:
                preconditionFailure()
            }
            
            let colors: [CGColor] = gradient.stops.map { $0.color.cgColor }
            let colorSpace = gradient.colorSpace.cgColorSpace
            if let directionalCenter {
                return StyleProperties(
                    type: .conic,
                    startPoint: CGPoint(x: layoutDirection == .rightToLeft ? 1.0 - directionalCenter.x : directionalCenter.x, y: directionalCenter.y),
                    endPoint: endPoint,
                    locations: locations,
                    colors: colors,
                    colorSpace: colorSpace
                )
            } else if let center {
                return StyleProperties(
                    type: .conic,
                    startPoint: CGPoint(x: center.x, y: center.y),
                    endPoint: endPoint,
                    locations: locations,
                    colors: colors,
                    colorSpace: colorSpace
                )
            } else {
                return nil
            }
        }
        
        @Invalidating
        internal var center: UIUnitPoint?
        
        @Invalidating
        internal var directionalCenter: NSDirectionalUnitPoint?
        
        @Invalidating
        internal var startAngle: UIAngle
        
        @Invalidating
        internal var endAngle: UIAngle
        
        internal init(gradient: Gradient, center: UIUnitPoint, startAngle: UIAngle, endAngle: UIAngle) {
            _center = .init(wrappedValue: center)
            _directionalCenter = .init(wrappedValue: nil)
            _startAngle = .init(wrappedValue: startAngle)
            _endAngle = .init(wrappedValue: endAngle)
            super.init(gradient: gradient)
        }
        
        internal init(gradient: Gradient, directionalCenter: NSDirectionalUnitPoint, startAngle: UIAngle, endAngle: UIAngle) {
            _center = .init(wrappedValue: nil)
            _directionalCenter = .init(wrappedValue: directionalCenter)
            _startAngle = .init(wrappedValue: startAngle)
            _endAngle = .init(wrappedValue: endAngle)
            super.init(gradient: gradient)
        }
        
        internal override func copy() -> Self {
            AngularConfiguration(copy: self) as! Self
        }
        
        internal init(copy other: borrowing AngularConfiguration) {
            _center = other._center
            _directionalCenter = other._directionalCenter
            _startAngle = other._startAngle
            _endAngle = other._endAngle
            super.init(copy: other)
        }
    }
}

extension GradientView {
    
    fileprivate final class ConicConfiguration: Configuration {
        
        internal override func provideStylePropertiesWith(bounds _: CGRect, layoutDirection: UIUserInterfaceLayoutDirection) -> GradientView.StyleProperties? {
            let endPoint_ = UIUnitPoint(angle: angle)
            let endPoint = CGPoint(x: endPoint_.x, y: endPoint_.y)
            let locations: [CGFloat] = gradient.stops.map { $0.location }
            let colors: [CGColor] = gradient.stops.map { $0.color.cgColor }
            let colorSpace = gradient.colorSpace.cgColorSpace
            if let directionalCenter {
                return StyleProperties(
                    type: .conic,
                    startPoint: CGPoint(x: layoutDirection == .rightToLeft ? 1.0 - directionalCenter.x : directionalCenter.x, y: directionalCenter.y),
                    endPoint: endPoint,
                    locations: locations,
                    colors: colors,
                    colorSpace: colorSpace
                )
            } else if let center {
                return StyleProperties(
                    type: .conic,
                    startPoint: CGPoint(x: center.x, y: center.y),
                    endPoint: endPoint,
                    locations: locations,
                    colors: colors,
                    colorSpace: colorSpace
                )
            } else {
                return nil
            }
        }
        
        @Invalidating
        internal var center: UIUnitPoint?
        
        @Invalidating
        internal var directionalCenter: NSDirectionalUnitPoint?
        
        @Invalidating
        internal var angle: UIAngle
        
        internal init(gradient: Gradient, center: UIUnitPoint, angle: UIAngle) {
            _center = .init(wrappedValue: center)
            _directionalCenter = .init(wrappedValue: nil)
            _angle = .init(wrappedValue: angle)
            super.init(gradient: gradient)
        }
        
        internal init(gradient: Gradient, directionalCenter: NSDirectionalUnitPoint, angle: UIAngle) {
            _center = .init(wrappedValue: nil)
            _directionalCenter = .init(wrappedValue: directionalCenter)
            _angle = .init(wrappedValue: angle)
            super.init(gradient: gradient)
        }
        
        internal override func copy() -> Self {
            ConicConfiguration(copy: self) as! Self
        }
        
        internal init(copy other: borrowing ConicConfiguration) {
            _center = other._center
            _directionalCenter = other._directionalCenter
            _angle = other._angle
            super.init(copy: other)
        }
    }
}

extension GradientView {
    
    fileprivate final class EllipticalConfiguration: Configuration {
        
        internal override func provideStylePropertiesWith(bounds: CGRect, layoutDirection: UIUserInterfaceLayoutDirection) -> GradientView.StyleProperties? {
            let radius: (x: CGFloat, y: CGFloat) = (bounds.width * endRadiusFraction, bounds.height * endRadiusFraction)
            let locations: [CGFloat] = gradient.stops.map { $0.location * (1.0 - startRadiusFraction) + startRadiusFraction }
            let colors: [CGColor] = gradient.stops.map { $0.color.cgColor }
            let colorSpace = gradient.colorSpace.cgColorSpace
            if let directionalCenter {
                let startPoint = CGPoint(x: layoutDirection == .rightToLeft ? 1.0 - directionalCenter.x : directionalCenter.x, y: directionalCenter.y)
                return StyleProperties(
                    type: .radial,
                    startPoint: startPoint,
                    endPoint: CGPoint(x: startPoint.x - radius.x / bounds.width, y: startPoint.y - radius.y / bounds.height),
                    locations: locations,
                    colors: colors,
                    colorSpace: colorSpace
                )
            } else if let center {
                let startPoint = CGPoint(x: center.x, y: center.y)
                return StyleProperties(
                    type: .radial,
                    startPoint: startPoint,
                    endPoint: CGPoint(x: startPoint.x - radius.x / bounds.width, y: startPoint.y - radius.y / bounds.height),
                    locations: locations,
                    colors: colors,
                    colorSpace: colorSpace
                )
            } else {
                return nil
            }
        }
        
        @Invalidating
        internal var center: UIUnitPoint?
        
        @Invalidating
        internal var directionalCenter: NSDirectionalUnitPoint?
        
        @Invalidating
        internal var startRadiusFraction: CGFloat
        
        @Invalidating
        internal var endRadiusFraction: CGFloat
        
        internal init(gradient: Gradient, center: UIUnitPoint, startRadiusFraction: CGFloat, endRadiusFraction: CGFloat) {
            _center = .init(wrappedValue: center)
            _directionalCenter = .init(wrappedValue: nil)
            _startRadiusFraction = .init(wrappedValue: startRadiusFraction)
            _endRadiusFraction = .init(wrappedValue: endRadiusFraction)
            super.init(gradient: gradient)
        }
        
        internal init(gradient: Gradient, directionalCenter: NSDirectionalUnitPoint, startRadiusFraction: CGFloat, endRadiusFraction: CGFloat) {
            _center = .init(wrappedValue: nil)
            _directionalCenter = .init(wrappedValue: directionalCenter)
            _startRadiusFraction = .init(wrappedValue: startRadiusFraction)
            _endRadiusFraction = .init(wrappedValue: endRadiusFraction)
            super.init(gradient: gradient)
        }
        
        internal override func copy() -> Self {
            EllipticalConfiguration(copy: self) as! Self
        }
        
        internal init(copy other: borrowing EllipticalConfiguration) {
            _center = other._center
            _directionalCenter = other._directionalCenter
            _startRadiusFraction = other._startRadiusFraction
            _endRadiusFraction = other._endRadiusFraction
            super.init(copy: other)
        }
    }
}

extension GradientView {
    
    fileprivate final class RadialConfiguration: Configuration {
        
        internal override func provideStylePropertiesWith(bounds: CGRect, layoutDirection: UIUserInterfaceLayoutDirection) -> GradientView.StyleProperties? {
            let radius = min(bounds.width, bounds.height) * endRadiusFraction
            let locations: [CGFloat] = gradient.stops.map { $0.location * (1.0 - startRadiusFraction) + startRadiusFraction }
            let colors: [CGColor] = gradient.stops.map { $0.color.cgColor }
            let colorSpace = gradient.colorSpace.cgColorSpace
            if let directionalCenter {
                let startPoint = CGPoint(x: layoutDirection == .rightToLeft ? 1.0 - directionalCenter.x : directionalCenter.x, y: directionalCenter.y)
                return StyleProperties(
                    type: .radial,
                    startPoint: startPoint,
                    endPoint: CGPoint(x: startPoint.x - radius / bounds.width , y: startPoint.y - radius / bounds.height),
                    locations: locations,
                    colors: colors,
                    colorSpace: colorSpace
                )
            } else if let center {
                let startPoint = CGPoint(x: center.x, y: center.y)
                return StyleProperties(
                    type: .radial,
                    startPoint: startPoint,
                    endPoint: CGPoint(x: startPoint.x - radius / bounds.width , y: startPoint.y - radius / bounds.height),
                    locations: locations,
                    colors: colors,
                    colorSpace: colorSpace
                )
            } else {
                return nil
            }
        }
        
        @Invalidating
        internal var center: UIUnitPoint?
        
        @Invalidating
        internal var directionalCenter: NSDirectionalUnitPoint?
        
        @Invalidating
        internal var startRadiusFraction: CGFloat
        
        @Invalidating
        internal var endRadiusFraction: CGFloat
        
        internal init(gradient: Gradient, center: UIUnitPoint, startRadiusFraction: CGFloat, endRadiusFraction: CGFloat) {
            _center = .init(wrappedValue: center)
            _directionalCenter = .init(wrappedValue: nil)
            _startRadiusFraction = .init(wrappedValue: startRadiusFraction)
            _endRadiusFraction = .init(wrappedValue: endRadiusFraction)
            super.init(gradient: gradient)
        }
        
        internal init(gradient: Gradient, directionalCenter: NSDirectionalUnitPoint, startRadiusFraction: CGFloat, endRadiusFraction: CGFloat) {
            _center = .init(wrappedValue: nil)
            _directionalCenter = .init(wrappedValue: directionalCenter)
            _startRadiusFraction = .init(wrappedValue: startRadiusFraction)
            _endRadiusFraction = .init(wrappedValue: endRadiusFraction)
            super.init(gradient: gradient)
        }
        
        internal override func copy() -> Self {
            RadialConfiguration(copy: self) as! Self
        }
        
        internal init(copy other: borrowing RadialConfiguration) {
            _center = other._center
            _directionalCenter = other._directionalCenter
            _startRadiusFraction = other._startRadiusFraction
            _endRadiusFraction = other._endRadiusFraction
            super.init(copy: other)
        }
    }
}

extension GradientView.Configuration {
    
    public struct Gradient: Hashable {
        
        public var stops: [Stop]
        
        public var colorSpace: ColorSpace
        
        public init(stops: [Stop], colorSpace: ColorSpace = .perceptual) {
            precondition(!stops.isEmpty, "Gradient should contain at least one stop, preferably two or more")
            self.stops = stops
            self.colorSpace = colorSpace
        }
        
        public init(colors: borrowing [UIColor], colorSpace: ColorSpace = .perceptual) {
            guard let lastIndex = colors.index(colors.endIndex, offsetBy: -1, limitedBy: colors.startIndex) else {
                preconditionFailure("Gradient should contain at least one color, preferably two or more")
            }
            stops = colors.enumerated().map { Stop(location: CGFloat($0.offset) / CGFloat(lastIndex), color: $0.element) }
            self.colorSpace = colorSpace
        }
    }
}

extension GradientView.Configuration.Gradient {
    
    public struct Stop: Hashable {
        
        public let location: CGFloat
        
        public let color: UIColor
        
        public init(location: CGFloat, color: UIColor) {
            self.location = location
            self.color = color
        }
    }
}

extension GradientView.Configuration.Gradient {
    
    public enum ColorSpace: Hashable {
        
        case device
        
        case linear
        
        case perceptual
    }
}

extension GradientView.Configuration.Gradient.ColorSpace {
    
    fileprivate var cgColorSpace: CGColorSpace {
        switch self  {
        case .device:
            extendedSRGBCGColorSpace
        case .linear:
            extendedLinearSRGBCGColorSpace
        case .perceptual:
            oklabCGColorSpace
        }
    }
}

fileprivate let extendedSRGBCGColorSpace = CGColorSpace(name: CGColorSpace.extendedSRGB)!

fileprivate let extendedLinearSRGBCGColorSpace = CGColorSpace(name: CGColorSpace.extendedLinearSRGB)!

fileprivate let oklabCGColorSpace: CGColorSpace = {
    guard let url = Bundle.module.url(forResource: "Oklab", withExtension: "icc") else {
        preconditionFailure("Unable to find the appropriate ICC profile")
    }
    
    let data: Data
    do {
        data = try Data(contentsOf: url)
    }  catch {
        preconditionFailure(error.localizedDescription)
    }
    
    guard let colorSpace = CGColorSpace(iccData: data as CFData) else {
        preconditionFailure("Failed to create CGColorSpace from this ICC profile")
    }
    
    return colorSpace
}()

#if DEBUG
#Preview("Linear", traits: .fixedLayout(width: 300.0, height: 900.0)) {
    let colors: [UIColor] = [
        .init(dynamicProvider: { $0.userInterfaceStyle == .dark ? .systemCyan : .systemGreen}),
        .systemPink,
    ]
    let stackView = UIStackView(arrangedSubviews: [
        GradientView(
            frame: .zero,
            configuration: .linear(gradient: .init(colors: colors, colorSpace: .device), directionalStartPoint: .topLeading, directionalEndPoint: .bottomTrailing)
        ),
        GradientView(
            frame: .zero,
            configuration: .linear(gradient: .init(colors: colors, colorSpace: .perceptual), directionalStartPoint: .topLeading, directionalEndPoint: .bottomTrailing) //configuration: .linear(colors: colors, startPoint: .left, endPoint: .right)
        ),
        GradientView(
            frame: .zero,
            configuration: .linear(colors: colors, directionalStartPoint: .top, directionalEndPoint: .bottom)
        ),
    ])
    stackView.axis = .vertical
    stackView.alignment = .fill
    stackView.distribution = .fillEqually
    stackView.spacing = 1.0
    return stackView
}

#Preview("Angular", traits: .fixedLayout(width: 300.0, height: 1800.0)) {
    let colors: [UIColor] = [
        .systemRed,
        .systemOrange,
        .systemYellow,
        .systemGreen,
        .systemBlue,
        .systemPurple,
    ]
    let stackView = UIStackView(arrangedSubviews: [
        GradientView(
            frame: .zero,
            configuration: .angular(colors: colors, center: .center, angle: .degrees(90.0))
        ),
        GradientView(
            frame: .zero,
            configuration: .angular(colors: colors, directionalCenter: .init(x: 0.7, y: 0.5), angle: .degrees(90.0))
        ),
        GradientView(
            frame: .zero,
            configuration: .angular(colors: colors, directionalCenter: .center, startAngle: .degrees(90.0), endAngle: .degrees(0.0))
        ),
        GradientView(
            frame: .zero,
            configuration: .angular(colors: colors, directionalCenter: .center, startAngle: .init(degrees: 0.0), endAngle: .init(degrees: 270.0))
        ),
        GradientView(
            frame: .zero,
            configuration: .angular(colors: colors, directionalCenter: .center, startAngle: .degrees(0.0), endAngle: .degrees(360.0 + 360.0))
        ),
        GradientView(
            frame: .zero,
            configuration: .angular(colors: colors, directionalCenter: .center, startAngle: .degrees(360.0 + 360.0), endAngle: .degrees(0.0))
        ),
    ])
    stackView.axis = .vertical
    stackView.alignment = .fill
    stackView.distribution = .fillEqually
    stackView.spacing = 1.0
    return stackView
}

#Preview("Conic", traits: .fixedLayout(width: 300.0, height: 900.0)) {
    let colors: [UIColor] = [
        .systemRed,
        .systemOrange,
        .systemYellow,
        .systemGreen,
        .systemBlue,
        .systemPurple,
    ]
    let stackView = UIStackView(arrangedSubviews: [
        GradientView(
            frame: .zero,
            configuration: .conic(colors: colors, center: .center, angle: .degrees(0.0))
        ),
        GradientView(
            frame: .zero,
            configuration: .conic(colors: colors, directionalCenter: .init(x: 0.7, y: 0.5), angle: .degrees(90.0))
        ),
        GradientView(
            frame: .zero,
            configuration: .conic(colors: colors, directionalCenter: .center, angle: .degrees(-180.0))
        ),
    ])
    stackView.axis = .vertical
    stackView.alignment = .fill
    stackView.distribution = .fillEqually
    stackView.spacing = 1.0
    return stackView
}

#Preview("Elliptical", traits: .fixedLayout(width: 500.0, height: 900.0)) {
    let colors: [UIColor] = [
        .systemGreen,
        .systemPink,
    ]
    let stackView = UIStackView(arrangedSubviews: [
        GradientView(
            frame: .zero,
            configuration: .elliptical(colors: colors, startRadiusFraction: 0.0, endRadiusFraction: 0.3)
        ),
        GradientView(
            frame: .zero,
            configuration: .elliptical(colors: colors, directionalCenter: .topTrailing, startRadiusFraction: 0.0, endRadiusFraction: 0.7)
        ),
        GradientView(
            frame: .zero,
            configuration: .elliptical(colors: colors, directionalCenter: .bottomLeading, startRadiusFraction: 0.0, endRadiusFraction: 1.0)
        ),
    ])
    stackView.axis = .vertical
    stackView.alignment = .fill
    stackView.distribution = .fillEqually
    stackView.spacing = 1.0
    return stackView
}

#Preview("Radial", traits: .fixedLayout(width: 500.0, height: 900.0)) {
    let colors: [UIColor] = [
        .systemGreen,
        .systemPink,
    ]
    let stackView = UIStackView(arrangedSubviews: [
        GradientView(
            frame: .zero,
            configuration: .radial(colors: colors, startRadiusFraction: 0.0, endRadiusFraction: 0.3)
        ),
        GradientView(
            frame: .zero,
            configuration: .radial(colors: colors, directionalCenter: .topTrailing, startRadiusFraction: 0.0, endRadiusFraction: 0.7)
        ),
        GradientView(
            frame: .zero,
            configuration: .radial(colors: colors, directionalCenter: .bottomLeading, startRadiusFraction: 0.0, endRadiusFraction: 1.0)
        ),
    ])
    stackView.axis = .vertical
    stackView.alignment = .fill
    stackView.distribution = .fillEqually
    stackView.spacing = 1.0
    return stackView
}
#endif
