import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_email_sender/flutter_email_sender.dart';
import 'package:flutter_habit_run/app/widget_support.dart';
import 'package:flutter_habit_run/common/constant/colors.dart';
import 'package:flutter_habit_run/common/constant/env.dart';
import 'package:flutter_habit_run/common/model/invite_friend_model.dart';

import '../bloc/search_name/bloc_search_name.dart';
import '../bloc/search_name/search_name_bloc.dart';
import '../widget/item_invite.dart';

class InviteFriends extends StatefulWidget {
  const InviteFriends({Key key, this.roomId}) : super(key: key);
  final int roomId;
  @override
  _InviteFriendsState createState() => _InviteFriendsState();
}

class _InviteFriendsState extends State<InviteFriends> {
  TextEditingController searchController = TextEditingController();
  FocusNode searchNode = FocusNode();
  SearchUserBloc searchNameBloc;
  List<InviteFriend> results = [];

  @override
  void didChangeDependencies() {
    searchNameBloc = BlocProvider.of<SearchUserBloc>(context);
    super.didChangeDependencies();
  }

  @override
  void dispose() {
    searchController.dispose();
    searchNode.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final width = AppWidget.getWidthScreen(context);
    final height = AppWidget.getHeightScreen(context);
    return Scaffold(
      backgroundColor: Theme.of(context).color15,
      resizeToAvoidBottomInset: false,
      appBar:
          AppWidget.createSimpleAppBar(context: context, hasBackground: true),
      body: GestureDetector(
        onTap: () {
          FocusScope.of(context).unfocus();
        },
        child: Column(
          children: [
            SizedBox(
              height: height / 29 * 9,
              width: width,
              child: Stack(
                children: [
                  Positioned(
                    right: -16,
                    bottom: 24,
                    child: Image.asset('images/background_invite@3x.png',
                        width: width / 3 * 2, height: height / 50 * 11),
                  ),
                  Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 32),
                      child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              'Invite friends',
                              style: Theme.of(context).textTheme.headline1,
                            ),
                            Padding(
                              padding:
                                  const EdgeInsets.only(top: 10, bottom: 16),
                              child: Text(
                                ' ',
                                style: AppWidget.simpleTextFieldStyle(
                                    fontSize: 16,
                                    height: 24,
                                    color: Theme.of(context).color4),
                              ),
                            ),
                          ])),
                ],
              ),
            ),
            Expanded(
              child: Container(
                width: width,
                decoration: BoxDecoration(
                  color: Theme.of(context).color13,
                  borderRadius: const BorderRadius.only(
                      topLeft: Radius.circular(24),
                      topRight: Radius.circular(24)),
                ),
                padding: const EdgeInsets.only(top: 24),
                child: Column(
                  children: [
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 32),
                      child: TextFormField(
                          controller: searchController,
                          focusNode: searchNode,
                          onFieldSubmitted: (term) {
                            if (searchController.text.isNotEmpty) {
                              searchNameBloc.add(SearchEmailEvent(
                                  input: searchController.text.trim(),
                                  context: context));
                            }
                            searchNode.unfocus();
                          },
                          style: AppWidget.simpleTextFieldStyle(
                              color: Theme.of(context).color5,
                              fontSize: 16,
                              height: 24),
                          decoration: InputDecoration(
                            contentPadding: const EdgeInsets.symmetric(
                                vertical: 8, horizontal: 24),
                            suffixIcon: GestureDetector(
                              onTap: () {
                                if (searchController.text.isNotEmpty) {
                                  searchNameBloc.add(SearchEmailEvent(
                                      input: searchController.text.trim(),
                                      context: context));
                                }
                              },
                              child: Icon(CupertinoIcons.search,
                                  color: ultramarineBlue),
                            ),
                            hintText: 'Search Email',
                            hintStyle: AppWidget.simpleTextFieldStyle(
                                fontSize: 16,
                                height: 24,
                                color: Theme.of(context).color5),
                            border: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(16),
                                borderSide: BorderSide(color: grey600)),
                          )),
                    ),
                    Expanded(
                      child: BlocBuilder<SearchUserBloc, SearchUserState>(
                        builder: (context, state) {
                          if (state is SearchUserSuccess) {
                            results = state.results;
                          }
                          return results.isEmpty
                              ? const SizedBox()
                              : Align(
                                  alignment: Alignment.topCenter,
                                  child: ListView.builder(
                                    itemCount: results.length,
                                    shrinkWrap: true,
                                    reverse: true,
                                    padding: const EdgeInsets.symmetric(
                                        vertical: 12, horizontal: 32),
                                    itemBuilder: (context, index) {
                                      return ItemInvite(
                                          roomId: widget.roomId,
                                          inviteFriend: results[index],
                                          guestEmail:
                                              results[index].userModel.email,
                                          name: results[index].userModel.name,
                                          avatar:
                                              results[index].userModel.avatar);
                                    },
                                  ),
                                );
                        },
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
      // bottomNavigationBar: Container(
      //   height: 120,
      //   color: Theme.of(context).color13,
      //   padding: const EdgeInsets.symmetric(horizontal: 40),
      //   child: Column(
      //     children: [
      //       Expanded(
      //         child: GestureDetector(
      //           onTap: () {
      //             Clipboard.setData(
      //                     const ClipboardData(text: EnvValue.linkGooglePlay))
      //                 .then((_) {
      //               ScaffoldMessenger.of(context).showSnackBar(
      //                   AppWidget.customSnackBar(
      //                       content: 'Copied link', color: caribbeanGreen));
      //             });
      //           },
      //           child: Row(
      //             mainAxisAlignment: MainAxisAlignment.spaceBetween,
      //             children: [
      //               Text(
      //                 'Copy link to join with Runner',
      //                 style: AppWidget.simpleTextFieldStyle(
      //                     fontSize: 16, height: 24, color: ultramarineBlue),
      //               ),
      //               Image.asset('images/fi_link@3x.png',
      //                   width: 24, height: 24)
      //             ],
      //           ),
      //         ),
      //       ),
      //       BlocBuilder<SearchUserBloc, SearchUserState>(
      //         builder: (context, state) {
      //           if (state is SearchUserSuccess) {
      //             results = state.results;
      //           }
      //           return results.isNotEmpty
      //               ? const SizedBox()
      //               : Padding(
      //                   padding: const EdgeInsets.only(bottom: 8),
      //                   child: AppWidget.typeButtonStartAction(
      //                       input: 'Invite Friend to Run',
      //                       onPressed: () async {
      //                         final Email email = Email(
      //                           body:
      //                               'Link download App Runner Habit: ${EnvValue.linkGooglePlay}',
      //                           subject: 'Download App to Run with me',
      //                           recipients: [searchController.text.trim()],
      //                         );
      //                         await FlutterEmailSender.send(email);
      //                       },
      //                       bgColor: ultramarineBlue),
      //                 );
      //         },
      //       ),
      //     ],
      //   ),
      // )
    );
  }
}
