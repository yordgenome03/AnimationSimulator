//
//  RotatingShapesView.swift
//  AnimationSimulator
//
//  Created by yotahara on 2024/06/22.
//

import SwiftUI

struct RotatingShapesView<T: Shape>: View {
    let frameSize: CGFloat
    let numberOfPoints: Int
    let colors: [Color] = [.red, .yellow, .blue, .green, .purple]
    let backgroundOpacity: CGFloat
    let addBackground: Bool
    let addOppositeAnimation: Bool
    var objectShape: T
    var animationDuration: Double
    var pointScaleRatio: CGFloat
    var shadowRadius: CGFloat
    var shadowOffset: CGFloat
    var shadowOpacity: CGFloat
    
    @State private var rotateAngle: Double = 0.0
    
    init(objectShape: T = Circle(),
         frameSize: CGFloat = 300,
         animationDuration: Double = 2.5,
         numberOfPoints: Int = 5,
         pointScaleRatio: CGFloat = 2.0,
         addOppositeAnimation: Bool = true,
         shadowRadius: CGFloat = 10,
         shadowOffset: CGFloat = 10,
         shadowOpacity: CGFloat = 0.5,
         backgroundOpacity: CGFloat = 0.3,
         addBackground: Bool = true
    ) {
        self.objectShape = objectShape
        self.frameSize = frameSize
        self.numberOfPoints = numberOfPoints
        self.animationDuration = animationDuration
        self.pointScaleRatio = pointScaleRatio
        self.addOppositeAnimation = addOppositeAnimation
        self.shadowRadius = shadowRadius
        self.shadowOffset = shadowOffset
        self.shadowOpacity = shadowOpacity
        self.backgroundOpacity = backgroundOpacity
        self.addBackground = addBackground
    }
    
    var body: some View {
        ZStack {
            if addBackground {
                RoundedRectangle(cornerRadius: backgroundCornerRadius)
                    .fill(Color.gray.opacity(backgroundOpacity))
            }
            
            Group {
                ForEach(0..<numberOfPoints, id: \.self) { index in
                    MovingPoint(index: index,
                                rotateAngle: rotateAngle,
                                objectShape: objectShape,
                                pointSize: pointSize,
                                pointScaleRatio: pointScaleRatio,
                                shadowRadius: shadowRadius,
                                shadowOffset: shadowOffset,
                                shadowOpacity: shadowOpacity,
                                color: colors[index % colors.count],
                                radius: radius,
                                numberOfPoints: numberOfPoints,
                                isOpposite: false,
                                animationDuration: animationDuration)
                    if addOppositeAnimation {
                        MovingPoint(index: index,
                                    rotateAngle: rotateAngle,
                                    objectShape: objectShape,
                                    pointSize: pointSize,
                                    pointScaleRatio: pointScaleRatio,
                                    shadowRadius: shadowRadius,
                                    shadowOffset: shadowOffset,
                                    shadowOpacity: shadowOpacity,
                                    color: colors[index % colors.count],
                                    radius: radius,
                                    numberOfPoints: numberOfPoints,
                                    isOpposite: true,
                                    animationDuration: animationDuration)
                    }
                }
            }
            .frame(width: size, height: size)
        }
        .frame(width: frameSize, height: frameSize)
        .onAppear {
            withAnimation(.linear(duration: animationDuration).repeatForever(autoreverses: false)) {
                rotateAngle = 360
            }
        }
    }
    
    private var radius: CGFloat { frameSize / 5 }
    private var size: CGFloat { radius * 2 }
    private var pointSize: CGFloat { radius * 0.15 }
    private var backgroundCornerRadius: CGFloat { frameSize / 10 }
    
    struct MovingPoint: View, Animatable {
        let index: Int
        var rotateAngle: Double
        var objectShape: T
        var pointSize: CGFloat
        var pointScaleRatio: CGFloat
        var shadowRadius: CGFloat
        var shadowOffset: CGFloat
        var shadowOpacity: CGFloat
        var color: Color
        var radius: CGFloat
        var numberOfPoints: Int
        var isOpposite: Bool
        let animationDuration: Double
        
        private var radians: (Double) -> CGFloat = { degrees in
            return CGFloat(degrees * .pi / 180)
        }
        
        var animatableData: Double {
            get { rotateAngle }
            set { rotateAngle = newValue }
        }
        
        init(index: Int, rotateAngle: Double, objectShape: T, pointSize: CGFloat, pointScaleRatio: CGFloat, shadowRadius: CGFloat, shadowOffset: CGFloat, shadowOpacity: CGFloat, color: Color, radius: CGFloat, numberOfPoints: Int, isOpposite: Bool, animationDuration: Double) {
            self.index = index
            self.rotateAngle = rotateAngle
            self.objectShape = objectShape
            self.pointSize = pointSize
            self.pointScaleRatio = pointScaleRatio
            self.shadowRadius = shadowRadius
            self.shadowOffset = shadowOffset
            self.shadowOpacity = shadowOpacity
            self.color = color
            self.radius = radius
            self.numberOfPoints = numberOfPoints
            self.isOpposite = isOpposite
            self.animationDuration = animationDuration
        }
        
        var body: some View {
            objectShape
                .fill(color)
                .frame(width: pointSize, height: pointSize)
                .scaleEffect(pointScale())
                .position(position(index))
                .rotationEffect(.degrees(isOpposite ? -rotateAngle : rotateAngle))
                .shadow(color: color.opacity(shadowOpacity),
                        radius: shadowRadius(shadowRadius),
                        x: 0,
                        y: shadowOffset(shadowOffset))
                .offset(offset(index))
                .offset(y: -shadowOffset(shadowOffset))
                .rotationEffect(isOpposite ? .degrees(180) : .zero)
        }
        
        private func position(_ index: Int) -> CGPoint {
            let angle = 2 * .pi / CGFloat(numberOfPoints) * CGFloat(index)
            let x = cos(angle) * radius + radius
            let y = sin(angle) * radius + radius
            return .init(x: x, y: y)
        }
        
        private func offset(_ index: Int) -> CGSize {
            let angle = 2 * .pi / CGFloat(numberOfPoints) * CGFloat(index)
            let x = cos(angle + radians(180 * (isOpposite ? 1 : 0))) * radius
            let y = sin(angle + radians(180 * (isOpposite ? 1 : 0))) * radius
            return .init(width: x, height: y)
        }
        
        private func pointScale() -> CGFloat {
            let offset = rotateAngle < 180 ? 1.0 - CGFloat(rotateAngle) / 180 : 1.0 - CGFloat(360 - rotateAngle) / 180
            let oppositeOffset = 1.0 - offset
            return isOpposite ? pointScaleRatio * oppositeOffset : pointScaleRatio * offset
        }
        
        private func shadowRadius(_ value: CGFloat) -> CGFloat {
            let scale = pointScale()
            return (value / pointScaleRatio) * scale
        }
        
        private func shadowOffset(_ value: CGFloat) -> CGFloat {
            let scale = pointScale()
            return (value / pointScaleRatio) * scale * (isOpposite ? -1 : 1)
        }
    }
}

#Preview {
    RotatingShapesView(objectShape: Squircle(),
                       animationDuration: 2.5,
                       pointScaleRatio: 3,
                       addOppositeAnimation: true,
                       shadowRadius: 20,
                       shadowOffset: 20,
                       shadowOpacity: 0.9,
                       addBackground: true)
}

