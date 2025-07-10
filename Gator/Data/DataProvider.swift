//
//  DataProvider.swift
//  Gator
//
//  Created by Foundation-009 on 07/07/25.
//


import Foundation
import SwiftData

enum DataProvider {
    static func generate(context: ModelContext) {
        // Cek agar data tidak dibuat berulang kali
        let descriptor = FetchDescriptor<Jurusan>()
        guard (try? context.fetch(descriptor))?.isEmpty == true else { return }
        
        // Panggil data dari setiap file dan simpan ke database
        context.insert(D3TI_Data.create())
        context.insert(D3TK_Data.create())
        context.insert(D4TRPL_Data.create())
        context.insert(S1IF_Data.create())
        context.insert(S1MR_Data.create())
        context.insert(S1SI_Data.create())
        context.insert(S1TB_Data.create())
        context.insert(S1TE_Data.create())
        context.insert(S1TM_Data.create())
    }
}