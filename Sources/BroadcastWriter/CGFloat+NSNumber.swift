
import Foundation
import CoreGraphics

extension CGFloat {

    var nsNumber: NSNumber {
        return .init(value: native)
    }
}
