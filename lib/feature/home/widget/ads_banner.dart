// import 'package:flutter/material.dart';
// import 'package:flutter_bloc/flutter_bloc.dart';
// import 'package:flutter_habit_run/common/constant/env.dart';
// import 'package:flutter_habit_run/common/model/user_model.dart';
// import 'package:flutter_habit_run/feature/home/bloc/save_info_user/bloc_save_info_user.dart';
// import 'package:google_mobile_ads/google_mobile_ads.dart';

// class AdsBanner extends StatefulWidget {
//   const AdsBanner({Key key}) : super(key: key);

//   @override
//   _AdsBannerState createState() => _AdsBannerState();
// }

// class _AdsBannerState extends State<AdsBanner> {
//   BannerAd _ad;
//   bool _isAdLoaded = false;
//   UserModel userModel;

//   @override
//   void initState() {
//     _ad = BannerAd(
//       adUnitId: AdHelper().bannerAdUnitId,
//       size: AdSize.banner,
//       request: const AdRequest(),
//       listener: BannerAdListener(
//         onAdLoaded: (_) {
//           setState(() {
//             _isAdLoaded = true;
//           });
//         },
//         onAdFailedToLoad: (ad, error) {
//           ad.dispose();
//           print('Ad load failed (code=${error.code} message=${error.message})');
//         },
//       ),
//     );
//     _ad.load();
//     super.initState();
//   }

//   @override
//   void dispose() {
//     _ad.dispose();
//     super.dispose();
//   }

//   @override
//   Widget build(BuildContext context) {
//     return BlocBuilder<SaveInfoUserBloc, SaveInfoUserState>(
//       builder: (context, state) {
//         if (state is SaveInfoUserSuccess) {
//           userModel = state.userModel;
//         }
//         return userModel.isPremium
//             ? const SizedBox()
//             : (_isAdLoaded
//                 ? Container(
//                     height: 100,
//                     child: AdWidget(
//                       ad: _ad,
//                     ),
//                   )
//                 : const SizedBox());
//       },
//     );
//   }
// }
