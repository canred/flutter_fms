// For demo only
import 'package:test/constants.dart';

class MyFormModel {
  final String image, brandName, title;
  final String? subTitle;
  final double? urgentLevel;
  final String? urgentLevelText;

  MyFormModel({
    required this.image,
    required this.brandName,
    required this.title,
    required this.subTitle,
    this.urgentLevel,
    this.urgentLevelText,
  });
}

List<MyFormModel> demoPopularProducts = [
  MyFormModel(
    image: productDemoImg1,
    title: "Mountain Warehouse for Women",
    brandName: "Lipsy london",
    subTitle: "540",
    urgentLevel: 420,
    urgentLevelText: "3 Day",
  ),
  MyFormModel(
    image: productDemoImg4,
    title: "Mountain Beta Warehouse",
    brandName: "Lipsy london",
    subTitle: "800",
  ),
  MyFormModel(
    image: productDemoImg5,
    title: "FS - Nike Air Max 270 Really React",
    brandName: "Lipsy london",
    subTitle: "650.62",
    urgentLevel: 390.36,
    urgentLevelText: "2 Day",
  ),
  MyFormModel(
    image: productDemoImg6,
    title: "Green Poplin Ruched Front",
    brandName: "Lipsy london",
    subTitle: "1264",
    urgentLevel: 1200.8,
    urgentLevelText: "2 Day",
  ),
  MyFormModel(
    image: "https://i.imgur.com/tXyOMMG.png",
    title: "Green Poplin Ruched Front",
    brandName: "Lipsy london",
    subTitle: "650.62",
    urgentLevel: 390.36,
    urgentLevelText: "1 Day",
  ),
  MyFormModel(
    image: "https://i.imgur.com/h2LqppX.png",
    title: "white satin corset top",
    brandName: "Lipsy london",
    subTitle: "1264",
    urgentLevel: 1200.8,
    urgentLevelText: "Today",
  ),
];

List<MyFormModel> demoFlashMyForm = [
  MyFormModel(
    image: myFormImg1,
    title: "資訊需求單",
    brandName: "陳慧鴻",
    subTitle: "電腦設備申請",
    urgentLevelText: "3 Day",
  ),
  MyFormModel(
    image: myFormImg2,
    title: "教育訓練",
    brandName: "陳慧鴻",
    subTitle: "PDCA課程",
    urgentLevelText: "2 Day",
  ),
  MyFormModel(
    image: myFormImg3,
    title: "設備維護",
    brandName: "Lipsy london",
    subTitle: "F1-1號機",
    urgentLevelText: "Now",
  ),
];
List<MyFormModel> demoBestSellersProducts = [
  MyFormModel(
    image: "https://i.imgur.com/tXyOMMG.png",
    title: "Green Poplin Ruched Front",
    brandName: "Lipsy london",
    subTitle: "650.62",
    urgentLevel: 390.36,
    urgentLevelText: "3 Day",
  ),
  MyFormModel(
    image: "https://i.imgur.com/h2LqppX.png",
    title: "white satin corset top",
    brandName: "Lipsy london",
    subTitle: "1264",
    urgentLevel: 1200.8,
    urgentLevelText: "3 Day",
  ),
  MyFormModel(
    image: productDemoImg4,
    title: "Mountain Beta Warehouse",
    brandName: "Lipsy london",
    subTitle: "800",
    urgentLevel: 680,
    urgentLevelText: "3 Day",
  ),
];
List<MyFormModel> kidsProducts = [
  MyFormModel(
    image: "https://i.imgur.com/dbbT6PA.png",
    title: "Green Poplin Ruched Front",
    brandName: "Lipsy london",
    subTitle: "650.62",
    urgentLevel: 590.36,
    urgentLevelText: "3 Day",
  ),
  MyFormModel(
    image: "https://i.imgur.com/7fSxC7k.png",
    title: "Printed Sleeveless Tiered Swing Dress",
    brandName: "Lipsy london",
    subTitle: "650.62",
  ),
  MyFormModel(
    image: "https://i.imgur.com/pXnYE9Q.png",
    title: "Ruffle-Sleeve Ponte-Knit Sheath ",
    brandName: "Lipsy london",
    subTitle: "400",
  ),
  MyFormModel(
    image: "https://i.imgur.com/V1MXgfa.png",
    title: "Green Mountain Beta Warehouse",
    brandName: "Lipsy london",
    subTitle: "400",
    urgentLevel: 360,
    urgentLevelText: "3 Day",
  ),
  MyFormModel(
    image: "https://i.imgur.com/8gvE5Ss.png",
    title: "Printed Sleeveless Tiered Swing Dress",
    brandName: "Lipsy london",
    subTitle: "654",
  ),
  MyFormModel(
    image: "https://i.imgur.com/cBvB5YB.png",
    title: "Mountain Beta Warehouse",
    brandName: "Lipsy london",
    subTitle: "250",
  ),
];
