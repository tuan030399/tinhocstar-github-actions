import 'package:flutter/material.dart';
import 'package:qltinhoc/google_sheets_api.dart';
import 'package:qltinhoc/ocr_helper.dart' as ocr; // Thêm 'as ocr' để dùng key

class JobScreen extends StatefulWidget {
  final Map<String, String>? job;
  final VoidCallback onSave;
  final List<String> userList; // <-- THÊM
  final List<String> sellerList; // <-- THÊM

  const JobScreen({
    super.key,
    this.job,
    required this.onSave,
    this.userList = const [], // <-- THÊM
    this.sellerList = const [], // <-- THÊM
  });

  @override
  State<JobScreen> createState() => _JobScreenState();
}

class _JobScreenState extends State<JobScreen> {
  final _formKey = GlobalKey<FormState>();
  final Map<String, TextEditingController> _controllers = {};
  bool _isLoading = false;
  bool _isOcrLoading = false;

  // State cho dropdown
  String? _selectedNguoiLam;
  String? _selectedNguoiBan;

  // Cấu hình các trường dữ liệu
  final List<Map<String, String>> _fieldConfigs = [
    {'key': 'ma_phieu', 'label': 'Mã Phiếu', 'type': 'text'},
    {'key': 'ten_kh', 'label': 'Tên Khách Hàng', 'type': 'text'},
    {'key': 'dien_thoai', 'label': 'Điện Thoại', 'type': 'phone'},
    {'key': 'nguoi_lam', 'label': 'Người Làm', 'type': 'dropdown_user'},
    {'key': 'nguoi_ban', 'label': 'Người Bán', 'type': 'dropdown_seller'},
    {'key': 'diem_rap', 'label': 'Điểm Ráp', 'type': 'number'},
    {'key': 'diem_cai', 'label': 'Điểm Cài', 'type': 'number'},
    {'key': 'diem_test', 'label': 'Điểm Test', 'type': 'number'},
    {'key': 'diem_ve_sinh', 'label': 'Điểm Vệ Sinh', 'type': 'number'},
    {'key': 'diem_nc_pc', 'label': 'Điểm NC PC', 'type': 'number'},
    {'key': 'diem_nc_laptop', 'label': 'Điểm NC Laptop', 'type': 'number'},
    {'key': 'ghi_chu', 'label': 'Ghi Chú', 'type': 'multiline'},
  ];

  @override
  void initState() {
    super.initState();
    
    // Tạo các controller cho trường text
    for (var config in _fieldConfigs) {
      final key = config['key']!;
      final type = config['type']!;
      if (type != 'dropdown_user' && type != 'dropdown_seller') {
         _controllers[key] = TextEditingController(text: widget.job?[key] ?? '');
      }
    }
    
    // Khởi tạo giá trị ban đầu cho Dropdown
    _selectedNguoiLam = widget.job?['nguoi_lam'];
    _selectedNguoiBan = widget.job?['nguoi_ban'];
  }

  @override
  void dispose() {
    _controllers.forEach((_, controller) => controller.dispose());
    super.dispose();
  }

  Future<void> _scanWithOcr() async {
  setState(() { _isOcrLoading = true; });

  // Lưu lại context một cách an toàn
  final scaffoldMessenger = ScaffoldMessenger.of(context);
  
  // Gọi hàm quét ảnh
  final result = await ocr.OcrHelper.pickAndScanImage();

  if (result.isNotEmpty && mounted) {
    final data = result[ocr.OCR_RESULT_DATA] as Map<String, String>;
    final method = result[ocr.OCR_RESULT_METHOD] as String;
    
    setState(() {
      _controllers['ma_phieu']?.text = data['ma_phieu'] ?? '';
      _controllers['ten_kh']?.text = data['ten_kh'] ?? '';
      _controllers['dien_thoai']?.text = data['dien_thoai'] ?? '';
    });

    // Hiển thị thông báo về phương pháp đã dùng
    scaffoldMessenger.showSnackBar(
      SnackBar(
        content: Text('Đã quét thành công bằng: $method'),
        backgroundColor: Colors.green, // Màu xanh cho thành công
      ),
    );
  
  } else if (mounted) {
    // Thông báo nếu quét thất bại
    scaffoldMessenger.showSnackBar(
      const SnackBar(
        content: Text('Không thể nhận dạng được thông tin từ ảnh.'),
        backgroundColor: Colors.orange, // Màu cam cho cảnh báo
      ),
    );
  }

  // Đảm bảo loading được tắt dù thành công hay thất bại
  if(mounted) {
    setState(() { _isOcrLoading = false; });
  }
}

  Future<void> _saveJob() async {
    if (_formKey.currentState!.validate()) {
      setState(() { _isLoading = true; });

      final data = <String, String>{};
      // Lấy dữ liệu từ các ô text
      _controllers.forEach((key, controller) {
        data[key] = controller.text;
      });
      // Lấy dữ liệu từ các ô dropdown
      data['nguoi_lam'] = _selectedNguoiLam ?? '';
      data['nguoi_ban'] = _selectedNguoiBan ?? '';

      final pointFields = ['diem_rap', 'diem_cai', 'diem_test', 'diem_ve_sinh', 'diem_nc_pc', 'diem_nc_laptop'];
      for (var field in pointFields) {
          if (data[field] == null || data[field]!.isEmpty) {
              data[field] = '0';
          }
      }

      // Kiểm tra các trường bắt buộc
      if(data['nguoi_lam']!.isEmpty || data['ma_phieu']!.isEmpty) {
          ScaffoldMessenger.of(context).showSnackBar(
              const SnackBar(content: Text('Mã phiếu và Người làm là bắt buộc!')),
          );
          setState(() { _isLoading = false; });
          return;
      }

      bool success;
      if (widget.job != null) {
        success = await GoogleSheetsApi.updateJob(widget.job!['id']!, data);
      } else {
        success = await GoogleSheetsApi.addJob(data);
      }

      if (mounted) {
        setState(() { _isLoading = false; });
        if (success) {
            widget.onSave();
            Navigator.of(context).pop();
        } else {
            ScaffoldMessenger.of(context).showSnackBar(
              const SnackBar(content: Text('Lưu thất bại. Vui lòng thử lại.')),
            );
        }
      }
    }
  }
  
  // Widget xây dựng các widget đầu vào
  Widget _buildFormField(Map<String, String> config) {
    final key = config['key']!;
    final label = config['label']!;
    final type = config['type']!;

    switch(type) {
      case 'dropdown_user':
        final selectedValueExists = widget.userList.contains(_selectedNguoiLam);
        return DropdownButtonFormField<String>(
          value: selectedValueExists ? _selectedNguoiLam : null,
          decoration: InputDecoration(labelText: label, border: const OutlineInputBorder()),
          items: widget.userList.map((user) => DropdownMenuItem(value: user, child: Text(user))).toList(),
          onChanged: (value) => setState(() => _selectedNguoiLam = value),
          validator: (value) {
            if (value == null || value.isEmpty) { return 'Người làm là bắt buộc'; }
            return null;
          },
        );
      
      case 'dropdown_seller':
        final selectedValueExists = widget.sellerList.contains(_selectedNguoiBan);
        return DropdownButtonFormField<String>(
          value: selectedValueExists ? _selectedNguoiBan : null,
          decoration: InputDecoration(labelText: label, border: const OutlineInputBorder()),
          items: widget.sellerList.toSet().toList().map((seller) => DropdownMenuItem(value: seller, child: Text(seller))).toList(),
          onChanged: (value) => setState(() => _selectedNguoiBan = value),
        );

      case 'multiline':
        return TextFormField(
          controller: _controllers[key],
          decoration: InputDecoration(labelText: label, border: const OutlineInputBorder()),
          maxLines: 3,
        );
      
      case 'phone':
      case 'number':
        return TextFormField(
          controller: _controllers[key],
          decoration: InputDecoration(labelText: label, border: const OutlineInputBorder()),
          keyboardType: TextInputType.number,
        );

      default: // text
        return TextFormField(
          controller: _controllers[key],
          decoration: InputDecoration(labelText: label, border: const OutlineInputBorder()),
          keyboardType: TextInputType.text,
          validator: (value) {
            if (key == 'ma_phieu' && (value == null || value.isEmpty)) { return 'Mã phiếu là bắt buộc'; }
            return null;
          },
        );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.job != null ? 'Sửa Công Việc' : 'Thêm Công Việc Mới'),
        backgroundColor: Colors.indigo,
        foregroundColor: Colors.white,
        actions: [
          if (widget.job == null)
            IconButton(
              icon: const Icon(Icons.camera_alt),
              onPressed: (_isLoading || _isOcrLoading) ? null : _scanWithOcr,
              tooltip: 'Quét từ ảnh',
            ),
        ],
      ),
      body: _isLoading || _isOcrLoading
          ? Center(child: Column( mainAxisAlignment: MainAxisAlignment.center, children: [ const CircularProgressIndicator(), const SizedBox(height: 10), Text(_isOcrLoading ? 'Đang xử lý ảnh...' : 'Đang lưu...'), ],))
          : Form(
              key: _formKey,
              child: ListView(
                padding: const EdgeInsets.all(16.0),
                children: [
                  ..._fieldConfigs.map((config) => Padding(
                        padding: const EdgeInsets.only(bottom: 16.0),
                        child: _buildFormField(config),
                      )),
                  ElevatedButton(
                    onPressed: _saveJob,
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.indigo,
                      foregroundColor: Colors.white,
                      padding: const EdgeInsets.symmetric(vertical: 16.0),
                    ),
                    child: const Text('LƯU LẠI'),
                  ),
                ],
              ),
            ),
    );
  }
}