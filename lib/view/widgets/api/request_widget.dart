import 'package:btt/tools/response.dart';
import 'package:btt/view/widgets/dialog/error_dialog.dart';
import 'package:flutter/material.dart';

// ignore: must_be_immutable
class RequestWidget<T> extends StatefulWidget {
  Future<Response<T?>> request;
  final Widget Function(T data) successWidgetBuilder;
  final Widget Function(String error)? failWidgetBuilder;
  final Widget Function(double progress, bool retrying)? loadingWidgetBuilder;
  final bool? showErrorDialog;
  final List<ErrorActionType>? errorActions;

  RequestWidget({
    Key? key,
    required this.request,
    required this.successWidgetBuilder,
    this.failWidgetBuilder,
    this.loadingWidgetBuilder,
    this.showErrorDialog,
    this.errorActions,
  }) : super(key: key);

  @override
  State<RequestWidget> createState() => _RequestWidgetState<T>();
}

class _RequestWidgetState<T> extends State<RequestWidget<T>> {
  final bool _isRetrying = false;
  late Future<Response<T?>> _request;

  @override
  Widget build(BuildContext context) {
    _request = widget.request;
    return FutureBuilder<Response<T?>>(
      future: _request,
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return Center(
            child: widget.loadingWidgetBuilder?.call(0, _isRetrying) ?? const CircularProgressIndicator(),
          );
        } else if (snapshot.hasError || (snapshot.data?.data == null && snapshot.connectionState == ConnectionState.done)) {
          if (widget.showErrorDialog ?? true) {
            WidgetsBinding.instance.addPostFrameCallback((_) {
              showDialog(
                context: context,
                builder: (context) => ErrorDialog(
                  title: 'Error!',
                  message: snapshot.error.toString(),
                ),
              );
            });
          }

          if (widget.errorActions != null && widget.errorActions!.contains(ErrorActionType.autoRetry)) {
            WidgetsBinding.instance.addPostFrameCallback((_) {
              setState(() {});
            });
          }

          return widget.failWidgetBuilder != null ? widget.failWidgetBuilder!(snapshot.error.toString()) : const SizedBox();
        } else if (snapshot.hasData) {
          final T? nullableData = snapshot.data?.data;
          if (nullableData == null) {
            return widget.failWidgetBuilder != null ? widget.failWidgetBuilder!('An unknown error occurred.') : const SizedBox();
          }
          final T data = nullableData;
          return widget.successWidgetBuilder(data);
        } else {
          return const SizedBox();
        }
      },
    );
  }
}

class ErrorAction {
  final ErrorActionType type;
  final void Function()? action;

  const ErrorAction({
    required this.type,
    this.action,
  });
}

enum ErrorActionType {
  retry, // Renders on fail widget and dialog
  autoRetry, // Doesn't render
  openWifiSettings, // Renders on fail widget and dialog
  contactSupport, // Renders on fail widget and dialog
  sendLogs, // Doesn't render
  close, // Renders on dialog
}
