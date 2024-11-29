import 'dart:math';
import 'package:flutter/material.dart';
import 'caixinhas.dart'; // Certifique-se de que este arquivo está correto e existe

class AppTest extends StatefulWidget {
  @override
  _AppTestState createState() => _AppTestState();
}

class _AppTestState extends State<AppTest> {
  int _selectedIndex = 0; // Índice do item selecionado na BottomNavigationBar

  // Função chamada ao clicar nos itens da BottomNavigationBar
  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });

    // Verifica qual item foi tocado para navegar para a tela apropriada
    if (index == 0) {
      // Quando o índice 0 (Início) for selecionado, nada é feito aqui, pois já estamos na tela inicial
    } else if (index == 1) {
      // Quando o índice 1 (Investimentos) for tocado, navega para a página de Investimentos
      Navigator.push(
        context,
        MaterialPageRoute(builder: (context) => MyApp()), // Navegar para a tela 'Caixinhas'
      );
    } else if (index == 2) {
      // Quando o índice 2 (Perfil) for tocado, você pode adicionar a navegação ou funcionalidade que desejar
    }
  }

  @override
  Widget build(BuildContext context) {
    var random = Random();
    int numeroAleatorio = random.nextInt(4001) + 1000;

    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: Scaffold(
        backgroundColor: Colors.black,  // Cor de fundo da tela
        appBar: AppBar(
          toolbarHeight: 135,
          title: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Icon(Icons.account_circle_outlined, size: 50),
                  Row(
                    children: [
                      Icon(Icons.help_outline_outlined, size: 30),
                      SizedBox(width: 10),
                      Icon(Icons.remove_red_eye_outlined, size: 30),
                      SizedBox(width: 10),
                      Icon(Icons.supervisor_account, size: 30),
                    ],
                  ),
                ],
              ),
              SizedBox(height: 20),
              Text(
                "Olá, Pietro",
                style: TextStyle(color: Colors.white),
              ),
            ],
          ),
          backgroundColor: Color.fromRGBO(255, 110, 64, 100),
        ),
        body: Stack(
          children: [
            // DraggableScrollableSheet para rolagem inicial visível
            DraggableScrollableSheet(
              initialChildSize: 0.9,  // Começa mais abaixo (com a rolagem visível)
              minChildSize: 0.3,  // Mínimo tamanho da tela
              maxChildSize: 1.0,  // Tamanho máximo ao arrastar
              builder: (BuildContext context, ScrollController scrollController) {
                return SingleChildScrollView(
                  controller: scrollController,
                  child: Padding(
                    padding: const EdgeInsets.fromLTRB(20, 40, 20, 40),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text(
                              "Conta",
                              style: TextStyle(fontSize: 20, color: Colors.white),
                            ),
                            Icon(Icons.arrow_forward_ios_rounded, color: Colors.white),
                          ],
                        ),
                        Text(
                          "R\$ 3.809,23",
                          style: TextStyle(fontSize: 20, color: Colors.white),
                        ),
                        SizedBox(height: 20),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.start,
                          children: [
                            Column(
                              children: [
                                CircleAvatar(
                                  child: Icon(Icons.pix, color: Colors.white),
                                  maxRadius: 30,
                                  backgroundColor: Colors.white10,
                                ),
                                SizedBox(height: 5),
                                Text(
                                  "Área Pix",
                                  style: TextStyle(color: Colors.white),
                                ),
                              ],
                            ),
                            SizedBox(width: 20),
                            Column(
                              children: [
                                CircleAvatar(
                                  child: Icon(Icons.bar_chart, color: Colors.white),
                                  maxRadius: 30,
                                  backgroundColor: Colors.white10,
                                ),
                                SizedBox(height: 5),
                                Text(
                                  "Pagar",
                                  style: TextStyle(color: Colors.white),
                                ),
                              ],
                            ),
                            SizedBox(width: 20),
                            Column(
                              children: [
                                CircleAvatar(
                                  child: Icon(Icons.phone_android_outlined, color: Colors.white),
                                  maxRadius: 30,
                                  backgroundColor: Colors.white10,
                                ),
                                SizedBox(height: 5),
                                Text(
                                  "Recarga",
                                  style: TextStyle(color: Colors.white),
                                ),
                              ],
                            ),
                            SizedBox(width: 20),
                            Column(
                              children: [
                                CircleAvatar(
                                  child: Icon(Icons.add_chart, color: Colors.white),
                                  maxRadius: 30,
                                  backgroundColor: Colors.white10,
                                ),
                                SizedBox(height: 5),
                                Text(
                                  "Depositar",
                                  style: TextStyle(color: Colors.white),
                                ),
                              ],
                            ),
                          ],
                        ),
                        Padding(
                          padding: const EdgeInsets.fromLTRB(5, 60, 5, 5),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.stretch,
                            children: [
                              Container(
                                height: 50,
                                child: FloatingActionButton(
                                  onPressed: () {
                                    Navigator.push(
                                      context,
                                      MaterialPageRoute(builder: (context) => MyApp()),
                                    );
                                  },
                                  backgroundColor: Colors.white24,
                                  shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(10),
                                  ),
                                  child: Row(
                                    children: [
                                      SizedBox(width: 8),
                                      Icon(Icons.monetization_on),
                                      SizedBox(width: 8),
                                      Text("Investimentos"),
                                      SizedBox(width: 120),
                                      Text("R\$ 4.504,13")
                                    ],
                                  ),
                                ),
                              ),
                              SizedBox(height: 20),
                              Container(
                                height: 50,
                                child: FloatingActionButton(
                                  onPressed: () {},
                                  backgroundColor: Colors.white24,
                                  shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(10),
                                  ),
                                  child: Row(
                                    children: [
                                      SizedBox(width: 8),
                                      Icon(Icons.credit_card),
                                      SizedBox(width: 9),
                                      Text("Meus Cartões")
                                    ],
                                  ),
                                ),
                              ),
                              SizedBox(height: 10),
                              Container(
                                height: 1,
                                color: Colors.white12,
                              ),
                              SizedBox(height: 10),
                              Text(
                                "Novidades",
                                style: TextStyle(fontSize: 20, color: Colors.white),
                              ),
                              SizedBox(height: 10),
                              Container(
                                width: double.infinity,
                                height: 50,
                                child: FloatingActionButton(
                                  onPressed: () {},
                                  backgroundColor: Colors.white24,
                                  shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(10),
                                  ),
                                  child: Row(
                                    children: [
                                      SizedBox(width: 8),
                                      Icon(Icons.shopping_cart),
                                      SizedBox(width: 8),
                                      Text(
                                        "Favoritos",
                                        style: TextStyle(fontFamily: "Arial"),
                                      ),
                                    ],
                                  ),
                                ),
                              ),


                          SizedBox(height: 20,),
                          
                          Container(
                            margin: EdgeInsets.only(bottom: 10),
                            padding: EdgeInsets.all(16),
                            decoration: BoxDecoration(
                              color: Colors.grey[800],
                              borderRadius: BorderRadius.circular(10),
                            ),
                            child: Row(
                              children: [
                                Text("Favoritas", style: TextStyle(color: Colors.white),)
                              ],
                            ),
                            ),
                            ],
                          ),
                        ),
                        SizedBox(height: 10),
                        Container(
                          height: 1,
                          color: Colors.white12,
                        ),
                        SizedBox(height: 10),
                        SizedBox(height: 20),
                      ],
                    ),
                  ),
                );
              },
            ),
          ],
        ),
        bottomNavigationBar: BottomNavigationBar(
          backgroundColor: Colors.black,  // Cor de fundo da barra de navegação
          currentIndex: _selectedIndex, // Índice do ícone selecionado
          onTap: _onItemTapped, // Função chamada ao tocar nos ícones
          selectedItemColor: Color.fromRGBO(255, 110, 64, 1.0), // Cor do ícone selecionado
          unselectedItemColor: Color.fromRGBO(255, 110, 64, 1.0), // Cor dos ícones não selecionados
          items: const <BottomNavigationBarItem>[
            BottomNavigationBarItem(
              icon: Icon(Icons.home),
              label: 'Início',
            ),
            BottomNavigationBarItem(
              icon: Icon(Icons.auto_graph),
              label: 'Investimentos',
            ),
            BottomNavigationBarItem(
              icon: Icon(Icons.account_circle),
              label: 'Perfil',
            ),
          ],
        ),
      ),
    );
  }
}

void main() {
  runApp(AppTest());
}
