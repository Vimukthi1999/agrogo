import 'dart:io';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../controllers/createad_controller.dart';

class CreateadView extends GetView<CreateadController> {
  const CreateadView({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Create Ad'.tr),
        centerTitle: true,
        backgroundColor: const Color(0xFF1E7044),
        elevation: 0,
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(20),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Title Field
              _buildSectionTitle('Ad Title'.tr),
              const SizedBox(height: 10),
              Obx(
                () => _buildTextField(
                  controller: controller.titleController,
                  hintText: 'Enter ad title (e.g., Fresh Tomatoes)'.tr,
                  errorText: controller.titleError.value,
                  onChanged: (value) {
                    if (value.isNotEmpty) controller.titleError.value = '';
                  },
                ),
              ),
              const SizedBox(height: 20),

              // Description Field
              _buildSectionTitle('Description'.tr),
              const SizedBox(height: 10),
              Obx(
                () => _buildTextField(
                  controller: controller.descriptionController,
                  hintText: 'Describe your product in detail'.tr,
                  errorText: controller.descriptionError.value,
                  maxLines: 4,
                  onChanged: (value) {
                    if (value.isNotEmpty) controller.descriptionError.value = '';
                  },
                ),
              ),
              const SizedBox(height: 20),

              // Quantity and Price Row
              Row(
                children: [
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        _buildSectionTitle('Quantity (kg)'.tr),
                        const SizedBox(height: 10),
                        Obx(
                          () => _buildTextField(
                            controller: controller.quantityController,
                            hintText: '0',
                            errorText: controller.quantityError.value,
                            keyboardType: TextInputType.number,
                            onChanged: (value) {
                              if (value.isNotEmpty)
                                controller.quantityError.value = '';
                            },
                          ),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(width: 16),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        _buildSectionTitle('Price per kg (₹)'.tr),
                        const SizedBox(height: 10),
                        Obx(
                          () => _buildTextField(
                            controller: controller.priceController,
                            hintText: '0',
                            errorText: controller.priceError.value,
                            keyboardType: TextInputType.number,
                            onChanged: (value) {
                              if (value.isNotEmpty)
                                controller.priceError.value = '';
                            },
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 20),

              // Category Selection
              _buildSectionTitle('Category'.tr),
              const SizedBox(height: 10),
              Obx(
                () => Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    SizedBox(
                      height: 110,
                      child: ListView.builder(
                        scrollDirection: Axis.horizontal,
                        itemCount: controller.categories.length,
                        itemBuilder: (context, index) {
                          final category = controller.categories[index];
                          final isSelected =
                              controller.selectedCategory.value == category['id'];

                          return GestureDetector(
                            onTap: () {
                              controller.selectedCategory.value = category['id'];
                              controller.categoryError.value = '';
                            },
                            child: Container(
                              width: 90,
                              margin: const EdgeInsets.only(right: 12),
                              decoration: BoxDecoration(
                                color: isSelected
                                    ? const Color(0xFF1E7044)
                                    : Colors.white,
                                border: Border.all(
                                  color: isSelected
                                      ? const Color(0xFF1E7044)
                                      : Colors.grey[300]!,
                                  width: 2,
                                ),
                                borderRadius: BorderRadius.circular(16),
                              ),
                              child: Column(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  Container(
                                    height: 40,
                                    width: 40,
                                    decoration: BoxDecoration(
                                      shape: BoxShape.circle,
                                      color: isSelected
                                          ? Colors.white.withOpacity(0.2)
                                          : const Color(0xFF1E7044)
                                              .withOpacity(0.1),
                                    ),
                                    child: Icon(
                                      Icons.category,
                                      color: isSelected
                                          ? Colors.white
                                          : const Color(0xFF1E7044),
                                      size: 20,
                                    ),
                                  ),
                                  const SizedBox(height: 6),
                                  Text(
                                    category['name'],
                                    textAlign: TextAlign.center,
                                    maxLines: 1,
                                    overflow: TextOverflow.ellipsis,
                                    style: TextStyle(
                                      fontSize: 11,
                                      fontWeight: FontWeight.w600,
                                      color: isSelected
                                          ? Colors.white
                                          : const Color(0xFF1E7044),
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          );
                        },
                      ),
                    ),
                    if (controller.categoryError.isNotEmpty)
                      Padding(
                        padding: const EdgeInsets.only(top: 8),
                        child: Text(
                          controller.categoryError.value,
                          style: const TextStyle(
                            color: Colors.red,
                            fontSize: 12,
                          ),
                        ),
                      ),
                  ],
                ),
              ),
              const SizedBox(height: 20),

              // Location, District, Town Row
              _buildSectionTitle('Location'.tr),
              const SizedBox(height: 10),
              Obx(
                () => DropdownButtonFormField<String>(
                  value: controller.selectedDistrict.isEmpty
                      ? null
                      : controller.selectedDistrict.value,
                  decoration: InputDecoration(
                    labelText: 'District'.tr,
                    prefixIcon: const Icon(
                      Icons.location_on_outlined,
                      color: Color(0xFF1E7044),
                    ),
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                    filled: true,
                    fillColor: Colors.grey[50],
                  ),
                  items: controller.districts
                      .map((district) => DropdownMenuItem(
                            value: district,
                            child: Text(district),
                          ))
                      .toList(),
                  onChanged: (value) {
                    if (value != null) {
                      controller.updateTowns(value);
                    }
                  },
                ),
              ),
              const SizedBox(height: 12),
              Obx(
                () => DropdownButtonFormField<String>(
                  value: controller.selectedTown.isEmpty
                      ? null
                      : controller.selectedTown.value,
                  decoration: InputDecoration(
                    labelText: 'Town'.tr,
                    prefixIcon: const Icon(
                      Icons.location_city_outlined,
                      color: Color(0xFF1E7044),
                    ),
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                    filled: true,
                    fillColor: Colors.grey[50],
                  ),
                  items: (controller.townsByDistrict[
                              controller.selectedDistrict.value] ??
                          [])
                      .map((town) => DropdownMenuItem(
                            value: town,
                            child: Text(town),
                          ))
                      .toList(),
                  onChanged: (value) {
                    if (value != null) {
                      controller.selectedTown.value = value;
                    }
                  },
                ),
              ),
              const SizedBox(height: 20),

              // Images Section
              _buildSectionTitle('Product Images'.tr),
              const SizedBox(height: 10),
              Obx(
                () => Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    if (controller.selectedImages.isEmpty)
                      GestureDetector(
                        onTap: controller.pickImages,
                        child: Container(
                          width: double.infinity,
                          height: 150,
                          decoration: BoxDecoration(
                            border: Border.all(
                              color: Colors.grey[300]!,
                              width: 2,
                              style: BorderStyle.solid,
                            ),
                            borderRadius: BorderRadius.circular(12),
                            color: Colors.grey[50],
                          ),
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Icon(
                                Icons.add_photo_alternate_outlined,
                                size: 48,
                                color: Colors.grey[400],
                              ),
                              const SizedBox(height: 10),
                              Text(
                                'Tap to add images (Max 5)'.tr,
                                style: TextStyle(
                                  color: Colors.grey[600],
                                  fontSize: 14,
                                ),
                              ),
                            ],
                          ),
                        ),
                      )
                    else
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          GridView.builder(
                            shrinkWrap: true,
                            physics: const NeverScrollableScrollPhysics(),
                            gridDelegate:
                                const SliverGridDelegateWithFixedCrossAxisCount(
                              crossAxisCount: 3,
                              crossAxisSpacing: 12,
                              mainAxisSpacing: 12,
                              childAspectRatio: 1,
                            ),
                            itemCount: controller.selectedImages.length,
                            itemBuilder: (context, index) {
                              final image = controller.selectedImages[index];
                              return Stack(
                                children: [
                                  Container(
                                    decoration: BoxDecoration(
                                      borderRadius: BorderRadius.circular(12),
                                      image: DecorationImage(
                                        image: FileImage(
                                          File(image.path),
                                        ),
                                        fit: BoxFit.cover,
                                      ),
                                    ),
                                  ),
                                  Positioned(
                                    top: 0,
                                    right: 0,
                                    child: GestureDetector(
                                      onTap: () =>
                                          controller.removeImage(index),
                                      child: Container(
                                        decoration: const BoxDecoration(
                                          color: Colors.red,
                                          shape: BoxShape.circle,
                                        ),
                                        padding: const EdgeInsets.all(4),
                                        child: const Icon(
                                          Icons.close,
                                          color: Colors.white,
                                          size: 16,
                                        ),
                                      ),
                                    ),
                                  ),
                                ],
                              );
                            },
                          ),
                          const SizedBox(height: 12),
                          if (controller.selectedImages.length < 5)
                            GestureDetector(
                              onTap: controller.pickImages,
                              child: Container(
                                width: double.infinity,
                                padding: const EdgeInsets.symmetric(
                                  vertical: 12,
                                ),
                                decoration: BoxDecoration(
                                  border: Border.all(
                                    color: const Color(0xFF1E7044),
                                    width: 1.5,
                                  ),
                                  borderRadius: BorderRadius.circular(12),
                                ),
                                child: Center(
                                  child: Text(
                                    'Add More Images'.tr,
                                    style: const TextStyle(
                                      color: Color(0xFF1E7044),
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                ),
                              ),
                            ),
                        ],
                      ),
                    if (controller.imageError.isNotEmpty)
                      Padding(
                        padding: const EdgeInsets.only(top: 8),
                        child: Text(
                          controller.imageError.value,
                          style: const TextStyle(
                            color: Colors.red,
                            fontSize: 12,
                          ),
                        ),
                      ),
                  ],
                ),
              ),
              const SizedBox(height: 30),

              // Submit Button
              Obx(
                () => SizedBox(
                  width: double.infinity,
                  height: 50,
                  child: ElevatedButton(
                    onPressed: controller.isLoading.value
                        ? null
                        : () => controller.createAd(),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: const Color(0xFF1E7044),
                      disabledBackgroundColor: Colors.grey[400],
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                      elevation: 3,
                    ),
                    child: controller.isLoading.value
                        ? const SizedBox(
                            height: 24,
                            width: 24,
                            child: CircularProgressIndicator(
                              strokeWidth: 2.5,
                              valueColor: AlwaysStoppedAnimation<Color>(
                                Colors.white,
                              ),
                            ),
                          )
                        : Text(
                            "Create Ad".tr,
                            style: const TextStyle(
                              color: Colors.white,
                              fontSize: 16,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                  ),
                ),
              ),
              const SizedBox(height: 20),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildSectionTitle(String title) {
    return Text(
      title,
      style: const TextStyle(
        fontSize: 14,
        fontWeight: FontWeight.bold,
        color: Color(0xFF1E7044),
      ),
    );
  }

  Widget _buildTextField({
    required TextEditingController controller,
    required String hintText,
    String errorText = '',
    int maxLines = 1,
    TextInputType keyboardType = TextInputType.text,
    Function(String)? onChanged,
  }) {
    return TextField(
      controller: controller,
      keyboardType: keyboardType,
      maxLines: maxLines,
      onChanged: onChanged,
      decoration: InputDecoration(
        hintText: hintText,
        errorText: errorText.isEmpty ? null : errorText,
        filled: true,
        fillColor: Colors.grey[50],
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: BorderSide(
            color: errorText.isEmpty ? Colors.grey[300]! : Colors.red,
          ),
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: BorderSide(
            color: errorText.isEmpty ? Colors.grey[300]! : Colors.red,
            width: 1.5,
          ),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: BorderSide(
            color: errorText.isEmpty ? const Color(0xFF1E7044) : Colors.red,
            width: 2,
          ),
        ),
        contentPadding: const EdgeInsets.symmetric(
          horizontal: 16,
          vertical: 14,
        ),
      ),
    );
  }
}
