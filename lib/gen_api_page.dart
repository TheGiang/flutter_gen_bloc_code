import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:gen_bloc_code/widgets/input_widget.dart';

class GenApiPage extends StatefulWidget {
  GenApiPage({Key? key}) : super(key: key);

  @override
  State<GenApiPage> createState() => _GenApiPageState();
}

class _GenApiPageState extends State<GenApiPage> {
  final TextEditingController _apiNameController = TextEditingController();
  final TextEditingController _blocNameController = TextEditingController();
  final List<TextEditingController> _paramsController = [];
  final List<TextEditingController> _typesController = [];

  String _result = '';

  @override
  void initState() {
    super.initState();
    _apiNameController.addListener(() {
      _genCodeEvent();
    });
    _blocNameController.addListener(() {
      _genCodeEvent();
    });
  }

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text('GenApiPage'),
          InputWidget(
            title: 'Bloc name:',
            controller: _blocNameController,
          ),
          InputWidget(
            title: 'Api name:',
            controller: _apiNameController,
          ),
          const SizedBox(height: 20),
          const Text('Event Parameters'),
          ListView.builder(
            shrinkWrap: true,
            itemCount: _typesController.length,
            itemBuilder: (context, index) {
              return _buildInputParamItem(index);
            },
          ),
          const SizedBox(height: 20),
          Center(
            child: IconButton(
              onPressed: () {
                setState(() {
                  _onAddParam();
                });
              },
              icon: const Icon(Icons.add),
              iconSize: 20,
            ),
          ),
          const SizedBox(height: 20),
          Text(_result),
          ElevatedButton(
              onPressed: () {
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

  Widget _buildInputParamItem(index) {
    final type = _typesController[index];
    final param = _paramsController[index];
    return Row(
      children: [
        Expanded(
          child: InputWidget(
            title: 'Types:',
            controller: type,
          ),
        ),
        const SizedBox(width: 10),
        Expanded(
          child: InputWidget(
            title: 'Params:',
            controller: param,
          ),
        ),
        IconButton(
          onPressed: () {
            setState(() {
              _onRemoveParam(index);
            });
          },
          icon: const Icon(Icons.remove_circle),
          iconSize: 20,
        ),
      ],
    );
  }

  void _onAddParam() {
    _paramsController.add(TextEditingController()..addListener(_genCodeEvent));
    _typesController.add(TextEditingController()..addListener(_genCodeEvent));
  }

  void _onRemoveParam(index) {
    _paramsController.removeAt(index);
    _typesController.removeAt(index);
  }

  void _genCodeEvent() {
    String _event = '''
class %NAME%Event extends %BLOC%Event {
%PROPS%
  %NAME%Event(%PARAMS%);

  @override
  List<Object> get props => [%props%];
}
    ''';

    setState(() {
      String eventName = _apiNameController.text;
      if (eventName.isNotEmpty) {
        eventName =
            eventName.replaceFirst(eventName[0], eventName[0].toUpperCase());
      }
      String props = '', params = '';
      int length = _typesController.length;
      for (int i = 0; i < length; i++) {
        props +=
            '    ${_typesController[i].text} ${_paramsController[i].text};\n';
        params +=
            '${_typesController[i].text.contains('?') ? '' : 'required '}this.${_paramsController[i].text}, ';
      }

      _result = _event
          .replaceAll('%BLOC%', _blocNameController.text)
          .replaceAll('%NAME%', eventName)
          .replaceAll('%PROPS%', props)
          .replaceAll('%PARAMS%', params)
          .replaceAll('%props%', params);
    });
  }

  void _genCodeState() {
    String pageProps = '''
  final bool isReachMax;
  final bool isFetching;
    ''';

    String pageParams = '{this.isReachMax = false, this.isFetching = false}';

    String state = '''
class %NAME%State extends %BLOC%State {
  final ApiResult<%TYPE%>? data;
  %pageProps%

  ReportFindState(LoadingState state, this.data, %pageParams%)
      : super(state);

  @override
  List<Object?> get props => [state, data];
}
    ''';

    setState(() {
      String eventName = _apiNameController.text;
      if (eventName.isNotEmpty) {
        eventName =
            eventName.replaceFirst(eventName[0], eventName[0].toUpperCase());
      }
      String props = '', params = '';
      int length = _typesController.length;
      for (int i = 0; i < length; i++) {
        props +=
            '    ${_typesController[i].text} ${_paramsController[i].text};\n';
        params +=
            '${_typesController[i].text.contains('?') ? '' : 'required '}this.${_paramsController[i].text}, ';
      }

      _result = state
          .replaceAll('%BLOC%', _blocNameController.text)
          .replaceAll('%NAME%', eventName)
          .replaceAll('%PROPS%', props)
          .replaceAll('%PARAMS%', params)
          .replaceAll('%props%', params);
    });
  }
}
