//
//  AcessoBioView.swift
//  acessobio_plugin
//
//  Created by Lucas Diniz Silva on 18/02/21.
//

import UIKit
import Flutter

class AcessoBioView: UIViewController, AcessoBioManagerDelegate {
    
    private var method: String!
    var unicoCheck: AcessoBioManager!
    private var isOpenCamera: Bool =  false
    private var acessoBioStatus = true
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setUi()
        initAcessoBio()
        
        if(acessoBioStatus){ callMethodBio() }
    }
    
    func callMethodBio(){}
    
    override func viewWillAppear(_ animated: Bool) {
        if(isOpenCamera) {
            DispatchQueue.main.async {
                self.dismiss(animated: true, completion: nil)
            }
        }
        isOpenCamera = true
    }
    
    private func setUi() {
        self.view.backgroundColor = UIColor(white: 1, alpha: 0.0)
        self.navigationController!.setToolbarHidden(true, animated: false)
    }
    
    private func initAcessoBio() {
        unicoCheck = AcessoBioManager(viewController: self)
        
        let cameraType = UnicoCameraType(argument: SwiftUnicoCheckPlugin.argument)
        let unicoTimer = UnicoTimer(argument: SwiftUnicoCheckPlugin.argument)
        
        unicoCheck.setSmartFrame(cameraType.getSmartFrame())
        unicoCheck.setAutoCapture(cameraType.getAutoCapture())
        unicoCheck.setTimeoutSession(unicoTimer.getTimeoutSession())
        unicoCheck.setTheme(UnicoTheme(argument: SwiftUnicoCheckPlugin.argument))
    }
    
    func onErrorAcessoBioManager(_ errorBio: ErrorBio!) {
        acessoBioStatus = false
        SwiftUnicoCheckPlugin.result(
            FlutterError(
                code: ReturnConstants.ON_ERROR_UNICO.rawValue,
                message: ReturnConstants.ON_ERROR_UNICO.rawValue,
                details: ConvertToHashMap.errorBioToHashMap(error: errorBio))
        )
        DispatchQueue.main.async {
            self.dismiss(animated: true, completion: nil)
        }
    }
    
    func onUserClosedCameraManually() {
        SwiftUnicoCheckPlugin.result(
            FlutterError(
                code: ReturnConstants.ON_USER_CLOSED_CAMERA_MANUALLY.rawValue,
                message: ReturnConstants.ON_ERROR_UNICO.rawValue,
                details: nil)
        )
        DispatchQueue.main.async {
            self.dismiss(animated: true, completion: nil)
        }
    }
    
    func onSystemClosedCameraTimeoutSession() {
        SwiftUnicoCheckPlugin.result(
            FlutterError(
                code: ReturnConstants.ON_SYSTEM_CLOSED_CAMERA_TIMEOUT_SESSION.rawValue,
                message: ReturnConstants.ON_SYSTEM_CLOSED_CAMERA_TIMEOUT_SESSION.rawValue,
                details: nil)
        )
        DispatchQueue.main.async {
            self.dismiss(animated: true, completion: nil)
        }
    }
    
    func onSystemChangedTypeCameraTimeoutFaceInference() {
        
        SwiftUnicoCheckPlugin.channel.invokeMethod(
            MethodConstants.ON_RESULT.rawValue,
            arguments: ConvertToHashMap.errorNotifier(
                errorMethodName: ReturnConstants.ON_SYSTEM_CHANGED_TYPE_CAMERA_TIMEOUT_FACE_INFERENCE.rawValue
            )
        )
    }
}
