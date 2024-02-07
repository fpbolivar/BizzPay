import 'package:buysellbiz/Application/Services/Navigation/navigation.dart';
import 'package:buysellbiz/Data/DataSource/Resources/imports.dart';
import 'package:buysellbiz/Presentation/Widgets/Dashboard/Chat/Components/broker_chat_details.dart';
import 'package:buysellbiz/Presentation/Widgets/Dashboard/Chat/Components/chat_details.dart';
import 'package:buysellbiz/Presentation/Widgets/Dashboard/Chat/Controllers/Repo/inboox_repo.dart';
import 'package:buysellbiz/Presentation/Widgets/Dashboard/Chat/Controllers/inboxmodel.dart';
import 'package:socket_io_client/socket_io_client.dart';

class ChatNavigation {
  /// chat creating with business
  static getToChatDetails(
      BuildContext context, String createdFor, String businessId) async {
    print("socket value ");
    print(InboxRepo.socket != null);
    // if(InboxRepo.socket.connected==false) {
    //
    // }
    if (InboxRepo.isConnected.value == false) {
      print("in  here");
      InboxRepo().initSocket(context, Data().user?.user?.id);

      // Navigate.to(context, ChatDetailsScreen(chatDto: chatTileApiModel,));
    }
    print('pa else kda da adasdsada');

    var data = {
      "createdBy": Data().user?.user?.id, //"6579ea61d76f7a30f94f5c80"
      "createdFor": createdFor, //"6579f21c00996aa38f7c7a2b"
      "businessReff": businessId //"6579ed17d76f7a30f94f5c9c"
    };
    print("alldata");
    print(data);
    await InboxRepo().createBusiness(body: data).then((value) {
      print("valueeeeeeeeeeeeee");
      print(value);
      if (value['Success']) {
        ChatTileApiModel chatTileApiModel =
            ChatTileApiModel.fromJson(value['body']);
        Navigate.to(
            context,
            ChatDetailsScreen(
              chatDto: chatTileApiModel,
            ));
      } else {
        WidgetFunctions.instance.snackBar(context, text: value['error']);
      }

      // Navigate.to(context, ChatDetailsScreen(chatDto: chatTileApiModel,));
    });
    print("user id${Data().user!.user!.id}");

// InboxRepo.socket.onConnect((s){
// print("here in on connect");
//
//
// });
//     InboxRepo.socket.emit("createBusinessConversation",data);
//
//     InboxRepo.socket.on("newBusinessConversation",(data)
//     {
// print("data socket");
// print(data);
// ChatTileApiModel chatTileApiModel=ChatTileApiModel.fromJson(data);
// Navigate.to(context, ChatDetailsScreen(chatDto: chatTileApiModel,));
//
//     });
//     InboxRepo.socket.on("chatAlreadyExists",(data)
//     {
//       print("data socket");
//       print(data);
//       ChatTileApiModel chatTileApiModel=ChatTileApiModel.fromJson(data);
//       Navigate.to(context, ChatDetailsScreen(chatDto: chatTileApiModel,));
//
//     });
  }

  static initChatWithBroker(
      BuildContext context, String createdFor, String brokerId) async {
    print(InboxRepo.socket != null);
    // if(InboxRepo.socket.connected==false) {
    //
    // }
    if (InboxRepo.isConnected.value == false) {
      print("in  hereee");
      InboxRepo().initSocket(context, Data().user?.user?.id);
    }
    print("user id${Data().user!.user!.id}");
    var data = {
      "createdBy": Data().user?.user?.id, //"6579ea61d76f7a30f94f5c80"
      "createdFor": createdFor, //"6579f21c00996aa38f7c7a2b"
      "brokerReff": brokerId //"6579ed17d76f7a30f94f5c9c"
    };
    print("alldata");
    print(data);

    await InboxRepo().createBrokerChat(body: data).then((value) {
      print("valueeeeeeeeeeeeee");
      print(value);
      if (value['Success']) {
        ChatTileApiModel chatTileApiModel =
            ChatTileApiModel.fromJson(value['body']);

        print("here is chat details ${chatTileApiModel.toJson()}");

        Navigate.to(
            context,
            BrokerChatDetailsScreen(
              chatDto: chatTileApiModel,
            ));
      } else {
        WidgetFunctions.instance.snackBar(context, text: value['error']);
      }
      // Navigate.to(context, ChatDetailsScreen(chatDto: chatTileApiModel,));
    });
// InboxRepo.socket.onConnect((s){
// print("here in on connect");
//
//
// });
//     InboxRepo.socket.emit("createBusinessConversation",data);
//
//     InboxRepo.socket.on("newBusinessConversation",(data)
//     {
// print("data socket");
// print(data);
// ChatTileApiModel chatTileApiModel=ChatTileApiModel.fromJson(data);
// Navigate.to(context, ChatDetailsScreen(chatDto: chatTileApiModel,));
//
//     });
//     InboxRepo.socket.on("chatAlreadyExists",(data)
//     {
//       print("data socket");
//       print(data);
//       ChatTileApiModel chatTileApiModel=ChatTileApiModel.fromJson(data);
//       Navigate.to(context, ChatDetailsScreen(chatDto: chatTileApiModel,));
//
//     });
  }
}
