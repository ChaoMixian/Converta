//
//  FormatPicker.swift
//  Converta
//
//  Created by 陈铭勋 on 7/3/25.
//


// FormatPicker.swift
import SwiftUI

struct FormatPicker: View {
    @Binding var selectedFormat: String
    let availableFormats: [String]
    
    var body: some View {
        Menu {
            ForEach(availableFormats, id: \.self) { format in
                Button(action: {
                    selectedFormat = format
                }) {
                    HStack {
                        Text(format.uppercased())
                        if selectedFormat == format {
                            Image(systemName: "checkmark")
                        }
                    }
                }
            }
        } label: {
            HStack {
                Text(selectedFormat.uppercased())
                    .font(.body)
                    .fontWeight(.medium)
                Spacer()
                Image(systemName: "chevron.down")
                    .font(.caption)
            }
            .padding(.horizontal, 12)
            .padding(.vertical, 8)
            .background(Color.accentColor.opacity(0.1))
            .cornerRadius(6)
        }
        .buttonStyle(PlainButtonStyle())
    }
}