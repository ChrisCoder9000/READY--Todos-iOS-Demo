//
//  SettingsView.swift
//  Todo App
//
//  Created by Christian Nonis on 24/07/22.
//

import SwiftUI

struct SettingsView: View {
    
    //MARK: - PROPERTIES
    @Environment(\.presentationMode) var presentationMode
    @EnvironmentObject var iconSettings: IconNames
    let themes: [Theme] = themeData
    @ObservedObject var theme = ThemeSettings()
    @State private var isThmemeChanged: Bool = false
    
    //MARK: - BODY
    var body: some View {
        NavigationView {
            VStack(alignment: .center, spacing: 0) {
                Form {
                    //                    Section(header: Text("Choose the app icon")) {
                    //                        Picker(selection: $iconSettings.currentIndex, label: Text("App Icons")) {
                    //                            ForEach(0..<iconSettings.iconNames.count) {
                    //                                index in
                    //                                HStack {
                    //                                    Image(uiImage: UIImage(named: self.iconSettings.iconNames[index] ?? "Blue") ?? UIImage())
                    //                                        .renderingMode(.original)
                    //                                        .resizable()
                    //                                        .scaledToFit()
                    //                                        .frame(width: 44, height: 44)
                    //                                        .cornerRadius(8)
                    //                                    Spacer().frame(width: 8)
                    //                                    Text(self.iconSettings.iconNames[index] ?? "Blue")
                    //                                        .frame(alignment: .leading)
                    //                                }
                    //                                .padding(3)
                    //                            }
                    //                        } //: Picker
                    //                        .onReceive([self.iconSettings.currentIndex].publisher.first()) {
                    //                            (value) in
                    //                            let index = self.iconSettings.iconNames.firstIndex(of: UIApplication.shared.alternateIconName) ?? 0
                    //                            if index != value {
                    //                                UIApplication.shared.setAlternateIconName(self.iconSettings.iconNames[value]) { error in
                    //                                    if let error = error {
                    //                                        print(error.localizedDescription)
                    //                                    } else {
                    //                                        print("Success!")
                    //                                    }
                    //                                }
                    //                            }
                    //                        }
                    //                    }
                    //                    .padding(.vertical, 3)
                    Section(header: Text("Follow us on social media")) {
                        FormRowLinkView(icon: "globe", color: .pink, text: "Website", link: "https://servizidiamond.it")
                        FormRowLinkView(icon: "link", color: .blue, text: "Twitter", link: "https://twitter.com/christiannonis")
                    }
                    .padding(.vertical, 3)
                    Section(header: Text("About the application")) {
                        FormRowStaticView(icon: "gear", firstText: "Application", secondText: "Todo")
                        FormRowStaticView(icon: "checkmark.seal", firstText: "Compatibility", secondText: "iPhone, iPad")
                        FormRowStaticView(icon: "keyboard", firstText: "Developer", secondText: "John / Jane")
                        FormRowStaticView(icon: "paintbrush", firstText: "Designer", secondText: "Robert Petras")
                        FormRowStaticView(icon: "flag", firstText: "Version", secondText: "1.0.0")
                    }
                    .padding(.vertical, 3)
                    Section(header:
                                HStack {
                        Text("Choose the app theme")
                        Image(systemName: "circle.fill")
                            .resizable()
                            .frame(width: 10, height: 10)
                            .foregroundColor(themes[self.theme.themeSettings].themeColor)
                    }
                    ) {
                        List {
                            ForEach(themes, id: \.id) { item in
                                Button {
                                    self.theme.themeSettings = item.id
                                    UserDefaults.standard.set(self.theme.themeSettings, forKey: "Theme")
                                    self.isThmemeChanged.toggle()
                                } label: {
                                    HStack {
                                        Image(systemName: "circle.fill")
                                            .foregroundColor(item.themeColor)
                                        Text(item.themeName)
                                    }
                                }
                                .accentColor(Color.primary)
                            }
                        }
                    }
                    .padding(.vertical, 3)
                    .alert(isPresented: $isThmemeChanged) {
                        Alert(title:
                                Text("SUCCESS!"),
                              message: Text("App has been changed to the \(themes[self.theme.themeSettings].themeName). Now close and restart it!"),
                              dismissButton: .default(Text("OK"))
                        )
                    }
                } //: Form
                .listStyle(GroupedListStyle())
                .environment(\.horizontalSizeClass, .regular)
                Text("Copyright © All rights reserved.\nChristian Nonis")
                    .multilineTextAlignment(.center)
                    .font(.footnote)
                    .padding(.top, 6)
                    .padding(.bottom, 8)
                    .foregroundColor(.secondary)
            } //: VStack
            .navigationBarItems(
                trailing:
                    Button(action: {
                        self.presentationMode.wrappedValue.dismiss()
                    }, label: {
                        Image(systemName: "xmark")
                    }))
            .navigationBarTitle("Settings", displayMode: .inline)
            .background(Color("ColorBackground"))
            //            .edgesIgnoringSafeArea(.all)
        } //: Navigation
        .accentColor(themes[self.theme.themeSettings].themeColor)
        .navigationViewStyle(StackNavigationViewStyle())
    }
}

//MARK: - PREVIEW
struct SettingsView_Previews: PreviewProvider {
    static var previews: some View {
        SettingsView().environmentObject(IconNames())
    }
}
