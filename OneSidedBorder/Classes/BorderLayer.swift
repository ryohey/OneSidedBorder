import QuartzCore

enum Edge: CaseIterable {
    case top
    case right
    case bottom
    case left
}

extension CaseIterable {
    static func dictionaryKeyedByCases<T>(with value: T) -> [Self: T] where Self: Hashable {
        var dict: [Self: T] = [:]
        allCases.forEach {
            dict[$0] = value
        }
        return dict
    }
}

private let defaultBorderColor = CGColor(colorSpace: CGColorSpaceCreateDeviceRGB(), components: [0.0, 0.0, 0.0, 1.0])!

/// BorderLayer draws borders inside superlayer's edge
class BorderLayer: CALayer {
    /// 各辺の線幅
    var widths = [Edge: CGFloat]() {
        didSet {
            setNeedsDisplay()
        }
    }

    //// 各辺の色
    var colors = [Edge: CGColor]() {
        didSet {
            setNeedsDisplay()
        }
    }

    //// 各辺の角からの余白
    var margins = [Edge: CGFloat]() {
        didSet {
            setNeedsDisplay()
        }
    }

    var frameObserver: NSKeyValueObservation?

    override init() {
        super.init()

        needsDisplayOnBoundsChange = true

        // frame が 1 以上のサイズを持っていないと最初の描画が走らないので 1x1 の大きさにしておく
        frame = CGRect(x: 9, y: 9, width: 1, height: 1)

        // 初期値の設定
        borderWidth = 0.0

        setBorderColor(defaultBorderColor)
        setBorderMargin(0.0)
    }

    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    deinit {
        frameObserver?.invalidate()
        frameObserver = nil
    }

    /// すべての辺の色を変える
    func setBorderColor(_ borderColor: CGColor) {
        colors = Edge.dictionaryKeyedByCases(with: borderColor)
    }

    /// すべての辺の線幅を変える
    func setBorderWidth(_ borderWidth: CGFloat) {
        widths = Edge.dictionaryKeyedByCases(with: borderWidth)
    }

    /// すべての辺の余白を変える
    func setBorderMargin(_ margin: CGFloat) {
        margins = Edge.dictionaryKeyedByCases(with: margin)
    }

    // MARK: -

    override func draw(in ctx: CGContext?) {
        guard let ctx = ctx else {
            return
        }
        ctx.saveGState()
        ctx.setShouldAntialias(false)

        Edge.allCases.forEach { edge in
            // 線幅が無いとき描画しない
            guard let width = widths[edge], width > .ulpOfOne else {
                return
            }

            // 色が指定されていないか透明なら描画しない
            guard let color = colors[edge], color.alpha > .ulpOfOne else {
                return
            }

            let rect = borderRect(for: edge, borderWidth: width)
            ctx.setFillColor(color)
            ctx.fill(rect)
        }

        ctx.restoreGState()
    }

    /// 線の塗りつぶし範囲を作成する
    func borderRect(for edge: Edge, borderWidth: CGFloat) -> CGRect {
        let size = bounds.size
        let margin = margins[edge] ?? 0
        let margin2 = margin * 2
        switch edge {
        case .top:
            return CGRect(x: margin, y: 0, width: size.width - margin2, height: borderWidth)
        case .right:
            let x = size.width - borderWidth
            return CGRect(x: x, y: margin, width: x, height: size.height - margin2)
        case .bottom:
            let y = size.height - borderWidth
            return CGRect(x: margin, y: y, width: size.width - margin2, height: y)
        case .left:
            return CGRect(x: 0, y: margin, width: borderWidth, height: size.height - margin2)
        }

    }
}
