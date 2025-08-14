import 'dart:io';
import 'dart:typed_data';
import 'package:path_provider/path_provider.dart';
import 'package:file_picker/file_picker.dart';
import 'package:image_picker/image_picker.dart';
import 'package:uuid/uuid.dart';
import 'package:path/path.dart' as path;
import '../constants/app_constants.dart';
import '../errors/exceptions.dart';
import '../errors/failures.dart';

class FileService {
  final ImagePicker _imagePicker = ImagePicker();
  final Uuid _uuid = const Uuid();

  Future<Directory> get _documentsDir async {
    final directory = await getApplicationDocumentsDirectory();
    final propertyMasterDir = Directory('${directory.path}/property_master');
    if (!await propertyMasterDir.exists()) {
      await propertyMasterDir.create(recursive: true);
    }
    return propertyMasterDir;
  }

  Future<Directory> _getSubDirectory(String subDirName) async {
    final documentsDir = await _documentsDir;
    final subDir = Directory('${documentsDir.path}/$subDirName');
    if (!await subDir.exists()) {
      await subDir.create(recursive: true);
    }
    return subDir;
  }

  // Image Operations
  Future<File?> pickImageFromGallery() async {
    try {
      final XFile? pickedFile = await _imagePicker.pickImage(
        source: ImageSource.gallery,
        maxWidth: 1920,
        maxHeight: 1080,
        imageQuality: 85,
      );

      if (pickedFile == null) return null;

      final file = File(pickedFile.path);
      return await _validateAndSaveImage(file);
    } catch (e) {
      throw FileException('Failed to pick image from gallery: $e');
    }
  }

  Future<File?> pickImageFromCamera() async {
    try {
      final XFile? pickedFile = await _imagePicker.pickImage(
        source: ImageSource.camera,
        maxWidth: 1920,
        maxHeight: 1080,
        imageQuality: 85,
      );

      if (pickedFile == null) return null;

      final file = File(pickedFile.path);
      return await _validateAndSaveImage(file);
    } catch (e) {
      throw FileException('Failed to pick image from camera: $e');
    }
  }

  Future<List<File>> pickMultipleImages() async {
    try {
      final List<XFile> pickedFiles = await _imagePicker.pickMultiImage(
        maxWidth: 1920,
        maxHeight: 1080,
        imageQuality: 85,
      );

      final List<File> savedFiles = [];
      for (final pickedFile in pickedFiles) {
        final file = File(pickedFile.path);
        final savedFile = await _validateAndSaveImage(file);
        if (savedFile != null) {
          savedFiles.add(savedFile);
        }
      }

      return savedFiles;
    } catch (e) {
      throw FileException('Failed to pick multiple images: $e');
    }
  }

  Future<File?> _validateAndSaveImage(File file) async {
    // Validate file size
    final fileStat = await file.stat();
    if (fileStat.size > AppConstants.maxFileSize) {
      throw FileSizeExceededFailure(
        'File size ${fileStat.size} exceeds limit of ${AppConstants.maxFileSize} bytes',
      );
    }

    // Validate file type
    final extension = path.extension(file.path).toLowerCase().substring(1);
    if (!AppConstants.allowedImageTypes.contains(extension)) {
      throw InvalidFileTypeFailure();
    }

    // Save to app directory
    return await _saveFileToAppDirectory(file, 'images', extension);
  }

  // Document Operations
  Future<File?> pickDocument() async {
    try {
      final FilePickerResult? result = await FilePicker.platform.pickFiles(
        type: FileType.custom,
        allowedExtensions: AppConstants.allowedDocTypes,
      );

      if (result == null || result.files.isEmpty) return null;

      final platformFile = result.files.first;
      if (platformFile.path == null) return null;

      final file = File(platformFile.path!);
      return await _validateAndSaveDocument(file);
    } catch (e) {
      throw FileException('Failed to pick document: $e');
    }
  }

  Future<File?> _validateAndSaveDocument(File file) async {
    // Validate file size
    final fileStat = await file.stat();
    if (fileStat.size > AppConstants.maxFileSize) {
      throw FileException(
        'File size ${fileStat.size} exceeds the allowed limit of ${AppConstants.maxFileSize} bytes',
      );
    }

    // Validate file type
    final extension = path.extension(file.path).toLowerCase().substring(1);
    if (!AppConstants.allowedDocTypes.contains(extension)) {
      throw FileException('Invalid file type: $extension');
    }

    // Save to app directory
    return await _saveFileToAppDirectory(file, 'documents', extension);
  }

  Future<File> _saveFileToAppDirectory(
    File file,
    String subDir,
    String extension,
  ) async {
    try {
      final directory = await _getSubDirectory(subDir);
      final fileName = '${_uuid.v4()}.$extension';
      final newPath = '${directory.path}/$fileName';

      return await file.copy(newPath);
    } catch (e) {
      throw FileException('Failed to save file: $e');
    }
  }

  // File Management
  Future<void> deleteFile(String filePath) async {
    try {
      final file = File(filePath);
      if (await file.exists()) {
        await file.delete();
      }
    } catch (e) {
      throw FileException('Failed to delete file: $e');
    }
  }

  Future<void> deleteFiles(List<String> filePaths) async {
    for (final filePath in filePaths) {
      await deleteFile(filePath);
    }
  }

  Future<bool> fileExists(String filePath) async {
    try {
      final file = File(filePath);
      return await file.exists();
    } catch (e) {
      return false;
    }
  }

  Future<int> getFileSize(String filePath) async {
    try {
      final file = File(filePath);
      final stat = await file.stat();
      return stat.size;
    } catch (e) {
      throw FileException('Failed to get file size: $e');
    }
  }

  Future<String> getFileName(String filePath) {
    return Future.value(path.basename(filePath));
  }

  Future<String> getFileExtension(String filePath) {
    return Future.value(path.extension(filePath).toLowerCase().substring(1));
  }

  // Save data as file
  Future<File> saveDataAsFile(
    Uint8List data,
    String fileName,
    String subDir,
  ) async {
    try {
      final directory = await _getSubDirectory(subDir);
      final filePath = '${directory.path}/$fileName';
      final file = File(filePath);
      return await file.writeAsBytes(data);
    } catch (e) {
      throw FileException('Failed to save data as file: $e');
    }
  }

  // Read file as bytes
  Future<Uint8List> readFileAsBytes(String filePath) async {
    try {
      final file = File(filePath);
      if (!await file.exists()) {
        throw FileException('File not found: $filePath'); // ✅ simple
      }
      return await file.readAsBytes();
    } catch (e) {
      throw FileException('Failed to read file: $e');
    }
  }

  // Clean up old files (older than specified days)
  Future<void> cleanUpOldFiles({int olderThanDays = 30}) async {
    try {
      final documentsDir = await _documentsDir;
      final cutoffDate = DateTime.now().subtract(Duration(days: olderThanDays));

      await for (final entity in documentsDir.list(recursive: true)) {
        if (entity is File) {
          final stat = await entity.stat();
          if (stat.modified.isBefore(cutoffDate)) {
            await entity.delete();
          }
        }
      }
    } catch (e) {
      throw FileException('Failed to clean up old files: $e');
    }
  }

  // Get app storage size
  Future<int> getStorageSize() async {
    try {
      final documentsDir = await _documentsDir;
      int totalSize = 0;

      await for (final entity in documentsDir.list(recursive: true)) {
        if (entity is File) {
          final stat = await entity.stat();
          totalSize += stat.size;
        }
      }

      return totalSize;
    } catch (e) {
      throw FileException('Failed to calculate storage size: $e');
    }
  }

  // Format file size for display
  String formatFileSize(int bytes) {
    if (bytes < 1024) {
      return '$bytes B';
    } else if (bytes < 1024 * 1024) {
      return '${(bytes / 1024).toStringAsFixed(1)} KB';
    } else if (bytes < 1024 * 1024 * 1024) {
      return '${(bytes / (1024 * 1024)).toStringAsFixed(1)} MB';
    } else {
      return '${(bytes / (1024 * 1024 * 1024)).toStringAsFixed(1)} GB';
    }
  }
}
