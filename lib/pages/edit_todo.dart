import 'package:flutter/material.dart';
import 'package:todo_list/component/date_field_group.dart';
import 'package:todo_list/component/label_group.dart';
import 'package:todo_list/component/location_field_group.dart';
import 'package:todo_list/component/prority_field_group.dart';
import 'package:todo_list/component/time_filed_group.dart';
import 'package:todo_list/const/route_argument.dart';
import 'package:todo_list/const/route_url.dart';
import 'package:todo_list/extension/date_time.dart';
import 'package:todo_list/extension/time_of_day.dart';
import 'package:todo_list/model/todo.dart';

const TextStyle _labelTextStyle = TextStyle(
  color: Color(0xFF1D1D26),
  fontFamily: 'Avenir',
  fontSize: 14.0,
);
const EdgeInsets _labelPadding = const EdgeInsets.fromLTRB(20, 10, 20, 20);
const InputBorder _textFormBorder = UnderlineInputBorder(
  borderSide: BorderSide(
    color: Colors.black26,
    width: 0.5,
  ),
);

class EditTodoPage extends StatefulWidget {
  const EditTodoPage({Key key}) : super(key: key);

  @override
  _EditTodoPageState createState() => _EditTodoPageState();
}

class _EditTodoPageState extends State<EditTodoPage> {
  OpenType _openType;
  Todo _todo;

  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  Map<OpenType, _OpenTypeConfig> _openTypeConfigMap;

  final TextEditingController _dateTextEditingController =
      TextEditingController();
  final TextEditingController _startTimeTextEditingController =
      TextEditingController();
  final TextEditingController _endTimeTextEditingController =
      TextEditingController();
  final TextEditingController _locationTextEditingController =
      TextEditingController();

  @override
  void initState() {
    super.initState();

    _openTypeConfigMap = {
      OpenType.Preview: _OpenTypeConfig('查看TODO', Icons.edit, _edit),
      OpenType.Edit: _OpenTypeConfig('编辑TODO', Icons.check, _submit),
      OpenType.Add: _OpenTypeConfig('添加TODO', Icons.check, _submit),
    };
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    EditTodoPageArgument arguments = ModalRoute.of(context).settings.arguments;
    _openType = arguments.openType;
    _todo = arguments.todo ?? Todo();
    _dateTextEditingController.text = _todo.date.dateString;
    _startTimeTextEditingController.text = _todo.startTime.timeString;
    _endTimeTextEditingController.text = _todo.endTime.timeString;
    _locationTextEditingController.text = _todo.location.description;
  }

  @override
  void dispose() {
    super.dispose();
    _dateTextEditingController.dispose();
    _startTimeTextEditingController.dispose();
    _endTimeTextEditingController.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(_openTypeConfigMap[_openType].title),
        backgroundColor: Colors.white,
        centerTitle: true,
        actions: <Widget>[
          IconButton(
            icon: Icon(
              _openTypeConfigMap[_openType].icon,
              color: Colors.black87,
            ),
            onPressed: _openTypeConfigMap[_openType].onPressed,
          ),
        ],
      ),
      body: _buildForm(),
    );
  }

  Widget _buildForm() {
    bool canEdit = _openType != OpenType.Preview;
    return SingleChildScrollView(
      child: IgnorePointer(
        ignoring: !canEdit,
        child: GestureDetector(
          behavior: HitTestBehavior.translucent,
          onTap: () {
            FocusScope.of(context).unfocus();
          },
          child: Form(
            key: _formKey,
            child: Column(
              children: <Widget>[
                _buildTextFormField(
                  '名称',
                  '任务名称',
                  maxLines: 1,
                  initialValue: _todo.title,
                  onSaved: (value) => _todo.title = value,
                ),
                _buildTextFormField(
                  '描述',
                  '任务描述',
                  initialValue: _todo.description,
                  onSaved: (value) => _todo.description = value,
                ),
                _buildDateFormField(
                  '日期',
                  '请选择日期',
                  initialValue: _todo.date,
                  controller: _dateTextEditingController,
                  onSelect: (value) {
                    _todo.date = value.dayTime;
                    _dateTextEditingController.text = _todo.date.dateString;
                  },
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: <Widget>[
                    Expanded(
                      child: _buildTimeFormField(
                        '开始时间',
                        '请选择开始时间',
                        initialValue: _todo.startTime,
                        controller: _startTimeTextEditingController,
                        onSelect: (value) {
                          _todo.startTime = value;
                          _startTimeTextEditingController.text =
                              _todo.startTime.timeString;
                        },
                      ),
                    ),
                    Expanded(
                      child: _buildTimeFormField(
                        '终止时间',
                        '请选择终止时间',
                        initialValue: _todo.endTime,
                        controller: _endTimeTextEditingController,
                        onSelect: (value) {
                          _todo.endTime = value;
                          _endTimeTextEditingController.text =
                              _todo.endTime.timeString;
                        },
                      ),
                    ),
                  ],
                ),
                _buildPriorityFormField(
                  '优先级',
                ),
                _buildLocationFormField(
                  '位置',
                  '点击以保存当前位置',
                  controller: _locationTextEditingController,
                  onSaved: (Location location) {
                    _todo.location = location;
                    _locationTextEditingController.text = location.description;
                  },
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildTextFormField(
    String title,
    String hintText, {
    int maxLines,
    String initialValue,
    FormFieldSetter<String> onSaved,
  }) {
    TextInputType inputType =
        maxLines == null ? TextInputType.multiline : TextInputType.text;
    return LabelGroup(
      labelText: title,
      labelStyle: _labelTextStyle,
      padding: _labelPadding,
      child: TextFormField(
        keyboardType: inputType,
        validator: (String value) {
          return value.length > 0 ? null : '$title 不能为空';
        },
        onSaved: onSaved,
        textInputAction: TextInputAction.done,
        maxLines: maxLines,
        initialValue: initialValue,
        decoration: InputDecoration(
          hintText: hintText,
          enabledBorder: _textFormBorder,
        ),
      ),
    );
  }

  Widget _buildDateFormField(
    String title,
    String hintText, {
    DateTime initialValue,
    TextEditingController controller,
    Function(DateTime) onSelect,
  }) {
    DateTime now = DateTime.now();
    return LabelGroup(
      labelText: title,
      labelStyle: _labelTextStyle,
      padding: _labelPadding,
      child: DateFieldGroup(
        onSelect: onSelect,
        child: TextFormField(
          controller: controller,
          decoration: InputDecoration(
            hintText: hintText,
            disabledBorder: _textFormBorder,
          ),
          validator: (String value) {
            return value == null ? '$title 不能为空' : null;
          },
        ),
        initialDate: initialValue,
        startDate: initialValue ?? DateTime(now.year, now.month, now.day - 1),
        endDate: DateTime(2025),
      ),
    );
  }

  Widget _buildTimeFormField(
    String title,
    String hintText, {
    TextEditingController controller,
    TimeOfDay initialValue,
    Function(TimeOfDay) onSelect,
  }) {
    return LabelGroup(
      labelText: title,
      labelStyle: _labelTextStyle,
      padding: _labelPadding,
      child: TimeFieldGroup(
        onSelect: onSelect,
        child: TextFormField(
          validator: (String value) {
            return value.length > 0 ? null : '$title 不能为空';
          },
          controller: controller,
          decoration: InputDecoration(
            hintText: hintText,
            disabledBorder: _textFormBorder,
          ),
        ),
        initialTime: initialValue,
      ),
    );
  }

  Widget _buildPriorityFormField(
    String title, {
    TextEditingController textController,
    Function(Priority) onSaved,
  }) {
    return LabelGroup(
      labelText: title,
      labelStyle: _labelTextStyle,
      padding: _labelPadding,
      child: PriorityFieldGroup(
        initialValue: _todo.priority,
        onChange: (Priority priority) {
          setState(() {
            _todo.priority = priority;
          });
        },
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            Container(
              padding: const EdgeInsets.fromLTRB(0, 10, 0, 10),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: <Widget>[
                  Container(
                    child: Text(_todo.priority.description),
                  ),
                  Container(
                    width: 100,
                    height: 50,
                    alignment: Alignment.center,
                    child: Container(
                      width: 100,
                      height: 5,
                      color: _todo.priority.color,
                    ),
                  ),
                ],
              ),
            ),
            Divider(
              height: 1,
              thickness: 1,
              color: Colors.black26,
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildLocationFormField(
    String title,
    String hintText, {
    TextEditingController controller,
    Function(Location) onSaved,
  }) {
    return LabelGroup(
      labelText: title,
      labelStyle: _labelTextStyle,
      padding: _labelPadding,
      child: GestureDetector(
        child: LocationFieldGroup(
          onChange: onSaved,
          child: TextFormField(
            keyboardType: TextInputType.text,
            textInputAction: TextInputAction.done,
            controller: controller,
            decoration: InputDecoration(
              hintText: hintText,
              enabledBorder: _textFormBorder,
            ),
          ),
        ),
        onLongPress: () {
          Navigator.of(context).pushNamed(
            LOCATION_DETAIL_PAGE_URL,
            arguments: LocationDetailArgument(_todo.location),
          );
        },
      ),
    );
  }

  void _edit() {
    setState(() {
      _openType = OpenType.Edit;
    });
  }

  void _submit() {
    if (_formKey.currentState.validate()) {
      _formKey.currentState.save();
      Navigator.of(context).pop(_todo);
    }
  }
}

class _OpenTypeConfig {
  final String title;
  final IconData icon;
  final Function onPressed;

  const _OpenTypeConfig(this.title, this.icon, this.onPressed);
}
