import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:pinch_zoom/pinch_zoom.dart';
import 'package:pinch_zoom_release_unzoom/pinch_zoom_release_unzoom.dart';

import '../controller/pizza_controller.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {

  double _currentScale = 1.0;

  List<TransformationController> transformationControllers = List.generate(50, (_) => TransformationController()); //Pass dynamic length
  List<bool> isTapped = List.generate(50, (_) => false);  //Pass dynamic length
  
  bool blockScroll = false;
  ScrollController scrollController = ScrollController();

  void _zoomIn(int index) {
    setState(() {
      _currentScale += 0.1;
      transformationControllers[index].value = Matrix4.identity()..scale(_currentScale);
    });
  }

  void _zoomOut(int index) {
    setState(() {
      _currentScale -= 0.1;
      transformationControllers[index].value = Matrix4.identity()..scale(_currentScale);
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
                controller: scrollController,
                physics: blockScroll ? const NeverScrollableScrollPhysics() : const BouncingScrollPhysics(),
                    itemCount: controller.recipe.length,
                    itemBuilder: (BuildContext context, int index) {
                      //var getData = controller.recipe.elementAt(index);
                      

                      return Padding(
                        padding: const EdgeInsets.all(20.0),
                        child: Stack(
                          alignment: Alignment.bottomRight,
                          children: [
                            SizedBox(
                              width: 350,
                              height: 350,
                              child: Card(
                                child: InteractiveViewer(
                                  panEnabled: true,
                                  scaleEnabled: true,
                                  transformationController: transformationControllers[index],
                                  maxScale: 3.0,
                                  child: PinchZoomReleaseUnzoomWidget(
                                    resetDuration: const Duration(milliseconds: 10),
                                    fingersRequiredToPinch: 2,
                                    twoFingersOn: () => setState(() => blockScroll = true),
                                    twoFingersOff: () => Future.delayed(
                                      PinchZoomReleaseUnzoomWidget.defaultResetDuration, () => setState(() => blockScroll = false),
                                    ),
                                    child: PinchZoom(
                                      child: CachedNetworkImage(imageUrl: controller.recipe[index].imageUrl,
                                        fit: BoxFit.cover,
                                        progressIndicatorBuilder: (context, url, downloadProgress) => Center(child: CircularProgressIndicator(value: downloadProgress.progress)),
                                        errorWidget: (context, url, error) => const Icon(Icons.error),),
                                    ),
                                  ),
                                ),
                              ),
                            ),
                            Padding(
                              padding: const EdgeInsets.all(8.0),
                              child: Container(
                                alignment: Alignment.bottomRight,
                                child: GestureDetector(
                                  onTap: (){
                                    setState(() {
                                      isTapped[index] = true;
                                    });
                                  },
                                  child: isTapped[index] ? Row(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    children: [
                                      Tooltip(
                                        message: 'Zoom In',
                                        child: Center(
                                          child: ElevatedButton.icon(onPressed: (){
                                            _zoomIn(index);
                                          },
                                            label: const Text(""),
                                            style: ElevatedButton.styleFrom(
                                              backgroundColor: Colors.transparent,
                                              minimumSize: const Size(10, 20)
                                            ),
                                            icon: const Icon(Icons.add, size: 35, color: Colors.white,),),
                                        ),
                                      ),
                                      Tooltip(
                                        message: 'Zoom out',
                                        child: ElevatedButton.icon(onPressed: (){
                                          _currentScale > 1.0 ? _zoomOut(index) : null;
                                        },
                                          label: const Text(""),
                                          style: ElevatedButton.styleFrom(
                                              backgroundColor: Colors.transparent,
                                              minimumSize: const Size(10, 20)
                                          ),
                                          icon: const Icon(Icons.remove, size: 35, color: Colors.white,),),
                                      ),
                                    ],
                                  ) :  Container(
                                    color: Colors.transparent,
                                    child: const Icon(
                                      Icons.zoom_in,
                                      color: Colors.white,
                                      size: 40.0,
                                    ),
                                  ) ,
                                ),
                              ),
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
