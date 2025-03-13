import 'package:flutter/material.dart';

class MedicationScheduleScreen extends StatelessWidget {
  const MedicationScheduleScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Medication Schedule'),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () {
            Navigator.pop(context);
          },
        ),
        // actions: [
        //    ElevatedButton(
        //     onPressed: () {
        //     Navigator.pushNamed(context, '/device');
        //     },
        //     child: const Text('Add Prescription'),
        //   )
        //],
      ),
      body: Column(
        children: [
          // Day selector
          Container(
            padding: const EdgeInsets.symmetric(vertical: 16.0),
            decoration: BoxDecoration(
              color: Colors.white,
              border: Border(
                bottom: BorderSide(
                  color: Colors.grey[300]!,
                  width: 1,
                ),
              ),
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: List.generate(7, (index) {
                DateTime date = DateTime.now().add(Duration(days: index));
                String day =
                    ['S', 'M', 'T', 'W', 'T', 'F', 'S'][date.weekday % 7];
                bool isSelected = index == 0;
                return _buildDayCircle(day, date.day.toString(),
                    isSelected: isSelected);
              }),
            ),
          ),

          // Schedule timeline
          Expanded(
            child: ListView(
              padding: const EdgeInsets.all(0),
              children: [
                Stack(
                  children: [
                    Column(
                      children: [
                        _buildTimeSlot('7:00'),
                        _buildTimeSlot('8:00',
                            hasMedication: true, status: 'Skipped'),
                        _buildTimeSlot('9:00'),
                        _buildTimeSlot('10:00',
                            hasMedication: true, status: 'Taken'),
                        _buildTimeSlot('11:00'),
                        _buildTimeSlot('12:00', hasDoubleMedication: true),
                        _buildTimeSlot('13:00'),
                        _buildTimeSlot('14:00'),
                        _buildTimeSlot('15:00', hasMedication: true),
                        _buildTimeSlot('16:00'),
                      ],
                    ),
                  ],
                ),
              ],
              // children: [
              //   _buildTimeSlot('7:00'),
              //   _buildTimeSlot('8:00', hasMedication: true, status: 'Skipped'),
              //   _buildTimeSlot('9:00'),
              //   _buildTimeSlot('10:00', hasMedication: true, status: 'Taken'),
              //   _buildTimeSlot('11:00'),
              //   _buildTimeSlot('12:00', hasDoubleMedication: true),
              //   _buildTimeSlot('13:00'),
              //   _buildTimeSlot('14:00'),
              //   _buildTimeSlot('15:00', hasMedication: true),
              //   _buildTimeSlot('16:00'),
              // ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildDayCircle(String day, String date, {bool isSelected = false}) {
    return Container(
      width: 40,
      height: 40,
      decoration: BoxDecoration(
        shape: BoxShape.circle,
        color: isSelected ? const Color(0xFF344955) : Colors.grey[300],
      ),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Text(
            day,
            style: TextStyle(
              color: isSelected ? Colors.white : Colors.black,
              fontWeight: FontWeight.bold,
              fontSize: 14,
            ),
          ),
          Text(
            date,
            style: TextStyle(
              color: isSelected ? Colors.white : Colors.black,
              fontSize: 12,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildTimeSlot(String time,
      {bool hasMedication = false,
      bool hasDoubleMedication = false,
      String status = ''}) {
    return Container(
      height: hasDoubleMedication ? 100 : 70,
      decoration: BoxDecoration(
        border: Border(
          bottom: BorderSide(
            color: Colors.grey[300]!,
            width: 1,
          ),
        ),
      ),
      child: Row(
        children: [
          // Time column
          SizedBox(
            width: 50,
            child: Padding(
              padding: const EdgeInsets.symmetric(vertical: 8.0),
              child: Text(
                time,
                textAlign: TextAlign.center,
                style: const TextStyle(
                  fontWeight: FontWeight.w500,
                ),
              ),
            ),
          ),
          // Horizontal time line

          // Medication info
          Expanded(
            child: hasDoubleMedication
                ? Row(
                    children: [
                      Expanded(child: _buildMedicationItem()),
                      Expanded(child: _buildMedicationItem()),
                    ],
                  )
                : hasMedication
                    ? _buildMedicationItem(status: status)
                    : Container(),
          ),
        ],
      ),
    );
  }

  Widget _buildMedicationItem(
      {String status = '',
      String medicationName = 'Amoxicilline - 65 mg Tablet',
      String instructions = 'After Meal - 1 tablet'}) {
    return Container(
      margin: const EdgeInsets.all(8.0),
      padding: const EdgeInsets.symmetric(horizontal: 12.0, vertical: 8.0),
      decoration: BoxDecoration(
        color: Colors.grey[300],
        borderRadius: BorderRadius.circular(8),
      ),
      child: Row(
        children: [
          CircleAvatar(
            backgroundColor: Colors.white,
            radius: 15,
            child: Text(medicationName.isNotEmpty ? medicationName[0] : 'M',
                style: const TextStyle(color: Colors.black)),
          ),
          const SizedBox(width: 8),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(
                  medicationName,
                  style: const TextStyle(fontWeight: FontWeight.w500),
                  overflow: TextOverflow.ellipsis,
                ),
                Text(
                  instructions,
                  style: const TextStyle(fontSize: 12, color: Colors.black54),
                ),
              ],
            ),
          ),
          if (status.isNotEmpty)
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
              decoration: BoxDecoration(
                color: status == 'Taken' ? Colors.green[100] : Colors.red[100],
                borderRadius: BorderRadius.circular(4),
              ),
              child: Text(
                status,
                style: TextStyle(
                  color:
                      status == 'Taken' ? Colors.green[800] : Colors.red[800],
                  fontSize: 12,
                ),
              ),
            ),
        ],
      ),
    );
  }
}
