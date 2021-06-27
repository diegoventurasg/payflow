import 'package:flutter/material.dart';
import 'package:payflow/modules/login/login_controller.dart';
import 'package:payflow/shared/themes/app_colors.dart';
import 'package:payflow/shared/themes/app_images.dart';
import 'package:payflow/shared/themes/app_text_styles.dart';
import 'package:payflow/shared/widgets/social_login/social_login_button.dart';

class LoginPage extends StatefulWidget {
  const LoginPage({Key? key}) : super(key: key);

  @override
  _LoginPageState createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  final controller = LoginController();
  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    return Scaffold(
      backgroundColor: AppColors.background,
      body: Container(
        width: size.width,
        height: size.height,
        child: Stack(
          children: [
            Container(
              width: size.width,
              height: size.height * 0.36,
              color: AppColors.primary,
            ),
            Positioned(
              top: size.height * 0.0455,
              left: 0,
              right: 0,
              child: Image.asset(
                AppImages.person,
                width: size.width * 0.554,
                height: size.height * 0.459,
              ),
            ),
            Positioned(
              top: size.height * 0.39,
              left: 0,
              right: 0,
              child: Container(
                height: size.height * 0.1145,
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    begin: FractionalOffset.topCenter,
                    end: FractionalOffset.bottomCenter,
                    colors: [
                      Colors.white.withOpacity(0),
                      Colors.white.withOpacity(0.6),
                      Colors.white.withOpacity(0.943),
                      Colors.white
                    ],
                  ),
                ),
              ),
            ),
            Positioned(
                right: size.width * 0.215,
                top: size.height * 0.225,
                child: Container(
                  decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(5),
                      boxShadow: [
                        BoxShadow(
                            color: AppColors.secondary,
                            spreadRadius: 10,
                            blurRadius: 0,
                            offset: Offset(0, 0)),
                      ]),
                  child: Center(
                    child: Icon(
                      Icons.description_outlined,
                      color: AppColors.stroke,
                    ),
                  ),
                )),
            Positioned(
                left: size.width * 0.215,
                top: size.height * 0.32,
                child: Container(
                  decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(5),
                      boxShadow: [
                        BoxShadow(
                            color: AppColors.secondary,
                            spreadRadius: 10,
                            blurRadius: 0,
                            offset: Offset(0, 0)),
                      ]),
                  child: Center(
                    child: Icon(
                      Icons.add_box_outlined,
                      color: AppColors.stroke,
                    ),
                  ),
                )),
            Positioned(
              bottom: size.height * 0.07,
              left: 0,
              right: 0,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Image.asset(AppImages.logomini),
                  Padding(
                    padding:
                        const EdgeInsets.only(top: 30, left: 70, right: 70),
                    child: Text(
                      'Organize seus boletos em um só lugar',
                      textAlign: TextAlign.center,
                      style: AppTextStyles.titleHome,
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.only(
                      left: 40,
                      right: 40,
                      top: 40,
                    ),
                    child: SocialLoginButton(onTap: () {
                      controller.googleSignIn(context);
                    }),
                  ),
                ],
              ),
            )
          ],
        ),
      ),
    );
  }
}
