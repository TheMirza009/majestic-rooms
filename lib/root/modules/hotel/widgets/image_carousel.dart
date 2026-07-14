import 'package:majestic_rooms/core/theme/custom_colors.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:majestic_rooms/core/theme/theme_context_extension.dart';
import 'package:majestic_rooms/root/widgets/round_icon_button.dart';

class ImageCarousel extends StatefulWidget {
  final List<String> images;
  final String? heroTagPrefix;
  final void Function(int index)? onImageTap;

  const ImageCarousel({
    super.key,
    required this.images,
    this.heroTagPrefix,
    this.onImageTap,
  });

  @override
  State<ImageCarousel> createState() => _ImageCarouselState();
}

class _ImageCarouselState extends State<ImageCarousel> {
  late final PageController _pageController;
  int _currentIndex = 0;

  @override
  void initState() {
    super.initState();
    _pageController = PageController();
  }

  @override
  void dispose() {
    _pageController.dispose();
    super.dispose();
  }

  void _nextPage() {
    if (_currentIndex < widget.images.length - 1) {
      _pageController.nextPage(
        duration: const Duration(milliseconds: 300),
        curve: Curves.easeInOut,
      );
    }
  }

  void _prevPage() {
    if (_currentIndex > 0) {
      _pageController.previousPage(
        duration: const Duration(milliseconds: 300),
        curve: Curves.easeInOut,
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    if (widget.images.isEmpty) {
      return Container(
        height: 300,
        color: CustomColors.cardSubtleBg,
        child: Icon(Icons.broken_image, size: 50, color: context.hintColor),
      );
    }

    if (widget.images.length == 1) {
      Widget image = CachedNetworkImage(
        imageUrl: widget.images.first,
        width: double.infinity,
        fit: BoxFit.fitWidth,
        alignment: Alignment.topCenter,
        errorWidget: (context, url, error) => Container(
          height: 300,
          width: double.infinity,
          color: CustomColors.cardSubtleBg,
          child: Icon(Icons.broken_image, size: 50, color: context.hintColor),
        ),
      );

      if (widget.heroTagPrefix != null) {
        image = Hero(
          tag: '${widget.heroTagPrefix}_${widget.images.first}',
          child: image,
        );
      }

      return GestureDetector(
        onTap: widget.onImageTap != null ? () => widget.onImageTap!(0) : null,
        child: image,
      );
    }

    return AspectRatio(
      aspectRatio: 1.3,
      child: Stack(
        alignment: Alignment.center,
        children: [
          PageView.builder(
            controller: _pageController,
            itemCount: widget.images.length,
            onPageChanged: (index) {
              setState(() {
                _currentIndex = index;
              });
            },
            itemBuilder: (context, index) {
              Widget image = CachedNetworkImage(
                imageUrl: widget.images[index],
                width: double.infinity,
                fit: BoxFit.cover,
                errorWidget: (context, url, error) => Container(
                  color: CustomColors.cardSubtleBg,
                  child: Icon(
                    Icons.broken_image,
                    size: 50,
                    color: context.hintColor,
                  ),
                ),
              );

              if (widget.heroTagPrefix != null) {
                image = Hero(
                  tag: '${widget.heroTagPrefix}_${widget.images[index]}',
                  child: image,
                );
              }

              return GestureDetector(
                onTap: widget.onImageTap != null
                    ? () => widget.onImageTap!(index)
                    : null,
                child: image,
              );
            },
          ),
          if (_currentIndex > 0)
            PositionedDirectional(
              start: 16.0,
              child: RoundIconButton(
                size: 40,
                backgroundColor: const Color.fromARGB(40, 0, 0, 0),
                icon: Icon(
                  Icons.arrow_back_ios_new_rounded,
                  color: context.textLightColor,
                  size: 18,
                ),
                onTap: _prevPage,
              ),
            ),
          if (_currentIndex < widget.images.length - 1)
            PositionedDirectional(
              end: 16.0,
              child: RoundIconButton(
                size: 40,
                backgroundColor: const Color.fromARGB(40, 0, 0, 0),
                icon: Icon(
                  Icons.arrow_forward_ios_rounded,
                  color: context.textLightColor,
                  size: 18,
                ),
                onTap: _nextPage,
              ),
            ),
          Positioned(
            bottom: 16.0,
            child: AnimatedBuilder(
              animation: _pageController,
              builder: (context, _) {
                final page = _pageController.hasClients
                    ? (_pageController.page ?? _currentIndex.toDouble())
                    : _currentIndex.toDouble();

                return Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: List.generate(widget.images.length, (index) {
                    final progress = (page - index).abs().clamp(0.0, 1.0);

                    return Container(
                      margin: const EdgeInsets.symmetric(horizontal: 4.0),
                      width: 16.0 - (progress * 10.0),
                      height: 6.0,
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(3.0),
                        color: context.surfaceColor.withOpacity(
                          1.0 - (progress * 0.5),
                        ),
                      ),
                    );
                  }),
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}
