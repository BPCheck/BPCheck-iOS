//
//  PostViewController.swift
//  BPCheck
//
//  Created by 이가영 on 2021/04/07.
//

import UIKit
import PanModal
import Then
import Vision
import ReactorKit
import RxCocoa

class PostViewController: UIViewController {
    
    private let recognizingText = UIButton().then{
        $0.setTitle("간편 사진 인식", for: .normal)
        $0.titleLabel?.font = UIFont.boldSystemFont(ofSize: 20)
        $0.tintColor = .white
        $0.backgroundColor = MainColor.update
        $0.clipsToBounds = true
        $0.layer.cornerRadius = 19
    }
    
    private let updateButton = UIButton().then {
        $0.setTitle("갱신", for: .normal)
        $0.titleLabel?.font = UIFont.boldSystemFont(ofSize: 20)
        $0.tintColor = .white
        $0.backgroundColor = MainColor.auth
        $0.clipsToBounds = true
        $0.layer.cornerRadius = 19
    }
    
    private let highLabel = UILabel().then {
        $0.text = "최고"
        $0.font = UIFont.boldSystemFont(ofSize: 30)
    }
    private let highPickerView = UIPickerView()
    
    private let lowLabel = UILabel().then {
        $0.text = "최저"
        $0.font = UIFont.boldSystemFont(ofSize: 30)
    }
    private let lowPickerView = UIPickerView()
    
    private let pulseLabel = UILabel().then {
        $0.text = "맥박"
        $0.font = UIFont.boldSystemFont(ofSize: 30)
    }
    private let pulsePickerView = UIPickerView()
    
    private let dateLabel = UILabel().then {
        $0.text = "날짜"
        $0.font = UIFont.boldSystemFont(ofSize: 30)
    }
    private let datePickerView = UIDatePicker().then {
        $0.datePickerMode = .date
        $0.preferredDatePickerStyle = .wheels
    }
    
    private let activityIndicator = UIActivityIndicatorView()
    
    private var counter = [String]()
    private var request = VNRecognizeTextRequest(completionHandler: nil)
    private let disposeBag = DisposeBag()
    private let reactor = PostReactor()
    private var lowBpData = BehaviorRelay<String>(value: "")
    private var highBpData = BehaviorRelay<String>(value: "")
    private var pulseBpData = BehaviorRelay<String>(value: "")
    private var dateBpData = BehaviorRelay<String>(value: "")
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        view.addSubview(highPickerView)
        view.addSubview(highLabel)
        view.addSubview(lowPickerView)
        view.addSubview(lowLabel)
        view.addSubview(pulsePickerView)
        view.addSubview(pulseLabel)
        view.addSubview(dateLabel)
        view.addSubview(datePickerView)
        view.addSubview(recognizingText)
        view.addSubview(updateButton)
        view.addSubview(activityIndicator)
        
        for i in 40...200 { counter.append(String(i)) }
        
        highPickerView.dataSource = self
        highPickerView.delegate = self
        
        lowPickerView.dataSource = self
        lowPickerView.delegate = self
        
        pulsePickerView.dataSource = self
        pulsePickerView.delegate = self
        
        setupConstraint()
        
        bind(reactor: reactor)
        
        recognizingText.rx.tap.subscribe(onNext: { [unowned self] _ in setupGallery() }).disposed(by: disposeBag)
        
        datePickerView.rx.value.asObservable().subscribe(onNext: { data in
            let dateFormatter = DateFormatter()
            dateFormatter.dateFormat = "YY/MM/dd"
            self.dateBpData.accept(dateFormatter.string(from: data))
        }).disposed(by: disposeBag)
    }
    
    private func setupGallery() {
        let imagePicker = UIImagePickerController()
        imagePicker.delegate = self
        imagePicker.allowsEditing = true
        imagePicker.sourceType = .photoLibrary
        self.present(imagePicker, animated: true, completion: nil)
    }
    
    private func startAnimating() {
        activityIndicator.startAnimating()
    }
    
    private func stopAnimating() {
        activityIndicator.stopAnimating()
    }
    
    private func setupVisionTextRecognizeImage(image: UIImage?) {
        var textString = [String]()
        
        request = VNRecognizeTextRequest(completionHandler: { (request, error) in
            guard let observations = request.results as? [VNRecognizedTextObservation] else { fatalError("recieved invaild observation")}
            
            for observation in observations {
                guard let topCandidate = observation.topCandidates(1).first else { continue }
                textString.append(topCandidate.string)
                DispatchQueue.main.async {
                    self.stopAnimating()
                    
                    self.highPickerView.selectRow(Int(textString[1])! - 40, inComponent: 0, animated: true)
                    self.lowPickerView.selectRow(Int(textString[2])! - 40, inComponent: 0, animated: true)
                    self.pulsePickerView.selectRow(Int(textString[3])! - 40, inComponent: 0, animated: true)
                }
            }
        })
        
        let requests = [request]
        
        request.recognitionLanguages = ["en_EG"]
        request.usesLanguageCorrection = true
        request.recognitionLevel = .accurate
        
        DispatchQueue.global(qos: .userInitiated).async {
            guard let img = image?.cgImage else { fatalError("missing image to scan") }
            let handle = VNImageRequestHandler(cgImage: img, options: [:])
            try? handle.perform(requests)
        }
    }
    
    private func setupConstraint() {
        highLabel.snp.makeConstraints { (make) in
            make.top.equalTo(view.snp.top).offset(60)
            make.leading.equalTo(view.snp.leading).offset(46)
        }
        
        highPickerView.snp.makeConstraints { (make) in
            make.centerY.equalTo(highLabel)
            make.leading.equalTo(highLabel.snp.trailing).offset(30)
            make.trailing.lessThanOrEqualTo(view.snp.trailing).offset(-45)
            make.height.equalTo(50)
        }
        
        lowLabel.snp.makeConstraints { (make) in
            make.top.equalTo(highLabel.snp.bottom).offset(20)
            make.leading.equalTo(view.snp.leading).offset(46)
        }
        
        lowPickerView.snp.makeConstraints { (make) in
            make.centerY.equalTo(lowLabel)
            make.leading.equalTo(lowLabel.snp.trailing).offset(30)
            make.trailing.lessThanOrEqualTo(view.snp.trailing).offset(-45)
            make.height.equalTo(50)
        }
        
        pulseLabel.snp.makeConstraints { (make) in
            make.top.equalTo(lowLabel.snp.bottom).offset(20)
            make.leading.equalTo(view.snp.leading).offset(46)
        }
        
        pulsePickerView.snp.makeConstraints { (make) in
            make.centerY.equalTo(pulseLabel)
            make.leading.equalTo(pulseLabel.snp.trailing).offset(30)
            make.trailing.lessThanOrEqualTo(view.snp.trailing).offset(-45)
            make.height.equalTo(50)
        }
        
        dateLabel.snp.makeConstraints { (make) in
            make.top.equalTo(pulseLabel.snp.bottom).offset(20)
            make.leading.equalTo(view.snp.leading).offset(46)
        }
        
        datePickerView.snp.makeConstraints { (make) in
            make.centerY.equalTo(dateLabel)
            make.leading.equalTo(pulsePickerView.snp.leading)
            make.trailing.lessThanOrEqualTo(view.snp.trailing).offset(-45)
            make.height.equalTo(50)
            make.width.equalTo(240)
        }
        
        updateButton.snp.makeConstraints { (make) in
            make.top.equalTo(dateLabel.snp.bottom).offset(40)
            make.leading.equalTo(dateLabel.snp.leading)
            make.width.equalTo(156)
            make.height.equalTo(50)
        }
        
        recognizingText.snp.makeConstraints { (make) in
            make.top.equalTo(updateButton.snp.top)
            make.leading.equalTo(updateButton.snp.trailing).offset(17)
            make.width.equalTo(156)
            make.height.equalTo(50)
        }
        
        activityIndicator.snp.makeConstraints { (make) in
            make.width.height.equalTo(50)
            make.top.equalTo(view.snp.top).offset(60)
            make.centerX.equalToSuperview()
        }
    }
    
    func bind(reactor: PostReactor) {
        updateButton.rx.tap.map {[unowned self] _ in
            PostReactor.Action.postBp(Bp(lowBp: lowBpData.value, highBp: highBpData.value, date: dateBpData.value, pulse: pulseBpData.value))
        }.bind(to: reactor.action)
        .disposed(by: disposeBag)

        reactor.state.map { $0.result }
            .subscribe(onNext: { message in
                if let text = message {
                    self.showAlert(text)
                }
            }).disposed(by: disposeBag)
        
        reactor.state.map { $0.isDismiss }
            .subscribe(onNext: { result in
                if result { self.dismiss(animated: true, completion: nil) }
            }).disposed(by: disposeBag)
    }
}

extension PostViewController: PanModalPresentable {
    var longFormHeight: PanModalHeight { return .contentHeight(400) }
    var anchorModalToLongForm: Bool { return false }
    var shouldRoundTopCorners: Bool { return true }
    var panScrollable: UIScrollView? {  return nil }
    
    override var preferredStatusBarStyle: UIStatusBarStyle {
        return .lightContent
    }
}

extension PostViewController: UIPickerViewDataSource, UIPickerViewDelegate {
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 1
    }
    
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        return counter.count
    }
    
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        switch pickerView {
        case lowPickerView:
            lowBpData.accept(String(counter[row]))
        case highPickerView:
            highBpData.accept(String(counter[row]))
        case pulsePickerView:
            pulseBpData.accept(String(counter[row]))
        default:
            print("other pickerView")
        }
        
        return counter[row]
    }
}

extension PostViewController: UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        startAnimating()
        let image = info[UIImagePickerController.InfoKey.originalImage] as? UIImage
        setupVisionTextRecognizeImage(image: image)
        dismiss(animated: true, completion: nil)
    }
}
