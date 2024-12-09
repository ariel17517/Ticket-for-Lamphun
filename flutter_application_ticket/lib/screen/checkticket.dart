import 'package:flutter/material.dart';
import 'package:flutter_application_ticket/controller/checkticketnoController.dart';
import 'package:flutter_application_ticket/screen/qrscan.dart';
import 'package:shared_preferences/shared_preferences.dart';

class CheckTicketScreen extends StatefulWidget {
  const CheckTicketScreen({super.key});

  @override
  State<CheckTicketScreen> createState() => _CheckTicketScreenState();
}

class _CheckTicketScreenState extends State<CheckTicketScreen> {
  final TextEditingController _ticketController = TextEditingController();
  String? scanResult;
  Map<String, String> _ticketDetails = {
    'เลขที่ตั๋ว': '-',
    'สถานะ': '-',
    'ชื่อรายการแข่งขัน': '-',
    'วันที่': '-',
    'โซนที่นั่ง': '-',
  };

  bool _isScanning = false;

  void _scanQRCode() async {
    if (_isScanning) return;
    _isScanning = true;

    await Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => QRScanScreen(
          onDetect: (barcode) {
            Navigator.pop(context);
            setState(() {
              scanResult = barcode.rawValue;
              _ticketController.text = scanResult ?? '';
            });
            _onScanComplete(scanResult);
          },
        ),
      ),
    );

    _isScanning = false;
  }

  void _onScanComplete(String? scannedResult) {
    if (scannedResult == null || scannedResult.isEmpty) {
      setState(() {
        _ticketDetails = {
          'เลขที่ตั๋ว': '-',
          'สถานะ': '-',
          'ชื่อรายการแข่งขัน': '-',
          'วันที่': '-',
          'โซนที่นั่ง': '-',
        };
      });
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('หมายเลขตั๋วไม่ถูกต้อง หรือ QR Code ไม่ถูกต้อง'),
        ),
      );
      return;
    }
    _fetchTicketDetails(scannedResult);
  }

  void _fetchTicketDetails(String ticketNo) async {
    setState(() {
      _ticketDetails = {
        'เลขที่ตั๋ว': '-',
        'สถานะ': '-',
        'ชื่อรายการแข่งขัน': '-',
        'วันที่': '-',
        'โซนที่นั่ง': '-',
      };
    });

    final controller = CheckTicketNoController();
    try {
      final prefs = await SharedPreferences.getInstance();
      final String? token = prefs.getString('authToken');

      if (token == null) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('ไม่พบ token หรือ token หมดอายุ')),
        );
        return;
      }

      final details =
          await controller.checkTicket(ticketNo: ticketNo, token: token);
      if (details.isNotEmpty) {
        setState(() {
          _ticketDetails = details;
        });
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('ไม่พบข้อมูลตั๋ว')),
        );
      }
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('หมายเลขตั๋วไม่ถูกต้อง')),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color.fromARGB(255, 244, 248, 255),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Center(
              child: Text(
                'หมายเลขตั๋ว',
                style: TextStyle(
                  fontSize: 25,
                  fontWeight: FontWeight.bold,
                  color: Colors.black,
                ),
                textAlign: TextAlign.center,
              ),
            ),
            const SizedBox(height: 30),
            const Text(
              'หมายเลขตั๋ว',
              style: TextStyle(
                fontSize: 17,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 10),
            Row(
              children: [
                Expanded(
                  flex: 1,
                  child: TextField(
                    controller: _ticketController,
                    style: const TextStyle(fontSize: 14),
                    decoration: InputDecoration(
                      hintText: 'กรอกหมายเลขตั๋ว',
                      hintStyle: const TextStyle(fontSize: 14),
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(20),
                      ),
                      filled: true,
                      fillColor: Colors.white,
                      contentPadding: const EdgeInsets.symmetric(
                          vertical: 16, horizontal: 16),
                      suffixIcon: IconButton(
                        icon: const Icon(Icons.qr_code_scanner),
                        onPressed: _scanQRCode,
                      ),
                    ),
                  ),
                ),
                const SizedBox(width: 8),
                SizedBox(
                  height: 50,
                  child: ElevatedButton(
                    onPressed: () {
                      setState(() {
                        if (_ticketController.text.isNotEmpty) {
                          _fetchTicketDetails(_ticketController.text);
                        } else {
                          _ticketDetails = {
                            'เลขที่ตั๋ว': '-',
                            'สถานะ': '-',
                            'ชื่อรายการแข่งขัน': '-',
                            'วันที่': '-',
                            'โซนที่นั่ง': '-',
                          };
                          ScaffoldMessenger.of(context).showSnackBar(
                            const SnackBar(
                                content: Text('กรุณากรอกหมายเลขตั๋ว')),
                          );
                        }
                      });
                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: const Color.fromARGB(255, 95, 138, 192),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(8),
                      ),
                    ),
                    child: const Text(
                      'ตรวจสอบ',
                      style: TextStyle(fontSize: 14, color: Colors.white),
                    ),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 40),
            const Center(
              child: Text(
                'ผลการค้นหา',
                style: TextStyle(
                  fontSize: 22,
                  fontWeight: FontWeight.bold,
                  color: Colors.black,
                ),
                textAlign: TextAlign.center,
              ),
            ),
            const SizedBox(height: 20),
            buildRow('เลขที่ตั๋ว', _ticketDetails['เลขที่ตั๋ว']!),
            const SizedBox(height: 10),
            buildRow('สถานะ', _ticketDetails['สถานะ']!),
            const SizedBox(height: 10),
            buildRow('ชื่อรายการแข่งขัน', _ticketDetails['ชื่อรายการแข่งขัน']!),
            const SizedBox(height: 10),
            buildRow('วันที่', _ticketDetails['วันที่']!),
            const SizedBox(height: 10),
            buildRow('โซนที่นั่ง', _ticketDetails['โซนที่นั่ง']!),
          ],
        ),
      ),
    );
  }

  Widget buildRow(String leftText, String rightText) {
    return Row(
      children: [
        Expanded(
          flex: 2,
          child: Text(
            leftText,
            style: const TextStyle(
              fontSize: 15,
              color: Colors.black,
            ),
          ),
        ),
        Expanded(
          flex: 1,
          child: Text(
            rightText,
            textAlign: TextAlign.end,
            style: const TextStyle(
              fontSize: 15,
              color: Colors.black,
              fontWeight: FontWeight.bold,
            ),
          ),
        ),
      ],
    );
  }
}
