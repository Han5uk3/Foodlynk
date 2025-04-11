import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class ShowCalendar extends StatefulWidget {
  final bool isEdit;
  final bool restrictBackDates;
  final DateTime initialDate;
  final Function(DateTime) onDatePicked;

  const ShowCalendar({
    super.key,
    required this.isEdit,
    required this.restrictBackDates,
    required this.initialDate,
    required this.onDatePicked,
  });

  @override
  State<ShowCalendar> createState() => _ShowCalendarState();
}

class _ShowCalendarState extends State<ShowCalendar> {
  late DateTime _selectedDate;

  @override
  void initState() {
    super.initState();
    _selectedDate = widget.initialDate;
  }

  Future<void> _pickDate() async {
    if (widget.isEdit) return;

    DateTime? pickedDate = await showDatePicker(
      context: context,
      initialDate: _selectedDate,
      firstDate: widget.restrictBackDates ? DateTime.now() : DateTime(2000),
      lastDate: DateTime(2100),
      barrierDismissible: false,
      builder: (context, child) {
        return Theme(
          data: Theme.of(context).copyWith(
            colorScheme: ColorScheme.light(
              primary: Colors.green,
              surface: Colors.white,
            ),
          ),
          child: child!,
        );
      },
    );

    if (pickedDate != null && pickedDate != _selectedDate) {
      setState(() {
        _selectedDate = pickedDate;
      });
      widget.onDatePicked(pickedDate);
    }
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: _pickDate,
      child: Container(
        height: 50,
        padding: const EdgeInsets.symmetric(horizontal: 12),
        decoration: BoxDecoration(
          border: Border.all(color: Colors.grey.shade300),
          borderRadius: BorderRadius.all(Radius.circular(8)),
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              DateFormat('dd/MM/yyyy').format(_selectedDate),
              style: TextStyle(fontSize: 16, color: Colors.black),
            ),
            IconButton(
              onPressed: widget.isEdit ? null : _pickDate,
              icon: Icon(Icons.calendar_month_outlined, color: Colors.black),
            ),
          ],
        ),
      ),
    );
  }
}
