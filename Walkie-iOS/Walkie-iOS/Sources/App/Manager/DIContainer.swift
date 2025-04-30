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
    
    private lazy var reissueService = DefaultReissueService()
    private lazy var eggService = DefaultEggService(reissueService: reissueService)
    private lazy var memberService = DefaultMemberService(reissueService: reissueService)
    private lazy var reviewService = DefaultReviewService(reissueService: reissueService)
    private lazy var characterService = DefaultCharacterService(reissueService: reissueService)
    private lazy var authService = DefaultAuthService(reissueService: reissueService)
    
    private lazy var eggRepo = DefaultEggRepository(eggService: eggService)
    private lazy var memberRepo = DefaultMemberRepository(memberService: memberService)
    private lazy var reviewRepo = DefaultReviewRepository(reviewService: reviewService)
    private lazy var characterRepo = DefaultCharacterRepository(characterService: characterService)
    private lazy var authRepo = DefaultAuthRepository(authService: authService)
}

extension DIContainer {
    
    func buildHomeView() -> HomeView {
        return HomeView(viewModel: HomeViewModel(
            getEggPlayUseCase: DefaultGetEggPlayUseCase(
                memberRepository: memberRepo
            ),
            getCharacterPlayUseCase: DefaultGetWalkingCharacterUseCase(
                memberRepository: memberRepo
            ),
            getEggCountUseCase: DefaultGetEggCountUseCase(
                eggRepository: eggRepo
            ), getCharactersCountUseCase: DefaultGetCharactersCountUseCase(
                characterRepository: characterRepo
            )
        ))
    }
    
    func buildMapView() -> MapView {
        return MapView(viewModel: MapViewModel())
    }
    
    func buildMypageView() -> MypageMainView {
        return MypageMainView(viewModel: MypageMainViewModel())
    }
    
    func buildEggView() -> EggView {
        let eggVM = EggViewModel(
            eggUseCase: DefaultEggUseCase(
                eggRepository: eggRepo,
                memberRepository: memberRepo
            )
        )
        return EggView(viewModel: eggVM)
    }
    
    func buildAlarmListView() -> AlarmListView {
        return AlarmListView(viewModel: AlarmListViewModel())
    }
    
    func buildReviewView() -> ReviewView {
        return ReviewView(
            viewModel: ReviewViewModel(
                reviewUseCase: DefaultReviewUseCase(
                    reviewRepository: reviewRepo
                )
            )
        )
    }
    
    func buildCharacterView() -> CharacterView {
        return CharacterView(
            viewModel: CharacterViewModel(
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
        )
    }
    
    // Onboarding
    
    func buildLoginView() -> LoginView {
        return LoginView(
            loginViewModel: LoginViewModel(
                loginUseCase: DefaultLoginUseCase(
                    authRepository: authRepo,
                    memberRepository: memberRepo
                )
            )
        )
    }
    
    func buildSignupView() -> OnboardingCompleteView {
        return OnboardingCompleteView()
    }
    
    func buildNicknameView() -> NicknameView {
        return NicknameView(
            signupViewModel: SignupViewModel(
                signupUseCase: DefaultSignupUseCase(
                    authRepository: authRepo,
                    memberRepository: memberRepo
                )
            )
        )
    }
}
