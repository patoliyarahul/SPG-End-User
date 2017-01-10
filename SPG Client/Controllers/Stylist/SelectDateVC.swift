//
//  SelectDateVC.swift
//  SPG Client
//
//  Created by Dharmesh Vaghani on 10/01/17.
//  Copyright © 2017 Ahmed Elhosseiny. All rights reserved.
//

import UIKit

import JTAppleCalendar

class SelectDateVC: UIViewController {
    
    //MARK: - IBOutlet
    @IBOutlet weak var calendarView: JTAppleCalendarView!
    @IBOutlet weak var monthLabel: UILabel!
    
    @IBOutlet weak var lblStylistName: UILabel!
    @IBOutlet weak var lblProfession: UILabel!
    @IBOutlet weak var imgLogo: UIImageView!
    
    @IBOutlet weak var myCollectionView: UICollectionView!
    
    //MARK: - Variables
    
    var numberOfRows = 6
    let formatter = DateFormatter()
    var testCalendar = Calendar.current
    var generateInDates: InDateCellGeneration = .forAllMonths
    var generateOutDates: OutDateCellGeneration = .tillEndOfGrid
    let firstDayOfWeek: DaysOfWeek = .sunday
    let disabledColor = UIColor.lightGray
    let enabledColor = UIColor.blue
    let dateCellSize: CGFloat? = nil
    
    let red = UIColor.red
    let white = UIColor.white
    let black = UIColor.black
    let gray = UIColor.gray
    let shade = UIColor(colorWithHexValue: 0x4E4E4E)
    
    var profession          =   ""
    var stylistName         =   ""
    var logoUrl             =   ""
    
    var timeInterval        =   [String]()
    
    var selectedDate        =   ""
    
    var previousIndexPath   =   IndexPath(row: 0, section: 0)
    
    let selectionColor      =   UIColor(red: 93.0/255, green: 9.0/255, blue: 139.0/255, alpha: 1)
    
    //MARK: - Life Cycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        formatter.dateFormat = "yyyy MM dd"
        formatter.timeZone = testCalendar.timeZone
        formatter.locale = testCalendar.locale
        
        calendarView.delegate = self
        calendarView.dataSource = self
        
        calendarView.registerCellViewXib(file: "CellView")
        
        calendarView.cellInset = CGPoint(x: 0, y: 0)
        
        calendarView.selectDates([Date()])
        
        calendarView.visibleDates { (visibleDates: DateSegmentInfo) in
            self.setupViewsOfCalendar(from: visibleDates)
        }
        
        getArrayOfTimeInterval()
    }
    
    //MARK: - Helper Methods
    
    func getArrayOfTimeInterval() {
        
        timeInterval = Time(startHour: 10, intervalMinutes: 45, endHour: 18).timeRepresentations
        
        if timeInterval.count > 0 {
            selectedDate = timeInterval[0]
        }
        
        myCollectionView.reloadData()
    }
    
    func setText() {
        lblStylistName.text =   stylistName
        lblProfession.text  =   profession
        Utils.downloadImage(logoUrl, imageView: imgLogo)
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
    
    // Function to handle the text color of the calendar
    func handleCellTextColor(view: JTAppleDayCellView?, cellState: CellState) {
        
        guard let myCustomCell = view as? CellView  else {
            return
        }
        
        if cellState.isSelected {
            myCustomCell.dayLabel.textColor = white
        } else {
            if cellState.dateBelongsTo == .thisMonth {
                myCustomCell.dayLabel.textColor = black
            } else {
                myCustomCell.dayLabel.textColor = gray
            }
        }
    }
    
    // Function to handle the calendar selection
    func handleCellSelection(view: JTAppleDayCellView?, cellState: CellState) {
        guard let myCustomCell = view as? CellView  else {
            return
        }
        if cellState.isSelected {
            myCustomCell.selectedView.layer.cornerRadius =  15
            myCustomCell.selectedView.isHidden = false
        } else {
            myCustomCell.selectedView.isHidden = true
        }
    }
    
    //MARK: - UIButton Action Methods
    
    @IBAction func btnNext_Click(_ sender: Any) {
        self.performSegue(withIdentifier: StylistSegue.selfieSegue, sender: self)
    }
    
    //MARK: - MemoryWarning
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    
    // MARK: - Navigation
    
    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if  segue.identifier == StylistSegue.selfieSegue {
            let dv = segue.destination as! SelfieViewController
        }
    }
}

// MARK : JTAppleCalendarDelegate
extension SelectDateVC: JTAppleCalendarViewDelegate, JTAppleCalendarViewDataSource {
    func configureCalendar(_ calendar: JTAppleCalendarView) -> ConfigurationParameters {
        
        let startDate = formatter.date(from: formatter.string(from: Date()))!
        let endDate = formatter.date(from: "2026 10 01")!
        
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
        
        let myCustomCell = cell as! CellView
        myCustomCell.dayLabel.text = cellState.text
        
        handleCellSelection(view: cell, cellState: cellState)
        handleCellTextColor(view: cell, cellState: cellState)
    }
    
    func calendar(_ calendar: JTAppleCalendarView, didDeselectDate date: Date, cell: JTAppleDayCellView?, cellState: CellState) {
        handleCellSelection(view: cell, cellState: cellState)
        handleCellTextColor(view: cell, cellState: cellState)
    }
    
    func calendar(_ calendar: JTAppleCalendarView, didSelectDate date: Date, cell: JTAppleDayCellView?, cellState: CellState) {
        handleCellSelection(view: cell, cellState: cellState)
        handleCellTextColor(view: cell, cellState: cellState)
        
        print(formatter.string(from: date))
    }
    
    func calendar(_ calendar: JTAppleCalendarView, didScrollToDateSegmentWith visibleDates: DateSegmentInfo) {
        self.setupViewsOfCalendar(from: visibleDates)
    }
    
    func scrollDidEndDecelerating(for calendar: JTAppleCalendarView) {
        self.setupViewsOfCalendar(from: calendarView.visibleDates())
    }
}

//MARK: - UICollectionView Delegate & Datasource Methods

extension SelectDateVC: UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 1
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        if timeInterval.count > 0 {
            return timeInterval.count
        }
        
        return 1
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        if timeInterval.count > 1 {
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "Cell", for: indexPath) as! TimeSelectionCell
            
            cell.lblTime.text = timeInterval[indexPath.row]
            cell.lblTime.textColor = selectionColor
            cell.contentView.layer.cornerRadius = 14
            cell.contentView.layer.borderColor = selectionColor.cgColor
            cell.contentView.layer.borderWidth = 1
            cell.contentView.backgroundColor = UIColor.clear
            
            if cell.lblTime.text == selectedDate {
                cell.lblTime.textColor = UIColor.white
                cell.contentView.backgroundColor = selectionColor
            }

            return cell
        } else {
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "NotAvailableCell", for: indexPath)
            
            return cell
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        
        if timeInterval.count > 0 && previousIndexPath != indexPath {
            selectedDate = timeInterval[indexPath.row]
            myCollectionView.reloadItems(at: [previousIndexPath, indexPath])
            previousIndexPath = indexPath
        }
    }
}
