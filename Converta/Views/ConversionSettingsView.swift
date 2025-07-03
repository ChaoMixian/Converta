//
//  ConversionSettingsView.swift
//  Converta
//
//  Created by 陈铭勋 on 7/3/25.
//


// MARK: - ConversionSettingsView.swift
import SwiftUI

struct ConversionSettingsView: View {
    let fileType: ConvertaFileType
    @Binding var settings: ConversionSettings
    
    var body: some View {
        VStack(alignment: .leading, spacing: 12) {
            Text("转换设置")
                .font(.subheadline)
                .fontWeight(.semibold)
            
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

struct ImageSettingsView: View {
    @Binding var settings: ConversionSettings
    
    var body: some View {
        VStack(alignment: .leading, spacing: 8) {
            SettingRow(label: "格式") {
                Picker("格式", selection: $settings.targetFormat) {
                    Text("JPEG").tag("JPEG")
                    Text("PNG").tag("PNG")
                    Text("WebP").tag("WebP")
                }
                .pickerStyle(.menu)
            }
            
            if settings.targetFormat == "JPEG" {
                SettingRow(label: "质量") {
                    Slider(value: $settings.imageQuality, in: 0.1...1.0, step: 0.1)
                    Text("\(Int(settings.imageQuality * 100))%")
                        .frame(width: 40)
                }
            }
            
            SettingRow(label: "尺寸") {
                Picker("尺寸", selection: $settings.imageSize) {
                    Text("原始尺寸").tag("原始尺寸")
                    Text("50%").tag("50%")
                    Text("25%").tag("25%")
                }
                .pickerStyle(.menu)
            }
        }
    }
}

struct VideoSettingsView: View {
    @Binding var settings: ConversionSettings
    
    var body: some View {
        VStack(alignment: .leading, spacing: 8) {
            SettingRow(label: "格式") {
                Picker("格式", selection: $settings.targetFormat) {
                    Text("MP4").tag("MP4")
                    Text("MOV").tag("MOV")
                }
                .pickerStyle(.menu)
            }
            
            SettingRow(label: "质量") {
                Picker("质量", selection: $settings.videoQuality) {
                    Text("高").tag("高")
                    Text("中等").tag("中等")
                    Text("低").tag("低")
                }
                .pickerStyle(.menu)
            }
            
            SettingRow(label: "分辨率") {
                Picker("分辨率", selection: $settings.videoResolution) {
                    Text("原始分辨率").tag("原始分辨率")
                    Text("1080p").tag("1080p")
                    Text("720p").tag("720p")
                    Text("480p").tag("480p")
                }
                .pickerStyle(.menu)
            }
        }
    }
}

struct AudioSettingsView: View {
    @Binding var settings: ConversionSettings
    
    var body: some View {
        VStack(alignment: .leading, spacing: 8) {
            SettingRow(label: "格式") {
                Picker("格式", selection: $settings.targetFormat) {
                    Text("MP3").tag("MP3")
                    Text("WAV").tag("WAV")
                    Text("AAC").tag("AAC")
                }
                .pickerStyle(.menu)
            }
            
            SettingRow(label: "比特率") {
                Picker("比特率", selection: $settings.audioBitrate) {
                    Text("320 kbps").tag("320")
                    Text("256 kbps").tag("256")
                    Text("192 kbps").tag("192")
                    Text("128 kbps").tag("128")
                }
                .pickerStyle(.menu)
            }
            
            SettingRow(label: "采样率") {
                Picker("采样率", selection: $settings.audioSampleRate) {
                    Text("48000 Hz").tag("48000")
                    Text("44100 Hz").tag("44100")
                    Text("22050 Hz").tag("22050")
                }
                .pickerStyle(.menu)
            }
        }
    }
}

struct DocumentSettingsView: View {
    @Binding var settings: ConversionSettings
    
    var body: some View {
        VStack(alignment: .leading, spacing: 8) {
            SettingRow(label: "格式") {
                Picker("格式", selection: $settings.targetFormat) {
                    Text("PDF").tag("PDF")
                    Text("TXT").tag("TXT")
                }
                .pickerStyle(.menu)
            }
        }
    }
}

struct SettingRow<Content: View>: View {
    let label: String
    let content: Content
    
    init(label: String, @ViewBuilder content: () -> Content) {
        self.label = label
        self.content = content()
    }
    
    var body: some View {
        HStack {
            Text(label)
                .font(.caption)
                .foregroundColor(.secondary)
                .frame(width: 60, alignment: .leading)
            
            content
        }
    }
}