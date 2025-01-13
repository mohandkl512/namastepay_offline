import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:ussd_npay/routes/route_path.dart';
import 'package:ussd_npay/utils.dart';
import 'package:ussd_npay/utils/field_validator.dart';
import 'package:ussd_npay/utils/loading_dialog.dart';
import 'package:ussd_npay/utils/operators.dart';
import 'package:ussd_npay/viewmodels/recharge_cubit.dart';
import 'package:ussd_npay/viewmodels/states/recharge_state.dart';
import '../utils/error_dialog.dart';

class RechargeScreen extends StatefulWidget {
  const RechargeScreen({super.key});

  @override
  _RechargeScreenState createState() => _RechargeScreenState();
}

class _RechargeScreenState extends State<RechargeScreen> {
  final TextEditingController _phoneController = TextEditingController();
  final TextEditingController _amountController = TextEditingController();
  final _formKey = GlobalKey<FormState>();
  String? _selectedOperator;
  bool _isFormValid = false;

  // List of available network operators
  final List<String> operators = [MNO.nt, MNO.ncell];
  @override
  void initState() {
    super.initState();
    _phoneController.addListener(_validateForm);
  }

  void _validateForm() {
    setState(() {
      _isFormValid =
          Validator.validatePhoneNumber(_phoneController.text) == null &&
              _selectedOperator != null &&
              Validator.amountValidator(_amountController.text) == null;
    });
  }

  void _processRecharge(String? pin) async {
    if (pin != null) {
      if (Utils.isPinValid(pin)) {
        if (mounted) {
          final homeCubit = context.read<RechargeCubit>();
          if (Utils.checkNumberPrefix(_phoneController.text) == MNO.nt) {
            await homeCubit.rechargeNamaste(
                pin, int.parse(_amountController.text), _phoneController.text);
          } else if (_selectedOperator == MNO.ncell) {
            await homeCubit.rechargeNcell(
                pin, int.parse(_amountController.text), _phoneController.text);
          }
        }
      }
    } else {
      if (mounted) {
        final homeCubit = context.read<RechargeCubit>();
        if (Utils.checkNumberPrefix(_phoneController.text) == MNO.nt) {
          await homeCubit.rechargeNamaste(
              "pin", int.parse(_amountController.text), _phoneController.text);
        } else if (_selectedOperator == MNO.ncell) {
          await homeCubit.rechargeNcell(
              "pin", int.parse(_amountController.text), _phoneController.text);
        }
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Recharge")),
      body: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Form(
          key: _formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const SizedBox(height: 8),
              TextFormField(
                controller: _phoneController,
                keyboardType: TextInputType.phone,
                maxLength: 10,
                onChanged: (value) {
                  if (value.length == 10) {
                    setState(() {
                      _selectedOperator = Utils.checkNumberPrefix(value);
                    });
                  }
                },
                decoration: InputDecoration(
                  labelText: "Phone Number",
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(10),
                  ),
                ),
              ),

              _selectedOperator == null && _phoneController.text.length < 10
                  ? const SizedBox()
                  : ChoiceChip(
                      label: Text(
                        _selectedOperator!,
                        style: const TextStyle(color: Colors.white,fontWeight: FontWeight.bold),
                      ),
                      selected: true,
                      selectedColor: _selectedOperator == MNO.ncell
                          ? Colors.purple
                          : Colors.blue,
                    ),

              const SizedBox(height: 16),
              // const CustomNumberPad(),
              TextFormField(
                controller: _amountController,
                keyboardType: TextInputType.number,
                decoration: InputDecoration(
                  labelText: 'Amount',
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                ),
                validator: Validator.amountValidator,
                onChanged: (value) {
                  _validateForm();
                },
              ),
              const SizedBox(height: 32),
              BlocConsumer<RechargeCubit, RechargeState>(
                listener: (context, state) {
                  if (state is RechargeSelected) {
                    Navigator.pushNamedAndRemoveUntil(
                      context,
                      RoutesName.rechargeComplete,
                      (_) => false,
                    );
                  } else if (state is RechargeError) {
                    showErrorDialog(context, "Error Occured", state.message);
                    Navigator.pushNamedAndRemoveUntil(
                      context,
                      RoutesName.rechargeComplete,
                      (_) => false,
                    );
                  } else if (state is Recharging) {
                    showLoadingDialog(context);
                  }
                },
                builder: (BuildContext context, RechargeState state) {
                  return Center(
                    child: ElevatedButton(
                      onPressed: () {
                        if (_isFormValid) {
                          if (int.parse(_amountController.text) > 0) {
                            _processRecharge(null);
                          } else {
                            ScaffoldMessenger.of(context).showSnackBar(
                              SnackBar(
                                content: const Text("Enter Valid Amount"),
                                backgroundColor: Colors.red[400],
                                duration: const Duration(
                                  seconds: 3,
                                ),
                              ),
                            );
                          }
                        }
                      },
                      style: ElevatedButton.styleFrom(
                        shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(10)),
                        backgroundColor:
                            _isFormValid ? Colors.blue : Colors.grey,
                      ),
                      child: const Text("Recharge"),
                    ),
                  );
                },
              ),
            ],
          ),
        ),
      ),
    );
  }

  void _showPinDialog() {
    TextEditingController pinController = TextEditingController();
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
        title: const Text("Enter PIN"),
        content: TextField(
          controller: pinController,
          keyboardType: TextInputType.number,
          obscureText: true,
          decoration: InputDecoration(
            border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
          ),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text("Cancel"),
          ),
          ElevatedButton(
            onPressed: () {
              bool validPin = Utils.isPinValid(pinController.text);
              if (validPin) {
                _processRecharge(pinController.text);
              } else {
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(
                    content: const Text("Invalid Pin"),
                    backgroundColor: Colors.red[400],
                    duration: const Duration(
                      seconds: 2,
                    ),
                  ),
                );
              }
            },
            style: ElevatedButton.styleFrom(
                shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(10))),
            child: const Text("Proceed"),
          ),
        ],
      ),
    );
  }
}
