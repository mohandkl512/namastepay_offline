import 'package:flutter/material.dart';
import 'package:ussd_npay/utils/tv_data.dart';
import 'package:ussd_npay/widgets/tv_dropdown.dart';

class TvPaymentPage extends StatefulWidget {
  const TvPaymentPage({super.key});

  @override
  _TvPaymentPageState createState() => _TvPaymentPageState();
}

class _TvPaymentPageState extends State<TvPaymentPage> {
  String? selectedTv;
  String? selectedOption;
  bool _isFormValid = false;
  final TextEditingController _controller = TextEditingController();
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("TV Recharge")),
      body: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const SizedBox(height: 8),
            CustomDropDown(
              onChanged: (value) {
                setState(() {
                  selectedTv = value;
                });
              },
              items: TvData.tvs,
              selectedValue: selectedTv,
            ),
            const SizedBox(height: 16),
            CustomDropDown(
              onChanged: (value) {
                setState(() {
                  selectedOption = value;
                });
              },
              items: TvData.dishTVPaymentOptions,
              selectedValue: selectedOption,
            ),
            const SizedBox(height: 16),
            TextField(
              controller: _controller,
              keyboardType: TextInputType.number,
              decoration: InputDecoration(
                labelText: 'Customer ID',
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
              ),
            ),
            Center(
              child: ElevatedButton(
                onPressed: () {},
                style: ElevatedButton.styleFrom(
                  shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(10)),
                  backgroundColor: _isFormValid ? Colors.blue : Colors.grey,
                ),
                child: const Text("Recharge"),
              ),
            )
          ],
        ),
      ),
    );
  }
}
