import '../utils/all_imports.dart';

class CommonButton extends StatelessWidget {
  final Function()? onTap;
  final Color? backGroundColor;
  final Color? fontColor;
  final Color? borderColor;
  final String? buttonTitle;
  final IconData? sufixIcon;
  final bool? isSufixIcon;
  final FontWeight? fontWeight;
  final double? fontSize;
  final double? borderRadius;

  const CommonButton({
    super.key,
    this.backGroundColor,
    this.buttonTitle,
    this.onTap,
    this.fontSize,
    this.fontWeight,
    this.sufixIcon,
    this.fontColor,
    this.borderRadius,
    this.borderColor,
    this.isSufixIcon = false,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        // padding: EdgeInsets.symmetric(vertical: 12.h),
        width: double.infinity,
        height: 59.h,
        color: AppColors.lightYellow,

        alignment: Alignment.center,
        child: Center(
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
             Text(
                buttonTitle ?? "",
                textAlign: TextAlign.center,

              ),
              isSufixIcon!
                  ? Padding(
                      padding: EdgeInsets.only(right: 3.w),
                      child: Icon(
                        sufixIcon!,
                        size: 11.w,
                        color: AppColors.white,
                      ),
                    )
                  : Container(),
            ],
          ),
        ),
      ),
    );
  }
}
