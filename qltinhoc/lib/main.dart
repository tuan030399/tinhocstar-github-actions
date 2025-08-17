// Dòng này để import thư viện giao diện cơ bản của Flutter
import 'package:flutter/material.dart';
import 'package:qltinhoc/google_sheets_api.dart';
import 'package:qltinhoc/job_screen.dart';
import 'package:qltinhoc/user_management_screen.dart'; // <-- IMPORT MÀN HÌNH MỚI
import 'package:qltinhoc/password_dialog.dart';
import 'package:qltinhoc/settings_service.dart';
import 'package:qltinhoc/settings_screen.dart';

// Đây là hàm "cửa ngõ", nơi ứng dụng bắt đầu chạy
void main() async { // <-- Chuyển thành async
  // Đảm bảo Flutter đã sẵn sàng trước khi chạy các tác vụ bất đồng bộ
  WidgetsFlutterBinding.ensureInitialized(); 
  await SettingsService.init();

  runApp(const MyApp());
}

// Đây là Widget (Tiện ích) gốc của toàn bộ ứng dụng của bạn
class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    // MaterialApp là một widget cung cấp rất nhiều thứ cơ bản cho ứng dụng
    return MaterialApp(
      debugShowCheckedModeBanner: false, // Tắt cái banner "Debug"
      title: 'Quản Lý Công Việc',
      // theme dùng để định nghĩa màu sắc chung cho ứng dụng
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.indigo),
        useMaterial3: true,
      ),
      // home chỉ định màn hình đầu tiên sẽ được hiển thị khi mở app
      home: const HomeScreen(),
    );
  }
}

// Đây là Widget màn hình chính của chúng ta
class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {

  // Danh sách công việc sẽ được tải từ Google Sheets
  List<Map<String, String>> _allJobs = [];
  List<Map<String, String>> _displayedJobs = [];
  bool _isLoading = true; // Biến để theo dõi trạng thái tải dữ liệu

  // State cho bộ lọc và tìm kiếm
  final _searchController = TextEditingController();
  String? _selectedUser;
  String? _selectedSeller;
  List<String> _userList = [];
  List<String> _sellerList = [];


  @override
  void initState() {
    super.initState();
    _loadData(); // Gọi hàm tải dữ liệu khi màn hình được tạo
    _searchController.addListener(_filterJobs);
  }

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  // Hàm để tải tất cả dữ liệu cần thiết
  Future<void> _loadData() async {
    setState(() { _isLoading = true; });
    final jobs = await GoogleSheetsApi.getAllJobs();
    final users = await GoogleSheetsApi.getUsers();
    final sellers = await GoogleSheetsApi.getSellers();
    if (mounted) {
      setState(() {
        _allJobs = jobs;
        _userList = users;
        _sellerList = sellers;
        _filterJobs(); // Áp dụng bộ lọc (ban đầu là không có)
        _isLoading = false;
      });
    }
  }

  // Hàm lọc và tìm kiếm trên danh sách đã tải
  void _filterJobs() {
    List<Map<String, String>> filteredList = List.from(_allJobs);

    // Lọc theo người làm
    if (_selectedUser != null) {
      filteredList = filteredList.where((job) => job['nguoi_lam'] == _selectedUser).toList();
    }

    // Lọc theo người bán
    if (_selectedSeller != null) {
      filteredList = filteredList.where((job) => job['nguoi_ban'] == _selectedSeller).toList();
    }

    // Lọc theo từ khóa tìm kiếm
    final searchQuery = _searchController.text.toLowerCase();
    if (searchQuery.isNotEmpty) {
      filteredList = filteredList.where((job) {
        return job.values.any((value) => value.toLowerCase().contains(searchQuery));
      }).toList();
    }

    setState(() {
      _displayedJobs = filteredList;
    });
  }

  // Hàm để tải lại dữ liệu từ sheet
  Future<void> _refreshData() async {
    await _loadData();
  }

  // Hàm hiển thị dialog xác nhận xóa
  Future<void> _showDeleteDialog(Map<String, String> job) async {
  final jobId = job['id'];
  final ownerName = job['nguoi_lam'];
  // Tạo biến an toàn
  final scaffoldMessenger = ScaffoldMessenger.of(context);
  final navigator = Navigator.of(context);

  if (jobId == null || ownerName == null || ownerName.isEmpty) {
     scaffoldMessenger.showSnackBar(
      const SnackBar(content: Text('Công việc không có người làm, không thể xóa.')),
    );
    return;
  }

  // BƯỚC 1: HỎI MẬT KHẨU TRƯỚC
  final passwordCorrect = await showPasswordDialog(
      context: context, ownerName: ownerName, action: 'xóa');

  // BƯỚC 2: NẾU PASS ĐÚNG MỚI HIỂN THỊ HỘP THOẠI XÁC NHẬN XÓA
  if (passwordCorrect) {
    final confirmed = await showDialog<bool>(
      context: context,
      builder: (ctx) => AlertDialog(
        title: const Text('Xác Nhận Xóa'),
        content:
            Text('Bạn chắc chắn muốn xóa vĩnh viễn công việc của "${job['ten_kh']}"?'),
        actions: [
          TextButton(onPressed: () => Navigator.of(ctx).pop(false), child: const Text('Hủy')),
          TextButton(onPressed: () => Navigator.of(ctx).pop(true), style: TextButton.styleFrom(foregroundColor: Colors.red), child: const Text('XÓA')),

        ],
      ),
    );

    if (confirmed == true) {
      setState(() { _isLoading = true; });
      final success = await GoogleSheetsApi.deleteJob(jobId);
      if (success) {
        await _refreshData(); // Đảm bảo dùng await ở đây
      } else {
        scaffoldMessenger.showSnackBar(const SnackBar(content: Text('Xóa thất bại. Vui lòng thử lại.')));
        if(mounted) {
          setState(() { _isLoading = false; });
        }
      }
    }
  }
}

  @override
  Widget build(BuildContext context) {
    // Scaffold là cấu trúc cơ bản của một màn hình (có appbar, body,...)
    return Scaffold(
      // AppBar là thanh tiêu đề màu xanh ở trên cùng
      appBar: AppBar(
        title: const Text('Danh Sách Công Việc'),
        backgroundColor: Colors.indigo,
        foregroundColor: Colors.white,
        actions: [ // Thêm nút refresh
          IconButton(
        icon: const Icon(Icons.settings),
        tooltip: 'Cài đặt',
        onPressed: () {
          Navigator.of(context).push(
            MaterialPageRoute(builder: (_) => const SettingsScreen()),
          );
        },
      ),
          IconButton(
            icon: const Icon(Icons.manage_accounts), // Icon quản lý user
            tooltip: 'Quản lý nhân viên',
            onPressed: () {
              Navigator.of(context).push(
                MaterialPageRoute(builder: (_) => const UserManagementScreen()),
              );
            },
          ),
          IconButton(
            icon: const Icon(Icons.refresh),
            tooltip: 'Làm mới',
            onPressed: _refreshData,
          ),
        ],
      ),
      // body là phần thân chính của màn hình
      body: Column(
        children: [
          // KHUNG TÌM KIẾM VÀ BỘ LỌC
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Column(
              children: [
                TextField(
                  controller: _searchController,
                  decoration: InputDecoration(
                    labelText: 'Tìm kiếm...',
                    prefixIcon: const Icon(Icons.search),
                    border: const OutlineInputBorder(),
                    suffixIcon: _searchController.text.isNotEmpty
                        ? IconButton(
                            icon: const Icon(Icons.clear),
                            onPressed: () {
                              _searchController.clear();
                            },
                          )
                        : null,
                  ),
                ),
                const SizedBox(height: 8),
                Row(
                  children: [
                    Expanded(child: _buildFilterDropdown(_userList, 'Người làm', _selectedUser, (val) => setState(() { _selectedUser = val; _filterJobs(); }))),
                    const SizedBox(width: 8),
                    Expanded(child: _buildFilterDropdown(_sellerList, 'Người bán', _selectedSeller, (val) => setState(() { _selectedSeller = val; _filterJobs(); }))),
                  ],
                ),
              ],
            ),
          ),
          // DANH SÁCH CÔNG VIỆC
          Expanded(
            child: _isLoading
                ? const Center(child: CircularProgressIndicator())
                : _displayedJobs.isEmpty
                    ? const Center(child: Text('Không có công việc nào phù hợp.'))
                    : RefreshIndicator(
                        onRefresh: _refreshData,
                        child: ListView.builder(
                          itemCount: _displayedJobs.length,
                          itemBuilder: (context, index) {
                            final job = _displayedJobs[index];
                            return Card(
                              margin: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
                              child: ListTile(
                                leading: CircleAvatar(
                                  backgroundColor: Colors.indigo[100],
                                  child: Text(job['id'] ?? '?'),
                                ),
                                title: Text(job['ten_kh'] ?? 'Không có tên'),
                                subtitle: Text('Mã phiếu: ${job['ma_phieu']} - Người làm: ${job['nguoi_lam']}'),
                                onTap: () async {
  final ownerName = job['nguoi_lam'];
  
  // Tạo một bản sao an toàn của các biến cần thiết TRƯỚC KHI gọi await
  final BuildContext currentContext = context;
  final Function refreshCallback = _refreshData;
  final List<String> currentUserList = _userList;
  final List<String> currentSellerList = _sellerList;
  final Map<String, String> currentJob = job;

  if (ownerName == null || ownerName.isEmpty) {
    ScaffoldMessenger.of(currentContext).showSnackBar(
      const SnackBar(content: Text('Công việc không có người làm, không thể sửa.')),
    );
    return;
  }

  // Bước 1: Gọi dialog hỏi mật khẩu
  final passwordCorrect = await showPasswordDialog(
    context: currentContext, // Dùng context an toàn
    ownerName: ownerName,
    action: 'sửa',
  );

  // Bước 2: Nếu mật khẩu đúng và widget vẫn còn tồn tại (mounted)
  if (passwordCorrect && currentContext.mounted) {
    // Sử dụng các biến an toàn đã lưu từ trước
    Navigator.of(currentContext).push(
      MaterialPageRoute(
        builder: (_) => JobScreen(
          job: currentJob,
          onSave: () => refreshCallback(),
          userList: currentUserList,
          sellerList: currentSellerList,
        ),
      ),
    );
  }
},
                                onLongPress: () {
                                  _showDeleteDialog(job);
                                },
                              ),
                            );
                          },
                        ),
                      ),
          ),
        ],
      ),
      floatingActionButton: FloatingActionButton(
  onPressed: () {
    Navigator.of(context).push(
      MaterialPageRoute(
        builder: (_) => JobScreen( // Mở màn hình thêm mới
          onSave: _refreshData,
          userList: _userList,     // TRUYỀN DANH SÁCH NGƯỜI LÀM
          sellerList: _sellerList, // TRUYỀN DANH SÁCH NGƯỜI BÁN
        ),
      ),
    );
  },
  backgroundColor: Colors.indigo,
  foregroundColor: Colors.white,
  child: const Icon(Icons.add),
),
    );
  }

  // Widget trợ giúp để tạo Dropdown
  Widget _buildFilterDropdown(List<String> items, String hint, String? selectedValue, ValueChanged<String?> onChanged) {
    return DropdownButtonFormField<String>(
      decoration: InputDecoration(
        labelText: hint,
        border: const OutlineInputBorder(),
        contentPadding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
      ),
      value: selectedValue,
      hint: Text(hint),
      isExpanded: true,
      items: [
        DropdownMenuItem<String>(
          value: null,
          child: Text('Tất cả ${hint.toLowerCase()}'),
        ),
        ...items.map((String value) {
          return DropdownMenuItem<String>(
            value: value,
            child: Text(value),
          );
        }),
      ],
      onChanged: onChanged,
    );
  }
}