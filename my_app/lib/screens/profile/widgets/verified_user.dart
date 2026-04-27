import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/profile_provider.dart';


// =====================================================
// VERIFIED NAME WIDGET (user name + verified badge)
// =====================================================
class VerifiedUser extends StatelessWidget {
  final double fontSize;
  final FontWeight fontWeight;

  const VerifiedUser({
    super.key,
    this.fontSize = 16,
    this.fontWeight = FontWeight.bold,
  });

  @override
  Widget build(BuildContext context) {

    // --- ACCESS USER PROFILE FROM PROVIDER ---
    final profile = context.watch<ProfileProvider>();

    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [

        // --- USER NAME DISPLAY ---
        Text(
          profile.name.isNotEmpty ? profile.name : "No Name",
          style: TextStyle(
            fontSize: fontSize,
            fontWeight: fontWeight,
          ),
        ),

        // --- VERIFIED BADGE ---
        if (profile.isVerified) ...[
          const SizedBox(width: 6),
          const Icon(
            Icons.verified,
            color: Colors.blue,
            size: 18,
          ),
        ],
      ],
    );
  }
}