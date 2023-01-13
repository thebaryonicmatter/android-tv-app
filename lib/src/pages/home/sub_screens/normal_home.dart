import 'package:flutter/material.dart';
import 'package:marquee/marquee.dart';
import 'package:mawaqit/generated/l10n.dart';
import 'package:mawaqit/src/helpers/RelativeSizes.dart';
import 'package:mawaqit/src/pages/home/widgets/HomeLogoVersion.dart';
import 'package:mawaqit/src/pages/home/widgets/SalahItem.dart';
import 'package:mawaqit/src/pages/home/widgets/SalahTimesBar.dart';
import 'package:mawaqit/src/pages/home/widgets/TimeWidget.dart';
import 'package:mawaqit/src/pages/home/widgets/mosque_header.dart';
import 'package:mawaqit/src/services/mosque_manager.dart';
import 'package:mawaqit/src/themes/UIShadows.dart';
import 'package:provider/provider.dart';

import '../widgets/FlashWidget.dart';

class NormalHomeSubScreen extends StatelessWidget {
  const NormalHomeSubScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final mosqueProvider = context.read<MosqueManager>();
    final mosque = mosqueProvider.mosque!;
    final mosqueConfig = mosqueProvider.mosqueConfig;
    return Column(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        MosqueHeader(mosque: mosque),
        Row(
          children: [
            Expanded(
              child: mosqueProvider.showImsak
                  ? Center(
                      child: SalahItemWidget(
                        title: S.of(context).imsak,
                        time: mosqueProvider.imsak,
                        removeBackground: true,
                        withDivider: false,
                      ),
                    )
                  : mosqueProvider.showEid
                      ? Center(
                          child: SalahItemWidget(
                            title: "Salat El Eid",
                            iqama: mosqueProvider.times!.aidPrayerTime2,
                            time: mosqueProvider.times!.aidPrayerTime ?? "",
                            removeBackground: false,
                            withDivider: mosqueProvider.times!.aidPrayerTime2 != null,
                            active: true,
                          ),
                        )
                      : Center(
                          child: SalahItemWidget(
                            title: S.of(context).shuruk,
                            time: mosqueProvider.times!.shuruq ?? "",
                            removeBackground: true,
                            withDivider: false,
                            active: mosqueProvider.activateShroukItem,
                          ),
                        ),
            ),
            HomeTimeWidget(),
            Expanded(
              child: Center(
                child: SalahItemWidget(
                  title: S.of(context).jumua,
                  time: mosqueProvider.times!.jumua ?? "",
                  iqama: mosqueProvider.times!.jumua2,
                  active:
                      mosqueProvider.nextSalahIndex() == 2 && mosqueProvider.mosqueDate().weekday == DateTime.friday,
                  removeBackground: true,
                ),
              ),
            ),
          ],
        ),
        SalahTimesBar(),
        mosqueConfig!.footer!
            ? Container(
                padding: EdgeInsets.symmetric(horizontal: 1.vw, vertical: .3.vw),
                width: double.infinity,
                color: mosque.flash?.content.isEmpty != false ? null : Colors.black38,
                child: Row(
                  children: [
                    Column(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          "ID ${mosque.id}",
                          style: TextStyle(
                            fontSize: .7.vw,
                            color: Colors.grey,
                            fontWeight: FontWeight.bold,
                            shadows: kHomeTextShadow,
                          ),
                        ),
                        SizedBox(height: 5),
                        Image.network(
                          'https://mawaqit.net/static/images/store-qrcode.png?4.89.2',
                          width: 3.vw,
                          height: 3.vw,
                        ),
                      ],
                    ),
                    Expanded(
                      child: SizedBox(
                        height: 5.vw,
                        child: FlashWidget(),
                      ),
                    ),
                    HomeLogoVersion(),
                  ],
                ),
              )
            : SizedBox(
                height: 40,
              )
      ],
    );
  }
}
