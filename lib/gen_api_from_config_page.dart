import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:gen_bloc_code/utils/constants.dart';

import 'models/api_config.dart';

class GenApiFromConfigPage extends StatefulWidget {
  GenApiFromConfigPage({Key? key}) : super(key: key);

  @override
  State<GenApiFromConfigPage> createState() => _GenApiFromConfigPageState();
}

class _GenApiFromConfigPageState extends State<GenApiFromConfigPage> {
  String _result = '';

  @override
  void initState() {
    super.initState();
    _genCode();
  }

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text('GenApiConfigPage'),
          const SizedBox(height: 20),
          Text(_result),
          ElevatedButton(
              onPressed: () async {
                await _genCode();
                Clipboard.setData(ClipboardData(text: _result)).then((_) {
                  ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
                      content: Text("Code copied to clipboard")));
                });
              },
              child: const Text('copy')),
        ],
      ),
    );
  }

  Future<String> _genCode() async {
    await readJson().then((data) {
      print('giang.pt1 gencode:: $data');
      _result = '';
      final blocName = data.blocName.trim();
      final apiData = data.apis;

      String eventBase = '${blocName}Event';
      String stateBase = '${blocName}State';
      String eventStr = '', stateStr = '';
      String provStr = '', provImplStr = '', repoStr = '';

      for (final api in apiData) {
        String apiName = api.name;
        String eventName = apiName.isNotEmpty
            ? apiName.replaceRange(0, 1, apiName[0].toUpperCase())
            : apiName;
        List<Map<String, String>> eventParams = [];
        final eventData = api.evenParams;
        String eventPropsStr = '', eventParamsStr = '';
        for (final param in eventData) {
          final type = param.type;
          final name = param.name;
          eventParams.add({
            Constants.type: type,
            Constants.name: name,
          });
          eventPropsStr += '    $type $name;\n';
          eventParamsStr +=
              '${type.contains('?') ? '' : 'required '}this.$name, ';
        }

        String stateName = apiName.isNotEmpty
            ? apiName.replaceRange(0, 1, apiName[0].toUpperCase())
            : apiName;
        List<Map<String, String>> stateParams = [];
        final stateData = api.stateParams;
        String statePropsStr = '', stateParamsStr = '';
        bool isPageAble = false;
        for (final param in stateData) {
          final type = param.type;
          final name = param.name;
          stateParams.add({
            Constants.type: type,
            Constants.name: name,
          });
          if (name == 'isReachMax' || name == 'isFetching') {
            isPageAble = true;
          } else {
            statePropsStr += '    $type $name;\n';
            stateParamsStr +=
                '${type.contains('?') ? '' : 'required '}this.$name, ';
          }
        }
        if (isPageAble) {
          statePropsStr += Constants.pageProps;
          stateParamsStr += Constants.pageParams;
        }

        final String _eventStr = Constants.eventForm
            .replaceAll('%BLOC%', blocName)
            .replaceAll('%NAME%', eventName)
            .replaceAll('%PROPS%', eventPropsStr)
            .replaceAll('%PARAMS%', eventParamsStr)
            .replaceAll('%props%', eventParamsStr);

        final String _stateStr = Constants.stateForm
            .replaceAll('%BLOC%', blocName)
            .replaceAll('%NAME%', stateName)
            .replaceAll('%PROPS%', statePropsStr)
            .replaceAll('%PARAMS%', stateParamsStr)
            .replaceAll('%props%', stateParamsStr);

        final String _repoStr = Constants.repoForm
            .replaceAll('%BLOC%', toLowerCamelCase(blocName))
            .replaceAll('%TYPE%', api.stateParams.first.type)
            .replaceAll('%NAME%', apiName);
        final String _provStr = Constants.provForm
            .replaceAll('%TYPE%', api.stateParams.first.type)
            .replaceAll('%NAME%', apiName);
        final String _provImplStr = isPageAble
            ? Constants.provPageImplForm
                .replaceAll('%TYPE%', api.stateParams.first.type)
                .replaceAll('%NAME%', api.name)
                .replaceAll('%PROPS%', eventParamsStr)
                .replaceAll('%TYPE_1%', toType1(api.stateParams.first.type))
                .replaceAll('%TYPE_2%', toType2(api.stateParams.first.type))
            : Constants.provImplForm
                .replaceAll('%TYPE%', api.stateParams.first.type)
                .replaceAll('%NAME%', api.name)
                .replaceAll('%PROPS%', eventParamsStr)
                .replaceAll('%TYPE_1%', toType1(api.stateParams.first.type));

        setState(() {
          eventStr += _eventStr;
          stateStr += _stateStr;

          provStr = _provStr;
          provImplStr = _provImplStr;
          repoStr = _repoStr;
        });
      }

      setState(() {
        _result = eventStr;
        _result += stateStr;
        _result += provStr;
        _result += provImplStr;
        _result += repoStr;
      });
    });
    return _result;
  }

  // Fetch content from the json file
  Future<ApiConfig> readJson() async {
    final String response =
        await rootBundle.loadString('assets/jsons/config.json');
    // final data = await json.decode(response);
    // print('giang.pt1 $data');
    ApiConfig apiConfig = apiConfigFromJson(response);
    return apiConfig;
  }

  String toLowerCamelCase(String str) {
    if (str.isEmpty) return str;
    return str..[0].toLowerCase();
  }

  String toType1(String type) {
    if (type.length < 10) return type;
    return type.substring(10);
  }

  String toType2(String type) {
    if (type.length < 27) return type;
    return type.substring(27);
  }
}
