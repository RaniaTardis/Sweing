import 'package:flutter/material.dart';

class AppLocalizations {
  final Locale locale;

  AppLocalizations(this.locale);

  static AppLocalizations of(BuildContext context) {
    return Localizations.of<AppLocalizations>(context, AppLocalizations)!;
  }

  static const LocalizationsDelegate<AppLocalizations> delegate =
      _AppLocalizationsDelegate();

  static final Map<String, Map<String, String>> _localizedValues = {
    'en': {
      // Splash / Welcome
      'app_title': 'Warrad Fashion',
      'home_label': 'Home',
      'splash_brand': 'WARRAD',
      'splash_subtitle': 'FASHION',
      'ready': 'Ready?',
      'ready_subtitle': 'Shop and do all you want',
      'lets_start': "Let's Start",

      // Home Screen
      'sewing_elegance': 'Sewing Elegance',
      'search_hint': 'Search dresses & gowns...',
      'shop_by_category': 'Shop by Category',
      'see_all': 'See All',
      'most_popular': 'Most Popular',
      'view_all': 'View All',
      'buy_dresses': 'Buy Dresses',
      'rent_dresses': 'Rent Dresses',
      'custom_made': 'Custom Made',
      'hero_title': '50% OFF First Order!',
      'hero_subtitle': 'Discover your perfect dress today',
      'shop_now': 'Shop Now',
      'image_not_found': 'Image not found',
      'no_results': 'No results for',

      // Account options
      'login': 'Login',
      'access_account': 'Access your account',
      'create_account': 'Create Account',
      'create_account_subtitle': 'Required for orders',
      'logout': 'Logout',
      'logout_subtitle': 'Sign out of account',      'logged_out': 'Logged out successfully!',
      'welcome_back': 'Welcome back!',
      'please_login_cart': 'Please login to add to cart',
      'added_to_wishlist': 'added to wishlist!',
      'removed_from_wishlist': 'removed from wishlist',
      'network_error': 'Network error. Try again!',
      'already_in_cart': 'is already in cart',
      'added_to_cart': 'added to cart!',
      'cart_error': 'Cart error. Please try again.',

      // Product Details
      'premium_quality': 'Premium Quality',
      'size': 'Size',
      'size_guide': 'Size Guide',
      'description': 'Description',
      'description_template':
          'Elegant {name} made with premium fabrics. Perfect for any special occasion. Available for {category}. Custom tailoring available upon request. High quality craftsmanship guaranteed.',
      'reviews': 'Reviews',
      'view_all_reviews': 'View All',
      'image_not_available': 'Image not available',
      'in_wishlist': 'In Wishlist',
      'add_to_wishlist': 'Add to Wishlist',
      'adding': 'Adding...',
      'add_to_cart': 'Add to Cart',
      'please_login_wishlist': 'Please login to use wishlist',
      'failed_wishlist': 'Failed to add to wishlist',
      'wishlist_error': 'Wishlist error. Please try again.',
      'size_updated': 'Size updated to {size} in cart',
      'rating': 'rating',

      // Settings
      'settings': 'Settings',
      'personal': 'Personal',
      'profile': 'Profile',
      'shipping_address': 'Shipping Address',
      'payment_methods': 'Payment methods',
      'shop': 'Shop',
      'country': 'Country',
      'currency': 'Currency',
      'account': 'Account',
      'language': 'Language',
      'about_warrad': 'About Warrad',
      'delete_account': 'Delete My Account',
      'login_manage': 'Login to Manage Profile',
      'version_info': 'Version 1.0 May, 2026',

      // Settings Sheets
      'edit_profile': 'Edit Profile',
      'full_name': 'Full Name',
      'email': 'Email',
      'save': 'Save',
      'profile_updated': 'Profile updated!',
      'failed_update': 'Failed to update profile',
      'enter_shipping_address': 'Shipping Address',
      'full_address': 'Full Address',
      'address_hint': 'Street, building, apartment...',
      'city': 'City',
      'address_saved': 'Address saved!',
      'failed_address': 'Failed to save address',
      'select_country': 'Select Country',
      'select_currency': 'Select Currency',
      'select_language': 'Select Language',
      'english': 'English',
      'arabic': 'العربية',

      // Cart
      'cart': 'Cart',
      'your_cart_waiting': 'Your cart is waiting!',
      'login_add_items': 'Login to add items and manage your orders',
      'login_sign_up': 'Login / Sign Up',
      'your_cart_empty': 'Your cart is empty',
      'add_items_home': 'Add items from the home screen',
      'total': 'Total',
      'checkout': 'Checkout',
      'confirm_order': 'Confirm Order',
      'items': 'Items',
      'order_placed': 'Order placed!',
      'checkout_failed': 'Checkout failed',
      'set_address_settings': 'Please set a shipping address in Settings',

      // Orders
      'my_orders': 'My Orders',
      'ongoing': 'Ongoing',
      'completed': 'Completed',
      'no_orders': 'No orders here',
      'login_see_orders': 'Login to see your orders',
      'go_to_login': 'Go to Login',
      'in_progress': 'In Progress',
      'delivered': 'Delivered',
      'track_order': 'Track Order',
      'reorder': 'Reorder',
      'order_tracking': 'Order Tracking',
      'order_placed_step': 'Order Placed',
      'order_placed_sub': 'Your order has been confirmed',
      'processing': 'Processing',
      'processing_sub': 'Preparing your items',
      'shipped': 'Shipped',
      'shipped_sub': 'On the way to you',
      'delivered_step': 'Delivered',
      'delivered_sub': 'Arriving at your address',
      'estimated_delivery': 'Estimated delivery: 3-5 business days',

      // Wishlist
      'my_wishlist': 'My Wishlist',
      'wishlist_empty': 'Your Wishlist is Empty',
      'wishlist_empty_sub':
          'Add your favorite dresses here to save them for later!',
      'continue_shopping': 'Continue Shopping',
      'removed_wishlist': 'Removed from wishlist',
      'add': 'Add',

      // Reviews
      'reviews_title': 'Reviews',
      'add_review': 'Add Review',
      'write_review': 'Write a Review',
      'share_experience': 'Share your experience...',
      'submit_review': 'Submit Review',
      'select_rating_review': 'Please select a rating and write a review',
      'already_reviewed': 'You have already reviewed this product',
      'review_submitted': 'Review submitted successfully!',
      'failed_review': 'Failed to submit review',

      // Auth - Login
      'log_in_now': 'Log in Now',
      'login_subtitle': 'Please login to continue using the app',
      'password': 'Password',
      'forgot_password': 'Forgot Password?',
      'log_in': 'Log in',
      'no_account': "Don't have an account? ",
      'sign_up_now': 'Sign up now !!',
      'please_fill': 'Please fill in all fields',
      'login_failed': 'Login failed',
      'connect_error': 'Could not connect to server',

      // Auth - Signup
      'sign_up_now_title': 'Sign Up, NOW',
      'signup_subtitle': 'Please fill details to create an account',
      'phone_number': 'Phone Number',
      'sign_up': 'Sign up',
      'have_account': 'Already got an account, ',
      'log_in_now_link': 'LOG IN now !!',
      'account_created': 'Account created successfully!',
      'signup_failed': 'Signup failed',
      'please_fill_all': 'Please fill all fields',

      // Category Products
      'sort': 'Sort',
      'no_dresses': 'No dresses in {category} yet',
      'check_back': 'Check back soon for new arrivals!',

      // Password Recovery
      'please_login_orders': 'Please login to view your wishlist',
    },
    'ar': {
      // Splash / Welcome
      'app_title': 'وراد فاشن',
      'home_label': 'الرئيسية',
      'splash_brand': 'وراد',
      'splash_subtitle': 'فاشن',
      'ready': 'مستعدة؟',
      'ready_subtitle': 'تسوقي وافعلي كل ما تريدين',
      'lets_start': 'هيا نبدأ',

      // Home Screen
      'sewing_elegance': 'أناقة الخياطة',
      'search_hint': 'ابحثي عن الفساتين...',
      'shop_by_category': 'تسوقي حسب الفئة',
      'see_all': 'عرض الكل',
      'most_popular': 'الأكثر شعبية',
      'view_all': 'عرض الكل',
      'buy_dresses': 'شراء فساتين',
      'rent_dresses': 'استئجار فساتين',
      'custom_made': 'تفصيل حسب الطلب',
      'hero_title': 'خصم 50% على الطلب الأول!',
      'hero_subtitle': 'اكتشفي فستانك المثالي اليوم',
      'shop_now': 'تسوقي الآن',
      'image_not_found': 'الصورة غير موجودة',
      'no_results': 'لا توجد نتائج لـ',

      // Account options
      'login': 'تسجيل الدخول',
      'access_account': 'الدخول إلى حسابك',
      'create_account': 'إنشاء حساب',
      'create_account_subtitle': 'مطلوب للطلبات',
      'logout': 'تسجيل الخروج',
      'logout_subtitle': 'الخروج من الحساب',
      'logged_out': 'تم تسجيل الخروج بنجاح!',
      'welcome_back': 'مرحباً بعودتك!',
      'please_login_cart': 'يرجى تسجيل الدخول لإضافة إلى السلة',
      'added_to_wishlist': 'تمت الإضافة إلى المفضلة!',
      'removed_from_wishlist': 'تمت الإزالة من المفضلة',
      'network_error': 'خطأ في الشبكة. حاولي مرة أخرى!',
      'already_in_cart': 'موجود بالفعل في السلة',
      'added_to_cart': 'تمت الإضافة إلى السلة!',
      'cart_error': 'خطأ في السلة. يرجى المحاولة مرة أخرى.',

      // Product Details
      'premium_quality': 'جودة عالية',
      'size': 'المقاس',
      'size_guide': 'دليل المقاسات',
      'description': 'الوصف',
      'description_template':
          'فسأنيق {name} مصنوع من أقمشة فاخرة. مثالي لأي مناسبة خاصة. متاح لـ{category}. تفصيل حسب الطلب متاح عند الطلب. ضمان جودة الحرفية العالية.',
      'reviews': 'التقييمات',
      'view_all_reviews': 'عرض الكل',
      'image_not_available': 'الصورة غير متوفرة',
      'in_wishlist': 'في المفضلة',
      'add_to_wishlist': 'إضافة إلى المفضلة',
      'adding': 'جاري الإضافة...',
      'add_to_cart': 'إضافة إلى السلة',
      'please_login_wishlist': 'يرجى تسجيل الدخول لاستخدام المفضلة',
      'failed_wishlist': 'فشل الإضافة إلى المفضلة',
      'wishlist_error': 'خطأ في المفضلة. يرجى المحاولة مرة أخرى.',
      'size_updated': 'تم تحديث المقاس إلى {size} في السلة',
      'rating': 'تقييم',

      // Settings
      'settings': 'الإعدادات',
      'personal': 'شخصي',
      'profile': 'الملف الشخصي',
      'shipping_address': 'عنوان الشحن',
      'payment_methods': 'طرق الدفع',
      'shop': 'المتجر',
      'country': 'الدولة',
      'currency': 'العملة',
      'account': 'الحساب',
      'language': 'اللغة',
      'about_warrad': 'عن وراد',
      'delete_account': 'حذف حسابي',
      'login_manage': 'تسجيل الدخول لإدارة الملف الشخصي',
      'version_info': 'الإصدار 1.0 مايو 2026',

      // Settings Sheets
      'edit_profile': 'تعديل الملف الشخصي',
      'full_name': 'الاسم الكامل',
      'email': 'البريد الإلكتروني',
      'save': 'حفظ',
      'profile_updated': 'تم تحديث الملف الشخصي!',
      'failed_update': 'فشل تحديث الملف الشخصي',
      'enter_shipping_address': 'عنوان الشحن',
      'full_address': 'العنوان الكامل',
      'address_hint': 'شارع، مبنى، شقة...',
      'city': 'المدينة',
      'address_saved': 'تم حفظ العنوان!',
      'failed_address': 'فشل حفظ العنوان',
      'select_country': 'اختر الدولة',
      'select_currency': 'اختر العملة',
      'select_language': 'اختر اللغة',
      'english': 'English',
      'arabic': 'العربية',

      // Cart
      'cart': 'السلة',
      'your_cart_waiting': 'سلتك بانتظارك!',
      'login_add_items': 'سجلي الدخول لإضافة عناصر وإدارة طلباتك',
      'login_sign_up': 'تسجيل الدخول / إنشاء حساب',
      'your_cart_empty': 'سلتك فارغة',
      'add_items_home': 'أضيفي عناصر من الشاشة الرئيسية',
      'total': 'المجموع',
      'checkout': 'الدفع',
      'confirm_order': 'تأكيد الطلب',
      'items': 'العناصر',
      'order_placed': 'تم تقديم الطلب!',
      'checkout_failed': 'فشل عملية الدفع',
      'set_address_settings': 'يرجى تعيين عنوان الشحن في الإعدادات',

      // Orders
      'my_orders': 'طلباتي',
      'ongoing': 'قيد التنفيذ',
      'completed': 'مكتمل',
      'no_orders': 'لا توجد طلبات هنا',
      'login_see_orders': 'سجلي الدخول لعرض طلباتك',
      'go_to_login': 'الذهاب لتسجيل الدخول',
      'in_progress': 'قيد التنفيذ',
      'delivered': 'تم التوصيل',
      'track_order': 'تتبع الطلب',
      'reorder': 'إعادة الطلب',
      'order_tracking': 'تتبع الطلب',
      'order_placed_step': 'تم تقديم الطلب',
      'order_placed_sub': 'تم تأكيد طلبك',
      'processing': 'قيد التحضير',
      'processing_sub': 'جاري تحضير طلبك',
      'shipped': 'تم الشحن',
      'shipped_sub': 'في الطريق إليك',
      'delivered_step': 'تم التوصيل',
      'delivered_sub': 'واصل إلى عنوانك',
      'estimated_delivery': 'التوصيل المتوقع: 3-5 أيام عمل',

      // Wishlist
      'my_wishlist': 'مفضلتي',
      'wishlist_empty': 'مفضلتك فارغة',
      'wishlist_empty_sub': 'أضيفي فساتينك المفضلة هنا لحفظها لاحقاً!',
      'continue_shopping': 'متابعة التسوق',
      'removed_wishlist': 'تمت الإزالة من المفضلة',
      'add': 'إضافة',

      // Reviews
      'reviews_title': 'التقييمات',
      'add_review': 'إضافة تقييم',
      'write_review': 'اكتبي تقييم',
      'share_experience': 'شاركي تجربتك...',
      'submit_review': 'إرسال التقييم',
      'select_rating_review': 'يرجى اختيار تقييم وكتابة مراجعة',
      'already_reviewed': 'لقد قمت بتقييم هذا المنتج مسبقاً',
      'review_submitted': 'تم إرسال التقييم بنجاح!',
      'failed_review': 'فشل إرسال التقييم',

      // Auth - Login
      'log_in_now': 'سجلي الدخول الآن',
      'login_subtitle': 'يرجى تسجيل الدخول للاستمرار في استخدام التطبيق',
      'password': 'كلمة المرور',
      'forgot_password': 'نسيت كلمة المرور؟',
      'log_in': 'تسجيل الدخول',
      'no_account': 'ليس لديك حساب؟ ',
      'sign_up_now': 'سجلي الآن!',
      'please_fill': 'يرجى ملء جميع الحقول',
      'login_failed': 'فشل تسجيل الدخول',
      'connect_error': 'لا يمكن الاتصال بالخادم',

      // Auth - Signup
      'sign_up_now_title': 'سجلي الآن',
      'signup_subtitle': 'يرجى ملء التفاصيل لإنشاء حساب',
      'phone_number': 'رقم الهاتف',
      'sign_up': 'تسجيل',
      'have_account': 'لديك حساب بالفعل، ',
      'log_in_now_link': 'سجلي الدخول الآن!',
      'account_created': 'تم إنشاء الحساب بنجاح!',
      'signup_failed': 'فشل التسجيل',
      'please_fill_all': 'يرجى ملء جميع الحقول',

      // Category Products
      'sort': 'ترتيب',
      'no_dresses': 'لا توجد فساتين في {category} بعد',
      'check_back': 'تفقدي لاحقاً للوصولات الجديدة!',

      // Password Recovery
      'please_login_orders': 'يرجى تسجيل الدخول لعرض مفضلتي',
      },
    };

  String translate(String key, {Map<String, String>? params}) {
    String value =
        (_localizedValues[locale.languageCode]?[key] ?? _localizedValues['en']?[key] ?? key);
    if (params != null) {
      params.forEach((k, v) {
        value = value.replaceAll('{$k}', v);
      });
    }
    return value;
  }

  String t(String key, {Map<String, String>? params}) =>
      translate(key, params: params);
}

class _AppLocalizationsDelegate
    extends LocalizationsDelegate<AppLocalizations> {
  const _AppLocalizationsDelegate();

  @override
  bool isSupported(Locale locale) =>
      ['en', 'ar'].contains(locale.languageCode);

  @override
  Future<AppLocalizations> load(Locale locale) async {
    return AppLocalizations(locale);
  }

  @override
  bool shouldReload(_AppLocalizationsDelegate old) => false;
}
