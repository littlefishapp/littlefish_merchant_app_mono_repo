import 'package:littlefish_core_utils/httpErrors/models/api_error.dart';
import 'package:littlefish_merchant/tools/http/rest_client.dart';
import 'package:redux/redux.dart';

import '../../../redux/app/app_state.dart';
import '../model/business_store.dart';

class BusinessStoreDataSource {
  final String baseUrl;

  BusinessStoreDataSource({required this.baseUrl});

  Future<List<BusinessStore>> fetchBusinesses({
    required Store<AppState> store,
    required String? userId,
    required String? token,
  }) async {
    final restClient = RestClient(store: store);

    final response = await restClient.get(
      url: '$baseUrl/User/Businesses/$userId',
      token: 'Bearer $token',
    );

    if (response?.statusCode == 200) {
      final data = response!.data;
      if (data is List) {
        return data.map((json) => BusinessStore.fromJson(json)).toList();
      } else {
        throw ApiErrorException(
          ApiError(
            title: 'Unexpected response',
            detail: 'The server returned an unexpected payload.',
            status: 500,
            errorCode: 'BUSINESS_LIST_UNEXPECTED_PAYLOAD',
          ),
        );
      }
    }

    final Map<String, dynamic> raw = (response?.data is Map<String, dynamic>)
        ? response?.data as Map<String, dynamic>
        : <String, dynamic>{};
    final apiError = ApiError.fromJson(raw);

    throw ApiErrorException(
      (apiError.detail != null && apiError.detail!.isNotEmpty)
          ? apiError
          : ApiError(
              title: 'Failed to load businesses',
              detail:
                  'Server responded with status code ${response?.statusCode ?? 'unknown'}.',
              status: response?.statusCode ?? 500,
              errorCode: 'BUSINESS_FETCH_FAILED',
            ),
    );
  }
}
