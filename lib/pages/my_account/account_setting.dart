import 'package:flutter/material.dart';
import 'package:my_store/functions/localizations.dart';
import 'package:my_store/pages/login_signup/login.dart';

class AccountSetting extends StatefulWidget {
  @override
  _AccountSettingState createState() => _AccountSettingState();
}

class _AccountSettingState extends State<AccountSetting> {
  @override
  Widget build(BuildContext context) {
    double width = MediaQuery.of(context).size.width;

    ListTile getListTile(title) {
      // Widget for common ListTile
      return ListTile(
        title: Text(
          title,
          style: TextStyle(color: Colors.grey, fontSize: 18.0),
        ),
        trailing: Icon(
          Icons.keyboard_arrow_right,
          color: Colors.grey,
        ),
        onTap: () {},
      );
    }

    // Widget for common divider
    Padding getDivider() {
      return Padding(
        padding: EdgeInsets.only(left: 12.0),
        child: Divider(
          height: 1.0,
        ),
      );
    }

    // Logout AlertDialog Start Here
    logoutDialogue() {
      showDialog(
        context: context,
        barrierDismissible: false,
        builder: (BuildContext context) {
          // return object of type Dialog
          return Dialog(
            elevation: 5.0,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(10.0),
            ),
            child: Wrap(
              children: <Widget>[
                Padding(
                  padding: EdgeInsets.all(15.0),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.start,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      Text(
                        AppLocalizations.of(context)
                            .translate('myAccountPage', 'sureDialogueString'),
                        style: TextStyle(
                          fontSize: 18.0,
                          fontWeight: FontWeight.w600,
                          color: Theme.of(context).textTheme.headline6?.color,
                        ),
                      ),
                      SizedBox(
                        height: 20.0,
                      ),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceAround,
                        children: <Widget>[
                          InkWell(
                            onTap: () {
                              Navigator.pop(context);
                            },
                            child: Container(
                              width: (width / 3.5),
                              alignment: Alignment.center,
                              padding: EdgeInsets.all(10.0),
                              decoration: BoxDecoration(
                                color: Colors.grey[300],
                                borderRadius: BorderRadius.circular(5.0),
                              ),
                              child: Text(
                                AppLocalizations.of(context)
                                    .translate('myAccountPage', 'closeString'),
                                style: TextStyle(
                                  fontWeight: FontWeight.w700,
                                ),
                              ),
                            ),
                          ),
                          InkWell(
                            onTap: () {
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                    builder: (context) => OTPLoginPage()),
                              );
                            },
                            child: Container(
                              width: (width / 3.5),
                              alignment: Alignment.center,
                              padding: EdgeInsets.all(10.0),
                              decoration: BoxDecoration(
                                color: Theme.of(context).primaryColor,
                                borderRadius: BorderRadius.circular(5.0),
                              ),
                              child: Text(
                                AppLocalizations.of(context)
                                    .translate('myAccountPage', 'logoutString'),
                                style: TextStyle(
                                  fontWeight: FontWeight.w700,
                                  color: Theme.of(context)
                                      .appBarTheme
                                      .backgroundColor,
                                ),
                              ),
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              ],
            ),
          );
        },
      );
    }
    // Logout AlertDialog Ends Here

    return Scaffold(
      appBar: AppBar(
        title: Text(
          AppLocalizations.of(context)
              .translate('accountSettingPage', 'accSettingAppBarTitleString'),
          style: TextStyle(
            fontFamily: 'Jost',
            fontWeight: FontWeight.bold,
            fontSize: 18.0,
            letterSpacing: 1.7,
          ),
        ),
        titleSpacing: 0.0,
      ),
      body: ListView(
        shrinkWrap: true,
        children: <Widget>[
          Container(
            margin: EdgeInsets.only(top: 5.0),
            color: Theme.of(context).appBarTheme.backgroundColor,
            padding: EdgeInsets.all(20.0),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                Text(
                  AppLocalizations.of(context)
                      .translate('accountSettingPage', 'accountString'),
                  style: TextStyle(
                    fontSize: 22.0,
                    fontWeight: FontWeight.bold,
                    color: Theme.of(context).textTheme.headline6?.color,
                  ),
                ),
                getListTile(AppLocalizations.of(context)
                    .translate('accountSettingPage', 'addressString')),
                getDivider(),
                getListTile(AppLocalizations.of(context)
                    .translate('accountSettingPage', 'telephoneString')),
                getDivider(),
                getListTile(AppLocalizations.of(context)
                    .translate('accountSettingPage', 'emailString')),
                getDivider(),
              ],
            ),
          ),
          Container(
            margin: EdgeInsets.only(top: 5.0),
            color: Theme.of(context).appBarTheme.backgroundColor,
            padding: EdgeInsets.all(20.0),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                Text(
                  AppLocalizations.of(context)
                      .translate('accountSettingPage', 'settingString'),
                  style: TextStyle(
                    fontSize: 22.0,
                    fontWeight: FontWeight.bold,
                    color: Theme.of(context).textTheme.headline6?.color,
                  ),
                ),
                getListTile(AppLocalizations.of(context).translate(
                    'accountSettingPage', 'orderNotificationsString')),
                getDivider(),
                getListTile(AppLocalizations.of(context).translate(
                    'accountSettingPage', 'discountNotificationsString')),
                getDivider(),
                getListTile(AppLocalizations.of(context)
                    .translate('accountSettingPage', 'creditCardString')),
                getDivider(),
              ],
            ),
          ),
          InkWell(
            onTap: () {
              logoutDialogue();
            },
            child: Container(
              margin: EdgeInsets.only(top: 5.0, bottom: 5.0),
              color: Theme.of(context).appBarTheme.backgroundColor,
              padding: EdgeInsets.all(20.0),
              child: Text(
                AppLocalizations.of(context)
                    .translate('myAccountPage', 'logoutString'),
                style: TextStyle(
                  fontSize: 22.0,
                  fontWeight: FontWeight.bold,
                  color: Theme.of(context).textTheme.headline6?.color,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
