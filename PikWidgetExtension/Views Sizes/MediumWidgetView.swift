//
//  MediumWidgetView.swift
//  Pik-Blink
//
//  Created by Arnau on 27/09/2026.
//

//
//  MediumWidgetView.swift
//  PikWidgetExtension
//

import SwiftUI
import AppIntents

struct MediumWidgetView: View {
    
    @Environment(\.colorScheme) private var colorScheme
    
    let entry: PikEntry
    
    private var visiblePiks: [PikItem] { Array(entry.piks.prefix(3)) }
    private var remaining: Int { max(0, entry.piks.count - 3) }
    
    var body: some View {
        HStack(spacing: 14) {
            
            // MARK: Left summary
            
            VStack(alignment: .leading, spacing: 2) {
                
                Text("Today")
                    .font(.headline)
                
                Text("\(entry.piks.count)")
                    .font(.system(size: 34, weight: .bold))
                
                Text("pending")
                    .font(.caption2)
                    .foregroundStyle(.secondary)
                
                Spacer()
            }
            .frame(width: 72, alignment: .topLeading)
            .padding()
            
            Divider()
            
            // MARK: Right list
            
            VStack(alignment: .leading, spacing: 10) {
                
                if visiblePiks.isEmpty {
                    
                    Spacer()
                    
                    VStack(alignment: .leading, spacing: 4) {
                        Text("Nothing for today")
                            .font(.subheadline)
                        
                        Text("Enjoy your day ✨")
                            .font(.caption2)
                            .foregroundStyle(.secondary)
                    }
                    
                    Spacer()
                    
                } else {
                    
                    ForEach(visiblePiks) { pik in
                        HStack(spacing: 10) {
                            
                            Button(intent: CompletePikIntent(id: pik.id)) {
                                Image(systemName: "circle")
                                    .font(.title3)
                                    .foregroundStyle(.secondary)
                            }
                            .buttonStyle(.plain)
                            
                            VStack(alignment: .leading, spacing: 1) {
                                
                                Text(pik.text)
                                    .font(.footnote)
                                    .lineLimit(1)
                                
                                Text(subtitle(for: pik))
                                    .font(.caption2 )
                                    .foregroundStyle(.secondary)
                            }
                            
                            Spacer()
                        }
                        .frame(height: 30)
                    }
                    
                    Spacer(minLength: 0)
                    
                    if remaining > 0 {
                        Divider()
                        
                        Text("+\(remaining) more")
                            .font(.caption2)
                            .foregroundStyle(.secondary)
                            .frame(maxWidth: .infinity)
                    }
                }
            }
        }
    }
    
    private func subtitle(for pik: PikItem) -> String {
        if pik.reminderType == .location {
            return pik.placeName ?? "Location"
        }
        
        guard let date = pik.remindAt else {
            return "No reminder"
        }
        
        return date.formatted(.dateTime.hour().minute())
    }
}
