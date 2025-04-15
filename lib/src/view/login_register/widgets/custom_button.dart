import 'package:flutter/material.dart';

class CustomButton extends StatelessWidget {
  const CustomButton({
    super.key,
    this.height,
    this.width,
    this.color,
    this.borderRadius,
    this.boxShadow,
    this.decorationImage,
    this.buttonimage,
    this.border,
    this.gradient,
    this.shape,
    this.backgroundBlendMode,
    required this.child,
    this.margin,
    this.padding,
    this.alignment,
    this.clipBehavior,
    this.constrains,
    this.transformAlignment,
    this.foregroundDecoration,
    required this.onpress,
    this.leading,
    this.trailing,
    this.decoration,
  });
  final double? height, width;
  final Color? color;
  final BorderRadius? borderRadius;
  final List<BoxShadow>? boxShadow;
  final DecorationImage? decorationImage;
  final Border? border;
  final Gradient? gradient;
  final BoxShape? shape;
  final BlendMode? backgroundBlendMode;
  final Widget child;
  final Widget? leading, trailing;
  final EdgeInsetsGeometry? margin, padding;
  final AlignmentGeometry? alignment;
  final Clip? clipBehavior;
  final BoxConstraints? constrains;
  final AlignmentGeometry? transformAlignment;
  final Decoration? foregroundDecoration;
  final VoidCallback onpress;
  final Image? buttonimage;
  final BoxDecoration? decoration;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onpress,
      child: Container(
        // color: color ?? buttonColor,
        height: height ?? 50,
        width: width ?? 50,
        margin: margin,
        alignment: alignment,
        clipBehavior: clipBehavior ?? Clip.none,
        constraints: constrains,
        padding: padding,
        transformAlignment: transformAlignment,
        foregroundDecoration: foregroundDecoration,
        decoration: BoxDecoration(
          color: color ?? Colors.green,
          borderRadius: borderRadius ?? BorderRadius.circular(50),
          boxShadow: boxShadow,
          image: decorationImage,
          border: border,
          gradient: gradient,
          shape: shape ?? BoxShape.rectangle,
          backgroundBlendMode: backgroundBlendMode,
        ),
        child: Center(
          child: Container(
            decoration: decoration,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                SizedBox(
                  height: 50,
                  child: Row(children: [leading ?? SizedBox()]),
                ),
                child,
                SizedBox(
                  height: 50,
                  child: Row(
                    children: [
                      trailing ?? SizedBox(),
                      buttonimage ?? SizedBox(),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
