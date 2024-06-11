import 'package:flutter/material.dart';
import 'package:loading_animation_widget/loading_animation_widget.dart';

showWaitDialog(
    BuildContext context, Function(BuildContext) onAlertContextBuilt) {
  var theme = Theme.of(context);

  showDialog(
    context: context,
    builder: (context) {
      onAlertContextBuilt(context);
      return WillPopScope(
        onWillPop: () async => false,
        child: Container(
          color: Colors.grey.withAlpha(50),
          child: Center(
            child: Container(
              decoration: BoxDecoration(
                  color: Colors.white, borderRadius: BorderRadius.circular(20)),
              child: Padding(
                padding: const EdgeInsets.all(16),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    LoadingAnimationWidget.fourRotatingDots(
                        color: theme.primaryColor, size: 48),
                    const SizedBox(height: 16,),
                    Text("بیمرزان",
                        style: theme.textTheme.titleLarge!
                            .copyWith(color: theme.primaryColor, fontSize: 28))
                  ],
                ),
              ),
            ),
          ),
        ),
      );
    },
  );
}
