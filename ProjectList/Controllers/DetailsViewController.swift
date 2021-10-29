//
//  DetailsViewController.swift
//  ProjectList
//
//  Created by Apple on 27/10/2021.
//

import UIKit

class DetailsViewController: UIViewController, UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    
    @IBOutlet weak var headerView: UIView!
    @IBOutlet weak var backLabel: UILabel!
    @IBOutlet weak var containView: UIView!
    @IBOutlet weak var footerView: UIView!
    @IBOutlet weak var addButton: UIButton!
    
    var id: Int = 0
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupConstraints()
        setupElements()
        
        // fetch Image
        DispatchQueue.global(qos: .userInitiated).async { [weak self] in
          guard let self = self else {
            return
          }
            self.fetchFromServer()
            
        }
       
        // canvas zoom
        let pinchGesture = UIPinchGestureRecognizer(target: self, action: #selector(pinch(sender:)))
        containView!.addGestureRecognizer(pinchGesture)
        
        addButton.addTarget(self, action: #selector(didTapButton), for: .touchUpInside)
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        
    }
    
    //MARK: - setupConstraints
    func setupConstraints() {
        view.addSubview(containView)
        view.addSubview(headerView)
        view.addSubview(footerView)
        headerView.addSubview(backLabel)
        footerView.addSubview(addButton)
        
        headerView.translatesAutoresizingMaskIntoConstraints = false
        containView.translatesAutoresizingMaskIntoConstraints = false
        footerView.translatesAutoresizingMaskIntoConstraints = false
        backLabel.translatesAutoresizingMaskIntoConstraints = false
        addButton.translatesAutoresizingMaskIntoConstraints = false
        
        NSLayoutConstraint.activate([
            // headerView
            headerView.topAnchor.constraint(equalTo: view.topAnchor),
            headerView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            headerView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            headerView.heightAnchor.constraint(equalTo: view.heightAnchor, multiplier: 0.15),
            
            // backLabel
            backLabel.leadingAnchor.constraint(equalTo: headerView.leadingAnchor, constant: 10),
            backLabel.widthAnchor.constraint(equalToConstant: 80),
            backLabel.bottomAnchor.constraint(equalTo: headerView.bottomAnchor, constant: -15),
            
            // containView
            containView.topAnchor.constraint(equalTo: headerView.bottomAnchor),
            containView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            containView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            containView.bottomAnchor.constraint(equalTo: footerView.topAnchor),
            
            // footerView
            footerView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            footerView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            footerView.bottomAnchor.constraint(equalTo: view.bottomAnchor),
            footerView.heightAnchor.constraint(equalTo: view.heightAnchor, multiplier: 0.2),
            
            // Add Button
            addButton.centerXAnchor.constraint(equalTo: footerView.centerXAnchor),
            addButton.topAnchor.constraint(equalTo: footerView.topAnchor, constant: 20),
            addButton.heightAnchor.constraint(equalTo: footerView.heightAnchor, multiplier: 0.4),
            addButton.widthAnchor.constraint(equalTo: footerView.widthAnchor, multiplier: 0.8)
        ])
   
    }
   
    //MARK:  setupElements
    func setupElements() {
        self.view.backgroundColor = #colorLiteral(red: 0.9010927081, green: 0.9243850708, blue: 0.9953681827, alpha: 1)
        headerView.backgroundColor = .white
       
        // back buton
        backLabel.text = "back"
        backLabel.font = UIFont.systemFont(ofSize: 20, weight: .bold)
        backLabel.isUserInteractionEnabled = true
        
        let tap = UITapGestureRecognizer(target: self, action:#selector(self.backTap(_:)))
        backLabel.addGestureRecognizer(tap)
        
        containView.backgroundColor = #colorLiteral(red: 0.9010927081, green: 0.9243850708, blue: 0.9953681827, alpha: 1)
        footerView.backgroundColor = .white
        addButton.setTitle("Add Photo", for: .normal)
        Utilities.styleFilledButton(addButton)
    }
    
//MARK: - fetch
    func fetchFromServer() {
        // fetch Project data
        let params = ["id":id] as [String:Int]
        var request = URLRequest(url: URL(string: "https://tapuniverse.com/xprojectdetail")!)
        request.httpMethod = "POST"
        request.httpBody = try? JSONSerialization.data(withJSONObject: params, options: [])
        request.addValue("application/json", forHTTPHeaderField: "Content-Type")

        let session = URLSession.shared
        let task = session.dataTask(with: request, completionHandler: { data, response, error -> Void in
            guard let data = data else {
                return
            }
            
            do {
                let json = try JSONSerialization.jsonObject(with: data) as! Dictionary<String, AnyObject>
                
                // append to photos array
                if let array = json["photos"] as? [Any] {
                    photos.reserveCapacity(array.count)
                    
                    for value in array {
                        let photo = Photo.init(data: value as! [String : Any])
                        
                        // check if new photo from API is already existed or not
                        var isExisted = false
                        for i in photos {
                            if i == photo {
                                isExisted = true
                                break
                            }
                        }
                        
                        // if not then add it
                        if isExisted == false {
                            photos.append(photo)
                        }
                    }
                    
                    // add photos to viewcontroller
                    for photo in photos {
                        self.addImage(photo: photo, url: photo.url)
                    }
                }
            } catch {
                print("error")
            }
        })

        task.resume()
    }
 

    
    func addImage(photo: Photo, url: String){
        DispatchQueue.main.async {
            // photoView
            let photoView = PhotoView(frame: CGRect(x: photo.frame.x, y: photo.frame.y, width: photo.frame.width, height: photo.frame.height+40))
            photoView.url = url
            self.containView.addSubview(photoView)
            
            photoView.isUserInteractionEnabled = true
            let panGesture = UIPanGestureRecognizer(target: self, action: #selector(self.panPiece(_:)))
            photoView.addGestureRecognizer(panGesture)
            
            let url = URL(string: photo.url)
            let data = try? Data(contentsOf: url!)
            photoView.imageView?.image = UIImage(data: data!)
        }
    }
    
    //MARK: - UIImagePickerController
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        guard let image = info[.editedImage] as? UIImage else { return }

        let imageName = UUID().uuidString
        let imagePath = getDocumentsDirectory().appendingPathComponent(imageName)

        if let jpegData = image.jpegData(compressionQuality: 0.8) {
            try? jpegData.write(to: imagePath)
        }
        
        let newPhoto = Photo()
        newPhoto.url = "\(imagePath)"
        newPhoto.frame.width = Double(image.size.width)
        newPhoto.frame.height = Double(image.size.height)
        newPhoto.frame.x = Double(self.containView.center.x - image.size.width/2)
        newPhoto.frame.y = Double(self.containView.center.y - image.size.height/2)
        
        photos.append(newPhoto)
        addImage(photo: newPhoto, url: newPhoto.url)
        dismiss(animated: true)
    }

    func getDocumentsDirectory() -> URL {
        let paths = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask)
        return paths[0]
    }
    
    
    
    //MARK: - @objc func
    
    // pan gesture
    var initialCenter = CGPoint()  // The initial center point of the view.
    @objc func panPiece(_ gestureRecognizer : UIPanGestureRecognizer) {
       guard gestureRecognizer.view != nil else {return}
       let piece = gestureRecognizer.view!
       // Get the changes in the X and Y directions relative to
       // the superview's coordinate space.
       let translation = gestureRecognizer.translation(in: piece.superview)
       if gestureRecognizer.state == .began {
          // Save the view's original position.
          self.initialCenter = piece.center
       }
          // Update the position for the .began, .changed, and .ended states
       if gestureRecognizer.state != .cancelled {
          // Add the X and Y translation to the view's original position.
          let newCenter = CGPoint(x: initialCenter.x + translation.x, y: initialCenter.y + translation.y)
          piece.center = newCenter
       }
       else {
          // On cancellation, return the piece to its original location.
          piece.center = initialCenter
       }
    }
    
    // pinch gesture
    @objc func pinch(sender:UIPinchGestureRecognizer) {
        
        guard let view = sender.view else { return }
        if sender.state == .began || sender.state == .changed {
            view.transform = view.transform.scaledBy(x: sender.scale, y: sender.scale)
            sender.scale = 1
        }

    }
    // add Button
    @objc func didTapButton (){
        let picker = UIImagePickerController()
            picker.allowsEditing = true
            picker.delegate = self
            present(picker, animated: true)
        
    }
    
    // back gesture
    @objc func backTap(_ sender: UITapGestureRecognizer) {
        self.dismiss(animated: true, completion: nil)
    }
}
