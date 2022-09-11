//
//  ContentView.swift
//  Todo App
//
//  Created by Christian Nonis on 22/07/22.
//

import SwiftUI
import CoreData

struct ContentView: View {
    
    //MARK: - PROPERTIES
    @Environment(\.managedObjectContext) var viewContext
    @State private var showingAddToDoView: Bool = false
    @FetchRequest(entity: Todo.entity(), sortDescriptors: [NSSortDescriptor(keyPath: \Todo.name, ascending: true)]) var todos: FetchedResults<Todo>
    @State private var animatingButton: Bool = false
    @State private var showingSettingsView: Bool = false
    @EnvironmentObject var iconSettings: IconNames
    @ObservedObject var theme = ThemeSettings()
    var themes: [Theme] = themeData
    
    //MARK: - BODY
    var body: some View {
        NavigationView {
            ZStack {
                
                List {
                    ForEach(self.todos, id: \.self) { todo in
                        HStack {
                            Circle()
                                .frame(width: 12, height: 12, alignment: .center)
                                .foregroundColor(self.colorize(priority: todo.priority ?? "Normal"))
                            Text(todo.name ?? "Unknown")
                                .fontWeight(.semibold)
                            Spacer()
                            Text(todo.priority ?? "Unknown")
                                .font(.footnote)
                                .foregroundColor(Color(UIColor.systemGray2))
                                .padding(3)
                                .frame(minWidth: 62)
                                .overlay(
                                    Capsule().stroke(Color(UIColor.systemGray2), lineWidth: 0.75)
                                )
                        } //: HStack
                        .padding(.vertical, 10)
                    } //: ForEach
                    .onDelete(perform: deleteTodo)
                } //: List
                .navigationBarTitle("Todo", displayMode: .inline)
                .navigationBarItems(
                    leading: EditButton().accentColor(themes[self.theme.themeSettings].themeColor),
                    
                    trailing:
                        Button(action: {
                            self.showingSettingsView.toggle()
                        }, label: {
                            Image(systemName: "paintbrush")
                                .imageScale(.large)
                        })
                        .accentColor(themes[self.theme.themeSettings].themeColor)
                        .sheet(isPresented: $showingSettingsView) {
                            SettingsView()
                        }
                )
                if todos.count == 0 {
                    EmptyListView()
                }
                
            } //: ZStack
            .sheet(isPresented: $showingAddToDoView) {
                AddToDoView().environment(\.managedObjectContext, self.viewContext)
            }
            .overlay(
                ZStack {
                    Group {
                        Circle()
                            .fill(themes[self.theme.themeSettings].themeColor)
                            .opacity(self.animatingButton ? 0.2 : 0)
                            .scaleEffect(self.animatingButton ? 1 : 0.8)
                            .frame(width: 68, height: 68, alignment: .center)
                        Circle()
                            .fill(themes[self.theme.themeSettings].themeColor)
                            .opacity(self.animatingButton ? 0.15 : 0)
                            .scaleEffect(self.animatingButton ? 1 : 0.8)
                            .frame(width: 88, height: 88, alignment: .center)
                    }
                    .onAppear {
                        withAnimation(.easeOut(duration: 1).repeatForever()) {
                            self.animatingButton.toggle()
                        }
                    }
                    Button(action: {
                        self.showingAddToDoView.toggle()
                    }, label: {
                        Image(systemName: "plus.circle.fill")
                            .resizable()
                            .scaledToFit()
                            .background(Circle().fill(Color("ColorBase")))
                            .frame(width: 48, height: 48, alignment: .center)
                    })
                    .accentColor(themes[self.theme.themeSettings].themeColor)
                    .onAppear {
                        self.animatingButton.toggle()
                    }
                } //: ZStack
                    .padding(.bottom, 15)
                    .padding(.trailing, 15)
                , alignment: .bottomTrailing
            )
        } //: NavicationView
        .navigationViewStyle(StackNavigationViewStyle())
    }
    
    //MARK: - FUNCIONS
    private func deleteTodo(at offsets: IndexSet) {
        for index in offsets {
            let todo = todos[index]
            viewContext.delete(todo)
            do {
                try viewContext.save()
            } catch {
                print(error)
            }
        }
    }
    private func colorize(priority: String) -> Color {
        switch priority {
        case "High": return .pink
        case "Normal": return .green
        case "Low" : return .blue
        default: return .gray
        }
    }
}

//MARK: - PREVIEW
struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView().environment(\.managedObjectContext, PersistenceController.preview.container.viewContext)
    }
}
