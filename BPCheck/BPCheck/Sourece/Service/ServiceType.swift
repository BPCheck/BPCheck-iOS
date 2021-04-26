//
//  ServiceType.swift
//  BPCheck
//
//  Created by 이가영 on 2021/04/20.
//

import Foundation
import RxSwift

protocol ServiceType {
    typealias ReturnState = Observable<StatusRules>
    typealias ReturnStateWithData<T> = Single<(T, StatusRules)>
}

protocol ServiceBasic: ServiceType {
    func signIn(_ userId: String, _ password: String) -> ReturnState
    func signUp(_ userId: String, _ name: String, _ password: String) -> ReturnState
    func getMainFeed() -> ReturnStateWithData<Main>
    func postMeasureBp(_ highBp: String, _ lowBp: String, _ pulse: String, _ date: String) -> ReturnState
    func deleteBp(_ ID: String) -> ReturnState
    func postRegisterHospital(_ hospitalName: String, _ hospitalNumber: String) -> ReturnState
    func deleteHospital(_ ID: String) -> ReturnState
    func selectFavoritHospital(_ ID: String) -> ReturnState
    func deselectFavoritHospital(_ ID: String) -> ReturnState
    func getOnlyLowBp() -> ReturnStateWithData<OnlyLowBp>
    func getOnlyHighBp() -> ReturnStateWithData<OnlyHighBp>
    func getAllBp() -> ReturnStateWithData<AllBp>
    func getHospital() -> ReturnStateWithData<HospitalInfo>
}
