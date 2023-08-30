import 'dart:convert';
import 'dart:io';
import 'package:eva_icons_flutter/eva_icons_flutter.dart';
import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:my_store/constants/utils/custom_color.dart';
import 'package:my_store/functions/showToast.dart';
import 'package:my_store/pages/home/home.dart';
import 'package:mime/mime.dart';
import 'package:http_parser/http_parser.dart';
import 'package:path_provider/path_provider.dart';
import 'package:pinput/pinput.dart';
import 'package:select_form_field/select_form_field.dart';
import 'package:page_transition/page_transition.dart';
import 'package:image_picker/image_picker.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';
import '../../constants/urls/urls.dart';
import '../login_signup/login.dart';
import 'kyc_component.dart';

class KYCPage extends StatefulWidget {
  final int marketUserId;
  KYCPage(this.marketUserId);



  @override
  _KYCPageState createState() => _KYCPageState();
}

class _KYCPageState extends State<KYCPage> {
  bool contactnoValidationFailed = false;
  File _pickedImage;
  File _pickedFrontSideImage;
  File _pickedInsideSideImage;
  File _pickedBackSideImage;

  File selectedDocumentImage;
  String base64DocumentImage = "";
  Future<void> uploadDocumentImage(type) async {
    // ignore: prefer_typing_uninitialized_variables
    var image;
    if (type == "camera") {
      image = await ImagePicker()
          .pickImage(source: ImageSource.camera, imageQuality: 10);
    } else {
      image = await ImagePicker()
          .pickImage(source: ImageSource.gallery, imageQuality: 25);
    }
    if (image != null) {
      setState(() {
        selectedDocumentImage = File(image.path);
        base64DocumentImage =
            base64Encode(selectedDocumentImage.readAsBytesSync());
        // won't have any error now
      });
    }
  }

  File selectedfrontImage;
  String uploadfrontImage = "";
  Future<void> frontImage(type) async {
    var image;
    if (type == "camera") {
      image = await ImagePicker().pickImage(source: ImageSource.camera);
    }
    if (image != null) {
      setState(() {
        selectedfrontImage = File(image.path);
        uploadfrontImage = base64Encode(selectedfrontImage.readAsBytesSync());
        // won't have any error now
      });
    }
  }

  File selectedInsideImage;
  String uploadInsideImage = "";
  Future<void> insideImage(type) async {
    // ignore: prefer_typing_uninitialized_variables
    var image;
    if (type == "camera") {
      image = await ImagePicker().pickImage(source: ImageSource.camera);
    }
    if (image != null) {
      setState(() {
        selectedInsideImage = File(image.path);
        uploadInsideImage = base64Encode(selectedInsideImage.readAsBytesSync());
        // won't have any error now
      });
    }
  }

  File selectedBackImage;
  String uploadbackImage = "";
  Future<void> backImage(type) async {
    // ignore: prefer_typing_uninitialized_variables
    var image;
    if (type == "camera") {
      image = await ImagePicker().pickImage(source: ImageSource.camera);
    }
    if (image != null) {
      setState(() {
        selectedBackImage = File(image.path);
        print(selectedBackImage);
        print("***************************************************");
        uploadbackImage = base64Encode(selectedBackImage.readAsBytesSync());
        // won't have any error now
      });
    }
  }

  void _uploadImage(String from) async {
    if (from == "gallery") {
      final pickedImageFile =
          await ImagePicker().pickImage(source: ImageSource.gallery);
      setState(() {
        _pickedImage = File(pickedImageFile.path.toString());
      });
    } else {
      final pickedImageFile =
          await ImagePicker().pickImage(source: ImageSource.camera);
      setState(() {
        _pickedImage = File(pickedImageFile.path.toString());
      });
    }
  }

  void _frontSideImage(String from) async {
    if (from == "gallery") {
      final pickedImageFile =
          await ImagePicker().pickImage(source: ImageSource.gallery);
      setState(() {
        _pickedFrontSideImage = File(pickedImageFile.path.toString());
      });
    } else {
      final pickedImageFile =
          await ImagePicker().pickImage(source: ImageSource.camera);
      setState(() {
        _pickedFrontSideImage = File(pickedImageFile.path.toString());
      });
    }
  }

  void _insideImage(String from) async {
    if (from == "gallery") {
      final pickedImageFile =
          await ImagePicker().pickImage(source: ImageSource.gallery);
      setState(() {
        _pickedInsideSideImage = File(pickedImageFile.path.toString());
      });
    } else {
      final pickedImageFile =
          await ImagePicker().pickImage(source: ImageSource.camera);
      setState(() {
        _pickedInsideSideImage = File(pickedImageFile.path.toString());
      });
    }
  }

  void _backSideImage(String from) async {
    if (from == "gallery") {
      final pickedImageFile =
          await ImagePicker().pickImage(source: ImageSource.gallery);
      setState(() {
        _pickedBackSideImage = File(pickedImageFile.path.toString());
      });
    } else {
      final pickedImageFile =
          await ImagePicker().pickImage(source: ImageSource.camera);
      setState(() {
        _pickedBackSideImage = File(pickedImageFile.path.toString());
      });
    }
  }

  List documentType = [
    {
      "title": "Shop Establishment Certificate",
      "value": "Shop Establishment Certificate"
    },
    {"title": "Trade Licence", "value": "Trade Licence"},
    {"title": "Electric Bill", "value": "Electric Bill"},
    {"title": "Any Other Document", "value": "Any Other Document"},
  ];
  String documentValue = "";
  var mob_number;
  TextEditingController shopname_controller = TextEditingController();
  TextEditingController shopowner_controller = TextEditingController();
  TextEditingController gst_controller = TextEditingController();
  TextEditingController pin_controller = TextEditingController();
  TextEditingController uploadDocument_controller = TextEditingController();
  TextEditingController reference_controller = TextEditingController();
  TextEditingController _controller;

  String _business = '0';
  String _valueToValidate = '';
  String _valueSaved = '';

  final TextEditingController gstController = TextEditingController();
  bool isGSTVerified = false;
  bool isPanVerified = false;
  String verificationMessage = "";
  String errorMessage = '';
  Color verificationColor = Colors.black;
  String nGSTVerification ="";
  String GstVerifyName ="";
  void GSTVerification(String gstNumber) async {
    String api = gettGSTINVerification +
        "?" +
        "authorization=" +
        token +
        "&gstin=" +
        gstNumber;
    final response = await http.get(Uri.parse(api));
    print(response.statusCode);
    print(gstNumber);
    if (response.statusCode == 200) {
      var mjson = json.decode(response.body);
      String jsonString = json.encode(mjson);

      /// Convert JSON data to a string
      setState(() {
        nGSTVerification = jsonString;
        isGSTVerified = true; // Set the verification flag to true
        //  verificationMessage = "Successfully Verified";
        if (mjson["code"] == 200) {
          setState(() {
            verificationMessage = "Successfully Verified";
            GstVerifyName = mjson["data"]["lgnm"];
            verificationColor = Colors.green;
          });
        } else if (mjson["code"] == 422) {
          setState(() {
            verificationMessage = "Invalid GSTIN pattern";
          //  verificationColor = Colors.red;
          });
        } else if (mjson["code"] == 403) {
          setState(() {
            verificationMessage = "Invalid GSTIN pattern";
          //  verificationColor = Colors.red;
          });
        } else if (mjson["code"] == 500) {
          setState(() {
            verificationMessage = "Invalid GSTIN pattern";
           // verificationColor = Colors.red;
          });
        }
      });
      print("------------------------------------------" + jsonString);
    } else {
      setState(() {
        isGSTVerified = false;
        verificationMessage = "Verification failed";
        verificationColor = Colors.red;
      });
      print('API Error');
    }
  }

  ///GST Number
  //27AAECL8827H1Z6

  /// Pan_Verification
  String nPANVerification = "";
  String FullName = "";
  void PanVerification(String PanCard) async {
    String api = getPANVerification+"?" + "authorization=" + token + "&pan=" + PanCard;
    final response = await http.get(Uri.parse(api));
    print(response.statusCode);
    print("JJJJJJJJJJJJJJJJJJJJJJJJJJJJJJJJJJJJJJJJJJJJJJJ"+PanCard);
    if (response.statusCode == 200) {
      var mjson = json.decode(response.body);
      String jsonString = json.encode(mjson); /// Convert JSON data to a string
      setState(() {
        nPANVerification = jsonString;
        FullName = mjson["data"]["full_name"];
        // Set the verification flag to true
        if (mjson["code"] == 200) {
          setState(() {
            isPanVerified = true;
            verificationMessage = "Successfully Pan Verified";
            verificationColor = Colors.green;
          });
        }  else if (mjson["code"] == 403) {
          setState(() {
            verificationMessage = "Invalid Pan Pattern";
       //     verificationColor = Colors.red;
          });
        } else if (mjson["code"] == 500) {
          setState(() {
            verificationMessage = "Invalid Pan Pattern";
         //  verificationColor = Colors.red;
          });
        }
      });
      print(FullName);
      print(nPANVerification);
    } else {
      setState(() {
        isPanVerified = false; // Set the verification flag to false
        verificationMessage = "Verification failed";// Update the verification message
      //  verificationColor = Colors.red;
      });
      print('apppi Error');
    }
  }

  @override
  void dispose() {
    gstController.dispose();
    super.dispose();
  }

  /// KYC
  bool _isLoading = false;
  Future<void> buyerKYC() async {
    if (_isLoading) {
      return; // Prevent multiple requests while already loading
    }

    setState(() {
      _isLoading = true;
    });

    try {
      SharedPreferences prefs = await SharedPreferences.getInstance();
      setState(() {
        contactnoValidationFailed = false;
      });
      final imageUploadRequest =
      http.MultipartRequest('POST', Uri.parse(clientImageUpload));

      final mimeTypeData =
      lookupMimeType(_pickedImage.path.toString(), headerBytes: [0xFF, 0xD8])
          .split('/');
      final Uploadfile = await http.MultipartFile.fromPath('file', _pickedImage.path,
          contentType: MediaType(mimeTypeData[0], mimeTypeData[1]));

      final frontTypeData = lookupMimeType(_pickedFrontSideImage.path.toString(),
          headerBytes: [0xFF, 0xD8]).split('/');
      final frontImageFile = await http.MultipartFile.fromPath(
          'file1', _pickedFrontSideImage.path,
          contentType: MediaType(frontTypeData[0], frontTypeData[1]));

      final insideTypeData = lookupMimeType(
          _pickedInsideSideImage.path.toString(),
          headerBytes: [0xFF, 0xD8]).split('/');
      final insideImageFile = await http.MultipartFile.fromPath(
          'file2', _pickedInsideSideImage.path,
          contentType: MediaType(insideTypeData[0], insideTypeData[1]));

      final backTypeData = lookupMimeType(_pickedBackSideImage.path.toString(),
          headerBytes: [0xFF, 0xD8]).split('/');
      final backImageFile = await http.MultipartFile.fromPath(
          'file3', _pickedBackSideImage.path,
          contentType: MediaType(backTypeData[0], backTypeData[1]));

      imageUploadRequest.files.add(Uploadfile);
      imageUploadRequest.files.add(frontImageFile);
      imageUploadRequest.files.add(insideImageFile);
      imageUploadRequest.files.add(backImageFile);
      print("GGGGGGGGGGGGGGGGGGGGGGGGGGGGGGGGGGGGGGGGGGGGGGGGGGGG");
      imageUploadRequest.fields['ShopOwnerName '] = shopowner_controller.text;
      imageUploadRequest.fields['ShopeName'] = shopname_controller.text;
      imageUploadRequest.fields['GSTINNo '] = gst_controller.text;
      imageUploadRequest.fields['BusinessTypeId '] = _business.toString();
      imageUploadRequest.fields['DocumentType '] = documentValue;
      imageUploadRequest.fields['PostalCode '] = pin_controller.text;
      imageUploadRequest.fields['ReferenceCode '] = reference_controller.text;
      imageUploadRequest.fields['CreatedBy'] = widget.marketUserId.toString();

      print(
          imageUploadRequest.fields['ShopOwnerName'] = shopowner_controller.text);
      print(imageUploadRequest.fields['ShopeName'] = shopname_controller.text);
      print(imageUploadRequest.fields['GSTINNo'] = gstController.text);
      print(imageUploadRequest.fields['BusinessTypeId'] = _business.toString());
      print(imageUploadRequest.fields['DocumentType'] = documentValue);
      print(imageUploadRequest.fields['PostalCode'] = pin_controller.text);
      print(imageUploadRequest.fields['ReferenceCode'] = reference_controller.text);
      print( imageUploadRequest.fields['CreatedBy'] = widget.marketUserId.toString());
      final streamedResponse = await imageUploadRequest.send();
      final response = await http.Response.fromStream(streamedResponse);
      print(response.statusCode);
      print("TTTTTTTTTTTTTTTTTTTTTTTTTTTTTTTTTTTTTTTTTTTTTTTTTTTTTTTTTTT");
      if (response.statusCode == 200) {
        print(response.statusCode);
        Map mjson = json.decode(response.body);
        print("============================="+mjson.toString());
        // preference.setString("storecode", mjson["storeCode"].toString());
        SharedPreferences preference = await SharedPreferences.getInstance();
        preference.setString("ShopOwnerName", shopowner_controller.text);
        preference.setString("ShopeName", shopname_controller.text);
        preference.setString("GSTINNo", gstController.text);
        preference.setString("usertype", "login");
        print(
            "PPPPPPPPPPPPPPPPPPPPPPPPPPPPPPPPPPPPPPPPPPPPPPPPPPPPPPPPPPPPPPPPPPPPPPPPPPPPPPPPPPPPPPPP");
        Navigator.pushAndRemoveUntil(
            context,
            MaterialPageRoute(builder: (context) => Home()),
                (Route<dynamic> route) => false);
      } else {
        showInSnackBar("Please Enter Different GST And pan Number");
        print("error");
        //Navigator.of(context).pop();
      }
    } catch (error) {
      print('Error: $error');
    } finally {
      setState(() {
        _isLoading = false;
      });
    }
  }
  List<String> imagePaths = [];
  void showInSnackBar(String value) {
    ScaffoldMessenger.of(context).showSnackBar(SnackBar(
      content: Text(value.toString()),
    ));
  }

  /// GSTAuthenticate
  List nAuthenticate = [];
  String token = "";
  void GstVerificatonToken() async {
    String api = getAuthenticate;
    final response = await http.get(Uri.parse(api));
    print(response.statusCode);
    if (response.statusCode == 200) {
      Map mjson = json.decode(response.body);
      // print(mjson);
      setState(() {
        nAuthenticate = mjson["data"];
        token = mjson["access_token"];
      });
    } else {
      print('appi Error');
    }
  }

  //Color verificationColor = Colors.black; /// Default color
  // bool isGSTVerified = false;
  // String verificationMessage = "";


  final List<Map<String, dynamic>> _item = [];

  void businessServiceType() async {
    var encoded = Uri.parse(businessTypeApi);
    http.get(encoded).then((value) {
      // print(value.statusCode);
      if (value.statusCode == 200) {
        Map mjson;
        mjson = json.decode(value.body);
        print(mjson);
        for (int i = 0; i < mjson["data"].length; i++) {
          setState(() {
            _item.add(
              {
                'value': mjson["data"][i]["businessTypeId"],
                'label': mjson["data"][i]["businessTypeName"],
              },
            );
          });
        }
      }
    });
  }

  final GlobalKey<FormState> formKey = GlobalKey<FormState>();

  @override
  void initState() {
    super.initState();
    businessServiceType();
    GstVerificatonToken();
    getDetails();
  }
  String mobileNumber = "";
  String marketUserId = "";
  void getDetails() async {
    SharedPreferences preferences = await SharedPreferences.getInstance();
    setState(() {
      marketUserId = preferences.getString("marketUserId").toString();
      mobileNumber = preferences.getString("mobileNumber").toString();

    });

  }

  @override
  Widget build(BuildContext context) {
    print(widget.marketUserId.toString()+"xxxxxxxxxxxxxxxxxxxxxxxxxxxxxxx");
    double deviceHeight = MediaQuery.of(context).size.height;
    double deviceWidth = MediaQuery.of(context).size.width;
    final arguments = (ModalRoute.of(context)?.settings.arguments ??
        <String, dynamic>{}) as Map;
    setState(() {
      mob_number = arguments['mob'];
    });
    return Scaffold(
      body: Stack(
        children: [
          SingleChildScrollView(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Column(
                  children: <Widget>[
                    SizedBox(height:80,),
                    Center(

                      child: Container(
                        width: deviceWidth - 25.0,
                        padding: EdgeInsets.all(20),
                        decoration: BoxDecoration(
                          color:
                          Theme.of(context).appBarTheme.backgroundColor,
                          borderRadius: BorderRadius.circular(15.0),
                          boxShadow: [
                            BoxShadow(
                              blurRadius: 25,
                              color: Colors.grey,
                            ),
                          ],
                        ),

                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.center,
                          mainAxisAlignment: MainAxisAlignment.start,
                          children: <Widget>[
                            Text(
                              "Verify your Business",
                              style: TextStyle(
                                fontSize: 18,
                                fontWeight: FontWeight.w500,
                              ),
                            ),
                            SizedBox(height: 20),

                            /// Shop Name
                            TextFormField(
                                controller: shopname_controller,
                                validator: (value) {
                                  if (value.isEmpty) {
                                    ShowToast()
                                        .showToast('Shop name is empty');
                                  }
                                },
                                decoration: InputDecor.nameofBorderDecor(
                                    Icons.shopping_bag_outlined,
                                    'Shop Name*')),
                            SizedBox(height: deviceHeight * 0.01),

                            ///Shop Owner Name
                            TextFormField(
                                controller: shopowner_controller,
                                decoration: InputDecor.nameofBorderDecor(
                                    EvaIcons.personOutline,
                                    'Shop Owner Name*')),
                            SizedBox(height: deviceHeight * 0.01),

                            /// Postal Pin Code
                            TextFormField(
                              controller: pin_controller,
                              // maxLength: 6,
                              keyboardType: TextInputType.number,
                              decoration: InputDecor.nameofBorderDecor(
                                  Icons.pin_outlined, 'Postal Code*'),
                            ),
                            SizedBox(height: deviceHeight * 0.01),

                            /// Business Type
                            Container(
                              height: 45,
                              decoration: BoxDecoration(
                                color: Colors.grey[200],
                                borderRadius:
                                BorderRadius.all(Radius.circular(10.0)),
                              ),
                              child: SizedBox(
                                // width: 350,
                                child: _item.length > 0
                                    ? SelectFormField(
                                  decoration: InputDecoration(
                                    focusedBorder:
                                    InputBorder.none,
                                    enabledBorder:
                                    InputBorder.none,
                                    hintText: 'Business Type*',
                                    hintStyle: TextStyle(
                                        color: Colors.grey),
                                    contentPadding:
                                    const EdgeInsets.all(
                                        10),
                                  ),
                                  type: SelectFormFieldType
                                      .dropdown,
                                  controller: _controller,
                                  //initialValue: _initialValue,

                                  changeIcon: false,
                                  dialogTitle:
                                  'Please select Business Type Type',
                                  dialogCancelBtn: 'CANCEL',
                                  enableSearch: true,
                                  dialogSearchHint:
                                  'Search item',
                                  items: _item,
                                  onChanged: (val) =>
                                      setState(() =>
                                      _business = val),
                                  validator: (val) {
                                    setState(() =>
                                    _valueToValidate =
                                        val ?? '');
                                    return null;
                                  },
                                  onSaved: (val) => setState(
                                          () => _valueSaved =
                                          val ?? ''),
                                )
                                    : SizedBox(),
                              ),
                            ),

                            SizedBox(height: deviceHeight * 0.01),

                            /// GST Number Or Pan Card Number
                            TextFormField(
                              controller: gstController,
                              onChanged: (value) {
                                String gstController = value; // Assuming gstController is a variable accessible in the current scope

                                if (gstController.length < 10) {
                                  setState(() {
                                    // Update the UI with the invalid GST pattern message
                                    errorMessage = "Invalid Pan Pattern";
                                    verificationColor=Colors.red;

                                  });
                                } else if (gstController.length == 10) {
                                  String panCard = gstController;
                                  PanVerification(panCard);

                                  setState(() {
                                    verificationColor=Colors.green;
                                    errorMessage = " ";
                                  });
                                  // Call PAN verification API
                                } else if (gstController.length > 10 && gstController.length < 15) {
                                  setState(() {
                                    // Update the UI with the invalid GST pattern message
                                    errorMessage = "Invalid GST Pattern";
                                    verificationColor=Colors.red;
                                  });
                                } else if (gstController.length > 15) {
                                  setState(() {
                                    errorMessage = "Invalid GST Pattern";
                                    verificationColor=Colors.red;
                                  });
                                } else if (gstController.length == 15) {
                                  String gstNumber = gstController;
                                  GSTVerification(gstNumber);
                                  Text("ffghhhhhh");
                                  setState(() {
                                    verificationColor=Colors.green;
                                    errorMessage = " ";
                                  });
                                  //   verificationColor=Colors.green;
                                  // Call GST verification API
                                }
                              },

                              decoration: InputDecoration(
                                filled: true,
                                hintText: "GST or Pan Card Number*",
                                hintStyle: TextStyle(color: Colors.grey),
                                contentPadding: const EdgeInsets.all(10.0),
                                enabledBorder: const OutlineInputBorder(
                                  borderSide: BorderSide.none,
                                  borderRadius: BorderRadius.all(
                                      Radius.circular(10.0)),
                                ),
                                focusedBorder: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(10),
                                  borderSide: BorderSide.none,
                                ),
                                errorBorder: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(10),
                                  borderSide:
                                  const BorderSide(color: Colors.red),
                                ),
                                focusedErrorBorder: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(10),
                                  borderSide:
                                  const BorderSide(color: Colors.red),
                                ),
                              ),
                            ),
                            Text(
                              // errorMessage,
                              // verificationMessage,
                              GstVerifyName.toString(),
                              style: TextStyle(
                                color: verificationColor,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            Text(
                              // errorMessage,
                              // verificationMessage,
                              FullName.toString(),
                              style: TextStyle(
                                color: verificationColor,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            SizedBox(height: deviceHeight * 0.01),

                            /// Reference Code
                            TextFormField(
                                controller: reference_controller,
                                // keyboardType: TextInputType.number,
                                decoration: InputDecor.nameofBorderDecor(
                                    EvaIcons.code, 'Reference Code')),
                            SizedBox(height: deviceHeight * 0.01),

                            /// Document Type
                            Container(
                              padding: EdgeInsets.only(left: 15, right: 15),
                              height: 45,
                              decoration: BoxDecoration(
                                color: Colors.grey[200],
                                borderRadius:
                                BorderRadius.all(Radius.circular(10.0)),
                              ),
                              child: DropdownButtonHideUnderline(
                                child: DropdownButton<String>(
                                    isDense: true,
                                    value: documentValue,
                                    isExpanded: true,
                                    menuMaxHeight: 350,
                                    icon: Icon(
                                      EvaIcons.chevronDownOutline,
                                      color: Colors.black45,
                                    ),
                                    iconSize: 28,
                                    elevation: 16,
                                    items: [
                                      const DropdownMenuItem(
                                          child: Text(
                                            "Document Type*",
                                            style: TextStyle(
                                                color: Colors.grey),
                                          ),
                                          value: ""),
                                      ...documentType
                                          .map<DropdownMenuItem<String>>(
                                              (data) {
                                            return DropdownMenuItem(
                                                child: Text(data['title']),
                                                value: data['value']);
                                          }).toList(),
                                    ],
                                    onChanged: (value) {
                                      print("selected Patient Type $value");
                                      setState(() {
                                        documentValue = value;
                                      });
                                    }),
                              ),
                            ),
                            // SizedBox(height: deviceHeight * 0.01),

                            /// Upload Document
                            ElevatedButton(
                              onPressed: () {
                                //  Navigator.pop(context);
                                //  uploadDocumentImage("Gallery");

                                showModalBottomSheet(
                                    context: context,
                                    builder: (context) {
                                      return Column(
                                        mainAxisSize: MainAxisSize.min,
                                        children: <Widget>[
                                          ListTile(
                                            leading: new Icon(Icons.photo),
                                            title: new Text('Gallery'),
                                            onTap: () {
                                              Navigator.pop(context);
                                              _uploadImage("gallery");
                                            },
                                          ),
                                          ListTile(
                                            leading:
                                            new Icon(Icons.videocam),
                                            title: new Text('Camera'),
                                            onTap: () {
                                              Navigator.pop(context);
                                              _uploadImage("camera");
                                            },
                                          ),
                                        ],
                                      );
                                    });
                              },
                              style: ElevatedButton.styleFrom(
                                backgroundColor: _pickedImage == null
                                    ? Color(0xFF526FD8)
                                    : Colors.green,
                              ),
                              child: _pickedImage == null
                                  ? Text("Upload Document*")
                                  : Text("Upload Successful"),
                            ),

                            SizedBox(height: deviceHeight * 0.02),

                            /// Upload Store Images
                            Text(
                              'Upload Store Images',
                              style: TextStyle(
                                  fontSize: 18,
                                  fontWeight: FontWeight.w400),
                            ),
                            SizedBox(height: deviceHeight * 0.01),

                            Row(
                              mainAxisAlignment:
                              MainAxisAlignment.spaceBetween,
                              children: <Widget>[
                                ElevatedButton(
                                  onPressed: () {
                                    //  frontImage("camera");
                                    showModalBottomSheet(
                                        context: context,
                                        builder: (context) {
                                          return Column(
                                            mainAxisSize: MainAxisSize.min,
                                            children: <Widget>[
                                              ListTile(
                                                leading:
                                                new Icon(Icons.photo),
                                                title: new Text('Gallery'),
                                                onTap: () {
                                                  Navigator.pop(context);
                                                  _frontSideImage(
                                                      "gallery");
                                                },
                                              ),
                                              ListTile(
                                                leading: new Icon(
                                                    Icons.videocam),
                                                title: new Text('Camera'),
                                                onTap: () {
                                                  Navigator.pop(context);
                                                  _frontSideImage("camera");
                                                },
                                              ),
                                            ],
                                          );
                                        });
                                  },
                                  style: ElevatedButton.styleFrom(
                                    backgroundColor:
                                    _pickedFrontSideImage == null
                                        ? Color(0xFF526FD8)
                                        : Colors.green,
                                  ),
                                  child: _pickedFrontSideImage == null
                                      ? Text(" Front Side*")
                                      : Text("Success"),
                                ),
                                ElevatedButton(
                                  onPressed: () {
                                    // insideImage("camera");
                                    showModalBottomSheet(
                                        context: context,
                                        builder: (context) {
                                          return Column(
                                            mainAxisSize: MainAxisSize.min,
                                            children: <Widget>[
                                              ListTile(
                                                leading:
                                                new Icon(Icons.photo),
                                                title: new Text('Gallery'),
                                                onTap: () {
                                                  Navigator.pop(context);
                                                  _insideImage("gallery");
                                                },
                                              ),
                                              ListTile(
                                                leading: new Icon(
                                                    Icons.videocam),
                                                title: new Text('Camera'),
                                                onTap: () {
                                                  Navigator.pop(context);
                                                  _insideImage("camera");
                                                },
                                              ),
                                            ],
                                          );
                                        });
                                  },
                                  style: ElevatedButton.styleFrom(
                                    backgroundColor:
                                    _pickedInsideSideImage == null
                                        ? Color(0xFF526FD8)
                                        : Colors.green,
                                  ),
                                  child: _pickedInsideSideImage == null
                                      ? Text("Inside 1*")
                                      : Text("Success"),
                                ),
                                ElevatedButton(
                                  onPressed: () {
                                    //  backImage("camera");
                                    showModalBottomSheet(
                                        context: context,
                                        builder: (context) {
                                          return Column(
                                            mainAxisSize: MainAxisSize.min,
                                            children: <Widget>[
                                              ListTile(
                                                leading:
                                                new Icon(Icons.photo),
                                                title: new Text('Gallery'),
                                                onTap: () {
                                                  Navigator.pop(context);
                                                  _backSideImage("gallery");
                                                },
                                              ),
                                              ListTile(
                                                leading: new Icon(
                                                    Icons.videocam),
                                                title: new Text('Camera'),
                                                onTap: () {
                                                  Navigator.pop(context);
                                                  _backSideImage("camera");
                                                },
                                              ),
                                            ],
                                          );
                                        });
                                  },
                                  style: ElevatedButton.styleFrom(
                                    backgroundColor:
                                    _pickedBackSideImage == null
                                        ? Color(0xFF526FD8)
                                        : Colors.green,
                                  ),
                                  child: _pickedBackSideImage == null
                                      ? Text("Inside 2*")
                                      : Text("Success"),
                                ),
                              ],
                            ),
                            SizedBox(height: deviceHeight * 0.04),
                            InkWell(
                              onTap: () {
                                // if (formKey.currentState.validate()) {
                                //   // Validation successful, proceed with buyerKYC
                                //   buyerKYC();
                                // }



                                if (shopname_controller.text.isEmpty) {
                                  ShowToast().showToast('Shop Name is empty');
                                } else if (shopowner_controller.text.isEmpty) {
                                  ShowToast().showToast("Shop Owner Name is empty");
                                } else if (pin_controller.text.isEmpty) {
                                  ShowToast().showToast("Pin Code is empty");
                                }else if (_controller != null) {
                                  ShowToast().showToast("Business Type is empty");
                                } else if (gstController.text.isEmpty) {
                                  ShowToast().showToast("GST Or Pan Number is empty");
                                } else if (documentValue.isEmpty) {
                                  ShowToast().showToast("Document Type is empty");
                                } else {
                                  buyerKYC();
                                }
                              },
                              child: Container(
                                height: 45.0,
                                width: deviceWidth,
                                child: Material(
                                  borderRadius: BorderRadius.circular(20.0),
                                  shadowColor:
                                  PrimaryColor.withOpacity(0.4),
                                  color: PrimaryColor,
                                  elevation: 7.0,
                                  child: GestureDetector(
                                    child: Center(
                                      child: Text(
                                        "Submit",
                                        style: TextStyle(
                                          color: Colors.white,
                                          fontSize: 16.0,
                                          letterSpacing: 1.0,
                                          fontWeight: FontWeight.bold,
                                        ),
                                      ),
                                    ),
                                  ),
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
          if (_isLoading)
            Container(
              color: Colors.black.withOpacity(0.5), // Semi-transparent background
              child: Center(
                child: SpinKitFadingCircle(
                  // Colors.deepPurple.shade800,
                  color: Color(0xFF526FD8),
                  size: 80.0,
                ),
                //CircularProgressIndicator(),
              ),
            ),
        ],
      ),
    );
  }
}

