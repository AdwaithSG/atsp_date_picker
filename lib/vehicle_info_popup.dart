import 'package:flutter/material.dart';

class VehicleInfoPopup extends StatefulWidget {
  final bool isFourWheeler;
  final Map<String, dynamic> initialVehicleInfo;
  final Function(bool, Map<String, dynamic>) onSave;

  const VehicleInfoPopup({
    super.key,
    required this.isFourWheeler,
    required this.onSave,
    this.initialVehicleInfo = const {},
  });

  @override
  State<VehicleInfoPopup> createState() => _VehicleInfoPopupState();
}

class _VehicleInfoPopupState extends State<VehicleInfoPopup> with SingleTickerProviderStateMixin {
  late bool _isFourWheeler;
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  late TextEditingController _vehicleNumberController;
  late TextEditingController _modelController;
  late TextEditingController _brandController;
  late TextEditingController _colorController;
  late AnimationController _animationController;
  late Animation<double> _scaleAnimation;
  String _selectedFuelType = '';
  String _selectedVehicleType = '';

  // Lists for dropdown options
  final List<String> _fourWheelerTypes = ['Sedan', 'SUV', 'Hatchback', 'MUV', 'Compact SUV'];
  final List<String> _twoWheelerTypes = ['Scooter', 'Sports Bike', 'Cruiser', 'Street Bike', 'Commuter'];
  final List<String> _fuelTypes = ['Petrol', 'Diesel', 'Electric', 'CNG', 'Hybrid'];
  final List<Color> _colorOptions = [
    Colors.red,
    Colors.blue,
    Colors.black,
    Colors.white,
    Colors.grey,
    Colors.green,
    Colors.yellow,
  ];
  final List<String> _colorNames = [
    'Red',
    'Blue',
    'Black',
    'White',
    'Grey',
    'Green',
    'Yellow',
  ];

  @override
  void initState() {
    super.initState();
    _isFourWheeler = widget.isFourWheeler;
    
    // Initialize controllers with existing data if available
    _vehicleNumberController = TextEditingController(
      text: widget.initialVehicleInfo['vehicleNumber'] ?? '',
    );
    _modelController = TextEditingController(
      text: widget.initialVehicleInfo['model'] ?? '',
    );
    _brandController = TextEditingController(
      text: widget.initialVehicleInfo['brand'] ?? '',
    );
    _colorController = TextEditingController(
      text: widget.initialVehicleInfo['color'] ?? '',
    );
    
    // Initialize dropdowns
    _selectedFuelType = widget.initialVehicleInfo['fuelType'] ?? _fuelTypes[0];
    _selectedVehicleType = widget.initialVehicleInfo['vehicleType'] ?? 
                         (_isFourWheeler ? _fourWheelerTypes[0] : _twoWheelerTypes[0]);
    
    // Setup animations
    _animationController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 300),
    );
    
    _scaleAnimation = CurvedAnimation(
      parent: _animationController,
      curve: Curves.easeOutBack,
    );
    
    // Start animation
    _animationController.forward();
  }

  @override
  void dispose() {
    _vehicleNumberController.dispose();
    _modelController.dispose();
    _brandController.dispose();
    _colorController.dispose();
    _animationController.dispose();
    super.dispose();
  }

  void _saveVehicleInfo() {
    if (_formKey.currentState!.validate()) {
      // Create the vehicle info map to return
      Map<String, dynamic> vehicleInfo = {
        'vehicleNumber': _vehicleNumberController.text,
        'model': _modelController.text,
        'brand': _brandController.text,
        'color': _colorController.text,
        'fuelType': _selectedFuelType,
        'vehicleType': _selectedVehicleType,
      };
      
      // Call the onSave callback with updated info
      widget.onSave(_isFourWheeler, vehicleInfo);
      Navigator.pop(context);
    }
  }

  @override
  Widget build(BuildContext context) {
    return ScaleTransition(
      scale: _scaleAnimation,
      child: Dialog(
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(24),
        ),
        elevation: 0,
        backgroundColor: Colors.transparent,
        child: Container(
          padding: const EdgeInsets.all(24),
          width: double.infinity,
          constraints: BoxConstraints(
            maxWidth: MediaQuery.of(context).size.width * 0.85,
            maxHeight: MediaQuery.of(context).size.height * 0.85,
          ),
          decoration: BoxDecoration(
            gradient: LinearGradient(
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
              colors: [
                Colors.white,
                Colors.grey.shade50,
              ],
            ),
            borderRadius: BorderRadius.circular(24),
            boxShadow: [
              BoxShadow(
                color: Colors.deepPurple.withOpacity(0.1),
                blurRadius: 24,
                spreadRadius: 0,
              ),
            ],
          ),
          child: SingleChildScrollView(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                _buildHeader(),
                const SizedBox(height: 16),
                _buildVehicleTypeToggle(),
                const SizedBox(height: 24),
                _buildVehicleForm(),
                const SizedBox(height: 24),
                _buildSaveButton(),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildHeader() {
    return Row(
      children: [
        Container(
          padding: const EdgeInsets.all(12),
          decoration: BoxDecoration(
            color: Colors.deepPurple.withOpacity(0.1),
            borderRadius: BorderRadius.circular(16),
          ),
          child: Icon(
            _isFourWheeler ? Icons.directions_car : Icons.two_wheeler,
            color: Colors.deepPurple,
            size: 26,
          ),
        ),
        const SizedBox(width: 12),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text(
                'Vehicle Details',
                style: TextStyle(
                  fontSize: 22,
                  fontWeight: FontWeight.bold,
                  color: Colors.deepPurple,
                ),
              ),
              Text(
                'Enter your ${_isFourWheeler ? '4 wheeler' : '2 wheeler'} information',
                style: const TextStyle(
                  fontSize: 14,
                  color: Colors.grey,
                ),
              ),
            ],
          ),
        ),
        GestureDetector(
          onTap: () => Navigator.pop(context),
          child: Container(
            padding: const EdgeInsets.all(8),
            decoration: BoxDecoration(
              color: Colors.grey.shade100,
              borderRadius: BorderRadius.circular(12),
            ),
            child: const Icon(
              Icons.close,
              color: Colors.grey,
              size: 20,
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildVehicleTypeToggle() {
    return Container(
      decoration: BoxDecoration(
        color: Colors.deepPurple.withOpacity(0.05),
        borderRadius: BorderRadius.circular(16),
      ),
      padding: const EdgeInsets.all(8),
      child: Row(
        children: [
          Expanded(
            child: GestureDetector(
              onTap: () {
                setState(() {
                  _isFourWheeler = false;
                  // Update vehicle type when switching
                  _selectedVehicleType = _twoWheelerTypes[0];
                });
              },
              child: AnimatedContainer(
                duration: const Duration(milliseconds: 200),
                padding: const EdgeInsets.symmetric(vertical: 12),
                decoration: BoxDecoration(
                  color: !_isFourWheeler ? Colors.deepPurple : Colors.transparent,
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Icon(
                      Icons.two_wheeler,
                      color: !_isFourWheeler ? Colors.white : Colors.grey,
                      size: 20,
                    ),
                    const SizedBox(width: 8),
                    Text(
                      'Two Wheeler',
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                        color: !_isFourWheeler ? Colors.white : Colors.grey,
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
          Expanded(
            child: GestureDetector(
              onTap: () {
                setState(() {
                  _isFourWheeler = true;
                  // Update vehicle type when switching
                  _selectedVehicleType = _fourWheelerTypes[0];
                });
              },
              child: AnimatedContainer(
                duration: const Duration(milliseconds: 200),
                padding: const EdgeInsets.symmetric(vertical: 12),
                decoration: BoxDecoration(
                  color: _isFourWheeler ? Colors.deepPurple : Colors.transparent,
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Icon(
                      Icons.directions_car,
                      color: _isFourWheeler ? Colors.white : Colors.grey,
                      size: 20,
                    ),
                    const SizedBox(width: 8),
                    Text(
                      'Four Wheeler',
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                        color: _isFourWheeler ? Colors.white : Colors.grey,
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

  Widget _buildVehicleForm() {
    return Form(
      key: _formKey,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Vehicle Type Dropdown
          _buildSectionTitle('Vehicle Type'),
          _buildDropdown(
            value: _selectedVehicleType,
            items: _isFourWheeler ? _fourWheelerTypes : _twoWheelerTypes,
            onChanged: (value) {
              if (value != null) {
                setState(() {
                  _selectedVehicleType = value;
                });
              }
            },
          ),
          
          const SizedBox(height: 16),
          
          // Brand and Model (side by side)
          Row(
            children: [
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    _buildSectionTitle('Brand'),
                    _buildTextField(
                      controller: _brandController,
                      hintText: 'e.g. Honda, Toyota',
                      prefixIcon: Icons.branding_watermark,
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return 'Required';
                        }
                        return null;
                      },
                    ),
                  ],
                ),
              ),
              const SizedBox(width: 16),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    _buildSectionTitle('Model'),
                    _buildTextField(
                      controller: _modelController,
                      hintText: 'e.g. Civic, Innova',
                      prefixIcon: Icons.model_training,
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return 'Required';
                        }
                        return null;
                      },
                    ),
                  ],
                ),
              ),
            ],
          ),
          
          const SizedBox(height: 16),
          
          // Vehicle Number
          _buildSectionTitle('Registration Number'),
          _buildTextField(
            controller: _vehicleNumberController,
            hintText: 'e.g. KA 01 AB 1234',
            prefixIcon: Icons.pin,
            textCapitalization: TextCapitalization.characters,
            validator: (value) {
              if (value == null || value.isEmpty) {
                return 'Registration number is required';
              }
              // Add more validation if needed
              return null;
            },
          ),
          
          const SizedBox(height: 16),
          
          // Fuel Type
          _buildSectionTitle('Fuel Type'),
          _buildDropdown(
            value: _selectedFuelType,
            items: _fuelTypes,
            onChanged: (value) {
              if (value != null) {
                setState(() {
                  _selectedFuelType = value;
                });
              }
            },
          ),
          
          const SizedBox(height: 16),
          
          // Color Selection
          _buildSectionTitle('Vehicle Color'),
          _buildColorPicker(),
        ],
      ),
    );
  }

  Widget _buildSectionTitle(String title) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 8),
      child: Text(
        title,
        style: const TextStyle(
          fontSize: 14,
          fontWeight: FontWeight.w600,
          color: Colors.deepPurple,
        ),
      ),
    );
  }

  Widget _buildTextField({
    required TextEditingController controller,
    required String hintText,
    required IconData prefixIcon,
    required String? Function(String?) validator,
    TextCapitalization textCapitalization = TextCapitalization.sentences,
  }) {
    return TextFormField(
      controller: controller,
      textCapitalization: textCapitalization,
      decoration: InputDecoration(
        hintText: hintText,
        hintStyle: TextStyle(color: Colors.grey.shade400, fontSize: 14),
        prefixIcon: Icon(prefixIcon, color: Colors.deepPurple, size: 20),
        fillColor: Colors.grey.shade50,
        filled: true,
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: BorderSide.none,
        ),
        contentPadding: const EdgeInsets.symmetric(vertical: 16),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: BorderSide(color: Colors.grey.shade200),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: const BorderSide(color: Colors.deepPurple, width: 1.5),
        ),
        errorBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: const BorderSide(color: Colors.redAccent, width: 1.5),
        ),
        focusedErrorBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: const BorderSide(color: Colors.redAccent, width: 1.5),
        ),
        errorStyle: const TextStyle(color: Colors.redAccent),
      ),
      validator: validator,
    );
  }

  Widget _buildDropdown({
    required String value,
    required List<String> items,
    required Function(String?) onChanged,
  }) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.grey.shade50,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: Colors.grey.shade200),
      ),
      padding: const EdgeInsets.symmetric(horizontal: 16),
      child: DropdownButtonHideUnderline(
        child: DropdownButton<String>(
          value: value.isEmpty ? items[0] : value,
          isExpanded: true,
          hint: const Text('Select'),
          icon: const Icon(Icons.arrow_drop_down, color: Colors.deepPurple),
          style: const TextStyle(
            color: Colors.black87,
            fontSize: 16,
          ),
          dropdownColor: Colors.white,
          borderRadius: BorderRadius.circular(12),
          items: items.map((String item) {
            return DropdownMenuItem<String>(
              value: item,
              child: Text(item),
            );
          }).toList(),
          onChanged: onChanged,
        ),
      ),
    );
  }

  Widget _buildColorPicker() {
    return Container(
      height: 65,
      decoration: BoxDecoration(
        color: Colors.grey.shade50,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: Colors.grey.shade200),
      ),
      padding: const EdgeInsets.symmetric(vertical: 8, horizontal: 8),
      child: Row(
        children: [
          // Color input field
          Expanded(
            child: TextFormField(
              controller: _colorController,
              decoration: InputDecoration(
                hintText: 'Select or type color',
                hintStyle: TextStyle(color: Colors.grey.shade400, fontSize: 14),
                prefixIcon: const Icon(Icons.color_lens, color: Colors.deepPurple, size: 20),
                border: InputBorder.none,
              ),
              validator: (value) {
                if (value == null || value.isEmpty) {
                  return 'Color is required';
                }
                return null;
              },
            ),
          ),
          
          // Color options
          SizedBox(
            height: 50,
            width: 160,
            child: ListView.builder(
              scrollDirection: Axis.horizontal,
              itemCount: _colorOptions.length,
              itemBuilder: (context, index) {
                return GestureDetector(
                  onTap: () {
                    setState(() {
                      _colorController.text = _colorNames[index];
                    });
                  },
                  child: Container(
                    width: 36,
                    height: 36,
                    margin: const EdgeInsets.symmetric(horizontal: 4),
                    decoration: BoxDecoration(
                      color: _colorOptions[index],
                      shape: BoxShape.circle,
                      border: Border.all(
                        color: Colors.grey.shade300,
                        width: 2,
                      ),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.black.withOpacity(0.1),
                          blurRadius: 4,
                          offset: const Offset(0, 2),
                        ),
                      ],
                    ),
                    child: _colorController.text == _colorNames[index]
                        ? const Icon(
                            Icons.check,
                            color: Colors.white,
                            size: 20,
                          )
                        : null,
                  ),
                );
              },
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildSaveButton() {
    return Container(
      width: double.infinity,
      height: 56,
      decoration: BoxDecoration(
        gradient: const LinearGradient(
          colors: [Colors.deepPurple, Colors.purple],
          begin: Alignment.centerLeft,
          end: Alignment.centerRight,
        ),
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: Colors.deepPurple.withOpacity(0.3),
            blurRadius: 10,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          onTap: _saveVehicleInfo,
          borderRadius: BorderRadius.circular(16),
          splashColor: Colors.white.withOpacity(0.2),
          child: const Center(
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(
                  Icons.check_circle_outline,
                  color: Colors.white,
                  size: 22,
                ),
                SizedBox(width: 8),
                Text(
                  'SAVE VEHICLE',
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                    letterSpacing: 1,
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