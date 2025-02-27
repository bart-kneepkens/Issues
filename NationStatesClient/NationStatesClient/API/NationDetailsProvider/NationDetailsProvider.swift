//
//  NationDetailsProvider.swift
//  NationStatesClient
//
//  Created by Bart Kneepkens on 24/11/2020.
//

import Combine

protocol NationDetailsProvider {
    var nationDetails: CurrentValueSubject<Nation?, Never> { get }
    func fetchCurrentNationDetails() async
    func fetchNationDetails(for nationName: String) async throws -> Nation?
}
