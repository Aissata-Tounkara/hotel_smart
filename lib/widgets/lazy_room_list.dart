import 'package:flutter/widgets.dart';

import '../models/chambre.dart';

/// Construit les chambres uniquement lorsqu'elles entrent dans la zone visible.
class LazyRoomList extends StatelessWidget {
  const LazyRoomList({
    required this.rooms,
    required this.itemBuilder,
    this.padding,
    super.key,
  });

  final List<Chambre> rooms;
  final Widget Function(BuildContext context, Chambre room) itemBuilder;
  final EdgeInsetsGeometry? padding;

  @override
  Widget build(BuildContext context) => ListView.builder(
    padding: padding,
    itemCount: rooms.length,
    itemBuilder: (context, index) {
      final room = rooms[index];
      return KeyedSubtree(
        key: ValueKey('room-${room.id ?? room.numero}'),
        child: itemBuilder(context, room),
      );
    },
  );
}
