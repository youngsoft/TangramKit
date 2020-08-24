import Foundation

///命名空间

public protocol NameSpaceWrappable {
    associatedtype WrapperType
    var tg: WrapperType { set get }
    static var tg: WrapperType.Type { set get }
}

public extension NameSpaceWrappable {
    var tg: NameSpaceWrapper<Self> {
        set {}
        get {
            return NameSpaceWrapper(value: self)
        }
    }

    static var tg: NameSpaceWrapper<Self>.Type {
        set {}
        get {
            return NameSpaceWrapper.self
        }
    }
}

public protocol TypeWrapperProtocol {
    associatedtype WrappedType
    var wrappedValue: WrappedType { get }
    init(value: WrappedType)
}

public struct NameSpaceWrapper<T>: TypeWrapperProtocol {
    public var wrappedValue: T
    public init(value: T) {
        self.wrappedValue = value
    }
}
