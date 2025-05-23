//
//  DIContainer.swift
//  Walkie-iOS
//
//  Created by ahra on 3/13/25.
//

import Foundation

final class DIContainer {
    static let shared = DIContainer()
    private init() {}
    
    // Singleton Services
    private lazy var reissueService = DefaultReissueService()
    private lazy var eggService = DefaultEggService(reissueService: reissueService)
    private lazy var memberService = DefaultMemberService(reissueService: reissueService)
    private lazy var reviewService = DefaultReviewService(reissueService: reissueService)
    private lazy var characterService = DefaultCharacterService(reissueService: reissueService)
    private lazy var authService = DefaultAuthService(reissueService: reissueService)
    
    // Singleton Repositories
    private lazy var eggRepo = DefaultEggRepository(eggService: eggService)
    private lazy var memberRepo = DefaultMemberRepository(memberService: memberService)
    private lazy var reviewRepo = DefaultReviewRepository(reviewService: reviewService)
    private lazy var characterRepo = DefaultCharacterRepository(characterService: characterService)
    private lazy var authRepo = DefaultAuthRepository(authService: authService)
    
    private lazy var stepStore = DefaultStepStore()
}

// UseCases

extension DIContainer {
    
    func resolveCheckStepUseCase() -> CheckStepUseCase {
        return DefaultCheckStepUseCase(stepStore: stepStore)
    }
    func resolveUpdateStepCacheUseCase() -> UpdateStepCacheUseCase {
        return DefaultUpdateStepCacheUseCase(stepStore: stepStore)
    }
    func resolveUpdateEggStepUseCase() -> UpdateEggStepUseCase {
        return DefaultUpdateEggStepUseCase(eggRepository: eggRepo)
    }
    
    func resolveGetEggPlayUseCase() -> GetEggPlayUseCase {
        return DefaultGetEggPlayUseCase(memberRepository: memberRepo)
    }
}

// ViewModels

extension DIContainer {
    
    func makeHomeViewModel() -> HomeViewModel {
        return HomeViewModel(
            getEggPlayUseCase: resolveGetEggPlayUseCase(),
            getCharacterPlayUseCase: DefaultGetWalkingCharacterUseCase(
                memberRepository: memberRepo
            ),
            getEggCountUseCase: DefaultGetEggCountUseCase(
                eggRepository: eggRepo
            ),
            getCharactersCountUseCase: DefaultGetCharactersCountUseCase(
                characterRepository: characterRepo
            ),
            getRecordedSpotUseCase: DefaultRecordedSpotUseCase(
                memberRepository: memberRepo
            )
        )
    }
    
    func makeMapViewModel() -> MapViewModel {
        return MapViewModel(
            getCharacterPlayUseCase: DefaultGetCharacterPlayUseCase(
                memberRepository: memberRepo
            )
        )
    }
    
    func makeReviewViewModel() -> ReviewViewModel {
        return ReviewViewModel(
            reviewUseCase: DefaultReviewUseCase(reviewRepository: reviewRepo),
            delReviewUseCase: DefaultDeleteReviewUseCase(reviewRepository: reviewRepo)
        )
    }
    
    func makeMypageMainViewModel() -> MypageMainViewModel {
        return MypageMainViewModel(
            logoutUseCase: DefaultLogoutUserUseCase(
                authRepository: authRepo,
                memberRepository: memberRepo
            ),
            patchProfileUseCase: DefaultPatchProfileUseCase(
                memberRepository: memberRepo
            ),
            getProfileUseCase: DefaultGetProfileUseCase(
                memberRepository: memberRepo
            ),
            withdrawUseCase: DefaultWithdrawUseCase(
                memberRepository: memberRepo
            )
        )
    }
    
    func makeCalendarViewModel(using reviewVM: ReviewViewModel) -> CalendarViewModel {
        return CalendarViewModel(reviewViewModel: reviewVM)
    }
    
    func makeEggViewModel() -> EggViewModel {
        return EggViewModel(
            eggUseCase: DefaultEggUseCase(
                eggRepository: eggRepo,
                memberRepository: memberRepo
            )
        )
    }
    
    func makeCharacterViewModel() -> CharacterViewModel {
        return CharacterViewModel(
            getCharactersListUseCase: DefaultGetCharactersListUseCase(
                characterRepository: characterRepo
            ),
            getCharactersDetailUseCase: DefaultGetCharactersDetailUseCase(
                characterRepository: characterRepo
            ),
            patchWalkingCharacterUseCase: DefaultPatchWalkingCharacterUseCase(
                memberRepository: memberRepo
            )
        )
    }
    
    func makeLoginViewModel() -> LoginViewModel {
        return LoginViewModel(
            loginUseCase: DefaultLoginUseCase(
                authRepository: authRepo,
                memberRepository: memberRepo
            )
        )
    }
    
    func makeSignupViewModel() -> SignupViewModel {
        return SignupViewModel(
            signupUseCase: DefaultSignupUseCase(
                authRepository: authRepo,
                memberRepository: memberRepo
            )
        )
    }
    
    func makeHatchEggViewModel() -> HatchEggViewModel {
        return HatchEggViewModel(
            getEggPlayUseCase: resolveGetEggPlayUseCase(),
            updateEggStepUseCase: DefaultUpdateEggStepUseCase(
                eggRepository: eggRepo
            )
        )
    }
    
    func makeAlarmListViewModel() -> AlarmListViewModel {
        return AlarmListViewModel()
    }
}

extension DIContainer {
    
    // MARK: - Main Views
    func buildHomeView() -> HomeView {
        return HomeView(
            viewModel: self.makeHomeViewModel()
        )
    }
    
    func buildMapView() -> MapView {
        return MapView(
            viewModel: self.makeMapViewModel()
        )
    }
    
    func buildMypageView() -> MypageMainView {
        return MypageMainView(
            viewModel: self.makeMypageMainViewModel()
        )
    }
    
    func buildEggView() -> EggView {
        return EggView(
            viewModel: self.makeEggViewModel()
        )
    }
    
    func buildReviewView() -> ReviewView {
        let reviewVM = makeReviewViewModel()
        let calendarVM = makeCalendarViewModel(using: reviewVM)
        return ReviewView(
            viewModel: reviewVM,
            calendarViewModel: calendarVM
        )
    }
    
    func buildCharacterView() -> CharacterView {
        return CharacterView(
            viewModel: self.makeCharacterViewModel()
        )
    }
    
    func buildAlarmListView() -> AlarmListView {
        return AlarmListView(
            viewModel: self.makeAlarmListViewModel()
        )
    }
    
    // MARK: - Onboarding Views
    func buildLoginView() -> LoginView {
        return LoginView(
            loginViewModel: self.makeLoginViewModel()
        )
    }
    
    func buildSignupView() -> OnboardingCompleteView {
        return OnboardingCompleteView()
    }
    
    func buildNicknameView() -> NicknameView {
        return NicknameView(
            signupViewModel: self.makeSignupViewModel()
        )
    }
    
    func buildHatchEggView() -> HatchEggView {
        return HatchEggView(
            hatchEggViewModel: self.makeHatchEggViewModel()
        )
    }
}
