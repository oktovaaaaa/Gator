//
//  KomponenNilai.swift
//  Gator
//
//  Created by Foundation-009 on 30/06/25.
//

import Foundation
import SwiftData

@Model
final class KomponenNilai {
    @Attribute(.unique) var id: UUID = UUID() 

    var nama: String
    var bobot: Double
    var nilaiAktual: Double?
    var mataKuliah: MataKuliah?

    // ✅ Init lengkap
    init(nama: String, bobot: Double, nilaiAktual: Double? = nil, mataKuliah: MataKuliah) {
        self.id = UUID()
        self.nama = nama
        self.bobot = bobot
        self.nilaiAktual = nilaiAktual
        self.mataKuliah = mataKuliah
    }
}
