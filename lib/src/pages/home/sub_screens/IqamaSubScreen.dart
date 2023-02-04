import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:mawaqit/const/resource.dart';
import 'package:mawaqit/generated/l10n.dart';
import 'package:mawaqit/src/helpers/RelativeSizes.dart';
import 'package:mawaqit/src/helpers/StringUtils.dart';
import 'package:mawaqit/src/helpers/mawaqit_icons_icons.dart';
import 'package:mawaqit/src/pages/home/widgets/FlashAnimation.dart';
import 'package:mawaqit/src/services/audio_manager.dart';
import 'package:mawaqit/src/services/mosque_manager.dart';
import 'package:mawaqit/src/themes/UIShadows.dart';
import 'package:provider/provider.dart';

class IqamaSubScreen extends StatefulWidget {
  const IqamaSubScreen({Key? key, this.onDone}) : super(key: key);

  final VoidCallback? onDone;

  @override
  State<IqamaSubScreen> createState() => _IqamaSubScreenState();
}

class _IqamaSubScreenState extends State<IqamaSubScreen> {
  @override
  void initState() {
    if (context.read<MosqueManager>().mosqueConfig!.iqamaBip) {
      context.read<AudioManager>().loadAndPlayIqamaBipVoice(
            context.read<MosqueManager>().mosqueConfig,
            onDone: widget.onDone,
          );
    } else {
      Future.delayed(Duration(minutes: 1), widget.onDone);
    }
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final tr =S.of(context);
    return Column(
      children: [
        Expanded(
          child: FittedBox(
            fit: BoxFit.scaleDown,
            child: Container(
              padding: EdgeInsets.symmetric(vertical: 10, horizontal: 40),
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(10),
                gradient: LinearGradient(
                  // transform: GradientRotation(pi / 2),
                  begin: Alignment(0, 0),
                  end: Alignment(0, 1),
                  colors: [
                    theme.primaryColor,
                    theme.primaryColor.withOpacity(0),
                  ],
                ),
              ),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Text(
                    tr.alIqama,
                    style: theme.textTheme.displayMedium?.copyWith(
                      color: Colors.white,
                      fontWeight: FontWeight.w500,
                      shadows: kAfterAdhanTextShadow,
                      fontFamily: StringManager.getFontFamilyByString(tr.alIqama)
                    ),
                  ),
                  Text(
                    "الإقامة",
                    style: theme.textTheme.displaySmall?.copyWith(
                      color: Colors.white,
                      fontFamily: StringManager.fontFamilyKufi,
                      shadows: kAfterAdhanTextShadow,
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
        Expanded(
            child: FlashAnimation(
              child: Stack(children: [
                Transform.scale(scaleX: 1.01,scaleY: 1.02,child: Image.asset(R.ASSETS_ICON_NO_PHONE_PNG,color: Colors.black38,)),
                Image.asset(R.ASSETS_ICON_NO_PHONE_PNG,color:Colors.white,),

        ]),
            )),
        Text(
          tr.turnOfPhones,
          style: TextStyle(
            fontWeight: FontWeight.bold,
            fontSize: 4.vw,
            color: Colors.white,
            fontFamily: StringManager.getFontFamilyByString(tr.turnOfPhones),
            shadows: kAfterAdhanTextShadow,
          ),
        ),
        SizedBox(height: 50),
      ],
    );
  }
}
