//
//  MarkdownView.swift
//  Noren
//
//  https://github.com/RyoDeveloper/Noren
//  Copyright © 2023 RyoDeveloper. All rights reserved.
//

import SwiftUI
import RDMarkdownKit

enum MarkdownPage {
    case editor
    case preview
}

struct MarkdownView: View {
    @State var page = MarkdownPage.editor
    @Binding var note: String

    var body: some View {
        VStack {
            Picker("", selection: $page) {
                Label("エディター", systemImage: "square.and.pencil")
                    .tag(MarkdownPage.editor)
                Label("プレビュー", systemImage: "number")
                    .tag(MarkdownPage.preview)
            }
            .pickerStyle(.segmented)
            .padding([.top, .leading, .trailing])
            Group {
                if page == .editor {
                    // エディター
                    TextEditor(text: $note)
                } else {
                    // プレビュー
                    ScrollView {
                        Markdown($note)
                            .padding()
                    }
                }
            }
        }
    }
}

struct MarkdownView_Previews: PreviewProvider {
    static var previews: some View {
        MarkdownView(note: .constant("# Noren"))
    }
}
