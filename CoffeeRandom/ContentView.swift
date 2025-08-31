//
//  ContentView.swift
//  CoffeeRandom
//
//  Created by Numwhan on 31/8/2568 BE.
//


import SwiftUI

struct Drink: Identifiable {
    let id = UUID()
    let name: String
    let imageName: String
}

struct ContentView: View {
    @State private var drinks = [
        Drink(name: "Latte", imageName: "latte"),
        Drink(name: "Cappu", imageName: "cappu"),
        Drink(name: "Pink Drink", imageName: "pinkmilk"),
        Drink(name: "Orange Juice", imageName: "orange"),
        Drink(name: "Milk Tea", imageName: "milktea"),
        Drink(name: "Iced Coffee", imageName: "caramel"),
        Drink(name: "Strawberry Soda", imageName: "strawberry")
    ]
    
    @State private var rotationAngle: Double = 0
    @State private var isSpinning = false
    @State private var selectedIndex: Int? = nil
    @State private var timer: Timer?

    var body: some View {
        ZStack {
            Color(red: 228/255, green: 226/255, blue: 211/255)
                .ignoresSafeArea()

            VStack(spacing: 20) {
                Text("WELCOME")
                    .font(.largeTitle)
                    .bold()
                    .offset(y: 5)
                Text("MENU")
                    .font(.title2)
                    .foregroundColor(.gray)
                    .offset(y: -15)
                
                ZStack {
                    ForEach(drinks.indices, id: \.self) { index in
                        let angle = Double(index) / Double(drinks.count) * 360
                        let isSelected = selectedIndex == index
                        
                        let radians = (angle + rotationAngle) * .pi / 180
                        let xOffset = cos(radians) * 120
                        let yOffset = sin(radians) * 120
                        
                        Image(drinks[index].imageName)
                            .resizable()
                            .scaledToFit()
                            .frame(width: isSelected ? 150 : 80,
                                   height: isSelected ? 150 : 80)
                            .opacity(isSelected ? 1.0 : 0.7)
                            .offset(x: xOffset, y: yOffset)
                            .animation(.easeInOut(duration: 0.3), value: selectedIndex)
                    }

                }
                .frame(width: 300, height: 300)
                
             
                ZStack {
                    Image("Home")
                        .resizable()
                        .scaledToFit()
                        .frame(height: 350)
                        .offset(y: 30)

                    Button(action: startSpinning) {
                        Image("start")
                            .resizable()
                            .scaledToFit()
                            .frame(width: 220, height: 60)
                            .shadow(radius: 5)
                            .cornerRadius(10)
                    }
                    .offset(y: -120)
                }
            }
        }
    }
    
    func startSpinning() {
        isSpinning = true
        selectedIndex = nil
        timer?.invalidate()
        
        var spinsRemaining = Int.random(in: 20...30)
        
        timer = Timer.scheduledTimer(withTimeInterval: 0.1, repeats: true) { t in
            withAnimation(.linear(duration: 0.1)) {
                rotationAngle += 30
            }
            spinsRemaining -= 1
            if spinsRemaining <= 0 {
                t.invalidate()
                timer = nil
                isSpinning = false
                // เลือกแก้วจากตำแหน่งด้านบน (มุม 0 องศา)
                let normalized = (360 - rotationAngle.truncatingRemainder(dividingBy: 360)).truncatingRemainder(dividingBy: 360)
                let closestIndex = drinks.indices.min(by: {
                    abs(Double($0)/Double(drinks.count)*360 - normalized) <
                    abs(Double($1)/Double(drinks.count)*360 - normalized)
                }) ?? 0
                withAnimation(.spring()) {
                    selectedIndex = closestIndex
                }
            }
        }
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
