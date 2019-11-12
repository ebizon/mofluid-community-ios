import UIKit

class RatingViewController: UIViewController {
    @IBOutlet weak var cosmosStarRating: CosmosView!

    override func viewDidLoad() {
        super.viewDidLoad()
        cosmosStarRating.rating = 5.1
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
}

