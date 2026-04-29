import 'dart:math';
import 'package:flutter/material.dart';
import 'invest.dart' show TelaInvestimentos;

class AppTest extends StatefulWidget {
  const AppTest({super.key});

  @override
  _AppTestState createState() => _AppTestState();
}

class _AppTestState extends State<AppTest> {
  int _selectedIndex = 0;

  void _onItemTapped(int index) {
    if (index == 1) {
      Navigator.push(
        context,
        MaterialPageRoute(builder: (context) => const _InvestimentosWrapper()),
      );
      return;
    }
    setState(() => _selectedIndex = index);
  }

  @override
  Widget build(BuildContext context) {
    final random = Random();
    final balance = (random.nextInt(4001) + 1000).toDouble() + random.nextDouble();

    return Scaffold(
      backgroundColor: const Color(0xFF121212),
      body: CustomScrollView(
        slivers: [
          // ── App Bar ───────────────────────────────────────────────
          SliverAppBar(
            expandedHeight: 160,
            pinned: true,
            backgroundColor: const Color(0xFFFF6E40),
            flexibleSpace: FlexibleSpaceBar(
              background: Container(
                decoration: const BoxDecoration(
                  gradient: LinearGradient(
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight,
                    colors: [Color(0xFFBF360C), Color(0xFFFF6E40)],
                  ),
                ),
                child: SafeArea(
                  child: Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Row(
                              children: [
                                Container(
                                  width: 44,
                                  height: 44,
                                  decoration: BoxDecoration(
                                    shape: BoxShape.circle,
                                    color: Colors.white.withOpacity(0.25),
                                    border: Border.all(color: Colors.white38, width: 2),
                                  ),
                                  child: const Icon(Icons.person_outline, color: Colors.white, size: 24),
                                ),
                                const SizedBox(width: 10),
                                Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: const [
                                    Text('Olá,', style: TextStyle(color: Colors.white70, fontSize: 13)),
                                    Text(
                                      'Pietro 👋',
                                      style: TextStyle(color: Colors.white, fontSize: 16, fontWeight: FontWeight.bold),
                                    ),
                                  ],
                                ),
                              ],
                            ),
                            Row(
                              children: [
                                _AppBarIconButton(icon: Icons.help_outline_rounded),
                                const SizedBox(width: 4),
                                _AppBarIconButton(icon: Icons.notifications_outlined),
                              ],
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ),
          ),

          SliverToBoxAdapter(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // ── Balance Card ────────────────────────────────────
                Padding(
                  padding: const EdgeInsets.fromLTRB(16, 16, 16, 0),
                  child: Container(
                    width: double.infinity,
                    padding: const EdgeInsets.all(20),
                    decoration: BoxDecoration(
                      gradient: const LinearGradient(
                        colors: [Color(0xFF1E1E1E), Color(0xFF2A2A2A)],
                        begin: Alignment.topLeft,
                        end: Alignment.bottomRight,
                      ),
                      borderRadius: BorderRadius.circular(20),
                      border: Border.all(color: Colors.white12),
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            const Text(
                              'Saldo disponível',
                              style: TextStyle(color: Colors.white54, fontSize: 13),
                            ),
                            Container(
                              padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                              decoration: BoxDecoration(
                                color: Colors.green.withOpacity(0.15),
                                borderRadius: BorderRadius.circular(20),
                              ),
                              child: Row(
                                children: const [
                                  Icon(Icons.arrow_upward_rounded, size: 12, color: Colors.greenAccent),
                                  SizedBox(width: 3),
                                  Text('2,3%', style: TextStyle(color: Colors.greenAccent, fontSize: 11, fontWeight: FontWeight.w600)),
                                ],
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(height: 6),
                        Text(
                          'R\$ ${balance.toStringAsFixed(2).replaceAll('.', ',')}',
                          style: const TextStyle(
                            color: Colors.white,
                            fontSize: 30,
                            fontWeight: FontWeight.bold,
                            letterSpacing: 0.5,
                          ),
                        ),
                        const SizedBox(height: 16),
                        const Divider(color: Colors.white12, height: 1),
                        const SizedBox(height: 14),
                        Row(
                          children: const [
                            _MiniStat(label: 'Receitas', value: 'R\$ 6.200', color: Colors.greenAccent),
                            SizedBox(width: 24),
                            _MiniStat(label: 'Despesas', value: 'R\$ 2.391', color: Colors.redAccent),
                          ],
                        ),
                      ],
                    ),
                  ),
                ),

                // ── Quick Actions ───────────────────────────────────
                Padding(
                  padding: const EdgeInsets.fromLTRB(16, 20, 16, 0),
                  child: Container(
                    padding: const EdgeInsets.symmetric(vertical: 16),
                    decoration: BoxDecoration(
                      color: const Color(0xFF1E1E1E),
                      borderRadius: BorderRadius.circular(20),
                      border: Border.all(color: Colors.white12),
                    ),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      children: const [
                        _QuickAction(icon: Icons.pix_rounded, label: 'Pix'),
                        _QuickAction(icon: Icons.qr_code_scanner_rounded, label: 'Pagar'),
                        _QuickAction(icon: Icons.phone_android_rounded, label: 'Recarga'),
                        _QuickAction(icon: Icons.add_rounded, label: 'Depositar'),
                      ],
                    ),
                  ),
                ),

                // ── Section: Produtos ───────────────────────────────
                const Padding(
                  padding: EdgeInsets.fromLTRB(20, 28, 20, 12),
                  child: Text(
                    'Seus produtos',
                    style: TextStyle(color: Colors.white, fontSize: 16, fontWeight: FontWeight.bold),
                  ),
                ),

                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 16),
                  child: Column(
                    children: [
                      _ProductCard(
                        icon: Icons.show_chart_rounded,
                        iconColor: const Color(0xFFFF6E40),
                        title: 'Investimentos',
                        subtitle: 'Carteira diversificada',
                        trailing: 'R\$ 4.504,13',
                        onTap: () => Navigator.push(
                          context,
                          MaterialPageRoute(builder: (context) => const _InvestimentosWrapper()),
                        ),
                      ),
                      const SizedBox(height: 10),
                      _ProductCard(
                        icon: Icons.credit_card_rounded,
                        iconColor: Colors.blueAccent,
                        title: 'Meus Cartões',
                        subtitle: 'Limite disponível: R\$ 3.000',
                        trailing: null,
                        onTap: () {},
                      ),
                    ],
                  ),
                ),

                // ── Section: Novidades ──────────────────────────────
                const Padding(
                  padding: EdgeInsets.fromLTRB(20, 28, 20, 12),
                  child: Text(
                    'Novidades',
                    style: TextStyle(color: Colors.white, fontSize: 16, fontWeight: FontWeight.bold),
                  ),
                ),

                Padding(
                  padding: const EdgeInsets.fromLTRB(16, 0, 16, 32),
                  child: Container(
                    padding: const EdgeInsets.all(16),
                    decoration: BoxDecoration(
                      gradient: const LinearGradient(
                        colors: [Color(0xFFBF360C), Color(0xFFFF6E40)],
                        begin: Alignment.topLeft,
                        end: Alignment.bottomRight,
                      ),
                      borderRadius: BorderRadius.circular(16),
                    ),
                    child: Row(
                      children: [
                        Container(
                          padding: const EdgeInsets.all(10),
                          decoration: BoxDecoration(
                            color: Colors.white.withOpacity(0.2),
                            borderRadius: BorderRadius.circular(12),
                          ),
                          child: const Icon(Icons.star_rounded, color: Colors.white, size: 24),
                        ),
                        const SizedBox(width: 12),
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: const [
                              Text(
                                'MXFR11 em alta',
                                style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold, fontSize: 14),
                              ),
                              SizedBox(height: 2),
                              Text(
                                '+2,23% hoje · Fundo imobiliário',
                                style: TextStyle(color: Colors.white70, fontSize: 12),
                              ),
                            ],
                          ),
                        ),
                        const Icon(Icons.arrow_forward_ios_rounded, color: Colors.white70, size: 16),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
      bottomNavigationBar: BottomNavigationBar(
        backgroundColor: const Color(0xFF1E1E1E),
        currentIndex: _selectedIndex,
        onTap: _onItemTapped,
        selectedItemColor: const Color(0xFFFF6E40),
        unselectedItemColor: Colors.white38,
        items: const [
          BottomNavigationBarItem(icon: Icon(Icons.home_rounded), label: 'Início'),
          BottomNavigationBarItem(icon: Icon(Icons.auto_graph_rounded), label: 'Investimentos'),
          BottomNavigationBarItem(icon: Icon(Icons.account_circle_outlined), label: 'Perfil'),
        ],
      ),
    );
  }
}

// ── Wrapper to embed TelaInvestimentos stand-alone ────────────────────────────
class _InvestimentosWrapper extends StatelessWidget {
  const _InvestimentosWrapper();

  @override
  Widget build(BuildContext context) {
    return const TelaInvestimentos();
  }
}

// ── Small helpers ─────────────────────────────────────────────────────────────

class _AppBarIconButton extends StatelessWidget {
  const _AppBarIconButton({required this.icon});
  final IconData icon;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 38,
      height: 38,
      decoration: BoxDecoration(
        color: Colors.white.withOpacity(0.2),
        shape: BoxShape.circle,
      ),
      child: Icon(icon, color: Colors.white, size: 20),
    );
  }
}

class _MiniStat extends StatelessWidget {
  const _MiniStat({required this.label, required this.value, required this.color});
  final String label;
  final String value;
  final Color color;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(label, style: const TextStyle(color: Colors.white38, fontSize: 11)),
        const SizedBox(height: 2),
        Text(value, style: TextStyle(color: color, fontSize: 13, fontWeight: FontWeight.w600)),
      ],
    );
  }
}

class _QuickAction extends StatelessWidget {
  const _QuickAction({required this.icon, required this.label});
  final IconData icon;
  final String label;

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Container(
          width: 52,
          height: 52,
          decoration: BoxDecoration(
            color: const Color(0xFFFF6E40).withOpacity(0.15),
            shape: BoxShape.circle,
            border: Border.all(color: const Color(0xFFFF6E40).withOpacity(0.3)),
          ),
          child: Icon(icon, color: const Color(0xFFFF6E40), size: 22),
        ),
        const SizedBox(height: 6),
        Text(label, style: const TextStyle(color: Colors.white70, fontSize: 11)),
      ],
    );
  }
}

class _ProductCard extends StatelessWidget {
  const _ProductCard({
    required this.icon,
    required this.iconColor,
    required this.title,
    required this.subtitle,
    required this.trailing,
    required this.onTap,
  });
  final IconData icon;
  final Color iconColor;
  final String title;
  final String subtitle;
  final String? trailing;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return Material(
      color: const Color(0xFF1E1E1E),
      borderRadius: BorderRadius.circular(16),
      child: InkWell(
        borderRadius: BorderRadius.circular(16),
        onTap: onTap,
        child: Container(
          padding: const EdgeInsets.all(16),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(16),
            border: Border.all(color: Colors.white12),
          ),
          child: Row(
            children: [
              Container(
                width: 44,
                height: 44,
                decoration: BoxDecoration(
                  color: iconColor.withOpacity(0.15),
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Icon(icon, color: iconColor, size: 22),
              ),
              const SizedBox(width: 14),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(title, style: const TextStyle(color: Colors.white, fontWeight: FontWeight.w600, fontSize: 14)),
                    const SizedBox(height: 2),
                    Text(subtitle, style: const TextStyle(color: Colors.white38, fontSize: 12)),
                  ],
                ),
              ),
              if (trailing != null) ...[
                Text(
                  trailing!,
                  style: const TextStyle(color: Color(0xFFFF6E40), fontWeight: FontWeight.bold, fontSize: 14),
                ),
                const SizedBox(width: 6),
              ],
              const Icon(Icons.arrow_forward_ios_rounded, color: Colors.white24, size: 14),
            ],
          ),
        ),
      ),
    );
  }
}
