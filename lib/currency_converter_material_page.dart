import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class CurrencyConverterPage extends StatefulWidget {
  const CurrencyConverterPage({super.key});

  @override
  State<CurrencyConverterPage> createState() => _CurrencyConverterPageState();
}

class _CurrencyConverterPageState extends State<CurrencyConverterPage> {
  // Currency conversion data
  final Map<String, double> exchangeRates = {
    'USD': 1.0,
    'EUR': 0.92,
    'GBP': 0.79,
    'JPY': 149.50,
    'INR': 83.20,
    'AUD': 1.52,
    'CAD': 1.35,
    'CNY': 7.16,
  };

  String fromCurrency = 'USD';
  String toCurrency = 'INR';
  double result = 0.0;
  bool isDarkMode = false;
  final TextEditingController textEditingController = TextEditingController();

  void convert() {
    if (textEditingController.text.isNotEmpty) {
      try {
        double input = double.parse(textEditingController.text);
        double baseAmount = input / exchangeRates[fromCurrency]!;
        setState(() {
          result = baseAmount * exchangeRates[toCurrency]!;
        });
      } catch (e) {
        _showError('Please enter a valid numeric value.');
      }
    } else {
      _showError('Input field cannot be empty.');
    }
  }

  void _showError(String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(
          message,
          style: const TextStyle(color: Colors.white),
        ),
        backgroundColor: Colors.red,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      drawer: _buildDrawer(),
      body: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
            colors: isDarkMode
              ? [
                  Colors.blueGrey[900]!, 
                  Colors.black87, 
                  Colors.black54
                ]
              : [
                  Colors.deepPurple[200]!, 
                  Colors.purpleAccent[100]!, 
                  Colors.blueAccent[100]!
                ],
          ),
        ),
        child: SafeArea(
          child: Column(
            children: [
              // App Bar with Drawer
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Builder(
                      builder: (context) => IconButton(
                        icon: Icon(Icons.menu, color: isDarkMode ? Colors.white : Colors.white),
                        onPressed: () => Scaffold.of(context).openDrawer(),
                      ),
                    ),
                    Text(
                      'Currency Converter',
                      style: TextStyle(
                        color: isDarkMode ? Colors.white : Colors.white,
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    IconButton(
                      icon: Icon(
                        isDarkMode ? Icons.light_mode : Icons.dark_mode,
                        color: isDarkMode ? Colors.white : Colors.white,
                      ),
                      onPressed: () {
                        setState(() {
                          isDarkMode = !isDarkMode;
                        });
                      },
                    ),
                  ],
                ),
              ),

              // Converter Content
              Expanded(
                child: SingleChildScrollView(
                  child: Padding(
                    padding: const EdgeInsets.all(20.0),
                    child: Container(
                      decoration: BoxDecoration(
                        color: Colors.white.withOpacity(0.2),
                        borderRadius: BorderRadius.circular(20),
                        border: Border.all(color: Colors.white.withOpacity(0.3)),
                      ),
                      padding: const EdgeInsets.all(20),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          // Converted Amount Display
                          Container(
                            padding: const EdgeInsets.all(20),
                            decoration: BoxDecoration(
                              color: Colors.white.withOpacity(0.3),
                              borderRadius: BorderRadius.circular(15),
                            ),
                            child: Column(
                              children: [
                                const Text(
                                  'Converted Amount',
                                  style: TextStyle(
                                    fontSize: 18,
                                    color: Colors.white,
                                  ),
                                ),
                                const SizedBox(height: 10),
                                Text(
                                  '${toCurrency} ${result.toStringAsFixed(2)}',
                                  style: const TextStyle(
                                    fontSize: 36,
                                    fontWeight: FontWeight.bold,
                                    color: Colors.white,
                                  ),
                                ),
                              ],
                            ),
                          ),
                          
                          const SizedBox(height: 30),
                          
                          // Currency Selection Dropdowns
                          Row(
                            children: [
                              Expanded(
                                child: _buildCurrencyDropdown(
                                  value: fromCurrency,
                                  onChanged: (String? newValue) {
                                    setState(() {
                                      fromCurrency = newValue!;
                                    });
                                  },
                                  label: 'From',
                                ),
                              ),
                              const SizedBox(width: 10),
                              IconButton(
                                icon: const Icon(Icons.swap_horiz, color: Colors.white),
                                onPressed: () {
                                  setState(() {
                                    String temp = fromCurrency;
                                    fromCurrency = toCurrency;
                                    toCurrency = temp;
                                  });
                                },
                              ),
                              const SizedBox(width: 10),
                              Expanded(
                                child: _buildCurrencyDropdown(
                                  value: toCurrency,
                                  onChanged: (String? newValue) {
                                    setState(() {
                                      toCurrency = newValue!;
                                    });
                                  },
                                  label: 'To',
                                ),
                              ),
                            ],
                          ),
                          
                          const SizedBox(height: 20),
                          
                          // Input Field
                          TextField(
                            controller: textEditingController,
                            decoration: InputDecoration(
                              hintText: 'Enter amount in $fromCurrency',
                              hintStyle: const TextStyle(color: Colors.white70),
                              prefixIcon: const Icon(
                                Icons.attach_money,
                                color: Colors.white,
                              ),
                              filled: true,
                              fillColor: Colors.white.withOpacity(0.2),
                              border: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(10),
                                borderSide: BorderSide.none,
                              ),
                            ),
                            style: const TextStyle(color: Colors.white),
                            keyboardType: const TextInputType.numberWithOptions(decimal: true),
                          ),
                          
                          const SizedBox(height: 30),
                          
                          // Convert Button
                          ElevatedButton(
                            onPressed: convert,
                            style: ElevatedButton.styleFrom(
                              backgroundColor: Colors.white.withOpacity(0.3),
                              padding: const EdgeInsets.symmetric(vertical: 15, horizontal: 40),
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(10),
                              ),
                            ),
                            child: const Text(
                              'Convert',
                              style: TextStyle(
                                fontSize: 18,
                                color: Colors.white,
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  // Drawer for additional navigation
  Widget _buildDrawer() {
    return Drawer(
      child: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
            colors: isDarkMode
              ? [
                  Colors.blueGrey[900]!, 
                  Colors.black87, 
                  Colors.black54
                ]
              : [
                  Colors.deepPurple[200]!, 
                  Colors.purpleAccent[100]!, 
                  Colors.blueAccent[100]!
                ],
          ),
        ),
        child: SafeArea(
          child: Column(
            children: [
              // Drawer Header
              DrawerHeader(
                decoration: BoxDecoration(
                  color: Colors.white.withOpacity(0.2),
                ),
                child: const Center(
                  child: Text(
                    'Currency Converter',
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 24,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
              ),
              
              // Drawer Items
              _buildDrawerItem(
                icon: Icons.calculate,
                title: 'Converter',
                onTap: () => Navigator.pop(context),
              ),
              _buildDrawerItem(
                icon: Icons.info,
                title: 'About App',
                onTap: () {
                  Navigator.pop(context);
                  _showAboutDialog();
                },
              ),
              _buildDrawerItem(
                icon: Icons.contact_mail,
                title: 'Contact Us',
                onTap: () {
                  Navigator.pop(context);
                  _showContactDialog();
                },
              ),
              _buildDrawerItem(
                icon: Icons.settings,
                title: 'Settings',
                onTap: () {
                  Navigator.pop(context);
                  _showSettingsDialog();
                },
              ),
            ],
          ),
        ),
      ),
    );
  }

  // Helper method for drawer items
  Widget _buildDrawerItem({
    required IconData icon,
    required String title,
    required VoidCallback onTap,
  }) {
    return ListTile(
      leading: Icon(icon, color: Colors.white),
      title: Text(
        title,
        style: const TextStyle(color: Colors.white),
      ),
      onTap: onTap,
    );
  }

  // Dialog methods
  void _showAboutDialog() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        backgroundColor: isDarkMode 
          ? Colors.blueGrey[900]?.withOpacity(0.9) 
          : Colors.white.withOpacity(0.9),
        title: Text(
          'About Currency Converter',
          style: TextStyle(color: isDarkMode ? Colors.white : Colors.black),
        ),
        content: Text(
          'A simple and elegant app to convert currencies quickly and easily. '
          'Developed with Flutter, providing real-time exchange rates.',
          style: TextStyle(color: isDarkMode ? Colors.white70 : Colors.black87),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: Text(
              'Close',
              style: TextStyle(color: isDarkMode ? Colors.white : Colors.black),
            ),
          ),
        ],
      ),
    );
  }

  void _showContactDialog() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        backgroundColor: isDarkMode 
          ? Colors.blueGrey[900]?.withOpacity(0.9) 
          : Colors.white.withOpacity(0.9),
        title: Text(
          'Contact Us',
          style: TextStyle(color: isDarkMode ? Colors.white : Colors.black),
        ),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(
              'Email: support@currencyconverter.com',
              style: TextStyle(color: isDarkMode ? Colors.white70 : Colors.black87),
            ),
            const SizedBox(height: 10),
            Text(
              'Phone: +1 (555) 123-4567',
              style: TextStyle(color: isDarkMode ? Colors.white70 : Colors.black87),
            ),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: Text(
              'Close',
              style: TextStyle(color: isDarkMode ? Colors.white : Colors.black),
            ),
          ),
        ],
      ),
    );
  }

  void _showSettingsDialog() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        backgroundColor: isDarkMode 
          ? Colors.blueGrey[900]?.withOpacity(0.9) 
          : Colors.white.withOpacity(0.9),
        title: Text(
          'Settings',
          style: TextStyle(color: isDarkMode ? Colors.white : Colors.black),
        ),
        content: StatefulBuilder(
          builder: (context, setState) => Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              SwitchListTile(
                title: Text(
                  'Dark Mode',
                  style: TextStyle(color: isDarkMode ? Colors.white : Colors.black),
                ),
                value: isDarkMode,
                onChanged: (bool value) {
                  // Update the state in both the dialog and the main app
                  this.setState(() {
                    isDarkMode = value;
                  });
                  Navigator.pop(context);
                },
              ),
            ],
          ),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: Text(
              'Close',
              style: TextStyle(color: isDarkMode ? Colors.white : Colors.black),
            ),
          ),
        ],
      ),
    );
  }

  // Helper method to create currency dropdowns
  Widget _buildCurrencyDropdown({
    required String value,
    required void Function(String?)? onChanged,
    required String label,
  }) {
    return DropdownButtonFormField<String>(
      value: value,
      dropdownColor: isDarkMode ? Colors.blueGrey[900] : Colors.purpleAccent[100],
      decoration: InputDecoration(
        labelText: label,
        labelStyle: TextStyle(color: isDarkMode ? Colors.white : Colors.white),
        filled: true,
        fillColor: Colors.white.withOpacity(0.2),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(10),
          borderSide: BorderSide.none,
        ),
      ),
      style: TextStyle(color: isDarkMode ? Colors.white : Colors.black),
      items: exchangeRates.keys
          .map<DropdownMenuItem<String>>((String currency) => 
              DropdownMenuItem<String>(
                value: currency,
                child: Text(
                  currency, 
                  style: TextStyle(color: isDarkMode ? Colors.white : Colors.black),
                ),
              ))
          .toList(),
      onChanged: onChanged,
    );
  }
  }