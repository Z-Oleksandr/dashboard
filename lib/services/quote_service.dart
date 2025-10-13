import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';
import '../config/app_config.dart';
import '../models/system_models.dart';
import '../utils/log.dart';

class QuoteService {
  static const String _quoteKey = 'daily_quote';
  static const String _quoteAuthorKey = 'daily_quote_author';
  static const String _quoteDateKey = 'daily_quote_date';
  static const String _quoteCategoryKey = 'daily_quote_category';

  Future<DailyQuoteNinjas> getDailyQuote() async {
    final prefs = await SharedPreferences.getInstance();
    final today = DateTime.now().toIso8601String().split('T')[0];
    final savedDate = prefs.getString(_quoteDateKey);

    // Check if we have a quote for today
    if (savedDate == today) {
      final content = prefs.getString(_quoteKey);
      final author = prefs.getString(_quoteAuthorKey);
      final category = prefs.getString(_quoteCategoryKey);
      if (content != null && author != null && category != null) {
        return DailyQuoteNinjas(
            content: content, author: author, category: category);
      }
    }

    // Fetch new quote
    try {
      final response = await http.get(Uri.parse(AppConfig.quoteApiUrl),
          headers: {'X-Api-Key': AppConfig.quoteApiKey});

      if (response.statusCode == 200) {
        // This setup is for quotable.io, which is currently down
        // final data = jsonDecode(response.body) as Map<String, dynamic>;
        // final quote = DailyQuote.fromJson(data);

        final decoded = jsonDecode(response.body);
        final data = (decoded is List && decoded.isNotEmpty)
            ? decoded.first as Map<String, dynamic>
            : {};

        // Here also temporarily Ninjas
        final quote = DailyQuoteNinjas.fromJson(data);

        // Save quote for today
        // This setup is for quotable.io, which is currently down
        await prefs.setString(_quoteKey, quote.content);
        await prefs.setString(_quoteAuthorKey, quote.author);
        await prefs.setString(_quoteDateKey, today);

        return quote;
      }
    } catch (e) {
      log.e('Error fetching quote: $e');
    }

    // Return fallback quote
    return DailyQuoteNinjas(
        content: 'The only way to do great work is to love what you do.',
        author: 'Steve Jobs (Fallback)',
        category: 'Fallback');
  }
}
