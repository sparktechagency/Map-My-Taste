import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';

class WebsiteLinkWidget extends StatelessWidget {
  final String? website;

  const WebsiteLinkWidget({super.key, this.website});

  Future<void> _launchURL(String url) async {
    final uri = Uri.parse(url);
    if (await canLaunchUrl(uri)) {
      await launchUrl(uri, mode: LaunchMode.externalApplication);
    } else {
      debugPrint("Could not launch $url");
    }
  }

  @override
  Widget build(BuildContext context) {
    if (website == null || website!.isEmpty) {
      return const SizedBox(); // hide if no website
    }

    return GestureDetector(
      onTap: () => _launchURL(website!),
      child: const Text(
        "Visit Website",
        style: TextStyle(
          color: Colors.blue,
          decoration: TextDecoration.underline,
        ),
      ),
    );
  }
}
