import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:ussd_npay/routes/route_path.dart';
import 'package:ussd_npay/viewmodels/states/tv_state.dart';
import 'package:ussd_npay/viewmodels/tv_cubit.dart';

class TvSucessPage extends StatelessWidget {
  const TvSucessPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("")),
      body: Center(
        child: BlocBuilder<TvCubit, TvState>(
          builder: (context, state) {
            return Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                state is TvRequestSucessfull
                    ? const Icon(Icons.check_circle,
                        color: Colors.green, size: 100)
                    : const Icon(Icons.warning, color: Colors.red, size: 100),
                const SizedBox(height: 8),
                state is TvRequestError
                    ? const Text(
                        "Action Halted!",
                        style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                        ),
                      )
                    : const Text(
                        "Action Sucessfull",
                        style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                const SizedBox(height: 8),
                state is TvRequestError
                    ? Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Text(
                          state.message,
                          textAlign: TextAlign.center,
                          style: const TextStyle(
                            fontSize: 16,
                          ),
                        ),
                      )
                    : state is TvRequestSucessfull
                        ? Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: Text(
                              " ${state.response}",
                              style: const TextStyle(
                                fontSize: 16,
                              ),
                            ),
                          )
                        : const SizedBox(),
                ElevatedButton(
                  onPressed: () =>
                      Navigator.pushReplacementNamed(context, RoutesName.home),
                  style: ElevatedButton.styleFrom(
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(10),
                    ),
                  ),
                  child: const Text("Proceed Forward"),
                ),
              ],
            );
          },
        ),
      ),
    );
  }
}
