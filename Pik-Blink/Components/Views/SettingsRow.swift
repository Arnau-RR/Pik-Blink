struct SettingsRow: View {
    let title: String
    let icon: String
    var value: String? = nil

    var body: some View {
        HStack(spacing: 14) {
            Image(systemName: icon)
                .frame(width: 22)
                .foregroundStyle(.primary)

            Text(title)

            Spacer()

            if let value {
                Text(value)
                    .foregroundStyle(.secondary)
                    .font(.subheadline)
            }

            if value == nil {
                Image(systemName: "chevron.right")
                    .font(.footnote)
                    .foregroundStyle(.tertiary)
            }
        }
        .padding(.vertical, 4)
    }
}