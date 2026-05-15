import 'package:fish_meat/core/constants/colors.dart';
import 'package:fish_meat/features/auth/views/login_view.dart';
import 'package:fish_meat/features/notification/view/notification_screen.dart';
import 'package:fish_meat/features/profile/model/response/user_model.dart';
import 'package:fish_meat/features/profile/provider/profile_notifier.dart';
import 'package:fish_meat/shared/services/shared_pref_svc.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class ProfileScreen extends ConsumerStatefulWidget {
  const ProfileScreen({super.key});

  @override
  ConsumerState<ProfileScreen> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends ConsumerState<ProfileScreen> {
  @override
  void initState() {
    super.initState();
    Future.microtask(() => ref.read(profileProvider.notifier).fetchUser());
  }

  @override
  Widget build(BuildContext context) {
    final state = ref.watch(profileProvider);
    return Scaffold(
      body: Container(
        height: double.infinity,
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(30),
        ),
      child: SingleChildScrollView(
          child: Column(
            children: [
              Container(
                padding: EdgeInsets.symmetric(vertical: 32),
                width: double.infinity,
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    colors: [ConstantColors.blueClr, ConstantColors.lightClr],
                    begin: Alignment.topLeft,
                    end: Alignment.bottomLeft,
                  ),
                  borderRadius: BorderRadius.only(
                    bottomLeft: Radius.circular(32),
                    bottomRight: Radius.circular(32),
                  ),
                ),
                child: Column(
                  children: [
                    CircleAvatar(
                      radius: 50,
                      backgroundColor: Colors.white.withOpacity(0.02),
                      child: Icon(Icons.person, size: 55, color: Colors.white),
                    ),
                    SizedBox(height: 12),
                    Text(
                      state.user?.username ?? "User",
                      style: TextStyle(
                        fontSize: 22,
                        fontWeight: FontWeight.bold,
                        color: Colors.white,
                      ),
                    ),
                    SizedBox(height: 4),
                    Text(
                      state.user?.email ?? "",
                      style: TextStyle(
                        fontSize: 13,
                        color: Colors.white.withOpacity(0.08),
                      ),
                    ),
                    SizedBox(height: 8),
                    if (state.user?.vendor == "true")
                      Container(
                        padding: EdgeInsets.symmetric(
                          horizontal: 12,
                          vertical: 4,
                        ),
                        decoration: BoxDecoration(
                          color: Colors.amber,
                          borderRadius: BorderRadius.circular(20),
                        ),
                        child: Text(
                          "Vendor",
                          style: TextStyle(
                            fontWeight: FontWeight.bold,
                            fontSize: 12,
                          ),
                        ),
                      ),
                  ],
                ),
              ),
              SizedBox(height: 24),
              Padding(
                padding: EdgeInsetsGeometry.symmetric(horizontal: 16),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    _sectionTitle("Account Details"),
                    _InfoTile(
                      icon: Icons.person_outline,
                      title: "Username",
                      value: state.user?.username ?? "—",
                    ),
                    _InfoTile(
                      icon: Icons.email_outlined,
                      title: "Email",
                      value: state.user?.email ?? "—",
                    ),
                    _InfoTile(
                      icon: Icons.location_on_outlined,
                      title: "Address",
                      value: state.user?.address ?? "Not set",
                    ),
                    _InfoTile(
                      icon: Icons.pin_drop_outlined,
                      title: "Pincode",
                      value: state.user?.pincode ?? "Not set",
                    ),

                    const SizedBox(height: 16),
                    _sectionTitle("Actions"),

                    _ProfileTile(
                      icon: Icons.edit_outlined,
                      title: "Edit Profile",
                      subtitle: "Update your name, address and more",
                      onTap: () => _showEditDialog(context, state.user),
                    ),
                    
                    _ProfileTile(
                      icon: Icons.payment_outlined,
                      title: "Payment Methods",
                      subtitle: "Manage your payment options",
                      onTap: () {},
                    ),
                    _ProfileTile(
                      icon: Icons.notifications_outlined,
                      title: "Notifications",
                      subtitle: "Manage notification settings",
                      onTap: () {
                        Navigator.push(context, MaterialPageRoute(builder: (context) => NotificationScreen()));
                      },
                    ),
                    _ProfileTile(
                      icon: Icons.help_outline,
                      title: "Help & Support",
                      subtitle: "FAQs and contact us",
                      onTap: () {},
                    ),

                    const SizedBox(height: 16),

                    SizedBox(
                      width: double.infinity,
                      child: ElevatedButton.icon(
                        onPressed: () async {
                          await SharedPrefSvc.instance.clear();
                          if (context.mounted) {
                            Navigator.pushAndRemoveUntil(
                              context,
                              MaterialPageRoute(
                                builder: (context) => LoginView(),
                              ),
                              (route) => false,
                            );
                          }
                        },
                        icon: Icon(Icons.logout, color: Colors.white),
                        label: Text(
                          "LogOut",
                          style: TextStyle(
                            color: Colors.white,
                            fontWeight: FontWeight.bold,
                            fontSize: 16,
                          ),
                        ),
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.red,
                          padding: EdgeInsets.symmetric(vertical: 14),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadiusGeometry.circular(14),
                          ),
                        ),
                      ),
                    ),
                    SizedBox(height: 24),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}




void _showEditDialog(BuildContext context, UserModel? user) {
  final usernameCtrl = TextEditingController(text: user?.username ?? "");
  final addressCtrl = TextEditingController(text: user?.address ?? "");
  final pincodeCtrl = TextEditingController(text: user?.pincode ?? "");
  final formKey = GlobalKey<FormState>();

  showModalBottomSheet(
    context: context,
    isScrollControlled: true,
    backgroundColor: Colors.white,
    shape: const RoundedRectangleBorder(
      borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
    ),
    builder: (context) => Padding(
      padding: EdgeInsets.only(
        left: 16,
        right: 16,
        top: 24,
        bottom: MediaQuery.of(context).viewInsets.bottom + 24,
      ),
      child: Form(
        key: formKey,
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Center(
              child: Container(
                width: 40,
                height: 4,
                decoration: BoxDecoration(
                  color: Colors.grey[300],
                  borderRadius: BorderRadius.circular(2),
                ),
              ),
            ),
            const SizedBox(height: 16),
            Text(
              "Edit Profile",
              style: TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.bold,
                color: ConstantColors.blueClr,
              ),
            ),
            const SizedBox(height: 16),
            _EditField(
              controller: usernameCtrl,
              label: "Username",
              icon: Icons.person_outline,
              validator: (v) => v!.isEmpty ? "Enter username" : null,
            ),
            const SizedBox(height: 12),
            _EditField(
              controller: addressCtrl,
              label: "Address",
              icon: Icons.location_on_outlined,
            ),
            const SizedBox(height: 12),
            _EditField(
              controller: pincodeCtrl,
              label: "Pincode",
              icon: Icons.pin_drop_outlined,
              keyboardType: TextInputType.number,
            ),
            const SizedBox(height: 20),
            Consumer(
              builder: (context, ref, _) {
                final isUpdating = ref.watch(profileProvider).isUpdating;
                return SizedBox(
                  width: double.infinity,

                  child: ElevatedButton(
                    onPressed: isUpdating
                        ? null
                        : () async {
                            if (formKey.currentState!.validate()) {
                              final success = await ref
                                  .read(profileProvider.notifier)
                                  .updateUser(
      address: addressCtrl.text.trim().isEmpty ? null : addressCtrl.text.trim(),
      pincode: pincodeCtrl.text.trim().isEmpty ? null : pincodeCtrl.text.trim(),
                                  );
                              if (context.mounted) {
                                Navigator.pop(context);
                                ScaffoldMessenger.of(context).showSnackBar(
                                  SnackBar(
                                    content: Text(
                                      success
                                          ? "Profile updated!"
                                          : "Update failed",
                                    ),
                                    backgroundColor: success
                                        ? ConstantColors.blueClr
                                        : Colors.red[400],
                                  ),
                                );
                              }
                            }
                          },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: ConstantColors.blueClr,
                      disabledBackgroundColor: ConstantColors.lightClr,
                      padding: const EdgeInsets.symmetric(vertical: 14),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(14),
                      ),
                    ),
                    child: isUpdating
                        ? const SizedBox(
                            height: 20,
                            width: 20,
                            child: CircularProgressIndicator(
                              color: Colors.white,
                              strokeWidth: 2,
                            ),
                          )
                        : const Text(
                            "Save Changes",
                            style: TextStyle(
                              color: Colors.white,
                              fontWeight: FontWeight.bold,
                              fontSize: 16,
                            ),
                          ),
                  ),
                );
              },
            ),
          ],
        ),
      ),
    ),
  );
}

Widget _sectionTitle(String title) {
  return Padding(
    padding: const EdgeInsets.only(bottom: 8, top: 4),
    child: Text(
      title,
      style: TextStyle(
        fontSize: 13,
        fontWeight: FontWeight.bold,
        color: Colors.grey[500],
        letterSpacing: 0.5,
      ),
    ),
  );
}

class _InfoTile extends StatelessWidget {
  final IconData icon;
  final String title;
  final String value;

  const _InfoTile({
    required this.icon,
    required this.title,
    required this.value,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(bottom: 10),
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: Colors.grey[50],
        borderRadius: BorderRadius.circular(14),
        border: Border.all(color: Colors.grey.shade200),
      ),
      child: Row(
        children: [
          Icon(icon, color: ConstantColors.blueClr, size: 20),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: TextStyle(fontSize: 11, color: Colors.grey[500]),
                ),
                const SizedBox(height: 2),
                Text(
                  value,
                  style: const TextStyle(
                    fontSize: 14,
                    fontWeight: FontWeight.w600,
                    color: Color(0xFF1A2B3C),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class _ProfileTile extends StatelessWidget {
  final IconData icon;
  final String title;
  final String subtitle;
  final VoidCallback onTap;

  const _ProfileTile({
    required this.icon,
    required this.title,
    required this.subtitle,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(bottom: 10),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(14),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: 8,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: ListTile(
        leading: Container(
          width: 42,
          height: 42,
          decoration: BoxDecoration(
            color: ConstantColors.blueClr.withOpacity(0.1),
            borderRadius: BorderRadius.circular(10),
          ),
          child: Icon(icon, color: ConstantColors.blueClr, size: 22),
        ),
        title: Text(
          title,
          style: const TextStyle(
            fontWeight: FontWeight.w600,
            fontSize: 14,
            color: Color(0xFF1A2B3C),
          ),
        ),
        subtitle: Text(
          subtitle,
          style: TextStyle(fontSize: 12, color: Colors.grey[500]),
        ),
        trailing: Icon(Icons.chevron_right, color: Colors.grey[400]),
        onTap: onTap,
      ),
    );
  }
}

class _EditField extends StatelessWidget {
  final TextEditingController controller;
  final String label;
  final IconData icon;
  final TextInputType? keyboardType;
  final String? Function(String?)? validator;

  const _EditField({
    required this.controller,
    required this.label,
    required this.icon,
    this.keyboardType,
    this.validator,
  });

  @override
  Widget build(BuildContext context) {
    return TextFormField(
      controller: controller,
      keyboardType: keyboardType,
      validator: validator,
      decoration: InputDecoration(
        labelText: label,
        prefixIcon: Icon(icon, color: ConstantColors.blueClr),
        border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: BorderSide(color: ConstantColors.blueClr, width: 2),
        ),
      ),
    );
  }
}