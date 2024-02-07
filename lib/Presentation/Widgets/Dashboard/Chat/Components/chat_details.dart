import 'dart:convert';
import 'dart:io';
import 'package:buysellbiz/Application/Services/PickerServices/picker_services.dart';
import 'package:buysellbiz/Data/DataSource/Resources/api_constants.dart';
import 'package:buysellbiz/Data/DataSource/Resources/imports.dart';
import 'package:buysellbiz/Presentation/Common/display_images.dart';
import 'package:buysellbiz/Presentation/Widgets/Dashboard/Chat/Components/pop_munu.dart';
import 'package:buysellbiz/Presentation/Widgets/Dashboard/Chat/Controllers/Repo/inboox_repo.dart';
import 'package:buysellbiz/Presentation/Widgets/Dashboard/Chat/Controllers/inboxControllers.dart';
import 'package:buysellbiz/Presentation/Widgets/Dashboard/Chat/Controllers/inboxmodel.dart';
import 'package:file_picker/src/platform_file.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/scheduler.dart';
import 'package:grouped_list/grouped_list.dart';
import 'package:intl/intl.dart';

import 'package:path_provider/path_provider.dart';
import 'package:socket_io_client/socket_io_client.dart' as IO;

import 'package:video_thumbnail/video_thumbnail.dart';
import 'package:path/path.dart' as path;

import 'message_container.dart';

class ChatDetailsScreen extends StatefulWidget with ChangeNotifier {
  ChatDetailsScreen({super.key, this.chatDto});

  final ChatTileApiModel? chatDto;

  @override
  State<ChatDetailsScreen> createState() => _ChatDetailsScreenState();
}




int initValue = 0;
class _ChatDetailsScreenState extends State<ChatDetailsScreen> {

  final TextEditingController message = TextEditingController();
  final ScrollController _scrollController = ScrollController();
  bool? isLoading = false;
  bool isFromFiles=false;
  List<PlatformFile>? images = [];
  List<PlatformFile>? docs = [];
  List<PlatformFile>? videos = [];
  List<PlatformFile>? audios;
  List<PlatformFile> allFiles = [];
  List<PlatformFile> actualFiles = [];
  List<String> validImageExt = ["jpg", "jpeg", "png", "webp", "heic"];
  List<String> validVideExt = ["mp4", "avi", "mpeg", "wmv", "mkv"];
  List<String> validDocExt = ["pdf", "docx", "xlsx", "pptx"];

//final ScrollController _scrollController2 = ScrollController();
  FocusNode focusNode = FocusNode();
  @override
  void initState() {





    initValue = 1;


    ///for typing  keyboard
    focusNode.addListener(() {
      if (focusNode.hasFocus) {
        print("keyboard is open");
        // InboxRepo.socket.on(event, (data) => null);
        //print(InboxControllers.chatDetailData.value.receiver);
        var data = {
          "status": true,
          "reciever": InboxControllers.chatDetailData.value.receiver
        };

        InboxRepo.socket?.emit("isTyping", data);
      } else {
        print("keyBoard is closed");
        var data = {
          "status": false,
          "reciever": InboxControllers.chatDetailData.value.receiver
        };
        InboxRepo.socket?.emit("isTyping", data);
      }
    });

    var dataGet = {
      "userId": Data().user?.user?.id,

      ///from shared prefs
      "businessConversationId": widget.chatDto?.id,
      // "brokerConversationId": widget.chatDto?.id

      ///from chatDto
    };


    InboxRepo.socket?.on('block_user', (data) {
      print("block User emiting");

      // Handle the event data
      //print("blocked  called");
      //print(data);
      bool status = data['isBlocked'] as bool;
      //print(status);
      InboxControllers.blockedStatus.value = status;
      if (status == true) {
        // InboxControllers.blockedStatus.value = true;
        if (data['blockedUser_id'] !=
            InboxControllers.chatDetailData.value.receiver.toString()) {
          SchedulerBinding.instance.addPostFrameCallback((timeStamp) {
            InboxControllers.blockedString.value =
                "Can not Chat You Have been Blocked by this User";
            InboxControllers.blockedString.notifyListeners();
            InboxControllers.blockedStatus.notifyListeners();
          });
        } else {
          InboxControllers.blockedString.value =
              "Can not Chat You Have Blocked this User";

          // InboxControllers.blockedStatus.value = false;
          InboxControllers.blockedString.notifyListeners();
          InboxControllers.blockedStatus.notifyListeners();
        }
      } else {
        // print("da dlta raaze?");
        InboxControllers.blockedStatus.value = false;
        //InboxControllers.blockedStatus.notifyListeners();
        // InboxControllers.blockedString.notifyListeners();
      }

      // InboxControllers.blockedStatus.notifyListeners();
    });

    print("here is the data$dataGet");

    print("emiting>>>>>>>>>>>>>>>>>>");
    InboxRepo.socket?.onError((e) {
      print(e);
    });

    InboxRepo.socket?.emit('getBusinessChatDetails', dataGet);

    InboxRepo.socket?.on('error', (data) {
      // print("There is error ");
      WidgetFunctions.instance.snackBar(context, text: data.toString());
      //print(data);
    });

    print("Called ");

    ///full chat listener first time
    InboxRepo.socket?.on('businessChatDetails', (data) {
      print("bizness details>>>>>>>>>>>>>>>>>>>>>>>>>>>");
      print(data);

      ChatTileApiModel chTo = ChatTileApiModel.fromJson(data);
      InboxControllers.chatDetailData.value = chTo;
      InboxControllers.chatDetailData.notifyListeners();
      if(chTo.blockedUser!=null)
        {

          if (InboxControllers.chatDetailData.value.blockedUser ==
              Data().user?.user?.id) {
            SchedulerBinding.instance.addPostFrameCallback((timeStamp) {
              InboxControllers.blockedStatus.value = true;
              InboxControllers.blockedString.value =
              "Can not Chat You have been Blocked by this User";
              InboxControllers.blockedString.notifyListeners();
              InboxControllers.blockedStatus.notifyListeners();
            });
          } else {
            InboxControllers.blockedStatus.value = true;
            InboxControllers.blockedString.value =
            "Can not Chat You have  Blocked  this User";
         //   InboxControllers.blockedStatus.value = false;
          }
        }
      else
        {

          InboxControllers.blockedStatus.value = false;
        }
      // if (chTo.blockedUser.toString() == chTo.receiver.toString()) {
      //   print(InboxControllers.chatDetailData.value.blockedUser);
      //   print(InboxControllers.chatDetailData.value.receiver);
      //   print("inside the condition");
      //
      //   SchedulerBinding.instance.addPostFrameCallback((timeStamp) {
      //     InboxControllers.blockedStatus.value = true;
      //     InboxControllers.blockedString.value =
      //         "Can not Chat You have been Blocked by this User";
      //     InboxControllers.blockedString.notifyListeners();
      //     InboxControllers.blockedStatus.notifyListeners();
      //   });
      // } else {
      //   InboxControllers.blockedStatus.value = false;
      // }
      // if (InboxControllers.chatDetailData.value.blockedUser ==
      //     Data().user?.user?.id) {
      //   SchedulerBinding.instance.addPostFrameCallback((timeStamp) {
      //     InboxControllers.blockedStatus.value = true;
      //     InboxControllers.blockedString.value =
      //         "Can not Chat You have Blocked this User";
      //     InboxControllers.blockedString.notifyListeners();
      //     InboxControllers.blockedStatus.notifyListeners();
      //   });
      // } else {
      //   InboxControllers.blockedStatus.value = false;
      // }

      InboxControllers.blockedString.notifyListeners();
      InboxControllers.blockedStatus.notifyListeners();
    });

    ///new message to  chat
    InboxRepo.socket?.on('newMessageToBusiness', (data) {
      print("new message listener $data");
      Message newMessageDto = Message.fromJson(data);
      //InboxControllers.chatDetailData.value.messages?.clear();
      ChatTileApiModel dto = InboxControllers.chatDetailData.value;
      dto.messages?.add(newMessageDto);
      // InboxControllers.chatDetailData.value.messages?.clear();
      // await  Future.delayed(const Duration(milliseconds: 20));
      InboxControllers.chatDetailData.value = dto;

      InboxControllers.chatDetailData.notifyListeners();
  print("scroll offset");
   print(_scrollController.offset );


      if(InboxControllers.chatDetailData.value.messages!.length>6)
      {InboxControllers.scrollDownNotifier.value = true;}
      // int scrollMax = (_scrollController.position.maxScrollExtent.toInt());
      // int scrollOff = (_scrollController.offset.toInt());
      // int diff = scrollMax - scrollOff;
      // if(diff>50)
      // {
      //   InboxControllers.scrollDownNotifier.value = true;
      // }
      //_scrollController.jumpTo(_scrollController.position.maxScrollExtent+80);

     // print(data);
    });

    ///block _ user listener

//InboxRepo.socket.emit("user_online_status","Online");
    ///Typing event listening
    InboxRepo.socket?.on("isTyping", (data) {
      print("statusTypingTyping");
      InboxControllers.typingStatus.value = data;
      InboxControllers.typingStatus.notifyListeners();
      print(data);
    });

    ///replace userIdValue with storyId
    ///
    _scrollController.addListener(() {
      // print("scroll listening");

      print(_scrollController.position.minScrollExtent);
      int scrollMax = (_scrollController.position.maxScrollExtent.toInt());
      int scrollOff = (_scrollController.offset.toInt());
      int diff = scrollMax - scrollOff;
      print(diff);

      if (diff > 50) {
        //  print("in condition of scroll");
        if (InboxControllers.scrollDownNotifier.value != true) {
          InboxControllers.scrollDownNotifier.value = true;
        }
      } else {
        if (InboxControllers.scrollDownNotifier.value != false) {
          InboxControllers.scrollDownNotifier.value = false;
        }
      }
    });

    super.initState();

  }

  ///formatting date  for grouped header list chip
  String _formatDate(DateTime date) {
    // Format date as desired (e.g., "MMM dd, yyyy")
    //date=date.toLocal();
    if (date.day == DateTime.now().day &&
        date.year == DateTime.now().year &&
        date.month == DateTime.now().month) {
      return "Today";
    }
    return DateFormat("MMM dd, yyyy").format(date);
  }

  @override
  void dispose() {
    // TODO: implement dispose
    InboxRepo.socket?.off("newMessageToBusiness");
    InboxControllers.typingStatus.value = false;
    focusNode.dispose();
    _scrollController.dispose();
    InboxControllers.blockedStatus.value=false;
    InboxControllers.chatDetailData.value = ChatTileApiModel();
    InboxControllers.scrollDownNotifier.value = false;
    //InboxRepo.socket.clearListeners();
    super.dispose();
  }



  @override
  Widget build(BuildContext context) {
    return SafeArea(
        child: Scaffold(
      backgroundColor: AppColors.whiteColor,
      body: SizedBox(
        height: 1.sh,
        width: 1.sw,
        child: Stack(
          children: [
            Column(
              children: [
                16.y,
                Padding(
                  padding: EdgeInsets.symmetric(horizontal: 24.sp),
                  child: Row(
                    children: [
                      const BackArrowWidget(),
                      10.x,
                      CachedImage(
                          isCircle: true,
                          radius: 30.sp,
                          url: widget.chatDto!.profilePic != null
                              ? widget.chatDto!.profilePic!.contains('https')
                                  ? "${widget.chatDto!.profilePic}"
                                  : "${ApiConstant.baseurl}${widget.chatDto!.profilePic}"
                              : ""),
                      10.x,
                      Expanded(
                        flex: 3,
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            AppText(widget.chatDto!.username ?? "",
                                style: Styles.circularStdBold(context,
                                    fontSize: 18.sp,
                                    fontWeight: FontWeight.w500)),
                            AppText(
                              widget.chatDto!.businessReff?.name ?? "",
                              maxLine: 1,
                              overflow: TextOverflow.ellipsis,
                              style: Styles.circularStdMedium(
                                context,
                                fontSize: 12.sp,
                                color: AppColors.greyTextColor,
                              ),
                            ),
                            ValueListenableBuilder(
                              builder: (context, typingState, ss) {
                                return AppText(
                                  typingState ? "Typing..." : "",
                                  style: Styles.circularStdRegular(context),
                                );
                              },
                              valueListenable: InboxControllers.typingStatus,
                            ),
                            ValueListenableBuilder(
                              builder: (context, cStatus, ss) {
                                return AppText(
                                    cStatus == false ? "Offline" : "Online",
                                    style: Styles.circularStdMedium(context,
                                        fontSize: 12.sp,
                                        color: AppColors.greyTextColor));
                              },
                              valueListenable:
                                  InboxControllers.connectivityStatus,
                            ),
                          ],
                        ),
                      ),
                      //const Spacer(),
                      PopMenu(
                        chDto: widget.chatDto,
                      ),
                    ],
                  ),
                ),
                5.y,
                const Divider(
                  color: AppColors.borderColor,
                  thickness: 2,
                ),
                Expanded(
                  flex: 7,
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      10.y,

                      /// grouped messages message container message show
                      Expanded(
                        child: ValueListenableBuilder(
                          builder: (context, chatState, ss) {
                            //List<Message>? messages =[];
                            var elements = [];
                            if (chatState.messages != null &&
                                chatState.messages!.isNotEmpty) {
                              // chatState.messages?.forEach((element) {
                              //
                              //
                              //
                              // });
                              elements = List<dynamic>.from(
                                  chatState.messages!.map((x) => x.toJson()));
                              // if(InboxControllers.scrollGroupedKey.currentContext != null) {
                              //
                              // }

                              print("grouped elements------>");
                              print(elements);
                            }

                            return chatState.messages != null &&
                                    chatState.messages!.isNotEmpty
                                ? FutureBuilder(
                                    builder: (context, dd) {
                                      print("future isbuilding---");
                                      if (dd.connectionState ==
                                          ConnectionState.done) {
                                        scrollToBottom();
                                      }
                                      return GroupedListView<dynamic, String>(
                                        //key: InboxControllers.scrollGroupedKey,
                                       // shrinkWrap: true,
                                        //  cacheExtent: 20,

                                        controller: _scrollController,
                                        // physics: const CustomScrollPhysics(),
                                        elements: elements,
                                        groupBy: (element) => _formatDate(
                                            DateTime.parse(
                                                element['createdAt']).toLocal()),
                                        // groupComparator: (value1, value2) =>
                                        //     value2.compareTo(value1),

                                        order: GroupedListOrder.ASC,
                                        padding: EdgeInsets.symmetric(
                                            horizontal: 24.sp),
                                        useStickyGroupSeparators: true,
                                        floatingHeader: true,
                                        groupSeparatorBuilder: (String value) =>
                                            Chip(
                                                labelPadding:
                                                    EdgeInsets.symmetric(
                                                        horizontal: 5.sp,
                                                        vertical: 2.sp),
                                                backgroundColor:
                                                    AppColors.borderColor,
                                                label: AppText(
                                                  value,
                                                  style:
                                                      Styles.circularStdMedium(
                                                          context),
                                                )),
                                        itemBuilder: (c, element) {
                                          int index = elements.indexOf(element);
                                          return MessageContainer(
                                            //modelData: chats[0],
                                            index: index,
                                            chatDto: Message.fromJson(element),
                                            senderId: Data().user?.user?.id,
                                          );
                                        },

                                        //                             return MessageContainer(
                                        // //                                       modelData: chats[0],
                                        // //                                       index: index,
                                        // //                                       chatDto:chatState.messages![index],
                                        // //                                       senderId: "6579ea61d76f7a30f94f5c80",
                                        // //                                     );
                                      );
                                    },
                                    future: Future.delayed(
                                        const Duration(milliseconds: 0)),
                                  )
                                : chatState.messages != null &&
                                        chatState.messages!.isEmpty
                                    ? Center(
                                        child: AppText(
                                        "No New Messages",
                                        style:
                                            Styles.circularStdMedium(context),
                                      ))
                                    : const Center(
                                        child: CircularProgressIndicator());
                          },
                          valueListenable: InboxControllers.chatDetailData,
                        ),
                      ),
                      75.y,
                    ],
                  ),
                ),
              ],
            ),

            /// Message text field send message
            Positioned(
              bottom: 0,
              right: 0,
              left: 0,
              child: ValueListenableBuilder(
                builder: (context, blockedState, ss) {
                  print("${blockedState}blockedState");
                  return blockedState == false
                      ? Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 24.0),
                          child: Container(
                            height: allFiles != null && allFiles!.isNotEmpty
                                ? 220
                                : 80.h,
                            width: 1.sw,
                            decoration: BoxDecoration(
                              border: Border.all(
                                  color: allFiles.isNotEmpty
                                      ? AppColors.borderColor
                                      : Colors.transparent,
                                  width: 2),
                              borderRadius: BorderRadius.circular(20),
                              // color: AppColors.borderColor,
                            ),
                            child: Column(
                              children: [
                                allFiles.isNotEmpty
                                    ? SizedBox(
                                        height: 110.h,
                                        width: 1.sw,
                                        child: ListView.separated(
                                          // shrinkWrap: true,
                                          scrollDirection: Axis.horizontal,
                                          itemCount: allFiles.length,
                                          itemBuilder: (context, index) {
                                            return DisplayFileImageChat(
                                              fileImage: allFiles[index]
                                                  .path
                                                  .toString(),
                                              fullFile: allFiles[index],
                                              onDeleteTap: () {
                                                setState(() {
                                                  if (validImageExt.contains(
                                                      allFiles[index]
                                                          .extension
                                                          ?.toLowerCase())) {
                                                    images?.remove(
                                                        allFiles[index]);
                                                  }
                                                  // if(   allFiles?[index].path!.contains("thumbnail")==true)
                                                  // {
                                                  //   videos?.remove(allFiles![index]);
                                                  // }
                                                  if (validDocExt.contains(
                                                      allFiles[index]
                                                          .extension
                                                          ?.toLowerCase())) {
                                                    docs?.remove(
                                                        allFiles[index]);
                                                  }
                                                  allFiles.removeAt(index);
                                                  // actualFiles.removeAt(index);
                                                  //image = [];
                                                });
                                              },
                                            );
                                          },
                                          separatorBuilder:
                                              (BuildContext context,
                                                  int index) {
                                            return SizedBox(
                                              width: 5.sp,
                                            );
                                          },
                                        ),
                                      )
                                    : const SizedBox(),
                                CustomTextFieldWithOnTap(
                                  filledColor: AppColors.borderColor,
                                  focusNode: focusNode,
                                  isBorderRequired:
                                      allFiles != null && allFiles!.isNotEmpty
                                          ? false
                                          : true,
                                  prefixIcon: GestureDetector(
                                      onTap: () async {
                                        showPickerCustomBottomSheet(
                                            context, actualFiles);
                                      },
                                      child: SvgPicture.asset(
                                          'assets/images/attach.svg')),
                                  suffixIcon:Container(
                                    margin: const EdgeInsets.only(right: 10),
                                    child: GestureDetector(
                                      onTap: () {
                                        _sendMessage(message.text);
                                      },
                                      child: Material(
                                        //elevation: 0.9,
                                        color: Colors.transparent,

                                        child: SvgPicture.asset(
                                          'assets/images/send.svg',
                                          height: 30,
                                          width: 30,
                                        ),

                                      ),
                                    ),
                                  ),
                                  borderRadius: 40.sp,
                                  controller: message,
                                  hintText: 'Message',
                                  textInputType: TextInputType.text,
                                ),
                              ],
                            ),
                          ),
                        )
                      : ValueListenableBuilder(
                          builder: (context, blockedString, fg) {
                            return Container(
                              width: 1.sw,
                              height: 80,
                              padding: EdgeInsets.symmetric(horizontal: 24.sp),
                              child: AppText(
                                blockedString,
                                style: Styles.circularStdRegular(context,
                                    fontSize: 14),
                              ),
                            );
                          },
                          valueListenable: InboxControllers.blockedString,
                        );
                },
                valueListenable: InboxControllers.blockedStatus,
              ),
            ),

            ///loader
            Positioned(
                top: 0,
                bottom: 0,
                left: 0,
                right: 0,
                child: isLoading == true
                    ? const Center(
                        child: CircularProgressIndicator(
                          color: AppColors.primaryColor,
                        ),
                      )
                    : const Stack()),

            ///scroll container  scroll indicator
            Positioned(
                bottom: 100,
                right: 27,
                child: ValueListenableBuilder(
                  builder: (context, scrollData, ss) {
                    return scrollData == true
                        ? GestureDetector(
                            onTap: () {
                              _scrollController.animateTo(
                                  _scrollController.position.maxScrollExtent +
                                      400,
                                  duration: const Duration(milliseconds: 500),
                                  curve: Curves.bounceInOut);
                            },
                            child: Container(
                              height: 30,
                              width: 30,
                              decoration:  BoxDecoration(
                                  shape: BoxShape.circle,
                                  border: Border.all(color: AppColors.primaryColor,width: 1.3),
                                  color: AppColors.whiteColor),
                              child: const Center(
                                  child: Icon(
                                Icons.keyboard_double_arrow_down_outlined,
                                color: AppColors.primaryColor,
                              )),
                            ),
                          )
                        : const Stack();
                  },
                  valueListenable: InboxControllers.scrollDownNotifier,
                ))
          ],
        ),
      ),
    ));
  }

  ///pick file bottom sheet
  void showPickerCustomBottomSheet(BuildContext context, actualFiles) {
    showModalBottomSheet(
      backgroundColor: AppColors.primaryColor,
      context: context,
      builder: (context) => Container(
        height: 150.0, // Adjust height as needed
        decoration: BoxDecoration(
          color: AppColors.lightGraphColor,
          borderRadius: BorderRadius.circular(16.0),
        ),
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              // Image Circle
              InkWell(
                onTap: () async {
                  // Handle image selection

                  final List<PlatformFile>? filesPicked =
                      await PickFile.pickMultipleFiles(validImageExt, true);

                  if (filesPicked != null) {
                    print("in filepickeddd");
                    for (PlatformFile pf in filesPicked) {
                      print(pf.extension);
                      if (validImageExt.contains(pf.extension)) {
                        print("here");
                        images?.add(pf);
                        print(images?.length);
                        actualFiles.add(pf);
                      }
                    }
                    allFiles = actualFiles;
                    setState(() {});
                    Navigator.pop(context);
                  }
                },
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Container(
                        padding: const EdgeInsets.all(12.0),
                        decoration: BoxDecoration(
                          shape: BoxShape.circle,
                          color: Colors.grey[350],
                        ),
                        child: const Icon(Icons.image, color: Colors.black)),
                    AppText("Images",
                        style: Styles.circularStdRegular(context,
                            fontSize: 12, fontWeight: FontWeight.w500))
                  ],
                ),
              ),

              /// Video Circle
              // InkWell(
              //   onTap: () async {
              //     // Handle image selection
              //
              //     final List<PlatformFile>? filesPicked =
              //         await PickFile.pickMultipleFiles(validVideExt, false);
              //     // final  List<PlatformFile> actualFiles =[];
              //
              //     if (filesPicked != null) {
              //       print("in filepickeddd");
              //       for (PlatformFile pf in filesPicked) {
              //         print(pf.extension);
              //         if (validVideExt.contains(pf.extension)) {
              //           videos?.add(pf);
              //           print("inpicled videoss");
              //           print(videos?.length);
              //           var path =
              //               await getThumbnailFromVideo(pf.path.toString());
              //           PlatformFile? pff = PlatformFile(
              //               name:
              //                   "thumbnail ${DateTime.now().microsecondsSinceEpoch}",
              //               size: 10 * 1024 * 3,
              //               path: path);
              //           print("actual  path${pff.path}");
              //           actualFiles.add(pff);
              //         }
              //       }
              //       allFiles = actualFiles;
              //       setState(() {});
              //       Navigator.pop(context);
              //     }
              //   },
              //   child: Column(
              //     mainAxisAlignment: MainAxisAlignment.center,
              //     children: [
              //       Container(
              //           padding: const EdgeInsets.all(12.0),
              //           decoration: BoxDecoration(
              //             shape: BoxShape.circle,
              //             color: Colors.grey[350],
              //           ),
              //           child: const Icon(Icons.video_library,
              //               color: Colors.black)),
              //       AppText("Videos",
              //           style: Styles.circularStdRegular(context,
              //               fontSize: 12, fontWeight: FontWeight.w500))
              //     ],
              //   ),
              // ),

              // Document Circle
              InkWell(
                onTap: () async {
                  // Handle image selection

                  final List<PlatformFile>? filesPicked =
                      await PickFile.pickMultipleFiles(validDocExt, false);
                  // final  List<PlatformFile> actualFiles =[];
                  List<PlatformFile> actualDocsFiles = [];

                  if (filesPicked != null) {
                    print("in filepickeddd");
                    for (PlatformFile pf in filesPicked) {
                      if (validDocExt.contains(pf.extension)) {
                        docs?.add(pf);
                        print("docs selected");
                        print(docs?.length);
                        actualDocsFiles.add(pf);
                      }
                    }
                    allFiles = actualDocsFiles;
                    setState(() {});
                    Navigator.pop(context);
                  }
                },
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Container(
                        padding: const EdgeInsets.all(12.0),
                        decoration: BoxDecoration(
                          shape: BoxShape.circle,
                          color: Colors.grey[350],
                        ),
                        child: const Icon(Icons.file_copy_outlined,
                            color: Colors.black)),
                    AppText("Documents",
                        style: Styles.circularStdRegular(context,
                            fontSize: 12, fontWeight: FontWeight.w500))
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  ///message sending logic
  _sendMessage(messageContent) async {
    List<Map<String, dynamic>> imagesToSend = [];
    List<Map<String, dynamic>> vidToSend = [];
    List<Map<String, dynamic>> docsToSend = [];
    List<PlatformFile> vidThumbs = [];


    for (var i in allFiles) {
      if (i.path?.contains("thumbnail") == true) {
        vidThumbs.add(i);
      }
    }

    ///images
    if (images!=null && images!.isNotEmpty) {
      setState(() {
        isLoading = true;
        isFromFiles=true;
      });
      await Future.forEach(images as Iterable<PlatformFile?>, (element) async {
        final Uint8List buffer = await compute((PlatformFile? message) async {
          return await File(message!.path!).readAsBytes();
        }, element);
        print("buffer length --->");
        print(buffer.length);
        Map<String, dynamic> addDto = {"name": element?.name, "buffer": buffer};
        imagesToSend.add(addDto);
      }).whenComplete(() {
        var messageToSend = {
          "sender": Data().user?.user?.id,
          "receiver": InboxControllers.chatDetailData.value.receiver.toString(),
          //"receiver" : "6579f21c00996aa38f7c7a2b",
          "businessConversationId": widget.chatDto?.id,
          "content": message.text,
          "images": images != null ? imagesToSend : [],
          "videos": videos != null ? vidToSend : [],
          "docs": docs != null ? docsToSend : [],
          "createdAt": DateTime.now().toLocal().toIso8601String(),
        };
        sendMessageFinal(messageToSend);
        setState(() {
          isLoading = false;
          //isFromFiles=false;
        });


      });

      // for (var i in images!) {
      //   final Uint8List buffer = await compute((PlatformFile? message)   {
      //
      //     return File(message!.path!).readAsBytesSync();
      //
      //   },i);
      //   Map<String, dynamic> addDto = {
      //     "name": i.name,
      //     "buffer":buffer
      //   };
      //   imagesToSend.add(addDto);
      // }
      //isLoading=false;

    }

 //    ///videoos
 //    if (videos != null && videos!.isNotEmpty && vidThumbs.isNotEmpty) {
 //      print("here in videoss");
 //      setState(() {
 //        isLoading = true;
 //         isFromFiles=true;
 //      });
 //
 //      var element=videos?[0];
 //      Uint8List? bufferBytes=element!.bytes;
 //      print("sizezzzz");
 //      print(bufferBytes);
 //      await  File(element!.path!).readAsBytes().then((buffer) {
 //        print("original file size>> ");
 //        print(buffer.length);
 // double megabytes=bytesToMegabytes(buffer.length);
 //
 //
 // if(megabytes < 6 )
 //   {
 //     print("buffer length --->");
 //     print(buffer.length);
 //
 //     Map<String, dynamic> addDto = {"name": element?.name, "buffer": buffer};
 //     vidToSend.add(addDto);
 //     setState(() {
 //       isLoading = false;
 //       // isFromFiles=false;
 //     });
 //   }
 //
 // else
 //   {
 //     setState(() {
 //       isLoading = false;
 //       // isFromFiles=false;
 //     });
 //     WidgetFunctions.instance.snackBar(context,text: 'Video Size Exceeded 5 mb ');
 //   }
 //
 //
 //
 //      }).whenComplete((){
 //
 //        if(vidToSend.isEmpty)
 //          {}
 //        else {
 //          var messageToSend = {
 //            "sender": Data().user?.user?.id,
 //            "receiver": InboxControllers.chatDetailData.value.receiver
 //                .toString(),
 //            //"receiver" : "6579f21c00996aa38f7c7a2b",
 //            "businessConversationId": widget.chatDto?.id,
 //            "content": message.text,
 //            "images": images != null ? imagesToSend : [],
 //            "videos": videos != null ? vidToSend : [],
 //            "docs": docs != null ? docsToSend : [],
 //            "createdAt": DateTime.now().toString(),
 //          };
 //          sendMessageFinal(messageToSend);
 //          WidgetFunctions.instance.snackBar(context, text: "Video Sent!");
 //        }
 //      });
 //    //   final LightCompressor _lightCompressor = LightCompressor();
 //    //   _lightCompressor.onProgressUpdated.listen((event) {
 //    //
 //    //     print(event);
 //    //
 //    //   });
 //    //   await _lightCompressor.compressVideo(
 //    //    path:element!.path!,
 //    //     videoQuality: VideoQuality.medium,
 //    //     android: AndroidConfig(isSharedStorage: true, saveAt: SaveAt.Movies),
 //    //     ios: IOSConfig(saveInGallery: true),
 //    //
 //    //     video: Video(videoName: 'compressed${DateTime.now().millisecond}'),
 //    //      // It's false by default
 //    //   ).then((md) async {
 //    //
 //    //     if (md is OnSuccess) {
 //    //       final String outputFile = md.destinationPath;
 //    //       // use the file
 //    //
 //    //       print("filesize>>>>");
 //    //       // print(md?.filesize);
 //    //
 //    //
 //    //
 //    //
 //    //
 //    //
 //    //
 //    //     }
 //    //
 //    //     else if (md is OnFailure) {
 //    //       // failure message
 //    //       print(md.message);
 //    //
 //    //     } else if (md is OnCancelled) {
 //    //       print(md.isCancelled);
 //    //     }
 //    //
 //    //
 //    //
 //    //
 //    // });
 //
 //
 //
 //      // await Future.forEach(videos as Iterable<PlatformFile?>, (element) async {
 //      //
 //      //   // final Uint8List buffer = await compute((PlatformFile? message) async {
 //      //   //   return await File(message!.path!).readAsBytes();
 //      //   // }, element);
 //      //   // print("buffer length --->");
 //      //   // print(buffer.length);
 //      //   // Map<String, dynamic> addDto = {"name": element?.name, "buffer": buffer};
 //      //   // vidToSend.add(addDto);
 //      //
 //      //
 //      //
 //      // }).whenComplete(() {
 //      //
 //      //
 //      //   setState(() {
 //      //     isLoading = false;
 //      //   });
 //      // });
 //      //
 //      // for (var i in images!) {
 //      //   final Uint8List buffer = await compute((PlatformFile? message)   {
 //      //
 //      //     return File(message!.path!).readAsBytesSync();
 //      //
 //      //   },i);
 //      //   Map<String, dynamic> addDto = {
 //      //     "name": i.name,
 //      //     "buffer":buffer
 //      //   };
 //      //   imagesToSend.add(addDto);
 //      // }
 //      // isLoading=false;
 //
 //    }

    ///docs
    if (docs != null && docs!.isNotEmpty) {


      setState(() {
        isLoading = true;
        isFromFiles=true;
      });
      await Future.forEach(docs as Iterable<PlatformFile?>, (element) async {
        final Uint8List buffer = await compute((PlatformFile? message) async {
          return await File(message!.path!).readAsBytes();
        }, element);
print("buffer length --->");
print(buffer.length);
        Map<String, dynamic> addDto = {"name": element?.name, "buffer": buffer};
        docsToSend.add(addDto);
      }).whenComplete(() {

        setState(() {
          isLoading = false;
        //  isFromFiles=false;
        });

        var messageToSend = {
          "sender": Data().user?.user?.id,
          "receiver": InboxControllers.chatDetailData.value.receiver.toString(),
          //"receiver" : "6579f21c00996aa38f7c7a2b",
          "businessConversationId": widget.chatDto?.id,
          "content": message.text,
          "images": images != null ? imagesToSend : [],
          "videos": videos != null ? vidToSend : [],
          "docs": docs != null ? docsToSend : [],
          "createdAt": DateTime.now().toLocal().toIso8601String(),
        };
        sendMessageFinal(messageToSend);
      });
      // for (var i in images!) {
      //   final Uint8List buffer = await compute((PlatformFile? message)   {
      //
      //     return File(message!.path!).readAsBytesSync();
      //
      //   },i);
      //   Map<String, dynamic> addDto = {
      //     "name": i.name,
      //     "buffer":buffer
      //   };
      //   imagesToSend.add(addDto);
      // }
      //isLoading=false;

    }
    if(isFromFiles==false)
      {
        var messageToSend = {
          "sender": Data().user?.user?.id,
          "receiver": InboxControllers.chatDetailData.value.receiver.toString(),
          //"receiver" : "6579f21c00996aa38f7c7a2b",
          "businessConversationId": widget.chatDto?.id,
          "content": message.text,
          "images": images != null ? imagesToSend : [],
          "videos": videos != null ? vidToSend : [],
          "docs": docs != null ? docsToSend : [],
          "createdAt": DateTime.now().toLocal().toIso8601String(),
        };
        sendMessageFinal(messageToSend);

       setState(() {
         isFromFiles==false;
       });
      }
    print("imagesDto length+${imagesToSend.length}");
    print("vidDto length+${vidToSend.length}");
    print("DocsDto length+${docsToSend.length}");
    print("imagesDto length+${images?.length}");
    print("videoDto length+${videos?.length}");
    print("docsDtooo length+${docs?.length}");



    // if(allFiles.isEmpty)
    // {
    //   print("in here");
    //
    // }
    print("here");
    // const images = [
    //   {
    //     name: filename,
    //     buffer: file
    //   }
    // ]



    // if (images != null ||
    //     videos != null ||
    //     docs != null ||
    //     allFiles.isNotEmpty) {
    //
    //
    //
    // }
  }
  sendMessageFinal(messageToSend)
  {

  //  InboxRepo.socket?.emit('sendMessageToBusiness', messageToSend);
    if (allFiles.isEmpty && message.text.isNotEmpty) {
      InboxControllers.chatDetailData.value.messages?.add(Message(
          id: widget.chatDto?.id,
          sender: Data().user?.user?.id,
          receiver: widget.chatDto?.receiver.toString(),
          images: [],
          videos: [],
          docs: [],
          content: message.text,
          createdAt: DateTime.now().toUtc()));
      InboxControllers.chatDetailData.notifyListeners();
      // if(_scrollController.hasClients){
      // int scrollMax = (_scrollController.position.maxScrollExtent.toInt());
      // int scrollOff = (_scrollController.offset.toInt());
      // int diff = scrollMax - scrollOff;
      // if(diff>50)
      // {
      //   InboxControllers.scrollDownNotifier.value = true;
      // }
      // }

      if(InboxControllers.chatDetailData.value.messages!.length>6)
      {InboxControllers.scrollDownNotifier.value = true;}
      InboxRepo.socket?.emit('sendMessageToBusiness', messageToSend);
    }
    else if (allFiles.isNotEmpty || message.text.isNotEmpty) {
      print(messageToSend.toString());

      InboxRepo.socket?.emit('sendMessageToBusiness', messageToSend);
      //InboxRepo.socket?.sendBuffer=messageToSend['videos'][0]['buffer'];
      //InboxRepo.socket?.emitBuffered();
      //if(isLoading)

    } else {
      WidgetFunctions.instance.snackBar(context, text: "Can not be Empty");
    }

    message.text="";
    message.clear();
    images=[];
    videos=[];
    docs=[];
    // allFiles.clear();
    allFiles=[];
    actualFiles=[];
    // actualFiles.clear();
    setState(() {});

  }

  ///get thumbnail for vide0
  Future<String> getThumbnailFromVideo(String url) async {
    final fileName = await VideoThumbnail.thumbnailFile(
      video: url,
      thumbnailPath: (await getTemporaryDirectory()).path,
      imageFormat: ImageFormat.JPEG,
      maxWidth: 100,
      maxHeight: 130,
    );

    final file = File(fileName!);

    String dir = path.dirname(file.path); // Get directory
    String newPath = path.join(dir,
        'thumbnail_${DateTime.now().millisecondsSinceEpoch}.jpg'); // Rename
    file.renameSync(newPath);

    return newPath;
  }

  ///scroll to bottom for first timee
  void scrollToBottom() {

    if (initValue == 1) {
      InboxRepo.socket?.on('user_online_status', (data) {
        print('Online Emitting>>>>>>>>>>>>>>>>>');

        // print("Online Status");
        String recId = InboxControllers.chatDetailData.value.receiver.toString();

        print("allUserss");

        print(recId);
        List<dynamic> allUsers = data;
        print(allUsers);
        if (allUsers.contains(recId)) {
          InboxControllers.connectivityStatus.value = true;
        } else {
          InboxControllers.connectivityStatus.value = false;
        }

        // print("${InboxControllers.connectivityStatus.value}valueeeeeeee");
        InboxControllers.connectivityStatus.notifyListeners();
        // print(data);
      });
      if (_scrollController.hasClients) {
        // print("in scroll");
        _scrollController.jumpTo(
          _scrollController.position.maxScrollExtent + 1200,
        ); //immediate scroll
        initValue = 0;
      }


    }
  }
  double bytesToMegabytes(int bytes) {
    return bytes / (1024 * 1024);
  }
}
