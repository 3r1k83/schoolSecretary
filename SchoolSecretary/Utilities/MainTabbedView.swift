import SwiftUI

enum TabbedItems: Int, CaseIterable {
    case classrooms = 0
    case students
    case professors
    case settings
    
    var title: String {
        switch self {
        case .classrooms:
            return "Classrooms"
        case .students:
            return "Students"
        case .professors:
            return "Professors"
        case .settings:
            return "Settings"
        }
    }
    
    var iconName: String {
        return "\(title.lowercased())-icon"
    }
}

struct MainTabbedView: View {
    
    @State var selectedTab = 0
    
    var body: some View {
        
        ZStack(alignment: .bottom) {
            TabView(selection: $selectedTab) {
                ForEach(TabbedItems.allCases, id: \.self) { item in
                    getViewForTab(item)
                        .tag(item.rawValue)
                }
            }

            ZStack {
                HStack {
                    ForEach(TabbedItems.allCases, id: \.self) { item in
                        Button {
                            selectedTab = item.rawValue
                        } label: {
                            CustomTabItem(imageName: item.iconName, title: item.title, isActive: (selectedTab == item.rawValue))
                        }
                    }
                }
                .padding(6)
            }
            .frame(height: 60)
            .background(Utilities().pastelColors[0].opacity(0.2))
            .cornerRadius(35)
            .padding(.horizontal, 26)
        }
    }
    
    func getViewForTab(_ item: TabbedItems) -> some View {
        switch item {
        case .classrooms:
            return AnyView(ClassroomsListView(classroomManager: ClassroomManager()))
        case .students:
            return AnyView(StudentsView())
        case .professors:
            return AnyView(ProfessorsView())
        case .settings:
            return AnyView(SettingsView())
        }
    }
}

extension MainTabbedView {
    func CustomTabItem(imageName: String, title: String, isActive: Bool) -> some View {
        HStack(spacing: 10) {
            Spacer()
            Image(imageName)
                .resizable()
                .renderingMode(.template)
                .foregroundColor(isActive ? .black : .gray)
                .frame(width: 20, height: 20)
            if isActive {
                Text(title)
                    .font(.system(size: 12))
                    .foregroundColor(isActive ? .black : .gray)
            }
            Spacer()
        }
        .frame(width: isActive ? nil : 60, height: 60)
        .background(isActive ? Utilities().pastelColors[0].opacity(0.4) : Color.clear)
        .cornerRadius(30)
    }
}
