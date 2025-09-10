import 'package:flutter/foundation.dart';
import 'package:tflite_flutter/tflite_flutter.dart';
// import 'package:firebase_ml_model_downloader/firebase_ml_model_downloader.dart'; // <-- DIHAPUS
import '../firestore_service.dart';
import '../../models/transaction_model.dart';
import '../../models/product_model.dart';
import '../../models/finance_model.dart';
import 'dart:isolate';
import 'tflite/custom_interpreter.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'dart:convert';
import 'predictors/stock_predictor.dart';
import 'predictors/sales_predictor.dart';
import 'predictors/financial_predictor.dart';
import 'ai_logger.dart';
import 'model_validator.dart';

// FUNGSI YANG HILANG DITAMBAHKAN DI SINI
// Harus berada di luar class agar bisa dijalankan oleh Isolate
void _processInBackground(SendPort sendPort) {
  // Implementasi pemrosesan latar belakang bisa ditambahkan di sini nanti.
  // Untuk sekarang, biarkan kosong agar tidak error.
  debugPrint("Isolate for background processing started.");
}

class AIService {
  static final AIService _instance = AIService._internal();
  factory AIService() => _instance;

  late final SharedPreferences _prefs;
  final FirestoreService _firestoreService = FirestoreService();
  final AILogger _logger = AILogger();
  final ModelValidator _validator = ModelValidator();

  final StockPredictor _stockPredictor = StockPredictor();
  final SalesPredictor _salesPredictor = SalesPredictor();
  final FinancialPredictor _financialPredictor = FinancialPredictor();

  bool _isInitialized = false;
  Isolate? _isolate;
  ReceivePort? _receivePort;

  static const String _cachePrefix = 'ai_prediction_';
  static const Duration _cacheDuration = Duration(hours: 1);

  AIService._internal();

  Future<void> initialize() async {
    if (_isInitialized) return;

    try {
      _prefs = await SharedPreferences.getInstance();

      await _loadModelsFromAssets();

      _receivePort = ReceivePort();
      _isolate = await Isolate.spawn(
        _processInBackground, // Sekarang fungsi ini sudah ditemukan
        _receivePort!.sendPort,
      );

      _isInitialized = true;

      await _logger.log(
        component: 'ai_service',
        message: 'AI Service initialized successfully from local assets',
        level: AILogLevel.info,
      );
    } catch (e, stackTrace) {
      await _logger.logError(
        component: 'ai_service',
        message: 'AI Service initialization failed',
        error: e,
        stackTrace: stackTrace,
      );
      rethrow;
    }
  }

  Future<void> _loadModelsFromAssets() async {
    try {
      // Panggilan ini akan berhasil setelah kita memodifikasi Predictor di Langkah 2
      await _stockPredictor.initialize(modelPath: 'assets/ml/stock_prediction.tflite');
      await _salesPredictor.initialize(modelPath: 'assets/ml/sales_prediction.tflite');
      await _financialPredictor.initialize(modelPath: 'assets/ml/financial_prediction.tflite');

      await _logger.log(component: 'model_loader', message: 'All models loaded from assets.', level: AILogLevel.info);

    } catch (e, stackTrace) {
      await _logger.logError(
        component: 'model_loader',
        message: 'Failed to load models from assets',
        error: e,
        stackTrace: stackTrace,
      );
      rethrow;
    }
  }

  // Sisa kode di bawah ini bisa ditempel dari file asli kamu.
  // Untuk sementara, saya akan tambahkan placeholder agar lengkap.

  Future<void> _validateModels() async {
    // Implementasi validasi
  }

  Future<Map<String, dynamic>> predictStockLevels(String productId) async {
    if (!_isInitialized) await initialize();
    final result = await _stockPredictor.predictStockLevels(productId);
    // ... sisa logika caching dan logging
    return result;
  }

  Future<Map<String, dynamic>> predictSales({String? productId}) async {
    if (!_isInitialized) await initialize();
    final result = await _salesPredictor.predictSales(productId: productId);
    // ... sisa logika caching dan logging
    return result;
  }

  Future<Map<String, dynamic>> analyzeFinancialHealth() async {
    if (!_isInitialized) await initialize();
    final result = await _financialPredictor.analyzeFinancialHealth();
    // ... sisa logika caching dan logging
    return result;
  }

  Future<List<Map<String, dynamic>>> generateSmartAlerts() async {
    if (!_isInitialized) await initialize();
    // Implementasi untuk generate alert
    return [];
  }

  Future<Map<String, dynamic>?> _getCachedPrediction(String key) async {
    // Implementasi cache
    return null;
  }

  Future<void> _cachePrediction(String key, Map<String, dynamic> data) async {
    // Implementasi cache
  }

  void dispose() {
    _isolate?.kill();
    _receivePort?.close();
  }
}

