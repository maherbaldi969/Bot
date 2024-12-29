import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:animator/animator.dart';
import 'package:just_audio/just_audio.dart';
import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart' as path;
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:crypto/crypto.dart';
import 'package:video_player/video_player.dart';
import 'chatbot.dart';
// Utilisez un alias pour éviter le conflit



void main(){
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: LoginPage(),
    );
  }
}

class LoginPage extends StatefulWidget {
  @override
  _LoginPageState createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();

  // Variables pour l'état de l'image
  bool isSmiling = false;
  bool isCoveringEyes = false;

  Future<void> _loginUser(BuildContext context) async {
    final email = _emailController.text.trim();
    final password = _passwordController.text.trim();

    // Ajout du code pour afficher les valeurs de débogage
    print("Email saisi : $email");         // Affiche l'email saisi
    print("Password saisi : $password");   // Affiche le mot de passe saisi

    if (email.isNotEmpty && password.isNotEmpty) {
      final dbHelper = DatabaseHelper();
      final user = await dbHelper.getUserByEmail(email);

      // Vérifications et messages d'erreur spécifiques
      if (user == null) {
        print("Aucun utilisateur trouvé avec cet email.");
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('No user found with this email')),
        );
      } else if (user.password != password) {
        print("Mot de passe incorrect.");
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Invalid email or password')),
        );
      } else {
        // Redirection en cas de succès
        print("Utilisateur récupéré : ${user.email}, Mot de passe : ${user.password}");
        Navigator.push(
          context,
          MaterialPageRoute(builder: (context) => AnimatedLogo()),
        );
      }
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Please fill in both fields')),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          // Formes circulaires
          Positioned(
            top: -50,
            left: -50,
            child: CircleAvatar(
              radius: 100,
              backgroundColor: Colors.orange,
            ),
          ),
          Positioned(
            top: 0,
            right: -30,
            child: CircleAvatar(
              radius: 80,
              backgroundColor: Colors.redAccent,
            ),
          ),
          Positioned(
            top: 80,
            left: 60,
            child: CircleAvatar(
              radius: 50,
              backgroundColor: Colors.teal,
            ),
          ),
          Positioned(
            top: 100,
            right: 50,
            child: CircleAvatar(
              radius: 30,
              backgroundColor: Colors.red,
            ),
          ),
          Positioned(
            top: 150,
            left: -10,
            child: CircleAvatar(
              radius: 30,
              backgroundColor: Colors.orange,
            ),
          ),
          // Contenu principal
          Align(
            alignment: Alignment.center,
            child: SingleChildScrollView(
              child: Padding(
                padding: EdgeInsets.symmetric(horizontal: 30, vertical: 50),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    // Texte de bienvenue
                    Text(
                      'Welcome\nBack',
                      style: GoogleFonts.pacifico(
                        color: Colors.blue.shade900,
                        fontSize: 34,
                        fontWeight: FontWeight.bold,
                        height: 1.2,
                      ),
                      textAlign: TextAlign.center,
                    ),
                    SizedBox(height: 80),
                    // Image animée
                    AnimatedSwitcher(
                      duration: Duration(milliseconds: 300),
                      child: isSmiling
                          ? Image.asset(
                        'images/cartoonsmiling.jpeg',
                        key: ValueKey('smiling'),
                        height: 200,
                      )
                          : isCoveringEyes
                          ? Image.asset(
                        'images/coveringeyes1.jpeg',
                        key: ValueKey('covering_eyes'),
                        height: 200,
                      )
                          : Image.asset(
                        'images/neutral1.jpeg',
                        key: ValueKey('neutral'),
                        height: 200,
                      ),
                    ),
                    SizedBox(height: 30),
// Champ email
                    // Champ email
                    TextField(
                      controller: _emailController,
                      decoration: InputDecoration(
                        prefixIcon: Icon(
                          Icons.email,
                          color: Colors.white,
                          size: 24,
                        ),
                        hintText: 'Your Email',
                        hintStyle: TextStyle(color: Colors.white70),
                        filled: true,
                        fillColor: Colors.blue.shade700,
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(30),
                          borderSide: BorderSide.none,
                        ),
                      ),
                      onTap: () {
                        setState(() {
                          isSmiling = true;
                          isCoveringEyes = false;
                        });
                      },
                    ),
                    SizedBox(height: 20),
                    // Champ mot de passe
                    TextField(
                      controller: _passwordController,
                      obscureText: true,
                      decoration: InputDecoration(
                        prefixIcon: Icon(
                          Icons.lock,
                          color: Colors.white,
                          size: 24,
                        ),
                        hintText: 'Password',
                        hintStyle: TextStyle(color: Colors.white70),
                        filled: true,
                        fillColor: Colors.blue.shade700,
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(30),
                          borderSide: BorderSide.none,
                        ),
                      ),
                      onTap: () {
                        setState(() {
                          isSmiling = false;
                          isCoveringEyes = true;
                        });
                      },
                    ),
                    SizedBox(height: 10),
                    Align(
                      alignment: Alignment.centerRight,
                      child: TextButton(
                        onPressed: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(builder: (context) => ChangePasswordPage()),
                          );
                        },
                        child: Text(
                          'Change password?',
                          style: TextStyle(color: Colors.orange), // Couleur du texte
                        ),
                      ),
                    ),
                    SizedBox(height: 20),
                    // Bouton "Login"
                    ElevatedButton(
                      onPressed: () => _loginUser(context),
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.orange,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(30),
                        ),
                        padding: EdgeInsets.symmetric(
                            horizontal: 80, vertical: 15),
                      ),
                      child: Text(
                        'Login',
                        style: TextStyle(fontSize: 18, color: Colors.white),
                      ),
                    ),
                    SizedBox(height: 30),
                    // Lien pour créer un compte
                    Positioned(
                      top: 50, // Position verticale
                      left: 0,
                      right: 0,
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          // Demi-cercle gauche
                          Container(
                            width: 80,
                            height: 40,
                            decoration: BoxDecoration(
                              color: Colors.orange, // Couleur du demi-cercle
                              borderRadius: BorderRadius.only(
                                topRight: Radius.circular(40),
                                bottomRight: Radius.circular(40),
                              ),
                            ),
                          ),
                          SizedBox(width: 10),
                          // Texte "Signup"
                          GestureDetector(
                            onTap: () {
                              Navigator.push(
                                context,
                                MaterialPageRoute(builder: (context) => SignupPage()),
                              );
                            },
                            child: Text(
                              'Signup',
                              style: TextStyle(
                                color: Colors.orange, // Couleur du texte
                                fontWeight: FontWeight.bold,
                                fontSize: 18,
                              ),
                            ),
                          ),
                          SizedBox(width: 10),
                          // Demi-cercle droit
                          Container(
                            width: 80,
                            height: 40,
                            decoration: BoxDecoration(
                              color: Colors.orange, // Couleur du demi-cercle
                              borderRadius: BorderRadius.only(
                                topLeft: Radius.circular(40),
                                bottomLeft: Radius.circular(40),
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}


class SignupPage extends StatelessWidget {
  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();

  Future<void> _signupUser(BuildContext context) async {
    final name = _nameController.text;
    final email = _emailController.text;
    final password = _passwordController.text;
    // Validation du formulaire
    if (name.isEmpty || email.isEmpty || password.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Veuillez remplir tous les champs.'),
          backgroundColor: Colors.red,
        ),
      );
      return;
    }
    // Vérification du format de l'email
    if (!email.contains('@') || !email.contains('.')) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Veuillez entrer un e-mail valide.'),
          backgroundColor: Colors.red,
        ),
      );
      return;
    }
    // Vérification de la longueur du mot de passe
    if (password.length < 8) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Le mot de passe doit contenir au moins 8 caractères.'),
          backgroundColor: Colors.red,
        ),
      );
      return;
    }

    if (name.isNotEmpty && email.isNotEmpty && password.isNotEmpty) {
      final user = User(name: name, email: email, password: password);
      try {
        await DatabaseHelper().insertUser(user);
        // Afficher le message de succès
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Inscription réussie !'),
            backgroundColor: Colors.green,
          ),
        );
        // Rediriger vers la page de connexion après succès
        Navigator.pop(context);
      } catch (e) {
        // Afficher un message d'erreur en cas de problème d'insertion
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Erreur lors de l\'inscription. Veuillez réessayer.'),
            backgroundColor: Colors.red,
          ),
        );
      }
    } else {
      // Afficher un message d'erreur si des champs sont vides
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Veuillez remplir tous les champs.'),
          backgroundColor: Colors.red,
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          // Arrière-plan avec dégradé et demi-cercles
          Container(
            width: double.infinity,
            padding: EdgeInsets.symmetric(horizontal: 30, vertical: 50),
            decoration: BoxDecoration(
              gradient: LinearGradient(
                colors: [Colors.blue.shade900, Colors.blue.shade800],
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
              ),
            ),
          ),
          // Demi-cercle jaune en bas à gauche
          Positioned(
            bottom: -50,
            left: -50,
            child: Container(
              width: 150,
              height: 150,
              decoration: BoxDecoration(
                color: Colors.yellow,
                shape: BoxShape.circle,
              ),
            ),
          ),
          // Demi-cercle orange en bas à droite
          Positioned(
            bottom: -50,
            right: -50,
            child: Container(
              width: 150,
              height: 150,
              decoration: BoxDecoration(
                color: Colors.orange,
                shape: BoxShape.circle,
              ),
            ),
          ),
          // Contenu principal de la page
          SingleChildScrollView(
            child: Padding(
              padding: EdgeInsets.symmetric(horizontal: 30, vertical: 50),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    'Hello...!',
                    style: GoogleFonts.pacifico(
                      color: Colors.white,
                      fontSize: 34,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  SizedBox(height: 50),
                  TextField(
                    controller: _nameController,  // Lier le contrôleur
                    decoration: InputDecoration(
                      prefixIcon: Icon(Icons.person, color: Colors.white),
                      hintText: 'Your Name',
                      hintStyle: TextStyle(color: Colors.white70),
                      filled: true,
                      fillColor: Colors.blue.shade700,
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(30),
                        borderSide: BorderSide.none,
                      ),
                    ),
                  ),
                  SizedBox(height: 20),
                  TextField(
                    controller: _emailController,  // Lier le contrôleur
                    decoration: InputDecoration(
                      prefixIcon: Icon(Icons.email, color: Colors.white),
                      hintText: 'Your E-mail',
                      hintStyle: TextStyle(color: Colors.white70),
                      filled: true,
                      fillColor: Colors.blue.shade700,
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(30),
                        borderSide: BorderSide.none,
                      ),
                    ),
                  ),
                  SizedBox(height: 20),
                  TextField(
                    controller: _passwordController,  // Lier le contrôleur
                    obscureText: true,
                    decoration: InputDecoration(
                      prefixIcon: Icon(Icons.lock, color: Colors.white),
                      hintText: 'Password',
                      hintStyle: TextStyle(color: Colors.white70),
                      filled: true,
                      fillColor: Colors.blue.shade700,
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(30),
                        borderSide: BorderSide.none,
                      ),
                    ),
                  ),
                  SizedBox(height: 30),
                  ElevatedButton(
                    onPressed: () => _signupUser(context),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.orange,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(30),
                      ),
                      padding: EdgeInsets.symmetric(horizontal: 80, vertical: 15),
                    ),
                    child: Text(
                      'Signup',
                      style: TextStyle(fontSize: 18, color: Colors.white),
                    ),
                  ),
                ],
              ),
            ),
          ),
          // Texte "Already Have Account? Login" entre les deux demi-cercles
          Positioned(
            bottom: 40, // Ajustez la position si nécessaire
            left: 8,
            right: 0,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(
                  'Already Have Account?',
                  style: TextStyle(color: Colors.white),
                ),
                TextButton(
                  onPressed: () {
                    // Retour à la page de connexion
                    Navigator.pop(context);
                  },
                  child: Text(
                    'Login',
                    style: TextStyle(color: Colors.orange),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class AnimatedLogo extends StatefulWidget {
  @override
  _AnimatedLogoState createState() => _AnimatedLogoState();
}

class _AnimatedLogoState extends State<AnimatedLogo> with SingleTickerProviderStateMixin {
  late AudioPlayer _audioPlayer;
  late AnimationController _animationController;

  @override
  void initState() {
    super.initState();
    _audioPlayer = AudioPlayer();
    _playAudio();

    // Initialisez l'AnimationController
    _animationController = AnimationController(
      duration: Duration(seconds: 25), // Durée totale en tenant compte des cycles
      vsync: this,
    );

    // Écouteur pour détecter la fin de l'animation
    _animationController.addStatusListener((status) {
      if (status == AnimationStatus.completed) {
        _stopAudio(); // Arrêtez l'audio lorsque l'animation est terminée
      }
    });

    // Démarrez l'animation
    _animationController.forward();
  }

  Future<void> _playAudio() async {
    try {
      await _audioPlayer.setAsset('audio/son.mp3'); // Assurez-vous que le fichier audio est dans assets/audio
      _audioPlayer.play();
    } catch (e) {
      print("Erreur de chargement audio : $e");
    }
  }

  void _stopAudio() {
    _audioPlayer.stop(); // Arrête l'audio
  }

  @override
  void dispose() {
    _audioPlayer.dispose();
    _animationController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final screenSize = MediaQuery.of(context).size;

    return Scaffold(
      backgroundColor: Colors.black,
      body: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Padding(
            padding: const EdgeInsets.only(top: 40.0),
            child: Text(
              'Welcome to Body Building',
              style: GoogleFonts.pacifico(
                fontSize: 24,
                fontWeight: FontWeight.bold,
                color: Colors.white,
              ),
              textAlign: TextAlign.center,
            ),
          ),
          Expanded(
            child: Center(
              child: AnimatedBuilder(
                animation: _animationController,
                builder: (context, child) {
                  double size = _animationController.value * screenSize.width;
                  return Container(
                    height: size,
                    width: size,
                    child: Image.asset(
                      'images/body.jpeg',
                      fit: BoxFit.cover,
                    ),
                  );
                },
              ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.only(bottom: 20.0),
            child: ElevatedButton(
              onPressed: () {
                _stopAudio(); // Arrêter l'audio si on change de page
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => ProductListPage()),
                );
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.yellow[700],
                padding: EdgeInsets.symmetric(vertical: 12.0, horizontal: 24.0),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(8.0),
                ),
              ),
              child: Text(
                'View Products',
                style: TextStyle(color: Colors.black, fontSize: 16),
              ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.only(bottom: 20.0),
            child: ElevatedButton(
              onPressed: () {
                _stopAudio(); // Arrêter l'audio si on change de page
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => SubscriptionPage()),
                );
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.green[700],
                padding: EdgeInsets.symmetric(vertical: 12.0, horizontal: 24.0),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(8.0),
                ),
              ),
              child: Text(
                'View Subscriptions',
                style: TextStyle(color: Colors.white, fontSize: 16),
              ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.only(bottom: 40.0),
            child: ElevatedButton(
              onPressed: () {
                _stopAudio(); // Ajoutez ici l'action pour le bouton
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => ChatScreen()), // Assurez-vous que ChatBotScreen est correctement importé
                );
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.blueAccent,
                padding: EdgeInsets.symmetric(vertical: 12.0, horizontal: 24.0),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(8.0),
                ),
              ),
              child: Text(
                'Start New Conversation',
                style: TextStyle(color: Colors.white, fontSize: 16),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class ChangePasswordPage extends StatefulWidget {
  @override
  _ChangePasswordPageState createState() => _ChangePasswordPageState();
}

class _ChangePasswordPageState extends State<ChangePasswordPage> {
  final _oldPasswordController = TextEditingController();
  final _newPasswordController = TextEditingController();
  final _confirmPasswordController = TextEditingController();
  final DatabaseHelper _dbHelper = DatabaseHelper();

  Future<void> _changePassword() async {
    final email = "user@example.com"; // Remplacez par l'email actuel de l'utilisateur
    final oldPassword = _oldPasswordController.text;
    final newPassword = _newPasswordController.text;
    final confirmPassword = _confirmPasswordController.text;

    print('Old password entered: $oldPassword');

    if (newPassword != confirmPassword) {
      // Affiche un message d'erreur si les nouveaux mots de passe ne correspondent pas
      _showMessage(context, "New passwords do not match.");
      return;
    }

    // Récupère l'utilisateur actuel par email
    final user = await _dbHelper.getUserByEmail(email);
    if (user != null && user.password.trim() == oldPassword.trim()) {
      await _dbHelper.updatePassword(user.id!, newPassword);
      _showMessage(context, "Password successfully changed.");
    } else {
      _showMessage(context, "Old password is incorrect.");
    }
  }

  void _showMessage(BuildContext context, String message) {
    ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(message)));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.brown[900],
      body: Center(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 24.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text(
                'Change Password',
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 24,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 8),
              Text(
                'Please enter your details',
                style: TextStyle(
                  color: Colors.white70,
                  fontSize: 16,
                ),
              ),
              const SizedBox(height: 32),

              // Champ pour l'ancien mot de passe
              _buildPasswordField(_oldPasswordController, 'Old Password'),
              const SizedBox(height: 16),

              // Champ pour le nouveau mot de passe
              _buildPasswordField(_newPasswordController, 'New Password'),
              const SizedBox(height: 16),

              // Champ pour confirmer le nouveau mot de passe
              _buildPasswordField(_confirmPasswordController, 'Confirm New Password'),
              const SizedBox(height: 16),

              ElevatedButton(
                onPressed: _changePassword,
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.yellow[700],
                  padding: const EdgeInsets.symmetric(vertical: 12.0, horizontal: 48.0),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(8.0),
                  ),
                ),
                child: Text(
                  'Change Password',
                  style: TextStyle(
                    color: Colors.black,
                    fontSize: 16,
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildPasswordField(TextEditingController controller, String hint) {
    return TextField(
      controller: controller,
      obscureText: true,
      style: TextStyle(color: Colors.white),
      decoration: InputDecoration(
        filled: true,
        fillColor: Colors.brown[800],
        prefixIcon: Icon(Icons.lock, color: Colors.white70),
        hintText: hint,
        hintStyle: TextStyle(color: Colors.white70),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(8.0),
          borderSide: BorderSide.none,
        ),
      ),
    );
  }
}



// Page de liste des produits
class ProductListPage extends StatelessWidget {
  final List<Map<String, String>> products = [
    {"image": "images/creatinepur.jpeg", "name": "Product 1", "price": "150\D\T"},
    {"image": "images/creatinewhy.jpeg", "name": "Product 2", "price": "250\D\T"},
    {"image": "images/isowhy.jpeg", "name": "Product 3", "price": "190\D\T"},
    {"image": "images/massgainer.jpeg", "name": "Product 4", "price": "270\D\T"},
    {"image": "images/whycreatine.jpeg", "name": "Product 5", "price": "310\D\T"},
    {"image": "images/whyprotien.jpeg", "name": "Product 6", "price": "230\D\T"},
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Product List'),
        backgroundColor: Colors.red,
      ),
      body: Padding(
        padding: const EdgeInsets.all(8.0),
        child: GridView.builder(
          gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
            crossAxisCount: 2, // Deux colonnes
            crossAxisSpacing: 10,
            mainAxisSpacing: 10,
            childAspectRatio: 0.8, // Aspect pour ajuster l'image et le texte
          ),
          itemCount: products.length,
          itemBuilder: (context, index) {
            return ProductCard(
              image: products[index]["image"]!,
              name: products[index]["name"]!,
              price: products[index]["price"]!,
            );
          },
        ),
      ),
    );
  }
}
class ProductCard extends StatelessWidget {
  final String image;
  final String name;
  final String price;

  ProductCard({required this.image, required this.name, required this.price});

  @override
  Widget build(BuildContext context) {
    return Card(
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12),
      ),
      elevation: 4,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Expanded(
            child: ClipRRect(
              borderRadius: BorderRadius.vertical(top: Radius.circular(12)),
              child: Image.asset(
                image,
                fit: BoxFit.cover,
              ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  name,
                  style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                SizedBox(height: 4),
                Text(
                  price,
                  style: TextStyle(
                    fontSize: 14,
                    color: Colors.grey[700],
                  ),
                ),
                SizedBox(height: 8),
                SizedBox(
                  width: double.infinity, // Button takes full width
                  child: ElevatedButton(
                    onPressed: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => PaymentPageProduct(
                            subscriptionName: name, // Passez le nom du produit
                            price: price,           // Passez le prix du produit
                          ),
                        ),
                      );
                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.red, // Button color
                    ),
                    child: Text('Buy Now'),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class SubscriptionPage extends StatelessWidget {
  final List<Map<String, String>> subscriptions = [
    {"name": "Monthly Subscription", "price": "50 DT"},
    {"name": "Quarterly Subscription", "price": "180 DT"},
    {"name": "Half-Yearly Subscription", "price": "270 DT"},
    {"name": "Annual Subscription", "price": "500 DT"},
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Gym Subscriptions'),
        backgroundColor: Colors.green,
      ),
      body: Column(
        children: [
          // Design en-tête
          Container(
            width: double.infinity,
            padding: EdgeInsets.all(20),
            decoration: BoxDecoration(
              color: Colors.green[700],
              borderRadius: BorderRadius.vertical(
                bottom: Radius.circular(30),
              ),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Choose Your Subscription Plan',
                  style: TextStyle(
                    fontSize: 24,
                    fontWeight: FontWeight.bold,
                    color: Colors.white,
                  ),
                ),

              ],
            ),
          ),
          SizedBox(height: 20),
          // Liste des abonnements
          Expanded(
            child: Padding(
              padding: const EdgeInsets.all(8.0),
              child: ListView.builder(
                itemCount: subscriptions.length,
                itemBuilder: (context, index) {
                  return Card(
                    margin: EdgeInsets.symmetric(vertical: 8),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: ListTile(
                      leading: Icon(Icons.fitness_center, color: Colors.green),
                      title: Text(
                        subscriptions[index]["name"]!,
                        style: TextStyle(fontWeight: FontWeight.bold),
                      ),
                      subtitle: Text(
                        subscriptions[index]["price"]!,
                        style: TextStyle(color: Colors.grey[700]),
                      ),
                      trailing: ElevatedButton(
                        onPressed: () {
                          // Logique pour le paiement
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => PaymentPage(
                                subscriptionName: subscriptions[index]["name"]!,
                                price: subscriptions[index]["price"]!,
                              ),
                            ),
                          );
                        },
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.green,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(8),
                          ),
                        ),
                        child: Text(
                          'Pay Now',
                          style: TextStyle(color: Colors.white),
                        ),
                      ),
                    ),
                  );
                },
              ),
            ),
          ),
          // Design de gym sous la liste des abonnements
          Container(
            padding: EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: Colors.green[50],
              borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
            ),
            child: Column(
              children: [
                Text(
                  "Achieve Your Fitness Goals",
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 18,
                    color: Colors.green[800],
                  ),
                ),
                SizedBox(height: 8),
                Text(
                  "Join our gym today and enjoy personalized training plans!",
                  textAlign: TextAlign.center,
                  style: TextStyle(color: Colors.grey[700]),
                ),
                SizedBox(height: 16),
                Image.asset(
                  'images/body.jpeg', // Assurez-vous d'avoir une image "body.jpeg" dans vos assets
                  height: 150,
                  fit: BoxFit.cover,
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
class PaymentPage extends StatelessWidget {
  final String subscriptionName;
  final String price;

  PaymentPage({required this.subscriptionName, required this.price});

  final _formKey = GlobalKey<FormState>();
  final _cardNumberController = TextEditingController();
  final _secureCodeController = TextEditingController();

  bool _validateCardNumber(String value) {
    final regex = RegExp(r'^14\d{10}77$'); // Commence par 14, 10 chiffres, termine par 77
    return regex.hasMatch(value);
  }

  bool _validateSecureCode(String value) {
    final regex = RegExp(r'^\d{3}$'); // 3 chiffres uniquement
    return regex.hasMatch(value);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Payment'),
        backgroundColor: Colors.green,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Form(
          key: _formKey,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'Subscription: $subscriptionName',
                style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
              ),
              SizedBox(height: 10),
              Text(
                'Price: $price',
                style: TextStyle(fontSize: 18, color: Colors.grey[700]),
              ),
              SizedBox(height: 20),
              TextFormField(
                controller: _cardNumberController,
                decoration: InputDecoration(
                  labelText: 'Card number',
                  border: OutlineInputBorder(),
                  prefixIcon: Icon(Icons.credit_card),
                ),
                keyboardType: TextInputType.number,
                validator: (value) {
                  if (value == null || !_validateCardNumber(value)) {
                    return 'Card number must be 14 digits, start with 14 and end with 77';
                  }
                  return null;
                },
              ),
              SizedBox(height: 10),
              Row(
                children: [
                  Expanded(
                    child: DropdownButtonFormField<String>(
                      decoration: InputDecoration(
                        labelText: 'Month',
                        border: OutlineInputBorder(),
                      ),
                      items: List.generate(
                        12,
                            (index) => DropdownMenuItem(
                          value: (index + 1).toString().padLeft(2, '0'),
                          child: Text((index + 1).toString().padLeft(2, '0')),
                        ),
                      ),
                      onChanged: (value) {},
                    ),
                  ),
                  SizedBox(width: 10),
                  Expanded(
                    child: DropdownButtonFormField<String>(
                      decoration: InputDecoration(
                        labelText: 'Year',
                        border: OutlineInputBorder(),
                      ),
                      items: List.generate(
                        10,
                            (index) => DropdownMenuItem(
                          value: (DateTime.now().year + index).toString(),
                          child: Text((DateTime.now().year + index).toString()),
                        ),
                      ),
                      onChanged: (value) {},
                    ),
                  ),
                ],
              ),
              SizedBox(height: 10),
              TextFormField(
                controller: _secureCodeController,
                decoration: InputDecoration(
                  labelText: 'Secure code',
                  border: OutlineInputBorder(),
                ),
                keyboardType: TextInputType.number,
                obscureText: true,
                validator: (value) {
                  if (value == null || !_validateSecureCode(value)) {
                    return 'Secure code must be 3 digits';
                  }
                  return null;
                },
              ),
              SizedBox(height: 10),
              TextField(
                decoration: InputDecoration(
                  labelText: 'Cardholder name',
                  border: OutlineInputBorder(),
                ),
                keyboardType: TextInputType.name,
              ),
              SizedBox(height: 10),
              Row(
                children: [
                  Checkbox(
                    value: true,
                    onChanged: (bool? value) {},
                  ),
                  Expanded(
                    child: TextField(
                      decoration: InputDecoration(
                        labelText: 'Email address',
                        border: OutlineInputBorder(),
                      ),
                      keyboardType: TextInputType.emailAddress,
                    ),
                  ),
                ],
              ),
              SizedBox(height: 20),
              Center(
                child: ElevatedButton(
                  onPressed: () {
                    if (_formKey.currentState!.validate()) {
                      ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(
                          content: Text('Payment successful!'),
                        ),
                      );
                      Navigator.push(
                        context,
                        MaterialPageRoute(builder: (context) => TrainingProgramPage()),
                      );
                    }
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.green,
                    padding: EdgeInsets.symmetric(horizontal: 50, vertical: 15),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(8),
                    ),
                  ),
                  child: Text(
                    'Confirm Payment',
                    style: TextStyle(color: Colors.white),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class TrainingProgramPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Training Program'),
        backgroundColor: Colors.blue,
      ),
      body: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            colors: [Colors.blue.shade100, Colors.blue.shade300],
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
          ),
        ),
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Center(
                child: Container(
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black26,
                        blurRadius: 10,
                        offset: Offset(0, 5),
                      ),
                    ],
                  ),
                  child: ClipOval(
                    child: Image.asset(
                      'images/programbody.jpeg',
                      width: 120,
                      height: 120,
                      fit: BoxFit.cover,
                    ),
                  ),
                ),
              ),
              SizedBox(height: 20),
              Text(
                'Your Training Program',
                style: TextStyle(
                  fontSize: 26,
                  fontWeight: FontWeight.bold,
                  color: Colors.white,
                ),
                textAlign: TextAlign.center,
              ),
              SizedBox(height: 20),
              Expanded(
                child: ListView(
                  children: [
                    buildTrainingCard(
                      'Day 1',
                      'Chest and Back Exercises',
                      Icons.fitness_center,
                      context,
                      DayTrainingPage(
                        title: 'Day 1: Chest and Back',
                        description: 'Training videos for chest and back exercises.',
                        videoPath: 'video/chestandback.mp4',
                      ),
                    ),
                    buildTrainingCard(
                      'Day 2',
                      'Legs and Abs Exercises',
                      Icons.directions_run,
                      context,
                      DayTrainingPage(
                        title: 'Day 2: Legs and Abs',
                        description: 'Training videos for legs and abs exercises.',
                        videoPath: 'video/day2.mp4',
                      ),
                    ),
                    buildTrainingCard(
                      'Day 3',
                      'Arms and Shoulders Exercises',
                      Icons.sports_handball,
                      context,
                      DayTrainingPage(
                        title: 'Day 3: Arms and Shoulders',
                        description: 'Training videos for arms and shoulders exercises.',
                        videoPath: 'video/day3.mp4',
                      ),
                    ),
                    buildTrainingCard(
                      'Day 4',
                      'Cardio and Core Exercises',
                      Icons.favorite,
                      context,
                      DayTrainingPage(
                        title: 'Day 4: Cardio and Core',
                        description: 'Training videos for cardio and core exercises.',
                        videoPath: 'video/day4.mp4',
                      ),
                    ),
                    buildTrainingCard(
                      'Day 5',
                      'Full Body Workout',
                      Icons.self_improvement,
                      context,
                      DayTrainingPage(
                        title: 'Day 5: Full Body',
                        description: 'Training videos for a full body workout.',
                        videoPath: 'video/day5.mp4',
                      ),
                    ),
                    buildTrainingCard(
                      'Day 6',
                      'Rest Day',
                      Icons.hotel,
                      context,
                      DayTrainingPage(
                        title: 'Day 6: Rest Day',
                        description: 'Rest day to recover and recharge.',
                        videoPath: 'video/day6.mp4',
                      ),
                    ),
                    buildTrainingCard(
                      'Day 7',
                      'Cardio Exercises',
                      Icons.directions_bike,
                      context,
                      DayTrainingPage(
                        title: 'Day 7: Cardio',
                        description: 'Training videos for cardio exercises.',
                        videoPath: 'video/day7.mp4',
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget buildTrainingCard(String day, String description, IconData icon, BuildContext context, Widget targetPage) {
    return InkWell(
      onTap: () {
        Navigator.push(
          context,
          MaterialPageRoute(builder: (context) => targetPage),
        );
      },
      child: Card(
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(15),
        ),
        elevation: 5,
        margin: EdgeInsets.symmetric(vertical: 8),
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Row(
            children: [
              Icon(icon, color: Colors.blueAccent, size: 30),
              SizedBox(width: 15),
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    day,
                    style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                      color: Colors.blueAccent,
                    ),
                  ),
                  SizedBox(height: 5),
                  Text(
                    description,
                    style: TextStyle(
                      fontSize: 15,
                      color: Colors.black54,
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class DietProgramPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Fat Loss Diet Program 1'),
        backgroundColor: Colors.blue,
      ),
      body: ListView(
        padding: const EdgeInsets.all(8.0),
        children: [
          // First meal: Breakfast
          MealCard(
            mealTitle: "First meal: Breakfast",
            items: [
              ["Whey protein", "1 scoop", "120", "24", "3", "1"],
              ["Oats", "100 g", "347", "12", "60", "7"],
              ["Walnuts", "30 g", "196", "4.56", "4.08", "19"],
            ],
            preparationMethod:
            "Preparation method: Mix oats with walnuts and protein, then add water and stir the mixture.",
          ),

          // Second meal: Snack
          MealCard(
            mealTitle: "Second meal: Snack",
            items: [
              ["Medium-sized apple", "150 g", "150", "0", "19", "0"],
              ["Walnuts", "30 g", "196", "4.56", "4.08", "19.56"],
              ["Multivitamin supplement", "1 tablet", "-", "-", "-", "-"],
            ],
          ),

          // Third meal: Lunch
          MealCard(
            mealTitle: "Third meal: Lunch",
            items: [
              ["Chicken breast", "200 g", "242", "48", "0", "3.6"],
              ["Basmati rice", "50 g", "174", "3.6", "38.5", "0.4"],
              ["Boiled egg", "2 eggs", "140", "12", "2", "10"],
            ],
            preparationMethod:
            "Medium-sized salad with tomatoes, cucumbers, and a little olive oil.",
          ),

          // Fourth meal: Pre-workout snack
          MealCard(
            mealTitle: "Fourth meal: Pre-workout snack",
            items: [
              ["Coffee without sugar", "1", "2", "0", "0", "0"],
            ],
          ),

          // Fifth meal: Post-workout
          MealCard(
            mealTitle: "Fifth meal: Post-workout",
            items: [
              ["Chicken breast", "200 g", "242", "48", "0", "3.6"],
              ["Basmati rice", "35 g", "121", "2.52", "26.95", "0.28"],
              ["Boiled egg", "1 egg", "70", "6", "1", "5"],
            ],
            preparationMethod:
            "Medium-sized salad with tomatoes, cucumbers, and a little olive oil.",
          ),

          // Total Calories Section
          Padding(
            padding: const EdgeInsets.symmetric(vertical: 16.0),
            child: Column(
              children: [
                Divider(),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                  children: [
                    Text("Total", style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
                    Text("2002", style: TextStyle(fontSize: 16)),
                    Text("165", style: TextStyle(fontSize: 16)),
                    Text("159", style: TextStyle(fontSize: 16)),
                    Text("70", style: TextStyle(fontSize: 16)),
                  ],
                ),
                Divider(),
                SizedBox(height: 10),
                Text("Rate Us", style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: List.generate(5, (index) => Icon(Icons.star, color: Colors.amber)),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class MealCard extends StatelessWidget {
  final String mealTitle;
  final List<List<String>> items;
  final String? preparationMethod;

  MealCard({required this.mealTitle, required this.items, this.preparationMethod});

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: const EdgeInsets.symmetric(vertical: 8.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            color: Colors.blue,
            width: double.infinity,
            padding: const EdgeInsets.all(8.0),
            child: Text(
              mealTitle,
              style: TextStyle(color: Colors.white, fontSize: 18, fontWeight: FontWeight.bold),
            ),
          ),
          DataTable(
            columns: [
              DataColumn(label: Text('Quantity')),
              DataColumn(label: Text('Calories')),
              DataColumn(label: Text('Protein')),
              DataColumn(label: Text('Carb')),
              DataColumn(label: Text('Fat')),
            ],
            rows: items.map((item) {
              return DataRow(cells: item.sublist(1).map((data) => DataCell(Text(data))).toList());
            }).toList(),
          ),
          if (preparationMethod != null)
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: Text(preparationMethod!, style: TextStyle(fontSize: 14, color: Colors.grey[700])),
            ),
        ],
      ),
    );
  }
}
class PaymentPageProduct extends StatelessWidget {
  final String subscriptionName;
  final String price;

  PaymentPageProduct({required this.subscriptionName, required this.price});

  final _formKey = GlobalKey<FormState>();
  final _cardNumberController = TextEditingController();
  final _secureCodeController = TextEditingController();

  bool _validateCardNumber(String value) {
    final regex = RegExp(r'^14\d{10}77$'); // Commence par 14, 10 chiffres, termine par 77
    return regex.hasMatch(value);
  }

  bool _validateSecureCode(String value) {
    final regex = RegExp(r'^\d{3}$'); // 3 chiffres uniquement
    return regex.hasMatch(value);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Payment'),
        backgroundColor: Colors.green,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Form(
          key: _formKey,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'Subscription: $subscriptionName',
                style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
              ),
              SizedBox(height: 10),
              Text(
                'Price: $price',
                style: TextStyle(fontSize: 18, color: Colors.grey[700]),
              ),
              SizedBox(height: 20),
              TextFormField(
                controller: _cardNumberController,
                decoration: InputDecoration(
                  labelText: 'Card number',
                  border: OutlineInputBorder(),
                  prefixIcon: Icon(Icons.credit_card), // Affiche une icône de carte bancaire
                ),
                keyboardType: TextInputType.number,
                validator: (value) {
                  if (value == null || !_validateCardNumber(value)) {
                    return 'Card number must be 14 digits, start with 14 and end with 77';
                  }
                  return null;
                },
              ),
              SizedBox(height: 10),
              Row(
                children: [
                  Expanded(
                    child: DropdownButtonFormField<String>(
                      decoration: InputDecoration(
                        labelText: 'Month',
                        border: OutlineInputBorder(),
                      ),
                      items: List.generate(
                        12,
                            (index) => DropdownMenuItem(
                          value: (index + 1).toString().padLeft(2, '0'),
                          child: Text((index + 1).toString().padLeft(2, '0')),
                        ),
                      ),
                      onChanged: (value) {},
                    ),
                  ),
                  SizedBox(width: 10),
                  Expanded(
                    child: DropdownButtonFormField<String>(
                      decoration: InputDecoration(
                        labelText: 'Year',
                        border: OutlineInputBorder(),
                      ),
                      items: List.generate(
                        10,
                            (index) => DropdownMenuItem(
                          value: (DateTime.now().year + index).toString(),
                          child: Text((DateTime.now().year + index).toString()),
                        ),
                      ),
                      onChanged: (value) {},
                    ),
                  ),
                ],
              ),
              SizedBox(height: 10),
              TextFormField(
                controller: _secureCodeController,
                decoration: InputDecoration(
                  labelText: 'Secure code',
                  border: OutlineInputBorder(),
                ),
                keyboardType: TextInputType.number,
                obscureText: true,
                validator: (value) {
                  if (value == null || !_validateSecureCode(value)) {
                    return 'Secure code must be 3 digits';
                  }
                  return null;
                },
              ),
              SizedBox(height: 10),
              TextField(
                decoration: InputDecoration(
                  labelText: 'Cardholder name',
                  border: OutlineInputBorder(),
                ),
                keyboardType: TextInputType.name,
              ),
              SizedBox(height: 10),
              Row(
                children: [
                  Checkbox(
                    value: true,
                    onChanged: (bool? value) {},
                  ),
                  Expanded(
                    child: TextField(
                      decoration: InputDecoration(
                        labelText: 'Email address',
                        border: OutlineInputBorder(),
                      ),
                      keyboardType: TextInputType.emailAddress,
                    ),
                  ),
                ],
              ),
              SizedBox(height: 20),
              Center(
                child: ElevatedButton(
                  onPressed: () {
                    if (_formKey.currentState!.validate()) {
                      ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(
                          content: Text('Payment successful!'),
                        ),
                      );
                      Navigator.push(
                        context,
                        MaterialPageRoute(builder: (context) => DietProgramPage()),
                      );
                    }
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.green,
                    padding: EdgeInsets.symmetric(horizontal: 50, vertical: 15),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(8),
                    ),
                  ),
                  child: Text(
                    'Confirm Payment',
                    style: TextStyle(color: Colors.white),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class User {
  final int? id;
  final String name;
  final String email;
  final String password;

  User({this.id, required this.name, required this.email, required this.password});

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'name': name,
      'email': email,
      'password': password,
    };
  }

  // Méthode fromMap pour créer un objet User à partir d'une Map
  factory User.fromMap(Map<String, dynamic> map) {
    return User(
      id: map['id'] as int?,
      name: map['name'] as String,
      email: map['email'] as String,
      password: map['password'] as String,
    );
  }
}

class DatabaseHelper {
  static final DatabaseHelper _instance = DatabaseHelper._internal();
  factory DatabaseHelper() => _instance;
  DatabaseHelper._internal();

  static Database? _database;

  Future<Database> get database async {
    if (_database != null) return _database!;
    _database = await _initDatabase();
    return _database!;
  }

  Future<Database> _initDatabase() async {
    final dbPath = path.join(await getDatabasesPath(), 'app_database.db');
    return await openDatabase(
      dbPath,
      onCreate: (db, version) {
        return db.execute(
          'CREATE TABLE users(id INTEGER PRIMARY KEY AUTOINCREMENT, name TEXT, email TEXT, password TEXT)',
        );
      },
      version: 1,
    );
  }


  Future<void> insertUser(User user) async {
    final db = await database;
    await db.insert('users', user.toMap(), conflictAlgorithm: ConflictAlgorithm.replace);
  }

  Future<User?> getUserByEmail(String email) async {
    final db = await database;
    final maps = await db.query(
      'users',
      where: 'email = ?',
      whereArgs: [email],
    );

    if (maps.isNotEmpty) {
      return User.fromMap(maps.first); // Utilisation de User.fromMap pour créer l'utilisateur
    }
    return null;
  }
  Future<void> updatePassword(int id, String newPassword) async {
    final db = await database;
    await db.update(
      'users',
      {'password': newPassword},
      where: 'id = ?',
      whereArgs: [id],
    );
  }
}
class DayTrainingPage extends StatelessWidget {
  final String title;
  final String description;
  final String videoPath;

  DayTrainingPage({
    required this.title,
    required this.description,
    required this.videoPath,
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(title),
        backgroundColor: Colors.blue,
      ),
      body: Container(
        padding: EdgeInsets.all(16.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              Icons.play_circle_fill,
              color: Colors.blueAccent,
              size: 100,
            ),
            SizedBox(height: 20),
            Text(
              description,
              style: TextStyle(
                fontSize: 18,
                color: Colors.black87,
              ),
              textAlign: TextAlign.center,
            ),
            SizedBox(height: 40),
            ElevatedButton(
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => VideoPlayerScreen(videoPath: videoPath),
                  ),
                );
              },
              child: Text('Watch Training Videos'),
            ),
          ],
        ),
      ),
    );
  }
}

class VideoPlayerScreen extends StatefulWidget {
  final String videoPath;

  VideoPlayerScreen({required this.videoPath});

  @override
  _VideoPlayerScreenState createState() => _VideoPlayerScreenState();
}

class _VideoPlayerScreenState extends State<VideoPlayerScreen> {
  late VideoPlayerController _controller;

  @override
  void initState() {
    super.initState();
    // Initialisation du lecteur vidéo
    _controller = VideoPlayerController.asset(widget.videoPath)
      ..initialize().then((_) {
        setState(() {}); // Actualise l'interface après l'initialisation
      });
  }

  @override
  void dispose() {
    _controller.dispose(); // Libère les ressources du lecteur vidéo
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Lire la vidéo'),
      ),
      body: Center(
        child: _controller.value.isInitialized
            ? AspectRatio(
          aspectRatio: _controller.value.aspectRatio,
          child: VideoPlayer(_controller),
        )
            : CircularProgressIndicator(),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          setState(() {
            _controller.value.isPlaying ? _controller.pause() : _controller.play();
          });
        },
        child: Icon(
          _controller.value.isPlaying ? Icons.pause : Icons.play_arrow,
        ),
      ),
    );
  }
}




