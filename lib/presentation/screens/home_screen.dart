import 'package:flutter/cupertino.dart';
import 'package:architecto/services/auth/auth_service.dart';

class HomeScreen extends StatefulWidget {
  
  const HomeScreen({Key? key}) : super(key: key);

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  final AuthService _authService = AuthService();

  @override
  void initState() {
    super.initState();
    _updateLastActive();
  }

  Future<void> _updateLastActive() async {
    await _authService.updateLastActive();
  }

  @override
  Widget build(BuildContext context) {
    return CupertinoPageScaffold(
      navigationBar: const CupertinoNavigationBar(
        middle: Text('Home'),
      ),
      child: const SafeArea(
        child: Center(
          child: Text(
            'Home Screen',
            style: TextStyle(fontSize: 24),
          ),
        ),
      ),
    );
  }
}
