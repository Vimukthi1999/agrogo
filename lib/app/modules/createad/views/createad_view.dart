import 'dart:io';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../../models/category_model.dart';
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
                        _buildSectionTitle('Price per kg (Rs)'.tr),
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


              _buildSectionTitle('Category'.tr),
              const SizedBox(height: 10),
              StreamBuilder<List<CategoryModel>>(
                stream: controller.getCategories(),
                builder: (context, snapshot) {
                  if (snapshot.connectionState == ConnectionState.waiting) {
                    return const Center(child: CircularProgressIndicator());
                  }

                  if (snapshot.hasError) {
                    return Center(child: Text('Error: ${snapshot.error}'));
                  }

                  if (!snapshot.hasData || snapshot.data!.isEmpty) {
                    return Center(
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Icon(
                            Icons.category_outlined,
                            size: 48,
                            color: Colors.grey[400],
                          ),
                          const SizedBox(height: 12),
                          Text(
                            'No categories found'.tr,
                            style: TextStyle(
                              color: Colors.grey[600],
                              fontSize: 14,
                            ),
                          ),
                        ],
                      ),
                    );
                  }

                  final categories = snapshot.data!;

                  return SizedBox(
                    height: 140,
                    child: ListView.builder(
                      scrollDirection: Axis.horizontal,
                      itemCount: categories.length,
                      itemBuilder: (context, index) {
                        final category = categories[index];

                        return Obx(
                          () {
                            final isSelected =
                                controller.selectedCategory.value == category.id;

                            return GestureDetector(
                              onTap: () {
                                controller.selectedCategory.value = category.id;
                                controller.categoryError.value = '';
                              },
                              child: Container(
                                width: 110,
                                margin: const EdgeInsets.only(right: 12),
                                decoration: BoxDecoration(
                                  color: Colors.white,
                                  borderRadius: BorderRadius.circular(18),
                                  border: isSelected
                                      ? Border.all(
                                          color: const Color(0xFF1E7044),
                                          width: 2.5,
                                        )
                                      : null,
                                  boxShadow: [
                                    BoxShadow(
                                      color: isSelected
                                          ? const Color(0xFF1E7044)
                                              .withOpacity(0.3)
                                          : Colors.black.withOpacity(0.08),
                                      blurRadius: isSelected ? 12 : 8,
                                      offset: const Offset(0, 3),
                                    ),
                                  ],
                                ),
                                child: Column(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    Container(
                                      height: 70,
                                      width: 70,
                                      decoration: BoxDecoration(
                                        shape: BoxShape.circle,
                                        color: const Color(0xFF1E7044)
                                            .withOpacity(0.1),
                                      ),
                                      child: Padding(
                                        padding: const EdgeInsets.all(8),
                                        child: Image.network(
                                          category.icon,
                                          fit: BoxFit.contain,
                                          errorBuilder:
                                              (context, error, stackTrace) {
                                            return Icon(
                                              Icons.image_not_supported,
                                              color:
                                                  const Color(0xFF1E7044),
                                            );
                                          },
                                        ),
                                      ),
                                    ),
                                    const SizedBox(height: 8),
                                    Text(
                                      category.name,
                                      textAlign: TextAlign.center,
                                      maxLines: 2,
                                      overflow: TextOverflow.ellipsis,
                                      style: const TextStyle(
                                        fontSize: 12,
                                        fontWeight: FontWeight.w600,
                                        color: Color(0xFF1E7044),
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            );
                          },
                        );
                      },
                    ),
                  );
                },
              ),
              Obx(
                () => controller.categoryError.isNotEmpty
                    ? Padding(
                        padding: const EdgeInsets.only(top: 8),
                        child: Text(
                          controller.categoryError.value,
                          style: const TextStyle(
                            color: Colors.red,
                            fontSize: 12,
                          ),
                        ),
                      )
                    : const SizedBox.shrink(),
              ),
              const SizedBox(height: 20),


              _buildSectionTitle('Location'.tr),
              const SizedBox(height: 10),
              Obx(
                () => Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    if (!controller.isDistrictAutoDetected.value)
                      ElevatedButton.icon(
                        onPressed: controller.isGettingLocation.value
                            ? null
                            : controller.getCurrentLocation,
                        icon: controller.isGettingLocation.value
                            ? const SizedBox(
                                height: 20,
                                width: 20,
                                child: CircularProgressIndicator(
                                  strokeWidth: 2,
                                  valueColor: AlwaysStoppedAnimation<Color>(
                                    Colors.white,
                                  ),
                                ),
                              )
                            : const Icon(Icons.location_on_outlined),
                        label: Text(
                          controller.isGettingLocation.value
                              ? 'Detecting Location...'.tr
                              : 'Auto Detect Location'.tr,
                        ),
                        style: ElevatedButton.styleFrom(
                          backgroundColor: const Color(0xFF1E7044),
                          foregroundColor: Colors.white,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(10),
                          ),
                          padding: const EdgeInsets.symmetric(
                            horizontal: 16,
                            vertical: 12,
                          ),
                        ),
                      )
                    else
                      Container(
                        padding: const EdgeInsets.all(12),
                        decoration: BoxDecoration(
                          color: Colors.green[50],
                          border: Border.all(
                            color: Colors.green[400]!,
                          ),
                          borderRadius: BorderRadius.circular(10),
                        ),
                        child: Row(
                          children: [
                            Icon(
                              Icons.check_circle_outline,
                              color: Colors.green[700],
                              size: 20,
                            ),
                            const SizedBox(width: 12),
                            Expanded(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    'Location Detected'.tr,
                                    style: TextStyle(
                                      color: Colors.green[700],
                                      fontWeight: FontWeight.bold,
                                      fontSize: 13,
                                    ),
                                  ),
                                  const SizedBox(height: 4),
                                  Text(
                                    '${controller.selectedDistrict.value} (Lat: ${controller.latitude.value.toStringAsFixed(4)}, Lng: ${controller.longitude.value.toStringAsFixed(4)})',
                                    style: TextStyle(
                                      color: Colors.green[600],
                                      fontSize: 12,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                            GestureDetector(
                              onTap: () {
                                controller.isDistrictAutoDetected.value = false;
                                controller.selectedDistrict.value = '';
                                controller.selectedTown.value = '';
                              },
                              child: Icon(
                                Icons.close,
                                color: Colors.green[700],
                                size: 20,
                              ),
                            ),
                          ],
                        ),
                      ),
                    if (controller.locationError.value.isNotEmpty)
                      Padding(
                        padding: const EdgeInsets.only(top: 8),
                        child: Text(
                          controller.locationError.value,
                          style: const TextStyle(
                            color: Colors.red,
                            fontSize: 12,
                          ),
                        ),
                      ),
                    const SizedBox(height: 12),
                    Text(
                      'District'.tr,
                      style: const TextStyle(
                        color: Color(0xFF1E7044),
                        fontWeight: FontWeight.w600,
                        fontSize: 13,
                      ),
                    ),
                    const SizedBox(height: 8),
                    DropdownButtonFormField<String>(
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
                        enabled: !controller.isDistrictAutoDetected.value,
                      ),
                      items: controller.districts
                          .map((district) => DropdownMenuItem(
                                value: district,
                                child: Text(district),
                              ))
                          .toList(),
                      onChanged: (value) {
                        if (value != null) {
                          controller.updateDistrict(value);
                        }
                      },
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 12),
              Text(
                'Town'.tr,
                style: const TextStyle(
                  color: Color(0xFF1E7044),
                  fontWeight: FontWeight.w600,
                  fontSize: 13,
                ),
              ),
              const SizedBox(height: 8),
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
