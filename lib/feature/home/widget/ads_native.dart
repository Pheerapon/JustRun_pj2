// import 'package:flutter/material.dart';
// import 'package:flutter_bloc/flutter_bloc.dart';
// import 'package:flutter_habit_run/common/constant/colors.dart';
// import 'package:flutter_habit_run/common/constant/env.dart';
// import 'package:flutter_habit_run/common/model/user_model.dart';
// import 'package:flutter_habit_run/feature/home/bloc/save_info_user/bloc_save_info_user.dart';
// import 'package:google_mobile_ads/google_mobile_ads.dart';

// class AdsNative extends StatefulWidget {
//   const AdsNative({Key key}) : super(key: key);

//   @override
//   _AdsNativeState createState() => _AdsNativeState();
// }

// class _AdsNativeState extends State<AdsNative> {
//   NativeAd _ad;
//   bool _isAdLoaded = false;
//   UserModel userModel;

//   @override
//   void initState() {
//     _ad = NativeAd(
//       adUnitId: AdHelper().nativeAdUnitId,
//       factoryId: 'listTile',
//       request: const AdRequest(),
//       listener: NativeAdListener(
//         onAdLoaded: (ad) {
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
//         return _isAdLoaded
//             ? Container(
//                 child: AdWidget(ad: _ad),
//                 height: 98,
//                 padding: const EdgeInsets.all(8),
//                 margin: const EdgeInsets.symmetric(vertical: 16),
//                 decoration: BoxDecoration(
//                     color: caribbeanGreen,
//                     borderRadius: BorderRadius.circular(16)),
//                 alignment: Alignment.center,
//               )
//             : const SizedBox();
//       },
//     );
//   }
// }
