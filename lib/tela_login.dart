import 'package:flutter/material.dart';
import 'tela_principal.dart';
import 'package:http/http.dart' as http;

class TelaLogin extends StatefulWidget {
  const TelaLogin({super.key});

  @override
  State<TelaLogin> createState() => _TelaLoginState();
}

class _TelaLoginState extends State<TelaLogin> {
  final formKey = GlobalKey<FormState>();
  bool isLoading = false;
  bool _obscurePassword = true;
  final usuario = TextEditingController(text: 'emilys');
  final senha = TextEditingController(text: 'emilyspass');

  Future<void> _handleLogin() async {
    if (!formKey.currentState!.validate()) return;
    setState(() => isLoading = true);
    try {
      final url = Uri.parse('https://dummyjson.com/auth/login');
      final response = await http.post(
        url,
        body: {
          'username': usuario.text,
          'password': senha.text,
        },
      );
      if (!mounted) return;
      if (response.statusCode == 200) {
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(builder: (context) => const AppTest()),
        );
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: const Text('Usuário ou senha incorretos'),
            backgroundColor: Colors.redAccent,
            behavior: SnackBarBehavior.floating,
            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
            margin: const EdgeInsets.all(16),
          ),
        );
      }
    } finally {
      if (mounted) setState(() => isLoading = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: [
              Color(0xFFBF360C),
              Color(0xFFFF6E40),
              Color(0xFFFFAB76),
            ],
          ),
        ),
        child: SafeArea(
          child: Center(
            child: SingleChildScrollView(
              padding: const EdgeInsets.symmetric(horizontal: 24.0),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  // Logo
                  Container(
                    width: 84,
                    height: 84,
                    decoration: BoxDecoration(
                      color: Colors.white.withOpacity(0.2),
                      shape: BoxShape.circle,
                      border: Border.all(color: Colors.white38, width: 2),
                    ),
                    child: const Icon(
                      Icons.wb_sunny_rounded,
                      size: 44,
                      color: Colors.white,
                    ),
                  ),
                  const SizedBox(height: 16),
                  const Text(
                    'SOLIS',
                    style: TextStyle(
                      fontSize: 38,
                      fontWeight: FontWeight.w900,
                      color: Colors.white,
                      letterSpacing: 6,
                    ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    'Sua vida financeira mais simples',
                    style: TextStyle(
                      fontSize: 14,
                      color: Colors.white.withOpacity(0.85),
                      letterSpacing: 0.3,
                    ),
                  ),
                  const SizedBox(height: 40),
                  // Form card
                  Container(
                    padding: const EdgeInsets.all(24),
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(20),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.black.withOpacity(0.15),
                          blurRadius: 24,
                          offset: const Offset(0, 8),
                        ),
                      ],
                    ),
                    child: Form(
                      key: formKey,
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.stretch,
                        children: [
                          const Text(
                            'Entrar',
                            style: TextStyle(
                              fontSize: 22,
                              fontWeight: FontWeight.bold,
                              color: Color(0xFF212121),
                            ),
                          ),
                          const SizedBox(height: 4),
                          const Text(
                            'Acesse sua conta para continuar',
                            style: TextStyle(
                              fontSize: 13,
                              color: Colors.black54,
                            ),
                          ),
                          const SizedBox(height: 24),
                          TextFormField(
                            controller: usuario,
                            style: const TextStyle(color: Color(0xFF212121)),
                            decoration: InputDecoration(
                              labelText: 'Usuário',
                              labelStyle: const TextStyle(color: Colors.black54),
                              prefixIcon: const Icon(Icons.person_outline, color: Color(0xFFFF6E40)),
                              filled: true,
                              fillColor: const Color(0xFFF5F5F5),
                              border: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(12),
                                borderSide: BorderSide.none,
                              ),
                              enabledBorder: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(12),
                                borderSide: const BorderSide(color: Color(0xFFE0E0E0)),
                              ),
                              focusedBorder: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(12),
                                borderSide: const BorderSide(color: Color(0xFFFF6E40), width: 2),
                              ),
                            ),
                            validator: (valor) {
                              if (valor == null || valor.isEmpty) {
                                return 'Insira seu usuário, por favor.';
                              }
                              return null;
                            },
                          ),
                          const SizedBox(height: 16),
                          TextFormField(
                            controller: senha,
                            obscureText: _obscurePassword,
                            style: const TextStyle(color: Color(0xFF212121)),
                            decoration: InputDecoration(
                              labelText: 'Senha',
                              labelStyle: const TextStyle(color: Colors.black54),
                              prefixIcon: const Icon(Icons.lock_outline, color: Color(0xFFFF6E40)),
                              suffixIcon: IconButton(
                                icon: Icon(
                                  _obscurePassword ? Icons.visibility_off_outlined : Icons.visibility_outlined,
                                  color: Colors.black45,
                                  size: 20,
                                ),
                                onPressed: () => setState(() => _obscurePassword = !_obscurePassword),
                              ),
                              filled: true,
                              fillColor: const Color(0xFFF5F5F5),
                              border: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(12),
                                borderSide: BorderSide.none,
                              ),
                              enabledBorder: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(12),
                                borderSide: const BorderSide(color: Color(0xFFE0E0E0)),
                              ),
                              focusedBorder: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(12),
                                borderSide: const BorderSide(color: Color(0xFFFF6E40), width: 2),
                              ),
                            ),
                            validator: (valor) {
                              if (valor == null || valor.isEmpty) {
                                return 'Insira a senha, por favor.';
                              }
                              return null;
                            },
                          ),
                          const SizedBox(height: 28),
                          SizedBox(
                            height: 52,
                            child: ElevatedButton(
                              onPressed: isLoading ? null : _handleLogin,
                              style: ElevatedButton.styleFrom(
                                backgroundColor: const Color(0xFFFF6E40),
                                foregroundColor: Colors.white,
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(12),
                                ),
                                elevation: 0,
                              ),
                              child: isLoading
                                  ? const SizedBox(
                                      width: 24,
                                      height: 24,
                                      child: CircularProgressIndicator(
                                        color: Colors.white,
                                        strokeWidth: 2.5,
                                      ),
                                    )
                                  : const Text(
                                      'Entrar',
                                      style: TextStyle(
                                        fontSize: 16,
                                        fontWeight: FontWeight.bold,
                                        letterSpacing: 0.5,
                                      ),
                                    ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                  const SizedBox(height: 32),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
