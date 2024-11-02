import 'package:flutter/material.dart';
import 'package:test/components/my_form/my_form_card.dart';
// import 'package:test/components/product/product_card.dart';
// import 'package:test/models/product_model.dart';
import 'package:test/models/my_form_model.dart';
import 'package:test/route/screen_export.dart';

import '../../../../constants.dart';

class MyRequestList extends StatelessWidget {
  const MyRequestList({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const SizedBox(height: defaultPadding / 2),
        Padding(
          padding: const EdgeInsets.all(defaultPadding),
          child: Text(
            "我的簽核單",
            style: Theme.of(context).textTheme.titleSmall,
          ),
        ),
        // While loading use 👇
        // const ProductsSkelton(),
        SizedBox(
          height: 200,
          child: ListView.builder(
            scrollDirection: Axis.horizontal,
            // Find demoPopularProducts on models/ProductModel.dart
            itemCount: demoFlashMyForm.length,
            itemBuilder: (context, index) => Padding(
              padding: EdgeInsets.only(
                left: defaultPadding,
                right: index == demoFlashMyForm.length - 1 ? defaultPadding : 0,
              ),
              child: MyFormCard(
                image: demoFlashMyForm[index].image,
                brandName: demoFlashMyForm[index].brandName,
                title: demoFlashMyForm[index].title,
                subTitle: demoFlashMyForm[index].subTitle,
                urgentLevel: demoFlashMyForm[index].urgentLevel,
                urgentLevelText: demoFlashMyForm[index].urgentLevelText,
                press: () {
                  Navigator.pushNamed(context, productDetailsScreenRoute, arguments: index.isEven);
                },
              ),
            ),
          ),
        )
      ],
    );
  }
}
