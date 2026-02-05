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
              // Logo and Welcome Section
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
                      child: Icon(
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
              // Form Section
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

                      // Email Field
                      Text(
                        "Email Address".tr,
                        style: const TextStyle(
                          color: Color(0xFF173046),
                          fontWeight: FontWeight.w600,
                          fontSize: 13,
                        ),
                      ),
                      const SizedBox(height: 10),
                      Obx(
                        () => TextField(
                          controller: controller.emailController,
                          keyboardType: TextInputType.emailAddress,
                          onChanged: (value) {
                            if (value.isEmpty) {
                              controller.emailError.value = '';
                            }
                          },
                          decoration: InputDecoration(
                            hintText: "Enter your email",
                            prefixIcon: const Icon(
                              Icons.email_outlined,
                              color: Color(0xFF173046),
                              size: 22,
                            ),
                            filled: true,
                            fillColor: Colors.grey[50],
                            errorText: controller.emailError.isEmpty
                                ? null
                                : controller.emailError.value,
                            border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(12),
                              borderSide: BorderSide(
                                color: controller.emailError.isNotEmpty
                                    ? Colors.red
                                    : Colors.grey[300]!,
                              ),
                            ),
                            enabledBorder: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(12),
                              borderSide: BorderSide(
                                color: controller.emailError.isNotEmpty
                                    ? Colors.red
                                    : Colors.grey[300]!,
                                width: 1.5,
                              ),
                            ),
                            focusedBorder: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(12),
                              borderSide: BorderSide(
                                color: controller.emailError.isNotEmpty
                                    ? Colors.red
                                    : const Color(0xFF173046),
                                width: 2,
                              ),
                            ),
                            contentPadding: const EdgeInsets.symmetric(
                              horizontal: 16,
                              vertical: 14,
                            ),
                          ),
                        ),
                      ),
                      const SizedBox(height: 20),

                      // Password Field
                      Text(
                        "Password".tr,
                        style: const TextStyle(
                          color: Color(0xFF173046),
                          fontWeight: FontWeight.w600,
                          fontSize: 13,
                        ),
                      ),
                      const SizedBox(height: 10),
                      Obx(
                        () => TextField(
                          controller: controller.passwordController,
                          obscureText: !controller.isPasswordVisible.value,
                          onChanged: (value) {
                            if (value.isEmpty) {
                              controller.passwordError.value = '';
                            }
                          },
                          decoration: InputDecoration(
                            hintText: "Create a password",
                            prefixIcon: const Icon(
                              Icons.lock_outlined,
                              color: Color(0xFF173046),
                              size: 22,
                            ),
                            suffixIcon: GestureDetector(
                              onTap: () {
                                controller.isPasswordVisible.toggle();
                              },
                              child: Icon(
                                controller.isPasswordVisible.value
                                    ? Icons.visibility_outlined
                                    : Icons.visibility_off_outlined,
                                color: const Color(0xFF173046),
                                size: 22,
                              ),
                            ),
                            filled: true,
                            fillColor: Colors.grey[50],
                            errorText: controller.passwordError.isEmpty
                                ? null
                                : controller.passwordError.value,
                            border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(12),
                              borderSide: BorderSide(
                                color: controller.passwordError.isNotEmpty
                                    ? Colors.red
                                    : Colors.grey[300]!,
                              ),
                            ),
                            enabledBorder: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(12),
                              borderSide: BorderSide(
                                color: controller.passwordError.isNotEmpty
                                    ? Colors.red
                                    : Colors.grey[300]!,
                                width: 1.5,
                              ),
                            ),
                            focusedBorder: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(12),
                              borderSide: BorderSide(
                                color: controller.passwordError.isNotEmpty
                                    ? Colors.red
                                    : const Color(0xFF173046),
                                width: 2,
                              ),
                            ),
                            contentPadding: const EdgeInsets.symmetric(
                              horizontal: 16,
                              vertical: 14,
                            ),
                          ),
                        ),
                      ),
                      const SizedBox(height: 20),

                      // Confirm Password Field
                      Text(
                        "Confirm Password".tr,
                        style: const TextStyle(
                          color: Color(0xFF173046),
                          fontWeight: FontWeight.w600,
                          fontSize: 13,
                        ),
                      ),
                      const SizedBox(height: 10),
                      Obx(
                        () => TextField(
                          controller: controller.confirmPasswordController,
                          obscureText: !controller.isConfirmPasswordVisible.value,
                          onChanged: (value) {
                            if (value.isEmpty) {
                              controller.confirmPasswordError.value = '';
                            }
                          },
                          decoration: InputDecoration(
                            hintText: "Re-enter your password",
                            prefixIcon: const Icon(
                              Icons.lock_outlined,
                              color: Color(0xFF173046),
                              size: 22,
                            ),
                            suffixIcon: GestureDetector(
                              onTap: () {
                                controller.isConfirmPasswordVisible.toggle();
                              },
                              child: Icon(
                                controller.isConfirmPasswordVisible.value
                                    ? Icons.visibility_outlined
                                    : Icons.visibility_off_outlined,
                                color: const Color(0xFF173046),
                                size: 22,
                              ),
                            ),
                            filled: true,
                            fillColor: Colors.grey[50],
                            errorText: controller.confirmPasswordError.isEmpty
                                ? null
                                : controller.confirmPasswordError.value,
                            border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(12),
                              borderSide: BorderSide(
                                color: controller.confirmPasswordError.isNotEmpty
                                    ? Colors.red
                                    : Colors.grey[300]!,
                              ),
                            ),
                            enabledBorder: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(12),
                              borderSide: BorderSide(
                                color: controller.confirmPasswordError.isNotEmpty
                                    ? Colors.red
                                    : Colors.grey[300]!,
                                width: 1.5,
                              ),
                            ),
                            focusedBorder: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(12),
                              borderSide: BorderSide(
                                color: controller.confirmPasswordError.isNotEmpty
                                    ? Colors.red
                                    : const Color(0xFF173046),
                                width: 2,
                              ),
                            ),
                            contentPadding: const EdgeInsets.symmetric(
                              horizontal: 16,
                              vertical: 14,
                            ),
                          ),
                        ),
                      ),
                      const SizedBox(height: 25),

                      // Register Button
                      Obx(
                        () => SizedBox(
                          width: double.infinity,
                          height: 50,
                          child: ElevatedButton(
                            onPressed: controller.isLoading.value
                                ? null
                                : () {
                                    controller.register(
                                      controller.emailController.text.trim(),
                                      controller.passwordController.text.trim(),
                                      controller.confirmPasswordController.text.trim(),
                                    );
                                  },
                            style: ElevatedButton.styleFrom(
                              backgroundColor: Theme.of(context).primaryColor,
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

                      // Divider with text
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

                      // Sign In Link
                      Center(
                        child: GestureDetector(
                          onTap: () {
                            Get.offNamed(Routes.SIGNIN);
                          },
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
}
