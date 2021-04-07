import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';

import 'package:app/utils/app_constants.dart';
class CustomButton extends StatelessWidget {
  VoidCallback buttonClickCallback;
  String buttonTitle;

  CustomButton({this.buttonClickCallback, this.buttonTitle});

  @override
  Widget build(BuildContext context) {
    return Material(
      color: Colors.transparent,
      shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.all(Radius.circular(12.0))),
      child: InkWell(
        onTap: () {
          buttonClickCallback();
        },
        child:  Container(
          width: MediaQuery.of(context).size.width,
          padding: EdgeInsets.symmetric(vertical: 13,),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(6.0),
            color: const Color(0xfffca25d),
            boxShadow: [
              BoxShadow(
                color: const Color(0x66fca25d),
                offset: Offset(0, 5),
                blurRadius: 10,
              ),
            ],
          ),
          child:  Text(
            '$buttonTitle',
            style: TextStyle(
              fontFamily: AppConstants.Poppins_Font,
              fontSize: 18,
              color: const Color(0xffffffff),
              fontWeight: FontWeight.w700,
            ),
            textAlign: TextAlign.center,
          ),
        ),
      ),
    );
  }
}

backButton(BuildContext context,{VoidCallback callback}) {
  return SizedBox(
    width: 60,
    height: 60,
    child: Padding(
      padding: const EdgeInsets.symmetric(horizontal: 12),
      child: IconButton(

        icon: SvgPicture.string(
          '<svg viewBox="183.0 53.2 16.0 13.5" ><path transform="translate(-1408.3, 70.92)" d="M 1597.54052734375 -4.398300170898438 L 1591.66162109375 -10.27815341949463 C 1591.44482421875 -10.40956783294678 1591.299926757812 -10.64773464202881 1591.299926757812 -10.91970062255859 C 1591.299926757812 -11.0578145980835 1591.337158203125 -11.18709850311279 1591.402099609375 -11.29819774627686 C 1591.435546875 -11.3597240447998 1591.478271484375 -11.41757774353027 1591.530395507812 -11.46960067749023 C 1591.55517578125 -11.49447441101074 1591.581298828125 -11.51720523834229 1591.608520507812 -11.53786087036133 L 1597.54052734375 -17.46990013122559 C 1597.833984375 -17.76239967346191 1598.308227539062 -17.76239967346191 1598.601684570312 -17.46990013122559 C 1598.894165039062 -17.17650032043457 1598.894165039062 -16.70219993591309 1598.601684570312 -16.40880012512207 L 1593.862426757812 -11.67030048370361 L 1606.550415039062 -11.67030048370361 C 1606.964477539062 -11.67030048370361 1607.300170898438 -11.3346004486084 1607.300170898438 -10.91970062255859 C 1607.300170898438 -10.50570011138916 1606.964477539062 -10.17000007629395 1606.550415039062 -10.17000007629395 L 1593.890380859375 -10.17000007629395 L 1598.601684570312 -5.459400177001953 C 1598.894165039062 -5.165999889373779 1598.894165039062 -4.691699981689453 1598.601684570312 -4.398300170898438 C 1598.454956054688 -4.252049922943115 1598.263061523438 -4.178925037384033 1598.071044921875 -4.178925037384033 C 1597.879150390625 -4.178925037384033 1597.687255859375 -4.252049922943115 1597.54052734375 -4.398300170898438 Z" fill="#454f63" stroke="none" stroke-width="1" stroke-miterlimit="4" stroke-linecap="butt" /></svg>',
          allowDrawingOutsideViewBox: true,
          fit: BoxFit.fill,
        ),
        iconSize: 16.0,
        onPressed: (){
          if(callback==null)
          Navigator.pop(context);
          else
            callback();
        },
      ),
    ),
  );
}
