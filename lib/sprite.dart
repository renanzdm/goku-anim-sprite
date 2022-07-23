import 'dart:ui' as ui;

import 'package:flutter/widgets.dart';

class Sprite extends StatefulWidget {
  final ImageProvider image;
  final int frameWidth;
  final int frameHeight;
  final num frame;

  const Sprite(
      {Key? key,
      required this.image,
      required this.frameWidth,
      required this.frameHeight,
      this.frame = 0})
      : super(key: key);

  @override
  _SpriteState createState() => _SpriteState();
}

class _SpriteState extends State<Sprite> {
  ImageStream? _imageStream;
  ImageInfo? _imageInfo;

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    _getImage();
  }

  @override
  void didUpdateWidget(Sprite oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (widget.image != oldWidget.image) {
      _getImage();
    }
  }

  void _getImage() {
    final ImageStream? oldImageStream = _imageStream;
    _imageStream = widget.image.resolve(createLocalImageConfiguration(context));
    if (_imageStream?.key == oldImageStream?.key) {
      return;
    }
    final ImageStreamListener listener = ImageStreamListener(_updateImage);
    oldImageStream?.removeListener(listener);
    _imageStream?.addListener(listener);
  }

  void _updateImage(ImageInfo imageInfo, bool synchronousCall) {
    setState(() {
      _imageInfo = imageInfo;
    });
  }

  @override
  void dispose() {
    _imageStream?.removeListener(ImageStreamListener(_updateImage));
    super.dispose();
  }

  Rect _buildFramesAnimation(ui.Image image, {bool multiRows = false}) {
    ///size total image asset
    int widthTotalImage = image.width;

    ///current frame image
    int frameImage = widget.frame.round();

    ///width frame cut
    int frameWidth = widget.frameWidth;

    ///height frame cut
    int frameHeight = widget.frameHeight;

    ///quantity columns has image total
    int cols = (widthTotalImage / frameWidth).floor();

    ///get column
    int col = frameImage % cols;

    ///whats row
    int row = 0;

    ///if image has multiLine
    if (multiRows) {
      row = (frameImage / cols).floor();
    }

    ///multiple for 1.0. Int for double
    return ui.Rect.fromLTWH(col * frameWidth * 1.0, row * frameHeight * 1.0,
        frameWidth * 1.0, frameHeight * 1.0);
  }

  @override
  Widget build(BuildContext context) {
    ui.Image? img = _imageInfo?.image;
    if (img == null) {
      return const SizedBox();
    }
    return CustomPaint(
        painter: _SpritePainter(img, _buildFramesAnimation(img)));
  }
}

class _SpritePainter extends CustomPainter {
  ui.Image image;
  ui.Rect rect;

  _SpritePainter(this.image, this.rect);

  @override
  void paint(Canvas canvas, Size size) {
    canvas.drawImageRect(image, rect,
        ui.Rect.fromLTWH(0.0, 0.0, size.width, size.height), Paint());
  }

  @override
  bool shouldRepaint(_SpritePainter oldPainter) {
    return oldPainter.image != image || oldPainter.rect != rect;
  }
}
