//
//  LocusApp.swift
//  Locus
//
//  Created by Sanjeev on 20/02/22.
//

import SwiftUI

@main
struct LocusApp: App {

    @ObservedObject var model: WeatherViewModel = .shared
    
    @Environment(\.scenePhase) private var scenePhase
    
    var body: some Scene {
        WindowGroup {
            NavigationView {
                LandingView()
                    .modifier(UnHideNavigationBar())
                    .preferredColorScheme(.light)
                    .onAppear(perform: UIApplication.shared.addTapGestureRecognizer)
                    .environmentObject(model)
                    .modifier(AlertViewModifier())
            }
        }.onChange(of: scenePhase) { phase in
            switch phase {
            case .active:
                debugPrint("App going active")
            case .inactive:
                debugPrint("App going inactive")
            case .background:
                debugPrint("App going background")
            default:
                debugPrint("Unknown scenePhase")
            }
        }
    }
}

extension UIApplication {
    func addTapGestureRecognizer() {
        guard let window = windows.first else { return }
        let tapGesture = UITapGestureRecognizer(target: window, action: #selector(UIView.endEditing))
        tapGesture.requiresExclusiveTouchType = false
        tapGesture.cancelsTouchesInView = false
        tapGesture.delegate = self
        window.addGestureRecognizer(tapGesture)
    }
}

extension UIApplication: UIGestureRecognizerDelegate {
    public func gestureRecognizer(_ gestureRecognizer: UIGestureRecognizer, shouldRecognizeSimultaneouslyWith otherGestureRecognizer: UIGestureRecognizer) -> Bool {
        return true
    }
}
