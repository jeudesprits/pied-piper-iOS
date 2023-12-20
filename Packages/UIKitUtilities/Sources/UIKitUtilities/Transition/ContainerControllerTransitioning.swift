//
//  ContainerViewControllerTransitioning.swift
//  
//
//  Created by Ruslan Lutfullin on 29/03/23.
//

import UIKit

///
public enum ContainerControllerTransitioning {
}



//extension ContainerControllerTransitioning.ViewKeyScopes {
//
//  public struct DefaultViewKeys: ContainerControllerViewKeyScopeTransitioning {
//  }
//}
//
//
/////
//extension ContainerControllerTransitioning.FrameKeyScopes {
//
//  public struct DefaultFrameKeys: ContainerControllerFrameKeyScopeTransitioning {
//  }
//}
//
//
//
/////
//public protocol ContainerControllerViewKeyScopeTransitioning {
//}
//
/////
//public protocol ContainerControllerFrameKeyScopeTransitioning {
//}
//
/////
//extension ContainerControllerTransitioning {
//
//  public enum ViewKeyScopes {
//  }
//}
//
/////
//extension ContainerControllerTransitioning {
//
//  public enum FrameKeyScopes {
//  }
//}
//
/////
public protocol ContainerControllerViewKeyTransitioning {
}
//
/////
//public protocol ContainerControllerFrameKeyTransitioning {
//}

//extension ContainerControllerTransitioning {
//
//  @dynamicMemberLookup
//  public struct ViewKey {
//
//    public subscript<T: ContainerControllerViewKeyTransitioning>(_: T.Type) -> T {
//      fatalError()
//    }
//
//    public subscript<T: ContainerControllerViewKeyTransitioning>(dynamicMember keyPath: KeyPath<ContainerControllerTransitioning.ViewKeyScopes.DefaultViewKeys, T>) -> T {
//      return self[T.self]
//    }
//  }
//}

//extension ContainerControllerTransitioning {
//
//  @dynamicMemberLookup
//  public struct FrameKey: Hashable {
//
//    public subscript<T: ContainerControllerFrameKeyTransitioning>(_: T.Type) -> T {
//      fatalError()
//    }
//
//    public subscript<T: ContainerControllerFrameKeyTransitioning>(dynamicMember keyPath: KeyPath<ContainerControllerTransitioning.FrameKeyScopes.DefaultFrameKeys, T>) -> T {
//      return self[T.self]
//    }
//  }
//}


//
/////
//@MainActor
//public protocol ContainerViewControllerCoordinatorTransitioning {
//
//  associatedtype Context: ContainerViewControllerCoordinatorContextTransitioning
//
//  func animateAlongside(animations: ((_ context: Context) -> Void)?, completion: ((_ context: Context) -> Void)?)
//
//  func animateAlongside(in view: UIView, animations: ((_ context: Context) -> Void), completion: ((_ context: Context) -> Void)?)
//}




//@available(macOS 12, iOS 15, tvOS 15, watchOS 8, *)
//public protocol AttributedStringKey {
//  associatedtype Value : Swift.Hashable
//  static var name: Swift.String { get }
//  @available(macOS 13, iOS 16, tvOS 16, watchOS 9, *)
//  static var runBoundaries: Foundation.AttributedString.AttributeRunBoundaries? { get }
//  @available(macOS 13, iOS 16, tvOS 16, watchOS 9, *)
//  static var inheritedByAddedText: Swift.Bool { get }
//  @available(macOS 13, iOS 16, tvOS 16, watchOS 9, *)
//  static var invalidationConditions: Swift.Set<Foundation.AttributedString.AttributeInvalidationCondition>? { get }
//}
//@available(macOS 12, iOS 15, tvOS 15, watchOS 8, *)
//extension Foundation.AttributedStringKey {
//  public var description: Swift.String {
//    get
//  }
//  @available(macOS 13, iOS 16, tvOS 16, watchOS 9, *)
//  public static var runBoundaries: Foundation.AttributedString.AttributeRunBoundaries? {
//    get
//  }
//  @available(macOS 13, iOS 16, tvOS 16, watchOS 9, *)
//  public static var inheritedByAddedText: Swift.Bool {
//    get
//  }
//  @available(macOS 13, iOS 16, tvOS 16, watchOS 9, *)
//  public static var invalidationConditions: Swift.Set<Foundation.AttributedString.AttributeInvalidationCondition>? {
//    get
//  }
//}


//
//@dynamicMemberLookup @frozen public enum AttributeDynamicLookup {
//  public subscript<T>(_: T.Type) -> T where T : Foundation.AttributedStringKey {
//    get
//  }
//}


//public struct FoundationAttributes : Foundation.AttributeScope {
//  public let link: Foundation.AttributeScopes.FoundationAttributes.LinkAttribute
//  public let morphology: Foundation.AttributeScopes.FoundationAttributes.MorphologyAttribute
//  public let inflect: Foundation.AttributeScopes.FoundationAttributes.InflectionRuleAttribute
//  public let languageIdentifier: Foundation.AttributeScopes.FoundationAttributes.LanguageIdentifierAttribute
//  public let personNameComponent: Foundation.AttributeScopes.FoundationAttributes.PersonNameComponentAttribute
//  public let numberFormat: Foundation.AttributeScopes.FoundationAttributes.NumberFormatAttributes
//  public let dateField: Foundation.AttributeScopes.FoundationAttributes.DateFieldAttribute
//  public let inlinePresentationIntent: Foundation.AttributeScopes.FoundationAttributes.InlinePresentationIntentAttribute
//  public let presentationIntent: Foundation.AttributeScopes.FoundationAttributes.PresentationIntentAttribute
//  public let alternateDescription: Foundation.AttributeScopes.FoundationAttributes.AlternateDescriptionAttribute
//  public let imageURL: Foundation.AttributeScopes.FoundationAttributes.ImageURLAttribute
//  public let replacementIndex: Foundation.AttributeScopes.FoundationAttributes.ReplacementIndexAttribute
//  public let measurement: Foundation.AttributeScopes.FoundationAttributes.MeasurementAttribute
//  public let inflectionAlternative: Foundation.AttributeScopes.FoundationAttributes.InflectionAlternativeAttribute
//  public let byteCount: Foundation.AttributeScopes.FoundationAttributes.ByteCountAttribute
//  @available(macOS 13, iOS 16, tvOS 16, watchOS 9, *)
//  public var durationField: Foundation.AttributeScopes.FoundationAttributes.DurationFieldAttribute {
//    get
//  }
//  @available(macOS 13, iOS 16, tvOS 16, watchOS 9, *)
//  public var markdownSourcePosition: Foundation.AttributeScopes.FoundationAttributes.MarkdownSourcePositionAttribute {
//    get
//  }
//  @available(macOS 13, iOS 16, tvOS 16, watchOS 9, *)
//  public var localizedStringArgumentAttributes: Foundation.AttributeScopes.FoundationAttributes.LocalizedStringArgumentAttributes {
//    get
//  }
//  public typealias DecodingConfiguration = Foundation.AttributeScopeCodableConfiguration
//  public typealias EncodingConfiguration = Foundation.AttributeScopeCodableConfiguration
//}


//@available(macOS 12, iOS 15, tvOS 15, watchOS 8, *)
//extension Foundation.AttributeDynamicLookup {
//  public subscript<T>(dynamicMember keyPath: Swift.KeyPath<Foundation.AttributeScopes.FoundationAttributes, T>) -> T where T : Foundation.AttributedStringKey {
//    get
//  }
//  public subscript<T>(dynamicMember keyPath: Swift.KeyPath<Foundation.AttributeScopes.FoundationAttributes.NumberFormatAttributes, T>) -> T where T : Foundation.AttributedStringKey {
//    get
//  }
//  @available(macOS 13, iOS 16, tvOS 16, watchOS 9, *)
//  public subscript<T>(dynamicMember keyPath: Swift.KeyPath<Foundation.AttributeScopes.FoundationAttributes.LocalizedStringArgumentAttributes, T>) -> T where T : Foundation.AttributedStringKey {
//    get
//  }
//}
//@available(macOS 12, iOS 15, tvOS 15, watchOS 8, *)
//extension Foundation.AttributeScopes.FoundationAttributes {
//  @available(macOS 12, iOS 15, tvOS 15, watchOS 8, *)
//  @frozen public enum LinkAttribute : Foundation.CodableAttributedStringKey, Foundation.ObjectiveCConvertibleAttributedStringKey {
//    public typealias Value = Foundation.URL
//    public typealias ObjectiveCValue = ObjectiveC.NSObject
//    public static var name: Swift.String
//    public static func objectiveCValue(for value: Foundation.URL) throws -> ObjectiveC.NSObject
//    public static func value(for object: ObjectiveC.NSObject) throws -> Foundation.URL
//  }
//  @available(macOS 12, iOS 15, tvOS 15, watchOS 8, *)
//  @frozen public enum MorphologyAttribute : Foundation.CodableAttributedStringKey, Foundation.MarkdownDecodableAttributedStringKey {
//    public typealias Value = Foundation.Morphology
//    public static let name: Swift.String
//    public static let markdownName: Swift.String
//  }
//
//
