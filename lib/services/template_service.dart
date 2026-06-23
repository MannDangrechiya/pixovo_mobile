import '../config/api_config.dart';
import '../models/template.dart';
import 'api_service.dart';

/// Handles template fetching and filtering.
class TemplateService {
  final ApiService _api = ApiService();

  /// Fetch a paginated list of templates.
  Future<List<Template>> getTemplates({
    int page = 1,
    int limit = 20,
    String? category,
    String? search,
  }) async {
    final queryParams = <String, dynamic>{
      'page': page,
      'limit': limit,
    };
    if (category != null) queryParams['category'] = category;
    if (search != null) queryParams['search'] = search;

    final response = await _api.get(
      ApiConfig.templates,
      queryParameters: queryParams,
    );

    final list = response.data['templates'] as List<dynamic>;
    return list
        .map((e) => Template.fromJson(e as Map<String, dynamic>))
        .toList();
  }

  /// Fetch a single template by its ID.
  Future<Template> getTemplateDetail(String templateId) async {
    final response =
        await _api.get('${ApiConfig.templateDetail}/$templateId');
    return Template.fromJson(response.data as Map<String, dynamic>);
  }

  /// Fetch available template categories.
  Future<List<String>> getCategories() async {
    final response = await _api.get(ApiConfig.templateCategories);
    final list = response.data['categories'] as List<dynamic>;
    return list.map((e) => e as String).toList();
  }
}
