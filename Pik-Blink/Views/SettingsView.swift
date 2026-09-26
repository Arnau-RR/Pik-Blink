//
//  SettingsView.swift
//  Pik-Blink
//
//  Created by Arnau on 25/09/2026.
//

import SwiftUI
import SwiftData

struct SettingsView: View {
    @Environment(\.modelContext) private var context
    @State private var iCloudSync = true
    
    @AppStorage("appAppearance")
    private var appearance = AppAppearance.system.rawValue
    
    @AppStorage("appLanguage")
    private var language = AppLanguage.system.rawValue

    var body: some View {
        NavigationStack {
            VStack(spacing: 20) {

                HeaderView(
                    title: "Pik Blink",
                    subtitle: "Capture ideas in a blink."
                ) { }
                .padding(.horizontal, 20)

                List {

                    // MARK: General

                    Section("General") {

                        NavigationLink {
                            SettingsDetailView(title: "Notifications") {
                                Section {
                                    Text("Notification settings")
                                }
                            }
                        } label: {
                            SettingsRow(title: "Notifications", icon: "bell")
                        }

                        NavigationLink {
                            SettingsDetailView(title: "Default Reminder") {
                                Section {
                                    Text("Choose your default reminder")
                                }
                            }
                        } label: {
                            SettingsRow(
                                title: "Default reminder",
                                icon: "clock",
                                value: "Today, 10:00"
                            )
                        }

                        NavigationLink {
                            SettingsDetailView(title: "Siri Shortcuts") {
                                Section {
                                    Text("Configure Siri shortcuts")
                                }
                            }
                        } label: {
                            SettingsRow(title: "Siri Shortcuts", icon: "sparkles")
                        }

                        NavigationLink {
                            AppearanceSettingsView()
                        } label: {
                            SettingsRow(
                                title: "Appearance",
                                icon: "circle.lefthalf.filled",
                                value: AppAppearance(rawValue: appearance)?.title ?? "System"
                            )
                        }

                        
                        NavigationLink {
                            LanguageSettingsView()
                        } label: {
                            SettingsRow(
                                title: "Language",
                                icon: "globe",
                                value: AppLanguage(rawValue: language)?.title ?? "System"
                            )
                        }
                        
//                        NavigationLink {
//                            SettingsDetailView(title: "Language") {
//                                Section {
//                                    Text("Select your language")
//                                }
//                            }
//                        } label: {
//                            SettingsRow(
//                                title: "Language",
//                                icon: "globe",
//                                value: "English"
//                            )
//                        }
                    }
                    
                    Section("Location") {
                        NavigationLink {
                            FavoritePlacesSettingsView()
                        } label: {
                            SettingsRow(
                                title: "Favorite Places",
                                icon: "map"
                            )
                        }
                    }

                    // MARK: Privacy

                    Section("Privacy") {

                        Toggle(isOn: $iCloudSync) {
                            Label("iCloud Sync", systemImage: "icloud")
                        }

                        NavigationLink {
                            SettingsDetailView(title: "Export Data") {
                                Section {
                                    Text("Export your Pik Blink data")
                                }
                            }
                        } label: {
                            SettingsRow(
                                title: "Export Data",
                                icon: "square.and.arrow.up"
                            )
                        }
                    }

                    // MARK: About

                    Section("About") {

                        NavigationLink {
                            SettingsDetailView(title: "Version") {
                                Section("App") {
                                    HStack {
                                        Text("Version")
                                        Spacer()
                                        Text("1.0.0")
                                            .foregroundStyle(.secondary)
                                    }
                                }
                            }
                        } label: {
                            SettingsRow(
                                title: "Version",
                                icon: "info.circle",
                                value: "1.0.0"
                            )
                        }

                        NavigationLink {
                            SettingsDetailView(title: "Send Feedback") {
                                Section {
                                    Text("We'd love to hear your feedback.")
                                }
                            }
                        } label: {
                            SettingsRow(
                                title: "Send Feedback",
                                icon: "square.and.pencil"
                            )
                        }
                    }
                }
                .listStyle(.insetGrouped)
                .scrollContentBackground(.hidden)
                .background(Color(.systemGroupedBackground))
            }
            .background(Color(.systemGroupedBackground))
            .navigationBarHidden(true)
        }
    }
}
