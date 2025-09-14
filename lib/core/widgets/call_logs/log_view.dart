import 'package:call_watcher/core/util/helper.dart';
import 'package:call_watcher/core/widgets/call_logs/log_icon.dart';
import 'package:call_watcher/data/models/call_log.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
// import 'dart:developer' as developer;

class LogView extends StatelessWidget {
  final CallLogRecord callLog;

  const LogView({super.key, required this.callLog});

  @override
  Widget build(BuildContext context) {
    final log = callLog;

    // Fallback for missing or whitespace-only name, and number
    final displayName = (log.name != null && log.name!.trim().isNotEmpty)
        ? log.name!.trim()
        : 'Unknown Person';
    final number = log.formattedNumber ?? 'Unknown';
    final sim = log.sim;
    // developer.log("Name:  ${log.name} , $displayName , number : $number");

    final recordType = log.type;
    final duration =
        log.duration != null ? '${log.duration}s' : 'Unknown duration';
    final timestamp = DateTime.fromMillisecondsSinceEpoch(log.date).toLocal();

    final String timeStr = DateFormat('HH:mm:ss').format(timestamp);
    final String dateStr = DateFormat('dd MMM').format(timestamp);
    return Container(
      padding: const EdgeInsets.fromLTRB(0, 12, 0, 0),
      margin: const EdgeInsets.symmetric(vertical: 8),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(8),
        border: Border.all(color: Colors.grey.shade200),
      ),
      child: Column(
        children: [
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 12),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.end,
              children: [
                LogIcon(callType: recordType),
                const SizedBox(width: 10),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text(
                            displayName,
                            style: const TextStyle(
                                fontWeight: FontWeight.normal, fontSize: 12),
                            overflow: TextOverflow.ellipsis,
                            maxLines: 1,
                          ),
                          if (sim != null)
                            Container(
                              padding: const EdgeInsets.symmetric(
                                horizontal: 8,
                                vertical: 4,
                              ),
                              decoration: BoxDecoration(
                                  color: Theme.of(context)
                                      .colorScheme
                                      .tertiary
                                      .withOpacity(0.5),
                                  borderRadius: BorderRadius.circular(4.0),
                                  border: Border.all(
                                    width: 0.2,
                                    color:
                                        Theme.of(context).colorScheme.secondary,
                                  )),
                              child: Text(
                                sim,
                                style: TextStyle(
                                  fontWeight: FontWeight.bold,
                                  fontSize: 12,
                                  color:
                                      Theme.of(context).colorScheme.secondary,
                                ),
                              ),
                            ),
                        ],
                      ),
                      Text(
                        number,
                        style: const TextStyle(
                            fontWeight: FontWeight.bold, fontSize: 18),
                        overflow: TextOverflow.ellipsis,
                        maxLines: 1,
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(
            height: 16,
          ),
          Container(
            padding: const EdgeInsets.fromLTRB(12, 12, 12, 12),
            decoration: BoxDecoration(
                color: Colors.grey.withOpacity(0.1),
                borderRadius: const BorderRadius.only(
                    bottomLeft: Radius.circular(8),
                    bottomRight: Radius.circular(8))),
            width: double.infinity,
            child: Wrap(
              alignment: WrapAlignment.spaceBetween,
              runAlignment: WrapAlignment.spaceBetween,
              crossAxisAlignment: WrapCrossAlignment.center,
              spacing: 16,
              runSpacing: 4,
              children: [
                Text(
                  "Duration: ${formatDuration(int.parse(duration.replaceAll("s", "")))}",
                  style: const TextStyle(fontSize: 13),
                ),
                Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Text(
                      "Date: $dateStr",
                      style: const TextStyle(fontSize: 13),
                    ),
                    const SizedBox(width: 8),
                    Text(
                      "Time: $timeStr",
                      style: const TextStyle(fontSize: 13),
                    ),
                  ],
                ),
              ],
            ),
          )
        ],
      ),
    );
  }
}
