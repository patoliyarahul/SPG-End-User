//
//  CalendarViewController.swift
//  SPG Client
//
//  Created by Il Dottore on 11/21/16.
//  Copyright © 2016 Ahmed Elhosseiny. All rights reserved.
//


import JTAppleCalendar

class CalendarViewController: UIViewController {
    
    @IBOutlet weak var calendarView: JTAppleCalendarView!
    @IBOutlet weak var monthLabel: UILabel!
    
//    @IBOutlet var numbers: [UIButton]!
//    @IBOutlet var headers: [UIButton]!
//    @IBOutlet var directions: [UIButton]!
//    @IBOutlet var outDates: [UIButton]!
//    @IBOutlet var inDates: [UIButton]!
    @IBOutlet var scrollDate: UITextField!
    @IBOutlet var selectFrom: UITextField!
    @IBOutlet var selectTo: UITextField!
    
    var numberOfRows = 6
    let formatter = DateFormatter()
    var testCalendar = Calendar.current
    var generateInDates: InDateCellGeneration = .forAllMonths
    var generateOutDates: OutDateCellGeneration = .tillEndOfGrid
    let firstDayOfWeek: DaysOfWeek = .sunday
    let disabledColor = UIColor.lightGray
    let enabledColor = UIColor.blue
    let dateCellSize: CGFloat? = nil
    
    
//    @IBAction func changeToRow(_ sender: UIButton) {
//        numberOfRows = Int(sender.title(for: .normal)!)!
//        
////        for aButton in numbers {
////            aButton.tintColor = disabledColor
////        }
//        sender.tintColor = enabledColor
//        calendarView.reloadData()
//    }
    
//    @IBAction func changeDirection(_ sender: UIButton) {
////        for aButton in directions {
////            aButton.tintColor = disabledColor
////        }
//        sender.tintColor = enabledColor
//        
//        if sender.title(for: .normal)! == "HorizontalCalendar" {
//            calendarView.direction = .horizontal
//        } else {
//            calendarView.direction = .vertical
//        }
//        calendarView.reloadData()
//    }
    
//    @IBAction func headers(_ sender: UIButton) {
////        for aButton in headers {
////            aButton.tintColor = disabledColor
////        }
//        sender.tintColor = enabledColor
//        
//        if sender.title(for: .normal)! == "HeadersOn" {
//            calendarView.registerHeaderView(xibFileNames:
//                ["PinkSectionHeaderView", "WhiteSectionHeaderView"])
//        } else {
//            calendarView.unregisterHeaders()
//        }
//        calendarView.reloadData()
//    }
    
//    @IBAction func outDateGeneration(_ sender: UIButton) {
//        for aButton in outDates {
//            aButton.tintColor = disabledColor
//        }
//        sender.tintColor = enabledColor
//        
//        switch sender.title(for: .normal)! {
//        case "EOR":
//            generateOutDates = .tillEndOfRow
//        case "EOG":
//            generateOutDates = .tillEndOfGrid
//        case "OFF":
//            generateOutDates = .off
//        default:
//            break
//        }
//        calendarView.reloadData()
//    }
    
//    @IBAction func inDateGeneration(_ sender: UIButton) {
//        for aButton in inDates {
//            aButton.tintColor = disabledColor
//        }
//        sender.tintColor = enabledColor
//        
//        switch sender.title(for: .normal)! {
//        case "First":
//            generateInDates = .forFirstMonthOnly
//        case "All":
//            generateInDates = .forAllMonths//<<<<<<<<<<<<<<<<
//        case "Off":
//            generateInDates = .off
//        default:
//            break
//        }
//        calendarView.reloadData()
//    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        formatter.dateFormat = "yyyy MM dd"
        
        // Setting up your dataSource and delegate is manditory
        // ___________________________________________________________________
        calendarView.delegate = self
        calendarView.dataSource = self
        
        // ___________________________________________________________________
        // Registering your cells is manditory
        // ___________________________________________________________________
        calendarView.registerCellViewXib(file: "CalendarCellView")
        
        // ___________________________________________________________________
        // Registering your cells is optional
        
        // ___________________________________________________________________
        calendarView.registerHeaderView(xibFileNames: ["PinkSectionHeaderView", "WhiteSectionHeaderView"])
        
        calendarView.direction = .horizontal
        
        calendarView.cellInset = CGPoint(x: 0, y: 0)
        //        calendarView.allowsMultipleSelection = true
        
        calendarView.visibleDates { (visibleDates: DateSegmentInfo) in
            self.setupViewsOfCalendar(from: visibleDates)
        }
    }
    
//    @IBAction func selectDate(_ sender: AnyObject?) {
//        let fromDate = formatter.date(from: selectFrom.text!)!
//        let toDate = formatter.date(from: selectTo.text!)!
//        self.calendarView.selectDates(from: fromDate, to: toDate)
//    }
//    
//    @IBAction func scrollToDate(_ sender: AnyObject?) {
//        let text = scrollDate.text!
//        let date = formatter.date(from: text)!
//        calendarView.scrollToDate(date)
//    }
//    
//    @IBAction func printSelectedDates() {
//        print("\nSelected dates --->")
//        for date in calendarView.selectedDates {
//            print(formatter.string(from: date))
//        }
//    }
//    
//    @IBAction func resize(_ sender: UIButton) {
//        calendarView.frame = CGRect(
//            x: calendarView.frame.origin.x,
//            y: calendarView.frame.origin.y,
//            width: calendarView.frame.width,
//            height: calendarView.frame.height - 50
//        )
//    }
//    
//    @IBAction func reloadCalendar(_ sender: UIButton) {
//        calendarView.reloadData()
//    }
    
    @IBAction func next(_ sender: UIButton) {
        self.calendarView.scrollToSegment {
            self.calendarView.visibleDates({ (visibleDates: DateSegmentInfo) in
                self.setupViewsOfCalendar(from: visibleDates)
            })
        }
    }
    
    @IBAction func previous(_ sender: UIButton) {
        self.calendarView.scrollToPreviousSegment {
            self.calendarView.visibleDates({ (visibleDates: DateSegmentInfo) in
                self.setupViewsOfCalendar(from: visibleDates)
            })
        }
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
    }
    
    func setupViewsOfCalendar(from visibleDates: DateSegmentInfo) {
        guard let startDate = visibleDates.monthDates.first else {
            return
        }
        let month = testCalendar.dateComponents([.month], from: startDate).month!
        let monthName = DateFormatter().monthSymbols[(month-1) % 12]
        // 0 indexed array
        let year = testCalendar.component(.year, from: startDate)
        monthLabel.text = monthName + " " + String(year)
    }
    @IBAction func cancelButton_Click(_ sender: Any) {
        dismiss(animated: true, completion: nil)
    }
}

// MARK : JTAppleCalendarDelegate
extension CalendarViewController: JTAppleCalendarViewDelegate, JTAppleCalendarViewDataSource {
    func configureCalendar(_ calendar: JTAppleCalendarView) -> ConfigurationParameters {
        let startDate = formatter.date(from: "2016 10 01")!
        let endDate = formatter.date(from: "2016 12 01")!
        
        let parameters = ConfigurationParameters(startDate: startDate,
                                                 endDate: endDate,
                                                 numberOfRows: numberOfRows,
                                                 calendar: testCalendar,
                                                 generateInDates: generateInDates,
                                                 generateOutDates: generateOutDates,
                                                 firstDayOfWeek: firstDayOfWeek)
        return parameters
    }
    
    func calendar(_ calendar: JTAppleCalendarView, willDisplayCell cell: JTAppleDayCellView, date: Date, cellState: CellState) {
        (cell as? CalendarCellView)?.setupCellBeforeDisplay(cellState, date: date)
    }
    
    func calendar(_ calendar: JTAppleCalendarView, didDeselectDate date: Date, cell: JTAppleDayCellView?, cellState: CellState) {
        (cell as? CalendarCellView)?.cellSelectionChanged(cellState)
    }
    
    func calendar(_ calendar: JTAppleCalendarView, didSelectDate date: Date, cell: JTAppleDayCellView?, cellState: CellState) {
        (cell as? CalendarCellView)?.cellSelectionChanged(cellState)
        print(date, cellState.text)
    }
    
    
    // NOTICE: this function is not needed for iOS 10. It will not be called
    func calendar(_ calendar: JTAppleCalendarView, willResetCell cell: JTAppleDayCellView) {
        (cell as? CalendarCellView)?.selectedView.isHidden = true
    }
    
    func calendar(_ calendar: JTAppleCalendarView, didScrollToDateSegmentWith visibleDates: DateSegmentInfo) {
        self.setupViewsOfCalendar(from: visibleDates)
    }
    
    func calendar(_ calendar: JTAppleCalendarView,
                  sectionHeaderIdentifierFor range: (start: Date, end: Date),
                  belongingTo month: Int) -> String {
        if month % 2 > 0 {
            return "WhiteSectionHeaderView"
        }
        return "PinkSectionHeaderView"
    }
    
    func calendar(_ calendar: JTAppleCalendarView, sectionHeaderSizeFor range: (start: Date, end: Date), belongingTo month: Int) -> CGSize {
        if month % 2 > 0 {
            return CGSize(width: 200, height: 50)
        } else {
            // Yes you can have different size headers
            return CGSize(width: 200, height: 100)
        }
    }
    
    func calendar(_ calendar: JTAppleCalendarView, willDisplaySectionHeader header: JTAppleHeaderView, range: (start: Date, end: Date), identifier: String) {
        switch identifier {
        case "WhiteSectionHeaderView":
            let headerCell = header as? WhiteSectionHeaderView
            headerCell?.title.text = "Design multiple headers"
        default:
            let headerCell = header as? PinkSectionHeaderView
            headerCell?.title.text = "In any color or size you want"
        }
    }
}

func delayRunOnMainThread(_ delay: Double, closure: @escaping () -> ()) {
    DispatchQueue.main.asyncAfter(
        deadline: DispatchTime.now() +
            Double(Int64(delay * Double(NSEC_PER_SEC))) /
            Double(NSEC_PER_SEC), execute: closure)
    print("DELAY!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!")
}



//import UIKit
//
//import JTAppleCalendar
//class CalendarViewController: UIViewController {
//    @IBOutlet weak var calendarView: JTAppleCalendarView!
//    override func viewDidLoad() {
//        super.viewDidLoad()
//        calendarView.dataSource = self
//        calendarView.delegate = self
//        calendarView.registerCellViewXib(file: "CalendarCellView") // Registering your cell is manditory
//    }
//    
//    @IBAction func cancelButton_Click(_ sender: Any) {
//        dismiss(animated: true, completion: nil)
//    }
//}
//
//extension CalendarViewController: JTAppleCalendarViewDataSource, JTAppleCalendarViewDelegate {
//    func configureCalendar(_ calendar: JTAppleCalendarView) -> ConfigurationParameters {
//        let formatter = DateFormatter()
//        formatter.dateFormat = "yyyy MM dd"
//        
//        let startDate = formatter.date(from: "2016 02 01")! // You can use date generated from a formatter
//        let endDate = Date()                                // You can also use dates created from this function
//        let parameters = ConfigurationParameters(startDate: startDate,
//                                                 endDate: endDate,
//                                                 numberOfRows: 6,
//                                                 calendar: Calendar.current,
//                                                 generateInDates: .forAllMonths,
//                                                 generateOutDates: .tillEndOfGrid,
//                                                 firstDayOfWeek: .sunday)
//        return parameters
//    }
//    
//    func calendar(_ calendar: JTAppleCalendarView, willDisplayCell cell: JTAppleDayCellView, date: Date, cellState: CellState) {
//        let myCustomCell = cell as! CalendarCellView
//        
//        // Setup Cell text
//        myCustomCell.dayLabel.text = cellState.text
//        
//        // Setup text color
//        if cellState.dateBelongsTo == .thisMonth {
//            myCustomCell.dayLabel.textColor = UIColor.black
//        } else {
//            myCustomCell.dayLabel.textColor = UIColor.gray
//        }
//    }
//}
