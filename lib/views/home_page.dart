import 'package:dynamic_theme/dynamic_theme.dart';
import 'package:flutter/material.dart';
import 'package:search_cep/models/result_cep.dart';
import 'package:search_cep/services/via_cep_service.dart';
import 'package:share/share.dart';

class HomePage extends StatefulWidget {
  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  var _searchCepController = TextEditingController();
  bool _loading = false;
  bool _enableField = true;
  ResultCep _result;

  @override
  void dispose() {
    super.dispose();
    _searchCepController.clear();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Consultar CEP'),
        actions: <Widget>[
          IconButton(
            onPressed: () {
              changeBrightness();
            },
            icon: Icon(
              Icons.wb_sunny,
            ),
          ),
          IconButton(
            onPressed: () {
              Share.share(
                  " CEP: ${_result.cep ?? ""} \n Logradouro: ${_result.logradouro ?? ""} \n Complemento: ${_result.complemento ?? ""}"+
                  " \n Bairro: ${_result.bairro ?? ""} \n Localidade: ${_result.localidade ?? ""} \n UF: ${_result.uf ?? ""} \n "+
                  "Unidade: ${_result.unidade ?? ""} \n IBGE: ${_result.ibge ?? ""} \n GIA: ${_result.gia ?? ""} \n");
            },
            icon: Icon(
              Icons.share,
            ),
          ),
        ],
      ),
      body: SingleChildScrollView(
        padding: EdgeInsets.all(20.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: <Widget>[
            _buildSearchCepTextField(),
            _buildSearchCepButton(),
            _buildResultForm()
          ],
        ),
      ),
    );
  }

  void changeBrightness() {
    print('change brightness');
    DynamicTheme.of(context).setBrightness(
        Theme.of(context).brightness == Brightness.dark
            ? Brightness.light
            : Brightness.dark);
  }

  Widget _buildSearchCepTextField() {
    return TextFormField(
      autofocus: true,
      keyboardType: TextInputType.number,
      textInputAction: TextInputAction.done,
      decoration: InputDecoration(labelText: 'Cep'),
      controller: _searchCepController,
      enabled: _enableField,
      validator: (text){
        return text.isEmpty ? "Insira um CEP!" : null;
      },
    );
  }

  Widget _buildSearchCepButton() {
    return Padding(
      padding: const EdgeInsets.only(top: 20.0),
      child: RaisedButton(
        onPressed: _searchCep,
        child: _loading ? _circularLoading() : Text('Consultar'),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
      ),
    );
  }

  void _searching(bool enable) {
    setState(() {
      //_result = enable ? '' : _result;
      _loading = enable;
      _enableField = !enable;
    });
  }

  Widget _circularLoading() {
    return Container(
      height: 15.0,
      width: 15.0,
      child: CircularProgressIndicator(),
    );
  }

  Future _searchCep() async {
    _searching(true);

    final cep = _searchCepController.text;

    final resultCep = await ViaCepService.fetchCep(cep: cep);
    print(resultCep.localidade); // Exibindo somente a localidade no terminal

    setState(() {
      _result = resultCep;
      print(_result.cep);
    });

    _searching(false);
  }

  Widget _buildResultForm() {
    return Container(
        padding: EdgeInsets.only(top: 20.0),
        child: Column(
          children: <Widget>[
            _textForm("CEP", _result.cep),
            _textForm("Logradouro", _result.logradouro),
            _textForm("complemento", _result.complemento),
            _textForm("Bairro", _result.bairro),
            _textForm("Localidade", _result.localidade),
            _textForm("UF", _result.uf),
            _textForm("Unidade", _result.unidade),
            _textForm("IBGE", _result.ibge),
            _textForm("GIA", _result.gia),
          ],
        ));
  }

  Widget _textForm(String nome, String result) {
    final myController = TextEditingController();
    myController.text = result ?? "";

    return TextFormField(
      controller: myController,
      decoration: InputDecoration(
        labelText: nome,
      ),
      enabled: false,
    );
  }
}
