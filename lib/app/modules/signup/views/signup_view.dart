import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../../routes/app_pages.dart';
import '../../common/containers_decorations.dart';
import '../controllers/signup_controller.dart';

class SignupView extends GetView<SignupController> {
  const SignupView({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        decoration: backgroundDecorationSignUp(),
        child: SingleChildScrollView(
          child: Column(
            children: [
              SizedBox(
                height: 220,
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Container(
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        color: Colors.white.withOpacity(0.15),
                        boxShadow: [
                          BoxShadow(
                            color: Colors.black.withOpacity(0.2),
                            blurRadius: 20,
                            offset: const Offset(0, 10),
                          ),
                        ],
                      ),
                      padding: const EdgeInsets.all(30),
                      child: const Icon(
                        Icons.agriculture,
                        size: 60,
                        color: Colors.white,
                      ),
                    ),
                    const SizedBox(height: 20),
                    Text(
                      "AgroGo".tr,
                      style: const TextStyle(
                        color: Colors.white,
                        fontSize: 32,
                        fontWeight: FontWeight.bold,
                        letterSpacing: 1.5,
                      ),
                    ),
                    const SizedBox(height: 8),
                    Text(
                      "Join Our Community".tr,
                      style: TextStyle(
                        color: Colors.white.withOpacity(0.7),
                        fontSize: 14,
                        letterSpacing: 0.5,
                      ),
                    ),
                  ],
                ),
              ),
              Container(
                decoration: const BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.only(
                    topLeft: Radius.circular(40),
                    topRight: Radius.circular(40),
                  ),
                ),
                child: Padding(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 30,
                    vertical: 40,
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        "Create Account".tr,
                        style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                              fontWeight: FontWeight.bold,
                              color: const Color(0xFF173046),
                            ),
                      ),
                      const SizedBox(height: 8),
                      Text(
                        "Sign up to get started with your agricultural journey".tr,
                        style: TextStyle(
                          color: Colors.grey[600],
                          fontSize: 14,
                        ),
                      ),
                      const SizedBox(height: 30),

                     
                      RichText(
                        text: const TextSpan(
                          style: TextStyle(
                            color: Color(0xFF173046),
                            fontWeight: FontWeight.w600,
                            fontSize: 13,
                          ),
                          children: [
                            TextSpan(text: 'Full Name'),
                            TextSpan(text: ' ', style: TextStyle(fontSize: 13)),
                            TextSpan(
                              text: '*',
                              style: TextStyle(
                                color: Colors.red,
                                fontWeight: FontWeight.bold,
                                fontSize: 14,
                              ),
                            ),
                          ],
                        ),
                      ),
                      const SizedBox(height: 10),
                      Obx(
                        () => _buildTextField(
                          controller: controller.nameController,
                          hintText: "Enter your full name",
                          prefixIcon: Icons.person_outlined,
                          errorText: controller.nameError.value,
                          onChanged: (value) {
                            if (value.isNotEmpty) {
                              controller.nameError.value = '';
                            }
                          },
                        ),
                      ),
                      const SizedBox(height: 20),

                    
                      Text(
                        "Account Type".tr,
                        style: const TextStyle(
                          color: Color(0xFF173046),
                          fontWeight: FontWeight.w600,
                          fontSize: 13,
                        ),
                      ),
                      const SizedBox(height: 10),
                      Obx(
                        () => Row(
                          children: [
                            Expanded(
                              child: GestureDetector(
                                onTap: () => controller.accountType.value = 'farmer',
                                child: _buildAccountTypeButton(
                                  label: "Farmer",
                                  icon: Icons.agriculture,
                                  isSelected:
                                      controller.accountType.value == 'farmer',
                                ),
                              ),
                            ),
                            const SizedBox(width: 12),
                            Expanded(
                              child: GestureDetector(
                                onTap: () => controller.accountType.value = 'buyer',
                                child: _buildAccountTypeButton(
                                  label: "Buyer",
                                  icon: Icons.shopping_cart_outlined,
                                  isSelected: controller.accountType.value == 'buyer',
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                      const SizedBox(height: 20),

                     
                      RichText(
                        text: const TextSpan(
                          style: TextStyle(
                            color: Color(0xFF173046),
                            fontWeight: FontWeight.w600,
                            fontSize: 13,
                          ),
                          children: [
                            TextSpan(text: 'Email Address'),
                            TextSpan(text: ' ', style: TextStyle(fontSize: 13)),
                            TextSpan(
                              text: '*',
                              style: TextStyle(
                                color: Colors.red,
                                fontWeight: FontWeight.bold,
                                fontSize: 14,
                              ),
                            ),
                          ],
                        ),
                      ),
                      const SizedBox(height: 10),
                      Obx(
                        () => _buildTextField(
                          controller: controller.emailController,
                          hintText: "Enter your email",
                          prefixIcon: Icons.email_outlined,
                          errorText: controller.emailError.value,
                          keyboardType: TextInputType.emailAddress,
                          onChanged: (value) {
                            if (value.isNotEmpty) {
                              controller.emailError.value = '';
                            }
                          },
                        ),
                      ),
                      const SizedBox(height: 20),

                     
                      RichText(
                        text: const TextSpan(
                          style: TextStyle(
                            color: Color(0xFF173046),
                            fontWeight: FontWeight.w600,
                            fontSize: 13,
                          ),
                          children: [
                            TextSpan(text: 'Phone Number'),
                            TextSpan(text: ' ', style: TextStyle(fontSize: 13)),
                            TextSpan(
                              text: '*',
                              style: TextStyle(
                                color: Colors.red,
                                fontWeight: FontWeight.bold,
                                fontSize: 14,
                              ),
                            ),
                          ],
                        ),
                      ),
                      const SizedBox(height: 10),
                      Obx(
                        () => _buildTextField(
                          controller: controller.phoneController,
                          hintText: "Enter your phone number",
                          prefixIcon: Icons.phone_outlined,
                          errorText: controller.phoneError.value,
                          keyboardType: TextInputType.phone,
                          onChanged: (value) {
                            if (value.isNotEmpty) {
                              controller.phoneError.value = '';
                            }
                          },
                        ),
                      ),
                      const SizedBox(height: 20),

                    
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          RichText(
                            text: const TextSpan(
                              children: [
                                TextSpan(
                                  text: 'Location',
                                  style: TextStyle(
                                    color: Color(0xFF173046),
                                    fontWeight: FontWeight.w600,
                                    fontSize: 13,
                                  ),
                                ),
                                TextSpan(
                                  text: ' *',
                                  style: TextStyle(
                                    color: Colors.red,
                                    fontWeight: FontWeight.bold,
                                    fontSize: 14,
                                  ),
                                ),
                              ],
                            ),
                          ),
                          Obx(
                            () => GestureDetector(
                              onTap: controller.isGettingLocation.value
                                  ? null
                                  : controller.getCurrentLocation,
                              child: Container(
                                padding: const EdgeInsets.symmetric(
                                  horizontal: 12,
                                  vertical: 6,
                                ),
                                decoration: BoxDecoration(
                                  color: const Color(0xFF173046)
                                      .withOpacity(0.1),
                                  borderRadius: BorderRadius.circular(8),
                                ),
                                child: Row(
                                  children: [
                                    if (controller.isGettingLocation.value)
                                      const SizedBox(
                                        height: 14,
                                        width: 14,
                                        child: CircularProgressIndicator(
                                          strokeWidth: 2,
                                        ),
                                      )
                                    else
                                      const Icon(
                                        Icons.my_location,
                                        color: Color(0xFF173046),
                                        size: 16,
                                      ),
                                    const SizedBox(width: 6),
                                    Text(
                                      controller.isGettingLocation.value
                                          ? "Detecting...".tr
                                          : "Detect".tr,
                                      style: const TextStyle(
                                        color: Color(0xFF173046),
                                        fontSize: 12,
                                        fontWeight: FontWeight.w600,
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 10),
                      Obx(
                        () => Row(
                          children: [
                            Expanded(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    "Province".tr,
                                    style: const TextStyle(
                                      fontSize: 12,
                                      fontWeight: FontWeight.w600,
                                      color: Color(0xFF173046),
                                    ),
                                  ),
                                  const SizedBox(height: 6),
                                  Container(
                                    padding: const EdgeInsets.symmetric(
                                      horizontal: 12,
                                      vertical: 12,
                                    ),
                                    decoration: BoxDecoration(
                                      color: Colors.grey[50],
                                      border: Border.all(
                                        color: controller.locationError.value.isNotEmpty
                                            ? Colors.red
                                            : Colors.grey[300]!,
                                        width: controller.locationError.value.isNotEmpty ? 1.5 : 1,
                                      ),
                                      borderRadius: BorderRadius.circular(10),
                                    ),
                                    child: Text(
                                      controller.province.isEmpty
                                          ? "Not detected".tr
                                          : controller.province.value,
                                      style: TextStyle(
                                        color: controller.province.isEmpty
                                            ? Colors.grey[600]
                                            : const Color(0xFF173046),
                                        fontSize: 13,
                                        fontWeight: FontWeight.w500,
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                            ),
                            const SizedBox(width: 12),
                            Expanded(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    "District".tr,
                                    style: const TextStyle(
                                      fontSize: 12,
                                      fontWeight: FontWeight.w600,
                                      color: Color(0xFF173046),
                                    ),
                                  ),
                                  const SizedBox(height: 6),
                                  Container(
                                    padding: const EdgeInsets.symmetric(
                                      horizontal: 12,
                                      vertical: 12,
                                    ),
                                    decoration: BoxDecoration(
                                      color: Colors.grey[50],
                                      border: Border.all(
                                        color: controller.locationError.value.isNotEmpty
                                            ? Colors.red
                                            : Colors.grey[300]!,
                                        width: controller.locationError.value.isNotEmpty ? 1.5 : 1,
                                      ),
                                      borderRadius: BorderRadius.circular(10),
                                    ),
                                    child: Text(
                                      controller.district.isEmpty
                                          ? "Not detected".tr
                                          : controller.district.value,
                                      style: TextStyle(
                                        color: controller.district.isEmpty
                                            ? Colors.grey[600]
                                            : const Color(0xFF173046),
                                        fontSize: 13,
                                        fontWeight: FontWeight.w500,
                                      ),
                                    ),
                                  ),
                                ],
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
                              fontWeight: FontWeight.w500,
                            ),
                          ),
                        ),
                      const SizedBox(height: 20),

                      
                      RichText(
                        text: const TextSpan(
                          style: TextStyle(
                            color: Color(0xFF173046),
                            fontWeight: FontWeight.w600,
                            fontSize: 13,
                          ),
                          children: [
                            TextSpan(text: 'Password'),
                            TextSpan(text: ' ', style: TextStyle(fontSize: 13)),
                            TextSpan(
                              text: '*',
                              style: TextStyle(
                                color: Colors.red,
                                fontWeight: FontWeight.bold,
                                fontSize: 14,
                              ),
                            ),
                          ],
                        ),
                      ),
                      const SizedBox(height: 10),
                      Obx(
                        () => _buildPasswordField(
                          controller: controller.passwordController,
                          hintText: "Create a password",
                          isVisible: controller.isPasswordVisible.value,
                          onVisibilityToggle: () =>
                              controller.isPasswordVisible.toggle(),
                          errorText: controller.passwordError.value,
                          onChanged: (value) {
                            if (value.isEmpty) {
                              controller.passwordError.value = '';
                            }
                          },
                        ),
                      ),
                      const SizedBox(height: 20),

                      
                      RichText(
                        text: const TextSpan(
                          style: TextStyle(
                            color: Color(0xFF173046),
                            fontWeight: FontWeight.w600,
                            fontSize: 13,
                          ),
                          children: [
                            TextSpan(text: 'Confirm Password'),
                            TextSpan(text: ' ', style: TextStyle(fontSize: 13)),
                            TextSpan(
                              text: '*',
                              style: TextStyle(
                                color: Colors.red,
                                fontWeight: FontWeight.bold,
                                fontSize: 14,
                              ),
                            ),
                          ],
                        ),
                      ),
                      const SizedBox(height: 10),
                      Obx(
                        () => _buildPasswordField(
                          controller: controller.confirmPasswordController,
                          hintText: "Re-enter your password",
                          isVisible:
                              controller.isConfirmPasswordVisible.value,
                          onVisibilityToggle: () =>
                              controller.isConfirmPasswordVisible.toggle(),
                          errorText: controller.confirmPasswordError.value,
                          onChanged: (value) {
                            if (value.isEmpty) {
                              controller.confirmPasswordError.value = '';
                            }
                          },
                        ),
                      ),
                      const SizedBox(height: 25),

                      
                      Obx(
                        () => SizedBox(
                          width: double.infinity,
                          height: 50,
                          child: ElevatedButton(
                            onPressed: controller.isLoading.value
                                ? null
                                : () {
                                    controller.register(
                                      controller.nameController.text.trim(),
                                      controller.emailController.text.trim(),
                                      controller.phoneController.text.trim(),
                                      controller.passwordController.text
                                          .trim(),
                                      controller
                                          .confirmPasswordController.text
                                          .trim(),
                                    );
                                  },
                            style: ElevatedButton.styleFrom(
                              backgroundColor:
                                  Theme.of(context).primaryColor,
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
                                      valueColor:
                                          AlwaysStoppedAnimation<Color>(
                                        Colors.white,
                                      ),
                                    ),
                                  )
                                : const Text(
                                    "Create Account",
                                    style: TextStyle(
                                      color: Colors.white,
                                      fontSize: 16,
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                          ),
                        ),
                      ),
                      const SizedBox(height: 16),

                  
                      Row(
                        children: [
                          Expanded(
                            child: Divider(
                              color: Colors.grey[300],
                              thickness: 1,
                            ),
                          ),
                          Padding(
                            padding: const EdgeInsets.symmetric(horizontal: 12),
                            child: Text(
                              "or".tr,
                              style: TextStyle(
                                color: Colors.grey[600],
                                fontSize: 12,
                              ),
                            ),
                          ),
                          Expanded(
                            child: Divider(
                              color: Colors.grey[300],
                              thickness: 1,
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 16),

                     
                      Center(
                        child: GestureDetector(
                          onTap: () => Get.offNamed(Routes.SIGNIN),
                          child: RichText(
                            text: TextSpan(
                              children: [
                                TextSpan(
                                  text: "Already have an account? ".tr,
                                  style: TextStyle(
                                    color: Colors.grey[700],
                                    fontSize: 14,
                                  ),
                                ),
                                const TextSpan(
                                  text: "Sign In",
                                  style: TextStyle(
                                    color: Color(0xFF173046),
                                    fontSize: 14,
                                    fontWeight: FontWeight.bold,
                                    decoration: TextDecoration.underline,
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                      ),
                      const SizedBox(height: 20),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildTextField({
    required TextEditingController controller,
    required String hintText,
    required IconData prefixIcon,
    String errorText = '',
    TextInputType keyboardType = TextInputType.text,
    Function(String)? onChanged,
  }) {
    return TextField(
      controller: controller,
      keyboardType: keyboardType,
      onChanged: onChanged,
      decoration: InputDecoration(
        hintText: hintText,
        prefixIcon: Icon(
          prefixIcon,
          color: const Color(0xFF173046),
          size: 22,
        ),
        filled: true,
        fillColor: Colors.grey[50],
        errorText: errorText.isEmpty ? null : errorText,
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
            color: errorText.isEmpty
                ? const Color(0xFF173046)
                : Colors.red,
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

  Widget _buildPasswordField({
    required TextEditingController controller,
    required String hintText,
    required bool isVisible,
    required VoidCallback onVisibilityToggle,
    String errorText = '',
    Function(String)? onChanged,
  }) {
    return TextField(
      controller: controller,
      obscureText: !isVisible,
      onChanged: onChanged,
      decoration: InputDecoration(
        hintText: hintText,
        prefixIcon: const Icon(
          Icons.lock_outlined,
          color: Color(0xFF173046),
          size: 22,
        ),
        suffixIcon: GestureDetector(
          onTap: onVisibilityToggle,
          child: Icon(
            isVisible ? Icons.visibility_outlined : Icons.visibility_off_outlined,
            color: const Color(0xFF173046),
            size: 22,
          ),
        ),
        filled: true,
        fillColor: Colors.grey[50],
        errorText: errorText.isEmpty ? null : errorText,
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
            color: errorText.isEmpty
                ? const Color(0xFF173046)
                : Colors.red,
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

  Widget _buildAccountTypeButton({
    required String label,
    required IconData icon,
    required bool isSelected,
  }) {
    return Container(
      padding: const EdgeInsets.symmetric(vertical: 12),
      decoration: BoxDecoration(
        color:
            isSelected ? const Color(0xFF173046) : Colors.white,
        border: Border.all(
          color: isSelected
              ? const Color(0xFF173046)
              : Colors.grey[300]!,
          width: 2,
        ),
        borderRadius: BorderRadius.circular(10),
      ),
      child: Center(
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              icon,
              color: isSelected ? Colors.white : const Color(0xFF173046),
              size: 20,
            ),
            const SizedBox(width: 8),
            Text(
              label.tr,
              style: TextStyle(
                color:
                    isSelected ? Colors.white : const Color(0xFF173046),
                fontWeight: FontWeight.w600,
                fontSize: 13,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
