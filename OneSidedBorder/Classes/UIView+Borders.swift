//
//  UIView+Borders.swift
//  OneSidedBorder
//
//  Created by ryohey on 2019/03/25.
//

import UIKit

private var kBorderLayerKey: Int = 0

/**

 BorderLayer を UIView に持たせて、
 色や線幅をそれぞれプロパティとして設定できるようにするカテゴリ

 */
public extension UIView {
    var topBorderColor: UIColor? {
        get { return borderLayer.colors[.top].flatMap(UIColor.init) }
        set { borderLayer.colors[.top] = newValue?.cgColor }
    }

    var rightBorderColor: UIColor? {
        get { return borderLayer.colors[.right].flatMap(UIColor.init) }
        set { borderLayer.colors[.right] = newValue?.cgColor }
    }

    var bottomBorderColor: UIColor? {
        get { return borderLayer.colors[.bottom].flatMap(UIColor.init) }
        set { borderLayer.colors[.bottom] = newValue?.cgColor }
    }

    var leftBorderColor: UIColor? {
        get { return borderLayer.colors[.left].flatMap(UIColor.init) }
        set { borderLayer.colors[.left] = newValue?.cgColor }
    }
    
    var topBorderWidth: CGFloat {
        get { return borderLayer.widths[.top] ?? 0 }
        set { borderLayer.widths[.top] = newValue }
    }
    
    var rightBorderWidth: CGFloat {
        get { return borderLayer.widths[.right] ?? 0 }
        set { borderLayer.widths[.right] = newValue }
    }

    var bottomBorderWidth: CGFloat {
        get { return borderLayer.widths[.bottom] ?? 0 }
        set { borderLayer.widths[.bottom] = newValue }
    }

    var leftBorderWidth: CGFloat {
        get { return borderLayer.widths[.left] ?? 0 }
        set { borderLayer.widths[.left] = newValue }
    }

    var topBorderMargin: CGFloat {
        get { return borderLayer.margins[.top] ?? 0 }
        set { borderLayer.margins[.top] = newValue }
    }

    var rightBorderMargin: CGFloat {
        get { return borderLayer.margins[.right] ?? 0 }
        set { borderLayer.margins[.right] = newValue }
    }

    var bottomBorderMargin: CGFloat {
        get { return borderLayer.margins[.bottom] ?? 0 }
        set { borderLayer.margins[.bottom] = newValue }
    }

    var leftBorderMargin: CGFloat {
        get { return borderLayer.margins[.left] ?? 0 }
        set { borderLayer.margins[.left] = newValue }
    }

    // MARK: - border layer

    private var borderLayer: BorderLayer {
        get {
            if let layer = objc_getAssociatedObject(self, &kBorderLayerKey) as? BorderLayer {
                return layer
            }
            let layer = BorderLayer()

            objc_setAssociatedObject(self, &kBorderLayerKey, layer, .OBJC_ASSOCIATION_RETAIN_NONATOMIC)
            self.layer.addSublayer(layer)

            layer.frame = CGRect(origin: .zero, size: self.frame.size)
            layer.frameObserver = observe(\.frame) { [weak layer] (view, change) in
                guard let layer = layer else {
                    return
                }
                // アニメーションさせない
                CATransaction.begin()
                CATransaction.disableActions()

                // レイヤーのサイズを追従させる
                layer.frame = CGRect(origin: .zero, size: view.frame.size)
                CATransaction.commit()
            }

            return layer
        }
    }
}
