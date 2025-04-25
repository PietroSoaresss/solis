import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:flutter/services.dart';
import 'dart:convert';

void main() {
  WidgetsFlutterBinding.ensureInitialized();
  SystemChrome.setSystemUIOverlayStyle(
    const SystemUiOverlayStyle(
      statusBarColor: Colors.transparent,
      statusBarIconBrightness: Brightness.dark,
    ),
  );
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        useMaterial3: true,
        colorScheme: ColorScheme.fromSeed(
          seedColor: const Color(0xFFFF6E40), // Verde como cor principal
          brightness: Brightness.light,
        ),
        fontFamily: 'Poppins',
        scaffoldBackgroundColor: Colors.grey[50],
        inputDecorationTheme: InputDecorationTheme(
          filled: true,
          fillColor: Colors.white,
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(12),
            borderSide: BorderSide(color: Colors.grey[300]!),
          ),
          enabledBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(12),
            borderSide: BorderSide(color: Colors.grey[300]!),
          ),
          focusedBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(12),
            borderSide: const BorderSide(color: Color(0xFFFF6E40), width: 2),
          ),
          contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
        ),
        elevatedButtonTheme: ElevatedButtonThemeData(
          style: ElevatedButton.styleFrom(
            elevation: 0,
            padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 14),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(12),
            ),
            backgroundColor: const Color(0xFFFF6E40),
            foregroundColor: Colors.white,
          ),
        ),
      ),
      darkTheme: ThemeData(
        useMaterial3: true,
        colorScheme: ColorScheme.fromSeed(
          seedColor: const Color(0xFFFF6E40), // Verde mais claro para dark mode
          brightness: Brightness.dark,
        ),
        fontFamily: 'Poppins',
        scaffoldBackgroundColor: const Color(0xFF121212),
        inputDecorationTheme: InputDecorationTheme(
          filled: true,
          fillColor: const Color(0xFF1E1E1E),
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(12),
            borderSide: BorderSide(color: Colors.grey[700]!),
          ),
          enabledBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(12),
            borderSide: BorderSide(color: Colors.grey[700]!),
          ),
          focusedBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(12),
            borderSide: const BorderSide(color: Color(0xFFFF6E40), width: 2),
          ),
          contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
          labelStyle: TextStyle(color: Colors.grey[400]),
        ),
        elevatedButtonTheme: ElevatedButtonThemeData(
          style: ElevatedButton.styleFrom(
            elevation: 0,
            padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 14),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(12),
            ),
            backgroundColor: const Color(0xFFFF6E40),
            foregroundColor: Colors.white,
          ),
        ),
      ),
      themeMode: ThemeMode.system,
      home: const TelaInvestimentos(),
    );
  }
}

class TelaInvestimentos extends StatefulWidget {
  const TelaInvestimentos({Key? key}) : super(key: key);

  @override
  State<TelaInvestimentos> createState() => _TelaInvestimentosState();
}

class _TelaInvestimentosState extends State<TelaInvestimentos> with SingleTickerProviderStateMixin {
  final TextEditingController nameController = TextEditingController();
  final TextEditingController valueController = TextEditingController();
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();

  String? selectedOption;
  bool isAutoInvest = false;

  List<Map<String, dynamic>> investments = [];
  double totalInvested = 0.0;

  late TabController _tabController;
  bool isLoading = true;

  final List<String> investmentTypes = [
    "CDB",
    "Tesouro Direto",
    "Renda Fixa",
    "Renda Variável",
    "Fundos Imobiliários",
    "Ações"
  ];

  final Map<String, Color> typeColors = {
    "CDB": const Color(0xFF4CAF50),
    "Tesouro Direto": const Color(0xFF2196F3),
    "Renda Fixa": const Color(0xFF9C27B0),
    "Renda Variável": const Color(0xFFFF9800),
    "Fundos Imobiliários": const Color(0xFF795548),
    "Ações": const Color(0xFFE91E63),
  };

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 2, vsync: this);
    loadData();
  }

  @override
  void dispose() {
    nameController.dispose();
    valueController.dispose();
    _tabController.dispose();
    super.dispose();
  }

  Future<void> loadData() async {
    setState(() {
      isLoading = true;
    });

    try {
      SharedPreferences prefs = await SharedPreferences.getInstance();

      isAutoInvest = prefs.getBool('isAutoInvest') ?? false;

      String? investmentsJson = prefs.getString('investments');
      if (investmentsJson != null) {
        List<dynamic> decoded = jsonDecode(investmentsJson);
        investments = decoded.map((item) => Map<String, dynamic>.from(item)).toList();
      }

      calculateTotalInvested();
    } catch (e) {
      print('Erro ao carregar dados: $e');
    } finally {
      setState(() {
        isLoading = false;
      });
    }
  }

  void calculateTotalInvested() {
    totalInvested = 0;
    for (var investment in investments) {
      totalInvested += double.parse(investment['value'].toString());
    }
  }

  Future<void> saveInvestment() async {
    if (!_formKey.currentState!.validate()) return;

    SharedPreferences prefs = await SharedPreferences.getInstance();

    await prefs.setBool('isAutoInvest', isAutoInvest);

    final double value = double.parse(valueController.text.replaceAll(RegExp(r'[^\d,.]'), '').replaceAll(',', '.'));

    Map<String, dynamic> newInvestment = {
      'id': DateTime.now().millisecondsSinceEpoch.toString(),
      'name': nameController.text.trim(),
      'type': selectedOption,
      'value': value,
      'date': DateTime.now().toString(),
    };

    investments.add(newInvestment);

    await prefs.setString('investments', jsonEncode(investments));

    nameController.clear();
    valueController.clear();
    setState(() {
      selectedOption = null;
      calculateTotalInvested();
    });

    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: const Text('Investimento salvo com sucesso!'),
        backgroundColor: Theme.of(context).colorScheme.primary,
        behavior: SnackBarBehavior.floating,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
        margin: const EdgeInsets.all(16),
      ),
    );
  }

  Future<void> deleteInvestment(String id) async {
    setState(() {
      investments.removeWhere((investment) => investment['id'] == id);
      calculateTotalInvested();
    });

    SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs.setString('investments', jsonEncode(investments));

    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: const Text('Investimento removido'),
        backgroundColor: Colors.redAccent,
        behavior: SnackBarBehavior.floating,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
        margin: const EdgeInsets.all(16),
        action: SnackBarAction(
          label: 'DESFAZER',
          textColor: Colors.white,
          onPressed: () {
          },
        ),
      ),
    );
  }

  String formatCurrency(dynamic value) {
    double numValue = 0.0;

    if (value is String) {
      numValue = double.tryParse(value.replaceAll(RegExp(r'[^\d,.]'), '').replaceAll(',', '.')) ?? 0.0;
    } else if (value is num) {
      numValue = value.toDouble();
    }

    // Formatar manualmente sem usar a biblioteca intl
    String valueStr = numValue.toStringAsFixed(2);

    // Adicionar separador de milhares
    final parts = valueStr.split('.');
    final wholePart = parts[0];
    final decimalPart = parts.length > 1 ? parts[1] : '00';

    String result = '';
    for (int i = 0; i < wholePart.length; i++) {
      result += wholePart[wholePart.length - 1 - i];
      if ((i + 1) % 3 == 0 && i != wholePart.length - 1) {
        result += '.';
      }
    }

    result = result.split('').reversed.join('');
    return 'R\$ $result,$decimalPart';
  }

  String formatDate(String dateStr) {
    try {
      final date = DateTime.parse(dateStr);
      return '${date.day.toString().padLeft(2, '0')}/${date.month.toString().padLeft(2, '0')}/${date.year}';
    } catch (e) {
      return 'Data desconhecida';
    }
  }

  @override
  Widget build(BuildContext context) {
    final isDarkMode = Theme.of(context).brightness == Brightness.dark;

    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'Meus Investimentos',
          style: TextStyle(
            fontWeight: FontWeight.bold,
          ),
        ),
        elevation: 0,
        actions: [
          IconButton(
            icon: const Icon(Icons.refresh),
            onPressed: loadData,
            tooltip: 'Atualizar',
          ),
        ],
        bottom: TabBar(
          controller: _tabController,
          indicatorColor: Theme.of(context).colorScheme.primary,
          indicatorWeight: 3,
          labelColor: Theme.of(context).colorScheme.primary,
          unselectedLabelColor: Theme.of(context).colorScheme.onSurface.withOpacity(0.7),
          tabs: [
            const Tab(
              text: 'Meu Portfolio',
              icon: Icon(Icons.pie_chart),
            ),
            const Tab(
              text: 'Novo Investimento',
              icon: Icon(Icons.add_circle_outline),
            ),
          ],
        ),
      ),
      body: isLoading
          ? const Center(
        child: CircularProgressIndicator(),
      )
          : TabBarView(
        controller: _tabController,
        children: [
          // TAB 1: Portfolio
          BuildPortfolioTab(),

          // TAB 2: Novo Investimento
          BuildNewInvestmentTab(),
        ],
      ),
    );
  }

  Widget BuildPortfolioTab() {
    return CustomScrollView(
      slivers: [
        SliverToBoxAdapter(
          child: Padding(
            padding: const EdgeInsets.all(16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Card(
                  elevation: 0,
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
                  color: Theme.of(context).colorScheme.primary,
                  child: Padding(
                    padding: const EdgeInsets.all(20),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'Total Investido',
                          style: TextStyle(
                            color: Colors.white.withOpacity(0.8),
                            fontSize: 16,
                          ),
                        ),
                        const SizedBox(height: 8),
                        Text(
                          formatCurrency(totalInvested),
                          style: const TextStyle(
                            color: Colors.white,
                            fontSize: 28,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        const SizedBox(height: 16),
                        Row(
                          children: [
                            Text(
                              '${investments.length} investimentos',
                              style: TextStyle(
                                color: Colors.white.withOpacity(0.9),
                                fontSize: 14,
                              ),
                            ),
                            const Spacer(),
                            IconButton(
                              onPressed: () {
                                _tabController.animateTo(1);
                              },
                              icon: const Icon(Icons.add, color: Colors.white),
                              tooltip: 'Adicionar Investimento',
                              style: IconButton.styleFrom(
                                backgroundColor: Colors.white.withOpacity(0.2),
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                ),

                const SizedBox(height: 24),

                const Text(
                  'Meus Investimentos',
                  style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ],
            ),
          ),
        ),

        investments.isEmpty
            ? SliverToBoxAdapter(
          child: Center(
            child: Padding(
              padding: const EdgeInsets.all(32),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(
                    Icons.savings_outlined,
                    size: 80,
                    color: Theme.of(context).colorScheme.primary.withOpacity(0.3),
                  ),
                  const SizedBox(height: 16),
                  const Text(
                    'Nenhum investimento cadastrado',
                    style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                  const SizedBox(height: 8),
                  Text(
                    'Adicione seu primeiro investimento clicando no botão acima',
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      color: Theme.of(context).colorScheme.onSurface.withOpacity(0.7),
                    ),
                  ),
                  const SizedBox(height: 24),
                  ElevatedButton.icon(
                    onPressed: () {
                      _tabController.animateTo(1);
                    },
                    icon: const Icon(Icons.add),
                    label: const Text('Adicionar Investimento'),
                  ),
                ],
              ),
            ),
          ),
        )
            : SliverList(
          delegate: SliverChildBuilderDelegate(
                (context, index) {
              final investment = investments[index];
              final Color typeColor = typeColors[investment['type']] ??
                  Theme.of(context).colorScheme.primary;

              // Formatando a data sem usar a biblioteca intl
              String formattedDate = formatDate(investment['date'] ?? DateTime.now().toString());

              return Padding(
                padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                child: Card(
                  elevation: 0,
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                  child: InkWell(
                    borderRadius: BorderRadius.circular(12),
                    onTap: () {
                      // Detalhes do investimento (não implementado)
                    },
                    child: Padding(
                      padding: const EdgeInsets.all(16),
                      child: Row(
                        children: [
                          // Círculo com a primeira letra
                          Container(
                            width: 50,
                            height: 50,
                            decoration: BoxDecoration(
                              color: typeColor.withOpacity(0.2),
                              shape: BoxShape.circle,
                            ),
                            child: Center(
                              child: Text(
                                investment['name'].isNotEmpty ? investment['name'][0].toUpperCase() : 'I',
                                style: TextStyle(
                                  color: typeColor,
                                  fontSize: 20,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                            ),
                          ),
                          const SizedBox(width: 16),
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  investment['name'],
                                  style: const TextStyle(
                                    fontSize: 16,
                                    fontWeight: FontWeight.w600,
                                  ),
                                ),
                                const SizedBox(height: 4),
                                Row(
                                  children: [
                                    Container(
                                      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
                                      decoration: BoxDecoration(
                                        color: typeColor.withOpacity(0.1),
                                        borderRadius: BorderRadius.circular(4),
                                      ),
                                      child: Text(
                                        investment['type'],
                                        style: TextStyle(
                                          color: typeColor,
                                          fontSize: 12,
                                          fontWeight: FontWeight.w500,
                                        ),
                                      ),
                                    ),
                                    const SizedBox(width: 8),
                                    Text(
                                      formattedDate,
                                      style: TextStyle(
                                        fontSize: 12,
                                        color: Theme.of(context).colorScheme.onSurface.withOpacity(0.6),
                                      ),
                                    ),
                                  ],
                                ),
                              ],
                            ),
                          ),
                          Column(
                            crossAxisAlignment: CrossAxisAlignment.end,
                            children: [
                              Text(
                                formatCurrency(investment['value']),
                                style: TextStyle(
                                  fontSize: 16,
                                  fontWeight: FontWeight.bold,
                                  color: Theme.of(context).colorScheme.primary,
                                ),
                              ),
                              const SizedBox(height: 8),
                              GestureDetector(
                                onTap: () => deleteInvestment(investment['id']),
                                child: const Icon(
                                  Icons.delete_outline,
                                  size: 20,
                                  color: Colors.redAccent,
                                ),
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
              );
            },
            childCount: investments.length,
          ),
        ),
      ],
    );
  }

  Widget BuildNewInvestmentTab() {
    return SingleChildScrollView(
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Form(
          key: _formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const SizedBox(height: 8),
              const Text(
                'Novo Investimento',
                style: TextStyle(
                  fontSize: 22,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 8),
              Text(
                'Preencha os dados abaixo para registrar um novo investimento.',
                style: TextStyle(
                  color: Theme.of(context).colorScheme.onSurface.withOpacity(0.7),
                ),
              ),
              const SizedBox(height: 24),

              // Nome do investimento
              TextFormField(
                controller: nameController,
                decoration: const InputDecoration(
                  labelText: 'Nome do Investimento',
                  prefixIcon: Icon(Icons.label_outline),
                  hintText: 'Ex: Reserva de Emergência',
                ),
                validator: (value) {
                  if (value == null || value.trim().isEmpty) {
                    return 'Por favor, informe o nome do investimento';
                  }
                  return null;
                },
              ),
              const SizedBox(height: 16),

              // Tipo de investimento
              DropdownButtonFormField<String>(
                value: selectedOption,
                decoration: const InputDecoration(
                  labelText: 'Tipo de Investimento',
                  prefixIcon: Icon(Icons.category_outlined),
                ),
                items: investmentTypes.map((type) {
                  return DropdownMenuItem(
                    value: type,
                    child: Text(type),
                  );
                }).toList(),
                onChanged: (newValue) {
                  setState(() {
                    selectedOption = newValue;
                  });
                },
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Por favor, selecione um tipo de investimento';
                  }
                  return null;
                },
                hint: const Text('Selecione o tipo'),
              ),
              const SizedBox(height: 16),

              // Valor
              TextFormField(
                controller: valueController,
                keyboardType: const TextInputType.numberWithOptions(decimal: true),
                decoration: const InputDecoration(
                  labelText: 'Valor do Investimento',
                  prefixIcon: Icon(Icons.attach_money),
                  hintText: 'Ex: 1000,00',
                ),
                validator: (value) {
                  if (value == null || value.trim().isEmpty) {
                    return 'Por favor, informe o valor';
                  }
                  try {
                    double.parse(value.replaceAll(RegExp(r'[^\d,.]'), '').replaceAll(',', '.'));
                  } catch (e) {
                    return 'Por favor, informe um valor válido';
                  }
                  return null;
                },
              ),
              const SizedBox(height: 24),

              // Investimento automático
              SwitchListTile(
                title: const Text('Investimento Automático'),
                subtitle: const Text('Ativar reinvestimento automático dos rendimentos'),
                value: isAutoInvest,
                onChanged: (value) {
                  setState(() {
                    isAutoInvest = value;
                  });
                },
                activeColor: Theme.of(context).colorScheme.primary,
                contentPadding: EdgeInsets.zero,
              ),
              const SizedBox(height: 32),

              // Botão de salvar
              SizedBox(
                width: double.infinity,
                height: 54,
                child: ElevatedButton(
                  onPressed: saveInvestment,
                  child: const Text(
                    'SALVAR INVESTIMENTO',
                    style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
              ),
              const SizedBox(height: 16),

              // Botão de cancelar
              SizedBox(
                width: double.infinity,
                height: 54,
                child: TextButton(
                  onPressed: () {
                    nameController.clear();
                    valueController.clear();
                    setState(() {
                      selectedOption = null;
                    });
                  },
                  style: TextButton.styleFrom(
                    foregroundColor: Theme.of(context).colorScheme.onSurface.withOpacity(0.8),
                  ),
                  child: const Text('LIMPAR CAMPOS'),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
