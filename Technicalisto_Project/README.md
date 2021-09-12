
# Technicalisto

## How to Create PDF as a screen shot from UITableView & Display & Share it

1. Add your UIViewController which has your TableView with your custom design .

2. Connect your TableView & Add Delegate.

3. In file viewController inherit UIDocumentInteractionControllerDelegate & Add delegate method :

       func documentInteractionControllerViewControllerForPreview(_ controller: UIDocumentInteractionController) -> UIViewController {
          return self
       }
       
4. Add button to test create pdf of your table view

5. Add this method for used with your file name :

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
       
6. in Your button action call this & send your tableView wil represent your pdf : 

       let pdf_file = UIDocumentInteractionController(url: URL(fileURLWithPath: self.pdfDataWithTableView(tableView: self.tableView)))
       pdf_file.delegate = self
       pdf_file.presentPreview(animated: true)

### Thanks

