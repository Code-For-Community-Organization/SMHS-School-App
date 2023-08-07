//
//  Classrooms.swift
//  SMHS
//
//  Created by Jevon Mao on 8/4/23.
//

import Foundation

enum Classroom: String, Codable, CaseIterable, CustomStringConvertible, Comparable {
    static func < (lhs: Classroom, rhs: Classroom) -> Bool {
        lhs.rawValue.compare(rhs.rawValue, options: .numeric) == .orderedAscending
    }

    var description: String {
        return self.rawValue
    }
    case aBuilding = "A Building"
    case bBuilding = "B Building"
    case cBuilding = "C Building"
    case sBuilding = "S Building"
    case trailers = "Trailers"
    case storage = "Storage"
    case rr = "RR"
    case a146 = "A146"
    case a142 = "A142"
    case a144 = "A144"
    case a151 = "A151"
    case a145 = "A145"
    case a150 = "A150"
    case a149 = "A149"
    case a147 = "A147"
    case a148 = "A148"
    case a152 = "A152"
    case a153 = "A153"
    case b107 = "B107"
    case b108 = "B108"
    case b105 = "B105"
    case b109 = "B109"
    case b115 = "B115"
    case b110 = "B110"
    case b111 = "B111"
    case b112 = "B112"
    case b113 = "B113"
    case b114 = "B114"
    case b207 = "B207"
    case b208 = "B208"
    case b206 = "B206"
    case b209 = "B209"
    case b220 = "B220"
    case b210 = "B210"
    case b212 = "B212"
    case b213 = "B213"
    case b214 = "B214"
    case b215 = "B215"
    case b216 = "B216"
    case b217 = "B217"
    case b218 = "B218"
    case b219 = "B219"
    case r215 = "R215"
    case g112 = "G112"
    case g119 = "G119"
    case g118 = "G118"
    case g117 = "G117"
    case g113 = "G113"
    case g114 = "G114"
    case g115 = "G115"
    case g116 = "G116"
    case g207 = "G207"
    case g210 = "G210"
    case g211 = "G211"
    case g206 = "G206"
    case g205 = "G205"
    case g212 = "G212"
    case g229 = "G229"
    case g204 = "G204"
    case g220 = "G220"
    case g213 = "G213"
    case g217 = "G217"
    case g219 = "G219"
    case g214 = "G214"
    case g218 = "G218"
    case g215 = "G215"
    case g216 = "G216"
    case g311 = "G311"
    case g310 = "G310"
    case g301 = "G301"
    case g309 = "G309"
    case g302 = "G302"
    case g308 = "G308"
    case g303 = "G303"
    case g307 = "G307"
    case g304 = "G304"
    case g306 = "G306"
    case g305 = "G305"
    case s129 = "S129"
    case s130B = "S130B"
    case s131B = "S131B"
    case s130A = "S130A"
    case s131A = "S131A"
    case etv = "ETV"
    case s208 = "S208"
    case s209 = "S209"
    case s210 = "S210"
    case s211 = "S211"
    case s212 = "S212"
    case s205 = "S205"
    case s204 = "S204"
    case s203 = "S203"
    case s202 = "S202"
    case s201 = "S201"
    case c101 = "C101"
    case c102 = "C102"
    case c104 = "C104"
    case c112 = "C112"
    case c109 = "C109"
    case c110 = "C110"
    case c103 = "C103"
    case c105 = "C105"
    case c113 = "C113"
    case c111 = "C111"
    case c108 = "C108"
    case t8 = "T8"
    case t9 = "T9"
    case t10 = "T10"
    case weight = "Weight Room"
    case asp = "ASP Testing Center"
}
