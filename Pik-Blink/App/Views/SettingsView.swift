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

                    Section(String(localized: "settings.section.general")) {

                        NavigationLink {
                            SettingsDetailView(title: LocalizedStringKey("settings.notifications.title")) {
                                Section {
                                    Text(String(localized: "settings.notifications.description"))
                                }
                            }
                        } label: {
                            SettingsRow(
                                title: LocalizedStringKey("settings.notifications.row.title"),
                                icon: "bell"
                            )
                        }

                        NavigationLink {
                            SettingsDetailView(title: LocalizedStringKey("settings.defaultReminder.title")) {
                                Section {
                                    Text(String(localized: "settings.defaultReminder.description"))
                                }
                            }
                        } label: {
                            SettingsRow(
                                title: LocalizedStringKey("settings.defaultReminder.row.title"),
                                icon: "clock",
                                value: String(localized: "settings.defaultReminder.row.value")
                            )
                        }

                        NavigationLink {
                            SettingsDetailView(title: LocalizedStringKey("settings.siriShortcuts.title")) {
                                Section {
                                    Text(String(localized: "settings.siriShortcuts.description"))
                                }
                            }
                        } label: {
                            SettingsRow(
                                title: LocalizedStringKey("settings.siriShortcuts.row.title"),
                                icon: "sparkles"
                            )
                        }

                        NavigationLink {
                            AppearanceSettingsView()
                        } label: {
                            SettingsRow(
                                title: LocalizedStringKey("settings.appearance.row.title"),
                                icon: "circle.lefthalf.filled",
                                value: AppAppearance(rawValue: appearance)?.title ?? String(localized: "settings.appearance.system")
                            )
                        }

                        NavigationLink {
                            LanguageSettingsView()
                        } label: {
                            SettingsRow(
                                title: LocalizedStringKey("settings.language.row.title"),
                                icon: "globe",
                                value: AppLanguage(rawValue: language)?.title ?? String(localized: "settings.language.system")
                            )
                        }
                    }

                    // MARK: Location

                    Section(String(localized: "settings.section.location")) {
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

                    Section(String(localized: "settings.section.privacy")) {

                        Toggle(isOn: $iCloudSync) {
                            Label(
                                String(localized: "settings.icloudSync.title"),
                                systemImage: "icloud"
                            )
                        }

                        NavigationLink {
                            SettingsDetailView(title: LocalizedStringKey("settings.exportData.title")) {
                                Section {
                                    Text(String(localized: "settings.exportData.description"))
                                }
                            }
                        } label: {
                            SettingsRow(
                                title: LocalizedStringKey("settings.exportData.row.title"),
                                icon: "square.and.arrow.up"
                            )
                        }
                    }

                    // MARK: About

                    Section(String(localized: "settings.section.about")) {

                        NavigationLink {
                            SettingsDetailView(title: LocalizedStringKey("settings.version.title")) {
                                Section(String(localized: "settings.version.section.app")) {
                                    HStack {
                                        Text(String(localized: "settings.version.label"))
                                        Spacer()
                                        Text("1.0.0")
                                            .foregroundStyle(.secondary)
                                    }
                                }
                            }
                        } label: {
                            SettingsRow(
                                title: LocalizedStringKey("settings.version.row.title"),
                                icon: "info.circle",
                                value: "1.0.0"
                            )
                        }

                        NavigationLink {
                            SettingsDetailView(title: LocalizedStringKey("settings.feedback.title")) {
                                Section {
                                    Text(String(localized: "settings.feedback.description"))
                                }
                            }
                        } label: {
                            SettingsRow(
                                title: LocalizedStringKey("settings.feedback.row.title"),
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
