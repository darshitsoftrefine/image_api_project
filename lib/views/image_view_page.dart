import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';

class ImageViewPage extends StatefulWidget {
  final String imageUrl;
  const ImageViewPage({super.key, required this.imageUrl});

  @override
  State<ImageViewPage> createState() => _ImageViewPageState();
}

class _ImageViewPageState extends State<ImageViewPage> {

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
        title: const Text("Image View Page"),
      ),
      body: Center(
        child: InteractiveViewer(
            transformationController: _transformationController,
            minScale: 0.5,
            maxScale: 3.0,
            child: CachedNetworkImage(imageUrl: widget.imageUrl, fit: BoxFit.fill,)),
      ),
      floatingActionButton: Row(
        mainAxisAlignment: MainAxisAlignment.end,
        children: [
          ElevatedButton(onPressed: _zoomIn,
            style: ElevatedButton.styleFrom(
              minimumSize: const Size(100, 50)
            ), child: const Icon(Icons.zoom_in, size: 50,),),

          ElevatedButton(onPressed: _currentScale > 1.0 ? _zoomOut : null,
            style: ElevatedButton.styleFrom(
                minimumSize: const Size(100, 50)
            ), child: const Icon(Icons.zoom_out, size: 50,),),
        ],
      ),
    );
  }
}
