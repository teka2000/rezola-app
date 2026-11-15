import 'package:flutter/material.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  runApp(const RezolaLifestyleApp());
}

// الألوان المخصصة الفخمة
const Color primaryBurgundy = Color(0xFF80011f);
const Color backgroundCream = Color(0xFFfefaee);

// بيانات المنتجات الأساسية
List rezolaProducts = [
  {
    'name': 'سجادة يوغا مانعة للانزلاق',
    'price': '450 ج.م',
    'desc': 'مثالية للتمارين المنزلية، التأمل، وإطالة العضلات.',
    'image': 'https://images.unsplash.com/photo-1592432678016-e910b452f9a2?w=500',
  },
  {
    'name': 'زجاجة مياه ذكية تتبع الترطيب',
    'price': '650 ج.م',
    'desc': 'تساعدك على تذكيرك بشرب الماء بانتظام طوال اليوم.',
    'image': 'https://images.unsplash.com/photo-1602143407151-7111542de6e8?w=500',
  },
  {
    'name': 'مجموعة أربطة مقاومة للتمارين',
    'price': '300 ج.م',
    'desc': 'لتقوية عضلات الجسم المختلفة في أي وقت ومكان.',
    'image': 'https://images.unsplash.com/photo-1584100936595-c0654b55a2e2?w=500',
  },
  {
    'name': 'وسادة طبية مريحة للرقبة',
    'price': '550 ج.م',
    'desc': 'تحسن جودة النوم وتدعم فقرات الرقبة والظهر.',
    'image': 'https://images.unsplash.com/photo-1584100936595-c0654b55a2e2?w=500',
  },
  {
    'name': 'جهاز مساج عضلي محمول',
    'price': '1,100 ج.م',
    'desc': 'لإرخاء العضلات بعد التمارين الرياضية وتقليل الإجهاد.',
    'image': 'https://images.unsplash.com/photo-1540420773420-3366772f4999?w=500',
  },
];

List cartItems = [];
List storeOrders = [];

// بيانات المستخدم الحالي والملف الشخصي
String currentUserEmail = '';
String currentUserPhone = '01234567890';
String currentUserAddress = 'القاهرة، مصر';

List registeredUsers = [
  {'email': 'client@rezola.com', 'password': '123456', 'phone': '01000000000', 'address': 'الإسكندرية، مصر'}
];

class RezolaLifestyleApp extends StatelessWidget {
  const RezolaLifestyleApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Rezola Lifestyle',
      theme: ThemeData(
        primaryColor: primaryBurgundy,
        scaffoldBackgroundColor: backgroundCream,
        colorScheme: ColorScheme.fromSeed(
          seedColor: primaryBurgundy,
          primary: primaryBurgundy,
          surface: backgroundCream,
        ),
        fontFamily: 'Cairo',
      ),
      home: const AuthScreen(),
    );
  }
}

class AuthScreen extends StatefulWidget {
  const AuthScreen({Key? key}) : super(key: key);

  @override
  State<AuthScreen> createState() => _AuthScreenState();
}

class _AuthScreenState extends State<AuthScreen> with SingleTickerProviderStateMixin {
  bool isLoginMode = true;
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  String _errorMessage = '';

  late AnimationController _glowController;
  late Animation<double> _glowAnimation;

  @override
  void initState() {
    super.initState();
    _glowController = AnimationController(
      duration: const Duration(milliseconds: 1200),
      vsync: this,
    )..repeat(reverse: true);

    _glowAnimation = Tween<double>(begin: 4.0, end: 18.0).animate(
      CurvedAnimation(parent: _glowController, curve: Curves.easeInOut),
    );
  }

  @override
  void dispose() {
    _glowController.dispose();
    _emailController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  void _submitAuth() {
    final email = _emailController.text.trim();
    final password = _passwordController.text.trim();

    if (email.isEmpty || password.isEmpty) {
      setState(() {
        _errorMessage = 'يرجى إدخال البريد الإلكتروني وكلمة المرور';
      });
      return;
    }

    if (email == 'admin@rezola.com' && password == '123456') {
      currentUserEmail = email;
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (context) => const AdminDashboardScreen()),
      );
      return;
    }

    if (isLoginMode) {
      var user = registeredUsers.firstWhere(
            (u) => u['email'] == email && u['password'] == password,
        orElse: () => {},
      );
      if (user.isNotEmpty) {
        currentUserEmail = email;
        currentUserPhone = user['phone'] ?? 'غير محدد';
        currentUserAddress = user['address'] ?? 'غير محدد';
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(builder: (context) => const HomeScreen(isAdmin: false)),
        );
      } else {
        setState(() {
          _errorMessage = 'البريد أو كلمة المرور غير صحيحة، أو قم بإنشاء حساب جديد';
        });
      }
    } else {
      bool exists = registeredUsers.any((u) => u['email'] == email);
      if (exists) {
        setState(() {
          _errorMessage = 'هذا البريد مستخدم مسبقاً، سجل دخولك مباشرة';
        });
      } else {
        registeredUsers.add({
          'email': email,
          'password': password,
          'phone': 'أدخل رقم الهاتف',
          'address': 'أدخل عنوان الشحن'
        });
        currentUserEmail = email;
        currentUserPhone = 'أدخل رقم الهاتف';
        currentUserAddress = 'أدخل عنوان الشحن';
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('تم إنشاء الحساب وتسجيل الدخول بنجاح!')),
        );
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(builder: (context) => const HomeScreen(isAdmin: false)),
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: backgroundCream,
      body: Padding(
        padding: const EdgeInsets.all(24.0),
        child: Center(
          child: SingleChildScrollView(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                // أيقونة الشعار مع تأثير التوهج (Glow)
                AnimatedBuilder(
                  animation: _glowAnimation,
                  builder: (context, child) {
                    return Container(
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        boxShadow: [
                          BoxShadow(
                            color: primaryBurgundy.withOpacity(0.4),
                            blurRadius: _glowAnimation.value,
                            spreadRadius: 2,
                          ),
                        ],
                      ),
                      child: const Icon(Icons.spa, size: 80, color: primaryBurgundy),
                    );
                  },
                ),
                const SizedBox(height: 16),
                // الشعار النصي المنور والمتوهج
                const NeonGlowText(text: 'REZOLA', fontSize: 24, isCompact: true),
                const SizedBox(height: 12),
                Text(isLoginMode ? 'تسجيل الدخول إلى حسابك' : 'إنشاء حساب عميل جديد', style: const TextStyle(fontSize: 14, color: Colors.grey)),
                const SizedBox(height: 30),
                TextField(
                  controller: _emailController,
                  decoration: InputDecoration(
                    labelText: 'البريد الإلكتروني',
                    prefixIcon: const Icon(Icons.email, color: primaryBurgundy),
                    border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
                    filled: true,
                    fillColor: Colors.white,
                  ),
                ),
                const SizedBox(height: 16),
                TextField(
                  controller: _passwordController,
                  obscureText: true,
                  decoration: InputDecoration(
                    labelText: 'كلمة المرور',
                    prefixIcon: const Icon(Icons.lock, color: primaryBurgundy),
                    border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
                    filled: true,
                    fillColor: Colors.white,
                  ),
                ),
                if (_errorMessage.isNotEmpty) ...[
                  const SizedBox(height: 12),
                  Text(_errorMessage, style: const TextStyle(color: primaryBurgundy, fontSize: 13), textAlign: TextAlign.center),
                ],
                const SizedBox(height: 24),
                SizedBox(
                  width: double.infinity,
                  height: 50,
                  child: ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      backgroundColor: primaryBurgundy,
                      foregroundColor: Colors.white,
                      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                    ),
                    onPressed: _submitAuth,
                    child: Text(isLoginMode ? 'دخول' : 'تسجيل حساب جديد', style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
                  ),
                ),
                const SizedBox(height: 12),
                TextButton(
                  onPressed: () {
                    setState(() {
                      isLoginMode = !isLoginMode;
                      _errorMessage = '';
                    });
                  },
                  child: Text(
                    isLoginMode ? 'ليس لديك حساب؟ انقر هنا لإنشاء حساب جديد' : 'لديك حساب بالفعل؟ سجل دخولك',
                    style: const TextStyle(color: primaryBurgundy, fontWeight: FontWeight.bold),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class AdminDashboardScreen extends StatefulWidget {
  const AdminDashboardScreen({Key? key}) : super(key: key);

  @override
  State<AdminDashboardScreen> createState() => _AdminDashboardScreenState();
}

class _AdminDashboardScreenState extends State<AdminDashboardScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const NeonGlowText(text: 'ADMIN DASHBOARD', fontSize: 18, isCompact: true),
        backgroundColor: primaryBurgundy,
        foregroundColor: Colors.white,
        elevation: 4,
        actions: [
          IconButton(
            icon: const Icon(Icons.logout),
            onPressed: () {
              Navigator.pushReplacement(context, MaterialPageRoute(builder: (context) => const AuthScreen()));
            },
          ),
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text('أهلاً بك، مدير النظام (Admin)', style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold, color: primaryBurgundy)),
            const SizedBox(height: 16),
            Row(
              children: [
                Expanded(child: _buildStatCard('المنتجات', '${rezolaProducts.length}', Icons.store, Colors.blue)),
                const SizedBox(width: 12),
                Expanded(child: _buildStatCard('الطلبات', '${storeOrders.length}', Icons.shopping_bag, Colors.green)),
              ],
            ),
            const SizedBox(height: 24),
            const Text('الإدارة والتحكم', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
            const SizedBox(height: 12),
            ListTile(
              tileColor: Colors.white,
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
              leading: const Icon(Icons.edit_note, color: primaryBurgundy),
              title: const Text('إدارة وتعديل منتجات المتجر'),
              trailing: const Icon(Icons.arrow_forward_ios, size: 16),
              onTap: () async {
                await Navigator.push(context, MaterialPageRoute(builder: (context) => const AdminManageProductsScreen()));
                setState(() {});
              },
            ),
            const SizedBox(height: 10),
            ListTile(
              tileColor: Colors.white,
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
              leading: const Icon(Icons.local_shipping, color: Colors.green),
              title: const Text('تتبع ومتابعة وتعديل حالات طلبات العملاء'),
              trailing: const Icon(Icons.arrow_forward_ios, size: 16),
              onTap: () async {
                await Navigator.push(context, MaterialPageRoute(builder: (context) => const AdminOrdersScreen()));
                setState(() {});
              },
            ),
            const SizedBox(height: 10),
            ListTile(
              tileColor: Colors.white,
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
              leading: const Icon(Icons.visibility, color: Colors.orange),
              title: const Text('معاينة التطبيق كـ مستخدم'),
              trailing: const Icon(Icons.arrow_forward_ios, size: 16),
              onTap: () {
                Navigator.push(context, MaterialPageRoute(builder: (context) => const HomeScreen(isAdmin: true)));
              },
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildStatCard(String title, String count, IconData icon, Color color) {
    return Card(
      elevation: 2,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      color: Colors.white,
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            Icon(icon, size: 32, color: color),
            const SizedBox(height: 8),
            Text(count, style: const TextStyle(fontSize: 22, fontWeight: FontWeight.bold)),
            Text(title, style: const TextStyle(color: Colors.grey)),
          ],
        ),
      ),
    );
  }
}

class AdminManageProductsScreen extends StatefulWidget {
  const AdminManageProductsScreen({Key? key}) : super(key: key);

  @override
  State<AdminManageProductsScreen> createState() => _AdminManageProductsScreenState();
}

class _AdminManageProductsScreenState extends State<AdminManageProductsScreen> {
  String _searchQuery = '';

  void _addNewProductDialog() {
    final nameController = TextEditingController();
    final priceController = TextEditingController();
    final descController = TextEditingController();
    final imageController = TextEditingController();

    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('إضافة منتج جديد'),
        content: SingleChildScrollView(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              TextField(controller: nameController, decoration: const InputDecoration(labelText: 'اسم المنتج')),
              TextField(controller: priceController, decoration: const InputDecoration(labelText: 'السعر (مثال: 500 ج.م)')),
              TextField(controller: descController, decoration: const InputDecoration(labelText: 'الوصف')),
              TextField(controller: imageController, decoration: const InputDecoration(labelText: 'رابط الصورة (URL)')),
            ],
          ),
        ),
        actions: [
          TextButton(onPressed: () => Navigator.pop(context), child: const Text('إلغاء')),
          ElevatedButton(
            style: ElevatedButton.styleFrom(backgroundColor: primaryBurgundy, foregroundColor: Colors.white),
            onPressed: () {
              if (nameController.text.isNotEmpty && priceController.text.isNotEmpty) {
                setState(() {
                  rezolaProducts.add({
                    'name': nameController.text,
                    'price': priceController.text,
                    'desc': descController.text.isNotEmpty ? descController.text : 'منتج مميز من ريزولا',
                    'image': imageController.text.isNotEmpty ? imageController.text : 'https://images.unsplash.com/photo-1592432678016-e910b452f9a2?w=500',
                  });
                });
                Navigator.pop(context);
                ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('تمت إضافة المنتج بنجاح!')));
              }
            },
            child: const Text('إضافة'),
          ),
        ],
      ),
    );
  }

  void _editProductDialog(int productIndex) {
    final prod = rezolaProducts[productIndex];
    final nameController = TextEditingController(text: prod['name']);
    final priceController = TextEditingController(text: prod['price']);
    final descController = TextEditingController(text: prod['desc']);
    final imageController = TextEditingController(text: prod['image']);

    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('تعديل بيانات المنتج'),
        content: SingleChildScrollView(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              TextField(controller: nameController, decoration: const InputDecoration(labelText: 'اسم المنتج')),
              TextField(controller: priceController, decoration: const InputDecoration(labelText: 'السعر')),
              TextField(controller: descController, decoration: const InputDecoration(labelText: 'الوصف')),
              TextField(controller: imageController, decoration: const InputDecoration(labelText: 'رابط الصورة (URL)')),
            ],
          ),
        ),
        actions: [
          TextButton(onPressed: () => Navigator.pop(context), child: const Text('إلغاء')),
          ElevatedButton(
            style: ElevatedButton.styleFrom(backgroundColor: primaryBurgundy, foregroundColor: Colors.white),
            onPressed: () {
              setState(() {
                rezolaProducts[productIndex] = {
                  'name': nameController.text,
                  'price': priceController.text,
                  'desc': descController.text,
                  'image': imageController.text,
                };
              });
              Navigator.pop(context);
              ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('تم تعديل المنتج بنجاح!')));
            },
            child: const Text('حفظ التعديلات'),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final filteredProducts = rezolaProducts.where((prod) {
      final name = prod['name'].toLowerCase();
      final query = _searchQuery.toLowerCase();
      return name.contains(query);
    }).toList();

    return Scaffold(
      appBar: AppBar(
        title: const NeonGlowText(text: 'MANAGE PRODUCTS', fontSize: 18, isCompact: true),
        backgroundColor: primaryBurgundy,
        foregroundColor: Colors.white,
      ),
      body: Padding(
        padding: const EdgeInsets.all(12.0),
        child: Column(
          children: [
            TextField(
              onChanged: (val) => setState(() => _searchQuery = val),
              decoration: InputDecoration(
                hintText: 'ابحث عن منتج...',
                prefixIcon: const Icon(Icons.search, color: primaryBurgundy),
                border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
                filled: true,
                fillColor: Colors.white,
              ),
            ),
            const SizedBox(height: 12),
            Expanded(
              child: ListView.builder(
                itemCount: filteredProducts.length,
                itemBuilder: (context, index) {
                  final prod = filteredProducts[index];
                  final originalIndex = rezolaProducts.indexOf(prod);

                  return Card(
                    elevation: 2,
                    margin: const EdgeInsets.only(bottom: 12),
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                    child: ListTile(
                      leading: ClipRRect(
                        borderRadius: BorderRadius.circular(8),
                        child: Image.network(prod['image'], width: 50, height: 50, fit: BoxFit.cover, errorBuilder: (c, e, s) => const Icon(Icons.shopping_bag)),
                      ),
                      title: Text(prod['name'], style: const TextStyle(fontWeight: FontWeight.bold)),
                      subtitle: Text('${prod['price']}'),
                      trailing: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          IconButton(
                            icon: const Icon(Icons.edit, color: primaryBurgundy),
                            onPressed: () => _editProductDialog(originalIndex),
                          ),
                          IconButton(
                            icon: const Icon(Icons.delete, color: Colors.red),
                            onPressed: () {
                              setState(() {
                                rezolaProducts.removeAt(originalIndex);
                              });
                              ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('تم حذف المنتج')));
                            },
                          ),
                        ],
                      ),
                    ),
                  );
                },
              ),
            ),
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton(
        backgroundColor: primaryBurgundy,
        onPressed: _addNewProductDialog,
        child: const Icon(Icons.add, color: Colors.white),
      ),
    );
  }
}

class AdminOrdersScreen extends StatefulWidget {
  const AdminOrdersScreen({Key? key}) : super(key: key);

  @override
  State<AdminOrdersScreen> createState() => _AdminOrdersScreenState();
}

class _AdminOrdersScreenState extends State<AdminOrdersScreen> {
  final List statuses = ['قيد المراجعة ⏳', 'جاري التجهيز 📦', 'تم الشحن 🚀', 'تم التسليم ✔️'];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const NeonGlowText(text: 'CUSTOMER ORDERS', fontSize: 18, isCompact: true),
        backgroundColor: primaryBurgundy,
        foregroundColor: Colors.white,
      ),
      body: storeOrders.isEmpty
          ? const Center(child: Text('لا توجد طلبات جديدة حتى الآن', style: TextStyle(fontSize: 16, color: Colors.grey)))
          : Padding(
        padding: const EdgeInsets.all(12.0),
        child: ListView.builder(
          itemCount: storeOrders.length,
          itemBuilder: (context, index) {
            final order = storeOrders[index];
            return Card(
              elevation: 2,
              margin: const EdgeInsets.only(bottom: 12),
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
              child: Padding(
                padding: const EdgeInsets.all(16.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text('طلب #${index + 1}', style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 16)),
                        Container(
                          padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                          decoration: BoxDecoration(color: primaryBurgundy.withOpacity(0.1), borderRadius: BorderRadius.circular(8)),
                          child: Text(order['status'], style: const TextStyle(color: primaryBurgundy, fontWeight: FontWeight.bold, fontSize: 13)),
                        ),
                      ],
                    ),
                    const Divider(height: 20),
                    Text('العميل: ${order['user']}', style: const TextStyle(fontSize: 13, color: Colors.grey)),
                    const SizedBox(height: 4),
                    Text('المنتج: ${order['name']}', style: const TextStyle(fontSize: 15, fontWeight: FontWeight.w600)),
                    const SizedBox(height: 4),
                    Text('السعر: ${order['price']}', style: const TextStyle(color: Colors.grey)),
                    const SizedBox(height: 12),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.end,
                      children: [
                        const Text('تعديل الحالة: ', style: TextStyle(fontSize: 13, color: Colors.black54)),
                        const SizedBox(width: 8),
                        DropdownButton(
                          value: order['status'],
                          items: statuses.map((status) {
                            return DropdownMenuItem(value: status, child: Text(status, style: const TextStyle(fontSize: 13)));
                          }).toList(),
                          onChanged: (newStatus) {
                            setState(() {
                              storeOrders[index]['status'] = newStatus;
                            });
                          },
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            );
          },
        ),
      ),
    );
  }
}

Widget buildCartIconWithBadge(BuildContext context, VoidCallback onPressed) {
  return Stack(
    alignment: Alignment.center,
    children: [
      IconButton(
        icon: const Icon(Icons.shopping_cart, color: Colors.white70),
        onPressed: onPressed,
      ),
      if (cartItems.isNotEmpty)
        Positioned(
          right: 6,
          top: 6,
          child: Container(
            padding: const EdgeInsets.all(4),
            decoration: const BoxDecoration(color: primaryBurgundy, shape: BoxShape.circle),
            constraints: const BoxConstraints(minWidth: 18, minHeight: 18),
            child: Text(
              '${cartItems.length}',
              style: const TextStyle(color: Colors.white, fontSize: 10, fontWeight: FontWeight.bold),
              textAlign: TextAlign.center,
            ),
          ),
        ),
    ],
  );
}

// تصميم تأثير خط النيون المتحرك
class NeonGlowText extends StatefulWidget {
  final String text;
  final double fontSize;
  final bool isCompact;

  const NeonGlowText({
    Key? key,
    required this.text,
    this.fontSize = 20,
    this.isCompact = false,
  }) : super(key: key);

  @override
  State<NeonGlowText> createState() => _NeonGlowTextState();
}

class _NeonGlowTextState extends State<NeonGlowText> with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _animation;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      duration: const Duration(milliseconds: 1000),
      vsync: this,
    )..repeat(reverse: true);

    _animation = Tween<double>(begin: 2.0, end: widget.isCompact ? 8.0 : 18.0).animate(
      CurvedAnimation(parent: _controller, curve: Curves.easeInOut),
    );
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: _animation,
      builder: (context, child) {
        return Container(
          padding: widget.isCompact
              ? const EdgeInsets.symmetric(vertical: 4, horizontal: 8)
              : const EdgeInsets.symmetric(vertical: 16, horizontal: 20),
          decoration: widget.isCompact
              ? BoxDecoration(
            color: Colors.transparent,
            borderRadius: BorderRadius.circular(8),
          )
              : BoxDecoration(
            color: primaryBurgundy,
            borderRadius: BorderRadius.circular(16),
            border: Border.all(
              color: backgroundCream.withOpacity(0.8),
              width: 1.5,
            ),
            boxShadow: [
              BoxShadow(
                color: primaryBurgundy.withOpacity(0.6),
                blurRadius: _animation.value,
                spreadRadius: 1,
              ),
            ],
          ),
          child: Text(
            widget.text,
            textAlign: TextAlign.center,
            style: TextStyle(
              fontSize: widget.fontSize,
              fontWeight: FontWeight.w900,
              letterSpacing: 2.5,
              color: Colors.white,
              shadows: [
                Shadow(
                  blurRadius: _animation.value,
                  color: const Color(0xFFFFF3B0),
                  offset: const Offset(0, 0),
                ),
                Shadow(
                  blurRadius: _animation.value * 1.8,
                  color: const Color(0xFFFFD166),
                  offset: const Offset(0, 0),
                ),
                if (!widget.isCompact)
                  Shadow(
                    blurRadius: _animation.value * 2.5,
                    color: backgroundCream,
                    offset: const Offset(0, 0),
                  ),
              ],
            ),
          ),
        );
      },
    );
  }
}

// ودجت خاص لحركة الماوس (Hover Animation) على مربعات القائمة الرئيسية
class HoverCard extends StatefulWidget {
  final Map<String, dynamic> item;
  final VoidCallback onTap;

  const HoverCard({Key? key, required this.item, required this.onTap}) : super(key: key);

  @override
  State<HoverCard> createState() => _HoverCardState();
}

class _HoverCardState extends State<HoverCard> {
  bool isHovered = false;

  @override
  Widget build(BuildContext context) {
    return MouseRegion(
      onEnter: (_) => setState(() => isHovered = true),
      onExit: (_) => setState(() => isHovered = false),
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 200),
        curve: Curves.easeInOut,
        transform: Matrix4.identity()..translate(0.0, isHovered ? -6.0 : 0.0),
        child: Card(
          elevation: isHovered ? 8 : 2,
          shadowColor: primaryBurgundy.withOpacity(0.4),
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
          color: Colors.white,
          child: InkWell(
            borderRadius: BorderRadius.circular(16),
            onTap: widget.onTap,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                AnimatedContainer(
                  duration: const Duration(milliseconds: 200),
                  padding: const EdgeInsets.all(12),
                  decoration: BoxDecoration(
                    color: isHovered ? primaryBurgundy.withOpacity(0.1) : Colors.transparent,
                    shape: BoxShape.circle,
                  ),
                  child: Icon(
                    widget.item['icon'],
                    size: isHovered ? 40 : 36,
                    color: primaryBurgundy,
                  ),
                ),
                const SizedBox(height: 8),
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 8.0),
                  child: Text(
                    widget.item['title'],
                    style: TextStyle(
                      fontSize: 14,
                      fontWeight: FontWeight.bold,
                      color: isHovered ? primaryBurgundy : Colors.black87,
                    ),
                    textAlign: TextAlign.center,
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class HomeScreen extends StatefulWidget {
  final bool isAdmin;
  const HomeScreen({Key? key, this.isAdmin = false}) : super(key: key);

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  final List sections = [
    {'title': 'منصة نمط حياة رقمية', 'icon': Icons.dashboard, 'desc': 'النظرة الشاملة وإدارة نمط الحياة اليومي.'},
    {'title': 'خدمات الصحة واللياقة', 'icon': Icons.fitness_center, 'desc': 'برامج التمارين الرياضية ومتابعة الحيوية والصحة.'},
    {'title': 'خدمات التغذية الذكية', 'icon': Icons.restaurant, 'desc': 'خطط الغذاء الصحي، السعرات، والوجبات الذكية.'},
    {'title': 'الجمال والعناية الشخصية', 'icon': Icons.face, 'desc': 'نصائح وروتين العناية بالبشرة والمظهر الشخصي.'},
    {'title': 'الخدمات الترفيهية', 'icon': Icons.sports_esports, 'desc': 'أنشطة ترفيهية وألعاب لتحسين المزاج والطاقة.'},
    {'title': 'خدمات التسوق الإلكتروني', 'icon': Icons.shopping_bag, 'desc': 'متجر منتجات نمط الحياة الصحي (Lifestyle Store).'},
    {'title': 'المحتوى الرقمي المتخصص', 'icon': Icons.article, 'desc': 'مقالات، فيديوهات، ومدونات توعوية.'},
    {'title': 'مقارنة المنتجات والخدمات', 'icon': Icons.compare_arrows, 'desc': 'أدوات ذكية للمقارنة واختيار الأفضل.'},
    {'title': 'الحجز والتواصل المباشر', 'icon': Icons.calendar_today, 'desc': 'حجز المواعيد مع الخبراء والمختصين.'},
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const NeonGlowText(text: 'REZOLA', fontSize: 22, isCompact: true),
        centerTitle: true,
        backgroundColor: primaryBurgundy,
        foregroundColor: Colors.white,
        elevation: 6,
        actions: [
          IconButton(
            icon: const Icon(Icons.person, color: Colors.white70),
            tooltip: 'الملف الشخصي وطلباتي',
            onPressed: () async {
              await Navigator.push(context, MaterialPageRoute(builder: (context) => const UserProfileScreen()));
              setState(() {});
            },
          ),
          buildCartIconWithBadge(context, () async {
            await Navigator.push(context, MaterialPageRoute(builder: (context) => const CartScreen()));
            setState(() {});
          }),
          if (!widget.isAdmin)
            IconButton(
              icon: const Icon(Icons.logout, color: Colors.white70),
              onPressed: () {
                Navigator.pushReplacement(context, MaterialPageRoute(builder: (context) => const AuthScreen()));
              },
            ),
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.all(12.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            const SizedBox(height: 6),
            const Center(child: NeonGlowText(text: 'REZOLA LIFESTYLE', fontSize: 20)),
            const SizedBox(height: 16),
            Expanded(
              child: GridView.builder(
                itemCount: sections.length,
                gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: 2,
                  crossAxisSpacing: 12,
                  mainAxisSpacing: 12,
                  childAspectRatio: 1.1,
                ),
                itemBuilder: (context, index) {
                  final item = sections[index];
                  return HoverCard(
                    item: item,
                    onTap: () {
                      if (item['title'] == 'منصة نمط حياة رقمية') {
                        Navigator.push(context, MaterialPageRoute(builder: (context) => const DigitalLifestyleDashboardScreen()));
                      } else if (item['title'] == 'خدمات الصحة واللياقة') {
                        Navigator.push(context, MaterialPageRoute(builder: (context) => const BmiCalculatorScreen()));
                      } else if (item['title'] == 'خدمات التغذية الذكية') {
                        Navigator.push(context, MaterialPageRoute(builder: (context) => const CalorieCalculatorScreen()));
                      } else if (item['title'] == 'الجمال والعناية الشخصية') {
                        Navigator.push(context, MaterialPageRoute(builder: (context) => const BeautyCareScreen()));
                      } else if (item['title'] == 'الخدمات الترفيهية') {
                        Navigator.push(context, MaterialPageRoute(builder: (context) => const EntertainmentScreen()));
                      } else if (item['title'] == 'خدمات التسوق الإلكتروني') {
                        Navigator.push(context, MaterialPageRoute(builder: (context) => const RezolaShopScreen()));
                      } else if (item['title'] == 'المحتوى الرقمي المتخصص') {
                        Navigator.push(context, MaterialPageRoute(builder: (context) => const DigitalContentScreen()));
                      } else if (item['title'] == 'مقارنة المنتجات والخدمات') {
                        Navigator.push(context, MaterialPageRoute(builder: (context) => const CompareScreen()));
                      } else if (item['title'] == 'الحجز والتواصل المباشر') {
                        Navigator.push(context, MaterialPageRoute(builder: (context) => const BookingScreen()));
                      }
                    },
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}

// ==========================================
// الشاشات والأقسام الإضافية
// ==========================================

class DigitalLifestyleDashboardScreen extends StatelessWidget {
  const DigitalLifestyleDashboardScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('منصة نمط حياة رقمية', style: TextStyle(color: Colors.white)), backgroundColor: primaryBurgundy, foregroundColor: Colors.white),
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          const Text('نظرة عامة على يومك', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: primaryBurgundy)),
          const SizedBox(height: 12),
          _buildInfoCard('الترطيب اليومي', '6 / 8 أكواب مياه مستهلكة', Icons.water_drop, Colors.blue),
          _buildInfoCard('النشاط البدني', '4,500 خطوة من أصل 10,000 خطوة', Icons.directions_walk, primaryBurgundy),
          _buildInfoCard('جودة النوم', '7.5 ساعات نوم متواصل (ممتاز)', Icons.bedtime, Colors.purple),
          _buildInfoCard('حالة المزاج والطاقة', 'مستوى طاقة مرتفع (نشط)', Icons.bolt, Colors.orange),
        ],
      ),
    );
  }

  Widget _buildInfoCard(String title, String subtitle, IconData icon, Color color) {
    return Card(
      elevation: 2,
      color: Colors.white,
      margin: const EdgeInsets.only(bottom: 12),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      child: ListTile(
        leading: CircleAvatar(backgroundColor: color.withOpacity(0.15), child: Icon(icon, color: color)),
        title: Text(title, style: const TextStyle(fontWeight: FontWeight.bold, color: Colors.black87)),
        subtitle: Text(subtitle, style: const TextStyle(color: Colors.grey)),
      ),
    );
  }
}

class BeautyCareScreen extends StatelessWidget {
  const BeautyCareScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final List tips = [
      {'title': 'روتين العناية بالبشرة الصباحي', 'desc': 'تنظيف لطيف، ترطيب عميق، وحماية من الشمس (SPF).'},
      {'title': 'العناية بالشعر التالف', 'desc': 'استخدام زيوت طبيعية مرتين أسبوعياً وقص الأطراف بانتظام.'},
      {'title': 'ترطيب الجسم المستمر', 'desc': 'شرب الماء بانتظام واستخدام زبدة الكاكاو أو المرطبات الطبيعية.'},
    ];

    return Scaffold(
      appBar: AppBar(title: const Text('الجمال والعناية الشخصية', style: TextStyle(color: Colors.white)), backgroundColor: primaryBurgundy, foregroundColor: Colors.white),
      body: ListView.builder(
        padding: const EdgeInsets.all(16),
        itemCount: tips.length,
        itemBuilder: (context, index) {
          final t = tips[index];
          return Card(
            elevation: 2,
            color: Colors.white,
            margin: const EdgeInsets.only(bottom: 12),
            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
            child: ListTile(
              leading: const Icon(Icons.face_retouching_natural, color: primaryBurgundy, size: 36),
              title: Text(t['title'], style: const TextStyle(fontWeight: FontWeight.bold, color: Colors.black87)),
              subtitle: Text(t['desc'], style: const TextStyle(color: Colors.grey)),
            ),
          );
        },
      ),
    );
  }
}

class EntertainmentScreen extends StatefulWidget {
  const EntertainmentScreen({Key? key}) : super(key: key);

  @override
  State<EntertainmentScreen> createState() => _EntertainmentScreenState();
}

class _EntertainmentScreenState extends State<EntertainmentScreen> {
  String joke = 'اضغط على الزر أدناه للحصول على جرعة طاقة ومرح!';

  void _generateJoke() {
    final jokes = [
      'لماذا تقف سجادة اليوغا ثابتة؟ لأنها تمتلك مبادئ راسخة! 😄',
      'الاسترخاء هو الفن الذي يجعلك تبتسم بدون سبب.',
      'اجعل يومك مليئاً بالحيوية ولا تقلق من الصغائر.',
    ];
    setState(() {
      joke = (jokes..shuffle()).first;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('الخدمات الترفيهية', style: TextStyle(color: Colors.white)), backgroundColor: primaryBurgundy, foregroundColor: Colors.white),
      body: Padding(
        padding: const EdgeInsets.all(24.0),
        child: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const Icon(Icons.sports_esports, size: 80, color: primaryBurgundy),
              const SizedBox(height: 20),
              const Text('ركن تحسين المزاج والطاقة', style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold, color: primaryBurgundy)),
              const SizedBox(height: 20),
              Container(
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(color: Colors.white, borderRadius: BorderRadius.circular(12), boxShadow: const [BoxShadow(color: Colors.black12, blurRadius: 4)]),
                child: Text(joke, style: const TextStyle(fontSize: 16, color: Colors.black87), textAlign: TextAlign.center),
              ),
              const SizedBox(height: 30),
              ElevatedButton.icon(
                style: ElevatedButton.styleFrom(backgroundColor: primaryBurgundy, foregroundColor: Colors.white, padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12)),
                onPressed: _generateJoke,
                icon: const Icon(Icons.lightbulb),
                label: const Text('جرعة طاقة ومزاج إيجابي', style: TextStyle(fontSize: 15, fontWeight: FontWeight.bold)),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class DigitalContentScreen extends StatelessWidget {
  const DigitalContentScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final List articles = [
      {'title': 'أهمية النوم المبكر في تحسين التركيز', 'read': 'قراءة 5 دقائق'},
      {'title': 'دليلك الشامل لتعلم التأمل في المنزل', 'read': 'قراءة 4 دقائق'},
      {'title': 'كيف تبدأ روتين حياة صحي بدون تعقيد', 'read': 'قراءة 7 دقائق'},
    ];

    return Scaffold(
      appBar: AppBar(title: const Text('المحتوى الرقمي المتخصص', style: TextStyle(color: Colors.white)), backgroundColor: primaryBurgundy, foregroundColor: Colors.white),
      body: ListView.builder(
        padding: const EdgeInsets.all(16),
        itemCount: articles.length,
        itemBuilder: (context, index) {
          final art = articles[index];
          return Card(
            elevation: 2,
            color: Colors.white,
            margin: const EdgeInsets.only(bottom: 12),
            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
            child: ListTile(
              leading: const Icon(Icons.article, color: primaryBurgundy),
              title: Text(art['title'], style: const TextStyle(fontWeight: FontWeight.bold, color: Colors.black87)),
              subtitle: Text(art['read'], style: const TextStyle(color: Colors.grey)),
              trailing: const Icon(Icons.arrow_forward_ios, size: 16, color: Colors.grey),
              onTap: () {
                ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('جاري فتح المقال للقراءة...')));
              },
            ),
          );
        },
      ),
    );
  }
}

class CompareScreen extends StatelessWidget {
  const CompareScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('مقارنة المنتجات والخدمات', style: TextStyle(color: Colors.white)), backgroundColor: primaryBurgundy, foregroundColor: Colors.white),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text('مقارنة سريعة بين زجاجات المياه الذكية', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: primaryBurgundy)),
            const SizedBox(height: 16),
            Expanded(
              child: ListView(
                children: [
                  _buildCompareRow('الاسم', 'زجاجة ريزولا الذكية', 'الزجاجة العادية'),
                  _buildCompareRow('تتبع الترطيب', 'تتصل بالهاتف عبر البلوتوث', 'لا توجد خاصية'),
                  _buildCompareRow('تنبيهات الشرب', 'إضاءة واهتزاز تلقائي', 'لا توجد'),
                  _buildCompareRow('السعر', '650 ج.م', '150 ج.م'),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildCompareRow(String feature, String item1, String item2) {
    return Card(
      color: Colors.white,
      margin: const EdgeInsets.only(bottom: 10),
      child: Padding(
        padding: const EdgeInsets.all(12.0),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Expanded(flex: 2, child: Text(feature, style: const TextStyle(fontWeight: FontWeight.bold, color: primaryBurgundy))),
            Expanded(flex: 3, child: Text(item1, textAlign: TextAlign.center, style: const TextStyle(color: Colors.black87))),
            Expanded(flex: 3, child: Text(item2, textAlign: TextAlign.center, style: const TextStyle(color: Colors.grey))),
          ],
        ),
      ),
    );
  }
}

class BookingScreen extends StatefulWidget {
  const BookingScreen({Key? key}) : super(key: key);

  @override
  State<BookingScreen> createState() => _BookingScreenState();
}

class _BookingScreenState extends State<BookingScreen> {
  final _nameController = TextEditingController();
  String selectedExpert = 'د. أحمد (خبير التغذية الرياضية)';

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('الحجز والتواصل المباشر', style: TextStyle(color: Colors.white)), backgroundColor: primaryBurgundy, foregroundColor: Colors.white),
      body: Padding(
        padding: const EdgeInsets.all(20.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            const Icon(Icons.calendar_month, size: 60, color: primaryBurgundy),
            const SizedBox(height: 16),
            const Text('احجز استشارتك مع نخبة الخبراء', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: primaryBurgundy), textAlign: TextAlign.center),
            const SizedBox(height: 24),
            TextField(
              controller: _nameController,
              decoration: InputDecoration(labelText: 'اسمك الكريم', border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)), filled: true, fillColor: Colors.white),
            ),
            const SizedBox(height: 16),
            DropdownButtonFormField<String>(
              value: selectedExpert,
              decoration: InputDecoration(labelText: 'اختر الخبير', border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)), filled: true, fillColor: Colors.white),
              items: [
                'د. أحمد (خبير التغذية الرياضية)',
                'كابتن سارة (مدربة اللياقة البدنية)',
                'د. مريم (خبيرة العناية بالبشرة والمظهر)'
              ].map((exp) => DropdownMenuItem(value: exp, child: Text(exp))).toList(),
              onChanged: (val) => setState(() => selectedExpert = val!),
            ),
            const SizedBox(height: 24),
            SizedBox(
              height: 50,
              child: ElevatedButton(
                style: ElevatedButton.styleFrom(backgroundColor: primaryBurgundy, foregroundColor: Colors.white),
                onPressed: () {
                  if (_nameController.text.isNotEmpty) {
                    showDialog(
                      context: context,
                      builder: (context) => AlertDialog(
                        title: const Text('تم الحجز بنجاح!', style: TextStyle(color: primaryBurgundy)),
                        content: Text('شكراً لك ${_nameController.text}. تم حجز استشارتك مع ($selectedExpert) وسيتم التواصل معك قريباً.'),
                        actions: [TextButton(onPressed: () { Navigator.pop(context); Navigator.pop(context); }, child: const Text('موافق', style: TextStyle(color: primaryBurgundy)))],
                      ),
                    );
                  }
                },
                child: const Text('تأكيد الحجز', style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class UserProfileScreen extends StatefulWidget {
  const UserProfileScreen({Key? key}) : super(key: key);

  @override
  State<UserProfileScreen> createState() => _UserProfileScreenState();
}

class _UserProfileScreenState extends State<UserProfileScreen> {
  final _phoneController = TextEditingController(text: currentUserPhone);
  final _addressController = TextEditingController(text: currentUserAddress);
  bool isEditing = false;

  void _saveProfile() {
    setState(() {
      currentUserPhone = _phoneController.text.trim();
      currentUserAddress = _addressController.text.trim();
      isEditing = false;
    });
    for (var u in registeredUsers) {
      if (u['email'] == currentUserEmail) {
        u['phone'] = currentUserPhone;
        u['address'] = currentUserAddress;
      }
    }
    ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('تم حفظ تعديلات الملف الشخصي بنجاح!')));
  }

  @override
  Widget build(BuildContext context) {
    final myOrders = storeOrders.where((order) => order['user'] == currentUserEmail).toList();

    return Scaffold(
      appBar: AppBar(title: const NeonGlowText(text: 'MY PROFILE', fontSize: 18, isCompact: true), backgroundColor: primaryBurgundy, foregroundColor: Colors.white),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Card(
              elevation: 3,
              color: Colors.white,
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
              child: Padding(
                padding: const EdgeInsets.all(20.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        const CircleAvatar(radius: 28, backgroundColor: primaryBurgundy, child: Icon(Icons.person, size: 32, color: Colors.white)),
                        const SizedBox(width: 16),
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              const Text('البريد الإلكتروني', style: TextStyle(fontSize: 12, color: Colors.grey)),
                              const SizedBox(height: 2),
                              Text(currentUserEmail.isNotEmpty ? currentUserEmail : 'غير مسجل', style: const TextStyle(fontSize: 15, fontWeight: FontWeight.bold, color: Colors.black87)),
                            ],
                          ),
                        ),
                        IconButton(
                          icon: Icon(isEditing ? Icons.check : Icons.edit, color: primaryBurgundy),
                          onPressed: () {
                            if (isEditing) {
                              _saveProfile();
                            } else {
                              setState(() => isEditing = true);
                            }
                          },
                        ),
                      ],
                    ),
                    const Divider(height: 24),
                    isEditing
                        ? Column(
                      children: [
                        TextField(controller: _phoneController, decoration: const InputDecoration(labelText: 'رقم الهاتف', prefixIcon: Icon(Icons.phone, color: primaryBurgundy))),
                        const SizedBox(height: 12),
                        TextField(controller: _addressController, decoration: const InputDecoration(labelText: 'عنوان الشحن', prefixIcon: Icon(Icons.location_on, color: primaryBurgundy))),
                      ],
                    )
                        : Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(children: [const Icon(Icons.phone, size: 16, color: Colors.grey), const SizedBox(width: 8), Text('رقم الهاتف: $currentUserPhone', style: const TextStyle(fontSize: 14))]),
                        const SizedBox(height: 8),
                        Row(children: [const Icon(Icons.location_on, size: 16, color: Colors.grey), const SizedBox(width: 8), Text('العنوان: $currentUserAddress', style: const TextStyle(fontSize: 14))]),
                      ],
                    ),
                  ],
                ),
              ),
            ),
            const SizedBox(height: 24),
            const Text('📦 سجل طلباتي وحالة الشحن', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: primaryBurgundy)),
            const SizedBox(height: 12),
            Expanded(
              child: myOrders.isEmpty
                  ? const Center(child: Text('لا توجد طلبات سابقة حتى الآن.', textAlign: TextAlign.center, style: TextStyle(fontSize: 15, color: Colors.grey)))
                  : ListView.builder(
                itemCount: myOrders.length,
                itemBuilder: (context, index) {
                  final order = myOrders[index];
                  return Card(
                    elevation: 2,
                    color: Colors.white,
                    margin: const EdgeInsets.only(bottom: 12),
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                    child: Padding(
                      padding: const EdgeInsets.all(16.0),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Text('طلب رقم #${index + 1}', style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 16)),
                              Container(
                                padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                                decoration: BoxDecoration(color: primaryBurgundy.withOpacity(0.1), borderRadius: BorderRadius.circular(8)),
                                child: Text(order['status'], style: const TextStyle(color: primaryBurgundy, fontWeight: FontWeight.bold, fontSize: 13)),
                              ),
                            ],
                          ),
                          const Divider(height: 20),
                          Text('المنتج: ${order['name']}', style: const TextStyle(fontSize: 15, fontWeight: FontWeight.w600)),
                          const SizedBox(height: 4),
                          Text('السعر: ${order['price']}', style: const TextStyle(color: Colors.grey)),
                        ],
                      ),
                    ),
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class RezolaShopScreen extends StatefulWidget {
  const RezolaShopScreen({Key? key}) : super(key: key);

  @override
  State<RezolaShopScreen> createState() => _RezolaShopScreenState();
}

class _RezolaShopScreenState extends State<RezolaShopScreen> {
  String _searchQuery = '';

  @override
  Widget build(BuildContext context) {
    final filteredProducts = rezolaProducts.where((prod) {
      final name = prod['name'].toLowerCase();
      final query = _searchQuery.toLowerCase();
      return name.contains(query);
    }).toList();

    return Scaffold(
      appBar: AppBar(title: const NeonGlowText(text: 'REZOLA SHOP', fontSize: 18, isCompact: true), backgroundColor: primaryBurgundy, foregroundColor: Colors.white),
      body: Padding(
        padding: const EdgeInsets.all(12.0),
        child: Column(
          children: [
            TextField(
              onChanged: (value) => setState(() => _searchQuery = value),
              decoration: InputDecoration(hintText: 'ابحث عن منتجات الصحة واللياقة...', prefixIcon: const Icon(Icons.search, color: primaryBurgundy), border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)), filled: true, fillColor: Colors.white),
            ),
            const SizedBox(height: 12),
            Expanded(
              child: ListView.builder(
                itemCount: filteredProducts.length,
                itemBuilder: (context, index) {
                  final prod = filteredProducts[index];
                  return Card(
                    elevation: 2,
                    color: Colors.white,
                    margin: const EdgeInsets.only(bottom: 12),
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                    child: ListTile(
                      contentPadding: const EdgeInsets.all(12),
                      leading: ClipRRect(borderRadius: BorderRadius.circular(8), child: Image.network(prod['image'], width: 60, height: 60, fit: BoxFit.cover)),
                      title: Text(prod['name'], style: const TextStyle(fontWeight: FontWeight.bold)),
                      subtitle: Text('${prod['desc']}\n${prod['price']}', style: const TextStyle(color: Colors.grey)),
                      isThreeLine: true,
                      trailing: ElevatedButton(
                        style: ElevatedButton.styleFrom(backgroundColor: primaryBurgundy, foregroundColor: Colors.white),
                        onPressed: () {
                          setState(() {
                            cartItems.add({'name': prod['name'], 'price': prod['price']});
                          });
                          ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('تمت إضافة ${prod['name']} للسلة!'), duration: const Duration(milliseconds: 800)));
                        },
                        child: const Text('شراء'),
                      ),
                    ),
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class CartScreen extends StatefulWidget {
  const CartScreen({Key? key}) : super(key: key);

  @override
  State<CartScreen> createState() => _CartScreenState();
}

class _CartScreenState extends State<CartScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const NeonGlowText(text: 'CART', fontSize: 18, isCompact: true), backgroundColor: primaryBurgundy, foregroundColor: Colors.white),
      body: cartItems.isEmpty
          ? const Center(child: Text('السلة فارغة حالياً', style: TextStyle(fontSize: 18, color: Colors.grey)))
          : Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            Expanded(
              child: ListView.builder(
                itemCount: cartItems.length,
                itemBuilder: (context, index) {
                  final item = cartItems[index];
                  return Card(
                    color: Colors.white,
                    child: ListTile(
                      title: Text(item['name']),
                      subtitle: Text(item['price'], style: const TextStyle(color: primaryBurgundy)),
                      trailing: IconButton(icon: const Icon(Icons.delete, color: Colors.red), onPressed: () => setState(() => cartItems.removeAt(index))),
                    ),
                  );
                },
              ),
            ),
            SizedBox(
              width: double.infinity,
              height: 50,
              child: ElevatedButton(
                style: ElevatedButton.styleFrom(backgroundColor: primaryBurgundy, foregroundColor: Colors.white),
                onPressed: () {
                  for (var item in cartItems) {
                    storeOrders.add({'user': currentUserEmail, 'name': item['name'], 'price': item['price'], 'status': 'قيد المراجعة ⏳'});
                  }
                  cartItems.clear();
                  showDialog(
                    context: context,
                    builder: (context) => AlertDialog(
                      title: const Text('تأكيد الطلب', style: TextStyle(color: primaryBurgundy)),
                      content: const Text('تم إرسال طلبك بنجاح! يمكنك متابعته من ملفك الشخصي.'),
                      actions: [TextButton(onPressed: () { Navigator.pop(context); Navigator.pop(context); }, child: const Text('موافق', style: TextStyle(color: primaryBurgundy)))],
                    ),
                  );
                },
                child: const Text('إتمام الشراء', style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class BmiCalculatorScreen extends StatefulWidget {
  const BmiCalculatorScreen({Key? key}) : super(key: key);
  @override
  State<BmiCalculatorScreen> createState() => _BmiCalculatorScreenState();
}

class _BmiCalculatorScreenState extends State<BmiCalculatorScreen> {
  final _w = TextEditingController();
  final _h = TextEditingController();
  String _res = '';
  String _category = '';

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const NeonGlowText(text: 'BMI CALCULATOR', fontSize: 18, isCompact: true), backgroundColor: primaryBurgundy, foregroundColor: Colors.white),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(20.0),
        child: Card(
          elevation: 4,
          color: Colors.white,
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
          child: Padding(
            padding: const EdgeInsets.all(20.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                const Icon(Icons.fitness_center, size: 50, color: primaryBurgundy),
                const SizedBox(height: 16),
                const Text('أدخل بياناتك البدنية لحساب مؤشر كتلة الجسم', style: TextStyle(fontSize: 15, fontWeight: FontWeight.bold), textAlign: TextAlign.center),
                const SizedBox(height: 24),
                TextField(controller: _w, keyboardType: TextInputType.number, decoration: InputDecoration(labelText: 'الوزن (كجم)', border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)), filled: true, fillColor: Colors.grey[50])),
                const SizedBox(height: 16),
                TextField(controller: _h, keyboardType: TextInputType.number, decoration: InputDecoration(labelText: 'الطول (سم)', border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)), filled: true, fillColor: Colors.grey[50])),
                const SizedBox(height: 24),
                SizedBox(
                  height: 50,
                  child: ElevatedButton(
                    style: ElevatedButton.styleFrom(backgroundColor: primaryBurgundy, foregroundColor: Colors.white),
                    onPressed: () {
                      double? w = double.tryParse(_w.text);
                      double? h = double.tryParse(_h.text);
                      if (w != null && h != null && h > 0) {
                        double bmi = w / ((h / 100) * (h / 100));
                        String cat = bmi < 18.5 ? 'وزن منخفض' : (bmi < 25 ? 'وزن مثالي وطبيعي ممتاز! 🎉' : (bmi < 30 ? 'زيادة في الوزن' : 'سمنة مفرطة'));
                        setState(() { _res = 'النتيجة: ${bmi.toStringAsFixed(1)}'; _category = cat; });
                      }
                    },
                    child: const Text('حساب المؤشر', style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
                  ),
                ),
                if (_res.isNotEmpty) ...[
                  const SizedBox(height: 24),
                  Container(
                    padding: const EdgeInsets.all(16),
                    decoration: BoxDecoration(color: primaryBurgundy.withOpacity(0.1), borderRadius: BorderRadius.circular(12)),
                    child: Column(children: [Text(_res, style: const TextStyle(fontSize: 22, fontWeight: FontWeight.bold, color: primaryBurgundy)), const SizedBox(height: 6), Text(_category, style: const TextStyle(fontSize: 15, fontWeight: FontWeight.w600), textAlign: TextAlign.center)]),
                  ),
                ]
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class CalorieCalculatorScreen extends StatefulWidget {
  const CalorieCalculatorScreen({Key? key}) : super(key: key);
  @override
  State<CalorieCalculatorScreen> createState() => _CalorieCalculatorScreenState();
}

class _CalorieCalculatorScreenState extends State<CalorieCalculatorScreen> {
  final _w = TextEditingController();
  final _h = TextEditingController();
  final _a = TextEditingController();
  String _res = '';

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const NeonGlowText(text: 'CALORIE CALCULATOR', fontSize: 18, isCompact: true), backgroundColor: primaryBurgundy, foregroundColor: Colors.white),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(20.0),
        child: Card(
          elevation: 4,
          color: Colors.white,
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
          child: Padding(
            padding: const EdgeInsets.all(20.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                const Icon(Icons.restaurant_menu, size: 50, color: primaryBurgundy),
                const SizedBox(height: 16),
                const Text('احسب احتياج جسمك من السعرات اليومية', style: TextStyle(fontSize: 15, fontWeight: FontWeight.bold), textAlign: TextAlign.center),
                const SizedBox(height: 24),
                TextField(controller: _w, keyboardType: TextInputType.number, decoration: InputDecoration(labelText: 'الوزن (كجم)', border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)), filled: true, fillColor: Colors.grey[50])),
                const SizedBox(height: 16),
                TextField(controller: _h, keyboardType: TextInputType.number, decoration: InputDecoration(labelText: 'الطول (سم)', border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)), filled: true, fillColor: Colors.grey[50])),
                const SizedBox(height: 16),
                TextField(controller: _a, keyboardType: TextInputType.number, decoration: InputDecoration(labelText: 'العمر (بالسنوات)', border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)), filled: true, fillColor: Colors.grey[50])),
                const SizedBox(height: 24),
                SizedBox(
                  height: 50,
                  child: ElevatedButton(
                    style: ElevatedButton.styleFrom(backgroundColor: primaryBurgundy, foregroundColor: Colors.white),
                    onPressed: () {
                      double? w = double.tryParse(_w.text);
                      double? h = double.tryParse(_h.text);
                      int? a = int.tryParse(_a.text);
                      if (w != null && h != null && a != null) {
                        double cal = ((10 * w) + (6.25 * h) - (5 * a) + 5) * 1.375;
                        setState(() => _res = 'احتياجك اليومي: ${cal.toStringAsFixed(0)} سعرة حرارية');
                      }
                    },
                    child: const Text('حساب السعرات', style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
                  ),
                ),
                if (_res.isNotEmpty) ...[
                  const SizedBox(height: 24),
                  Container(
                    padding: const EdgeInsets.all(16),
                    decoration: BoxDecoration(color: primaryBurgundy.withOpacity(0.1), borderRadius: BorderRadius.circular(12)),
                    child: Text(_res, style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: primaryBurgundy), textAlign: TextAlign.center),
                  ),
                ]
              ],
            ),
          ),
        ),
      ),
    );
  }
}