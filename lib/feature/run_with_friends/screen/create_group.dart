import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_habit_run/app/widget_support.dart';
import 'package:flutter_habit_run/common/constant/colors.dart';
import 'package:flutter_habit_run/common/model/invite_friend_model.dart';
import '../bloc/create_group/bloc_create_group.dart';
import '../bloc/search_name/bloc_search_name.dart';
import '../widget/form_create_group.dart';
import '../widget/item_invite.dart';

class CreateGroup extends StatefulWidget {
  const CreateGroup({Key key}) : super(key: key);

  @override
  State<CreateGroup> createState() => _CreateGroupState();
}

class _CreateGroupState extends State<CreateGroup> {
  CreateGroupBloc createGroupBloc;
  SearchUserBloc searchNameBloc;
  TextEditingController nameGroupController = TextEditingController();
  FocusNode nameGroupNode = FocusNode();
  List<InviteFriend> results = [];

  @override
  void didChangeDependencies() {
    createGroupBloc = BlocProvider.of<CreateGroupBloc>(context);
    searchNameBloc = BlocProvider.of<SearchUserBloc>(context);
    super.didChangeDependencies();
  }

  @override
  void dispose() {
    nameGroupController.dispose();
    nameGroupNode.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppWidget.createSimpleAppBar(context: context),
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 40),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Create Groups',
                  style: Theme.of(context).textTheme.headline1,
                ),
                Padding(
                  padding: const EdgeInsets.only(top: 28, bottom: 30),
                  child: FormCreateGroup(
                    controller: nameGroupController,
                    focusNode: nameGroupNode,
                    label: 'Name Group',
                  ),
                ),
                Row(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text('Invite friends',
                        style: AppWidget.boldTextFieldStyle(
                            fontSize: 18,
                            height: 28,
                            color: Theme.of(context).color9)),
                    GestureDetector(
                      onTap: () {
                        createGroupBloc.add(CreatePressed(
                            nameGroup: nameGroupController.text.trim(),
                            context: context));
                        nameGroupController.clear();
                      },
                      child: Image.asset(
                        'images/arrow-right@3x.png',
                        width: 24,
                        height: 24,
                        color: Theme.of(context).color14,
                      ),
                    )
                  ],
                )
              ],
            ),
          ),
          Expanded(
            child: BlocBuilder<SearchUserBloc, SearchUserState>(
              builder: (context, state) {
                if (state is SearchUserSuccess) {
                  results = state.listInvite;
                }
                return results == null
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
                                roomId: createGroupBloc.roomId,
                                inviteFriend: results[index],
                                guestEmail: results[index].userModel.email,
                                name: results[index].userModel.name,
                                avatar: results[index].userModel.avatar);
                          },
                        ),
                      );
              },
            ),
          )
        ],
      ),
      bottomNavigationBar: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 40, vertical: 8),
        child: AppWidget.typeButtonStartAction(
            input: 'Create Groups',
            onPressed: () {
              searchNameBloc.add(ResetInviteEvent());
              createGroupBloc.add(CreatePressed(
                  nameGroup: nameGroupController.text.trim(),
                  context: context));
              nameGroupController.clear();
            },
            bgColor: ultramarineBlue),
      ),
    );
  }
}
