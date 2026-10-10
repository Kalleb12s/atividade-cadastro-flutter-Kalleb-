import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

void main() {
  runApp(const CadastroApp());
}

class CadastroApp extends StatelessWidget {
  const CadastroApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Nexo Finance',
      theme: ThemeData(
        useMaterial3: true,
        colorScheme: ColorScheme.fromSeed(seedColor: const Color(0xFF1976D2)),
        scaffoldBackgroundColor: const Color(0xFFF4F7FC),
      ),
      home: const CadastroPage(),
    );
  }
}

class CadastroPage extends StatefulWidget {
  const CadastroPage({super.key});

  @override
  State<CadastroPage> createState() => _CadastroPageState();
}

class _CadastroPageState extends State<CadastroPage> {
  final _formKey = GlobalKey<FormState>();

  final _nomeController = TextEditingController();
  final _emailController = TextEditingController();
  final _cpfController = TextEditingController();
  final _telefoneController = TextEditingController();
  final _senhaController = TextEditingController();
  final _confirmacaoController = TextEditingController();

  bool _mostrarSenha = false;
  bool _mostrarConfirmacao = false;

  @override
  void dispose() {
    _nomeController.dispose();
    _emailController.dispose();
    _cpfController.dispose();
    _telefoneController.dispose();
    _senhaController.dispose();
    _confirmacaoController.dispose();
    super.dispose();
  }

  void _cadastrar() {
    final valido = _formKey.currentState?.validate() ?? false;

    if (!valido) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Verifique os campos destacados e tente novamente.'),
          backgroundColor: Colors.red,
          behavior: SnackBarBehavior.floating,
        ),
      );
      return;
    }

    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Text('Cadastro realizado com sucesso!'),
        backgroundColor: Colors.green,
        behavior: SnackBarBehavior.floating,
      ),
    );
  }

  InputDecoration _decoracao(String rotulo, IconData icone) {
    return InputDecoration(
      labelText: rotulo,
      prefixIcon: Icon(icone),
      filled: true,
      fillColor: Colors.white,
      border: OutlineInputBorder(borderRadius: BorderRadius.circular(14)),
      enabledBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(14),
        borderSide: const BorderSide(color: Color(0xFFD8E0EB)),
      ),
      focusedBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(14),
        borderSide: const BorderSide(color: Color(0xFF1976D2), width: 2),
      ),
    );
  }

  Widget _espaco() => const SizedBox(height: 16);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'Criar conta',
          style: TextStyle(fontWeight: FontWeight.bold),
        ),
        centerTitle: true,
        backgroundColor: Colors.white,
      ),
      body: SafeArea(
        child: Form(
          key: _formKey,
          child: SingleChildScrollView(
            padding: const EdgeInsets.all(24),
            child: Center(
              child: ConstrainedBox(
                constraints: const BoxConstraints(maxWidth: 480),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    const Icon(
                      Icons.account_balance_wallet_rounded,
                      size: 64,
                      color: Color(0xFF1976D2),
                    ),
                    const SizedBox(height: 12),
                    const Text(
                      'Seu dinheiro, sob controle!',
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        fontSize: 28,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(height: 8),
                    const Text(
                      'Organize suas finanças de um jeito simples e inteligente.',
                      textAlign: TextAlign.center,
                      style: TextStyle(color: Colors.blueGrey),
                    ),
                    const SizedBox(height: 28),

                    // Nome completo
                    TextFormField(
                      controller: _nomeController,
                      keyboardType: TextInputType.name,
                      textCapitalization: TextCapitalization.words,
                      decoration: _decoracao(
                        'Nome completo',
                        Icons.person_outline,
                      ),
                      validator: (value) {
                        if (value == null || value.trim().isEmpty) {
                          return 'Digite seu nome completo';
                        }
                        return null;
                      },
                    ),
                    _espaco(),

                    // E-mail
                    TextFormField(
                      controller: _emailController,
                      keyboardType: TextInputType.emailAddress,
                      decoration: _decoracao('E-mail', Icons.email_outlined),
                      validator: (value) {
                        if (value == null || value.trim().isEmpty) {
                          return 'Digite seu e-mail';
                        }

                        final emailRegex = RegExp(
                          r'^[\w.+-]+@([\w-]+\.)+[\w-]{2,}$',
                        );

                        if (!emailRegex.hasMatch(value.trim())) {
                          return 'Digite um e-mail válido';
                        }
                        return null;
                      },
                    ),
                    _espaco(),

                    // CPF
                    TextFormField(
                      controller: _cpfController,
                      keyboardType: TextInputType.number,
                      inputFormatters: [
                        FilteringTextInputFormatter.digitsOnly,
                        LengthLimitingTextInputFormatter(11),
                      ],
                      decoration: _decoracao(
                        'CPF (somente números)',
                        Icons.badge_outlined,
                      ),
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return 'Digite seu CPF';
                        }
                        if (value.length != 11) {
                          return 'O CPF deve ter 11 números';
                        }
                        return null;
                      },
                    ),
                    _espaco(),

                    // Telefone
                    TextFormField(
                      controller: _telefoneController,
                      keyboardType: TextInputType.phone,
                      inputFormatters: [
                        FilteringTextInputFormatter.digitsOnly,
                        LengthLimitingTextInputFormatter(11),
                      ],
                      decoration: _decoracao(
                        'Telefone (somente números)',
                        Icons.phone_outlined,
                      ),
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return 'Digite seu telefone';
                        }
                        if (value.length < 10 || value.length > 11) {
                          return 'Informe um telefone com 10 ou 11 números';
                        }
                        return null;
                      },
                    ),
                    _espaco(),

                    // Senha
                    TextFormField(
                      controller: _senhaController,
                      obscureText: !_mostrarSenha,
                      decoration: _decoracao('Senha', Icons.lock_outline)
                          .copyWith(
                            suffixIcon: IconButton(
                              tooltip: _mostrarSenha
                                  ? 'Ocultar senha'
                                  : 'Mostrar senha',
                              icon: Icon(
                                _mostrarSenha
                                    ? Icons.visibility_off
                                    : Icons.visibility,
                              ),
                              onPressed: () {
                                setState(() {
                                  _mostrarSenha = !_mostrarSenha;
                                });
                              },
                            ),
                          ),
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return 'Digite sua senha';
                        }
                        if (value.length < 6) {
                          return 'A senha deve ter pelo menos 6 caracteres';
                        }
                        return null;
                      },
                    ),
                    _espaco(),

                    // Confirmação de senha (desafio)
                    TextFormField(
                      controller: _confirmacaoController,
                      obscureText: !_mostrarConfirmacao,
                      decoration:
                          _decoracao(
                            'Confirmar senha',
                            Icons.lock_reset,
                          ).copyWith(
                            suffixIcon: IconButton(
                              tooltip: _mostrarConfirmacao
                                  ? 'Ocultar senha'
                                  : 'Mostrar senha',
                              icon: Icon(
                                _mostrarConfirmacao
                                    ? Icons.visibility_off
                                    : Icons.visibility,
                              ),
                              onPressed: () {
                                setState(() {
                                  _mostrarConfirmacao = !_mostrarConfirmacao;
                                });
                              },
                            ),
                          ),
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return 'Confirme sua senha';
                        }
                        if (value != _senhaController.text) {
                          return 'As senhas não são iguais';
                        }
                        return null;
                      },
                    ),
                    const SizedBox(height: 28),

                    // Botão de cadastro
                    SizedBox(
                      height: 54,
                      child: ElevatedButton(
                        onPressed: _cadastrar,
                        style: ElevatedButton.styleFrom(
                          backgroundColor: const Color(0xFF1976D2),
                          foregroundColor: Colors.white,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(14),
                          ),
                        ),
                        child: const Text(
                          'CADASTRAR',
                          style: TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                    ),
                    const SizedBox(height: 20),
                    const Text(
                      'Seus dados serão utilizados para o cadastro.',
                      textAlign: TextAlign.center,
                      style: TextStyle(color: Colors.blueGrey, fontSize: 12),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
