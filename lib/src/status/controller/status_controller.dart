import 'dart:io';

import 'package:flutter/widgets.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:whatsapp/core/utils/utils.dart';
import 'package:whatsapp/src/status/models/status.dart';
import 'package:whatsapp/src/status/repository/status_repository.dart';

final statusControllerProvider = Provider(
  (ref) => StatusController(
    ref.read(statusRepositoryProvider),
  ),
);

class StatusController {
  const StatusController(this._statusRepository);

  final StatusRepository _statusRepository;

  void showLoadingDialog(
    BuildContext context, {
    String? loadingMessage,
  }) {
    Utils.showLoadingDialog(context: context, loadingMessage: loadingMessage);
  }

  Future<void> uploadStatus({
    required BuildContext context,
    required File statusImage,
  }) async {
    final navigator = Navigator.of(context);
    showLoadingDialog(context, loadingMessage: 'Uploading status...');
    await _statusRepository.uploadStatus(
      context: context,
      statusImage: statusImage,
    );
    navigator.pop();
  }

  Stream<List<Status>> getStatus(BuildContext context) =>
      _statusRepository.getStatus(context);
}
