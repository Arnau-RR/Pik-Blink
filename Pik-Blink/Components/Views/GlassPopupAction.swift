//
//  GlassPopupAction.swift
//  Pik-Blink
//
//  Created by Arnau on 23/09/2026.
//

import SwiftUI

struct GlassPopupAction: Identifiable {
    let id = UUID()
    let title: String
    var role: ButtonRole? = nil
    let action: () -> Void
}

struct GlassPopup: View {
    @Environment(\.colorScheme) private var colorScheme

    let title: String
    let subtitle: String
    let actions: [GlassPopupAction]

    var body: some View {
        VStack(spacing: 22) {

            VStack(spacing: 8) {
                Text(title)
                    .font(.title3.weight(.bold))
                    .multilineTextAlignment(.center)
                    .foregroundStyle(primaryText)

                Text(subtitle)
                    .font(.subheadline)
                    .multilineTextAlignment(.center)
                    .foregroundStyle(.secondary)
            }

            VStack(spacing: 12) {
                ForEach(actions) { item in
                    Button(role: item.role) {
                        item.action()
                    } label: {
                        Text(item.title)
                            .font(.headline)
                            .frame(maxWidth: .infinity)
                            .frame(height: 50)
                    }
                    .buttonStyle(
                        GlassPopupButtonStyle(
                            role: item.role,
                            colorScheme: colorScheme
                        )
                    )
                }
            }
        }
        .padding(24)
        .background(backgroundMaterial)
        .clipShape(RoundedRectangle(cornerRadius: 28, style: .continuous))
        .overlay {
            RoundedRectangle(cornerRadius: 28, style: .continuous)
                .stroke(borderColor, lineWidth: 1)
        }
        .shadow(
            color: .black.opacity(colorScheme == .dark ? 0.35 : 0.15),
            radius: 30,
            y: 12
        )
        .padding(.horizontal, 28)
    }

    private var backgroundMaterial: Material {
        colorScheme == .dark ? .thickMaterial : .regularMaterial
    }

    private var borderColor: Color {
        colorScheme == .dark
            ? .white.opacity(0.12)
            : .white.opacity(0.65)
    }

    private var primaryText: Color {
        colorScheme == .dark ? .white : .black
    }
}

struct GlassPopupButtonStyle: ButtonStyle {
    let role: ButtonRole?
    let colorScheme: ColorScheme

    func makeBody(configuration: Configuration) -> some View {
        configuration.label
            .foregroundStyle(foreground)
            .background(
                RoundedRectangle(cornerRadius: 16, style: .continuous)
                    .fill(buttonFill(configuration.isPressed))
            )
            .overlay {
                RoundedRectangle(cornerRadius: 16, style: .continuous)
                    .stroke(buttonBorder, lineWidth: 1)
            }
            .scaleEffect(configuration.isPressed ? 0.98 : 1)
            .animation(.easeOut(duration: 0.15), value: configuration.isPressed)
    }

    private var foreground: Color {
        if role == .destructive { return .red }
        return colorScheme == .dark ? .white : .black
    }

    private var buttonBorder: Color {
        colorScheme == .dark
            ? .white.opacity(0.12)
            : .white.opacity(0.8)
    }

    private func buttonFill(_ pressed: Bool) -> Color {
        if colorScheme == .dark {
            return .white.opacity(pressed ? 0.12 : 0.08)
        } else {
            return .white.opacity(pressed ? 0.65 : 0.45)
        }
    }
}

#Preview("Light") {
    ZStack {
        Color.gray.opacity(0.15).ignoresSafeArea()

        GlassPopup(
            title: "¿Cerrar recordatorio?",
            subtitle: "¿Seguro que quieres cerrar y eliminar el Pik?",
            actions: [
                GlassPopupAction(title: "Cancelar") {},
                GlassPopupAction(title: "Aceptar", role: .destructive) {}
            ]
        )
    }
    .preferredColorScheme(.light)
}

#Preview("Dark") {
    ZStack {
        Color.black.ignoresSafeArea()

        GlassPopup(
            title: "¿Cerrar recordatorio?",
            subtitle: "¿Seguro que quieres cerrar y eliminar el Pik?",
            actions: [
                GlassPopupAction(title: "Cancelar") {},
                GlassPopupAction(title: "Aceptar", role: .destructive) {}
            ]
        )
    }
    .preferredColorScheme(.dark)
}
