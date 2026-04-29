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
        colorScheme: ColorScheme.fromSeed(
          seedColor: const Color(0xFFFF6E40),
          brightness: Brightness.dark,
        ),
        scaffoldBackgroundColor: const Color(0xFF121212),
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
  String? savedData = '';
  final List<String> options = ['CDB', 'Renda fixa', 'Renda variável'];
  String? selectedOption;

  TextEditingController controller = TextEditingController();
  TextEditingController valueController = TextEditingController();

  List<Map<String, String>> investments = [];

  final _formKey = GlobalKey<FormState>();

  static const Color kPrimary = Color(0xFFFF6E40);
  static const Color kSurface = Color(0xFF1E1E1E);

  @override
  void initState() {
    super.initState();
    loadData();
  }

  Future<void> saveData() async {
    if (!_formKey.currentState!.validate()) return;

    SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs.setString('data', controller.text);
    await prefs.setString('selectedOption', selectedOption ?? '');

    if (controller.text.isNotEmpty && selectedOption != null && valueController.text.isNotEmpty) {
      investments.add({
        'name': controller.text,
        'type': selectedOption!,
        'value': valueController.text,
      });
      await prefs.setStringList(
        'investments',
        investments.map((inv) => '${inv['name']}|${inv['type']}|${inv['value']}').toList(),
      );
    }

    controller.clear();
    valueController.clear();
    setState(() => selectedOption = null);

    if (mounted) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: const Text('Investimento salvo com sucesso!'),
          backgroundColor: kPrimary,
          behavior: SnackBarBehavior.floating,
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
          margin: const EdgeInsets.all(16),
        ),
      );
    }
    loadData();
  }

  Future<void> loadData() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    final saved = prefs.getString('data') ?? '';
    final option = prefs.getString('selectedOption') ?? '';
    final savedInvestments = prefs.getStringList('investments');

    setState(() {
      savedData = saved;
      selectedOption = option.isEmpty ? null : option;
      if (savedInvestments != null) {
        investments = savedInvestments.map((inv) {
          final parts = inv.split('|');
          return {
            'name': parts[0],
            'type': parts[1],
            'value': parts[2],
          };
        }).toList();
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF121212),
      appBar: AppBar(
        backgroundColor: kPrimary,
        foregroundColor: Colors.white,
        elevation: 0,
        title: const Text(
          'Caixinhas',
          style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
        ),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.white),
          onPressed: () => Navigator.pop(context),
        ),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            // ── Form Card ───────────────────────────────────────────
            Container(
              padding: const EdgeInsets.all(20),
              decoration: BoxDecoration(
                color: kSurface,
                borderRadius: BorderRadius.circular(20),
                border: Border.all(color: Colors.white12),
              ),
              child: Form(
                key: _formKey,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    const Text(
                      'Nova Caixinha',
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(height: 16),
                    TextFormField(
                      controller: controller,
                      style: const TextStyle(color: Colors.white),
                      decoration: InputDecoration(
                        labelText: 'Nome da reserva',
                        labelStyle: const TextStyle(color: Colors.white54),
                        prefixIcon: const Icon(Icons.savings_outlined, color: kPrimary),
                        filled: true,
                        fillColor: const Color(0xFF2A2A2A),
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(12),
                          borderSide: const BorderSide(color: Colors.white12),
                        ),
                        enabledBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(12),
                          borderSide: const BorderSide(color: Colors.white12),
                        ),
                        focusedBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(12),
                          borderSide: const BorderSide(color: kPrimary, width: 2),
                        ),
                      ),
                      validator: (v) => (v == null || v.isEmpty) ? 'Informe o nome da reserva' : null,
                    ),
                    const SizedBox(height: 14),
                    TextFormField(
                      controller: valueController,
                      keyboardType: const TextInputType.numberWithOptions(decimal: true),
                      style: const TextStyle(color: Colors.white),
                      decoration: InputDecoration(
                        labelText: 'Valor (R\$)',
                        labelStyle: const TextStyle(color: Colors.white54),
                        prefixIcon: const Icon(Icons.attach_money_rounded, color: kPrimary),
                        filled: true,
                        fillColor: const Color(0xFF2A2A2A),
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(12),
                          borderSide: const BorderSide(color: Colors.white12),
                        ),
                        enabledBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(12),
                          borderSide: const BorderSide(color: Colors.white12),
                        ),
                        focusedBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(12),
                          borderSide: const BorderSide(color: kPrimary, width: 2),
                        ),
                      ),
                      validator: (v) => (v == null || v.isEmpty) ? 'Informe o valor' : null,
                    ),
                    const SizedBox(height: 14),
                    DropdownButtonFormField<String>(
                      value: selectedOption,
                      dropdownColor: kSurface,
                      style: const TextStyle(color: Colors.white),
                      decoration: InputDecoration(
                        labelText: 'Tipo de investimento',
                        labelStyle: const TextStyle(color: Colors.white54),
                        prefixIcon: const Icon(Icons.category_outlined, color: kPrimary),
                        filled: true,
                        fillColor: const Color(0xFF2A2A2A),
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(12),
                          borderSide: const BorderSide(color: Colors.white12),
                        ),
                        enabledBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(12),
                          borderSide: const BorderSide(color: Colors.white12),
                        ),
                        focusedBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(12),
                          borderSide: const BorderSide(color: kPrimary, width: 2),
                        ),
                      ),
                      hint: const Text('Selecione', style: TextStyle(color: Colors.white38)),
                      items: options
                          .map((opt) => DropdownMenuItem(value: opt, child: Text(opt)))
                          .toList(),
                      onChanged: (v) => setState(() => selectedOption = v),
                      validator: (v) => (v == null || v.isEmpty) ? 'Selecione o tipo' : null,
                    ),
                    const SizedBox(height: 20),
                    SizedBox(
                      height: 50,
                      child: ElevatedButton.icon(
                        onPressed: saveData,
                        icon: const Icon(Icons.save_rounded),
                        label: const Text('Salvar Caixinha'),
                        style: ElevatedButton.styleFrom(
                          backgroundColor: kPrimary,
                          foregroundColor: Colors.white,
                          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                          elevation: 0,
                          textStyle: const TextStyle(fontSize: 15, fontWeight: FontWeight.bold),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),

            const SizedBox(height: 28),

            if (investments.isNotEmpty) ...[
              const Text(
                'Minhas Caixinhas',
                style: TextStyle(color: Colors.white, fontSize: 16, fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 12),
              ...investments.map((inv) => _InvestmentCard(investment: inv)).toList(),
            ] else
              Padding(
                padding: const EdgeInsets.symmetric(vertical: 32),
                child: Column(
                  children: [
                    Icon(Icons.savings_outlined, size: 64, color: Colors.white12),
                    const SizedBox(height: 12),
                    const Text(
                      'Nenhuma caixinha criada ainda',
                      style: TextStyle(color: Colors.white38, fontSize: 14),
                    ),
                  ],
                ),
              ),
          ],
        ),
      ),
    );
  }
}

class _InvestmentCard extends StatelessWidget {
  const _InvestmentCard({required this.investment});
  final Map<String, String> investment;

  static const Map<String, Color> _typeColors = {
    'CDB': Color(0xFF4CAF50),
    'Renda fixa': Color(0xFF2196F3),
    'Renda variável': Color(0xFFFF9800),
  };

  @override
  Widget build(BuildContext context) {
    final color = _typeColors[investment['type']] ?? const Color(0xFFFF6E40);
    return Container(
      margin: const EdgeInsets.only(bottom: 10),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: const Color(0xFF1E1E1E),
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: Colors.white12),
      ),
      child: Row(
        children: [
          Container(
            width: 44,
            height: 44,
            decoration: BoxDecoration(
              color: color.withOpacity(0.15),
              borderRadius: BorderRadius.circular(12),
            ),
            child: Center(
              child: Text(
                investment['name']!.isNotEmpty ? investment['name']![0].toUpperCase() : 'C',
                style: TextStyle(color: color, fontSize: 18, fontWeight: FontWeight.bold),
              ),
            ),
          ),
          const SizedBox(width: 14),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  investment['name'] ?? '',
                  style: const TextStyle(color: Colors.white, fontWeight: FontWeight.w600, fontSize: 14),
                ),
                const SizedBox(height: 4),
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
                  decoration: BoxDecoration(
                    color: color.withOpacity(0.12),
                    borderRadius: BorderRadius.circular(4),
                  ),
                  child: Text(
                    investment['type'] ?? '',
                    style: TextStyle(color: color, fontSize: 11, fontWeight: FontWeight.w600),
                  ),
                ),
              ],
            ),
          ),
          Text(
            'R\$ ${investment['value']}',
            style: const TextStyle(color: Color(0xFFFF6E40), fontWeight: FontWeight.bold, fontSize: 14),
          ),
        ],
      ),
    );
  }
}
