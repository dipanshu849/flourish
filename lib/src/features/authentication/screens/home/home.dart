import "package:flourish/src/common_widget/layout/grid_layout.dart";
import "package:flourish/src/common_widget/product/product_card_vertical.dart";
import "package:flourish/src/features/authentication/screens/home/widget/circular_container.dart";
import "package:flourish/src/features/authentication/screens/home/widget/curved_edge_widget.dart";
import "package:flourish/src/features/authentication/screens/product/product_quries/product_controller.dart";
import "package:flourish/src/features/authentication/screens/sub_category/sub_category.dart";
import "package:flourish/src/utils/constants/colors.dart";
import "package:flourish/src/utils/constants/sizes.dart";
import "package:flourish/src/utils/device/device_utility.dart";
import "package:flourish/src/utils/helpers/helper_function.dart";
import "package:flutter/material.dart";
import "package:get/get.dart";
import "package:line_awesome_flutter/line_awesome_flutter.dart";

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  final ProductController productController = Get.put(ProductController());

  @override
  void initState() {
    super.initState();
    productController.fetchProducts();
  }

  @override
  Widget build(BuildContext context) {
    // final controller = Get.put(ProfileController());
    final Size size = HelperFunction.getScreenSize(context);
    final isDark = HelperFunction.isDarkMode(context);
    return Scaffold(
        backgroundColor: isDark ? slate800 : light,
        body: SingleChildScrollView(
            child: Column(
          children: [
            CurvedEdgeWidget(
              child: Container(
                color: slate400.withOpacity(0.6),
                padding: const EdgeInsets.all(0),
                child: SizedBox(
                  height: size.height * 0.4,
                  width: double.infinity,
                  child: Stack(
                    children: [
                      Positioned(
                        top: -150,
                        right: -250,
                        child: CircularContainer(
                            backgroundColor: light.withOpacity(0.2)),
                      ),
                      Positioned(
                        top: 100,
                        right: -300,
                        child: CircularContainer(
                            backgroundColor: light.withOpacity(0.2)),
                      ),
                      // Existing AppBar
                      Positioned(
                        top: 0,
                        left: 0,
                        right: 0,
                        child: AppBar(
                          title: Text(
                            "HOME",
                            style: Theme.of(context)
                                .textTheme
                                .headlineSmall!
                                .apply(color: slate800, fontSizeFactor: 0.8),
                            // style: TextStyle(
                            //     fontWeight: FontWeight.w600, fontSize: 18),
                          ),
                          backgroundColor: Colors.transparent,
                          elevation: 0,
                        ),
                      ),

                      // Search Bar
                      Positioned(
                        top: 120,
                        left: 20,
                        right: 20,
                        child: Container(
                          width: DeviceUtility.getScreenWidth(context),
                          padding: const EdgeInsets.symmetric(horizontal: base),
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(10),
                            color: slate800.withOpacity(0.2),
                          ),
                          child: const Row(
                            children: [
                              const Icon(
                                LineAwesomeIcons.search_solid,
                                size: 28,
                              ),
                              const SizedBox(width: 10),
                              Expanded(
                                child: TextField(
                                  decoration: InputDecoration(
                                    border: InputBorder.none,
                                    hintText: "Search",
                                    hintStyle: const TextStyle(
                                        color: slate600,
                                        fontWeight: FontWeight.w400),
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),

                      // categories
                      Positioned(
                          top: 210,
                          left: 20,
                          right: 20,
                          child: Column(
                            children: [
                              Align(
                                alignment: Alignment.centerLeft,
                                child: Text(
                                  'Popular Categories',
                                  style: Theme.of(context)
                                      .textTheme
                                      .bodyLarge!
                                      .apply(
                                          color: slate800, fontWeightDelta: 2),
                                  textAlign: TextAlign.left,
                                  maxLines: 1,
                                  overflow: TextOverflow.ellipsis,
                                ),
                              ),
                              const SizedBox(
                                height: xs,
                              ),
                              SizedBox(
                                height: 80,
                                child: ListView.builder(
                                  scrollDirection: Axis.horizontal,
                                  itemCount: categories.length,
                                  itemBuilder: (context, index) {
                                    return GestureDetector(
                                      onTap: () {
                                        //TODO: navigate to category page
                                        Get.to(() => SubCategoryScreen(
                                            categoryName:
                                                categories[index].name));
                                      },
                                      child: Container(
                                        margin:
                                            const EdgeInsets.only(right: 20),
                                        child: Column(
                                          children: [
                                            Container(
                                              width: 40,
                                              height: 40,
                                              decoration: BoxDecoration(
                                                borderRadius:
                                                    BorderRadius.circular(10),
                                                color: categories[index].color,
                                              ),
                                              child: Icon(
                                                categories[index].icon,
                                                size: 30,
                                                color: light,
                                              ),
                                            ),
                                            // const SizedBox(height: 10),
                                            SizedBox(
                                              width: 55,
                                              child: Text(
                                                categories[index].name,
                                                style: const TextStyle(
                                                    color: slate600,
                                                    fontWeight: FontWeight.w300,
                                                    fontSize: 12),
                                                maxLines: 1,
                                                overflow: TextOverflow.ellipsis,
                                                textAlign: TextAlign.center,
                                              ),
                                            ),
                                          ],
                                        ),
                                      ),
                                    );
                                  },
                                ),
                              ),
                            ],
                          )),
                    ],
                  ),
                ),
              ),
            ),
            // ProductCardVertical()
            Padding(
              padding: const EdgeInsets.only(
                  left: defaultSize, right: defaultSize, bottom: defaultSize),
              child: Column(
                children: [
                  Align(
                    alignment: Alignment.centerLeft,
                    child: Text("Recent",
                        style: Theme.of(context).textTheme.titleMedium!.apply(
                              color: isDark ? light : slate600,
                            )),
                  ),
                  const SizedBox(
                    height: xs,
                  ),
                  Obx(() {
                    if (productController.isLoading) {
                      return const Center(child: CircularProgressIndicator());
                    }

                    if (productController.products.isEmpty) {
                      return const Center(child: Text("No products found!"));
                    }

                    // Get the most recent 8 products
                    final recentProducts = productController.products.sublist(
                      0,
                      productController.products.length > 8
                          ? 8
                          : productController.products.length,
                    );

                    return GridLayout(
                      itemCount: recentProducts.length,
                      itemBuilder: (_, index) {
                        final product = recentProducts[index];
                        return ProductCardVertical(product: product);
                      },
                    );
                  }),
                  // GridLayout(
                  //   itemCount: 8,
                  //   itemBuilder: (_, index) => ProductCardVertical(),
                  // )
                ],
              ),
            )
          ],
        )));
  }
}

class Category {
  final String name;
  final IconData icon;
  final Color? color;

  const Category({
    required this.name,
    required this.icon,
    this.color,
  });
}

const List<Category> categories = [
  Category(name: "Electronics", icon: LineAwesomeIcons.laptop_solid),
  Category(name: "Books", icon: LineAwesomeIcons.book_solid),
  Category(name: "Accessories", icon: LineAwesomeIcons.camera_solid),
  Category(name: "Clothing", icon: Icons.backpack_outlined),
  Category(name: "Gaming", icon: Icons.gamepad_outlined),
];
