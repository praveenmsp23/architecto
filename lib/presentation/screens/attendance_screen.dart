import 'package:flutter/cupertino.dart';
import 'package:intl/intl.dart';
import 'package:architecto/config/theme_config.dart';
import 'package:architecto/data/models/enums.dart';

class AttendanceScreen extends StatefulWidget {
  const AttendanceScreen({Key? key}) : super(key: key);

  @override
  State<AttendanceScreen> createState() => _AttendanceScreenState();
}

class _AttendanceScreenState extends State<AttendanceScreen> {
  late DateTime _selectedDate;
  late List<DateTime> _dates;
  late List<MockAttendanceRecord> _mockAttendanceData;

  @override
  void initState() {
    super.initState();
    _selectedDate = DateTime.now();
    _generateDates();
    _generateMockData();
  }

  void _generateMockData() {
    _mockAttendanceData = [
      MockAttendanceRecord(
        id: '1',
        organizationId: 'org123',
        laborId: 'lab001',
        laborName: 'John Smith',
        role: ConstructionRole.mason,
        date: DateTime.now(),
        status: AttendanceStatus.present,
        notes: 'Completed wall section on east wing',
        markedById: 'supervisor001',
        markedByName: 'Site Manager',
        createdAt: DateTime.now().subtract(const Duration(hours: 10)),
      ),
      MockAttendanceRecord(
        id: '2',
        organizationId: 'org123',
        laborId: 'lab002',
        laborName: 'Sarah Johnson',
        role: ConstructionRole.electrician,
        date: DateTime.now(),
        status: AttendanceStatus.halfDay,
        notes: 'Left early due to doctor appointment',
        markedById: 'supervisor001',
        markedByName: 'Site Manager',
        createdAt: DateTime.now().subtract(const Duration(hours: 6)),
      ),
      MockAttendanceRecord(
        id: '3',
        organizationId: 'org123',
        laborId: 'lab003',
        laborName: 'Michael Chen',
        role: ConstructionRole.carpenter,
        date: DateTime.now(),
        status: AttendanceStatus.absent,
        notes: 'Called in sick',
        markedById: 'supervisor001',
        markedByName: 'Site Manager',
        createdAt: DateTime.now().subtract(const Duration(hours: 9)),
      ),
      MockAttendanceRecord(
        id: '4',
        organizationId: 'org123',
        laborId: 'lab004',
        laborName: 'Priya Patel',
        role: ConstructionRole.supervisor,
        date: DateTime.now(),
        status: AttendanceStatus.present,
        notes: 'Stayed late to complete project documentation',
        markedById: 'admin001',
        markedByName: 'Project Manager',
        createdAt: DateTime.now().subtract(const Duration(hours: 10)),
      ),
      MockAttendanceRecord(
        id: '5',
        organizationId: 'org123',
        laborId: 'lab005',
        laborName: 'David Wilson',
        role: ConstructionRole.helper,
        date: DateTime.now(),
        status: AttendanceStatus.present,
        notes: '',
        markedById: 'supervisor001',
        markedByName: 'Site Manager',
        createdAt: DateTime.now().subtract(const Duration(hours: 8)),
      ),
    ];
  }

  void _generateDates() {
    _dates = [];
    final today = DateTime.now();
    _dates.add(today);
    for (int i = 1; i <= 30; i++) {
      _dates.add(today.subtract(Duration(days: i)));
    }
  }

  void _selectDate(DateTime date) {
    setState(() {
      _selectedDate = date;
    });
  }

  void _openDatePicker() {
    showCupertinoModalPopup(
      context: context,
      builder: (BuildContext context) {
        return Container(
          height: 300,
          color: CupertinoTheme.of(context).scaffoldBackgroundColor,
          child: Column(
            children: [
              Container(
                height: 50,
                padding: const EdgeInsets.symmetric(horizontal: 16),
                alignment: Alignment.centerRight,
                decoration: BoxDecoration(
                  border: Border(
                    bottom: BorderSide(
                      color: CupertinoTheme.of(context).barBackgroundColor,
                      width: 0.5,
                    ),
                  ),
                ),
                child: CupertinoButton(
                  padding: EdgeInsets.zero,
                  child: Text(
                    'Done',
                    style: CupertinoTheme.of(context).textTheme.actionTextStyle,
                  ),
                  onPressed: () => Navigator.of(context).pop(),
                ),
              ),
              Expanded(
                child: CupertinoDatePicker(
                  initialDateTime: _selectedDate,
                  maximumDate: DateTime.now(),
                  minimumDate: DateTime(2020),
                  mode: CupertinoDatePickerMode.date,
                  onDateTimeChanged: (DateTime value) {
                    setState(() {
                      _selectedDate = value;
                    });
                  },
                ),
              ),
            ],
          ),
        );
      },
    );
  }

  String _getDateText(DateTime date) {
    final now = DateTime.now();
    if (date.year == now.year &&
        date.month == now.month &&
        date.day == now.day) {
      return 'Today';
    }

    final yesterday = now.subtract(const Duration(days: 1));
    if (date.year == yesterday.year &&
        date.month == yesterday.month &&
        date.day == yesterday.day) {
      return 'Yesterday';
    }

    return '${date.day} ${DateFormat('MMM').format(date)}';
  }

  @override
  Widget build(BuildContext context) {
    final theme = CupertinoTheme.of(context);
    final colorScheme = CupertinoTheme.of(context).primaryColor;
    final textStyle = theme.textTheme.textStyle;

    return CupertinoPageScaffold(
      child: SafeArea(
        child: Column(
          children: [
            Container(
              padding: const EdgeInsets.symmetric(vertical: 12),
              child: SingleChildScrollView(
                scrollDirection: Axis.horizontal,
                child: Row(
                  children: [
                    const SizedBox(width: 16),
                    ...List.generate(_dates.length, (index) {
                      final date = _dates[index];
                      final isSelected = _selectedDate.year == date.year &&
                          _selectedDate.month == date.month &&
                          _selectedDate.day == date.day;

                      return Padding(
                        padding: const EdgeInsets.only(right: 8),
                        child: GestureDetector(
                          onTap: () => _selectDate(date),
                          child: Container(
                            padding: const EdgeInsets.symmetric(
                                horizontal: 20, vertical: 10),
                            decoration: BoxDecoration(
                              color: isSelected
                                  ? colorScheme
                                  : CupertinoColors.transparent,
                              borderRadius: BorderRadius.circular(30),
                              border: isSelected
                                  ? null
                                  : Border.fromBorderSide(
                                      ThemeConfig.standardBorder(context)),
                            ),
                            child: Text(
                              _getDateText(date),
                              style: textStyle.copyWith(
                                color: isSelected
                                    ? CupertinoColors.white
                                    : ThemeConfig.iconSecondaryColor(context),
                                fontWeight: FontWeight.w500,
                              ),
                            ),
                          ),
                        ),
                      );
                    }),
                    Padding(
                      padding: const EdgeInsets.only(right: 16, left: 8),
                      child: GestureDetector(
                        onTap: _openDatePicker,
                        child: Container(
                          padding: const EdgeInsets.symmetric(
                              horizontal: 20, vertical: 10),
                          decoration: BoxDecoration(
                            color: CupertinoColors.transparent,
                            borderRadius: BorderRadius.circular(30),
                            border: Border.fromBorderSide(
                                ThemeConfig.standardBorder(context)),
                          ),
                          child: Icon(
                            CupertinoIcons.settings,
                            color: ThemeConfig.iconSecondaryColor(context),
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
            Expanded(
              child: ListView.builder(
                padding: const EdgeInsets.symmetric(horizontal: 16),
                itemCount: _mockAttendanceData.length,
                itemBuilder: (context, index) {
                  return AttendanceCard(attendance: _mockAttendanceData[index]);
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class MockAttendanceRecord {
  final String id;
  final String organizationId;
  final String laborId;
  final String laborName;
  final ConstructionRole role;
  final DateTime date;
  final AttendanceStatus status;
  final String? notes;
  final String markedById;
  final String markedByName;
  final DateTime createdAt;

  MockAttendanceRecord({
    required this.id,
    required this.organizationId,
    required this.laborId,
    required this.laborName,
    required this.role,
    required this.date,
    required this.status,
    this.notes,
    required this.markedById,
    required this.markedByName,
    required this.createdAt,
  });
}

class AttendanceCard extends StatelessWidget {
  final MockAttendanceRecord attendance;

  const AttendanceCard({Key? key, required this.attendance}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final theme = CupertinoTheme.of(context);
    final colorScheme = CupertinoTheme.of(context).primaryColor;
    final statusColor = _getStatusColor(attendance.status);

    return Container(
      margin: const EdgeInsets.only(bottom: 8),
      decoration: BoxDecoration(
        color: CupertinoTheme.of(context).scaffoldBackgroundColor,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: CupertinoColors.systemGrey.withAlpha(10),
            blurRadius: 8,
            spreadRadius: 0,
            offset: const Offset(0, 3),
          ),
        ],
        border: Border.fromBorderSide(ThemeConfig.standardBorder(context)),
      ),
      child: Column(
        children: [
          // Employee info section with status badge integrated
          Container(
            padding: const EdgeInsets.fromLTRB(12, 10, 12, 6),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                // Employee avatar with gradient background
                Container(
                  width: 42,
                  height: 42,
                  decoration: BoxDecoration(
                    gradient: LinearGradient(
                      begin: Alignment.topLeft,
                      end: Alignment.bottomRight,
                      colors: [
                        theme.textTheme.textStyle.color!.withAlpha(40),
                        theme.textTheme.textStyle.color!.withAlpha(15),
                      ],
                    ),
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Center(
                    child: Text(
                      attendance.laborName.substring(0, 1).toUpperCase(),
                      style: theme.textTheme.textStyle.copyWith(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                        color: theme.textTheme.textStyle.color,
                      ),
                    ),
                  ),
                ),
                const SizedBox(width: 12),
                // Employee details
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        attendance.laborName,
                        style: theme.textTheme.textStyle.copyWith(
                          fontWeight: FontWeight.bold,
                          fontSize: 16,
                        ),
                      ),
                      const SizedBox(height: 2),
                      Text(
                        _getRoleText(attendance.role),
                        style: theme.textTheme.textStyle.copyWith(
                          fontSize: 13,
                          color: CupertinoColors.systemGrey,
                        ),
                      ),
                    ],
                  ),
                ),
                // Status badge
                Container(
                  padding:
                      const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
                  decoration: BoxDecoration(
                    color: statusColor.withAlpha(26),
                    borderRadius: BorderRadius.circular(4),
                  ),
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      Container(
                        width: 6,
                        height: 6,
                        decoration: BoxDecoration(
                          color: statusColor,
                          shape: BoxShape.circle,
                        ),
                      ),
                      const SizedBox(width: 4),
                      Text(
                        _getStatusText(attendance.status),
                        style: theme.textTheme.textStyle.copyWith(
                          fontSize: 13,
                          fontWeight: FontWeight.w500,
                          color: statusColor,
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),

          // Divider
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 12),
            child: Container(
              height: 1.2,
              color: ThemeConfig.borderColor(context),
            ),
          ),

          // Date and details section
          Padding(
            padding: const EdgeInsets.fromLTRB(12, 10, 12, 10),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Date row with icon
                Row(
                  children: [
                    Container(
                      width: 24,
                      height: 24,
                      decoration: BoxDecoration(
                        color: colorScheme.withAlpha(26), // 10% opacity
                        borderRadius: BorderRadius.circular(6),
                      ),
                      child: Icon(
                        CupertinoIcons.calendar,
                        size: 14,
                        color: colorScheme,
                      ),
                    ),
                    const SizedBox(width: 8),
                    Text(
                      DateFormat('EEEE, MMM dd, yyyy').format(attendance.date),
                      style: theme.textTheme.textStyle.copyWith(
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                  ],
                ),

                // Notes section if available
                if (attendance.notes != null &&
                    attendance.notes!.isNotEmpty) ...[
                  const SizedBox(height: 12),
                  Container(
                    width: double.infinity,
                    child: IntrinsicHeight(
                      child: Row(
                        crossAxisAlignment: CrossAxisAlignment.stretch,
                        children: [
                          Container(
                            width: 3,
                            decoration: BoxDecoration(
                              color: colorScheme,
                              borderRadius: BorderRadius.circular(2),
                            ),
                          ),
                          const SizedBox(width: 10),
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Row(
                                  children: [
                                    Text(
                                      'Notes',
                                      style: theme.textTheme.textStyle.copyWith(
                                        fontWeight: FontWeight.w600,
                                        fontSize: 13,
                                        color: colorScheme,
                                      ),
                                    ),
                                  ],
                                ),
                                const SizedBox(height: 4),
                                Text(
                                  attendance.notes!,
                                  style: theme.textTheme.textStyle.copyWith(
                                    fontSize: 14,
                                    height: 1.4,
                                    color: CupertinoTheme.of(context)
                                        .textTheme
                                        .textStyle
                                        .color,
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ],
              ],
            ),
          ),

          // Footer section redesigned
          Container(
            padding: const EdgeInsets.fromLTRB(12, 0, 12, 10),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Row(
                  children: [
                    Icon(
                      CupertinoIcons.person_fill,
                      size: 12,
                      color: CupertinoColors.systemGrey,
                    ),
                    const SizedBox(width: 4),
                    Text(
                      attendance.markedByName,
                      style: theme.textTheme.textStyle.copyWith(
                        fontSize: 12,
                        color: CupertinoColors.systemGrey,
                      ),
                    ),
                  ],
                ),
                Row(
                  children: [
                    Icon(
                      CupertinoIcons.time,
                      size: 12,
                      color: CupertinoColors.systemGrey,
                    ),
                    const SizedBox(width: 4),
                    Text(
                      DateFormat('hh:mm a').format(attendance.createdAt),
                      style: theme.textTheme.textStyle.copyWith(
                        fontSize: 12,
                        color: CupertinoColors.systemGrey,
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  String _getStatusText(AttendanceStatus status) {
    switch (status) {
      case AttendanceStatus.present:
        return 'Present';
      case AttendanceStatus.absent:
        return 'Absent';
      case AttendanceStatus.halfDay:
        return 'Half Day';
      case AttendanceStatus.leave:
        return 'On Leave';
      case AttendanceStatus.holiday:
        return 'Holiday';
    }
  }

  String _getRoleText(ConstructionRole role) {
    switch (role) {
      case ConstructionRole.mason:
        return 'Mason';
      case ConstructionRole.carpenter:
        return 'Carpenter';
      case ConstructionRole.electrician:
        return 'Electrician';
      case ConstructionRole.plumber:
        return 'Plumber';
      case ConstructionRole.painter:
        return 'Painter';
      case ConstructionRole.helper:
        return 'Helper';
      case ConstructionRole.operator:
        return 'Operator';
      case ConstructionRole.supervisor:
        return 'Supervisor';
      case ConstructionRole.welder:
        return 'Welder';
      case ConstructionRole.other:
        return 'Other';
    }
  }

  Color _getStatusColor(AttendanceStatus status) {
    switch (status) {
      case AttendanceStatus.present:
        return CupertinoColors.activeGreen;
      case AttendanceStatus.absent:
        return CupertinoColors.systemRed;
      case AttendanceStatus.halfDay:
        return CupertinoColors.systemOrange;
      case AttendanceStatus.leave:
        return CupertinoColors.systemBlue;
      case AttendanceStatus.holiday:
        return CupertinoColors.systemPurple;
    }
  }
}
