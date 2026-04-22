//
//  BookmarkOverlayView.swift
//  Malashchuk08
//
//  Created by Ivanna Malashchuk on 19.04.2026.
//


import UIKit

class BookmarkOverlayView: UIView {
    private let shapeLayer = CAShapeLayer()

    override init(frame: CGRect) {
        super.init(frame: frame)
        isUserInteractionEnabled = false
        backgroundColor = UIColor.black.withAlphaComponent(0.18)
        alpha = 0

        shapeLayer.fillColor = UIColor.systemYellow.cgColor
        shapeLayer.strokeColor = UIColor.white.cgColor
        shapeLayer.lineWidth = 2
        layer.addSublayer(shapeLayer)
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    override func layoutSubviews() {
        super.layoutSubviews()
        shapeLayer.path = bookmarkPath(in: bounds.insetBy(dx: bounds.width * 0.35, dy: bounds.height * 0.28)).cgPath
    }

    private func bookmarkPath(in rect: CGRect) -> UIBezierPath {
        let path = UIBezierPath()
        let minX = rect.minX
        let maxX = rect.maxX
        let minY = rect.minY
        let maxY = rect.maxY
        let midX = rect.midX
        let notchY = maxY - rect.height * 0.22

        path.move(to: CGPoint(x: minX, y: minY))
        path.addLine(to: CGPoint(x: maxX, y: minY))
        path.addLine(to: CGPoint(x: maxX, y: maxY))
        path.addLine(to: CGPoint(x: midX, y: notchY))
        path.addLine(to: CGPoint(x: minX, y: maxY))
        path.close()
        return path
    }

    func play() {
        alpha = 0
        transform = CGAffineTransform(scaleX: 0.7, y: 0.7)

        UIView.animate(withDuration: 0.2, animations: {
            self.alpha = 1
            self.transform = .identity
        }) { _ in
            UIView.animate(withDuration: 0.25, delay: 0.55, options: [], animations: {
                self.alpha = 0
            })
        }

        let pop = CABasicAnimation(keyPath: "transform.scale")
        pop.fromValue = 0.7
        pop.toValue = 1.0
        pop.duration = 0.2
        shapeLayer.add(pop, forKey: "pop")
    }
}
