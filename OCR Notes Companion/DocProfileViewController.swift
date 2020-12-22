import UIKit
import Vision
import VisionKit
import PDFKit

class DocProfileViewController: UIViewController, VNDocumentCameraViewControllerDelegate,UITextFieldDelegate  {

    @IBOutlet var docImageView: UIImageView!
    @IBOutlet var docDetailsTextView: UITextView!
    
    @IBOutlet weak var titleTextBox: UITextField!
    
    var docImage: UIImage!
    var textRecognitionRequest = VNRecognizeTextRequest()
    var recognizedText = ""
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.navigationController?.setNavigationBarHidden(false, animated: true)
        self.title = "New Document"
        docImageView.image = docImage
        titleTextBox.delegate = self
        
        textRecognitionRequest = VNRecognizeTextRequest(completionHandler: { (request, error) in
                if let results = request.results, !results.isEmpty {
                    if let requestResults = request.results as? [VNRecognizedTextObservation] {
                        self.recognizedText = ""
                        for observation in requestResults {
                            guard let candidiate = observation.topCandidates(1).first else { return }
                              self.recognizedText += candidiate.string
                            self.recognizedText += "\n"
                        }
                        self.docDetailsTextView.text = self.recognizedText
                    }
                }
        })}
    
    func textFieldShouldReturn(_ titleTextBox: UITextField) -> Bool {   //delegate method
        titleTextBox.resignFirstResponder()
      return true
    }
    
    @IBAction func scanDocument(_ sender: Any) {
        let documentCameraViewController = VNDocumentCameraViewController()
         documentCameraViewController.delegate = self
         self.present(documentCameraViewController, animated: true, completion: nil)
    }
    
    @IBAction func sharePDF(_ sender: Any) {
        let pdfCreator = PDFCreator(
            title: titleTextBox.text!,
         body: recognizedText,
         image: docImage,
         contact: "github.com/Lord-V15"
            
       )
       let pdfData = pdfCreator.prepareData()
       let shareVc = UIActivityViewController(
         activityItems: [pdfData],
         applicationActivities: []
       )
       present(shareVc, animated: true, completion: nil)
    }
    

    
    override func shouldPerformSegue(withIdentifier identifier: String, sender: Any?) -> Bool {
      if
        recognizedText.count > 0 {
        return true
      }
      
      let alert = UIAlertController(title: "All Information Not Provided", message: "You must supply all information to create a PDF.", preferredStyle: .alert)
      alert.addAction(UIAlertAction(title: "OK", style: .default, handler: nil))
      present(alert, animated: true, completion: nil)
      
      return false
    }
    
    func documentCameraViewController(_ controller: VNDocumentCameraViewController, didFinishWith scan: VNDocumentCameraScan) {
        docImage = scan.imageOfPage(at: 0)
        docImageView.image = docImage
            let handler = VNImageRequestHandler(cgImage: docImage.cgImage!, options: [:])
            do {
                try handler.perform([textRecognitionRequest])
            } catch {
                print(error)
            }
            controller.dismiss(animated: true)
    }
    
}
