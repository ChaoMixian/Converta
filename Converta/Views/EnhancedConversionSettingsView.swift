// MARK: - Enhanced ConversionSettingsView with Presets
struct EnhancedConversionSettingsView: View {
    let fileType: ConvertaFileType
    @Binding var settings: ConversionSettings
    @StateObject private var presetManager = PresetManager()
    @State private var selectedPreset: ConversionPreset?
    @State private var showingPresets = false
    
    var body: some View {
        VStack(alignment: .leading, spacing: 12) {
            HStack {
                Text("转换设置")
                    .font(.subheadline)
                    .fontWeight(.semibold)
                
                Spacer()
                
                Button("预设") {
                    showingPresets.toggle()
                }
                .buttonStyle(.bordered)
                .controlSize(.small)
            }
            
            if showingPresets {
                PresetSelectionView(
                    presets: presetManager.presets.filter { $0.fileType == fileType },
                    selectedPreset: $selectedPreset,
                    onPresetSelected: { preset in
                        presetManager.applyPreset(preset, to: &settings)
                        showingPresets = false
                    }
                )
                .transition(.opacity)
            }
            
            // 原有的设置视图
            switch fileType {
            case .image:
                ImageSettingsView(settings: $settings)
            case .video:
                VideoSettingsView(settings: $settings)
            case .audio:
                AudioSettingsView(settings: $settings)
            case .document:
                DocumentSettingsView(settings: $settings)
            case .unknown:
                Text("该文件类型暂不支持转换")
                    .foregroundColor(.secondary)
            }
        }
    }
}

struct PresetSelectionView: View {
    let presets: [ConversionPreset]
    @Binding var selectedPreset: ConversionPreset?
    let onPresetSelected: (ConversionPreset) -> Void
    
    var body: some View {
        VStack(alignment: .leading, spacing: 8) {
            ForEach(presets) { preset in
                Button(action: {
                    onPresetSelected(preset)
                }) {
                    VStack(alignment: .leading, spacing: 4) {
                        Text(preset.name)
                            .font(.caption)
                            .fontWeight(.medium)
                        Text(preset.description)
                            .font(.caption2)
                            .foregroundColor(.secondary)
                    }
                    .frame(maxWidth: .infinity, alignment: .leading)
                    .padding(.horizontal, 8)
                    .padding(.vertical, 4)
                    .background(
                        RoundedRectangle(cornerRadius: 4)
                            .fill(Color.blue.opacity(0.1))
                    )
                }
                .buttonStyle(.plain)
            }
        }
        .padding(.vertical, 4)
    }
}
