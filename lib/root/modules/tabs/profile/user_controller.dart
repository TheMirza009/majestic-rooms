import 'dart:io';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:image_picker/image_picker.dart';
import 'package:majestic_rooms/core/base/common_controller.dart';
import 'package:majestic_rooms/core/utils/helper.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

class UserController extends GetxController {
  final CommonController _commonController = Get.find<CommonController>();
  final _supabase = Supabase.instance.client;
  final _picker = ImagePicker();

  final isLoading = false.obs;

  // ── Profile Photo Update ───────────────────────────────────────────────────

  Future<void> updateProfilePhoto() async {
    try {
      final XFile? image = await _picker.pickImage(source: ImageSource.gallery, imageQuality: 70);
      if (image == null) return;

      isLoading.value = true;
      final File file = File(image.path);
      final userId = _supabase.auth.currentUser?.id;
      if (userId == null) return;

      final fileExt = image.path.split('.').last;
      final fileName = '$userId-${DateTime.now().millisecondsSinceEpoch}.$fileExt';
      final path = '$userId/$fileName';

      // 1. Upload to Supabase Storage (account_image bucket)
      await _supabase.storage.from('account_image').upload(path, file);

      // 2. Get public URL
      final String publicUrl = _supabase.storage.from('account_image').getPublicUrl(path);

      // 3. Update auth user metadata
      await _supabase.auth.updateUser(UserAttributes(
        data: {'avatar_url': publicUrl},
      ));

      // 4. Update accounts table
      await _supabase.from('accounts').update({'picture_url': publicUrl}).eq('id', userId);

      // Force refresh of current user in CommonController
      _commonController.currentUser.value = _supabase.auth.currentUser;

      Utils.showBottomSnackBar('Success', 'Profile photo updated successfully.');
    } catch (e) {
      debugPrint('❌ [UserController] Failed to update profile photo: $e');
      Utils.showBottomSnackBarError('Update Failed', 'Could not update profile photo.');
    } finally {
      isLoading.value = false;
    }
  }

  // ── User Details Updates ───────────────────────────────────────────────────

  Future<void> updateName(String newName) async {
    if (newName.trim().isEmpty) return;
    try {
      isLoading.value = true;
      final userId = _supabase.auth.currentUser?.id;
      if (userId == null) return;

      // Update auth metadata
      await _supabase.auth.updateUser(UserAttributes(
        data: {'full_name': newName.trim()},
      ));

      // Update accounts table
      await _supabase.from('accounts').update({'name': newName.trim()}).eq('id', userId);

      _commonController.currentUser.value = _supabase.auth.currentUser;
      Utils.showBottomSnackBar('Success', 'Name updated successfully.');
    } catch (e) {
      debugPrint('❌ [UserController] Failed to update name: $e');
      Utils.showBottomSnackBarError('Update Failed', 'Could not update name.');
    } finally {
      isLoading.value = false;
    }
  }

  Future<void> updateEmail(String newEmail) async {
    if (newEmail.trim().isEmpty || !newEmail.contains('@')) return;
    try {
      isLoading.value = true;
      final userId = _supabase.auth.currentUser?.id;
      if (userId == null) return;

      // Update auth email
      await _supabase.auth.updateUser(UserAttributes(email: newEmail.trim()));

      // Update accounts table email
      await _supabase.from('accounts').update({'email': newEmail.trim()}).eq('id', userId);

      _commonController.currentUser.value = _supabase.auth.currentUser;
      Utils.showBottomSnackBar('Success', 'Email updated successfully. Please verify your new email.');
    } catch (e) {
      debugPrint('❌ [UserController] Failed to update email: $e');
      Utils.showBottomSnackBarError('Update Failed', 'Could not update email.');
    } finally {
      isLoading.value = false;
    }
  }

  Future<void> updatePassword(String newPassword) async {
    if (newPassword.trim().length < 6) {
      Utils.showBottomSnackBarError('Invalid Password', 'Password must be at least 6 characters.');
      return;
    }
    try {
      isLoading.value = true;
      
      await _supabase.auth.updateUser(UserAttributes(password: newPassword.trim()));

      Utils.showBottomSnackBar('Success', 'Password updated successfully.');
    } catch (e) {
      debugPrint('❌ [UserController] Failed to update password: $e');
      Utils.showBottomSnackBarError('Update Failed', 'Could not update password.');
    } finally {
      isLoading.value = false;
    }
  }

  Future<void> updatePhone(String newPhone) async {
    if (newPhone.trim().isEmpty) return;
    try {
      isLoading.value = true;
      final userId = _supabase.auth.currentUser?.id;
      if (userId == null) return;

      // Update public_data jsonb in accounts table
      // Fetch existing public_data first
      final accountData = await _supabase.from('accounts').select('public_data').eq('id', userId).single();
      
      Map<String, dynamic> publicData = {};
      if (accountData['public_data'] != null && accountData['public_data'] is Map) {
        publicData = Map<String, dynamic>.from(accountData['public_data'] as Map);
      }
      
      publicData['phone'] = newPhone.trim();

      await _supabase.from('accounts').update({'public_data': publicData}).eq('id', userId);

      Utils.showBottomSnackBar('Success', 'Phone number updated successfully.');
    } catch (e) {
      debugPrint('❌ [UserController] Failed to update phone: $e');
      Utils.showBottomSnackBarError('Update Failed', 'Could not update phone number.');
    } finally {
      isLoading.value = false;
    }
  }

  // ── Account Deletion ───────────────────────────────────────────────────────

  void deleteAccount() {
    // Stub implementation as requested
    Utils.showBottomSnackBarError('Action Denied', 'Cannot delete this account.');
  }
}
