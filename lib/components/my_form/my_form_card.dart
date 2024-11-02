import 'package:flutter/material.dart';

import '../../constants.dart';
import '../network_image_with_loader.dart';

class MyFormCard extends StatelessWidget {
  const MyFormCard({
    super.key,
    required this.image,
    required this.brandName,
    required this.title,
    required this.subTitle,
    this.urgentLevel,
    this.urgentLevelText,
    required this.press,
  });
  final String image, brandName, title;
  final String? subTitle;
  final double? urgentLevel;
  final String? urgentLevelText;
  final VoidCallback press;

  @override
  Widget build(BuildContext context) {
    return OutlinedButton(
      onPressed: press,
      style: OutlinedButton.styleFrom(minimumSize: const Size(140, 200), maximumSize: const Size(140, 200), padding: const EdgeInsets.all(4)),
      child: Column(
        children: [
          AspectRatio(
            aspectRatio: 1.15,
            child: Stack(
              children: [
                (image.startsWith("http") ? NetworkImageWithLoader(image, radius: defaultBorderRadious) : Image.asset(image)),
                //NetworkImageWithLoader(image, radius: defaultBorderRadious),
                if (urgentLevelText != null)
                  Positioned(
                    right: defaultPadding / 2,
                    top: defaultPadding / 2,
                    child: Container(
                      padding: const EdgeInsets.symmetric(horizontal: defaultPadding / 2),
                      height: 16,
                      decoration: const BoxDecoration(
                        color: errorColor,
                        borderRadius: BorderRadius.all(Radius.circular(defaultBorderRadious)),
                      ),
                      child: Text(
                        "$urgentLevelText",
                        style: const TextStyle(color: Colors.white, fontSize: 10, fontWeight: FontWeight.w500),
                      ),
                    ),
                  )
              ],
            ),
          ),
          Expanded(
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: defaultPadding / 2, vertical: defaultPadding / 2),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    brandName.toUpperCase(),
                    style: Theme.of(context).textTheme.bodyMedium!.copyWith(fontSize: 10),
                  ),
                  const SizedBox(height: defaultPadding / 2),
                  Text(
                    title,
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                    style: Theme.of(context).textTheme.titleSmall!.copyWith(fontSize: 12),
                  ),
                  urgentLevel != null
                      ? Row(
                          children: [
                            const SizedBox(width: defaultPadding / 4),
                            Text(
                              "$subTitle" + "A",
                              style: TextStyle(
                                color: Theme.of(context).textTheme.bodyMedium!.color,
                                fontSize: 10,
                                decoration: TextDecoration.lineThrough,
                              ),
                            ),
                          ],
                        )
                      : Text(
                          "$subTitle" + "B",
                          style: const TextStyle(
                            color: Color(0xFF31B0D8),
                            fontWeight: FontWeight.w500,
                            fontSize: 12,
                          ),
                        ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
