import 'package:event/event.dart';

class GroupItemMovedToOtherGroup extends EventArgs {
  final String fromGroupId;
  final int fromIndex;
  final String toGroupId;
  final int toIndex;

  GroupItemMovedToOtherGroup(this.fromGroupId, this.fromIndex, this.toGroupId, this.toIndex);
}