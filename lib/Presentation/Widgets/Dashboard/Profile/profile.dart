import 'package:buysellbiz/Application/Services/Navigation/navigation.dart';
import 'package:buysellbiz/Data/DataSource/Resources/imports.dart';
import 'package:buysellbiz/Presentation/Common/app_buttons.dart';
import 'package:buysellbiz/Presentation/Common/dialog.dart';
import 'package:buysellbiz/Presentation/Widgets/Dashboard/Profile/Components/custom_list_tile.dart';
import 'package:buysellbiz/Presentation/Widgets/Dashboard/Profile/Components/logout_dialog.dart';
import 'package:buysellbiz/Presentation/Widgets/Dashboard/Profile/change_password.dart';
import 'package:buysellbiz/Presentation/Widgets/Dashboard/Profile/customer_support.dart';
import 'package:buysellbiz/Presentation/Widgets/Dashboard/Profile/personal_information.dart';
import 'package:buysellbiz/Presentation/Widgets/Dashboard/Profile/privacy_policy.dart';
import 'package:buysellbiz/Presentation/Widgets/Dashboard/Profile/terms_and_conditions.dart';
import 'package:buysellbiz/Presentation/Widgets/Dashboard/Profile/your_business.dart';
import 'package:share_plus/share_plus.dart';

class ProfileScreen extends StatelessWidget {
  const ProfileScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: SingleChildScrollView(
        physics: const BouncingScrollPhysics(),
        child: Padding(
          padding: EdgeInsets.symmetric(horizontal: 10.sp),
          child: Column(
            children: [
              40.y,
              AssetImageWidget(
                url: Assets.dummyImage2,
                radius: 60.r,
                isCircle: true,
              ),
              Column(
                children: [
                  10.y,
                  Text(
                    AppStrings.gabriel,
                    style: Styles.circularStdBold(context, fontSize: 20.sp),
                  ),
                  20.y,
                  Column(
                    children: [
                      GestureDetector(
                        onTap: () {
                          Navigate.to(context, PersonalInformation());
                        },
                        child: const CustomListTile(
                          title: AppStrings.personalLinfo,
                          leadingicon: Assets.profile,
                          trailing: Assets.down,
                        ),
                      ),
                      GestureDetector(
                        onTap: () {
                          Navigate.to(context, ChangePassword());
                        },
                        child: const CustomListTile(
                          title: AppStrings.ChangePass,
                          leadingicon: Assets.unlock,
                          trailing: Assets.down,
                        ),
                      ),
                      GestureDetector(
                        onTap: () {
                          Navigate.to(context, YourBusiness());
                        },
                        child: const CustomListTile(
                          title: AppStrings.listYourbis,
                          leadingicon: Assets.plus,
                          trailing: Assets.down,
                        ),
                      ),
                      GestureDetector(
                        onTap: () async {
                          const url =
                              'https://wa.me/?text=Check out my awesome Flutter app!';
                          final encoded = Uri.encodeFull(url);
                          await Share.share(encoded);
                        },
                        child: const CustomListTile(
                          title: AppStrings.referAfri,
                          leadingicon: Assets.share,
                          trailing: Assets.down,
                        ),
                      ),
                      GestureDetector(
                        onTap: () {
                          Navigate.to(context, PrivacyPolicy());
                        },
                        child: const CustomListTile(
                          title: AppStrings.privacyPol,
                          leadingicon: Assets.document,
                          trailing: Assets.down,
                        ),
                      ),
                      GestureDetector(
                        onTap: () {
                          Navigate.to(context, TermsAndConditions());
                        },
                        child: const CustomListTile(
                          title: AppStrings.termsAndcon,
                          leadingicon: Assets.paper,
                          trailing: Assets.down,
                        ),
                      ),
                      GestureDetector(
                        onTap: () {
                          Navigate.to(context, const CustomerSupport());
                        },
                        child: const CustomListTile(
                          title: AppStrings.helpAandupp,
                          leadingicon: Assets.alert,
                          trailing: Assets.down,
                        ),
                      ),
                    ],
                  ),
                ],
              ),
              50.y,
              CustomButton(
                gapWidth: 7.w,
                imageHeight: 20.h,
                imageWidth: 20.w,
                leadingIcon: Assets.logout,
                leadingSvgIcon: true,
                width: 230.w,
                borderRadius: 40.r,
                onTap: () {
                  CustomDialog.dialog(
                      barrierDismissible: true, context, const LogoutDialog());
                },
                text: AppStrings.logout,
                bgColor: AppColors.whiteColor,
                textFontWeight: FontWeight.w700,
                textSize: 16.sp,
                textColor: AppColors.greyMedium,
              ),
              20.y,
              AppText('Version 1.1.02',
                  style: Styles.circularStdRegular(context,
                      fontSize: 12.sp, color: AppColors.greyColor)),
              30.y,
            ],
          ),
        ),
      ),
    );
  }
}
