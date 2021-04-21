//
//  ScheduleCardView.swift
//  SMHS Schedule
//
//  Created by Jevon Mao on 3/15/21.
//

import SwiftUI

struct ClassScheduleView: View {
    var body: some View {
        VStack{
            Divider()
            HStack{
                Spacer()
            }
            Spacer()

        }
        .background(Color.primary)
        .frame(maxHeight: 500)
        .clipShape(RoundedRectangle(cornerRadius: 15, style: .continuous))
        .padding(.horizontal, 35)
        .shadow(color: Color.primary.opacity(0.5), radius: 12, x: 6, y: 6)
        
        
    }
}

struct ScheduleCardView_Previews: PreviewProvider {
    static var previews: some View {
        ClassScheduleView()
    }
}
