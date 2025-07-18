//
//  URLConstant.swift
//  Walkie-iOS
//
//  Created by ahra on 3/11/25.
//

import Foundation

enum URLConstant {
    
    // MARK: - Base URL
    
    static let baseURL = Config.baseURL
    
    // MARK: - AppStore URL
    
    static let appStoreURL = "itms-apps://itunes.apple.com/app/id6742345668"
    
    // MARK: - URL Path
    
    // auth
    static let authLogin = "/auth/login"
    static let authLogout = "/auth/logout"
    static let authRefresh = "/auth/refresh"
    static let authSignup = "/auth/signup"
    
    // members
    static let members = "/members"
    static let membersCharacters = "/members/characters/play"
    static let membersEggs = "/members/eggs/play"
    static let membersProfile = "/members/profile/visibility"
    static let membersRecordedSpot = "/members/recorded-spot"
    
    // spots
    static let spots = "/spots"
    static let spotsPause = "/spots/pause"
    static let spotsComplete = "/spots/{spotId}"
    static let spotsVisitant = "/spots/curVisitant/{spotId}"
    
    // characters
    static let characters = "/characters"
    static let charactersCount = "/characters/count"
    static func charactersDetail(characterId: CLong) -> String { return "/characters/details/\(characterId)" }
    
    // eggs
    static let eggs = "/eggs"
    static let eggsStep = "/eggs/steps"
    static let eggsCount = "/eggs/count"
    static func eggsDetail(eggId: Int) -> String { return "/eggs/\(eggId)" }
    static let eventsDailyEgg = "/events/daily-egg"
    
    // reviews
    static let reviewsSpots = "/reviews/spots"
    static let reviews = "/reviews"
    static let reviewsEdit = "/reviews/{reviewId}"
    static let reviewCalendar = "/reviews/calendar"
    static let reviewCount = "/reviews/count/{spotId}"
    
    // notices
    static let notices = "/notices"
}
