//
//  Constant.swift
//  Allo Boulangerie
//
//  Created by Dharmesh Vaghani on 01/04/16.
//  Copyright © 2016 Dharmesh Vaghani. All rights reserved.
//

import UIKit

let userDefault = UserDefaults.standard
let appDelegate : AppDelegate = UIApplication.shared.delegate as! AppDelegate

class Constant  {
    
    static let screenSize = UIScreen.main.bounds
    static let storyboard = UIStoryboard(name: "Main", bundle: nil)
    
    static let logOutNotificationName = Notification.Name("logOutNotificationName")
    
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
    
    //Book Appointment
    
    static let uploadSelfiePic          =   "upload_photo_selfie.php"
    static let bookingTimeSlot          =   "get_end_user_book_appointment_stylist_time_slot.php"
    static let bookAppointment          =   "user_book_appointment.php"
    
    //Dicsover Services
    static let getDiscoverImages        =   "get_discover_end_user_gallery_image_by_business_id.php"
    static let saveLookBookImage        =   "save_end_user_lookbook_image.php"
    
    
    //LookBook
    
    static let getAllLookBook           =   "get_user_all_lookbook.php"
    static let getLookBookByID          =   "get_end_user_lookbook_all_images_by_id.php"
    static let deleteLookbookById       =   "delete_end_user_look_book_by_id.php"
    static let addLookBook              =   "add_new_end_user_lookbook.php"
    
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
    
    static let uploadBannerLogoImage    =   "upload_stylist_user_photo_logo_banner.php"
    static let deleteGalleryImage       =   "delete_gallery_byid.php"
    
    static let addManualAppointment     =   "add_stylist_user_manual_appointment.php"
    static let getStylistProfile        =   "get_end_user_stylist_profile.php"
    
    
    // Local
    
    static let getLocalStylistList      =   "local_end_user_stylist_list.php"
    
    static let logOutService            =   "sign_out_user.php"
    
    static let deleteAccount            =   "delete_user.php"
    
    static let deleteLookBookImage      =   "delete_end_user_look_book_image_by_id.php"
    
    static let uploadProfilePic         =   "upload_profile_pic_end_user.php"
    
    static let editProfile              =   "edit_user_profile.php"
    
    static let contactSupport           =   "contact_support.php"
    
    static let sendChatNotification     =   "send_notification_for_chat.php"
}

struct ChatNotifParams {
    static let sendBy           =   "sendBy"
    static let recieverId       =   "recieverId"
    static let message          =   "message"
    static let recieverType     =   "recieverType"
}

struct InitialSegue {
    static let homeToDashboardSegue     =   "homeSegue"
    static let loginSegue               =   "loginSegue"
    static let signupSegue              =   "signupSegue"
    static let homeToDeshboardWithoutAnimation =    "homeWithoutAnimationSegue"
}

struct StylistSegue {
    static let stylistDetailSegue       =   "stylistDetailSegue"
    static let showAllGalleryImageSegue =   "showAllGalleryImages"
    static let showAllServicesSegue     =   "viewAllServices"
    static let chooseDateSegue          =   "selectDateSegue"
    static let selfieSegue              =   "selfieSegue"
    static let additionalSegue          =   "additionalInfoSegue"
    static let reviewSegue              =   "reviewSegue"
}

struct LookBookSegue {
    static let viewLookBookSegue        =   "viewLookBookSegue"
    static let lookBookImageSegue       =   "lookBookImageSegue"
    static let saveImageSegue           =   "saveImageSegue"
    static let selectLookBookSegue      =   "selectLookBookSegue"
}

struct DiscoverSegue {
    static let imageDetailSegue         =   "imageDetailSegue"
    static let selectLookBookSegue      =   "selectLookBookSegue"
}

struct Segue {
    static let serviceDetails           =   "serviceDetail"
}

struct MyProfileSegue {
    static let privacyPolicySegue       =   "privacyPolicySegue"
    static let contactSupportSegue      =   "contactSupportSegue"
    static let editProfileSegue         =   "editProfileSegue"
}

struct ChatSeuge {
    static let showChatSegue            =   "showChatSegue"
}

struct DateFormate {
    static let dateFormate_1    =   "EEEE, MMMM dd, yyyy"
    static let dateFormate_2    =   "EEEE, MM/dd/yyyy"
    static let dateFormate_3    =   "EEEE"
    static let dateFormate_4    =   "yyyy-MM-dd"
    static let dateFormate_5    =   "MMMM dd, yyyy"
    static let dateFormate_6    =   "HH:mm:ss"
    static let dateFormate_7    =   "HH:mm a"
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
    static let distance         =   "distance"
}

struct EndUserParams {
    static let endUserID        =   "end_user_id"
    static let firstName        =   "first_name"
    static let lastName         =   "last_name"
    static let email            =   "email"
    static let password         =   "password"
    static let phone            =   "phone"
    static let profilePic       =   "profile_pic"
    static let fbToken          =   "fb_token"
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

struct Map {
    static let latitude     =   "end_user_latitude"
    static let longitude    =   "end_user_longitude"
    static let radius       =   "radius"
    static let offset       =   "offset"
}

struct Location {
    let tilte : String
    let latitude : Double
    let longitude : Double
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
    static let profession       =   "profession"
    static let distance         =   "distance"
    static let logoImage        =   "logo_image"
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

struct LookBookParams {
    static let lookBookId       =   "lookbook_id"
    static let lookBookName     =   "lookbook_name"
    static let lookBookTotalImg =   "total_image"
    static let lookBookImage    =   "image_name"
    
    static let lookBookImageId      =   "lookbook_image_id"
    static let lookBookDetailImage  =   "lookbook_image_name"
    static let lookBookNotes        =   "lookbook_image_notes"
    
    static let lookBookImagesName   =   "images_name"
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

struct FUserParams {
    static let FUSER_PATH							= "User"				//	Path name
    static let FUSER_OBJECTID						= "objectId"			//	String
    
    static let FUSER_EMAIL							= "email"				//	String
    static let FUSER_FIRSTNAME						= "firstname"			//	String
    static let FUSER_LASTNAME						= "lastname"			//	String
    static let FUSER_FULLNAME						= "fullname"			//	String
    static let FUSER_TYPE                           = "userType"				//	String
    static let FUSER_LOGINMETHOD					= "loginMethod"			//	String
    static let FUSER_ONESIGNALID					= "oneSignalId"			//	String
    
    static let FUSER_PICTURE						= "picture"				//	String
    static let FUSER_THUMBNAIL						= "thumbnail"			//	String
    
    static let FUSER_CREATEDAT						= "createdAt"			//	Interval
    static let FUSER_UPDATEDAT						= "updatedAt"			//	Interval
    
    static let FUSER_DBID                           =  "dbId"
}

struct FMessageParams {
    static let FMESSAGE_PATH						= "Message"				//	Path name
    static let FMESSAGE_OBJECTID					= "objectId"			//	String
    
    static let FMESSAGE_GROUPID                     = "groupId"				//	String
    static let FMESSAGE_SENDERID					= "senderId"			//	String
    static let FMESSAGE_SENDERNAME					= "senderName"			//	String
    static let FMESSAGE_SENDERINITIALS				= "senderInitials"		//	String
    
    static let FMESSAGE_TYPE						= "type"				//	String
    static let FMESSAGE_TEXT						= "text"				//	String
    
    static let FMESSAGE_PICTURE                     = "picture"				//	String
    static let FMESSAGE_PICTURE_WIDTH				= "picture_width"		//	Number
    static let FMESSAGE_PICTURE_HEIGHT				= "picture_height"		//	Number
    static let FMESSAGE_PICTURE_MD5                 = "picture_md5"			//	String
    
    static let FMESSAGE_VIDEO						= "video"				//	String
    static let FMESSAGE_VIDEO_DURATION				= "video_duration"		//	Number
    static let FMESSAGE_VIDEO_MD5					= "video_md5"			//	String
    
    static let FMESSAGE_AUDIO						= "audio"				//	String
    static let FMESSAGE_AUDIO_DURATION				= "audio_duration"		//	Number
    static let FMESSAGE_AUDIO_MD5					= "audio_md5"			//	String
    
    static let FMESSAGE_LATITUDE					= "latitude"			//	Number
    static let FMESSAGE_LONGITUDE					= "longitude"			//	Number
    
    static let FMESSAGE_STATUS						= "status"				//	String
    static let FMESSAGE_ISDELETED					= "isDeleted"			//	Boolean
    
    static let FMESSAGE_CREATEDAT					= "createdAt"			//	Interval
    static let FMESSAGE_UPDATEDAT					= "updatedAt"			//	Interval
}

struct FRecentParams {
    static let FRECENT_PATH                         =   "Recent"				//	Path name
    static let FRECENT_OBJECTID                     =   "objectId"				//	String
    
    static let FRECENT_USERID						=   "userId"				//	String
    static let FRECENT_GROUPID						=   "groupId"				//	String
    
    static let FRECENT_INITIALS                     =   "initials"				//	String
    static let FRECENT_PICTURE						=   "picture"				//	String
    static let FRECENT_DESCRIPTION					=   "description"			//	String
    static let FRECENT_MEMBERS						=   "members"				//	Array
    static let FRECENT_PASSWORD                     =   "password"				//	String
    static let FRECENT_TYPE                         =   "type"					//	String
    
    static let FRECENT_COUNTER						=   "counter"				//	Number
    static let FRECENT_LASTMESSAGE					=   "lastMessage"			//	String
    static let FRECENT_LASTMESSAGEDATE				=   "lastMessageDate"		//	Interval
    
    static let FRECENT_ISARCHIVED					=   "isArchived"			//	Boolean
    static let FRECENT_ISDELETED					=   "isDeleted"			//	Boolean
    
    static let FRECENT_CREATEDAT					=   "createdAt"			//	Interval
    static let FRECENT_UPDATEDAT					=   "updatedAt"			//	Interval
    
    static let FRECENT_DBID                         =   "dbId"              // id from data base
}

struct FStatusParams {
    static let FUSERSTATUS_PATH                     =   "UserStatus"			//	Path name
    static let FUSERSTATUS_OBJECTID                 =   "objectId"			//	String
    
    static let FUSERSTATUS_NAME                     =   "name"				//	String
    
    static let FUSERSTATUS_CREATEDAT				=   "createdAt"			//	Interval
    static let FUSERSTATUS_UPDATEDAT				=   "updatedAt"			//	Interval
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
    static let categoryId           =   "category_id"
    static let stylistId            =   "stylist_user_id"
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
    case WIFI_NETWORK   =   "Wifi"
    case WWAN_NETWORK   =   "Cellular"
    case OTHER          =   "Other"
}

struct ControllerIdentifier {
    static let prodDetailViewController =  "ProductDetailViewController"
}

struct Device {
    static let device_type          = "device_type"
    static let device_type_ios      = "2"
    static let user_login_type      = "user_login_type"
    static let user_login_type_fb   = "1"
    static let user_login_type_normal = "2"
    static let device_id            = "device_id"  // Push Notification Token
    static let udid                 =   "device_uuid"
}

struct Regx {
    static let email = "[A-Z0-9a-z._%+-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,6}"
    static let pass = "[A-Za-z0-9.!@#$^_]{6,20}"
    static let phone = "[0-9]{3}-[0-9]{3}-[0-9]{4}"
    
}

struct MESSAGES {
    //Login & Signup Messages
    static let email_empty      =   "Please enter email address."
    static let email_valid      =   "Please enter valid email address."
    static let phone_valid      =   "Please enter valid phone number."
    
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
    
    
    static let first_name_empty     = "Please enter first name."
    static let last_name_empty      = "Please enter last name."
    static let mobile_number_empty  = "Please enter phone number."
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



