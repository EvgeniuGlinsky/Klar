import 'package:equatable/equatable.dart';

class TaskList extends Equatable {
  const TaskList({
    required this.id,
    required this.name,
    required this.colorKey,
    required this.iconKey,
    this.sortOrder = 0,
  });

  static const inboxId = 'inbox';

  final String id;
  final String name;
  final String colorKey;
  final String iconKey;
  final int sortOrder;

  bool get isInbox => id == inboxId;

  TaskList copyWith({String? name, String? colorKey, String? iconKey, int? sortOrder}) => TaskList(
    id: id,
    name: name ?? this.name,
    colorKey: colorKey ?? this.colorKey,
    iconKey: iconKey ?? this.iconKey,
    sortOrder: sortOrder ?? this.sortOrder,
  );

  @override
  List<Object?> get props => [id, name, colorKey, iconKey, sortOrder];
}
