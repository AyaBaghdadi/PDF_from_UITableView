//
//  ViewController.swift
//
//  Created by Technicalisto.
//

import UIKit

class ViewController: UIViewController , UITableViewDelegate , UITableViewDataSource , UIDocumentInteractionControllerDelegate{

//--------------------------------------------------------------------------------------
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 20
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath)

        return cell
    }
//--------------------------------------------------------------------------------------

    func documentInteractionControllerViewControllerForPreview(_ controller: UIDocumentInteractionController) -> UIViewController {
        return self //or use return self.navigationController for fetching app navigation bar color
    }
    
//--------------------------------------------------------------------------------------

    @IBOutlet weak var tableView: UITableView!

    override func viewDidLoad() {
        super.viewDidLoad()
    }

//--------------------------------------------------------------------------------------

    @IBAction func pdfTapped(_ sender: Any) {
        let pdf_file = UIDocumentInteractionController(url: URL(fileURLWithPath: self.pdfDataWithTableView(tableView: self.tableView)))
        pdf_file.delegate = self
        pdf_file.presentPreview(animated: true)
    }
//--------------------------------------------------------------------------------------

    func pdfDataWithTableView(tableView: UITableView)-> String {
        let priorBounds = tableView.bounds

        let fittedSize = tableView.sizeThatFits(CGSize(
          width: priorBounds.size.width,
          height: tableView.contentSize.height
        ))

        tableView.bounds = CGRect(
          x: 0, y: 0,
          width: fittedSize.width,
          height: fittedSize.height
        )

        let pdfPageBounds = CGRect(
          x :0, y: 0,
          width: tableView.frame.width,
          height: self.view.frame.height
        )

        let pdfData = NSMutableData()
        UIGraphicsBeginPDFContextToData(pdfData, pdfPageBounds, nil)

        var pageOriginY: CGFloat = 0
        while pageOriginY < fittedSize.height {
          UIGraphicsBeginPDFPageWithInfo(pdfPageBounds, nil)
          UIGraphicsGetCurrentContext()!.saveGState()
          UIGraphicsGetCurrentContext()!.translateBy(x: 0, y: -pageOriginY)
          tableView.layer.render(in: UIGraphicsGetCurrentContext()!)
          UIGraphicsGetCurrentContext()!.restoreGState()
          pageOriginY += pdfPageBounds.size.height
          tableView.contentOffset = CGPoint(x: 0, y: pageOriginY) // move "renderer"
        }
        UIGraphicsEndPDFContext()

        tableView.bounds = priorBounds
        var docURL = (FileManager.default.urls(for: .documentDirectory, in: .userDomainMask)).last! as URL
        docURL = docURL.appendingPathComponent("Report.pdf")
        pdfData.write(to: docURL as URL, atomically: true)
        
        return docURL.path
     }
}


