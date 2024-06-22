//
//  RotatingShapesViewSimulator.swift
//  AnimationSimulator
//
//  Created by yotahara on 2024/06/22.
//

import SwiftUI

enum ShapeType: String, CaseIterable {
    case circle = "Circle",
         rectangle = "Rectangle",
         squircle = "Squircle"
}

struct RotatingShapesViewSimulator: View {
    @State private var colorScheme: ColorScheme = .light
    @State private var objectShape: ShapeType = .circle
    @State private var frameSize: CGFloat = 300
    @State private var animationDuration: CGFloat = 2.5
    @State private var numberOfPoints: Int = 5
    @State private var addOppositeAnimation: Bool = true
    @State private var backgroundOpacity: CGFloat = 0.3
    @State private var shadowRadius: CGFloat = 10
    @State private var shadowOffset: CGFloat = 15
    @State private var shadowOpacity: CGFloat = 0.5
    @State private var addBackground: Bool = true
    @State private var pointScaleRatio: CGFloat = 4.0
    
    private let maxFrameHeight: CGFloat = 350
    private let rowTextWidth: CGFloat = 200
    
    @State private var isGeneralSectionOpen: Bool = true
    @State private var isBackgroundSectionOpen: Bool = true
    @State private var isPointsSectionOpen: Bool = true
    @State private var isShadowSectionOpen: Bool = true
    
    var body: some View {
        NavigationStack {
            VStack {
                Group {
                    switch objectShape {
                    case .circle:
                        RotatingShapesView(objectShape: Circle(),
                                           frameSize: frameSize,
                                           animationDuration: animationDuration,
                                           numberOfPoints: numberOfPoints,
                                           pointScaleRatio: pointScaleRatio,
                                           addOppositeAnimation: addOppositeAnimation,
                                           shadowRadius: shadowRadius,
                                           shadowOffset: shadowOffset,
                                           shadowOpacity: shadowOpacity,
                                           backgroundOpacity: backgroundOpacity,
                                           addBackground: addBackground)
                    case .rectangle:
                        RotatingShapesView(objectShape: Rectangle(),
                                           frameSize: frameSize,
                                           animationDuration: animationDuration,
                                           numberOfPoints: numberOfPoints,
                                           pointScaleRatio: pointScaleRatio,
                                           addOppositeAnimation: addOppositeAnimation,
                                           shadowRadius: shadowRadius,
                                           shadowOffset: shadowOffset,
                                           shadowOpacity: shadowOpacity,
                                           backgroundOpacity: backgroundOpacity,
                                           addBackground: addBackground)
                    case .squircle:
                        RotatingShapesView(objectShape: Squircle(),
                                           frameSize: frameSize,
                                           animationDuration: animationDuration,
                                           numberOfPoints: numberOfPoints,
                                           pointScaleRatio: pointScaleRatio,
                                           addOppositeAnimation: addOppositeAnimation,
                                           shadowRadius: shadowRadius,
                                           shadowOffset: shadowOffset,
                                           shadowOpacity: shadowOpacity,
                                           backgroundOpacity: backgroundOpacity,
                                           addBackground: addBackground)
                    }
                }
                .id(UUID())
                .frame(height: maxFrameHeight)

                ScrollView(showsIndicators: false) {
                    VStack(spacing: 0) {
                        SectionView(title: "Generals", isOpen: $isGeneralSectionOpen) {
                            VStack {
                                SegmentedPickerRow(title: "colorScheme", selection: $colorScheme, selectionList: ColorScheme.allCases)
                                
                                Divider()
                                
                                SegmentedShapePickerRow(rowTextWidth: rowTextWidth, selection: $objectShape)
                                
                                Divider()
                                
                                SliderRow(title: "frameSize", value: $frameSize, in: 50...maxFrameHeight, step: 1)
                                
                                Divider()
                                
                                SliderRow(title: "animationDuration", value: $animationDuration, in: 0.1...10, step: 0.1)
                                
                                Divider()
                                
                                ToggleRow(title: "addOppositeAnimation", isOn: $addOppositeAnimation)
                            }
                            .padding(.horizontal, 20)
                            .padding(.vertical, 10)
                        }
                        
                        Divider()
                        
                        SectionView(title: "Background", isOpen: $isBackgroundSectionOpen) {
                            VStack {
                                ToggleRow(title: "addBackground", isOn: $addBackground)
                                
                                Divider()
                                
                                SliderRow(title: "backgroundOpacity", value: $backgroundOpacity, in: 0...1, step: 0.1)
                            }
                            .padding(.horizontal, 20)
                            .padding(.vertical, 10)
                        }
                        
                        Divider()
                        
                        SectionView(title: "Points", isOpen: $isPointsSectionOpen) {
                            VStack {
                                SliderRow(title: "pointScaleRatio", value: $pointScaleRatio, in: 0...10, step: 0.1)
                                
                                Divider()
                                
                                StepperRow(title: "numberOfPoints", value: $numberOfPoints, in: 1...20)
                            }
                            .padding(.horizontal, 20)
                            .padding(.vertical, 10)
                        }
                        
                        Divider()
                        
                        SectionView(title: "Shadows", isOpen: $isShadowSectionOpen) {
                            VStack {
                                SliderRow(title: "shadowRadius", value: $shadowRadius, in: 0...30, step: 0.5)
                                
                                Divider()
                                
                                SliderRow(title: "shadowOffset", value: $shadowOffset, in: 0...30, step: 0.5)
                                
                                Divider()
                                
                                SliderRow(title: "shadowOpacity", value: $shadowOpacity, in: 0...1, step: 0.1)
                                
                                Divider()
                            }
                            .padding(.horizontal, 20)
                            .padding(.vertical, 10)
                        }
                    }
                    .padding(.bottom, 20)
                }
                .background(Color.gray.opacity(0.2))
            }
            .navigationTitle("Rotating Shapes")
        .preferredColorScheme(colorScheme)
        }
    }
    
    func ToggleRow(title: String, isOn: Binding<Bool>) -> some View {
        HStack {
            Text(title)
                .font(.callout)
                .frame(maxWidth: .infinity, alignment: .leading)
                .frame(width: rowTextWidth)
            
            Toggle(isOn: isOn) {}
        }
    }
    
    func SliderRow(title: String, value: Binding<CGFloat>, in range: ClosedRange<CGFloat>, step: CGFloat = 1) -> some View {
        HStack {
            HStack {
                Text(title)
                    .frame(maxWidth: .infinity, alignment: .leading)
                
                
                Text("\(value.wrappedValue, specifier: "%.1f")")
                    .bold()
            }
            .font(.callout)
            .frame(width: rowTextWidth)
            
            Slider(value: value,
                   in: Double(range.lowerBound)...Double(range.upperBound),
                   step: Double(step))
            .padding(.horizontal)
        }
    }
    
    func StepperRow(title: String, value: Binding<Int>, in range: ClosedRange<Int>, step: Int = 1) -> some View {
        HStack {
            HStack {
                Text(title)
                    .frame(maxWidth: .infinity, alignment: .leading)
                
                Text(String(describing: value.wrappedValue))
                    .bold()
            }
            .font(.callout)
            .frame(width: rowTextWidth)
            
            Stepper("", value: value,
                    in: range.lowerBound...range.upperBound,
                    step: step)
            .padding(.horizontal)
        }
    }
    
    func SegmentedPickerRow<T: Hashable>(title: String, selection: Binding<T>, selectionList: [T]) -> some View {
        HStack {
            Text(title)
                .frame(maxWidth: .infinity, alignment: .leading)
                .frame(width: rowTextWidth)
            
            Picker("", selection: selection) {
                ForEach(selectionList, id: \.self) { row in
                    Text("\(String(describing: row))")
                        .tag(row)
                }
            }
            .font(.callout)
            .pickerStyle(SegmentedPickerStyle())
        }
    }
    
    
    func SectionHeader(title: String, isOpen: Binding<Bool>) -> some View {
        HStack {
            Text(title)
                .frame(maxWidth: .infinity, alignment: .leading)
            
            Image(systemName: isOpen.wrappedValue
                  ? "chevron.down"
                  : "chevron.right")
        }
        .padding(.horizontal, 16)
        .padding(.vertical, 8)
        .background(Color(uiColor: .darkGray))
        .foregroundColor(.white)
        .font(.title3)
        .onTapGesture {
            withAnimation {
                isOpen.wrappedValue.toggle()
            }
        }
    }
    
    func SectionView<Content: View>(title: String, isOpen: Binding<Bool>, @ViewBuilder content: () -> Content) -> some View {
        
        VStack {
            SectionHeader(title: title, isOpen: isOpen)
            
            if isOpen.wrappedValue {
                content()
            }
        }
    }
}

struct SegmentedShapePickerRow: View {
    var title: String = "objectShape"
    var rowTextWidth: CGFloat
    @Binding var selection: ShapeType
    @Namespace private var namespace
    
    var body: some View {
        HStack {
            Text(title)
                .frame(maxWidth: .infinity, alignment: .leading)
                .frame(width: rowTextWidth)
            
            HStack(spacing: 0) {
                ZStack {
                    if selection == .circle {
                        RoundedRectangle(cornerRadius: 6)
                            .fill(Color(uiColor: .lightText))
                            .matchedGeometryEffect(id: "selection", in: namespace)
                    }
                    
                    Circle()
                        .fill(Color(uiColor: .label))
                        .frame(width: 20, height: 20)
                }
                .frame(maxWidth: .infinity)
                .onTapGesture {
                    withAnimation {
                        selection = .circle
                    }
                }
                
                ZStack {
                    if selection == .rectangle {
                        RoundedRectangle(cornerRadius: 6)
                            .fill(Color(uiColor: .lightText))
                            .frame(maxWidth: .infinity)
                            .matchedGeometryEffect(id: "selection", in: namespace)
                    }
                    
                    Rectangle()
                        .fill(Color(uiColor: .label))
                        .frame(width: 20, height: 20)
                }
                .frame(maxWidth: .infinity)
                .onTapGesture {
                    withAnimation {
                        selection = .rectangle
                    }
                }
                
                ZStack {
                    if selection == .squircle {
                        RoundedRectangle(cornerRadius: 6)
                            .fill(Color(uiColor: .lightText))
                            .frame(maxWidth: .infinity)
                            .matchedGeometryEffect(id: "selection", in: namespace)
                    }
                    
                    Squircle()
                        .fill(Color(uiColor: .label))
                        .frame(width: 20, height: 20)
                }
                .frame(maxWidth: .infinity)
                .onTapGesture {
                    withAnimation {
                        selection = .squircle
                    }
                }
            }
            .padding(2)
            .background(
                RoundedRectangle(cornerRadius: 8)
                    .foregroundColor(Color(uiColor: .secondarySystemFill))
            )
        }
        .frame(height: 32)
    }
}

#Preview {
    NavigationStack {
        RotatingShapesViewSimulator()
    }
}

