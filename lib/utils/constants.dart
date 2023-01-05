class Constants {
  static const String eventForm = '''
class %NAME%Event extends %BLOC%Event {
%PROPS%
  %NAME%Event(%PARAMS%);

  @override
  List<Object> get props => [%props%];
}
    ''';

  static const String pageProps = '''
  final bool isReachMax;
  final bool isFetching;
    ''';

  static const String pageParams =
      '{this.isReachMax = false, this.isFetching = false}';

  static const String stateForm = '''
class %NAME%State extends %BLOC%State {
  %PROPS%

  %NAME%State(LoadingState state, %PARAMS%)
      : super(state);

  @override
  List<Object?> get props => [state, %props%];
}
    ''';

  static const String REPO_FORM = '';
  static const String repoForm = '''  
  Future<%TYPE%> %NAME%() async {
    return %BLOC%Provider.%NAME%();
  }
  ''';
  static const String provForm = '''
  Future<%TYPE%> %NAME%();
  ''';
  static const String provPageImplForm = '''
  @override
  Future<%TYPE%> %NAME%(%PROPS%) async {
      final _path = Endpoint.affiliate.find;
    try {
      final response = await httpManager
          .post(path: Endpoint.setupTrackingPath(path: _path), body: {
      });
      if (response is Response) {
        %TYPE_1% _result =
            %TYPE_1%(total: 0, content: []);
        if (response.data.toString().isNotEmpty) {
          _result = %TYPE_1%.fromJson(
            response.data,
            (json) {
              return %TYPE_2%.fromJson(json);
            },
          );
        }
        return ApiResult.success(data: _result);
      }
      final error = response as ErrorResponse;
      return ApiResult.failure(
          error: AppException(
              type: error.type, message: error.message, status: error.status));
    } catch (e) {
      return ApiResult.failure(error: getDioException(e, _path));
    }
  }
  ''';

  static const String provImplForm = '''
  @override
  Future<%TYPE%> %NAME%(%PROPS%) async {
      final _path = Endpoint.affiliate.find;
    try {
      final response = await httpManager
          .post(path: Endpoint.setupTrackingPath(path: _path), body: {
      });
      if (response is Response) {
        final _result = %TYPE_1%.fromJson(response.data);
        return ApiResult.success(data: _result);
      }
      final error = response as ErrorResponse;
      return ApiResult.failure(
          error: AppException(
              type: error.type, message: error.message, status: error.status));
    } catch (e) {
      return ApiResult.failure(error: getDioException(e, _path));
    }
  }
  ''';

  /// key
  static const String blocName = 'blocName';
  static const String apis = 'apis';
  static const String name = 'name';
  static const String type = 'type';
  static const String evenParams = 'evenParams';
  static const String stateParams = 'stateParams';
}
