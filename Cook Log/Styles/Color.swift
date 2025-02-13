import SwiftUI

extension Color {
    init(hex: Int, opacity: Double = 1.0) {
       let red = Double((hex & 0xff0000) >> 16) / 255.0
       let green = Double((hex & 0xff00) >> 8) / 255.0
       let blue = Double((hex & 0xff) >> 0) / 255.0
       self.init(.sRGB, red: red, green: green, blue: blue, opacity: opacity)
   }
    
    enum App {
        static let cocoaBean = Color(hex: 0x40211A)
        static let tundora = Color(hex: 0x404040)
        static let cherryWood = Color(hex: 0x661313)
        static let beaver = Color(hex: 0x8C695D)
        static let alto = Color(hex: 0xD9D9D9)
        static let zorba = Color(hex: 0xA6998A)
    }
 
    enum Text {
        static let main = Color(hex: 0x5F5F5F)
        static let error = Color(hex: 0xaa5F5F)
        
    }
}
