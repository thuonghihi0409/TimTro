import 'package:flutter/material.dart';
import 'package:timtro/Model/User.dart';



class CreateAppointmentScreen extends StatefulWidget {
  final User lanklord;

  const CreateAppointmentScreen({super.key, required this.lanklord});
  @override
  _CreateAppointmentScreenState createState() =>
      _CreateAppointmentScreenState();
}

class _CreateAppointmentScreenState extends State<CreateAppointmentScreen> {
  final _formKey = GlobalKey<FormState>();
  DateTime? _selectedDate;
  TimeOfDay? _selectedTime;
  String _status = 'Pending';
  String _result = '';
  String _customerName = 'John Doe';
  String _landlordName = 'Jane Smith';

  // Hàm chọn ngày
  Future<void> _selectDate(BuildContext context) async {
    final DateTime picked = await showDatePicker(
      context: context,
      initialDate: _selectedDate ?? DateTime.now(),
      firstDate: DateTime(2000),
      lastDate: DateTime(2101),
    ) ?? _selectedDate!;

    if (picked != null && picked != _selectedDate) {
      setState(() {
        _selectedDate = picked;
      });
    }
  }

  // Hàm chọn giờ
  Future<void> _selectTime(BuildContext context) async {
    final TimeOfDay picked = await showTimePicker(
      context: context,
      initialTime: _selectedTime ?? TimeOfDay.now(),
    ) ?? _selectedTime!;

    if (picked != null && picked != _selectedTime) {
      setState(() {
        _selectedTime = picked;
      });
    }
  }

  // Hàm lưu cuộc hẹn (ví dụ đơn giản)
  void _saveAppointment() {
    if (_formKey.currentState!.validate()) {
      // Xử lý lưu cuộc hẹn ở đây
      final String appointmentDate =
          '${_selectedDate!.toLocal()} ${_selectedTime!.format(context)}';
      print('Cuộc hẹn được tạo: $appointmentDate');
      print('Trạng thái: $_status');
      print('Kết quả: $_result');
      // Bạn có thể gửi dữ liệu này đến server hoặc lưu vào cơ sở dữ liệu
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Tạo Cuộc Hẹn'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Form(
          key: _formKey,
          child: ListView(
            children: [
              // Hiển thị tên khách hàng và chủ trọ
              Text('Khách hàng: $_customerName', style: TextStyle(fontSize: 18)),
              SizedBox(height: 10),
              Text('Chủ trọ: $_landlordName', style: TextStyle(fontSize: 18)),
              SizedBox(height: 20),

              // Chọn ngày
              GestureDetector(
                onTap: () => _selectDate(context),
                child: AbsorbPointer(
                  child: TextFormField(
                    decoration: InputDecoration(
                      labelText: 'Chọn ngày',
                      hintText: _selectedDate != null
                          ? _selectedDate.toString().split(' ')[0]
                          : 'Chưa chọn ngày',
                      border: OutlineInputBorder(),
                    ),
                    validator: (value) {
                      if (_selectedDate == null) {
                        return 'Vui lòng chọn ngày';
                      }
                      return null;
                    },
                  ),
                ),
              ),
              SizedBox(height: 20),

              // Chọn giờ
              GestureDetector(
                onTap: () => _selectTime(context),
                child: AbsorbPointer(
                  child: TextFormField(
                    decoration: InputDecoration(
                      labelText: 'Chọn giờ',
                      hintText: _selectedTime != null
                          ? _selectedTime!.format(context)
                          : 'Chưa chọn giờ',
                      border: OutlineInputBorder(),
                    ),
                    validator: (value) {
                      if (_selectedTime == null) {
                        return 'Vui lòng chọn giờ';
                      }
                      return null;
                    },
                  ),
                ),
              ),
              SizedBox(height: 20),

              // Trạng thái cuộc hẹn
              DropdownButtonFormField<String>(
                value: _status,
                decoration: InputDecoration(labelText: 'Trạng thái'),
                items: ['Pending', 'Completed', 'Canceled']
                    .map((status) => DropdownMenuItem<String>(
                  value: status,
                  child: Text(status),
                ))
                    .toList(),
                onChanged: (value) {
                  setState(() {
                    _status = value!;
                  });
                },
              ),
              SizedBox(height: 20),

              // Kết quả cuộc hẹn
              TextFormField(
                decoration: InputDecoration(
                  labelText: 'Kết quả',
                  border: OutlineInputBorder(),
                ),
                onChanged: (value) {
                  setState(() {
                    _result = value;
                  });
                },
              ),
              SizedBox(height: 20),

              // Nút lưu cuộc hẹn
              ElevatedButton(
                onPressed: _saveAppointment,
                child: Text('Lưu Cuộc Hẹn'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

