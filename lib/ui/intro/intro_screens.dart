import 'package:app/common_widget/custom_intro_button.dart';
import 'package:app/ui/auth/login_screen.dart';
import 'package:app/utils/SizeConfig.dart';
import 'package:app/utils/app_constants.dart';
import 'package:app/utils/app_utils.dart';
import 'package:app/utils/color_resources.dart';
import 'package:app/utils/ease_in_widget.dart';
import 'package:app/utils/image_resource.dart';
import 'package:app/utils/string_resource.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:smooth_page_indicator/smooth_page_indicator.dart';

class IntroScreen extends StatefulWidget {
  @override
  State<StatefulWidget> createState() {
    return _SplashState();
  }
}

class _SplashState extends State<IntroScreen> {
  final controller = PageController(viewportFraction: 0.8);
  var currenctIndex = 0;
  List<Widget> items = [
    Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: <Widget>[

        Container(
          alignment: Alignment.center,
          padding: const EdgeInsets.symmetric(horizontal: 18),
          child: Stack(
            children: <Widget>[
              SvgPicture.string(
                '<svg viewBox="56.7 215.0 260.7 177.6" ><path transform="translate(-65.84, 106.34)" d="M 283.1061401367188 133.0338439941406 C 271.9169616699219 141.6113433837891 257.4039001464844 141.0531921386719 244.6877593994141 136.5944519042969 C 231.9716491699219 132.1356811523438 220.2875823974609 124.1836547851562 207.9022369384766 118.5348205566406 C 197.4985198974609 113.7965393066406 186.6361846923828 110.6960601806641 175.5813140869141 109.309326171875 C 159.7899780273438 107.3301391601562 142.1567535400391 109.7391662597656 131.1528472900391 123.6062469482422 C 118.8998413085938 139.0515441894531 119.8393402099609 166.9108734130859 133.0926971435547 181.0826873779297 C 139.8331756591797 188.2937316894531 148.6616973876953 191.8318634033203 156.3601989746094 197.4614715576172 C 164.0587005615234 203.091064453125 171.1802520751953 212.441650390625 170.5265808105469 223.3094787597656 C 169.9205474853516 233.3689880371094 162.8651428222656 241.0900268554688 155.5636291503906 245.9337463378906 C 149.9187469482422 249.6771697998047 142.966552734375 253.7638397216797 142.2864227294922 261.5169677734375 C 141.6301116943359 269.0199279785156 147.4734497070312 274.8997497558594 153.0547943115234 278.2422180175781 C 171.2622985839844 289.1485290527344 193.6935119628906 289.0426940917969 211.8295593261719 277.96630859375 C 218.3000946044922 274.0143432617188 224.2493133544922 268.7600708007812 231.0347747802734 265.6806640625 C 248.853271484375 257.5939025878906 268.4845581054688 265.7351684570312 287.3510131835938 268.7119750976562 C 303.3709106445312 271.2261657714844 319.6415710449219 269.928466796875 335.2515869140625 264.8915405273438 C 344.5934448242188 261.869873046875 353.9724426269531 257.2507019042969 360.53564453125 248.6443176269531 C 365.2674255371094 242.4373474121094 368.2102661132812 234.5847625732422 370.9864196777344 226.8316345214844 C 373.9380798339844 218.5599212646484 376.7750549316406 210.23046875 379.4974060058594 201.84326171875 C 381.1328735351562 196.8071136474609 382.7419128417969 191.6746978759766 383.1626892089844 186.2856903076172 C 383.9275207519531 176.5245208740234 380.706787109375 166.8756103515625 376.3163452148438 158.6349182128906 C 365.8893737792969 139.0708160400391 348.3408508300781 125.3159942626953 329.3394165039062 121.82275390625 C 310.3379821777344 118.3295135498047 290.2276916503906 125.1588134765625 275.4870300292969 140.0844573974609" fill="#fca25d" fill-opacity="0.1" stroke="none" stroke-width="1" stroke-opacity="0.1" stroke-miterlimit="4" stroke-linecap="butt" /></svg>',
                allowDrawingOutsideViewBox: true,
              ),
              Positioned(
                left: 0,
                right: 0,
                top: 0,
                bottom: 0,
                child: SvgPicture.asset('assets/images/item1.svg'),
              ),
            ],
          ),
        ),
        SizedBox(
          height: 20.0,
        ),
        Text(
          'Connect in person',
          style: TextStyle(
            fontFamily: AppConstants.Poppins_Font,
            fontSize: 25,
            color: const Color(0xfffca25d),
            fontWeight: FontWeight.w600,
            height: 1.2,
          ),
          textAlign: TextAlign.center,
        ),
        SizedBox(
          height: 13.0,
        ),
        Text(
          'If you’re offered a seat on a rocket \nship, don’t ask what seat! Just get \non.',
          style: TextStyle(
            fontFamily: AppConstants.Poppins_Font,
            fontSize: 14,
            color: const Color(0x7555585a),
            height: 1.2,
          ),
          textAlign: TextAlign.center,
        )
      ],
    ),
    Column(

      mainAxisAlignment: MainAxisAlignment.center,
      children: <Widget>[

        Container(
          alignment: Alignment.center,
          padding: const EdgeInsets.symmetric(horizontal: 18),
          child: Stack(
            children: <Widget>[
              SvgPicture.string(
                '<svg viewBox="56.7 215.0 260.7 177.6" ><path transform="translate(-65.84, 106.34)" d="M 283.1061401367188 133.0338439941406 C 271.9169616699219 141.6113433837891 257.4039001464844 141.0531921386719 244.6877593994141 136.5944519042969 C 231.9716491699219 132.1356811523438 220.2875823974609 124.1836547851562 207.9022369384766 118.5348205566406 C 197.4985198974609 113.7965393066406 186.6361846923828 110.6960601806641 175.5813140869141 109.309326171875 C 159.7899780273438 107.3301391601562 142.1567535400391 109.7391662597656 131.1528472900391 123.6062469482422 C 118.8998413085938 139.0515441894531 119.8393402099609 166.9108734130859 133.0926971435547 181.0826873779297 C 139.8331756591797 188.2937316894531 148.6616973876953 191.8318634033203 156.3601989746094 197.4614715576172 C 164.0587005615234 203.091064453125 171.1802520751953 212.441650390625 170.5265808105469 223.3094787597656 C 169.9205474853516 233.3689880371094 162.8651428222656 241.0900268554688 155.5636291503906 245.9337463378906 C 149.9187469482422 249.6771697998047 142.966552734375 253.7638397216797 142.2864227294922 261.5169677734375 C 141.6301116943359 269.0199279785156 147.4734497070312 274.8997497558594 153.0547943115234 278.2422180175781 C 171.2622985839844 289.1485290527344 193.6935119628906 289.0426940917969 211.8295593261719 277.96630859375 C 218.3000946044922 274.0143432617188 224.2493133544922 268.7600708007812 231.0347747802734 265.6806640625 C 248.853271484375 257.5939025878906 268.4845581054688 265.7351684570312 287.3510131835938 268.7119750976562 C 303.3709106445312 271.2261657714844 319.6415710449219 269.928466796875 335.2515869140625 264.8915405273438 C 344.5934448242188 261.869873046875 353.9724426269531 257.2507019042969 360.53564453125 248.6443176269531 C 365.2674255371094 242.4373474121094 368.2102661132812 234.5847625732422 370.9864196777344 226.8316345214844 C 373.9380798339844 218.5599212646484 376.7750549316406 210.23046875 379.4974060058594 201.84326171875 C 381.1328735351562 196.8071136474609 382.7419128417969 191.6746978759766 383.1626892089844 186.2856903076172 C 383.9275207519531 176.5245208740234 380.706787109375 166.8756103515625 376.3163452148438 158.6349182128906 C 365.8893737792969 139.0708160400391 348.3408508300781 125.3159942626953 329.3394165039062 121.82275390625 C 310.3379821777344 118.3295135498047 290.2276916503906 125.1588134765625 275.4870300292969 140.0844573974609" fill="#fca25d" fill-opacity="0.1" stroke="none" stroke-width="1" stroke-opacity="0.1" stroke-miterlimit="4" stroke-linecap="butt" /></svg>',
                allowDrawingOutsideViewBox: true,
              ),
              Positioned(
                left: 0,
                right: 0,
                top: 0,
                bottom: 0,
                child: SvgPicture.asset('assets/images/item2.svg'),
              )
            ],
          ),
        ),
        SizedBox(
          height: 20.0,
        ),
        Text(
          'Intuitive Experience',
          style: TextStyle(
            fontFamily: AppConstants.Poppins_Font,
            fontSize: 25,
            color: const Color(0xfffca25d),
            fontWeight: FontWeight.w600,
            height: 1.2,
          ),
          textAlign: TextAlign.center,
        ),
        SizedBox(
          height: 13.0,
        ),
        Text(
          'If you’re offered a seat on a rocket \nship, don’t ask what seat! Just get \non.',
          style: TextStyle(
            fontFamily: AppConstants.Poppins_Font,
            fontSize: 14,
            color: const Color(0x7555585a),
            height: 1.2,
          ),
          textAlign: TextAlign.center,
        )
      ],
    ),
    Column(

      mainAxisAlignment: MainAxisAlignment.center,
      children: <Widget>[

        Container(
          alignment: Alignment.center,
          padding: const EdgeInsets.symmetric(horizontal: 18),
          child: Stack(
            children: <Widget>[
              SvgPicture.string(
                '<svg viewBox="56.7 215.0 260.7 177.6" ><path transform="translate(-65.84, 106.34)" d="M 283.1061401367188 133.0338439941406 C 271.9169616699219 141.6113433837891 257.4039001464844 141.0531921386719 244.6877593994141 136.5944519042969 C 231.9716491699219 132.1356811523438 220.2875823974609 124.1836547851562 207.9022369384766 118.5348205566406 C 197.4985198974609 113.7965393066406 186.6361846923828 110.6960601806641 175.5813140869141 109.309326171875 C 159.7899780273438 107.3301391601562 142.1567535400391 109.7391662597656 131.1528472900391 123.6062469482422 C 118.8998413085938 139.0515441894531 119.8393402099609 166.9108734130859 133.0926971435547 181.0826873779297 C 139.8331756591797 188.2937316894531 148.6616973876953 191.8318634033203 156.3601989746094 197.4614715576172 C 164.0587005615234 203.091064453125 171.1802520751953 212.441650390625 170.5265808105469 223.3094787597656 C 169.9205474853516 233.3689880371094 162.8651428222656 241.0900268554688 155.5636291503906 245.9337463378906 C 149.9187469482422 249.6771697998047 142.966552734375 253.7638397216797 142.2864227294922 261.5169677734375 C 141.6301116943359 269.0199279785156 147.4734497070312 274.8997497558594 153.0547943115234 278.2422180175781 C 171.2622985839844 289.1485290527344 193.6935119628906 289.0426940917969 211.8295593261719 277.96630859375 C 218.3000946044922 274.0143432617188 224.2493133544922 268.7600708007812 231.0347747802734 265.6806640625 C 248.853271484375 257.5939025878906 268.4845581054688 265.7351684570312 287.3510131835938 268.7119750976562 C 303.3709106445312 271.2261657714844 319.6415710449219 269.928466796875 335.2515869140625 264.8915405273438 C 344.5934448242188 261.869873046875 353.9724426269531 257.2507019042969 360.53564453125 248.6443176269531 C 365.2674255371094 242.4373474121094 368.2102661132812 234.5847625732422 370.9864196777344 226.8316345214844 C 373.9380798339844 218.5599212646484 376.7750549316406 210.23046875 379.4974060058594 201.84326171875 C 381.1328735351562 196.8071136474609 382.7419128417969 191.6746978759766 383.1626892089844 186.2856903076172 C 383.9275207519531 176.5245208740234 380.706787109375 166.8756103515625 376.3163452148438 158.6349182128906 C 365.8893737792969 139.0708160400391 348.3408508300781 125.3159942626953 329.3394165039062 121.82275390625 C 310.3379821777344 118.3295135498047 290.2276916503906 125.1588134765625 275.4870300292969 140.0844573974609" fill="#fca25d" fill-opacity="0.1" stroke="none" stroke-width="1" stroke-opacity="0.1" stroke-miterlimit="4" stroke-linecap="butt" /></svg>',
                allowDrawingOutsideViewBox: true,
              ),
              Positioned(
                left: 0,
                right: 0,
                top: 0,
                bottom: 0,
                child: SvgPicture.asset('assets/images/item3.svg'),
              )
            ],
          ),
        ),
        SizedBox(
          height: 20.0,
        ),
        Text(
          'Built For Everyone',
          style: TextStyle(
            fontFamily: AppConstants.Poppins_Font,
            fontSize: 25,
            color: const Color(0xfffca25d),
            fontWeight: FontWeight.w600,
            height: 2.2,
          ),
          textAlign: TextAlign.center,
        ),
        SizedBox(
          height: 13.0,
        ),
        Text(
          'If you’re offered a seat on a rocket \nship, don’t ask what seat! Just get \non.',
          style: TextStyle(
            fontFamily: AppConstants.Poppins_Font,
            fontSize: 14,
            color: const Color(0x7555585a),
            height: 1.2,
          ),
          textAlign: TextAlign.center,
        )
      ],
    )
  ];

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    var bttonWidth = (MediaQuery.of(context).size.width - 56) * 0.5;
    var cardHeigtht = MediaQuery.of(context).size.height - 260;
    print('bttonWidth$bttonWidth');
    Utils.hideKeyboard();
    return Scaffold(
      backgroundColor: ColorResources.app_primary_color,
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          children: <Widget>[
            SizedBox(
              height: 80,
            ),
            introScreen(cardHeigtht),
            SizedBox(height: 42),
            Container(
              child: SmoothPageIndicator(
                controller: controller,
                count: 3,
                effect: JumpingDotEffect(
                  dotColor: Colors.white.withOpacity(0.3),
                  activeDotColor: Colors.white,
                  dotHeight: 12.0,
                  dotWidth: 12.0,
                ),
              ),
            ),
            SizedBox(height: 30),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 24),
              child: Row(
                children: <Widget>[
                  CustomIntroButton(
                    text: StringResource.back,
                    bttonWidth: bttonWidth,
                    textColor: Color(0xffffffff),
                    bgColor: Colors.transparent,
                    callback: () {
                      controller.previousPage(
                          duration: Duration(seconds: 1), curve: Curves.ease);
                    },
                  ),
                  SizedBox(
                    width: 8,
                  ),
                  CustomIntroButton(
                    text: StringResource.next,
                    bttonWidth: bttonWidth,
                    bgColor: Color(0xfff5f7f9),
                    textColor: Color(0xfffca25d),
                    callback: () {
                      if (currenctIndex == 2) {
                        Utils.nextScreen(LoginScreen(), context);
                      } else {
                        controller.nextPage(
                            duration: Duration(seconds: 1), curve: Curves.ease);
                      }
                    },
                  ), // Adobe XD layer: 'bg' (shape)

                  // Adobe XD layer: 'bg' (shape)
                ],
              ),
            )
          ],
        ),
      ),
    );
  }



  button() {
    return // Adobe XD layer: 'btn-blue' (group)
        Container(
      alignment: Alignment.center,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(12.0),
        color: const Color(0xfff5f7f9),
      ),
      child: Text(
        'NEXT',
        style: TextStyle(
          fontFamily: 'Gibson',
          fontSize: 14,
          color: const Color(0xfffca25d),
          fontWeight: FontWeight.w600,
        ),
        textAlign: TextAlign.center,
      ),
    );
  }

  introScreen(double cardHeigtht) {
    return SizedBox(
      height: cardHeigtht,
      child: PageView(
        controller: controller,
        onPageChanged: (index) {
          currenctIndex = index;
        },
        children: List.generate(
            items.length,
            (_) => Card(
                  shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(16)),
                  margin: EdgeInsets.symmetric(horizontal: 10, vertical: 0),
                  child: Container(height: cardHeigtht, child: items[_]),
                )),
      ),
    );
  }
}
