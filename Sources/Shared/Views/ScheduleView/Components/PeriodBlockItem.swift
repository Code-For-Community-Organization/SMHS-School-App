//
//  PeriodBlockItem.swift
//  SMHSSchedule (iOS)
//
//  Created by Jevon Mao on 5/20/21.
//

import SwiftUI

struct PeriodBlockItem: View {
    var block: ClassPeriod
    var scheduleTitle: String
    var twoLine: Bool = false
    var body: some View {
        VStack(spacing: 5) {
            VStack {
                if twoLine {
                    doubleLineView
                }
                else {
                    singleLineView
                        .padding(.bottom, 8)
                }
                Spacer()
                Text(scheduleTitle)
                    .fontWeight(.medium)
                    .textAlign(.leading)
                    .font(.title3)
            }
            .padding(.horizontal)
            .padding(.vertical, 5)
            .foregroundColor(.platformTertiaryBackground)
            
        }
        .frame(maxWidth: .infinity)
        .background(.primary)
        .roundedCorners(cornerRadius: 12)
        .padding(.vertical, 5)
    }
    
    var doubleLineView: some View {
        VStack {
            Text("START: \(formatDate(block.startTime))")
                .fontWeight(.medium)
                .textAlign(.leading)
                .font(.footnote)
                .lineLimit(1)
                .minimumScaleFactor(0.5)
            Text("END: \(formatDate(block.endTime))")
                .fontWeight(.medium)
                .textAlign(.leading)
                .font(.footnote)
                .lineLimit(1)
                .minimumScaleFactor(0.5)
        }
    }
    
    var singleLineView: some View {
        GeometryReader {geo in
            HStack {
                HStack {
                    Text("START:")
                        .fontWeight(.medium)
                        .opacity(0.5)
                    Text(formatDate(block.startTime))
                        .fontWeight(.medium)
                }
                .frame(width: geo.size.width/CGFloat(2), alignment: .leading)
                HStack {
                    Text("END:")
                        .fontWeight(.medium)
                        .opacity(0.5)
                    Text(formatDate(block.endTime))
                        .fontWeight(.medium)
                }
                Spacer()
            }
            .font(.footnote)
        }
    }
    func formatDate(_ date: Date) -> String {
        let formatter = DateFormatter()
        formatter.dateFormat = "h:mm a"
        formatter.timeZone = TimeZone(secondsFromGMT: 0)
        return formatter.string(from: date)
    }
}

