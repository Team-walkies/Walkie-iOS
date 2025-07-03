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
    
    private lazy var updateStepForegroundUseCase = DefaultUpdateStepForegroundUseCase(store: stepStatusStore)
    private lazy var updateStepBackgroundUseCase = DefaultUpdateStepBackgroundUseCase(store: stepStatusStore)
    private lazy var checkHatchConditionUseCase = DefaultCheckHatchConditionUseCase(store: stepStatusStore)
    
    lazy var stepStatusStore = DefaultStepStatusStore()
}

// UseCases

extension DIContainer {
    
    func resolveUpdateEggStepUseCase() -> UpdateEggStepUseCase {
        return DefaultUpdateEggStepUseCase(eggRepository: eggRepo, stepStatusStore: stepStatusStore)
    }
    
    func resolveGetEggPlayUseCase() -> GetEggPlayUseCase {
        return DefaultGetEggPlayUseCase(memberRepository: memberRepo, stepStatusStore: stepStatusStore)
    }
    
    func resolveUpdateStepForegroundUseCase() -> UpdateStepForegroundUseCase {
        return updateStepForegroundUseCase
    }
    
    func resolveUpdateStepBackgroundUseCase() -> UpdateStepBackgroundUseCase {
        return updateStepBackgroundUseCase
    }
    
    func resolveCheckHatchConditionUseCase() -> CheckHatchConditionUseCase {
        return checkHatchConditionUseCase
    }
}

// ViewModels

extension DIContainer {
    
    func makeSplashViewModel(
        appCoordinator: AppCoordinator
    ) -> SplashViewModel {
        return SplashViewModel(
            appCoordinator: appCoordinator,
            getProfileUseCase: DefaultGetProfileUseCase(
                memberRepository: memberRepo,
                stepStatusStore: stepStatusStore
            )
        )
    }
    
    func makeHomeViewModel(appCoordinator: AppCoordinator) -> HomeViewModel {
        return HomeViewModel(
            getEggPlayUseCase: resolveGetEggPlayUseCase(),
            getCharacterPlayUseCase: DefaultGetWalkingCharacterUseCase(
                memberRepository: memberRepo,
                stepStatusStore: stepStatusStore
            ),
            getEggCountUseCase: DefaultGetEggCountUseCase(
                eggRepository: eggRepo, stepStatusStore: stepStatusStore
            ),
            getCharactersCountUseCase: DefaultGetCharactersCountUseCase(
                characterRepository: characterRepo
            ),
            getRecordedSpotUseCase: DefaultRecordedSpotUseCase(
                memberRepository: memberRepo,
                stepStatusStore: stepStatusStore
            ),
            appCoordinator: appCoordinator,
            stepStatusStore: stepStatusStore,
            getEventEggUseCase: DefaultGetEventEggUseCase(
                eggRepository: eggRepo,
                stepStatusStore: stepStatusStore
            )
        )
    }
    
    func makeMapViewModel() -> MapViewModel {
        return MapViewModel(
            getCharacterPlayUseCase: DefaultGetCharacterPlayUseCase(
                memberRepository: memberRepo,
                stepStatusStore: stepStatusStore
            )
        )
    }
    
    func makeReviewViewModel() -> ReviewViewModel {
        return ReviewViewModel(
            reviewUseCase: DefaultReviewUseCase(reviewRepository: reviewRepo),
            delReviewUseCase: DefaultDeleteReviewUseCase(reviewRepository: reviewRepo)
        )
    }
    
    func makeMypageMainViewModel(appCoordinator: AppCoordinator) -> MypageMainViewModel {
        return MypageMainViewModel(
            appCoordinator: appCoordinator,
            logoutUseCase: DefaultLogoutUserUseCase(
                authRepository: authRepo,
                memberRepository: memberRepo,
                stepStatusStore: stepStatusStore
            ),
            getProfileUseCase: DefaultGetProfileUseCase(
                memberRepository: memberRepo,
                stepStatusStore: stepStatusStore
            )
        )
    }
    
    func makeMypageMyInformationViewModel(
        appCoordinator: AppCoordinator,
        isPublic: Bool
    ) -> MypageMyInformationViewModel {
        return MypageMyInformationViewModel(
            appCoordinator: appCoordinator,
            patchProfileUseCase: DefaultPatchProfileUseCase(
                memberRepository: memberRepo,
                stepStatusStore: stepStatusStore
            ),
            isPublic: isPublic
        )
    }
    
    func makeCalendarViewModel(using reviewVM: ReviewViewModel) -> CalendarViewModel {
        return CalendarViewModel(reviewViewModel: reviewVM)
    }
    
    func makeEggViewModel(appCoordinator: AppCoordinator) -> EggViewModel {
        return EggViewModel(
            eggUseCase: DefaultEggUseCase(
                eggRepository: eggRepo,
                memberRepository: memberRepo,
                stepStatusStore: stepStatusStore
            ),
            appCoordinator: appCoordinator
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
                memberRepository: memberRepo,
                stepStatusStore: stepStatusStore
            )
        )
    }
    
    func makeLoginViewModel() -> LoginViewModel {
        return LoginViewModel(
            loginUseCase: DefaultLoginUseCase(
                authRepository: authRepo,
                memberRepository: memberRepo,
                stepStatusStore: stepStatusStore
            )
        )
    }
    
    func makeSignupViewModel() -> SignupViewModel {
        return SignupViewModel(
            signupUseCase: DefaultSignupUseCase(
                authRepository: authRepo,
                memberRepository: memberRepo,
                stepStatusStore: stepStatusStore
            )
        )
    }
    
    func makeHatchEggViewModel() -> HatchEggViewModel {
        return HatchEggViewModel(
            getEggPlayUseCase: resolveGetEggPlayUseCase(),
            hatchEggUseCase: DefaultHatchEggUseCase(
                eggRepository: eggRepo,
                stepStatusStore: stepStatusStore
            )
        )
    }
    
    func makeAlarmListViewModel() -> AlarmListViewModel {
        return AlarmListViewModel()
    }
}

extension DIContainer {
    
    func buildSplashView(
        appCoordinator: AppCoordinator
    ) -> SplashView {
        return SplashView(
            splashViewModel: self.makeSplashViewModel(
                appCoordinator: appCoordinator
            )
        )
    }
    
    // MARK: - Main Views
    func buildTabBarView() -> TabBarView {
        return TabBarView()
    }
    
    func buildHomeView(appCoordinator: AppCoordinator) -> HomeView {
        return HomeView(
            viewModel: self.makeHomeViewModel(appCoordinator: appCoordinator)
        )
    }
    
    func buildMapView() -> MapView {
        return MapView(
            viewModel: self.makeMapViewModel()
        )
    }
    
    func buildMypageView(appCoordinator: AppCoordinator) -> MypageMainView {
        return MypageMainView(
            viewModel: self.makeMypageMainViewModel(appCoordinator: appCoordinator)
        )
    }
    
    func buildEggView(appCoordinator: AppCoordinator) -> EggView {
        return EggView(
            viewModel: self.makeEggViewModel(appCoordinator: appCoordinator)
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
    
    func buildWithdrawView(appCoordinator: AppCoordinator, nickname: String) -> MypageWithdrawView {
        return MypageWithdrawView(
            viewModel: MypageWithdrawViewModel(
                appCoordinator: appCoordinator,
                withdrawUseCase: DefaultWithdrawUseCase(
                    memberRepository: self.memberRepo,
                    stepStatusStore: self.stepStatusStore
                ),
                nickname: nickname
            )
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
