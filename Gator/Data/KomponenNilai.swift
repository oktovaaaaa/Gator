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
    var nama: String
    var bobot: Double
    var nilaiAktual: Double?
    var mataKuliah: MataKuliah?

    init(nama: String, bobot: Double, nilaiAktual: Double? = nil, mataKuliah: MataKuliah) {
        self.nama = nama
        self.bobot = bobot
        self.nilaiAktual = nilaiAktual
        self.mataKuliah = mataKuliah
    }
}
