import 'dart:math';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';

import '../../../../core/constants/app_colors.dart';
import '../../../../core/utils/currency_formatter.dart';
import '../../../../core/widgets/custom_button.dart';
import '../../../../core/widgets/custom_text_field.dart';
import '../../../orders/domain/entities/order_entity.dart';
import '../../../orders/presentation/bloc/order_bloc.dart';
import '../../../orders/presentation/bloc/order_event.dart';
import '../../domain/entities/cart_entity.dart';
import '../bloc/cart_bloc.dart';
import '../bloc/cart_event.dart';

class CheckoutPage extends StatefulWidget {
  final CartEntity cart;

  const CheckoutPage({super.key, required this.cart});

  @override
  State<CheckoutPage> createState() => _CheckoutPageState();
}

class _CheckoutPageState extends State<CheckoutPage> {
  final _formKey = GlobalKey<FormState>();

  final _nameController = TextEditingController(text: 'Emily Johnson');
  final _streetController = TextEditingController(text: '742 Evergreen Terrace');
  final _cityController = TextEditingController(text: 'Springfield');
  final _postalController = TextEditingController(text: '97477');
  final _phoneController = TextEditingController(text: '+1 (555) 019-2834');

  String _paymentMethod = 'Credit / Debit Card';
  bool _isProcessing = false;

  @override
  void dispose() {
    _nameController.dispose();
    _streetController.dispose();
    _cityController.dispose();
    _postalController.dispose();
    _phoneController.dispose();
    super.dispose();
  }

  void _onPlaceOrder() async {
    if (!_formKey.currentState!.validate()) return;

    setState(() => _isProcessing = true);

    // Simulate order submission network delay
    await Future.delayed(const Duration(milliseconds: 1200));

    final randomId = 'ORD-${10000 + Random().nextInt(90000)}';
    final shippingAddress = '${_streetController.text.trim()}, ${_cityController.text.trim()}, ${_postalController.text.trim()}';

    final order = OrderEntity(
      id: randomId,
      createdAt: DateTime.now(),
      status: 'Confirmed',
      items: widget.cart.items,
      subtotal: widget.cart.subtotal,
      tax: widget.cart.estimatedTax,
      shippingFee: widget.cart.totalShippingFee,
      total: widget.cart.grandTotal,
      vendorCount: widget.cart.vendorGroups.length,
      shippingAddress: shippingAddress,
      paymentMethod: _paymentMethod,
    );

    if (mounted) {
      context.read<OrderBloc>().add(PlaceOrderEvent(order));
      context.read<CartBloc>().add(const ClearCartEvent());

      setState(() => _isProcessing = false);
      context.go('/order-success', extra: order);
    }
  }

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final cart = widget.cart;

    return Scaffold(
      appBar: AppBar(
        title: const Text('Checkout & Payment'),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Form(
          key: _formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // 1. Shipping Address Section
              Text(
                'Shipping Address',
                style: Theme.of(context).textTheme.titleMedium?.copyWith(fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 12),
              CustomTextField(
                controller: _nameController,
                labelText: 'Recipient Name',
                prefixIcon: const Icon(Icons.person_outline),
                validator: (val) => val == null || val.isEmpty ? 'Please enter recipient name' : null,
              ),
              const SizedBox(height: 10),
              CustomTextField(
                controller: _streetController,
                labelText: 'Street Address',
                prefixIcon: const Icon(Icons.home_outlined),
                validator: (val) => val == null || val.isEmpty ? 'Please enter street address' : null,
              ),
              const SizedBox(height: 10),
              Row(
                children: [
                  Expanded(
                    flex: 6,
                    child: CustomTextField(
                      controller: _cityController,
                      labelText: 'City',
                      prefixIcon: const Icon(Icons.location_city_outlined),
                      validator: (val) => val == null || val.isEmpty ? 'Required' : null,
                    ),
                  ),
                  const SizedBox(width: 10),
                  Expanded(
                    flex: 4,
                    child: CustomTextField(
                      controller: _postalController,
                      labelText: 'Postal Code',
                      validator: (val) => val == null || val.isEmpty ? 'Required' : null,
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 10),
              CustomTextField(
                controller: _phoneController,
                labelText: 'Phone Number',
                prefixIcon: const Icon(Icons.phone_outlined),
                keyboardType: TextInputType.phone,
                validator: (val) => val == null || val.isEmpty ? 'Please enter phone number' : null,
              ),
              const SizedBox(height: 24),

              // 2. Payment Method
              Text(
                'Payment Method',
                style: Theme.of(context).textTheme.titleMedium?.copyWith(fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 12),
              _buildPaymentOption('Credit / Debit Card', Icons.credit_card_rounded, isDark),
              const SizedBox(height: 10),
              _buildPaymentOption('Apple Pay / Google Pay', Icons.account_balance_wallet_outlined, isDark),
              const SizedBox(height: 10),
              _buildPaymentOption('Cash on Delivery (COD)', Icons.payments_outlined, isDark),
              const SizedBox(height: 24),

              // 3. Multi-Vendor Summary Box
              Text(
                'Multi-Vendor Order Summary',
                style: Theme.of(context).textTheme.titleMedium?.copyWith(fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 12),
              Container(
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  color: Theme.of(context).cardTheme.color,
                  borderRadius: BorderRadius.circular(16),
                  border: Border.all(
                    color: Theme.of(context).colorScheme.outline.withOpacity(0.6),
                  ),
                ),
                child: Column(
                  children: [
                    ...cart.vendorGroups.map((group) {
                      return Padding(
                        padding: const EdgeInsets.symmetric(vertical: 4),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text(
                              '${group.vendor.name} (${group.itemCount} items)',
                              style: const TextStyle(fontSize: 13, fontWeight: FontWeight.w600),
                            ),
                            Text(
                              CurrencyFormatter.format(group.subtotal),
                              style: const TextStyle(fontSize: 13, fontWeight: FontWeight.bold),
                            ),
                          ],
                        ),
                      );
                    }),
                    const Divider(height: 16),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text('Taxes & Multi-Store Shipping', style: TextStyle(color: isDark ? AppColors.textDarkMuted : AppColors.textLightMuted, fontSize: 12)),
                        Text(
                          CurrencyFormatter.format(cart.estimatedTax + cart.totalShippingFee),
                          style: const TextStyle(fontSize: 12, fontWeight: FontWeight.w600),
                        ),
                      ],
                    ),
                    const SizedBox(height: 6),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        const Text('Total Amount', style: TextStyle(fontSize: 15, fontWeight: FontWeight.bold)),
                        Text(
                          CurrencyFormatter.format(cart.grandTotal),
                          style: TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.w800,
                            color: isDark ? AppColors.primaryNeon : AppColors.primary,
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 30),

              // 4. Place Order Action
              CustomButton(
                text: 'Pay & Confirm Order (${CurrencyFormatter.format(cart.grandTotal)})',
                icon: Icons.check_circle_outline_rounded,
                isLoading: _isProcessing,
                onPressed: _onPlaceOrder,
              ),
              const SizedBox(height: 20),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildPaymentOption(String title, IconData icon, bool isDark) {
    final isSelected = _paymentMethod == title;

    return InkWell(
      onTap: () => setState(() => _paymentMethod = title),
      borderRadius: BorderRadius.circular(14),
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
        decoration: BoxDecoration(
          color: Theme.of(context).cardTheme.color,
          borderRadius: BorderRadius.circular(14),
          border: Border.all(
            color: isSelected
                ? (isDark ? AppColors.primaryNeon : AppColors.primary)
                : Theme.of(context).colorScheme.outline.withOpacity(0.5),
            width: isSelected ? 1.8 : 1,
          ),
        ),
        child: Row(
          children: [
            Icon(
              icon,
              color: isSelected ? (isDark ? AppColors.primaryNeon : AppColors.primary) : null,
              size: 22,
            ),
            const SizedBox(width: 12),
            Expanded(
              child: Text(
                title,
                style: TextStyle(
                  fontSize: 14,
                  fontWeight: isSelected ? FontWeight.bold : FontWeight.w500,
                ),
              ),
            ),
            Radio<String>(
              value: title,
              groupValue: _paymentMethod,
              activeColor: isDark ? AppColors.primaryNeon : AppColors.primary,
              onChanged: (val) {
                if (val != null) setState(() => _paymentMethod = val);
              },
            ),
          ],
        ),
      ),
    );
  }
}
