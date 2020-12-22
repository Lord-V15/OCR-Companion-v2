import UIKit
import ARKit


class ViewController: UIViewController {
    
    @IBOutlet var previewView: ARSCNView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.navigationController?.setNavigationBarHidden(true, animated: true)
        previewView.delegate = self
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        let configuration = ARWorldTrackingConfiguration()
        previewView.session.run(configuration)
    }
    
}

extension ViewController: ARSCNViewDelegate {
    
}
