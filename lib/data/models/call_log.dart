import 'package:call_log/call_log.dart';
import 'package:call_watcher/core/config/enum.dart';
import 'package:call_watcher/core/util/helper.dart';

class CallLogRecord {
  final int? id;
  final String? name;
  final String number;
  final String? formattedNumber;
  final String? sim;
  final CallRecordType type;
  final int date;
  final int? duration;

  CallLogRecord({
    this.id,
    this.name,
    required this.number,
    this.formattedNumber,
    required this.sim,
    required this.type,
    required this.date,
    this.duration,
  });

  // Factory constructor to create CallLogRecord from Map
  factory CallLogRecord.fromMap(Map<String, dynamic> map) {
    return CallLogRecord(
      id: map['id'] as int?,
      name: map['name'] as String?,
      number: map['number'] as String,
      formattedNumber: map['formattedNumber'] as String?,
      sim: map['sim'] as String?,
      type: CallRecordType.values.firstWhere(
        (e) => e.name == map['type'],
        orElse: () => CallRecordType.incoming, // default value
      ),
      date: map['date'] as int,
      duration: map['duration'],
    );
  }

  // Factory constructor to create CallLogRecord from CallLogEntry
  factory CallLogRecord.fromCallLogEntry(CallLogEntry log) {
    return CallLogRecord(
      number: log.number ?? "",
      name: log.name,
      formattedNumber:log.formattedNumber,
      sim: log.simDisplayName,
      type: mapToRecordType(log.callType),
      date: log.timestamp ?? 0,
      duration: log.duration,
    );
  }

  // Convert CallLogRecord to Map (useful for database operations)
  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'number': number,
      'name': name,
      'formattedNumber': formattedNumber,
      'sim': sim,
      'type': type.name,
      'date': date,
      'duration': duration,
    };
  }
  // Convert CallLogRecord to Map (useful for database operations)
  Map<String, dynamic> toMapWithoutId() {
    return {
      'number': number,
      'name': name,
      'formattedNumber': formattedNumber,
      'sim': sim,
      'type': type.name,
      'date': date,
      'duration': duration,
    };
  }
}
