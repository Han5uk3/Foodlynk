import 'dart:async';

import 'package:flutter/foundation.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:intl/intl.dart' as intl;

import 'app_localizations_ar.dart';
import 'app_localizations_en.dart';

// ignore_for_file: type=lint

/// Callers can lookup localized strings with an instance of AppLocalizations
/// returned by `AppLocalizations.of(context)`.
///
/// Applications need to include `AppLocalizations.delegate()` in their app's
/// `localizationDelegates` list, and the locales they support in the app's
/// `supportedLocales` list. For example:
///
/// ```dart
/// import 'l10n/app_localizations.dart';
///
/// return MaterialApp(
///   localizationsDelegates: AppLocalizations.localizationsDelegates,
///   supportedLocales: AppLocalizations.supportedLocales,
///   home: MyApplicationHome(),
/// );
/// ```
///
/// ## Update pubspec.yaml
///
/// Please make sure to update your pubspec.yaml to include the following
/// packages:
///
/// ```yaml
/// dependencies:
///   # Internationalization support.
///   flutter_localizations:
///     sdk: flutter
///   intl: any # Use the pinned version from flutter_localizations
///
///   # Rest of dependencies
/// ```
///
/// ## iOS Applications
///
/// iOS applications define key application metadata, including supported
/// locales, in an Info.plist file that is built into the application bundle.
/// To configure the locales supported by your app, you’ll need to edit this
/// file.
///
/// First, open your project’s ios/Runner.xcworkspace Xcode workspace file.
/// Then, in the Project Navigator, open the Info.plist file under the Runner
/// project’s Runner folder.
///
/// Next, select the Information Property List item, select Add Item from the
/// Editor menu, then select Localizations from the pop-up menu.
///
/// Select and expand the newly-created Localizations item then, for each
/// locale your application supports, add a new item and select the locale
/// you wish to add from the pop-up menu in the Value field. This list should
/// be consistent with the languages listed in the AppLocalizations.supportedLocales
/// property.
abstract class AppLocalizations {
  AppLocalizations(String locale)
      : localeName = intl.Intl.canonicalizedLocale(locale.toString());

  final String localeName;

  static AppLocalizations? of(BuildContext context) {
    return Localizations.of<AppLocalizations>(context, AppLocalizations);
  }

  static const LocalizationsDelegate<AppLocalizations> delegate =
      _AppLocalizationsDelegate();

  /// A list of this localizations delegate along with the default localizations
  /// delegates.
  ///
  /// Returns a list of localizations delegates containing this delegate along with
  /// GlobalMaterialLocalizations.delegate, GlobalCupertinoLocalizations.delegate,
  /// and GlobalWidgetsLocalizations.delegate.
  ///
  /// Additional delegates can be added by appending to this list in
  /// MaterialApp. This list does not have to be used at all if a custom list
  /// of delegates is preferred or required.
  static const List<LocalizationsDelegate<dynamic>> localizationsDelegates =
      <LocalizationsDelegate<dynamic>>[
    delegate,
    GlobalMaterialLocalizations.delegate,
    GlobalCupertinoLocalizations.delegate,
    GlobalWidgetsLocalizations.delegate,
  ];

  /// A list of this localizations delegate's supported locales.
  static const List<Locale> supportedLocales = <Locale>[
    Locale('ar'),
    Locale('en')
  ];

  /// No description provided for @loginUsingMobileNumber.
  ///
  /// In en, this message translates to:
  /// **'Login Using Mobile Number'**
  String get loginUsingMobileNumber;

  /// No description provided for @enterTenDigitMobileNumber.
  ///
  /// In en, this message translates to:
  /// **'Enter 10 digit mobile number'**
  String get enterTenDigitMobileNumber;

  /// No description provided for @iAgreeWithTheTermsAndCondition.
  ///
  /// In en, this message translates to:
  /// **'I agree with the Terms & Conditions'**
  String get iAgreeWithTheTermsAndCondition;

  /// No description provided for @loginWithPassword.
  ///
  /// In en, this message translates to:
  /// **'Login with Password'**
  String get loginWithPassword;

  /// No description provided for @otp.
  ///
  /// In en, this message translates to:
  /// **'OTP'**
  String get otp;

  /// No description provided for @or.
  ///
  /// In en, this message translates to:
  /// **'OR'**
  String get or;

  /// No description provided for @continueAsGuest.
  ///
  /// In en, this message translates to:
  /// **'Continue as Guest'**
  String get continueAsGuest;

  /// No description provided for @createProfile.
  ///
  /// In en, this message translates to:
  /// **'Create Profile'**
  String get createProfile;

  /// No description provided for @firstName.
  ///
  /// In en, this message translates to:
  /// **'First Name'**
  String get firstName;

  /// No description provided for @mr.
  ///
  /// In en, this message translates to:
  /// **'Mr.'**
  String get mr;

  /// No description provided for @mrs.
  ///
  /// In en, this message translates to:
  /// **'Mrs.'**
  String get mrs;

  /// No description provided for @ms.
  ///
  /// In en, this message translates to:
  /// **'Ms.'**
  String get ms;

  /// No description provided for @dr.
  ///
  /// In en, this message translates to:
  /// **'Dr.'**
  String get dr;

  /// No description provided for @prof.
  ///
  /// In en, this message translates to:
  /// **'Prof.'**
  String get prof;

  /// No description provided for @enterFirstName.
  ///
  /// In en, this message translates to:
  /// **'Enter First Name'**
  String get enterFirstName;

  /// No description provided for @lastName.
  ///
  /// In en, this message translates to:
  /// **'Last Name'**
  String get lastName;

  /// No description provided for @enterLastName.
  ///
  /// In en, this message translates to:
  /// **'Enter Last Name'**
  String get enterLastName;

  /// No description provided for @gender.
  ///
  /// In en, this message translates to:
  /// **'Gender'**
  String get gender;

  /// No description provided for @male.
  ///
  /// In en, this message translates to:
  /// **'Male'**
  String get male;

  /// No description provided for @female.
  ///
  /// In en, this message translates to:
  /// **'Female'**
  String get female;

  /// No description provided for @other.
  ///
  /// In en, this message translates to:
  /// **'Other'**
  String get other;

  /// No description provided for @dob.
  ///
  /// In en, this message translates to:
  /// **'D.O.B'**
  String get dob;

  /// No description provided for @address.
  ///
  /// In en, this message translates to:
  /// **'Address'**
  String get address;

  /// No description provided for @enterAddress.
  ///
  /// In en, this message translates to:
  /// **'Enter Address'**
  String get enterAddress;

  /// No description provided for @choose.
  ///
  /// In en, this message translates to:
  /// **'Choose'**
  String get choose;

  /// No description provided for @pinCode.
  ///
  /// In en, this message translates to:
  /// **'Pin Code'**
  String get pinCode;

  /// No description provided for @enterPincode.
  ///
  /// In en, this message translates to:
  /// **'Enter Pincode'**
  String get enterPincode;

  /// No description provided for @nationality.
  ///
  /// In en, this message translates to:
  /// **'Nationality'**
  String get nationality;

  /// No description provided for @emailId.
  ///
  /// In en, this message translates to:
  /// **'Email ID'**
  String get emailId;

  /// No description provided for @enterEmailId.
  ///
  /// In en, this message translates to:
  /// **'Enter Email ID'**
  String get enterEmailId;

  /// No description provided for @pleaseSelectADateOfBirth.
  ///
  /// In en, this message translates to:
  /// **'Please select a date of birth'**
  String get pleaseSelectADateOfBirth;

  /// No description provided for @pleaseSelectFoodTypeAndLocation.
  ///
  /// In en, this message translates to:
  /// **'Please select food type and location'**
  String get pleaseSelectFoodTypeAndLocation;

  /// No description provided for @selectFoodType.
  ///
  /// In en, this message translates to:
  /// **'Select Food Type'**
  String get selectFoodType;

  /// No description provided for @saveFoodSaveMoneySaveThePlanet.
  ///
  /// In en, this message translates to:
  /// **'Save Food, Save Money, Save the Planet!'**
  String get saveFoodSaveMoneySaveThePlanet;

  /// No description provided for @quickActions.
  ///
  /// In en, this message translates to:
  /// **'Quick Actions'**
  String get quickActions;

  /// No description provided for @zeroWasteChallenges.
  ///
  /// In en, this message translates to:
  /// **'Zero Waste Challenges'**
  String get zeroWasteChallenges;

  /// No description provided for @kitchenManager.
  ///
  /// In en, this message translates to:
  /// **'Kitchen Manager'**
  String get kitchenManager;

  /// No description provided for @smartShoppingList.
  ///
  /// In en, this message translates to:
  /// **'Smart Shopping List'**
  String get smartShoppingList;

  /// No description provided for @foodShare.
  ///
  /// In en, this message translates to:
  /// **'Food Share'**
  String get foodShare;

  /// No description provided for @foodSwap.
  ///
  /// In en, this message translates to:
  /// **'Food Swap'**
  String get foodSwap;

  /// No description provided for @smartRecipes.
  ///
  /// In en, this message translates to:
  /// **'Smart Recipes'**
  String get smartRecipes;

  /// No description provided for @zeroWasteCooking.
  ///
  /// In en, this message translates to:
  /// **'Zero Waste Cooking'**
  String get zeroWasteCooking;

  /// No description provided for @home.
  ///
  /// In en, this message translates to:
  /// **'Home'**
  String get home;

  /// No description provided for @community.
  ///
  /// In en, this message translates to:
  /// **'Community'**
  String get community;

  /// No description provided for @notification.
  ///
  /// In en, this message translates to:
  /// **'Notification'**
  String get notification;

  /// No description provided for @profile.
  ///
  /// In en, this message translates to:
  /// **'Profile'**
  String get profile;

  /// No description provided for @totalPoints.
  ///
  /// In en, this message translates to:
  /// **'Total Points'**
  String get totalPoints;

  /// No description provided for @takeAChallengeSaveFoodAndEarnReward.
  ///
  /// In en, this message translates to:
  /// **'Take a challenge, save food, and earn reward'**
  String get takeAChallengeSaveFoodAndEarnReward;

  /// No description provided for @cleanPlateChallenge.
  ///
  /// In en, this message translates to:
  /// **'Clean Plate Challenge'**
  String get cleanPlateChallenge;

  /// No description provided for @tenpoints.
  ///
  /// In en, this message translates to:
  /// **'+10 points'**
  String get tenpoints;

  /// No description provided for @finishYourEntireMeal.
  ///
  /// In en, this message translates to:
  /// **'Finish your entire meal withoit leftovers and upload a before & after photo.'**
  String get finishYourEntireMeal;

  /// No description provided for @stepsToComplete.
  ///
  /// In en, this message translates to:
  /// **'Steps to Complete'**
  String get stepsToComplete;

  /// No description provided for @takeABeforePhotoOfYourFullPlate.
  ///
  /// In en, this message translates to:
  /// **'Take a before photo of your full plate'**
  String get takeABeforePhotoOfYourFullPlate;

  /// No description provided for @enjoyYourMeal.
  ///
  /// In en, this message translates to:
  /// **'Enjoy your Meal!'**
  String get enjoyYourMeal;

  /// No description provided for @takeAnAfterPhotoOfYourCleanPlate.
  ///
  /// In en, this message translates to:
  /// **'Take an after photo of your clean plate'**
  String get takeAnAfterPhotoOfYourCleanPlate;

  /// No description provided for @submitForVerification.
  ///
  /// In en, this message translates to:
  /// **'Submit for verification!'**
  String get submitForVerification;

  /// No description provided for @uploading.
  ///
  /// In en, this message translates to:
  /// **'Uploading'**
  String get uploading;

  /// No description provided for @processing.
  ///
  /// In en, this message translates to:
  /// **'Processing'**
  String get processing;

  /// No description provided for @uploadBeforeImage.
  ///
  /// In en, this message translates to:
  /// **'Upload before image'**
  String get uploadBeforeImage;

  /// No description provided for @uploadAfterImage.
  ///
  /// In en, this message translates to:
  /// **'Upload after image'**
  String get uploadAfterImage;

  /// No description provided for @submitChallenge.
  ///
  /// In en, this message translates to:
  /// **'Submit Challenge'**
  String get submitChallenge;

  /// No description provided for @submitting.
  ///
  /// In en, this message translates to:
  /// **'Submitting...'**
  String get submitting;

  /// No description provided for @beforeImageUploadedSuccessfully.
  ///
  /// In en, this message translates to:
  /// **'Before image uploaded successfully!'**
  String get beforeImageUploadedSuccessfully;

  /// No description provided for @weCouldntVerifyFood.
  ///
  /// In en, this message translates to:
  /// **'We couldn\'t verify food on the plate.Please try a clearer image.'**
  String get weCouldntVerifyFood;

  /// No description provided for @theAfterimageDoesntShow.
  ///
  /// In en, this message translates to:
  /// **'The after doesn\'t show a clean plate. Please try again.'**
  String get theAfterimageDoesntShow;

  /// No description provided for @pleaseUploadTheBeforeImageFirst.
  ///
  /// In en, this message translates to:
  /// **'Please upload the before image first'**
  String get pleaseUploadTheBeforeImageFirst;

  /// No description provided for @afterImageUploadedSuccessfully.
  ///
  /// In en, this message translates to:
  /// **'After image uploaded successfully!'**
  String get afterImageUploadedSuccessfully;

  /// No description provided for @congratulations.
  ///
  /// In en, this message translates to:
  /// **'Congratulations!'**
  String get congratulations;

  /// No description provided for @youEarnedTenPointsOn.
  ///
  /// In en, this message translates to:
  /// **'You earned 10 points on completiing your challenge!'**
  String get youEarnedTenPointsOn;

  /// No description provided for @back.
  ///
  /// In en, this message translates to:
  /// **'back'**
  String get back;

  /// No description provided for @youveConsumedZeroOfYourFood.
  ///
  /// In en, this message translates to:
  /// **'You\'ve consumed 0% of your food before expiry this month!'**
  String get youveConsumedZeroOfYourFood;

  /// No description provided for @serachItems.
  ///
  /// In en, this message translates to:
  /// **'search items'**
  String get serachItems;

  /// No description provided for @expired.
  ///
  /// In en, this message translates to:
  /// **'Expired'**
  String get expired;

  /// No description provided for @expiringSoon.
  ///
  /// In en, this message translates to:
  /// **'Expiring Soon'**
  String get expiringSoon;

  /// No description provided for @fresh.
  ///
  /// In en, this message translates to:
  /// **'Fresh'**
  String get fresh;

  /// No description provided for @allItems.
  ///
  /// In en, this message translates to:
  /// **'All Items'**
  String get allItems;

  /// No description provided for @noItemsFound.
  ///
  /// In en, this message translates to:
  /// **'No items found'**
  String get noItemsFound;

  /// No description provided for @freshItems.
  ///
  /// In en, this message translates to:
  /// **'Fresh Items'**
  String get freshItems;

  /// No description provided for @itemsExpiringSoon.
  ///
  /// In en, this message translates to:
  /// **'Items Expiring Soon'**
  String get itemsExpiringSoon;

  /// No description provided for @expiredItems.
  ///
  /// In en, this message translates to:
  /// **'Expired Items'**
  String get expiredItems;

  /// No description provided for @addItem.
  ///
  /// In en, this message translates to:
  /// **'Add Item'**
  String get addItem;

  /// No description provided for @itemName.
  ///
  /// In en, this message translates to:
  /// **'Item Name'**
  String get itemName;

  /// No description provided for @enterItemName.
  ///
  /// In en, this message translates to:
  /// **'Enter Item Name'**
  String get enterItemName;

  /// No description provided for @category.
  ///
  /// In en, this message translates to:
  /// **'Category'**
  String get category;

  /// No description provided for @dairy.
  ///
  /// In en, this message translates to:
  /// **'Dairy'**
  String get dairy;

  /// No description provided for @expiryDate.
  ///
  /// In en, this message translates to:
  /// **'Expiry Date'**
  String get expiryDate;

  /// No description provided for @uploadImage.
  ///
  /// In en, this message translates to:
  /// **'Upload Image'**
  String get uploadImage;

  /// No description provided for @plaeseenterItemName.
  ///
  /// In en, this message translates to:
  /// **'Please enter item name'**
  String get plaeseenterItemName;

  /// No description provided for @pleaseSelectAUnitType.
  ///
  /// In en, this message translates to:
  /// **'Please select a unit type'**
  String get pleaseSelectAUnitType;

  /// No description provided for @pleaseEnterQuantity.
  ///
  /// In en, this message translates to:
  /// **'Please enter quantity'**
  String get pleaseEnterQuantity;

  /// No description provided for @pleaseSelectACategory.
  ///
  /// In en, this message translates to:
  /// **'Please select a category'**
  String get pleaseSelectACategory;

  /// No description provided for @thisItemExpiresToday.
  ///
  /// In en, this message translates to:
  /// **'This item expires today'**
  String get thisItemExpiresToday;

  /// No description provided for @moveToShopping.
  ///
  /// In en, this message translates to:
  /// **'Move to Shopping'**
  String get moveToShopping;

  /// No description provided for @removeFromList.
  ///
  /// In en, this message translates to:
  /// **'Remove from list'**
  String get removeFromList;

  /// No description provided for @itemRemoved.
  ///
  /// In en, this message translates to:
  /// **'Item Removed'**
  String get itemRemoved;

  /// No description provided for @newItemAddedToKitchen.
  ///
  /// In en, this message translates to:
  /// **'New Item Added to kitchen'**
  String get newItemAddedToKitchen;

  /// No description provided for @thisItemExpiresInOneDay.
  ///
  /// In en, this message translates to:
  /// **'This item expires in 1 day'**
  String get thisItemExpiresInOneDay;

  /// No description provided for @thisItemExpiresInTwoDay.
  ///
  /// In en, this message translates to:
  /// **'This item expires in 2 day'**
  String get thisItemExpiresInTwoDay;

  /// No description provided for @thisItemExpiresInThreeDay.
  ///
  /// In en, this message translates to:
  /// **'This item expires in 3 day'**
  String get thisItemExpiresInThreeDay;

  /// No description provided for @thisItemIsStillFresh.
  ///
  /// In en, this message translates to:
  /// **'This item is still fresh'**
  String get thisItemIsStillFresh;

  /// No description provided for @selectAList.
  ///
  /// In en, this message translates to:
  /// **'Select a list'**
  String get selectAList;

  /// No description provided for @selectAnOption.
  ///
  /// In en, this message translates to:
  /// **'Select an option'**
  String get selectAnOption;

  /// No description provided for @pleaseSelectAList.
  ///
  /// In en, this message translates to:
  /// **'please selecct a list'**
  String get pleaseSelectAList;

  /// No description provided for @addToList.
  ///
  /// In en, this message translates to:
  /// **'Add to list'**
  String get addToList;

  /// No description provided for @shoppingLists.
  ///
  /// In en, this message translates to:
  /// **'Shopping Lists'**
  String get shoppingLists;

  /// No description provided for @noShppingListsFound.
  ///
  /// In en, this message translates to:
  /// **'No shopping lists found'**
  String get noShppingListsFound;

  /// No description provided for @searchList.
  ///
  /// In en, this message translates to:
  /// **'search list'**
  String get searchList;

  /// No description provided for @addShoppingList.
  ///
  /// In en, this message translates to:
  /// **'Add Shopping List'**
  String get addShoppingList;

  /// No description provided for @listName.
  ///
  /// In en, this message translates to:
  /// **'List Name'**
  String get listName;

  /// No description provided for @enterListName.
  ///
  /// In en, this message translates to:
  /// **'Enter list name'**
  String get enterListName;

  /// No description provided for @saveChanges.
  ///
  /// In en, this message translates to:
  /// **'Save Changes'**
  String get saveChanges;

  /// No description provided for @noItemsInTheList.
  ///
  /// In en, this message translates to:
  /// **'No items in the list'**
  String get noItemsInTheList;

  /// No description provided for @all.
  ///
  /// In en, this message translates to:
  /// **'All'**
  String get all;

  /// No description provided for @purchased.
  ///
  /// In en, this message translates to:
  /// **'Purchased'**
  String get purchased;

  /// No description provided for @editShoppingList.
  ///
  /// In en, this message translates to:
  /// **'Edit Shopping List'**
  String get editShoppingList;

  /// No description provided for @weeklyGrocery.
  ///
  /// In en, this message translates to:
  /// **'Weekly Grocery'**
  String get weeklyGrocery;

  /// No description provided for @yourNewListHasBeenCreated.
  ///
  /// In en, this message translates to:
  /// **'Your new list has been created'**
  String get yourNewListHasBeenCreated;

  /// No description provided for @listNameChangedSuccessfully.
  ///
  /// In en, this message translates to:
  /// **'List name changed successfully'**
  String get listNameChangedSuccessfully;

  /// No description provided for @noPurchasedItems.
  ///
  /// In en, this message translates to:
  /// **'No purchased items'**
  String get noPurchasedItems;

  /// No description provided for @addNewItem.
  ///
  /// In en, this message translates to:
  /// **'Add New Item'**
  String get addNewItem;

  /// No description provided for @itemAddedSuccessfully.
  ///
  /// In en, this message translates to:
  /// **'Item added Successfully'**
  String get itemAddedSuccessfully;

  /// No description provided for @noteWhenanItemIsPurchased.
  ///
  /// In en, this message translates to:
  /// **'Note: When an item is purchased, it will be moved to the kitchen manager for tracking!'**
  String get noteWhenanItemIsPurchased;

  /// No description provided for @itemPurchasedSuccessfully.
  ///
  /// In en, this message translates to:
  /// **'Item purchasedsuccessfully'**
  String get itemPurchasedSuccessfully;

  /// No description provided for @howWouldYouLikeToProceed.
  ///
  /// In en, this message translates to:
  /// **'How would you like to proceed?'**
  String get howWouldYouLikeToProceed;

  /// No description provided for @donor.
  ///
  /// In en, this message translates to:
  /// **'Donor'**
  String get donor;

  /// No description provided for @shareFoodWithOthers.
  ///
  /// In en, this message translates to:
  /// **'Share food with others'**
  String get shareFoodWithOthers;

  /// No description provided for @continueText.
  ///
  /// In en, this message translates to:
  /// **'Continue'**
  String get continueText;

  /// No description provided for @beneficiary.
  ///
  /// In en, this message translates to:
  /// **'Beneficiary'**
  String get beneficiary;

  /// No description provided for @receiveAvailableFood.
  ///
  /// In en, this message translates to:
  /// **'Receive available food'**
  String get receiveAvailableFood;

  /// No description provided for @myRequests.
  ///
  /// In en, this message translates to:
  /// **'My Requests'**
  String get myRequests;

  /// No description provided for @globalDonations.
  ///
  /// In en, this message translates to:
  /// **'Global Donations'**
  String get globalDonations;

  /// No description provided for @picked.
  ///
  /// In en, this message translates to:
  /// **'Picked'**
  String get picked;

  /// No description provided for @donatedOn.
  ///
  /// In en, this message translates to:
  /// **'Donated On:'**
  String get donatedOn;

  /// No description provided for @serves.
  ///
  /// In en, this message translates to:
  /// **'Serves:'**
  String get serves;

  /// No description provided for @donationDetails.
  ///
  /// In en, this message translates to:
  /// **'Donation Details'**
  String get donationDetails;

  /// No description provided for @description.
  ///
  /// In en, this message translates to:
  /// **'Description'**
  String get description;

  /// No description provided for @expiresOn.
  ///
  /// In en, this message translates to:
  /// **'Expires On:'**
  String get expiresOn;

  /// No description provided for @pickupLocation.
  ///
  /// In en, this message translates to:
  /// **'Pickup Location'**
  String get pickupLocation;

  /// No description provided for @imInterested.
  ///
  /// In en, this message translates to:
  /// **'I\'m Interested'**
  String get imInterested;

  /// No description provided for @alreadyInterested.
  ///
  /// In en, this message translates to:
  /// **'Already Interested'**
  String get alreadyInterested;

  /// No description provided for @myDonationsRequests.
  ///
  /// In en, this message translates to:
  /// **'My Donation & Requests'**
  String get myDonationsRequests;

  /// No description provided for @noDonationsFound.
  ///
  /// In en, this message translates to:
  /// **'No Donations found'**
  String get noDonationsFound;

  /// No description provided for @noBenificiaryFound.
  ///
  /// In en, this message translates to:
  /// **'No Beneficiary found'**
  String get noBenificiaryFound;

  /// No description provided for @newText.
  ///
  /// In en, this message translates to:
  /// **'New'**
  String get newText;

  /// No description provided for @chooseRole.
  ///
  /// In en, this message translates to:
  /// **'Choose Role'**
  String get chooseRole;

  /// No description provided for @addDonation.
  ///
  /// In en, this message translates to:
  /// **'Add Donation'**
  String get addDonation;

  /// No description provided for @foodInformation.
  ///
  /// In en, this message translates to:
  /// **'Food Information'**
  String get foodInformation;

  /// No description provided for @foodName.
  ///
  /// In en, this message translates to:
  /// **'Food Name'**
  String get foodName;

  /// No description provided for @enterFoodName.
  ///
  /// In en, this message translates to:
  /// **'Enter food name'**
  String get enterFoodName;

  /// No description provided for @foodType.
  ///
  /// In en, this message translates to:
  /// **'Food Type'**
  String get foodType;

  /// No description provided for @meat.
  ///
  /// In en, this message translates to:
  /// **'Meat'**
  String get meat;

  /// No description provided for @vegetable.
  ///
  /// In en, this message translates to:
  /// **'Vegetable'**
  String get vegetable;

  /// No description provided for @fruit.
  ///
  /// In en, this message translates to:
  /// **'Fruit'**
  String get fruit;

  /// No description provided for @oils.
  ///
  /// In en, this message translates to:
  /// **'Oils'**
  String get oils;

  /// No description provided for @poultry.
  ///
  /// In en, this message translates to:
  /// **'Poultry'**
  String get poultry;

  /// No description provided for @seafood.
  ///
  /// In en, this message translates to:
  /// **'Seafood'**
  String get seafood;

  /// No description provided for @numberOfServes.
  ///
  /// In en, this message translates to:
  /// **'Number of Serves'**
  String get numberOfServes;

  /// No description provided for @descriptionAndExpiry.
  ///
  /// In en, this message translates to:
  /// **'Description & Expiry'**
  String get descriptionAndExpiry;

  /// No description provided for @describeWhyYouAreDonatingIt.
  ///
  /// In en, this message translates to:
  /// **'Describe why you are donating it...'**
  String get describeWhyYouAreDonatingIt;

  /// No description provided for @locationAndImage.
  ///
  /// In en, this message translates to:
  /// **'Location & Image'**
  String get locationAndImage;

  /// No description provided for @enterPickupLocation.
  ///
  /// In en, this message translates to:
  /// **'Enter pickup Location'**
  String get enterPickupLocation;

  /// No description provided for @foodImage.
  ///
  /// In en, this message translates to:
  /// **'Food Image'**
  String get foodImage;

  /// No description provided for @iCertifyThatTheFood.
  ///
  /// In en, this message translates to:
  /// **'I certify that the food I donated is safe to eat and has beem stored in tightly sealed containers in accordance with health guidelines. I pledge to bear full and leagal responsibility for all consewuences of its use and disposal.I also release (Ne\'ma Savers) from all liability for the food I donated.'**
  String get iCertifyThatTheFood;

  /// No description provided for @submitDonation.
  ///
  /// In en, this message translates to:
  /// **'Submit Donation'**
  String get submitDonation;

  /// No description provided for @pleaseFillInAllRequiredFields.
  ///
  /// In en, this message translates to:
  /// **'Please fill in all required fields'**
  String get pleaseFillInAllRequiredFields;

  /// No description provided for @requestDetails.
  ///
  /// In en, this message translates to:
  /// **'Request Details'**
  String get requestDetails;

  /// No description provided for @noRequestAvailableYet.
  ///
  /// In en, this message translates to:
  /// **'No requests available yet'**
  String get noRequestAvailableYet;

  /// No description provided for @whenSomeoneRequestsThisDonation.
  ///
  /// In en, this message translates to:
  /// **'When someone request this donation, they will appear here'**
  String get whenSomeoneRequestsThisDonation;

  /// No description provided for @deleteRequest.
  ///
  /// In en, this message translates to:
  /// **'Delete Request'**
  String get deleteRequest;

  /// No description provided for @areYouSureWantToDeletThisRequest.
  ///
  /// In en, this message translates to:
  /// **'Are you sure you want to delete this request?'**
  String get areYouSureWantToDeletThisRequest;

  /// No description provided for @yes.
  ///
  /// In en, this message translates to:
  /// **'Yes'**
  String get yes;

  /// No description provided for @no.
  ///
  /// In en, this message translates to:
  /// **'No'**
  String get no;

  /// No description provided for @requestDeletedSuccessfully.
  ///
  /// In en, this message translates to:
  /// **'Request Deleted Successfully'**
  String get requestDeletedSuccessfully;

  /// No description provided for @pleaseAcceptTheTermsAndConditions.
  ///
  /// In en, this message translates to:
  /// **'Please accept the terms and conditions'**
  String get pleaseAcceptTheTermsAndConditions;

  /// No description provided for @youHaveZeroPendingRequest.
  ///
  /// In en, this message translates to:
  /// **'You have 0 pending requests'**
  String get youHaveZeroPendingRequest;

  /// No description provided for @pending.
  ///
  /// In en, this message translates to:
  /// **'Pending'**
  String get pending;

  /// No description provided for @addBeneficairy.
  ///
  /// In en, this message translates to:
  /// **'Add Beneficiary'**
  String get addBeneficairy;

  /// No description provided for @requestInformation.
  ///
  /// In en, this message translates to:
  /// **'Request Infromation'**
  String get requestInformation;

  /// No description provided for @foodTypeRequired.
  ///
  /// In en, this message translates to:
  /// **'Food Type Required'**
  String get foodTypeRequired;

  /// No description provided for @preferredPickupLocation.
  ///
  /// In en, this message translates to:
  /// **'Preferred Pickup Location'**
  String get preferredPickupLocation;

  /// No description provided for @enterPreferredLocation.
  ///
  /// In en, this message translates to:
  /// **'Enter Preferred location'**
  String get enterPreferredLocation;

  /// No description provided for @contactInformation.
  ///
  /// In en, this message translates to:
  /// **'Contact Information'**
  String get contactInformation;

  /// No description provided for @thisInformationWillBeShared.
  ///
  /// In en, this message translates to:
  /// **'This information will be shared with the donor when they accept your request'**
  String get thisInformationWillBeShared;

  /// No description provided for @yourName.
  ///
  /// In en, this message translates to:
  /// **'Your Name'**
  String get yourName;

  /// No description provided for @enterYourName.
  ///
  /// In en, this message translates to:
  /// **'Enter your name'**
  String get enterYourName;

  /// No description provided for @mobileNumber.
  ///
  /// In en, this message translates to:
  /// **'Mobile Number'**
  String get mobileNumber;

  /// No description provided for @enterMobileNumber.
  ///
  /// In en, this message translates to:
  /// **'EnterMobileNumber'**
  String get enterMobileNumber;

  /// No description provided for @receivedOn.
  ///
  /// In en, this message translates to:
  /// **'Recevied On,available'**
  String get receivedOn;

  /// No description provided for @contact.
  ///
  /// In en, this message translates to:
  /// **'Contact:'**
  String get contact;

  /// No description provided for @requestSend.
  ///
  /// In en, this message translates to:
  /// **'Request send'**
  String get requestSend;

  /// No description provided for @youAreAlreadyInQueuePleaseWaitUntil.
  ///
  /// In en, this message translates to:
  /// **'You are already in queue. Please wait until your interest is accepted'**
  String get youAreAlreadyInQueuePleaseWaitUntil;

  /// No description provided for @myListings.
  ///
  /// In en, this message translates to:
  /// **'My Listings'**
  String get myListings;

  /// No description provided for @availableSwaps.
  ///
  /// In en, this message translates to:
  /// **'Available Swaps'**
  String get availableSwaps;

  /// No description provided for @noFoodSwapListingsAvailable.
  ///
  /// In en, this message translates to:
  /// **'No food swap Listings available'**
  String get noFoodSwapListingsAvailable;

  /// No description provided for @tapTheButtonToCReateANewListing.
  ///
  /// In en, this message translates to:
  /// **'Tap the + button to create a new listing'**
  String get tapTheButtonToCReateANewListing;

  /// No description provided for @requestSwap.
  ///
  /// In en, this message translates to:
  /// **'Request Swap'**
  String get requestSwap;

  /// No description provided for @quantity.
  ///
  /// In en, this message translates to:
  /// **'Quantity'**
  String get quantity;

  /// No description provided for @foodSwapRequest.
  ///
  /// In en, this message translates to:
  /// **'Food Swap Request'**
  String get foodSwapRequest;

  /// No description provided for @yourSwapItem.
  ///
  /// In en, this message translates to:
  /// **'Your Swap Item'**
  String get yourSwapItem;

  /// No description provided for @noItemAvailable.
  ///
  /// In en, this message translates to:
  /// **'No item available'**
  String get noItemAvailable;

  /// No description provided for @pleaseFillInAllFields.
  ///
  /// In en, this message translates to:
  /// **'Please fill in all fields'**
  String get pleaseFillInAllFields;

  /// No description provided for @selectDate.
  ///
  /// In en, this message translates to:
  /// **'Select date'**
  String get selectDate;

  /// No description provided for @cancel.
  ///
  /// In en, this message translates to:
  /// **'Cancel'**
  String get cancel;

  /// No description provided for @ok.
  ///
  /// In en, this message translates to:
  /// **'OK'**
  String get ok;

  /// No description provided for @done.
  ///
  /// In en, this message translates to:
  /// **'Done'**
  String get done;

  /// No description provided for @selectTime.
  ///
  /// In en, this message translates to:
  /// **'Select Time'**
  String get selectTime;

  /// No description provided for @submitSwapRequest.
  ///
  /// In en, this message translates to:
  /// **'Submit Swap Request'**
  String get submitSwapRequest;

  /// No description provided for @available.
  ///
  /// In en, this message translates to:
  /// **'available'**
  String get available;

  /// No description provided for @garlicBread.
  ///
  /// In en, this message translates to:
  /// **'Garlic Bread'**
  String get garlicBread;

  /// No description provided for @addToListing.
  ///
  /// In en, this message translates to:
  /// **'Add to Listing'**
  String get addToListing;

  /// No description provided for @foodSwapSuccess.
  ///
  /// In en, this message translates to:
  /// **'Food Swap Success'**
  String get foodSwapSuccess;

  /// No description provided for @zeroRequestsPending.
  ///
  /// In en, this message translates to:
  /// **'0 Requests Pending'**
  String get zeroRequestsPending;

  /// No description provided for @noRequestsFound.
  ///
  /// In en, this message translates to:
  /// **'No requests found'**
  String get noRequestsFound;

  /// No description provided for @checkBackLaterForNewRequests.
  ///
  /// In en, this message translates to:
  /// **'Check back later for new requests'**
  String get checkBackLaterForNewRequests;

  /// No description provided for @foodSwapUpdatedSuccessfuly.
  ///
  /// In en, this message translates to:
  /// **'Food Swap Updated Successfully'**
  String get foodSwapUpdatedSuccessfuly;

  /// No description provided for @deleteItem.
  ///
  /// In en, this message translates to:
  /// **'Delete Item'**
  String get deleteItem;

  /// No description provided for @areYouSureWantToDeletThisItem.
  ///
  /// In en, this message translates to:
  /// **'Are you sure you want to delete this item? This action cannot be undone.'**
  String get areYouSureWantToDeletThisItem;

  /// No description provided for @generateNewRecipe.
  ///
  /// In en, this message translates to:
  /// **'Generate New Recepie'**
  String get generateNewRecipe;

  /// No description provided for @noteYourKitchenMustHaveAtLeastFive.
  ///
  /// In en, this message translates to:
  /// **'NOTE: Your kitchen must have at least 5 items to generate a recipe'**
  String get noteYourKitchenMustHaveAtLeastFive;

  /// No description provided for @selectIngredients.
  ///
  /// In en, this message translates to:
  /// **'Select Ingredients (Choose at least 5)'**
  String get selectIngredients;

  /// No description provided for @generateRecipe.
  ///
  /// In en, this message translates to:
  /// **'Generate Recipe'**
  String get generateRecipe;

  /// No description provided for @generatedRecipes.
  ///
  /// In en, this message translates to:
  /// **'Generated Recipes'**
  String get generatedRecipes;

  /// No description provided for @generatingYourRecipe.
  ///
  /// In en, this message translates to:
  /// **'Generating your recipe...'**
  String get generatingYourRecipe;

  /// No description provided for @cookSmartReduceWaste.
  ///
  /// In en, this message translates to:
  /// **'Cook Smart Reduce Waste!'**
  String get cookSmartReduceWaste;

  /// No description provided for @cookWhatJustEnoughForNeeds.
  ///
  /// In en, this message translates to:
  /// **'Cook what just enough for your needs - no more, no less'**
  String get cookWhatJustEnoughForNeeds;

  /// No description provided for @whatAreYouCooking.
  ///
  /// In en, this message translates to:
  /// **'What are you Cooking?'**
  String get whatAreYouCooking;

  /// No description provided for @breakfast.
  ///
  /// In en, this message translates to:
  /// **'Breakfast'**
  String get breakfast;

  /// No description provided for @lunch.
  ///
  /// In en, this message translates to:
  /// **'Lunch'**
  String get lunch;

  /// No description provided for @dinner.
  ///
  /// In en, this message translates to:
  /// **'Dinner'**
  String get dinner;

  /// No description provided for @snack.
  ///
  /// In en, this message translates to:
  /// **'Snack'**
  String get snack;

  /// No description provided for @toWhomAreYouCooking.
  ///
  /// In en, this message translates to:
  /// **'To Whom are you cooking?'**
  String get toWhomAreYouCooking;

  /// No description provided for @dailyMeal.
  ///
  /// In en, this message translates to:
  /// **'Daily Meat'**
  String get dailyMeal;

  /// No description provided for @familyGathering.
  ///
  /// In en, this message translates to:
  /// **'Family Gathering'**
  String get familyGathering;

  /// No description provided for @party.
  ///
  /// In en, this message translates to:
  /// **'Party'**
  String get party;

  /// No description provided for @howManyPeopleAreEating.
  ///
  /// In en, this message translates to:
  /// **'How many people are eating?'**
  String get howManyPeopleAreEating;

  /// No description provided for @dietaryPreferances.
  ///
  /// In en, this message translates to:
  /// **'Dietary Preferances?'**
  String get dietaryPreferances;

  /// No description provided for @vegetarian.
  ///
  /// In en, this message translates to:
  /// **'Vegetarian'**
  String get vegetarian;

  /// No description provided for @vegan.
  ///
  /// In en, this message translates to:
  /// **'Vegan'**
  String get vegan;

  /// No description provided for @noPreferances.
  ///
  /// In en, this message translates to:
  /// **'No Preferances'**
  String get noPreferances;

  /// No description provided for @getPortionPlan.
  ///
  /// In en, this message translates to:
  /// **'Get Portion Plan'**
  String get getPortionPlan;

  /// No description provided for @nochatRoomsFound.
  ///
  /// In en, this message translates to:
  /// **'No chat rooms found'**
  String get nochatRoomsFound;

  /// No description provided for @expiryAlert.
  ///
  /// In en, this message translates to:
  /// **'Expiry Alert'**
  String get expiryAlert;

  /// No description provided for @warningYourItemExpiresToday.
  ///
  /// In en, this message translates to:
  /// **'Warining: Your item exires today!'**
  String get warningYourItemExpiresToday;

  /// No description provided for @reminderYourItemWillExpireInThreeDays.
  ///
  /// In en, this message translates to:
  /// **'Reminder: Your item will expire in 3 days!'**
  String get reminderYourItemWillExpireInThreeDays;

  /// No description provided for @alertYourItemWillExpireTomorrow.
  ///
  /// In en, this message translates to:
  /// **'Alert: Your item will expire tomorrow'**
  String get alertYourItemWillExpireTomorrow;

  /// No description provided for @myProfile.
  ///
  /// In en, this message translates to:
  /// **'My Profile'**
  String get myProfile;

  /// No description provided for @password.
  ///
  /// In en, this message translates to:
  /// **'Password'**
  String get password;

  /// No description provided for @termsAndConditions.
  ///
  /// In en, this message translates to:
  /// **'Terms & Conditions'**
  String get termsAndConditions;

  /// No description provided for @deleteProfile.
  ///
  /// In en, this message translates to:
  /// **'Delete Profile'**
  String get deleteProfile;

  /// No description provided for @logout.
  ///
  /// In en, this message translates to:
  /// **'Logout'**
  String get logout;

  /// No description provided for @createNewPassword.
  ///
  /// In en, this message translates to:
  /// **'Create New Password'**
  String get createNewPassword;

  /// No description provided for @enterPassword.
  ///
  /// In en, this message translates to:
  /// **'Enter Password'**
  String get enterPassword;

  /// No description provided for @confirmPassword.
  ///
  /// In en, this message translates to:
  /// **'Confirm Password'**
  String get confirmPassword;

  /// No description provided for @passwordCannotBeEmpty.
  ///
  /// In en, this message translates to:
  /// **'Password cannot be empty'**
  String get passwordCannotBeEmpty;

  /// No description provided for @confirmPasswordCannotBeEmpty.
  ///
  /// In en, this message translates to:
  /// **'Confirm password cannot be empty'**
  String get confirmPasswordCannotBeEmpty;

  /// No description provided for @savePassword.
  ///
  /// In en, this message translates to:
  /// **'Save Password'**
  String get savePassword;

  /// No description provided for @passwordMustBeAtLeastSixCharacters.
  ///
  /// In en, this message translates to:
  /// **'Password must be at least 6 characters'**
  String get passwordMustBeAtLeastSixCharacters;

  /// No description provided for @areYouSureYouWantToDeleteYourProfile.
  ///
  /// In en, this message translates to:
  /// **'Are you sure you want to delete your profile with Saver?'**
  String get areYouSureYouWantToDeleteYourProfile;

  /// No description provided for @areYouSureYouWantToLogout.
  ///
  /// In en, this message translates to:
  /// **'Arev you sure you want to logout?'**
  String get areYouSureYouWantToLogout;

  /// No description provided for @allNotificationClearedSuccessfully.
  ///
  /// In en, this message translates to:
  /// **'All notifiaction cleared successfully'**
  String get allNotificationClearedSuccessfully;

  /// No description provided for @noNotificationsFound.
  ///
  /// In en, this message translates to:
  /// **'No notifications found'**
  String get noNotificationsFound;

  /// No description provided for @profileUpdated.
  ///
  /// In en, this message translates to:
  /// **'Profile Updated'**
  String get profileUpdated;

  /// No description provided for @myListing.
  ///
  /// In en, this message translates to:
  /// **'My Listing'**
  String get myListing;

  /// No description provided for @otpHasBeenSentTo.
  ///
  /// In en, this message translates to:
  /// **'OTP has been sent to '**
  String get otpHasBeenSentTo;

  /// No description provided for @resendOtpInS.
  ///
  /// In en, this message translates to:
  /// **'Resend OTP in s'**
  String get resendOtpInS;

  /// No description provided for @verify.
  ///
  /// In en, this message translates to:
  /// **'Verify'**
  String get verify;

  /// No description provided for @sendingOtp.
  ///
  /// In en, this message translates to:
  /// **'Sending OTP...'**
  String get sendingOtp;

  /// No description provided for @verifyPhoneNumber.
  ///
  /// In en, this message translates to:
  /// **'Verify Phone Number'**
  String get verifyPhoneNumber;

  /// No description provided for @guestMode.
  ///
  /// In en, this message translates to:
  /// **'Guest Mode'**
  String get guestMode;

  /// No description provided for @unlockFullExperience.
  ///
  /// In en, this message translates to:
  /// **'Unlock Full Experience'**
  String get unlockFullExperience;

  /// No description provided for @accessAllFeatures.
  ///
  /// In en, this message translates to:
  /// **'Access all features'**
  String get accessAllFeatures;

  /// No description provided for @logIn.
  ///
  /// In en, this message translates to:
  /// **'Log In'**
  String get logIn;

  /// No description provided for @remove.
  ///
  /// In en, this message translates to:
  /// **'Remove'**
  String get remove;

  /// No description provided for @clearAll.
  ///
  /// In en, this message translates to:
  /// **'Clear All'**
  String get clearAll;

  /// No description provided for @pleaseAcceptOurTermsAndConditions.
  ///
  /// In en, this message translates to:
  /// **'Please accept our terms and conditions'**
  String get pleaseAcceptOurTermsAndConditions;

  /// No description provided for @requestedOn.
  ///
  /// In en, this message translates to:
  /// **'Requested on'**
  String get requestedOn;

  /// No description provided for @accept.
  ///
  /// In en, this message translates to:
  /// **'Accept'**
  String get accept;

  /// No description provided for @decline.
  ///
  /// In en, this message translates to:
  /// **'Decline'**
  String get decline;

  /// No description provided for @chat.
  ///
  /// In en, this message translates to:
  /// **'Chat'**
  String get chat;

  /// No description provided for @typeAMessage.
  ///
  /// In en, this message translates to:
  /// **'Type a message...'**
  String get typeAMessage;

  /// No description provided for @hello.
  ///
  /// In en, this message translates to:
  /// **'Hello'**
  String get hello;

  /// No description provided for @iAcceptYourFoodSwap.
  ///
  /// In en, this message translates to:
  /// **'I accept your food swap!'**
  String get iAcceptYourFoodSwap;

  /// No description provided for @userInformationNotAvailable.
  ///
  /// In en, this message translates to:
  /// **'User information not available'**
  String get userInformationNotAvailable;

  /// No description provided for @requestReceivedRecently.
  ///
  /// In en, this message translates to:
  /// **'Request received recently'**
  String get requestReceivedRecently;

  /// No description provided for @iWantToReceiveFoodWithYou.
  ///
  /// In en, this message translates to:
  /// **'I want to receive food with you!'**
  String get iWantToReceiveFoodWithYou;

  /// No description provided for @requestSent.
  ///
  /// In en, this message translates to:
  /// **'Request sent'**
  String get requestSent;

  /// No description provided for @enterValidMobileNumber.
  ///
  /// In en, this message translates to:
  /// **'Enter valid mobile number'**
  String get enterValidMobileNumber;

  /// No description provided for @loginSuccess.
  ///
  /// In en, this message translates to:
  /// **'Login Success'**
  String get loginSuccess;

  /// No description provided for @forgotPassword.
  ///
  /// In en, this message translates to:
  /// **'Forgot Password?'**
  String get forgotPassword;

  /// No description provided for @resetPassword.
  ///
  /// In en, this message translates to:
  /// **'Reset Password'**
  String get resetPassword;

  /// No description provided for @enterYourEmailAddressAndWeWill.
  ///
  /// In en, this message translates to:
  /// **'Enter your email address and we will send you a link to reset your password.'**
  String get enterYourEmailAddressAndWeWill;

  /// No description provided for @emailAddress.
  ///
  /// In en, this message translates to:
  /// **'Email Address'**
  String get emailAddress;

  /// No description provided for @weWillSendASercureLinkToThisEmail.
  ///
  /// In en, this message translates to:
  /// **'We\'ll send a secure link to this email'**
  String get weWillSendASercureLinkToThisEmail;

  /// No description provided for @pleaseEnterYourEmail.
  ///
  /// In en, this message translates to:
  /// **'Please enter your email'**
  String get pleaseEnterYourEmail;

  /// No description provided for @pleaseEnterAValidEmailAddress.
  ///
  /// In en, this message translates to:
  /// **'Please enter a valid email address'**
  String get pleaseEnterAValidEmailAddress;

  /// No description provided for @sendingResetLink.
  ///
  /// In en, this message translates to:
  /// **'Sending reset link..'**
  String get sendingResetLink;

  /// No description provided for @learnAndSave.
  ///
  /// In en, this message translates to:
  /// **'Learn & Save'**
  String get learnAndSave;

  /// No description provided for @languageChangedToArabic.
  ///
  /// In en, this message translates to:
  /// **'Language changed to arabic'**
  String get languageChangedToArabic;

  /// No description provided for @youveConsumed.
  ///
  /// In en, this message translates to:
  /// **'You\'ve consumed'**
  String get youveConsumed;

  /// No description provided for @ofYourFoodBeforeExpiry.
  ///
  /// In en, this message translates to:
  /// **'of your food before expiry this month!'**
  String get ofYourFoodBeforeExpiry;

  /// No description provided for @items.
  ///
  /// In en, this message translates to:
  /// **'items'**
  String get items;

  /// No description provided for @createdOn.
  ///
  /// In en, this message translates to:
  /// **'Created On:'**
  String get createdOn;

  /// No description provided for @interested.
  ///
  /// In en, this message translates to:
  /// **'Interested'**
  String get interested;

  /// No description provided for @donatedBy.
  ///
  /// In en, this message translates to:
  /// **'Donated By:'**
  String get donatedBy;

  /// No description provided for @anonymous.
  ///
  /// In en, this message translates to:
  /// **'Anonymous'**
  String get anonymous;

  /// No description provided for @donationAddedSuccessfully.
  ///
  /// In en, this message translates to:
  /// **'Donation Added Successfully'**
  String get donationAddedSuccessfully;

  /// No description provided for @youHave.
  ///
  /// In en, this message translates to:
  /// **'You have'**
  String get youHave;

  /// No description provided for @pendingRequests.
  ///
  /// In en, this message translates to:
  /// **'pending requests'**
  String get pendingRequests;

  /// No description provided for @requestAddedSuccessfully.
  ///
  /// In en, this message translates to:
  /// **'Request Added Successfully'**
  String get requestAddedSuccessfully;

  /// No description provided for @submitRequest.
  ///
  /// In en, this message translates to:
  /// **'Submit Request'**
  String get submitRequest;

  /// No description provided for @enterEightDigitMobileNumber.
  ///
  /// In en, this message translates to:
  /// **'Enter 8 digit mobile number'**
  String get enterEightDigitMobileNumber;

  /// No description provided for @thisItemExpiresIn.
  ///
  /// In en, this message translates to:
  /// **'This Item expires in '**
  String get thisItemExpiresIn;

  /// No description provided for @days.
  ///
  /// In en, this message translates to:
  /// **'days'**
  String get days;

  /// No description provided for @thisItemExpired.
  ///
  /// In en, this message translates to:
  /// **'This item expired'**
  String get thisItemExpired;

  /// No description provided for @daysAgo.
  ///
  /// In en, this message translates to:
  /// **'days ago'**
  String get daysAgo;

  /// No description provided for @editItem.
  ///
  /// In en, this message translates to:
  /// **'Edit Item'**
  String get editItem;

  /// No description provided for @moveToShoppingList.
  ///
  /// In en, this message translates to:
  /// **'Move to Shopping List'**
  String get moveToShoppingList;

  /// No description provided for @pleaseEnterAListName.
  ///
  /// In en, this message translates to:
  /// **'Please enter a list name'**
  String get pleaseEnterAListName;

  /// No description provided for @pleaseEnterYourName.
  ///
  /// In en, this message translates to:
  /// **'Please enter your name'**
  String get pleaseEnterYourName;

  /// No description provided for @noListingMatching.
  ///
  /// In en, this message translates to:
  /// **'No listing matching'**
  String get noListingMatching;

  /// No description provided for @noKitchenItemsAvailable.
  ///
  /// In en, this message translates to:
  /// **'No Kitchen items available'**
  String get noKitchenItemsAvailable;

  /// No description provided for @email.
  ///
  /// In en, this message translates to:
  /// **'Email'**
  String get email;

  /// No description provided for @phone.
  ///
  /// In en, this message translates to:
  /// **'Phone'**
  String get phone;

  /// No description provided for @date.
  ///
  /// In en, this message translates to:
  /// **'Date'**
  String get date;

  /// No description provided for @openingChat.
  ///
  /// In en, this message translates to:
  /// **'Opening chat...'**
  String get openingChat;

  /// No description provided for @iWantToDonateMyFoodWithYou.
  ///
  /// In en, this message translates to:
  /// **'I want to donate my food with you!'**
  String get iWantToDonateMyFoodWithYou;

  /// No description provided for @foodSwapAccepted.
  ///
  /// In en, this message translates to:
  /// **'Food Swap Accepted!'**
  String get foodSwapAccepted;

  /// No description provided for @selectADocumentToRead.
  ///
  /// In en, this message translates to:
  /// **'Select a document to read'**
  String get selectADocumentToRead;

  /// No description provided for @pleaseSelectAMeal.
  ///
  /// In en, this message translates to:
  /// **'Please select a meal'**
  String get pleaseSelectAMeal;

  /// No description provided for @pleaseSelectAType.
  ///
  /// In en, this message translates to:
  /// **'Please select a type'**
  String get pleaseSelectAType;

  /// No description provided for @youDontHaveEnoughIngredients.
  ///
  /// In en, this message translates to:
  /// **'You don\'t have enough ingredients in your kitchen to generate the portion plan.'**
  String get youDontHaveEnoughIngredients;

  /// No description provided for @availableFood.
  ///
  /// In en, this message translates to:
  /// **'Available Food'**
  String get availableFood;

  /// No description provided for @pickupDateAndTime.
  ///
  /// In en, this message translates to:
  /// **'PickUp Date & Time'**
  String get pickupDateAndTime;

  /// No description provided for @yourRequesthasBeenSent.
  ///
  /// In en, this message translates to:
  /// **'Your request has been sent'**
  String get yourRequesthasBeenSent;

  /// No description provided for @requestsPending.
  ///
  /// In en, this message translates to:
  /// **'Requests Pending'**
  String get requestsPending;

  /// No description provided for @location.
  ///
  /// In en, this message translates to:
  /// **'Location:'**
  String get location;

  /// No description provided for @foodDeatils.
  ///
  /// In en, this message translates to:
  /// **'Food Details'**
  String get foodDeatils;

  /// No description provided for @requests.
  ///
  /// In en, this message translates to:
  /// **'Requests'**
  String get requests;

  /// No description provided for @iAgreeWithThe.
  ///
  /// In en, this message translates to:
  /// **'I agree with the'**
  String get iAgreeWithThe;

  /// No description provided for @welcomePleaseCompleteYourProfile.
  ///
  /// In en, this message translates to:
  /// **'Welcome! Please complete your profile'**
  String get welcomePleaseCompleteYourProfile;

  /// No description provided for @otpVerificationFailed.
  ///
  /// In en, this message translates to:
  /// **'OTP verification failed'**
  String get otpVerificationFailed;

  /// No description provided for @pleaseSelectAnExpiryDate.
  ///
  /// In en, this message translates to:
  /// **'Please select an expiry date'**
  String get pleaseSelectAnExpiryDate;

  /// No description provided for @noAvailableSwaps.
  ///
  /// In en, this message translates to:
  /// **'No available swaps'**
  String get noAvailableSwaps;

  /// No description provided for @checkBackLaterForNewListings.
  ///
  /// In en, this message translates to:
  /// **'Check back later for new listings'**
  String get checkBackLaterForNewListings;

  /// No description provided for @inText.
  ///
  /// In en, this message translates to:
  /// **'in'**
  String get inText;

  /// No description provided for @searchResultsFor.
  ///
  /// In en, this message translates to:
  /// **'Search Results For'**
  String get searchResultsFor;

  /// No description provided for @languageChangedTo.
  ///
  /// In en, this message translates to:
  /// **'تغيرت اللغة الى'**
  String get languageChangedTo;

  /// No description provided for @portionPlan.
  ///
  /// In en, this message translates to:
  /// **'Portion Plan'**
  String get portionPlan;

  /// No description provided for @noFoodWasteThesePortionAreJustRightFor.
  ///
  /// In en, this message translates to:
  /// **'No food waste! These portions are just right for'**
  String get noFoodWasteThesePortionAreJustRightFor;

  /// No description provided for @people.
  ///
  /// In en, this message translates to:
  /// **'people'**
  String get people;

  /// No description provided for @forTwoPeople.
  ///
  /// In en, this message translates to:
  /// **'for 2 people'**
  String get forTwoPeople;

  /// No description provided for @recipeName.
  ///
  /// In en, this message translates to:
  /// **'Recipe Name'**
  String get recipeName;

  /// No description provided for @availableIngredients.
  ///
  /// In en, this message translates to:
  /// **'Available Ingredients'**
  String get availableIngredients;

  /// No description provided for @carbs.
  ///
  /// In en, this message translates to:
  /// **'Carbs'**
  String get carbs;

  /// No description provided for @perPerson.
  ///
  /// In en, this message translates to:
  /// **'per person'**
  String get perPerson;

  /// No description provided for @failedToSentRequestPleaseTryAgainLater.
  ///
  /// In en, this message translates to:
  /// **'Failed to sent request.Please try again later'**
  String get failedToSentRequestPleaseTryAgainLater;

  /// No description provided for @chooseFromTheList.
  ///
  /// In en, this message translates to:
  /// **'choose from the list'**
  String get chooseFromTheList;

  /// No description provided for @noMessageYet.
  ///
  /// In en, this message translates to:
  /// **'NomessageYet'**
  String get noMessageYet;

  /// No description provided for @areYouSureWantToDeletThis.
  ///
  /// In en, this message translates to:
  /// **'Are you sure you want to delete this'**
  String get areYouSureWantToDeletThis;

  /// No description provided for @itemThisActionCannotBeUndone.
  ///
  /// In en, this message translates to:
  /// **'Item? This action cannot be undone.'**
  String get itemThisActionCannotBeUndone;

  /// No description provided for @foodSwapDeletedSuccessfully.
  ///
  /// In en, this message translates to:
  /// **'Food Swap Deleted Successfully'**
  String get foodSwapDeletedSuccessfully;

  /// No description provided for @verifyingOtp.
  ///
  /// In en, this message translates to:
  /// **'Verifying OTP...'**
  String get verifyingOtp;

  /// No description provided for @passwordResetEmailSentSuccessfully.
  ///
  /// In en, this message translates to:
  /// **'Password reset email sent successfully'**
  String get passwordResetEmailSentSuccessfully;

  /// No description provided for @protein.
  ///
  /// In en, this message translates to:
  /// **'Protein'**
  String get protein;

  /// No description provided for @vegetables.
  ///
  /// In en, this message translates to:
  /// **'Vegetables:'**
  String get vegetables;

  /// No description provided for @beneficiaryAccepted.
  ///
  /// In en, this message translates to:
  /// **'Beneficiary accepted'**
  String get beneficiaryAccepted;

  /// No description provided for @incomingRequests.
  ///
  /// In en, this message translates to:
  /// **'Incoming Requests'**
  String get incomingRequests;

  /// No description provided for @donation.
  ///
  /// In en, this message translates to:
  /// **'Donation'**
  String get donation;

  /// No description provided for @details.
  ///
  /// In en, this message translates to:
  /// **'Details'**
  String get details;

  /// No description provided for @areYouSureWantToDeletThisDonation.
  ///
  /// In en, this message translates to:
  /// **'Are you sure you want to delete this donation'**
  String get areYouSureWantToDeletThisDonation;

  /// No description provided for @alreadyAccepted.
  ///
  /// In en, this message translates to:
  /// **'Already accepted'**
  String get alreadyAccepted;

  /// No description provided for @forText.
  ///
  /// In en, this message translates to:
  /// **'for'**
  String get forText;

  /// No description provided for @chooseFromMyListing.
  ///
  /// In en, this message translates to:
  /// **'Choose from my listing'**
  String get chooseFromMyListing;

  /// No description provided for @delete.
  ///
  /// In en, this message translates to:
  /// **'delete'**
  String get delete;

  /// No description provided for @checkingAccount.
  ///
  /// In en, this message translates to:
  /// **'Checking account...'**
  String get checkingAccount;

  /// No description provided for @deleteDonation.
  ///
  /// In en, this message translates to:
  /// **'Delete Donation'**
  String get deleteDonation;

  /// No description provided for @areYouSureYouWantToDeleteThisDonation.
  ///
  /// In en, this message translates to:
  /// **'Are you sure you want to delete this donation?'**
  String get areYouSureYouWantToDeleteThisDonation;

  /// No description provided for @declineRequest.
  ///
  /// In en, this message translates to:
  /// **'Decline Request'**
  String get declineRequest;

  /// No description provided for @areYouSureYouWantToDeclineTheRequestFrom.
  ///
  /// In en, this message translates to:
  /// **'Are you sure you want to decline the request from'**
  String get areYouSureYouWantToDeclineTheRequestFrom;

  /// No description provided for @weSentAPasswordResetLinkTo.
  ///
  /// In en, this message translates to:
  /// **'We\'ve sent a password reset link to:'**
  String get weSentAPasswordResetLinkTo;

  /// No description provided for @pleaseCheckYourInboxAndFollowTheInstructions.
  ///
  /// In en, this message translates to:
  /// **'Please check your inbox and follow the instructions in the email.'**
  String get pleaseCheckYourInboxAndFollowTheInstructions;

  /// No description provided for @resetLinkSent.
  ///
  /// In en, this message translates to:
  /// **'Reset Link Sent!'**
  String get resetLinkSent;

  /// No description provided for @weVeSentAPasswordResetLinkTo.
  ///
  /// In en, this message translates to:
  /// **'We\'ve sent a password reset link to:'**
  String get weVeSentAPasswordResetLinkTo;

  /// No description provided for @welcomeToSAverApp.
  ///
  /// In en, this message translates to:
  /// **'Welcome to Saver App! By using this application, you agree to be bound by these Terms and Conditions. Please read them carefully before accessing or using the services.'**
  String get welcomeToSAverApp;

  /// No description provided for @acceptanceOfTerms.
  ///
  /// In en, this message translates to:
  /// **'Acceptance of Terms'**
  String get acceptanceOfTerms;

  /// No description provided for @ofText.
  ///
  /// In en, this message translates to:
  /// **'of'**
  String get ofText;

  /// No description provided for @itemsPurchased.
  ///
  /// In en, this message translates to:
  /// **'item purchased'**
  String get itemsPurchased;

  /// No description provided for @requestDeclinedSuccessfully.
  ///
  /// In en, this message translates to:
  /// **'Request Declined Success'**
  String get requestDeclinedSuccessfully;

  /// No description provided for @day.
  ///
  /// In en, this message translates to:
  /// **'day'**
  String get day;

  /// No description provided for @hour.
  ///
  /// In en, this message translates to:
  /// **'hour'**
  String get hour;

  /// No description provided for @minute.
  ///
  /// In en, this message translates to:
  /// **'minute'**
  String get minute;

  /// No description provided for @ago.
  ///
  /// In en, this message translates to:
  /// **'ago'**
  String get ago;

  /// No description provided for @justNow.
  ///
  /// In en, this message translates to:
  /// **'just now'**
  String get justNow;

  /// No description provided for @recently.
  ///
  /// In en, this message translates to:
  /// **'recently'**
  String get recently;

  /// No description provided for @byDownloading.
  ///
  /// In en, this message translates to:
  /// **'By downloading, accessing, or using Saver App, you agree to be bound by these Terms and Conditions. If you do not agree with any part of these terms, you should not use the app. Your continued use of the app signifies your acceptance of these terms.'**
  String get byDownloading;

  /// No description provided for @descriptionOfServices.
  ///
  /// In en, this message translates to:
  /// **'Description of Services'**
  String get descriptionOfServices;

  /// No description provided for @saverAppOffersAVariety.
  ///
  /// In en, this message translates to:
  /// **'Saver App offers a variety of features including food sharing and food donation, a smart recipe generator based on available ingredients and nutritional needs, zero-waste cooking ideas, kitchen inventory management, and a shopping list tool. Additionally, the app includes a challenge system where users can earn virtual coins upon successful completion of tasks following specific instructions.'**
  String get saverAppOffersAVariety;

  /// No description provided for @userResponsibilities.
  ///
  /// In en, this message translates to:
  /// **'User Responsibilities'**
  String get userResponsibilities;

  /// No description provided for @usersAreResponsibleForEnsuring.
  ///
  /// In en, this message translates to:
  /// **'Users are responsible for ensuring that any food they share or donate is safe and suitable for consumption. Misuse of app features, such as submitting false data or attempting to exploit the challenge system, is strictly prohibited. Users must also maintain respectful interactions with others and keep their account details secure. In case of unauthorized account access, users are expected to report the issue promptly.'**
  String get usersAreResponsibleForEnsuring;

  /// No description provided for @virtualRewards.
  ///
  /// In en, this message translates to:
  /// **'Virtual Rewards'**
  String get virtualRewards;

  /// No description provided for @coinsEarnedThroughChallenges.
  ///
  /// In en, this message translates to:
  /// **'Coins earned through challenges in Saver App are virtual in nature and have no real-world monetary value. These coins are intended for engagement within the app only and cannot be redeemed for cash or external rewards. Saver App reserves the right to alter, suspend, or remove the coin system at any time without prior notice.'**
  String get coinsEarnedThroughChallenges;

  /// No description provided for @intellectualProperty.
  ///
  /// In en, this message translates to:
  /// **' Intellectual Property'**
  String get intellectualProperty;

  /// No description provided for @allDesignElements.
  ///
  /// In en, this message translates to:
  /// **'All design elements, logos, content, and features of Saver App are the exclusive intellectual property of its developers. Users may not copy, modify, distribute, or use any content from the app without written permission from the developers.'**
  String get allDesignElements;

  /// No description provided for @privacy.
  ///
  /// In en, this message translates to:
  /// **'Privacy'**
  String get privacy;

  /// No description provided for @saverAppIsCommittedTo.
  ///
  /// In en, this message translates to:
  /// **'Saver App is committed to protecting your personal information. Please refer to our Privacy Policy for details on how we collect, use, and protect your data.'**
  String get saverAppIsCommittedTo;

  /// No description provided for @modificationsToTerms.
  ///
  /// In en, this message translates to:
  /// **'Modifications to Terms'**
  String get modificationsToTerms;

  /// No description provided for @saverAppMayUpadte.
  ///
  /// In en, this message translates to:
  /// **'Saver App may update these Terms and Conditions from time to time to reflect changes in features or legal requirements. Notifications of updates will be shared within the app, and continued use of the app indicates acceptance of the revised terms.'**
  String get saverAppMayUpadte;

  /// No description provided for @limitationOfLiability.
  ///
  /// In en, this message translates to:
  /// **'Limitation of Liability'**
  String get limitationOfLiability;

  /// No description provided for @theAppIsProvidedAsIs.
  ///
  /// In en, this message translates to:
  /// **'The app is provided “as is” and without warranties of any kind. Saver App will not be held liable for any damages, losses, or issues arising from the use of the app, including but not limited to food-related incidents, inaccurate recipe suggestions, or data loss.'**
  String get theAppIsProvidedAsIs;

  /// No description provided for @termination.
  ///
  /// In en, this message translates to:
  /// **'Termination'**
  String get termination;

  /// No description provided for @weReserveTheRightTo.
  ///
  /// In en, this message translates to:
  /// **'We reserve the right to suspend or terminate access to Saver App for users who violate these Terms and Conditions or engage in inappropriate, unsafe, or abusive behavior within the platform.'**
  String get weReserveTheRightTo;

  /// No description provided for @contactUs.
  ///
  /// In en, this message translates to:
  /// **'Contact Us'**
  String get contactUs;

  /// No description provided for @ifYouHaveAnyQuestions.
  ///
  /// In en, this message translates to:
  /// **'If you have any questions or concerns about these Terms and Conditions, please contact us at'**
  String get ifYouHaveAnyQuestions;

  /// No description provided for @close.
  ///
  /// In en, this message translates to:
  /// **'Close'**
  String get close;

  /// No description provided for @pleaseEnterYourPassword.
  ///
  /// In en, this message translates to:
  /// **'Please enter your password'**
  String get pleaseEnterYourPassword;

  /// No description provided for @youdontHaveToSwapItems.
  ///
  /// In en, this message translates to:
  /// **'You don\'t have to swap items'**
  String get youdontHaveToSwapItems;

  /// No description provided for @recipePlanner.
  ///
  /// In en, this message translates to:
  /// **'Recipe Planner'**
  String get recipePlanner;

  /// No description provided for @letsCreateYourShoppinList.
  ///
  /// In en, this message translates to:
  /// **'Let\'s create your shopping list'**
  String get letsCreateYourShoppinList;

  /// No description provided for @whatRecipeAreYouLookingFor.
  ///
  /// In en, this message translates to:
  /// **'What Recipe are you looking for?'**
  String get whatRecipeAreYouLookingFor;

  /// No description provided for @enterYourRecipeName.
  ///
  /// In en, this message translates to:
  /// **'Enter your recipe name'**
  String get enterYourRecipeName;

  /// No description provided for @howManyPeopleAreYouServing.
  ///
  /// In en, this message translates to:
  /// **'How many people are you serving?'**
  String get howManyPeopleAreYouServing;

  /// No description provided for @enterNumberOfServes.
  ///
  /// In en, this message translates to:
  /// **'Enter number of serves'**
  String get enterNumberOfServes;

  /// No description provided for @generateList.
  ///
  /// In en, this message translates to:
  /// **'Generate List'**
  String get generateList;

  /// No description provided for @pleaseEnterARecipeName.
  ///
  /// In en, this message translates to:
  /// **'Please enter a recipe name'**
  String get pleaseEnterARecipeName;

  /// No description provided for @pleaseEnterNumberOfServes.
  ///
  /// In en, this message translates to:
  /// **'Please enter number of serves'**
  String get pleaseEnterNumberOfServes;

  /// No description provided for @numberOfServesMustBeGreaterThanZero.
  ///
  /// In en, this message translates to:
  /// **'Number of serves must be greater than 0'**
  String get numberOfServesMustBeGreaterThanZero;

  /// No description provided for @generatedShoppingItems.
  ///
  /// In en, this message translates to:
  /// **'Generated Shopping items'**
  String get generatedShoppingItems;

  /// No description provided for @noIngredientsFound.
  ///
  /// In en, this message translates to:
  /// **'No ingredients found'**
  String get noIngredientsFound;

  /// No description provided for @shoppingListFor.
  ///
  /// In en, this message translates to:
  /// **'Shopping List for'**
  String get shoppingListFor;

  /// No description provided for @ingredients.
  ///
  /// In en, this message translates to:
  /// **'Ingredients'**
  String get ingredients;

  /// No description provided for @unblockToSendMessages.
  ///
  /// In en, this message translates to:
  /// **'Unblock to send messages'**
  String get unblockToSendMessages;

  /// No description provided for @youBlockedThisUser.
  ///
  /// In en, this message translates to:
  /// **'You blocked this user'**
  String get youBlockedThisUser;

  /// No description provided for @unblockUser.
  ///
  /// In en, this message translates to:
  /// **'Unblock User'**
  String get unblockUser;

  /// No description provided for @block.
  ///
  /// In en, this message translates to:
  /// **'Block'**
  String get block;

  /// No description provided for @unblock.
  ///
  /// In en, this message translates to:
  /// **'Unblock'**
  String get unblock;

  /// No description provided for @report.
  ///
  /// In en, this message translates to:
  /// **'Report'**
  String get report;

  /// No description provided for @blockUser.
  ///
  /// In en, this message translates to:
  /// **'Block User'**
  String get blockUser;

  /// No description provided for @blockUserConfirmation.
  ///
  /// In en, this message translates to:
  /// **'Are you sure you want to block this user? You won\'t be able to send or receive messages.'**
  String get blockUserConfirmation;

  /// No description provided for @unblockUserConfirmation.
  ///
  /// In en, this message translates to:
  /// **'Are you sure you want to unblock this user? You will be able to send and receive messages again.'**
  String get unblockUserConfirmation;

  /// No description provided for @userBlockedSuccessfully.
  ///
  /// In en, this message translates to:
  /// **'User blocked successfully'**
  String get userBlockedSuccessfully;

  /// No description provided for @userUnblockedSuccessfully.
  ///
  /// In en, this message translates to:
  /// **'User unblocked successfully'**
  String get userUnblockedSuccessfully;

  /// No description provided for @reportSubmittedSuccessfully.
  ///
  /// In en, this message translates to:
  /// **'Report submitted successfully'**
  String get reportSubmittedSuccessfully;
}

class _AppLocalizationsDelegate
    extends LocalizationsDelegate<AppLocalizations> {
  const _AppLocalizationsDelegate();

  @override
  Future<AppLocalizations> load(Locale locale) {
    return SynchronousFuture<AppLocalizations>(lookupAppLocalizations(locale));
  }

  @override
  bool isSupported(Locale locale) =>
      <String>['ar', 'en'].contains(locale.languageCode);

  @override
  bool shouldReload(_AppLocalizationsDelegate old) => false;
}

AppLocalizations lookupAppLocalizations(Locale locale) {
  // Lookup logic when only language code is specified.
  switch (locale.languageCode) {
    case 'ar':
      return AppLocalizationsAr();
    case 'en':
      return AppLocalizationsEn();
  }

  throw FlutterError(
      'AppLocalizations.delegate failed to load unsupported locale "$locale". This is likely '
      'an issue with the localizations generation tool. Please file an issue '
      'on GitHub with a reproducible sample app and the gen-l10n configuration '
      'that was used.');
}
