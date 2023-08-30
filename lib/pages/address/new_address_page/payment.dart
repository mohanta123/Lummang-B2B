
import 'package:easy_stepper/easy_stepper.dart';
import 'package:flutter/material.dart';

class Payment_Screen extends StatefulWidget {
  const Payment_Screen({Key key}) : super(key: key);

  @override
  State<Payment_Screen> createState() => _Payment_ScreenState();
}

class _Payment_ScreenState extends State<Payment_Screen> {
  int activeStep = 0;

  int value = 0;
  final paymentlabels = ["Credit card", "Debit card", "UPI payment"];
  final paymenticon = [
    Icons.credit_card,
    Icons.payment,
    Icons.arrow_forward
  ];


  String selectedName;
  @override
  Widget build(BuildContext context) {
    double deviceHeight = MediaQuery.of(context).size.height;
    double deviceWidth = MediaQuery.of(context).size.width;
    return Scaffold(
      backgroundColor: Colors.grey.shade300,
      appBar: AppBar(
        backgroundColor: Colors.white,

        title: Text("Payment",style: TextStyle(color: Colors.black,
        fontSize: 18,fontWeight: FontWeight.bold),),
      ),
      body: Column(
        mainAxisAlignment: MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            color: Colors.white,
            child: EasyStepper(
              activeStep: activeStep,
              lineLength: 70,
              lineSpace: 0,
              lineType: LineType.normal,
              defaultLineColor: Colors.grey,
              finishedLineColor: Color(0xFF526FD8),
              activeStepTextColor: Colors.black87,
              finishedStepTextColor: Colors.black87,
              internalPadding: 0,
              showLoadingAnimation: false,
              stepRadius: 8,
              showStepBorder: false,
              lineDotRadius: 1.5,
              steps: [
                EasyStep(
                  customStep: CircleAvatar(
                    radius: 8,
                    backgroundColor: Colors.grey,
                    child: CircleAvatar(
                      radius: 7,
                      backgroundColor:
                      activeStep >= 0 ? Color(0xFF526FD8) : Colors.white,
                    ),
                  ),
                  title: 'Bag',
                ),
                EasyStep(
                  customStep: CircleAvatar(
                    radius: 8,
                    backgroundColor: Colors.grey,
                    child: CircleAvatar(
                      radius: 7,
                      backgroundColor:
                      activeStep >= 1 ? Color(0xFF526FD8): Colors.white,
                    ),
                  ),
                  //  title: 'Address',
                  topTitle: true,
                ),
                EasyStep(
                  customStep: CircleAvatar(
                    radius: 8,
                    backgroundColor: Colors.grey,
                    child: CircleAvatar(
                      radius: 7,
                      backgroundColor:
                      activeStep >= 2 ? Color(0xFF526FD8) : Colors.white,
                    ),
                  ),
                  title: 'Preparing',
                ),
                EasyStep(
                  customStep: CircleAvatar(
                    radius: 8,
                    backgroundColor: Colors.grey,
                    child: CircleAvatar(
                      radius: 7,
                      backgroundColor:
                      activeStep >= 3 ? Color(0xFF526FD8) : Colors.white,
                    ),
                  ),
                  //   title: 'On Way',
                  topTitle: true,
                ),
                EasyStep(
                  customStep: CircleAvatar(
                    radius: 8,
                    backgroundColor: Colors.grey,
                    child: CircleAvatar(
                      radius: 7,
                      backgroundColor:
                      activeStep >= 4 ?Color(0xFF526FD8) : Colors.white,
                    ),
                  ),
                  title: 'Payment',
                ),
              ],
              onStepReached: (index) => setState(() => activeStep = index),
            ),
          ),
          Container(
            height: deviceHeight*0.07,
            child: Padding(
              padding: const EdgeInsets.only(left: 10,top: 20),
              child: Text("RECOMMENDED PAYMENT OPTIONS",
              style: TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.bold,color: Colors.grey.shade700
              ),),
            ),
          ),
          Container(
            height: deviceHeight*0.3,
            color: Colors.white,
            child: ListView.separated(
                itemCount: paymentlabels.length,
                itemBuilder: (context, index) {
                  return ListTile(
                    leading: Radio(
                        activeColor: Color(0xFF526FD8),
                        value: index,
                        groupValue: value,
                        onChanged: (i) => setState(() => value = i)),
                    title: Text(paymentlabels[index]),
                    trailing: Icon(
                      paymenticon[index],
                      color: Color(0xFF526FD8),
                    ),
                  );

                },
                separatorBuilder: (context, index) {
                  return Divider(thickness: 1,);
                }
                ),
          ),




        ],
      ),
      bottomNavigationBar: Padding(
        padding: const EdgeInsets.all(5.0),
        child: InkWell(
          onTap: (){
            switch(value){
              case 0:
                // Navigator.push(
                //   context,
                //   MaterialPageRoute(builder: (context) => CreditCard()),
                // );
                break;
              case 1:
                // Navigator.push(
                //   context,
                //   MaterialPageRoute(builder: (context) => CreditCard()),
                // );
                break;
              case 2:
                // Navigator.push(
                //   context,
                //   MaterialPageRoute(builder: (context) => Upi_Payment()),
                // );
                break;


            }
          },
          child: Container(
            height:  deviceHeight*0.07,
            decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(5), color: Color(0xFF526FD8)),
            child: Center(
              child: Text("Pay",style: TextStyle(
                  color: Colors.white,fontSize: 20
              ),),
            ),
          ),
        ),
      ),
    );
  }
}
