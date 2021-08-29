import Foundation

///命名空间

public protocol TGNameSpaceWrappable {
    associatedtype TGWrapperType
    var tg: TGWrapperType { get set }
    static var tg: TGWrapperType.Type { get set }
}

public extension TGNameSpaceWrappable {
    var tg: TGNameSpaceWrapper<Self> {
        set {}
        get {
            return TGNameSpaceWrapper(value: self)
        }
    }

    static var tg: TGNameSpaceWrapper<Self>.Type {
        set {}
        get {
            return TGNameSpaceWrapper.self
        }
    }
}

public protocol TGTypeWrapperProtocol {
    associatedtype TGWrappedType
    var wrappedValue: TGWrappedType { get }
    init(value: TGWrappedType)
}

public struct TGNameSpaceWrapper<T>: TGTypeWrapperProtocol {
    public var wrappedValue: T
    public init(value: T) {
        self.wrappedValue = value
    }
}
