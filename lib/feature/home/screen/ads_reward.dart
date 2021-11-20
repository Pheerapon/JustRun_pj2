// import 'package:flutter/cupertino.dart';
// import 'package:flutter/material.dart';
// import 'package:flutter_bloc/flutter_bloc.dart';
// import 'package:flutter_habit_run/app/bubble_button.dart';
// import 'package:flutter_habit_run/common/constant/env.dart';
// import 'package:flutter_habit_run/common/model/user_model.dart';
// import 'package:google_mobile_ads/google_mobile_ads.dart';

// import '../bloc/save_info_user/bloc_save_info_user.dart';

// enum TypeReward { FinishRun }

// class AdsReward extends StatefulWidget {
//   const AdsReward({this.child, this.function, this.pointReward});
//   final Widget child;
//   final Function function;
//   final int pointReward;
//   @override
//   _AdsRewardState createState() => _AdsRewardState();
// }

// class _AdsRewardState extends State<AdsReward> {
//   RewardedAd _rewardedAd;
//   int _numRewardedLoadAttempts = 0;
//   int maxFailedLoadAttempts = 3;
//   UserModel userModel;

//   void createRewardedAd() {
//     RewardedAd.load(
//         adUnitId: AdHelper().rewardAdUnitId,
//         request: const AdRequest(),
//         rewardedAdLoadCallback: RewardedAdLoadCallback(
//           onAdLoaded: (RewardedAd ad) {
//             print('$ad loaded.');
//             _rewardedAd = ad;
//             _numRewardedLoadAttempts = 0;
//           },
//           onAdFailedToLoad: (LoadAdError error) {
//             print('RewardedAd failed to load: $error');
//             _rewardedAd = null;
//             _numRewardedLoadAttempts += 1;
//             if (_numRewardedLoadAttempts <= maxFailedLoadAttempts) {
//               createRewardedAd();
//             }
//           },
//         ));
//   }

//   Future<void> showRewardedAd() async {
//     if (_rewardedAd == null) {
//       widget.function(context, widget.pointReward);
//       return;
//     }
//     _rewardedAd.fullScreenContentCallback = FullScreenContentCallback(
//       onAdShowedFullScreenContent: (RewardedAd ad) {
//         widget.function(context, widget.pointReward * 2);
//       },
//       onAdDismissedFullScreenContent: (RewardedAd ad) async {
//         print('$ad onAdDismissedFullScreenContent.');
//         ad.dispose();
//       },
//       onAdFailedToShowFullScreenContent: (RewardedAd ad, AdError error) {
//         print('$ad onAdFailedToShowFullScreenContent: $error');
//         ad.dispose();
//         createRewardedAd();
//       },
//     );

//     _rewardedAd.show(onUserEarnedReward: (RewardedAd ad, RewardItem reward) {
//       print('$ad with reward $RewardItem(${reward.amount}, ${reward.type})');
//     });
//     _rewardedAd = null;
//   }

//   @override
//   void initState() {
//     super.initState();
//     createRewardedAd();
//   }

//   @override
//   void dispose() {
//     super.dispose();
//     _rewardedAd?.dispose();
//   }

//   @override
//   Widget build(BuildContext context) {
//     return BlocBuilder<SaveInfoUserBloc, SaveInfoUserState>(
//       builder: (context, state) {
//         if (state is SaveInfoUserSuccess) {
//           userModel = state.userModel;
//         }
//         return BubbleButton(
//           onTap: () async {
//             userModel.isPremium
//                 ? widget.function(context, widget.pointReward * 2)
//                 : await showRewardedAd();
//           },
//           child: widget.child,
//         );
//       },
//     );
//   }
// }
