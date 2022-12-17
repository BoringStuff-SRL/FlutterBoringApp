import 'package:flutter/material.dart';

class BoringDrawerEntry {
  BoringDrawerEntry(this.label,
      {required this.path, this.icon, this.subEntries});
  String label;
  Icon? icon;
  String path;
  List<BoringDrawerEntry>? subEntries;
}
