import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        useMaterial3: true,
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepOrangeAccent),
      ),
      home: TelaPrincipal(),
    );
  }
}

class TelaPrincipal extends StatefulWidget {
  const TelaPrincipal({super.key});

  @override
  State<TelaPrincipal> createState() => _TelaPrincipalState();
}

class _TelaPrincipalState extends State<TelaPrincipal> {
  String? savedData = "Nenhum dado salvo";
  bool estaLigado = false;
  final List<String> options = ["CDB", "Renda fixa", "Renda variável"];
  String? selectedOption;

  // Adicionando os controllers como variáveis de estado persistente
  TextEditingController controller = TextEditingController();
  TextEditingController valueController = TextEditingController();  // Novo controller para o valor do investimento

  List<Map<String, String>> investments = [];

  @override
  void initState() {
    super.initState();
    loadData();  // Carrega os dados salvos ao iniciar
  }

  // Função para salvar os dados (nome da reserva, tipo de investimento, valor e estado do switch)
  Future<void> saveData() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();

    // Salva o texto, o estado do switch e a opção selecionada
    await prefs.setString('data', controller.text);
    await prefs.setBool('switchValue', estaLigado);
    await prefs.setString('selectedOption', selectedOption ?? '');

    // Adiciona o novo investimento à lista de investimentos
    if (controller.text.isNotEmpty && selectedOption != null && valueController.text.isNotEmpty) {
      String newInvestment = '${controller.text}|$selectedOption|${valueController.text}';
      investments.add({
        'name': controller.text,
        'type': selectedOption!,
        'value': valueController.text
      });

      // Salva a lista de investimentos no SharedPreferences
      await prefs.setStringList(
        'investments',
        investments
            .map((investment) =>
        '${investment['name']}|${investment['type']}|${investment['value']}')
            .toList(),
      );
    }

    // Atualiza os dados na interface após salvar
    loadData();
  }

  // Função para carregar os dados do SharedPreferences
  Future<void> loadData() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    setState(() {
      savedData = prefs.getString('data') ?? "Nenhum dado salvo";
      selectedOption = prefs.getString('selectedOption') ?? '';
      controller.text = savedData ?? ''; // Atualiza o controller com o valor salvo
      loadInvestments();
    });
  }

  // Função para carregar os investimentos salvos
  Future<void> loadInvestments() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    List<String>? savedInvestments = prefs.getStringList('investments');
    if (savedInvestments != null) {
      setState(() {
        investments = savedInvestments
            .map((investment) => {
          'name': investment.split('|')[0],
          'type': investment.split('|')[1],
          'value': investment.split('|')[2],
        })
            .toList();
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,  // Define o fundo da tela como preto
      appBar: AppBar(
        title: Text("Investimentos", style: TextStyle(color: Colors.black)),  // Título do AppBar em preto
        backgroundColor: Colors.white,  // Cor de fundo do AppBar
        leading: IconButton(
          icon: Icon(Icons.arrow_back, color: Colors.black),  // Ícone do botão de voltar em preto
          onPressed: () {
            Navigator.pop(context); // Volta para a página anterior
          },
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Center(  // Centraliza todos os elementos na tela
          child: SingleChildScrollView(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,  // Centraliza os itens verticalmente
              crossAxisAlignment: CrossAxisAlignment.center,  // Centraliza os itens horizontalmente
              children: [
                // Campo de entrada para o nome da reserva
                TextField(
                  controller: controller,  // Usando o controller persistente
                  decoration: InputDecoration(
                    labelText: "Digite o Nome da Reserva",
                    labelStyle: TextStyle(color: Colors.white),  // Cor do texto do label
                    filled: true,
                    fillColor: Colors.grey[800],  // Cor de fundo do campo
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(10),
                      borderSide: BorderSide(color: Colors.white), // Cor da borda
                    ),
                  ),
                  style: TextStyle(color: Colors.white), // Cor do texto digitado
                ),
                SizedBox(height: 20),
                TextField(
                  controller: valueController,  // Controller para o valor
                  keyboardType: TextInputType.numberWithOptions(decimal: true),
                  decoration: InputDecoration(
                    labelText: "Valor do Investimento",
                    labelStyle: TextStyle(color: Colors.white),  // Cor do texto do label
                    filled: true,
                    fillColor: Colors.grey[800],  // Cor de fundo do campo
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(10),
                      borderSide: BorderSide(color: Colors.white), // Cor da borda
                    ),
                  ),
                  style: TextStyle(color: Colors.white), // Cor do texto digitado
                ),
                SizedBox(height: 20,),
                // Dropdown para selecionar uma opção
                DropdownButton<String>(
                  hint: Text("Selecione uma opção", style: TextStyle(color: Colors.black)),  // Cor do texto do hint
                  value: selectedOption?.isEmpty == true ? null : selectedOption,
                  items: options.map((option) {
                    return DropdownMenuItem(
                      value: option,
                      child: Text(option, style: TextStyle(color: Colors.white)),  // Cor do texto da opção
                    );
                  }).toList(),
                  onChanged: (newValue) {
                    setState(() {
                      selectedOption = newValue;
                    });
                  },
                ),
                SizedBox(height: 20),

                // Campo de entrada para o valor do investimento

                SizedBox(height: 20),

                // Botão para salvar os dados
                ElevatedButton(
                  onPressed: saveData,  // Salva os dados ao clicar
                  child: Text("Salvar Investimento"),
                  style: ElevatedButton.styleFrom(
                    primary: Colors.deepOrangeAccent,  // Cor de fundo do botão
                    onPrimary: Colors.black,  // Cor do texto do botão
                    shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(10)
                    ),
                  ),
                ),
                SizedBox(height: 20),

                // Exibe os investimentos salvos
                Column(
                  children: investments.map((investment) {
                    return Container(
                      margin: EdgeInsets.only(bottom: 10),
                      padding: EdgeInsets.all(16),
                      decoration: BoxDecoration(
                        color: Colors.grey[800],
                        borderRadius: BorderRadius.circular(10),
                      ),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text("Investimento: ${investment['name']}", style: TextStyle(color: Colors.white)),
                          Text("Tipo: ${investment['type']}", style: TextStyle(color: Colors.white)),
                          Text("Valor: R\$ ${investment['value']}", style: TextStyle(color: Colors.white)),
                        ],
                      ),
                    );
                  }).toList(),
                ),



              ],
            ),
          ),
        ),
      ),
    );
  }
}
