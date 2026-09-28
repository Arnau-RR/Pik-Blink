//
//  PikWidgetBundle.swift
//  Pik-Blink
//
//  Created by Arnau on 26/09/2026.
//

import WidgetKit
import SwiftUI

@main
struct PikWidgetBundle: WidgetBundle {
    var body: some Widget {
        PikWidget()
        PikLiveActivity()
    }
}
