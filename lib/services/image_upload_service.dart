import 'dart:convert';
import 'dart:io';
import 'package:http/http.dart' as http;

/// Upload ảnh lên imgbb (free, không cần thẻ, không cần preset như Cloudinary).
/// Setup: đăng ký free tại https://api.imgbb.com/ -> copy API key -> điền vào dưới.
class ImageUploadService {
  ImageUploadService._();
  static final ImageUploadService instance = ImageUploadService._();

  // TODO: thay bằng API key thật của bạn.
  static const String _apiKey = 'b62f22bea7d3250a2fb7650c238d98f5';

  /// Upload 1 file ảnh trong máy, trả về URL công khai để lưu vào Firestore.
  Future<String> uploadImage(File file) async {
    final bytes = await file.readAsBytes();
    final base64Image = base64Encode(bytes);

    final uri = Uri.parse('https://api.imgbb.com/1/upload?key=$_apiKey');
    final response = await http.post(uri, body: {'image': base64Image});

    if (response.statusCode != 200) {
      throw Exception('Upload ảnh thất bại (mã lỗi ${response.statusCode})');
    }

    final data = jsonDecode(response.body) as Map<String, dynamic>;
    if (data['success'] != true) {
      throw Exception('Upload ảnh thất bại: ${data['error']?['message'] ?? 'unknown error'}');
    }

    final url = (data['data'] as Map<String, dynamic>?)?['url'] as String?;
    if (url == null || url.isEmpty) {
      throw Exception('imgbb không trả về URL ảnh hợp lệ.');
    }
    return url;
  }
}