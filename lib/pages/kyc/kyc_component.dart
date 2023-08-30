import 'package:eva_icons_flutter/eva_icons_flutter.dart';
import 'package:flutter/material.dart';

import '../../constants/utils/custom_color.dart';


class InputDecor {
  static InputDecoration nameofBorderDecor(
      IconData prefixIcon,
      String hintText) => InputDecoration(
    prefixIcon: Icon(prefixIcon, size: 22,),
    hintText: '$hintText',
    hintStyle: const TextStyle(
        color: Colors.grey,
        fontWeight: FontWeight.w400,
        fontSize: 14.0
    ),
    filled: true,
    fillColor: Colors.grey[200],
    contentPadding: const EdgeInsets.all(10.0),
    enabledBorder:  const OutlineInputBorder(
      borderSide: BorderSide.none,
      borderRadius: BorderRadius.all( Radius.circular(10.0)),
    ),
    focusedBorder: OutlineInputBorder(
      borderRadius: BorderRadius.circular(10),
      borderSide: BorderSide.none,
    ),
    errorBorder: OutlineInputBorder(
      borderRadius: BorderRadius.circular(10),
      borderSide: const BorderSide(color: Colors.red),
    ),
    focusedErrorBorder: OutlineInputBorder(
      borderRadius: BorderRadius.circular(10),
      borderSide: const BorderSide(color: Colors.red),
    ),
  );
}

class DailogBoxInputDecor{
  static InputDecoration nameofTollTipInputDecor(
      IconData prefixIcon,
      String hintText,
      VoidCallback onPress) => InputDecoration(
    prefixIcon: Icon(prefixIcon, size: 22),
    suffixIcon: IconButton(
      onPressed: onPress,
      icon: Icon(EvaIcons.questionMarkCircleOutline,
        size: 20,
        color: Colors.red,
      ),
    ),
    hintText: '$hintText',
    hintStyle: const TextStyle(
        color: Colors.grey,
        fontWeight: FontWeight.w400,
        fontSize: 14.0
    ),
    filled: true,
    fillColor: Colors.grey[200],
    contentPadding: const EdgeInsets.all(10.0),
    enabledBorder:  const OutlineInputBorder(
      borderSide: BorderSide.none,
      borderRadius: BorderRadius.all( Radius.circular(10.0)),
    ),
    focusedBorder: OutlineInputBorder(
      borderRadius: BorderRadius.circular(10),
      borderSide: BorderSide.none,
    ),
    errorBorder: OutlineInputBorder(
      borderRadius: BorderRadius.circular(10),
      borderSide: const BorderSide(color: Colors.red),
    ),
    focusedErrorBorder: OutlineInputBorder(
      borderRadius: BorderRadius.circular(10),
      borderSide: const BorderSide(color: Colors.red),
    ),
  );
}

Widget CustomButton(
    String title,
    IconData icon,
    VoidCallback onTap) {
  return Column(
    mainAxisAlignment: MainAxisAlignment.center,
    children: [
      Container(
        width: 60,
        height: 60,
        decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(15),
            color: Colors.grey.shade200
        ),
        child: IconButton(
            onPressed: onTap,
            icon: Icon(icon)
        ),
      ),
      SizedBox(height: 10),
      Text(title)
    ],
  );
}

@override
Widget StoreImgButton(
    BuildContext context,
    String label,
    VoidCallback onPress,
    ) {

  double deviceWidth = MediaQuery.of(context).size.width;

      return Column(
        children: [
          SizedBox(
            width: deviceWidth * 0.30,
            child: ElevatedButton.icon(
              onPressed: onPress,
              icon: Icon(EvaIcons.cameraOutline, size: 25,),
              label: Text(label,
                style: TextStyle(
                    fontSize: 12
                ),
              ),
              style: ElevatedButton.styleFrom(
                  primary: label == "Try Again" ? Colors.red : PrimaryColor
              ),
            ),
          ),
        ],
      );
}

 // Inside Store
@override
Widget InsideStoreImgButton(
    BuildContext context,
    String label,
    VoidCallback onPress,
    ) {

  double deviceWidth = MediaQuery.of(context).size.width;

  return Column(
    children: [
      SizedBox(
        width: deviceWidth * 0.50,
        child: ElevatedButton.icon(
          onPressed: onPress,
          icon: Icon(EvaIcons.cameraOutline, size: 25,),
          label: Text(label,
            style: TextStyle(
                fontSize: 15
            ),
          ),
          style: ElevatedButton.styleFrom(
              primary: label == "Try Again" ? Colors.red : PrimaryColor
          ),
        ),
      ),
    ],
  );
}

// Upload Document
@override
Widget UdyamImgButton(
    BuildContext context,
    String label,
    VoidCallback onPress,
    ) {

  double deviceWidth = MediaQuery.of(context).size.width;

  return Column(
    children: [
      SizedBox(
        width: deviceWidth * 0.80,
        child: ElevatedButton.icon(
          onPressed: onPress,
          icon: Icon(Icons.file_upload, size: 25,),
          label: Text(label,
            style: TextStyle(
                fontSize: 15
            ),
          ),
          style: ElevatedButton.styleFrom(
              primary: label == "Try Again" ? Colors.red : PrimaryColor
          ),
        ),
      ),
    ],
  );
}

@override
Widget UploadDocumentImgButton(
    BuildContext context,
    String label,
    VoidCallback onPress,
    ) {

  double deviceWidth = MediaQuery.of(context).size.width;

  return Column(
    children: [
      SizedBox(
        width: deviceWidth * 0.80,
        child: ElevatedButton.icon(
          onPressed: onPress,
          icon: Icon(EvaIcons.cameraOutline, size: 25,),
          label: Text(label,
            style: TextStyle(
                fontSize: 15
            ),
          ),
          style: ElevatedButton.styleFrom(
              primary: label == "Try Again" ? Colors.red : PrimaryColor
          ),
        ),
      ),
    ],
  );
}

@override
Widget OtherDocumentsButton(BuildContext context,
    String title,
    String label,
    VoidCallback onPress){
  double deviceWidth = MediaQuery.of(context).size.width;
  return Column(
    children: [
      Text( title,
        style: TextStyle(
            fontSize: 12,
            fontWeight: FontWeight.w400
        ),
      ),
      SizedBox(
        width: deviceWidth * 0.30,
        child: ElevatedButton.icon(
          onPressed: onPress,
          icon: Icon(EvaIcons.cameraOutline, size: 20,),
          label: Text(label,
            style: TextStyle(
                fontSize: 11.5
            ),
          ),
          style: ElevatedButton.styleFrom(
              primary: label == "Try Again" ? Colors.red : PrimaryColor
          ),
        ),
      ),
    ],
  );
}

SuggestionDialogue(
    BuildContext context,
    String text,
    String assetImage) {
  showDialog(
    context: context,
    barrierDismissible: false,
    builder: (BuildContext context) {
      double deviceWidth = MediaQuery.of(context).size.width;
      double deviceHeight = MediaQuery.of(context).size.height;
      // return object of type Dialog
      return Container(
        width: deviceWidth * 0.5,
        child: Dialog(
          insetPadding: EdgeInsets.symmetric(horizontal: 60),
          elevation: 5.0,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(10.0),
          ),
          child: Wrap(
            children: <Widget>[
              Padding(
                padding: EdgeInsets.fromLTRB(10.0, 10.0, 10.0, 0),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    Text('Locate your $text?',
                      style: TextStyle(
                        fontSize: 16.0,
                        fontWeight: FontWeight.w500,
                        color: Colors.black87
                      ),
                    ),
                    SizedBox(height: deviceHeight * 0.02),
                    Image(
                        image: AssetImage('$assetImage'),
                      width: deviceWidth,
                      fit: BoxFit.contain,
                    ),
                    Divider(),

                    InkWell(
                      onTap: (){
                        Navigator.pop(context);
                      },
                      child: SizedBox(
                        width: deviceWidth,
                        height: deviceHeight * 0.04,
                        child: Center(
                          child: Text("OK",
                            style: TextStyle(
                              fontSize: 20,
                              fontWeight: FontWeight.w500,
                              color: PrimaryColor
                            ),
                          ),
                        )
                      ),
                    ),
                    SizedBox(height: 5)
                  ],
                ),
              ),
            ],
          ),
        ),
      );
    },
  );
}
