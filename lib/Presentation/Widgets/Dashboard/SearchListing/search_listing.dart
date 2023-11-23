import 'package:buysellbiz/Application/Services/Navigation/navigation.dart';
import 'package:buysellbiz/Data/DataSource/Resources/Extensions/extensions.dart';
import 'package:buysellbiz/Data/DataSource/Resources/imports.dart';
import 'package:buysellbiz/Domain/BusinessModel/buisiness_model.dart';
import 'package:buysellbiz/Presentation/Common/custom_dropdown.dart';
import 'package:buysellbiz/Presentation/Common/widget_functions.dart';
import 'package:buysellbiz/Presentation/Widgets/Dashboard/BottomNavigation/Controller/BottomNavigationNotifier/bottom_navigation_notifier.dart';
import 'package:buysellbiz/Presentation/Widgets/Dashboard/Buisness/BuisnessDetails/buisness_details.dart';
import 'package:buysellbiz/Presentation/Widgets/Dashboard/Chat/chat.dart';

import 'Components/search_business_widget.dart';

class SearchListing extends StatelessWidget {
  final String title;
   SearchListing({super.key, required this.title});
final List<String> countryList =["USA","China","PAK"];
  final List<String> priceList =["0-1000\$",'1000-100000 \$',"100000-1000000\$"];
  final List<String> categoryList =["Food","RealState","Maufacture","Online"];
  final List<String> revenueList =["10k","20k","30k"];
  List<BusinessProductModel>  businessProducts1 =[
    BusinessProductModel(businessImage: Assets.dummyImage2,businessName: 'Drop shipping website & E-commerce business',
        isFav:false,
        price: 'USD 40K',location: "San Francisco, USA"),
    BusinessProductModel(businessImage: Assets.dummyImage2,
        isFav: true,
        businessName: 'Drop shipping website & E-commerce business ',price: 'USD 30K',location: "San Francisco, USA"),
    BusinessProductModel(businessImage: Assets.dummyImage2,
        isFav: true,
        businessName:

        'Drop shipping website & E-commerce business',price: 'USD 20K',location: "San Francisco, USA"),
    BusinessProductModel(businessImage: Assets.dummyImage2,
        isFav: false,
        businessName: 'Drop shipping website & E-commerce business',price: 'USD 10K',location: "San Francisco, USA"),

  ];
  @override
  Widget build(BuildContext context) {
    return  Scaffold(


      appBar: AppBar(leading: GestureDetector(

        onTap: (){
          Navigate.pop(context);
        },
        child:   Container(
          margin: const EdgeInsets.only(left: 10),
          child:   SvgPicture.asset(Assets.arrowBackIcon,width: 10.sp,height:
          10.sp,
            fit: BoxFit.fitWidth
            ,

          ),
        ),
      ),leadingWidth: 40.sp,
        elevation: 0,
        automaticallyImplyLeading: false,
        title: AppText(title, style: Styles.circularStdRegular(context,fontWeight: FontWeight.w700,fontSize:
        18.sp),),

        centerTitle: true,
        backgroundColor: AppColors.whiteColor,
      ),
body: Padding(
  padding: const EdgeInsets.symmetric(horizontal: 20.0),
  child:   Column(
    crossAxisAlignment: CrossAxisAlignment.start,

    children: [

      ///top Categories $ filters
      ///
    //  ListView.separated(itemBuilder: (), separatorBuilder: separatorBuilder, itemCount: itemCount)
10.y,
      SingleChildScrollView(
        scrollDirection: Axis.horizontal,
        physics: const BouncingScrollPhysics(),
        child: Row(children: [
             // 10.x,
          WidgetFunctions.instance.dropDown(context, values:countryList, titles: countryList,placeholder: "USA",onChange: (c){},width:100)

       ,  10.x
          ,WidgetFunctions.instance.dropDown(context, values: categoryList, titles: categoryList,placeholder: "Categories",onChange: (c){},width:120)
          ,10.x
          , WidgetFunctions.instance.dropDown(context, values: priceList, titles: priceList,placeholder: "Price",onChange: (c){},width:100)
          ,10.x
          ,      WidgetFunctions.instance.dropDown(context, values:revenueList, titles: revenueList,placeholder: "Revenue",onChange: (c){},width:100)
          ,10.x


        ],),
      ),
5.y,
      AppText("129 Business", style: Styles.circularStdMedium(context,fontSize: 16)),
      15.y,
      Expanded(child: SearchBusinessWidget(businessProducts: businessProducts1, getData: (BusinessProductModel val) {

        print(val.businessName);

        Navigate.to(context, const BusinessDetails());

      }, chatTap: (BusinessProductModel val) {
        //BottomNotifier.bottomPageController.removeListener(() { });
        // BottomNotifier.bottomPageController=PageController(initialPage: 2);
        // BottomNotifier.bottomNavigationNotifier.value=2;
        //
        // Navigate.toReplace(context, const BottomNavigationScreen(initialPage: 2,));

        Navigate.to(context, ChatScreen(backButton: true,));


      },))

    ],

  ),
),
    );
  }
}
