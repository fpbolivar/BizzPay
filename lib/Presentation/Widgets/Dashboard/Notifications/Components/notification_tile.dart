import 'package:buysellbiz/Data/DataSource/Resources/imports.dart';
import 'package:buysellbiz/Presentation/Widgets/Dashboard/Chat/Components/ChatModel/chat_tile_model.dart';
import 'package:buysellbiz/Presentation/Widgets/Dashboard/Notifications/Components/notification_model.dart';

class ChatTile extends StatelessWidget {
  const ChatTile({super.key, this.data});

  final NotificationsModel? data;

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: () {
        // Navigate.to(
        //     context,
        //     ChatDetailsScreen(
        //       model: data,
        //     ));
      },
      child: Container(
        padding: EdgeInsets.all(13.sp),
        decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(10.sp),
            color: AppColors.whiteColor,
            border: Border.all(color: AppColors.borderColor)),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            AssetImageWidget(
                height: 50.h, width: 50.w, url: data!.pr0fileImage),
            15.x,
            Expanded(
              flex: 10,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      AppText(data?.title ?? "",
                          style: Styles.circularStdBold(context,
                              fontSize: 18.sp, fontWeight: FontWeight.w500)),
                      const Spacer(),
                      AppText(data!.time,
                          style: Styles.circularStdRegular(context,
                              fontSize: 12.sp,
                              fontWeight: FontWeight.w400,
                              color: AppColors.greyTextColor)),
                    ],
                  ),
                  5.y,
                  AppText(data!.subtitle,
                      maxLine: 1,
                      style: Styles.circularStdRegular(context,
                          fontSize: 14.sp,
                          fontWeight: FontWeight.w400,
                          color: AppColors.greyTextColor)),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
