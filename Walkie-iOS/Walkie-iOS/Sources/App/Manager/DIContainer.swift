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
    
    // Singleton ViewModels
    private lazy var homeViewModel: HomeViewModel = {
        HomeViewModel(
            getEggPlayUseCase: DefaultGetEggPlayUseCase(
                memberRepository: memberRepo
            ),
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
    }()
    private lazy var mapViewModel: MapViewModel = {
        MapViewModel(
            getCharacterPlayUseCase: DefaultGetCharacterPlayUseCase(
                memberRepository: memberRepo
            )
        )
    }()
    private lazy var mypageMainViewModel: MypageMainViewModel = {
        MypageMainViewModel(
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
    }()
    private lazy var eggViewModel: EggViewModel = {
        EggViewModel(
            eggUseCase: DefaultEggUseCase(
                eggRepository: eggRepo,
                memberRepository: memberRepo
            )
        )
    }()
    private lazy var alarmListViewModel: AlarmListViewModel = {
        AlarmListViewModel()
    }()
    private lazy var reviewViewModel: ReviewViewModel = {
        ReviewViewModel(
            reviewUseCase: DefaultReviewUseCase(
                reviewRepository: reviewRepo
            )
        )
    }()
    private lazy var characterViewModel: CharacterViewModel = {
        CharacterViewModel(
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
    }()
    private lazy var loginViewModel: LoginViewModel = {
        LoginViewModel(
            loginUseCase: DefaultLoginUseCase(
                authRepository: authRepo,
                memberRepository: memberRepo
            )
        )
    }()
    private lazy var signupViewModel: SignupViewModel = {
        SignupViewModel(
            signupUseCase: DefaultSignupUseCase(
                authRepository: authRepo,
                memberRepository: memberRepo
            )
        )
    }()
    private lazy var hatchEggViewModel: HatchEggViewModel = {
        HatchEggViewModel(
            getEggPlayUseCase: DefaultGetEggPlayUseCase(
                memberRepository: memberRepo
            ),
            updateEggStepUseCase: DefaultUpdateEggStepUseCase(
                eggRepository: eggRepo
            )
        )
    }()
}

extension DIContainer {
    
    // MARK: - Main Views
    func buildHomeView() -> HomeView {
        return HomeView(viewModel: homeViewModel)
    }
    func buildMapView() -> MapView {
        return MapView(viewModel: mapViewModel)
    }
    func buildMypageView() -> MypageMainView {
        return MypageMainView(viewModel: mypageMainViewModel)
    }
    func buildEggView() -> EggView {
        return EggView(viewModel: eggViewModel)
    }
    func buildAlarmListView() -> AlarmListView {
        return AlarmListView(viewModel: alarmListViewModel)
    }
    func buildReviewView() -> ReviewView {
        return ReviewView(viewModel: reviewViewModel)
    }
    func buildCharacterView() -> CharacterView {
        return CharacterView(viewModel: characterViewModel)
    }
    
    // MARK: - Onboarding Views
    func buildLoginView() -> LoginView {
        return LoginView(loginViewModel: loginViewModel)
    }
    func buildSignupView() -> OnboardingCompleteView {
        return OnboardingCompleteView()
    }
    func buildNicknameView() -> NicknameView {
        return NicknameView(signupViewModel: signupViewModel)
    }
    func buildHatchEggView() -> HatchEggView {
        return HatchEggView(hatchEggViewModel: hatchEggViewModel)
    }
    
    // MARK: - UseCases
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
