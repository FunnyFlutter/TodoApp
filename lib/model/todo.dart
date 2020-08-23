import 'package:flutter/material.dart';
import 'package:todo_list/extension/date_time.dart';
import 'package:uuid/uuid.dart';

const String ID = 'id';
const String TITLE = 'title';
const String DESCRIPTION = 'description';
const String DATE = 'date';
const String START_TIME = 'start_time';
const String END_TIME = 'end_time';
const String PRIORITY = 'priority';
const String IS_FINISHED = 'is_finished';
const String IS_STAR = 'is_star';
const String LOCATION_LATITUDE = 'location_latitude';
const String LOCATION_LONGITUDE = 'location_longitude';
const String LOCATION_DESCRIPTION = 'location_description';

timeOfDayToString(TimeOfDay timeOfDay) => '${timeOfDay.hour}:${timeOfDay.minute}';
timeOfDayFromString(String string) {
  return TimeOfDay(
    hour: int.parse(string.split(':').first),
    minute: int.parse(string.split(':').last),
  );
}

class Priority {
  ///  优先级对应的数值，如 0
  final int value;

  ///  优先级对应的文字描述，如“非常重要”
  final String description;

  ///  优先级对应的颜色，如红色
  final Color color;

  const Priority._(this.value, this.description, this.color);

  ///  重载==运算符
  ///  如果两个 Priority 对象的 value 相等，则它们相等；
  ///  如果一个 Priority 对象的 value 和一个整型值相等，则它们相等
  @override
  bool operator ==(other) =>
      other is Priority && other.value == value || other == value;

  ///  重载==运算符必须同时重载 hashCode
  @override
  int get hashCode => value;

  ///  判断当前 Priority 对象是否比另一个 Priority 对象更加重要，
  ///  这里的逻辑就是，谁的 value 值更小，谁的优先级就更高
  bool isHigher(Priority other) => other != null && other.value > value;

  ///  支持用整型值创建 Priority 对象
  factory Priority(int priority) =>
      values.firstWhere((e) => e.value == priority, orElse: () => Low);

  ///  下面定义了允许用户使用的4个枚举值
  static const Priority High = Priority._(0, '高优先级', Color(0xFFE53B3B));
  static const Priority Medium = Priority._(1, '中优先级', Color(0xFFFF9400));
  static const Priority Low = Priority._(2, '低优先级', Color(0xFF14D4F4));
  static const Priority Unspecific = Priority._(3, '无优先级', Color(0xFF50D2C2));

  static const List<Priority> values = [
    High,
    Medium,
    Low,
    Unspecific,
  ];
}

class Location {
  /// 纬度
  final double latitude;

  /// 经度
  final double longitude;

  /// 地点描述
  final String description;

  /// 默认的构造器
  const Location({this.longitude = 0, this.latitude = 0, this.description = ''});

  /// 命名构造器，用于构造只有描述信息的 Location 对象
  Location.fromDescription(this.description)
      : latitude = 0,
        longitude = 0;
}

class Todo {
  /// ID
  final String id;

  /// 标题
  String title;

  /// 描述
  String description;

  /// 日期
  DateTime date;

  /// 开始时间
  TimeOfDay startTime;

  /// 结束时间
  TimeOfDay endTime;

  /// 优先级
  Priority priority;

  /// 是否完成
  bool isFinished;

  /// 是否星标任务
  bool isStar;

  /// 任务所关联的位置
  Location location;

  String get timeString {
    String dateString = date.compareTo(DateTime.now()) == 0
        ? 'today'
        : '${date.year}/${date.month}/${date.day}';
    if (startTime == null || endTime == null) {
      return dateString;
    }
    return '$dateString ${startTime.hour}:${startTime.minute} - ${endTime.hour}:${endTime.minute}';
  }

  Todo({
    String id,
    this.title = "",
    this.description = "",
    this.date,
    this.startTime = const TimeOfDay(hour: 0, minute: 0),
    this.endTime = const TimeOfDay(hour: 0, minute: 0),
    this.priority = Priority.Unspecific, //优先级越小优先级越高
    this.isFinished = false,
    this.isStar = false,
    this.location = const Location(),
  }) : this.id = id ?? generateNewId() {
    // 如果开始时间为空，则设置为当前时间
    if (date == null) {
      date = DateTime.now().dayTime;
    }
  }

  static Uuid _uuid = Uuid();

  static String generateNewId() => _uuid.v1();

  TodoStatus get status {
    if (isFinished) {
      return TodoStatus.finished;
    }
    if (date != null && date.isBefore(DateTime.now())) {
      return TodoStatus.delay;
    }
    return TodoStatus.unspecified;
  }

  Map<String, dynamic> toMap() {
    return {
      ID: id,
      TITLE: title,
      DESCRIPTION: description,
      DATE: date.millisecondsSinceEpoch.toString(),
      START_TIME: timeOfDayToString(startTime),
      END_TIME: timeOfDayToString(endTime),
      PRIORITY: priority.value,
      IS_FINISHED: isFinished ? 1 : 0,
      IS_STAR: isStar ? 1 : 0,
      LOCATION_LATITUDE: location?.latitude?.toString() ?? '0',
      LOCATION_LONGITUDE: location?.latitude?.toString() ?? '0',
      LOCATION_DESCRIPTION: location?.description ?? '',
    };
  }

  static Todo fromMap(Map<String, dynamic> map) {
    return Todo(
      id: map[ID],
      title: map[TITLE],
      description: map[DESCRIPTION],
      date: DateTime.fromMillisecondsSinceEpoch(int.parse(map[DATE])),
      startTime: timeOfDayFromString(map[START_TIME]),
      endTime: timeOfDayFromString(map[END_TIME]),
      priority: Priority.values.firstWhere((p) => p.value == map[PRIORITY]),
      isFinished: map[IS_FINISHED] == 1 ? true : false,
      isStar: map[IS_STAR] == 1 ? true : false,
      location: Location(
        longitude: double.parse(map[LOCATION_LONGITUDE]),
        latitude: double.parse(map[LOCATION_LONGITUDE]),
        description: map[LOCATION_DESCRIPTION],
      ),
    );
  }
}

class TodoStatus {
  /// 完成状态对应的数值，如 0
  final int value;

  /// 完成状态对应的文字描述，如“已完成”
  final String description;

  /// 完成状态对应的颜色，如红色
  final Color color;

  const TodoStatus._(this.value, this.description, this.color);

  /// 下面定义了允许用户使用的4个枚举值
  static const TodoStatus unspecified =
      TodoStatus._(0, '未安排', const Color(0xff8c88ff));
  static const TodoStatus finished = TodoStatus._(1, '已完成', const Color(0xff51d2c2));
  static const TodoStatus delay = TodoStatus._(2, '已延期', const Color(0xffffb258));

  static const List<TodoStatus> values = [
    unspecified,
    finished,
    delay,
  ];
}
