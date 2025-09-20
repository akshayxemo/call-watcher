import 'package:call_watcher/core/util/helper.dart';
import 'package:call_watcher/core/widgets/call_logs/log_icon.dart';
import 'package:call_watcher/data/models/call_log.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class AdminLogView extends StatelessWidget {
  final CallLogRecord callLog;
  const AdminLogView({super.key, required this.callLog});

  @override
  Widget build(BuildContext context) {
    final log = callLog;

    // Fallback for missing or whitespace-only name, and number
    final displayName =
        (log.userName != null && log.userName!.trim().isNotEmpty)
            ? log.userName!.trim()
            : 'Unknown Employee (id: ${log.userId})';
    final number = log.formattedNumber ?? log.number;
    // developer.log("Name:  ${log.name} , $displayName , number : $number");
    final recordType = log.type;
    final duration =
        log.duration != null ? '${log.duration}s' : 'Unknown duration';
    final timestamp = DateTime.fromMillisecondsSinceEpoch(log.date).toLocal();

    final String timeStr = DateFormat('hh:mm:ss aa').format(timestamp);
    final String dateStr = DateFormat('dd MMM').format(timestamp);

    return Container(
      padding: const EdgeInsets.fromLTRB(0, 14, 0, 14),
      margin: const EdgeInsets.symmetric(vertical: 8),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(8),
        border: Border.all(color: Colors.grey.shade200),
      ),
      child: Column(
        children: [
          Padding(
            padding: const EdgeInsets.symmetric(
              horizontal: 18,
            ),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.end,
              children: [
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        mainAxisSize: MainAxisSize.max,
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text(
                            "From $displayName",
                            style: const TextStyle(
                              fontWeight: FontWeight.normal,
                              fontSize: 13,
                            ),
                            overflow: TextOverflow.ellipsis,
                            maxLines: 1,
                          ),
                          Text(
                            formatDuration(int.parse(duration.replaceAll("s", ""))),
                            style: const TextStyle(
                              fontSize: 12,
                            ),
                          ),
                        ],
                      ),
                      Text(
                        number,
                        style: const TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: 16,
                        ),
                        overflow: TextOverflow.ellipsis,
                        maxLines: 1,
                      ),
                      SizedBox(
                        height: 20,
                        child:
                            Divider(height: 0.1, color: Colors.grey.shade200),
                      ),
                      SizedBox(
                        width: double.infinity,
                        child: Wrap(
                          alignment: WrapAlignment.spaceBetween,
                          runAlignment: WrapAlignment.spaceBetween,
                          crossAxisAlignment: WrapCrossAlignment.center,
                          spacing: 8,
                          // runSpacing: 4,
                          children: [
                            Row(
                              mainAxisSize: MainAxisSize.min,
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                LogIcon(
                                  callType: recordType,
                                  iconSize: 16.0,
                                ),
                                const SizedBox(
                                  width: 5,
                                ),
                                Text(
                                  recordType.name.characters.first.toUpperCase() + recordType.name.substring(1),
                                  style: const TextStyle(
                                    fontWeight: FontWeight.normal,
                                    fontSize: 12,
                                  ),
                                  overflow: TextOverflow.ellipsis,
                                  maxLines: 1,
                                ),
                              ],
                            ),
                            const Text(
                              "•",
                              style: TextStyle(
                                fontSize: 12,
                                color: Colors.grey,
                              ),
                            ),
                            Text(
                              dateStr,
                              style: const TextStyle(
                                fontSize: 12,
                              ),
                            ),
                            const Text(
                              "•",
                              style: TextStyle(
                                fontSize: 12,
                                color: Colors.grey,
                              ),
                            ),
                            Text(
                              timeStr,
                              style: const TextStyle(
                                fontSize: 12,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
