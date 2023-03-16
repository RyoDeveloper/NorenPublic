//
//  NavigationView.swift
//  Noren
//
//  https://github.com/RyoDeveloper/Noren
//  Copyright © 2023 RyoDeveloper. All rights reserved.
//

import SwiftUI

struct NavigationView: View {
    @State var page: NavigationPage? = NavigationPage.calendar
    @State var date = Date()

    var body: some View {
        NavigationSplitView {
            SidebarView(page: $page, date: $date)
                .navigationBarTitleDisplayMode(.inline)
        } detail: {
            DetailView(page: $page, date: $date)
                .navigationBarTitleDisplayMode(.inline)
        }
    }
}

struct NavigationView_Previews: PreviewProvider {
    static var previews: some View {
        NavigationView()
    }
}
