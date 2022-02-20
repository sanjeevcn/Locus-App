//
//  AlerModifier.swift
//  Locus
//
//  Created by Sanjeev on 20/02/22.
//

import SwiftUI

struct UnHideNavigationBar: ViewModifier {
    func body(content: Content) -> some View {
        content
            .navigationViewStyle(.stack)
            .navigationBarTitleDisplayMode(.inline)
    }
}

struct HiddenNavigationBar: ViewModifier {
    func body(content: Content) -> some View {
        content
            .navigationViewStyle(.stack)
            .navigationBarTitleDisplayMode(.inline)
            .navigationBarBackButtonHidden(true)
            .navigationBarHidden(true)
    }
}

struct AlertViewModifier: ViewModifier {

    @ObservedObject var appRouter: WeatherViewModel = .shared
    @Environment(\.dismiss) var dismiss
    
    func body(content: Content) -> some View {
        content
            .alert(using: $appRouter.activeAlert) { alert in
                switch alert {
                case .custom(let message):
                    return Alert(title: Text("Locus App"), message: Text(message))
                }
            }
            .popup(isPresented: appRouter.isLoading, alignment: .center, content: Loader.init)
    }
}


public extension View {
    func popup<T: View>(
        isPresented: Bool,
        alignment: Alignment = .center,
        direction: Popup<T>.Direction = .bottom,
        @ViewBuilder content: () -> T
    ) -> some View {
        return modifier(Popup(isPresented: isPresented, alignment: alignment, direction: direction, content: content))
    }
    
    
    func alert<Value>(
        using value: Binding<Value?>,
        content: (Value) -> Alert
    ) -> some View {
        let binding = Binding<Bool>(
            get: { value.wrappedValue != nil },
            set: { _ in value.wrappedValue = nil }
        )
        return alert(isPresented: binding) {
            content(value.wrappedValue!)
        }
    }
}


public struct Loader: View {
    public var body: some View {
        Group {
            ProgressView("Loading")
                .progressViewStyle(CircularProgressViewStyle(tint: Color.white))
                .padding()
        }
        .padding()
        .background(Color.blue)
        .cornerRadius(10)
    }
}


public extension Popup {
    enum Direction {
        case top, bottom

        func offset(popupFrame: CGRect) -> CGFloat {
            switch self {
            case .top:
                let aboveScreenEdge = -popupFrame.maxY
                return aboveScreenEdge
            case .bottom:
                let belowScreenEdge = UIScreen.main.bounds.height - popupFrame.minY
                return belowScreenEdge
            }
        }
    }
}

public struct Popup<T: View>: ViewModifier {
    let popup: T
    let alignment: Alignment
    let direction: Direction
    let isPresented: Bool

    init(isPresented: Bool, alignment: Alignment, direction: Direction, @ViewBuilder content: () -> T) {
        self.isPresented = isPresented
        self.alignment = alignment
        self.direction = direction
        popup = content()
    }

    public func body(content: Content) -> some View {
        content
            .overlay(popupContent())
    }

    @ViewBuilder
    private func popupContent() -> some View {
        GeometryReader { geometry in
            if isPresented {
                popup
                    .animation(.spring(), value: isPresented)
                    .transition(.offset(x: 0, y: direction.offset(popupFrame: geometry.frame(in: .global))))
                    .frame(width: geometry.size.width, height: geometry.size.height, alignment: alignment)
            }
        }
    }
}
