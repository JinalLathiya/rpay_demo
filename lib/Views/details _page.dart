import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:razorpay_flutter/razorpay_flutter.dart';

class DetailsPage extends StatefulWidget {
  const DetailsPage({Key? key}) : super(key: key);

  @override
  State<DetailsPage> createState() => _DetailsPageState();
}

class _DetailsPageState extends State<DetailsPage> {
  late Razorpay razorpay;

  @override
  void initState() {
    super.initState();
    razorpay = Razorpay();
    razorpay.on(Razorpay.EVENT_PAYMENT_SUCCESS, handlePaymentSuccess);
    razorpay.on(Razorpay.EVENT_PAYMENT_ERROR, handlePaymentError);
    razorpay.on(Razorpay.EVENT_EXTERNAL_WALLET, handleExternalWallet);
  }

  @override
  Widget build(BuildContext context) {
    dynamic args = ModalRoute.of(context)!.settings.arguments;
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        leading: Padding(
          padding: const EdgeInsets.only(left: 20),
          child: IconButton(
            onPressed: () {
              setState(() {
                args.id = 1;
                Navigator.of(context).pushNamed("/");
              });
            },
            icon: const Icon(
              Icons.arrow_back_ios,
              color: Colors.black,
              size: 35,
            ),
          ),
        ),
      ),
      body: Column(
        children: [
          Expanded(
            flex: 2,
            child: Container(
              height: 200,
              width: double.infinity,
              padding: const EdgeInsets.all(30),
              alignment: Alignment.center,
              color: Colors.white,
              child: Container(
                alignment: Alignment.center,
                height: 250,
                width: 350,
                decoration: BoxDecoration(
                  color: Colors.white,
                  image: DecorationImage(
                    image: NetworkImage("${args.image}"),
                  ),
                ),
              ),
            ),
          ),
          Expanded(
            flex: 4,
            child: Container(
              height: 400,
              width: double.infinity,
              decoration: BoxDecoration(
                borderRadius: const BorderRadius.only(
                  topLeft: Radius.circular(20.0),
                  topRight: Radius.circular(20.0),
                ),
                color: Colors.grey.withOpacity(0.3),
              ),
              child: Column(
                children: [
                  const SizedBox(
                    height: 40,
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceAround,
                    children: [
                      Text(
                        "${args.name}",
                        style: const TextStyle(
                          fontSize: 40,
                          color: Colors.white,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                      Container(
                        height: 40,
                        width: 40,
                        decoration: BoxDecoration(
                          shape: BoxShape.circle,
                          color: Colors.white.withOpacity(0.2),
                        ),
                        child: (args.like)
                            ? const Icon(
                                Icons.favorite,
                                color: Colors.white,
                              )
                            : const Icon(
                                Icons.favorite_border_outlined,
                                color: Colors.white,
                              ),
                      )
                    ],
                  ),
                  const SizedBox(
                    height: 20,
                  ),
                  Container(
                    alignment: Alignment.topLeft,
                    padding: const EdgeInsets.only(left: 60),
                    child: Text(
                      "₹ ${args.id * args.price}",
                      style: const TextStyle(
                        fontSize: 26,
                        color: Colors.white,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ),
                  const SizedBox(
                    height: 30,
                  ),
                  Padding(
                    padding: const EdgeInsets.only(left: 20, right: 20),
                    child: Text(
                      "${args.info}",
                      style: TextStyle(
                        fontSize: 20,
                        wordSpacing: 2,
                        fontWeight: FontWeight.w500,
                        color: Colors.white.withOpacity(0.6),
                      ),
                    ),
                  ),
                  const SizedBox(
                    height: 30,
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.end,
                    children: [
                      Container(),
                      Padding(
                        padding: const EdgeInsets.only(right: 20),
                        child: FloatingActionButton.extended(
                          onPressed: () {
                            paymentMethod(args);
                          },
                          label: const Text("BUY NOW"),
                        ),
                      )
                    ],
                  )
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  void paymentMethod(dynamic e) async {
    var options = {
      'key': 'rzp_test_IqAe6xhOpRABuJ',
      'amount': "${e.price * 100}",
      // 'amount': "${e.price}",
      'name': "${e.name}",
      'description': "${e.info}",
      'retry': {'enabled': true, 'max_count': 1},
      'send_sms_hash': true,
      'prefill': {
        'contact': '8469254295',
        'email': 'jinallathiya3198@gmail.com'
      },

    };

    try {
      razorpay.open(options);
    } catch (e) {
      print('Error: e');
    }
  }

  void handlePaymentSuccess(PaymentSuccessResponse response) {
    print('Success Response: $response');
    Navigator.of(context).pushNamed("detail_page");
  }

  void handlePaymentError(PaymentFailureResponse response) {
    print('Error Response: $response');
    Fluttertoast.showToast(
        timeInSecForIosWeb: 10,
        msg: "ERROR: ${response.code} - ${response.message!}",
        toastLength: Toast.LENGTH_SHORT);
  }

  void handleExternalWallet(ExternalWalletResponse response) {
    print('External SDK Response: $response');
    Fluttertoast.showToast(
        timeInSecForIosWeb: 10,
        msg: "EXTERNAL_WALLET: ${response.walletName!}",
        toastLength: Toast.LENGTH_SHORT);
  }

  @override
  void dispose() {
    super.dispose();
    razorpay.clear();
  }
}
