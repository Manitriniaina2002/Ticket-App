import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../models/event.dart';
import '../models/ticket_type.dart';
import '../providers/event_provider.dart';
import '../widgets/qr_code_generator.dart';

class TicketSaleScreen extends StatefulWidget {
  final Event event;

  const TicketSaleScreen({super.key, required this.event});

  @override
  State<TicketSaleScreen> createState() => _TicketSaleScreenState();
}

class _TicketSaleScreenState extends State<TicketSaleScreen> {
  final _formKey = GlobalKey<FormState>();
  TicketType? _selectedTicketType;
  int _quantity = 1;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Sell Tickets - ${widget.event.name}'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Form(
          key: _formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              // Ticket Type Dropdown
              DropdownButtonFormField<TicketType>(
                decoration: const InputDecoration(
                  labelText: 'Ticket Type',
                  border: OutlineInputBorder(),
                ),
                value: _selectedTicketType,
                items: widget.event.ticketTypes.map((type) {
                  return DropdownMenuItem<TicketType>(
                    value: type as TicketType,
                    child: Text('${type['name']} - \$${type['price'].toStringAsFixed(2)}'),
                  );
                }).toList(),
                onChanged: (TicketType? newValue) {
                  setState(() {
                    _selectedTicketType = newValue;
                    _quantity = 1;
                  });
                },
                validator: (value) {
                  if (value == null) {
                    return 'Please select a ticket type';
                  }
                  if (value.availableQuantity == 0) {
                    return 'This ticket type is sold out';
                  }
                  return null;
                },
              ),
              const SizedBox(height: 16),
              // Quantity Selector
              Row(
                children: [
                  Expanded(
                    child: TextFormField(
                      decoration: const InputDecoration(
                        labelText: 'Quantity',
                        border: OutlineInputBorder(),
                      ),
                      initialValue: '1',
                      keyboardType: TextInputType.number,
                      onChanged: (value) {
                        setState(() {
                          _quantity = int.tryParse(value) ?? 1;
                        });
                      },
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return 'Please enter a quantity';
                        }
                        final quantity = int.tryParse(value) ?? 0;
                        if (quantity <= 0) {
                          return 'Quantity must be greater than 0';
                        }
                        if (_selectedTicketType != null &&
                            quantity > _selectedTicketType!.availableQuantity) {
                          return 'Not enough tickets available';
                        }
                        return null;
                      },
                    ),
                  ),
                  const SizedBox(width: 16),
                  ElevatedButton.icon(
                    onPressed: () {
                      if (_selectedTicketType != null) {
                        setState(() {
                          _quantity = _selectedTicketType!.availableQuantity;
                        });
                      }
                    },
                    icon: const Icon(Icons.all_inclusive),
                    label: const Text('Max'),
                  ),
                ],
              ),
              const SizedBox(height: 16),
              // Total Price
              Card(
                child: Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      const Text(
                        'Total:',
                        style: TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: 18,
                        ),
                      ),
                      Text(
                        '\$${(_selectedTicketType?.price ?? 0) * _quantity}',
                        style: const TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: 18,
                          color: Colors.green,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
              const Spacer(),
              // Sell Button
              ElevatedButton(
                onPressed: () {
                  if (_formKey.currentState!.validate()) {
                    if (_selectedTicketType != null) {
                      context.read<EventProvider>().sellTicket(
                            widget.event.id,
                            _selectedTicketType!.id,
                            _quantity,
                          );
                      ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(
                          content: Text(
                            'Successfully sold $_quantity ${_selectedTicketType!.name} ticket(s)',
                          ),
                        ),
                      );
                      Navigator.pop(context);
                    }
                  }
                },
                style: ElevatedButton.styleFrom(
                  padding: const EdgeInsets.symmetric(vertical: 16),
                ),
                child: const Text(
                  'Sell Tickets',
                  style: TextStyle(fontSize: 18),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
