//
//  NationDetailsProvider.swift
//  NationStatesClient
//
//  Created by Bart Kneepkens on 24/11/2020.
//

import Combine

protocol NationDetailsProvider {
    func fetchDetails() -> AnyPublisher<Nation?, APIError>
}
