
//const baseUrl = "https://demo3.appman.in/api/";
const baseUrl = "http://api.lummang.com/api/";
const webBaseUrl = "http://admin.lummang.com/";
const imageBaseUrl = "http://web.lummang.com/";
const createRegisterApi = baseUrl + "MarketUsers/CreateRegister";
const loginApi = baseUrl + "MarketUsers/GetLoginInfo/";
const getMobileNumberExistance = baseUrl + "MarketUsers/GetMobileNumberExistance/";
const sendOtp = baseUrl + "MarketUsers/SendOtp/";
const updateMarketUser = baseUrl + "MarketUsers/UpdateMarketUser";
const updateMarketUserForWeb = baseUrl + "MarketUsers/UpdateMarketUserForWeb";

const buyerKycApi = baseUrl + "BuyerKYC/CreateBuyerKYC";
//const imageBaseUrl = "http://lummang.com/";

const businessTypeApi = baseUrl + "BusinessType/GetBusinessTypeList";
const clientImageUpload = imageBaseUrl + "BuyerKYC/BuyerKYCCreate";


const getParentCategoryList = baseUrl + "Category/GetParentCategoryList";
const getOnlySubCategoryListByParent = baseUrl + "Category/GetOnlySubCategoryListByParent/";

const getAllChildCategoryListByParentCategory = baseUrl + "Category/GetAllChildCategoryListByParentCategory/";
const deleteMyWishlist = baseUrl + "MyWishlist/DeleteMyWishlist/";

const  getProductListByCategory = baseUrl + "SellerProduct/GetProductListByCategory/";
const  getProductListBySubCategory = baseUrl + "SellerProduct/GetProductListBySubCategory/";
const  getProductListBySubCategoryList = baseUrl + "SellerProduct/GetProductListBySubCategoryList/";

const getMyWishlistListByMarketUser = baseUrl + "MyWishlist/GetMyWishlistListByMarketUser/";
const  addWishList = baseUrl + "MyWishlist/CreateMyWishlist";
const  singleMyWishlist = baseUrl + "MyWishlist/GetSingleMyWishlist/";
const  deleteWishList =  baseUrl + "MyWishlist/DeleteSingleMyWishlist/";

const  itemAddtoCart = baseUrl + "AddtoCart/CreateAddtoCart";
const getAddtocartlist = baseUrl + "AddtoCart/GetAddtoCartListByMarketUser/";
const getDeleteAddtoCart = baseUrl + "AddtoCart/DeleteAddtoCart/";
const getSingleSellerProduct = baseUrl + "SellerProduct/GetSingleSellerProduct/";
const createMyWishlist= baseUrl +"MyWishlist/CreateMyWishlist";

const updatePlusQuantity= baseUrl +"AddtoCart/UpdatePlusQuantity";
const updateMinusQuantity= baseUrl +"AddtoCart/UpdateMinusQuantity";

const getProductListBySubscriptions= baseUrl +"SellerProduct/GetProductListBySubscriptions";
const getSubscriptionTypeList= baseUrl +"SubscriptionType/GetSubscriptionTypeList";

const getAddressListByMarketUser= baseUrl +"Address/GetAddressListByMarketUser/";
const createAddress= baseUrl +"Address/CreateAddress";

const getSellerProductList = baseUrl + "SellerProduct/GetSellerProductList";
const getAllSellerProductLists = baseUrl + "SellerProduct/GetAllSellerProductList";
const getHomePageBannerLists = baseUrl + "CategoryBanner/GetHomePageBannerList";
const getBuyerNotification = baseUrl + "BuyerNotification/GetBuyerNotificationListOnlyBuyer/";
const getProductListBySubscriptionsId = baseUrl + "SellerProduct/GetProductListBySubscriptionsId/";

const gettGSTINVerification = baseUrl + "Sandbox/GSTINVerification";
const getPANVerification = baseUrl + "Sandbox/PanVerification";
const getAuthenticate = baseUrl + "Sandbox/Authenticate";

const getSimilarProductList = baseUrl + "SellerProduct/GetSimilarProductList";

const getOrderList = baseUrl + "Order/GetOrderListByBuyers/";
const getDeliveryChargesList = baseUrl + "DeliveryCharges/GetDeliveryChargesList";
const getBuyerKYCListByMarketUserId = baseUrl + "BuyerKYC/GetBuyerKYCListByMarketUserId/";