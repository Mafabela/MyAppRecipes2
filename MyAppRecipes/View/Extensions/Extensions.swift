//
//  Extensions.swift
//  MyAppRecipes
//
//  Created by Consultant on 1/22/23.
//

import SwiftUI

//MARK: View Extension for UI Building
extension View {
    //Closing All Active Keyboards
    func closeKeyboard(){
        UIApplication.shared.sendAction(#selector(UIResponder.resignFirstResponder), to: nil, from: nil, for: nil)
    }
    
    //MARK: Disabling with opacity
    func disableWithOpacity(_ condition: Bool) -> some View {
        self
            .disabled(condition)
            .opacity(condition ? 0.6 : 1)
    }
    
    func hAlign(_ alignament: Alignment) -> some View {
        self
            .frame(maxWidth: .infinity, alignment: alignament)
    }
    
    func VAlign(_ alignament: Alignment) -> some View {
        self
            .frame(maxHeight: .infinity, alignment: alignament)
    }
    
    //MARK: Custom Border View whit padding
    func border(_ width: CGFloat,_ color: Color) -> some View {
        self
            .padding(.horizontal, 15)
            .padding(.vertical, 15)
            .background{
                RoundedRectangle(cornerRadius: 5, style: .continuous)
                    .stroke(color, lineWidth: width)
            }
    }
    
    //MARK: Custom Fill View whit padding
    func fillView(_ color: Color) -> some View {
        self
            .padding(.horizontal, 15)
            .padding(.vertical, 15)
            .background{
                RoundedRectangle(cornerRadius: 5, style: .continuous)
                    .fill(color)
            }
    }
    
    func cornerRadius(_ radius: CGFloat, corners: UIRectCorner) -> some View{
        clipShape(RoundedCorner(radius: radius, corners: corners) )
    }
//    func backColor(){
//        self
//            .background(
//        LinearGradient(colors: [.orange, Color("Peach"), .white], startPoint: .bottom, endPoint: .top)
//            .edgesIgnoringSafeArea(.all))
//    }
    
}
struct RoundedCorner: Shape {
    var radius: CGFloat = .infinity
    var corners: UIRectCorner = .allCorners
    
    func path(in rect: CGRect) -> Path {
        let path = UIBezierPath(roundedRect: rect, byRoundingCorners: corners, cornerRadii: CGSize(width: radius, height: radius))
        return Path(path.cgPath)
    }
}
