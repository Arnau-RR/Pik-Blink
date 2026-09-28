//
//  ReusableSheet.swift
//  Pik-Blink
//
//  Created by Arnau on 23/09/2026.
//

import SwiftUI

struct ReusableSheet<Content: View>: View {

    let title: LocalizedStringKey
    let cancelTitle: LocalizedStringKey
    let acceptTitle: LocalizedStringKey

    let onCancel: () -> Void
    let onAccept: () -> Void

    @ViewBuilder let content: () -> Content

    init(
        title: LocalizedStringKey,
        cancelTitle: LocalizedStringKey = "new.item.popup.close.cancel",
        acceptTitle: LocalizedStringKey = "new.item.popup.close.accept",
        onCancel: @escaping () -> Void,
        onAccept: @escaping () -> Void,
        @ViewBuilder content: @escaping () -> Content
    ) {
        self.title = title
        self.cancelTitle = cancelTitle
        self.acceptTitle = acceptTitle
        self.onCancel = onCancel
        self.onAccept = onAccept
        self.content = content
    }

    var body: some View {
        NavigationStack {
            content()
                .padding()
                .navigationTitle(title)
                .navigationBarTitleDisplayMode(.inline)
                .toolbar {
                    ToolbarItem(placement: .topBarLeading) {
                        Button(cancelTitle) {
                            onCancel()
                        }
                    }

                    ToolbarItem(placement: .topBarTrailing) {
                        Button(acceptTitle) {
                            onAccept()
                        }
                        .fontWeight(.semibold)
                    }
                }
        }
    }
}
