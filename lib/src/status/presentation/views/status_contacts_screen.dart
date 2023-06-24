import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:whatsapp/core/common/views/loading_screen.dart';
import 'package:whatsapp/core/common/widgets/global_tile.dart';
import 'package:whatsapp/src/status/controller/status_controller.dart';
import 'package:whatsapp/src/status/models/status.dart';
import 'package:whatsapp/src/status/presentation/status_time.dart';
import 'package:whatsapp/src/status/presentation/views/status_view.dart';

class StatusContactsScreen extends ConsumerStatefulWidget {
  const StatusContactsScreen({
    super.key,
  });

  @override
  ConsumerState<StatusContactsScreen> createState() =>
      _StatusContactsScreenState();
}

class _StatusContactsScreenState extends ConsumerState<StatusContactsScreen> {
  late Stream<List<Status>> statusStream;

  @override
  void initState() {
    super.initState();
    statusStream = ref.read(statusControllerProvider).getStatus(context);
  }

  @override
  Widget build(BuildContext context) {
    return StreamBuilder<List<Status>>(
      stream: statusStream,
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const LoadingScreen();
        }
        if (!snapshot.hasData || snapshot.data!.isEmpty) {
          return const Text('No status available');
        }

        // Create statuses list and copyWith nextStatus, the next status and
        // null if there is no next status
        final statuses = <Status>[];
        for (var i = 0; i < snapshot.data!.length; i++) {
          final sortedStatuses = snapshot.data!
            ..sort((a, b) => b.updatedAt.compareTo(a.updatedAt));
          final status = sortedStatuses[i];
          final nextStatus =
              i + 1 < snapshot.data!.length ? snapshot.data![i + 1] : null;
          statuses.add(status.copyWith(nextStatus: nextStatus));
        }

        return ListView.builder(
          itemCount: snapshot.data!.length,
          itemBuilder: (context, index) {
            final status = statuses[index];
            return Container(
              margin: index == 0 ? const EdgeInsets.only(top: 10) : null,
              child: GlobalTile(
                profileImage: status.profilePic,
                titleWidget: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      status.username,
                      style: const TextStyle(
                        fontSize: 18,
                      ),
                    ),
                    const SizedBox(height: 4),
                    StatusTime(time: status.updatedAt),
                  ],
                ),
                onTap: () {
                  Navigator.pushNamed(
                    context,
                    StatusView.id,
                    arguments: status,
                  );
                },
              ),
            );
          },
        );
      },
    );
  }
}
