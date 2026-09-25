//
//  LocationSummaryView.swift
//  Pik-Blink
//
//  Created by Arnau on 25/09/2026.
//

import SwiftUI

struct LocationSummaryView: View {

    let location: String

    var body: some View {
        HStack(spacing: 10) {

            Image(systemName: "location.circle.fill")
                .foregroundStyle(.green)
                .font(.title3)

            VStack(alignment: .leading, spacing: 2) {

                Text("Location")
                    .font(.caption)
                    .foregroundStyle(.secondary)

                Text(location)
                    .font(.subheadline.weight(.medium))
            }

            Spacer()
        }
        .padding(14)
        .background(.gray.opacity(0.08))
        .clipShape(RoundedRectangle(cornerRadius: 16))
    }
}
