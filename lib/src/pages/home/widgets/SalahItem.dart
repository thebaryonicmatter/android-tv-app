import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart' hide TextDirection;
import 'package:mawaqit/i18n/AppLanguage.dart';
import 'package:mawaqit/src/helpers/RelativeSizes.dart';
import 'package:mawaqit/src/helpers/time_utils.dart';
import 'package:mawaqit/src/themes/UIShadows.dart';
import 'package:provider/provider.dart';

import '../../../helpers/StringUtils.dart';
import '../../../services/mosque_manager.dart';

const kSalahItemWidgetWidth = 135.0;

class SalahItemWidget extends StatelessWidget {
  SalahItemWidget({
    Key? key,
    required this.time,
    this.title,
    this.iqama,
    this.active = false,
    this.removeBackground = false,
    this.withDivider = true,
  }) : super(key: key);

  final String? title;
  final String time;
  final String? iqama;

  /// show divider only when both time and iqama exists
  final bool withDivider;
  final bool active;
  final bool removeBackground;

  @override
  Widget build(BuildContext context) {
    double bigFont = 4.5.vw;
    double smallFont = 3.6.vw;

    final mosqueProvider = context.watch<MosqueManager>();
    final mosqueConfig = mosqueProvider.mosqueConfig;
    bool? isIqamaEnabled = mosqueConfig?.iqamaEnabled!;
    bool? isIqamaMoreImportant = mosqueConfig!.iqamaMoreImportant!&&isIqamaEnabled! ;
    final timeDate = time.toTimeOfDay()?.toDate();
    final iqamaDate = iqama?.toTimeOfDay()?.toDate();
    print (isIqamaEnabled);
    final isArabic = context.read<AppLanguage>().isArabic();
    final DateFormat dateTimeConverter = mosqueConfig.timeDisplayFormat == "12"
        ? DateFormat(
            "hh:mm",
            "en-En",
          )
        : DateFormat(
            "HH:mm",
            "en",
          );
    final DateFormat dateTimePeriodConverter = mosqueConfig.timeDisplayFormat == "12"
        ? DateFormat(
            "a",
            "en",
          )
        : DateFormat(
            "",
            "en",
          );

    return Container(
      width: 16.vw,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(2.vw),
        color: active
            ? mosqueProvider.getColorTheme().withOpacity(.7)
            : removeBackground
                ? null
                : Colors.black.withOpacity(.70),
      ),
      padding:
      isArabic?EdgeInsets.symmetric(vertical: .8.vh, horizontal: 1.vw):
      EdgeInsets.symmetric(vertical: 1.6.vh, horizontal: 1.vw),
      child: Directionality(
        textDirection: TextDirection.ltr,
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            if (title != null)
              FittedBox(
                child: Text(
                  maxLines: 1,
                  title!,
                  style: TextStyle(
                    fontSize: 3.vw,
                    shadows: kHomeTextShadow,
                    color: Colors.white,
                    fontFamily: StringManager.getFontFamily(context)

                  ),
                ),
              ),
            SizedBox(height: 1.vh),
            if (time.trim().isEmpty) Icon(Icons.dnd_forwardslash, size: 6.vw),
            Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                Text(
                  timeDate == null ? time : dateTimeConverter.format(timeDate),
                  style: TextStyle(
                    fontSize: isIqamaMoreImportant ? smallFont : bigFont,
                    fontWeight: FontWeight.w700,
                    shadows: kHomeTextShadow,
                    color: Colors.white,
                    // fontFamily: StringManager.getFontFamily(context),
                  ),
                ),
                if (timeDate != null)
                  SizedBox(
                    width: 1.vw,
                    child: Text(
                      dateTimePeriodConverter.format(timeDate),
                      style: TextStyle(
                        height: .9,
                        letterSpacing: 9,
                        fontSize: 1.6.vw,
                        fontWeight: FontWeight.w300,
                        // shadows: kHomeTextShadow,
                        color: Colors.white,
                      ),
                    ),
                  ),
              ],
            ),
            if (iqama != null &&isIqamaEnabled!)
              SizedBox(
                height: 1.3.vw,
                width: double.infinity,
                child: Divider(
                  thickness: 1,
                  color: withDivider ? Colors.white : Colors.transparent,
                ),
              ),
            if (iqama != null&&isIqamaEnabled!)
              Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Text(
                    iqamaDate == null ? iqama! : dateTimeConverter.format(iqamaDate),
                    // '$iqama${iqama!.startsWith('+') ? "\'" : ""}',
                    style: TextStyle(
                      fontSize: isIqamaMoreImportant ? bigFont : smallFont,
                      fontWeight: FontWeight.bold,
                      shadows: kHomeTextShadow,
                      letterSpacing: 1,
                      color: Colors.white,

                      // fontFamily: StringManager.getFontFamily(context)
                    ),
                  ),

                  if (iqamaDate != null )
                    SizedBox(
                      width: 1.vw,
                      child: Text(
                        dateTimePeriodConverter.format(iqamaDate),
                        style: TextStyle(
                          height: .9,
                          letterSpacing: 9,
                          fontSize: 1.4.vw,
                          fontWeight: FontWeight.w300,
                          // shadows: kHomeTextShadow,
                          // fontFamily: StringManager.getFontFamily(context),
                          color: Colors.white,
                        ),
                      ),
                    ),
                ],
              ),
          ],
        ),
      ),
    );
  }
}
