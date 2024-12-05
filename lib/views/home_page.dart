import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:pinch_zoom/pinch_zoom.dart';

import '../controller/pizza_controller.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {

  final TransformationController _transformationController = TransformationController();
  double _currentScale = 1.0;

  void _zoomIn() {
    setState(() {
      _currentScale += 0.1;
      _transformationController.value = Matrix4.identity()..scale(_currentScale);
    });
  }

  void _zoomOut() {
    setState(() {
      _currentScale -= 0.1;
      _transformationController.value = Matrix4.identity()..scale(_currentScale);
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: const Text("Display Images Api"),
          centerTitle: true,
        ),
        body: GetBuilder<PizzaController>(
          init: PizzaController(),
          builder: (PizzaController controller) {
            return Padding(
              padding: const EdgeInsets.all(8.0),
              child: ListView.builder(
                    physics: const BouncingScrollPhysics(),
                    itemCount: controller.recipe.length,
                    itemBuilder: (BuildContext context, int index) {
                      var getData = controller.recipe[index];
                      return Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Stack(
                          alignment: Alignment.bottomRight,
                          children: [
                            SizedBox(
                              width: 350,
                              height: 350,
                              child: Card(
                                child: InteractiveViewer(
                                  transformationController: _transformationController,
                                  minScale: 0.5,
                                  maxScale: 3.0,
                                  child: PinchZoom(
                                    maxScale: 2.5,
                                    child: CachedNetworkImage(imageUrl: controller.recipe.elementAt(index).imageUrl,
                                        fit: BoxFit.cover,
                                        progressIndicatorBuilder: (context, url, downloadProgress) => Center(child: CircularProgressIndicator(value: downloadProgress.progress)),
                                        errorWidget: (context, url, error) => const Icon(Icons.error),),
                                  ),
                                ),
                              ),
                            ),
                            GestureDetector(
                                onTap: (){
                                   controller.isTapped();
                                },
                                child: controller.isTappedImage.value ? Row(
                                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                  children: [
                                    GestureDetector(onTap: _zoomIn,
                                      child: const Icon(Icons.zoom_in, size: 40,),),

                                    GestureDetector(onTap: _zoomOut,
                                      child: const Icon(Icons.zoom_out, size: 40,),),

                                    GestureDetector(onTap: (){
                                      controller.isTapped();
                                    }, child: const Icon(Icons.hide_image, size: 40,),
                                    )
                                  ],
                                ) :  const Opacity(
                                  opacity: 0.5,
                                    child: Icon((Icons.zoom_in), size: 40,)) ,
                              )
                          ],
                        ),
                      );
                    },
                  )
            );
          },
        )
    );
  }
}
