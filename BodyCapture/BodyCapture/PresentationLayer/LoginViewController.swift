import UIKit
import AuthenticationServices

class LoginViewController: UIViewController {

    //var imageName = ""
    
    let logoImageView = {
        let logo = UIImageView()
        logo.backgroundColor = ThemeColor.blue2
        //logo.image = UIImage(named: <#T##String#>) 디자인 완료 후
        return logo
    }()
    
    let appleLoginButton = ASAuthorizationAppleIDButton()
    
    let kakaoLoginButton = {
        let button = UIButton()
        button.setImage(UIImage(named: "kakao_login_large_wide"), for: .normal)
        button.backgroundColor = UIColor(hex: "#FEE500")
        button.layer.cornerRadius = 12
        return button
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        configureUI()
    }
    //MARK: - AutoLayout + 추가적 ui설정
    func configureUI() {
        view.backgroundColor = .white
        appleLoginButton.addTarget(self, action: #selector(handleAppleIdRequest), for: .touchUpInside)
        view.addSubview(logoImageView)
        view.addSubview(appleLoginButton)
        view.addSubview(kakaoLoginButton)
        
        logoImageView.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            logoImageView.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            logoImageView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 150),
            logoImageView.widthAnchor.constraint(equalTo: view.widthAnchor, multiplier: 0.7),
            logoImageView.heightAnchor.constraint(equalTo: logoImageView.widthAnchor, multiplier: 0.6)
        ])
        
        appleLoginButton.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            appleLoginButton.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            appleLoginButton.bottomAnchor.constraint(equalTo: kakaoLoginButton.topAnchor, constant: -20),
            appleLoginButton.widthAnchor.constraint(equalTo: view.widthAnchor, multiplier: 0.8),
            appleLoginButton.heightAnchor.constraint(equalToConstant: 50)
        ])
        
        kakaoLoginButton.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            kakaoLoginButton.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            kakaoLoginButton.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor, constant: -20),
            kakaoLoginButton.widthAnchor.constraint(equalTo: appleLoginButton.widthAnchor),
            kakaoLoginButton.heightAnchor.constraint(equalTo: appleLoginButton.heightAnchor)
        ])
    }
    
    //MARK: - Helpers
    @objc func handleAppleIdRequest() {
        let appleIDProvider = ASAuthorizationAppleIDProvider()
        let request = appleIDProvider.createRequest()
        request.requestedScopes = [.fullName, .email]
        
        let authorizationController = ASAuthorizationController(authorizationRequests: [request])
        authorizationController.delegate = self
        authorizationController.performRequests()
    }

}

//apple로 로그인 버튼 눌렀을 때의 처리
extension LoginViewController: ASAuthorizationControllerDelegate {
    // 인증 성공 처리
    func authorizationController(controller: ASAuthorizationController, didCompleteWithAuthorization authorization: ASAuthorization) {
        
        print("Apple 로그인 인증 성공")
        let authenticateUserUseCase = AppleAuthenticateUserUseCase()
        authenticateUserUseCase.handleAuthorization(withAuthorization: authorization)
        }
    
    // 인증 실패 처리
    func authorizationController(controller: ASAuthorizationController, didCompleteWithError error: Error) {
        print("Apple 로그인 인증 실패: \(error.localizedDescription)")
    }
}
