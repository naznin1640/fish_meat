import 'package:fish_meat/core/constants/colors.dart';
import 'package:fish_meat/features/auth/providers/otp_notifier.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class OtpView extends ConsumerStatefulWidget {
  const OtpView({super.key});

  @override
  ConsumerState<OtpView> createState() => _OtpViewState();
}

class _OtpViewState extends ConsumerState<OtpView> {
  @override
  Widget build(BuildContext context) {
    final state = ref.watch(otpProvider);
    final pro = ref.read(otpProvider.notifier);

    return Scaffold(
      backgroundColor: blueClr,
      body: state.isLoading
          ? Center(child: CircularProgressIndicator())
          : Padding(
              padding: const EdgeInsets.all(8.0),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Text(
                    "Enter the otp sent to your phone",
                    style: TextStyle(color: Colors.white, fontSize: 16),
                  ),
                  Padding(
                    padding: const EdgeInsets.all(10),
                    child: TextFormField(
                      controller: state.otpController,
                      decoration: InputDecoration(
                        hintText: "Enter the 6 digit otp",
                        filled: true,
                        fillColor: Colors.white,
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(8),
                        ),
                      ),
                    ),
                  ),

                  Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: InkWell(
                      onTap: () async{
                        if(state.otpController.text.length < 6){
                          return;
                        }
                        final success = await pro.verifyOtp();
                        if(success && context.mounted){
                           Navigator.pushReplacementNamed(context, '/createaccount');
                        }
                      },
                      child: Container(
                        height: 48,
                        width: 250,
                        decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(8),
                        ),
                        child: Center(
                          child: Text(
                            "Verify Otp",
                            style: TextStyle(
                              color: blueClr,
                              fontWeight: FontWeight.w400,
                            ),
                          ),
                        ),
                      ),
                    ),
                  ),
                  TextButton(onPressed: () async{
                    await pro.sendOtp();
                  }, child: Text(
                    "Resend OTP",
                    style:  TextStyle(color:  Colors.white),
                  ))
                ],
              ),
            ),
    );
  }
}
