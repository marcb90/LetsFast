//
//  ProgressRing.swift
//  LetsFast
//
//  Created by Marc Biggar on 06/05/2022.
//

import SwiftUI

struct ProgressRing: View {
    @EnvironmentObject var fastingManager: FastingManager
    
    
    let timer = Timer
        .publish(every: 1, on: .main, in: .common)
        .autoconnect()
    
    var body: some View {
        ZStack {
            // MARK: Placeholder Ring
            
            Circle()
                .stroke(lineWidth: 20)
                .foregroundColor(.gray)
                .opacity(0.1)
            
            // MARK: Colored Ring
            
            Circle()
                .trim(from: 0.0, to: min(fastingManager.progress, 1.0))
                .stroke(AngularGradient(gradient: Gradient(colors: [Color(#colorLiteral(red: 0, green: 0.4151187241, blue: 0.7681056261, alpha: 1)), Color(#colorLiteral(red: 0.80578053, green: 0.2247284651, blue: 0.5584149361, alpha: 1)), Color(#colorLiteral(red: 0.7749753594, green: 0.5651600957, blue: 0.6199502945, alpha: 1)), Color(#colorLiteral(red: 0, green: 0.7549886107, blue: 0.7241036296, alpha: 1)), Color(#colorLiteral(red: 0, green: 0.386603862, blue: 0.7690050006, alpha: 1))]), center: .center), style: StrokeStyle(lineWidth: 15.0, lineCap: .round, lineJoin: .round))
                .rotationEffect(Angle(degrees: 270))
                .animation(.easeInOut(duration: 1.0), value: fastingManager.progress)
            
            VStack(spacing: 30) {
                
                if fastingManager.fastingState == .notStarted {
                    // MARK: Upcoming Fast
                    VStack(spacing: 5) {
                        Text("Upcoming fast")
                            .opacity(0.7)
                        
                        Text("\(fastingManager.fastingPlan.fastingPeriod.formatted()) Hours")
                            .font(.title)
                            .fontWeight(.bold)
                    }
                } else {
                    // MARK: Elapsed Time
                    
                    VStack(spacing: 5) {
                        Text("Elapsed Time (\(fastingManager.progress.formatted(.percent))")
                            .opacity(0.7)
                        
                        Text(fastingManager.startTime, style: .timer)
                            .font(.title)
                            .fontWeight(.bold)
                    }
                    .padding(.top)
                    
                    //MARK: Remaining Time
                    
                    VStack(spacing: 5) {
                        if !fastingManager.elapsed {
                            Text("Remaining Time (\(( 1 - fastingManager.progress).formatted(.percent))")
                                .opacity(0.7)
                        } else {
                            Text("Extra Time")
                                .opacity(0.7)
                        }
                       
                        
                        Text(fastingManager.endTime, style: .timer)
                            .font(.title2)
                            .fontWeight(.bold)
                    }
                }
                
            }
        }
        .frame(width: 250, height: 250)
        .padding()
//        .onAppear{
//            progress = 1
//        }
        .onReceive(timer) { _ in
            fastingManager.track()
        }
    }
}

struct ProgressRing_Previews: PreviewProvider {
    static var previews: some View {
        ProgressRing()
            .environmentObject(FastingManager())
    }
}
