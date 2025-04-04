import 'package:flutter/material.dart';

class PaymentPage extends StatefulWidget {
  final String patientName;

  const PaymentPage({Key? key, required this.patientName}) : super(key: key);

  @override
  _PaymentPageState createState() => _PaymentPageState();
}

class _PaymentPageState extends State<PaymentPage> {
  int _selectedPaymentMethod = 1;
  bool _saveCardDetails = false;
  final _formKey = GlobalKey<FormState>();

  final TextEditingController _cardNumberController = TextEditingController();
  final TextEditingController _expiryDateController = TextEditingController();
  final TextEditingController _cvvController = TextEditingController();
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _paypalWalletController = TextEditingController();

  void _handlePayment() {
    if (_formKey.currentState!.validate()) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text("Payment Successful for ${widget.patientName}!"),
          backgroundColor: Colors.green,
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Payment for ${widget.patientName}'),
        backgroundColor: Colors.black87,
        centerTitle: true,
        leading: IconButton(
          icon: Icon(Icons.arrow_back, color: Colors.white),
          onPressed: () => Navigator.of(context).pop(),
        ),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Form(
          key: _formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              _buildPaymentDetailsHeader(),
              const SizedBox(height: 20),
              _buildPaymentMethodSelector(),
              const SizedBox(height: 20),
              if (_selectedPaymentMethod == 1) ..._buildCardPaymentFields(),
              if (_selectedPaymentMethod == 2) ..._buildGooglePayFields(),
              if (_selectedPaymentMethod == 3) ..._buildPayPalFields(),
              if (_selectedPaymentMethod == 1) _buildSaveCardCheckbox(),
              const SizedBox(height: 20),
              _buildPayButton(),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildPaymentDetailsHeader() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Payment Details',
          style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
        ),
        const Divider(),
      ],
    );
  }

  Widget _buildPaymentMethodSelector() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Select Payment Method:',
          style: TextStyle(fontWeight: FontWeight.bold),
        ),
        const SizedBox(height: 10),
        ToggleButtons(
          isSelected: [
            _selectedPaymentMethod == 1,
            _selectedPaymentMethod == 2,
            _selectedPaymentMethod == 3,
          ],
          borderRadius: BorderRadius.circular(10),
          selectedColor: Colors.white,
          fillColor: Colors.blueAccent,
          borderColor: Colors.grey,
          selectedBorderColor: Colors.blue,
          onPressed: (index) {
            setState(() {
              _selectedPaymentMethod = index + 1;
            });
          },
          children: const [
            Row(
          mainAxisAlignment: MainAxisAlignment.center, // Center-align the children
          children: [
            Text('💳 card'),
            SizedBox(width: 10), // Add spacing between icon and text
          ],
        ),
        Row(
          mainAxisAlignment: MainAxisAlignment.center, // Center-align the children
          children: [
            Text('🟢 Google Pay'),
            SizedBox(width: 10), // Add spacing between icon and text

          ],
        ),
        Row(
          mainAxisAlignment: MainAxisAlignment.center, // Center-align the children
          children: [
            Text('💳 PayPal'),
            SizedBox(width: 10), // Add spacing between icon and text

          ],
        ),
          ],
        ),
      ],
    );
  }

  List<Widget> _buildCardPaymentFields() {
    return [
      _buildTextField(
        controller: _cardNumberController,
        label: 'Card Number',
        prefixIcon: Icons.credit_card,
        keyboardType: TextInputType.number,
        validator: (value) => value!.isEmpty ? 'Please enter your card number' : null,
      ),
      const SizedBox(height: 10),
      Row(
        children: [
          Expanded(
            child: _buildTextField(
              controller: _expiryDateController,
              label: 'Expiration Date',
              keyboardType: TextInputType.datetime,
              validator: (value) => value!.isEmpty ? 'Enter expiry date' : null,
            ),
          ),
          const SizedBox(width: 10),
          Expanded(
            child: _buildTextField(
              controller: _cvvController,
              label: 'CVV',
              keyboardType: TextInputType.number,
              validator: (value) => value!.isEmpty ? 'Enter CVV' : null,
            ),
          ),
        ],
      ),
    ];
  }

  List<Widget> _buildGooglePayFields() {
    return [
      _buildTextField(
        controller: _emailController,
        label: 'Email',
        keyboardType: TextInputType.emailAddress,
        validator: (value) => value!.isEmpty ? 'Please enter your email' : null,
      ),
      const SizedBox(height: 10),
      _buildTextField(
        controller: _cardNumberController,
        label: 'Card Number',
        prefixIcon: Icons.credit_card,
        keyboardType: TextInputType.number,
        validator: (value) => value!.isEmpty ? 'Please enter your card number' : null,
      ),
      const SizedBox(height: 10),
      _buildTextField(
        controller: _nameController,
        label: 'Name',
        keyboardType: TextInputType.text,
        validator: (value) => value!.isEmpty ? 'Please enter your name' : null,
      ),
    ];
  }

  List<Widget> _buildPayPalFields() {
    return [
      _buildTextField(
        controller: _paypalWalletController,
        label: 'PayPal Wallet',
        keyboardType: TextInputType.text,
        validator: (value) => value!.isEmpty ? 'Please enter your PayPal wallet' : null,
      ),
      const SizedBox(height: 10),
      _buildTextField(
        controller: _nameController,
        label: 'Name',
        keyboardType: TextInputType.text,
        validator: (value) => value!.isEmpty ? 'Please enter your name' : null,
      ),
    ];
  }

  Widget _buildSaveCardCheckbox() {
    return Row(
      children: [
        Checkbox(
          value: _saveCardDetails,
          onChanged: (value) {
            setState(() {
              _saveCardDetails = value!;
            });
          },
        ),
        Text('Save card details'),
      ],
    );
  }

  Widget _buildPayButton() {
    return SizedBox(
      width: double.infinity,
      child: ElevatedButton(
        onPressed: _handlePayment,
        style: ElevatedButton.styleFrom(
          backgroundColor: Colors.green,
          foregroundColor: Colors.white,
          padding: const EdgeInsets.symmetric(vertical: 14),
          textStyle: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(10),
          ),
        ),
        child: const Text('Pay Now'),
      ),
    );
  }

  Widget _buildTextField({
    required TextEditingController controller,
    required String label,
    TextInputType? keyboardType,
    IconData? prefixIcon,
    String? Function(String?)? validator,
  }) {
    return TextFormField(
      controller: controller,
      decoration: InputDecoration(
        labelText: label,
        border: const OutlineInputBorder(),
        prefixIcon: prefixIcon != null ? Icon(prefixIcon) : null,
      ),
      keyboardType: keyboardType,
      validator: validator,
    );
  }
}