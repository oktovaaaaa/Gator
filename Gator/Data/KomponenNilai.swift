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
    
    // PERBARUI INIT DI SINI
    init(nama: String, bobot: Double, mataKuliah: MataKuliah) {
        self.nama = nama
        self.bobot = bobot
        self.mataKuliah = mataKuliah
    }
}   
