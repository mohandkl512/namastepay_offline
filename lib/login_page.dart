import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:ussd_npay/routes/route_path.dart';
import 'package:ussd_npay/utils/debug_print.dart';
import 'package:ussd_npay/viewmodels/verification_cubit.dart';
import 'package:ussd_npay/viewmodels/states/verification_state.dart';
import 'utils/field_validator.dart';
import 'utils/loading_dialog.dart';
import 'widgets/custom_text_form_field.dart';
import 'widgets/decorated_container.dart';

class LoginPage extends StatefulWidget {
  const LoginPage({super.key});

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  final _formData = GlobalKey<FormState>();

  bool isLoading = false;
  bool visiblePin = false;
  final TextEditingController _msisdnController = TextEditingController();
  final TextEditingController _pinController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    final width = MediaQuery.of(context).size.width;
    final height = MediaQuery.of(context).size.height;

    if (isLoading) {
      return const Scaffold(
        body: Center(child: CircularProgressIndicator()),
      );
    }
    return BlocProvider(
      create: (context) => VerificationCubit(),
      child: Scaffold(
        backgroundColor: Colors.white,
        body: SingleChildScrollView(
          child: Form(
            key: _formData,
            child: SizedBox(
              height: height, // Ensure the container takes full height
              child: Column(
                children: [
                  SizedBox(height: height * 0.025),
                  Expanded(
                    child: SizedBox(
                      width: width,
                      child: Image.asset(
                        'assets/images/logo.png',
                        fit: BoxFit.contain,
                      ),
                    ),
                  ),
                  Expanded(
                    flex: 3,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const Row(
                          children: [
                            Expanded(
                              child: Text(
                                "Welcome to Namaste Pay \n(OFFLINE)",
                                textAlign: TextAlign.center,
                                style: TextStyle(
                                    fontWeight: FontWeight.w600, fontSize: 20),
                              ),
                            ),
                          ],
                        ),
                        DecoratedContainer(
                          widget: Column(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              const Padding(
                                padding: EdgeInsets.only(bottom: 8),
                                child: Text(
                                  "Enter your details to login",
                                  textAlign: TextAlign.left,
                                ),
                              ),
                              CustomTextFormField(
                                controller: _msisdnController,
                                labelText: "Mobile Number",
                                fillColor:
                                    const Color.fromARGB(255, 255, 255, 255),
                                filled: true,
                                borderDecoration: const OutlineInputBorder(
                                  borderRadius:
                                      BorderRadius.all(Radius.circular(8)),
                                ),
                                validator: Validator.validatePhoneNumber,
                              ),
                              SizedBox(height: height * 0.018),
                              Stack(
                                children: [
                                  CustomTextFormField(
                                    controller: _pinController,
                                    hintText: 'XXXX',
                                    labelText: "Pin",
                                    textInputType: TextInputType.number,
                                    fillColor: const Color.fromARGB(
                                      255,
                                      255,
                                      255,
                                      255,
                                    ),
                                    filled: true,
                                    borderDecoration: const OutlineInputBorder(
                                      borderRadius:
                                          BorderRadius.all(Radius.circular(8)),
                                    ),
                                    validator: Validator.validatePin,
                                    maxLength: 4,
                                  ),
                                  Positioned(
                                    right: 10,
                                    top: 4,
                                    child: IconButton(
                                      onPressed: () {
                                        setState(
                                          () => visiblePin = !visiblePin,
                                        );
                                      },
                                      icon: Icon(
                                        visiblePin
                                            ? CupertinoIcons.eye
                                            : CupertinoIcons.eye_slash_fill,
                                      ),
                                    ),
                                  )
                                ],
                              ),
                              Padding(
                                padding: const EdgeInsets.symmetric(
                                    vertical: 30, horizontal: 20),
                                child: Row(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  mainAxisSize: MainAxisSize.max,
                                  children: [
                                    Expanded(
                                      child: BlocConsumer<VerificationCubit,
                                          VerificationState>(
                                        listener: (BuildContext context,
                                            VerificationState state) {
                                          dPrint("builder called $state");
                                          if (state is Verified) {
                                            Navigator.pop(context);
                                            Navigator.pushNamedAndRemoveUntil(
                                              context,
                                              RoutesName.home,
                                              (_) => false,
                                            );
                                          } else if (state
                                              is VerificationError) {
                                            WidgetsBinding.instance
                                                .addPostFrameCallback((_) {
                                              Navigator.of(context).pop();
                                              ScaffoldMessenger.of(context)
                                                  .showSnackBar(
                                                SnackBar(
                                                  content: Text(state.message),
                                                  backgroundColor:
                                                      Colors.red[400],
                                                  duration: const Duration(
                                                    seconds: 2,
                                                  ),
                                                ),
                                              );
                                            });
                                          } else if (state is Verifying) {
                                            dPrint("loading dialog");
                                            showLoadingDialog(context);
                                          }
                                        },
                                        builder: (BuildContext context,
                                            VerificationState state) {
                                          return ElevatedButton(
                                            onPressed: () async {
                                              final bool validated = _formData
                                                      .currentState
                                                      ?.validate() ??
                                                  false;
                                              if (validated) {
                                                context
                                                    .read<VerificationCubit>()
                                                    .validateAndSendUSSD(
                                                      _msisdnController.text,
                                                      _pinController.text,
                                                    );
                                              }
                                            },
                                            child: const Text("Login"),
                                          );
                                        },
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
