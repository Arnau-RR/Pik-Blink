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
                    title: LocalizedStringKey("settings.header.title"),
                    subtitle: LocalizedStringKey("settings.header.subtitle")
                ) { }
                .padding(.horizontal, 20)

                List {

                    // MARK: General

                    Section("settings.section.general") {

                        NavigationLink {
                            SettingsDetailView(title: "settings.notifications.title") {
                                Section {
                                    Text("settings.notifications.description")
                                }
                            }
                        } label: {
                            SettingsRow(
                                title: "settings.notifications.row.title",
                                icon: "bell"
                            )
                        }

                        NavigationLink {
                            SettingsDetailView(title: "settings.defaultReminder.title") {
                                Section {
                                    Text("settings.defaultReminder.description")
                                }
                            }
                        } label: {
                            SettingsRow(
                                title: "settings.defaultReminder.row.title",
                                icon: "clock",
                                value: "settings.defaultReminder.row.value"
                            )
                        }

                        NavigationLink {
                            SettingsDetailView(title: "settings.siriShortcuts.title") {
                                Section {
                                    Text("settings.siriShortcuts.description")
                                }
                            }
                        } label: {
                            SettingsRow(
                                title: "settings.siriShortcuts.row.title",
                                icon: "sparkles"
                            )
                        }

                        NavigationLink {
                            AppearanceSettingsView()
                        } label: {
                            SettingsRow(
                                title: "settings.appearance.row.title",
                                icon: "circle.lefthalf.filled",
                                value: AppAppearance(rawValue: appearance)?.title ?? "settings.appearance.system"
                            )
                        }

                        NavigationLink {
                            LanguageSettingsView()
                        } label: {
                            SettingsRow(
                                title: "settings.language.row.title",
                                icon: "globe",
                                value: AppLanguage(rawValue: language)?.title ?? "settings.language.system"
                            )
                        }
                    }

                    // MARK: Location

                    Section("settings.section.location") {
                        NavigationLink {
                            FavoritePlacesSettingsView()
                        } label: {
                            SettingsRow(
                                title: LocalizedStringKey("settings.location.favoritePlaces.title"),
                                icon: "map"
                            )
                        }
                    }

                    // MARK: Privacy

                    Section("settings.section.privacy") {

                        Toggle(isOn: $iCloudSync) {
                            Label(
                                "settings.icloudSync.title",
                                systemImage: "icloud"
                            )
                        }

                        NavigationLink {
                            SettingsDetailView(title: "settings.exportData.title") {
                                Section {
                                    Text("settings.exportData.description")
                                }
                            }
                        } label: {
                            SettingsRow(
                                title: "settings.exportData.row.title",
                                icon: "square.and.arrow.up"
                            )
                        }
                    }

                    // MARK: About

                    Section("settings.section.about") {

                        NavigationLink {
                            SettingsDetailView(title: "settings.version.title") {
                                Section("settings.version.section.app") {
                                    HStack {
                                        Text("settings.version.label")
                                        Spacer()
                                        Text("1.0.0")
                                            .foregroundStyle(.secondary)
                                    }
                                }
                            }
                        } label: {
                            SettingsRow(
                                title: "settings.version.row.title",
                                icon: "info.circle",
                                value: "1.0.0"
                            )
                        }

                        NavigationLink {
                            SettingsDetailView(title: "settings.feedback.title") {
                                Section {
                                    Text("settings.feedback.description")
                                }
                            }
                        } label: {
                            SettingsRow(
                                title: "settings.feedback.row.title",
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
