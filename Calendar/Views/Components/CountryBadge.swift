//
//  CountryBadge.swift
//  Calendar
//
//  Created by Omar Sánchez on 29/03/25.
//

import SwiftUI

struct CountryBadge: View {
    let country: Country

    var body: some View {
        HStack {
            Text(country.flag)
            Text(country.name)
        }
        .padding(8)
        .padding(.horizontal, 8)
        .background(.ultraThinMaterial)
        .cornerRadius(20)
    }
}

#Preview(traits: .sizeThatFitsLayout) {
    CountryBadge(country: Country.mocks.first!)
}
