//
//  UserService.swift
//  NihonGoal
//
//  Created by kuroro on 02/09/2020.
//  Copyright © 2020 lucasam. All rights reserved.
//

import UIKit
import FirebaseFirestore
import FirebaseAuth

struct UserDatas {
    var name: String
    var email: String
    var hiraganaTab: [String]
    var katakanTab: [String]
}

enum AuthentificationError: Error {
    case invalidEmail
    case wrongPassword
    case emailAlreadyInUse
    case userNotFound
    case error

    func errorDescription() -> String {
        switch self {
        case .invalidEmail: return "Email incorrect !"
        case .wrongPassword: return "Mot de passe incorrect !"
        case .emailAlreadyInUse: return "Cette email est déjà utilisé !"
        case .userNotFound: return "Aucun compte n'existe avec ces identifiants."
        case .error: return "Une erreur est survenue, veuillez relancer l'application en vérifiant que votre connexion internet est bien active."
        }
    }
}

class UserController {
    // MARK: Property
    private lazy var db = Firestore.firestore()

    // MARK: Methods
    func handlingError(error: Error) -> AuthentificationError {
        if let errCode = AuthErrorCode(rawValue: error._code) {

            switch errCode {
            case .invalidEmail:
                return AuthentificationError.invalidEmail
            case .wrongPassword:
                return AuthentificationError.wrongPassword
            case .emailAlreadyInUse:
                return AuthentificationError.emailAlreadyInUse
            case .userNotFound:
                return AuthentificationError.userNotFound
            default:
                return AuthentificationError.error
            }
        }
        return AuthentificationError.error
    }
    
    func getUser(completionHandler: @escaping (Result<UserDatas, AuthentificationError>) -> Void) {
        let docRef = db.collection("Users").document(Auth.auth().currentUser?.uid ?? "")
        
        docRef.getDocument { (document, error) in
            if let document = document, document.exists {
                let dataDescription = document.data()
                let name = dataDescription?["firstName"] as? String ?? ""
                let email = dataDescription?["mail"] as? String ?? ""
                let hiraganaTab = dataDescription?["hiraganaTab"] as? [String] ?? []
                let katakanaTab = dataDescription?["katakanaTab"] as? [String] ?? []
                let userDatas = UserDatas(name: name, email: email, hiraganaTab: hiraganaTab, katakanTab: katakanaTab)
                
                completionHandler(.success(userDatas))
            } else {
                completionHandler(.failure(AuthentificationError.error))
            }
        }
    }

    func connexion(email: String, password: String, completionHandler: @escaping (AuthentificationError?) -> Void) {
        Auth.auth().signIn(withEmail: email, password: password) { authResult, error in
            if let error = error {
                completionHandler(self.handlingError(error: error))
            } else if authResult != nil {
                completionHandler(nil)
            }
        }
    }

    func inscription(email: String, password: String, completionHandler: @escaping (Result<AuthDataResult, AuthentificationError>) -> Void) {
        Auth.auth().createUser(withEmail: email, password: password) { (result, err) in
            if let err = err {
                completionHandler(.failure(self.handlingError(error: err)))
            } else {
                guard let result = result else {
                    return
                }
                completionHandler(.success(result))
            }
        }
    }

    func signOut(completionHandler: @escaping (Bool) -> Void) {
        let firebaseAuth = Auth.auth()
        do {
            try firebaseAuth.signOut()
            completionHandler(true)
        } catch let signOutError as NSError {
            print(signOutError)
            completionHandler(false)
        }
    }

    func resetPassword(email: String, completionHandler: @escaping (Bool) -> Void) {
        Auth.auth().sendPasswordReset(withEmail: email) { error in
            if error != nil {
                completionHandler(false)
            } else {
                completionHandler(true)
            }
        }
    }

    func addNewUserToDB(lastName: String, firstName: String, uid: String, email: String, hiraganaTab: [String], katakanaTab: [String], completionHandler: @escaping (Bool) -> Void) {
        self.db.collection("Users").document(uid).setData(["lastName": lastName, "firstName": firstName, "uid": uid, "mail": email, "hiraganaTab": hiraganaTab, "katakanaTab": katakanaTab]) { (error) in
            if error != nil {
                completionHandler(false)
            }
            completionHandler(true)
        }
    }

    func getSpecificData(collection: String, document: String, field: String, completionHandler: @escaping (Result<Any, AuthentificationError>) -> Void) {
        let docRef = db.collection(collection).document(document)

        docRef.getDocument { (document, error) in
            if let document = document, document.exists {
                let dataDescription = document.data()
                let returnedValue = dataDescription?[field]
                completionHandler(.success(returnedValue ?? (Any).self))
            } else {
                completionHandler(.failure(AuthentificationError.error))
            }
        }
    }

    func updateSpecificData(collection: String, document: String, field: String, newValue: Any, completionHandler: @escaping (Bool) -> Void) {
        let documentRef = db.collection(collection).document(document)

        documentRef.updateData([
            field: newValue
        ]) { err in
            if err != nil {
                completionHandler(false)
            } else {
                completionHandler(true)
            }
        }
    }
}
