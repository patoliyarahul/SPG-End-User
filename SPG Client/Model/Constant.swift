//
//  Constant.swift
//  Allo Boulangerie
//
//  Created by Dharmesh Vaghani on 01/04/16.
//  Copyright © 2016 Dharmesh Vaghani. All rights reserved.
//

import UIKit

let userDefault = UserDefaults.standard

class Constant  {
    
    static let screenSize = UIScreen.main.bounds
    static let storyboard = UIStoryboard(name: "Main", bundle: nil)
    
    static let logOutNotificationName = Notification.Name("logOutNotificationName")
    
    static let appDelegate : AppDelegate = UIApplication.shared.delegate as! AppDelegate
    
    static let URL_PREFIX   =   "http://54.67.19.220/SPG"
    //    static let URL_PREFIX   = "http://netdroidtech.com/spgftp/SPG"
    
    static let userIsLogedIn            =   "userIsLogedIn"
    static let isFirstTime              =   "isFirstTime"
    
}

struct Api {
    
    static let signUp                   =   "user_signup.php"
    static let login                    =   "user_login.php"
    static let forgotPassword           =   "end_user_forgot_password.php"
    
    static let booking_history          =   "end_user_upcoming_past_booking_history.php"
    static let appointment_detail       =   "view_end_user_booking_appointment_detail_by_id.php"
    static let cancel_appointment       =   "cancel_end_user_appointment.php"
    static let reschedule_appointment   =   "reschedule_end_user_booking_appointment.php"
    
    static let getListOfStylist         =   "recommended_featured_end_user_stylist_list.php"
    
    //
    
    static let updateStylistInfo        =   "update_stylist_user_personal_detail.php"
    static let updateBusinessInfo       =   "update_stylist_user_business_detail.php"
    
    static let getServiceListById       =   "get_stylist_user_all_service_detail_by_stylist_id.php"
    static let addService               =   "add_stylist_user_service.php"
    static let updateService            =   "update_stylist_user_service_detail.php"
    static let deleteService            =   "delete_stylist_user_service_by_service_id.php"
    
    static let getUpcommingAppointment  =   "get_stylist_user_all_appointments.php"
    
    static let getAllClients            =   "get_stylist_user_all_clients.php"
    static let addStylistClient         =   "add_stylist_user_client.php"
    static let editStylistClient        =   "edit_stylist_user_manual_client.php"
    
    static let appointmentDetails       =   "view_stylist_user_appointment_detail_by_id.php"
    
    static let appointmentHistory       =   "appointment_history_stylist_user_client.php"
    
    static let getAllGalleryImages      =   "get_stylist_user_all_gallery_image_by_id.php"
    
    static let uploadGalleryImage       =   "upload_gallery_image.php"
    
    static let uploadBannerLogoImage    =   "upload_stylist_user_photo_logo_banner.php"
    static let deleteGalleryImage       =   "delete_gallery_byid.php"
    
    static let addManualAppointment     =   "add_stylist_user_manual_appointment.php"
    static let getStylistProfile        =   "get_end_user_stylist_profile.php"
}

struct InitialSegue {
    static let homeToDashboardSegue     =   "homeSegue"
    static let loginSegue               =   "loginSegue"
    static let signupSegue              =   "signupSegue"
}

struct StylistSegue {
    static let stylistDetailSegue       =   "stylistDetailSegue"
    static let showAllGalleryImageSegue =   "showAllGalleryImages"
    static let showAllServicesSegue     =   "viewAllServices"
}

struct Segue {
    static let serviceDetails           =   "serviceDetail"
}

struct EditProfileSegue {
    
}

struct DateFormate {
    static let dateFormate_1 = "EEEE, MMMM dd, yyyy"
    static let dateFormate_2 = "EEEE, MM/dd/yyyy"
    static let dateFormate_3 = "EEEE"


}

struct ImageDirectory {
    static let bannerDir                =   "/upload_banner/"
    static let gallaryDir               =   "/upload_gallery/"
    static let logoDir                  =   "/upload_logo/"
    static let desiredLookDir           =   "/uploads_desired_look/"
    static let lookBookDir              =   "/uploads_lookbook_images/"
    static let selfieDir                =   "/uploads_selfie/"
}

struct UpcommingSegue {
    static let addClientSegue           =   "addClientSegue"
    static let appointmentDetailSegue   =   "appointmentDetailSegue"
}

struct ClientSegue {
    static let addEditSegue             =   "addEditSegue"
    static let viewClientSegue          =   "viewClientSegue"
    static let historySegue             =   "historySegue"
}

struct GallerySegue {
    static let addEditSegue             =   "addEditPhotoSegue"
}

struct MainResponseParams {
    static let data         =   "data"
    static let message      =   "message"
    static let success      =   "success"
    static let msgTitle     =   "title"
    static let msgDesc      =   "description"
}

struct ProfessionParams {
    static let position         =   "position"
    static let profession_id    =   "profession_id"
    static let profession_name  =   "profession_name"
}

struct StylistListParams {
    static let featuredList     =   "featured_list"
    static let recommendedList  =   "recommended_list"
    static let businessCity     =   "business_city"
    static let businessName     =   "business_name"
    static let businessState    =   "business_state"
    static let businessStreet   =   "business_street_address"
    static let businessSuit     =   "business_suit"
    static let businessZipCode  =   "business_zipcode"
    static let logoImage        =   "logo_image"
    static let profession       =   "profession"
    static let stylistId        =   "stylist_user_id"
    static let bannerPhoto      =   "banner_photo"
    static let businessCatId    =   "business_category_id"
    static let firtName         =   "first_name"
    static let lastName         =   "last_name"
    static let recentWork       =   "recent_work"
    static let services         =   "services"
}

struct PersonalInfoParams {
    static let firstName    =   "first_name"
    static let lastName     =   "last_name"
    static let email        =   "email"
    static let password     =   "password"
    static let phone        =   "phone"
    static let profession   =   "profession"
    static let bannerPhoto  =   "banner_photo"
    static let logoImage    =   "logo_image"
    static let stylistId    =   "stylist_user_id"
}

struct Request {
    static let pass_data = "pass_data"
}
struct BusinessInfoParams {
    static let businessName =   "business_name"
    
    static let businessStreet   =   "business_street_address"
    static let businessSuit     =   "business_suit"
    static let businessCity     =   "business_city"
    static let businessState    =   "business_state"
    static let businessZipcode  =   "business_zipcode"
    static let businessPhone    =   "business_phone"
    static let businessLat      =   "business_latitude"
    static let businessLong     =   "business_longitude"
    static let webAddress       =   "web_address"
    static let businessCatID    =   "business_category_id"
}

struct ServicesParams {
    static let serviceId        =   "service_id"
    static let userId           =   "stylist_user_id"
    static let serviceName      =   "service_name"
    static let lengthId         =   "length_id"
    static let lengthName       =   "length_name"
    static let price            =   "price"
    static let desc             =   "service_description"
    static let catId            =   "category_id"
}

struct AddServiceParams {
    
    static let userId       =   "stylist_user_id"
    static let serviceName  =   "service_name"
    static let lengthId     =   "length_id"
    static let price        =   "price"
    static let serviceDesc  =   "service_description"
    static let catId        =   "category_id"
    static let enabled      =   "enable"
}

struct ClientsParams {
    static let enduserId    =   "end_user_id"
    static let firstName    =   "first_name"
    static let lastName     =   "last_name"
    static let email        =   "email"
    static let phone        =   "phone"
    static let profilePic   =   "profile_pic"
    static let endUserType  =   "end_user_type"
}

struct BusinessCategoryPrams {
    static let businessCatId    =   "business_category_id"
    static let businessCatname  =   "business_category_name"
}

struct LengthParams {
    static let lengthId     =   "length_id"
    static let lengthName   =   "length_name"
}

struct CategoryPrams {
    static let categoryId   =   "category_id"
    static let categoryName =   "category_name"
}

struct GalleryParams {
    static let galleryId            =   "gallery_id"
    static let galleryImageName     =   "gallery_image_name"
    static let galleryDescription   =   "gallery_description"
    static let photoData            =   "photo"
    static let categoryName         =   "category_name"
}

struct AppointmentParams {
    static let dataItems           =   "data_itemes"
    static let appointmentId       =   "appointment_id"
    static let endUserId           =   "end_user_id"
    static let stylistId           =   "stylist_user_id"
    static let firstName           =   "first_name"
    static let lastName            =   "last_name"
    static let isSeen              =   "is_seen"
    static let startTime           =   "start_time"
    static let endTime             =   "end_time"
    static let serviceName         =   "service_name"
}

struct AppointmentDetailParams {
    static let createdBy            =   "appointment_create_by"
    static let appointmentDate      =   "appointment_date"
    static let appointmentId        =   "appointment_id"
    static let appointmentTime      =   "appointment_time"
    static let desiredLook          =   "desired_look"
    static let endUserId            =   "end_user_id"
    static let firstName            =   "first_name"
    static let lastName             =   "last_name"
    static let phone                =   "213-300-9915"
    static let profilePic           =   "profile_pic"
    static let requestStatus        =   "request_status"
    static let selfiePic            =   "selfie_pic"
    static let serviceRequested     =   "services_requested"
    static let stylistNote          =   "stylist_notes"
    static let stylistUserId        =   "stylist_user_id"
    static let userNote             =   "user_notes"
}

struct ManualAppointmentParams {
    static let endUserID            =   "end_user_id"
    static let stylistUserId        =   "stylist_user_id"
    static let serviceIdlist        =   "service_id_list"
    static let totalLength          =   "total_length"
    static let totalPrice           =   "total_price"
    static let stylistNote          =   "stylist_notes"
    static let appointmentDate      =   "appointment_date"
    static let appointmentTime      =   "appointment_time"
}

enum CONNECTION_NETWORK_TYPE : String {
    case WIFI_NETWORK = "Wifi"
    case WWAN_NETWORK = "Cellular"
    case OTHER = "Other"
}

struct ControllerIdentifier {
    static let prodDetailViewController =  "ProductDetailViewController"
}

struct Device {
    static let device_type = "device_type"
    static let device_type_ios = "2"
    static let user_login_type = "user_login_type"
    static let user_login_type_fb = "1"
    static let user_login_type_normal = "2"
    static let device_id = "device_id"  // Push Notification Token
}

struct Regx {
    static let email = "[A-Z0-9a-z._%+-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,6}"
    static let pass = "[A-Za-z0-9.!@#$^_]{6,20}"
}

struct MESSAGES {
    //Login & Signup Messages
    static let email_empty      =   "Please enter email address."
    static let email_valid      =   "Please enter valid email address."
    
    static let pass_empty       =   "Please enter password."
    static let conform_pass_empty       =   "Please enter confirm password."
    
    static let conform_pass_no_match       =   "Password and Confirm Password are not same."
    static let pass_valid       =   "Please enter valid password."
    
    static let login_success    =   "You have successfully logged in."
    static let login_failed     =   "Something wrong in login process."
    
    //Profile
    static let personalInfoUpdated  =   "Personal Info Updated Successfully."
    static let businessInfoUpdated  =   "Business Info Updated Successfully."
    static let serviceUpdated       =   "Service Details Updated Successfully."
}

extension Dictionary {
    
    var json: String {
        let invalidJson = "Not a valid JSON"
        do {
            let jsonData = try JSONSerialization.data(withJSONObject: self, options: .prettyPrinted)
            return String(bytes: jsonData, encoding: String.Encoding.utf8) ?? invalidJson
        } catch {
            return invalidJson
        }
    }
    
    func printJson() {
        print(json)
    }
}



