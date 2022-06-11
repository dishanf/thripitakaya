import 'package:flutter/material.dart';
import 'package:stacked/stacked.dart';
import 'package:tipitaka/splash_viewmodel.dart';

class SplashView extends StatelessWidget {
  const SplashView({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ViewModelBuilder<SplashViewModel>.reactive(
      onModelReady: (model) => model.handleStartUpLogic(),
      builder: (context, model, child) => Scaffold(
        backgroundColor: Colors.white,
        body: Center(
          child: Image.asset(
            'assets/lotus.jpg',
            fit: BoxFit.cover,
            //height: 80,
            //width: double.infinity,
            alignment: Alignment.center,
          ),
        ),
      ),
      viewModelBuilder: () => SplashViewModel(),
    );
  }
}
