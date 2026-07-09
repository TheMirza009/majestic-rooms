import 'package:flutter/material.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:majestic_rooms/core/theme/custom_colors.dart';
import 'package:majestic_rooms/core/data/models/hotel_room.dart';
import 'package:majestic_rooms/core/utils/currency_format.dart';
import 'package:majestic_rooms/root/modules/hotel/screens/image_viewer_screen.dart';
import 'package:majestic_rooms/root/modules/hotel/widgets/image_carousel.dart';
class RoomCard extends StatelessWidget {
  final HotelRoom room;
  final String? hotelImageUrl;
  final int quantity;
  final VoidCallback onIncrement;
  final VoidCallback onDecrement;

  const RoomCard({
    super.key,
    required this.room,
    this.hotelImageUrl,
    required this.quantity,
    required this.onIncrement,
    required this.onDecrement,
  });

  @override
  Widget build(BuildContext context) {
    final bool isSelected = quantity > 0;
    return GestureDetector(
      onTap: quantity == 0 ? onIncrement : null,
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 250),
        curve: Curves.easeInOut,
        margin: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 10.0),
        decoration: BoxDecoration(
          color: CustomColors.cardSubtleBg,
          borderRadius: BorderRadius.circular(24),
          border: Border.all(
            color: isSelected ? CustomColors.brandRed : Colors.transparent,
            width: 2,
          ),
          boxShadow: [
            if (isSelected)
              BoxShadow(
                color: CustomColors.brandRed.withOpacity(0.15),
                blurRadius: 16,
                offset: const Offset(0, 8),
              ),
            if (!isSelected)
              BoxShadow(
                color: Colors.black.withOpacity(0.1),
                blurRadius: 10,
                offset: const Offset(0, 4),
              ),
          ],
        ),
        child: ClipRRect(
          borderRadius: BorderRadius.circular(22),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              // IMAGE
              AspectRatio(
                aspectRatio: 16 / 9,
                child: ImageCarousel(
                  images: (room.images != null && room.images!.isNotEmpty)
                      ? room.images!.map((e) => e.url).toList()
                      : [
                          hotelImageUrl ??
                              'https://images.unsplash.com/photo-1611892440504-42a792e24d32?q=80&w=600&auto=format&fit=crop'
                        ],
                  heroTagPrefix: 'room_${room.id ?? room.hashCode}',
                  onImageTap: (index) {
                    final urls = (room.images != null && room.images!.isNotEmpty)
                        ? room.images!.map((e) => e.url).toList()
                        : [
                            hotelImageUrl ??
                                'https://images.unsplash.com/photo-1611892440504-42a792e24d32?q=80&w=600&auto=format&fit=crop'
                          ];
                    Navigator.push(
                      context,
                      PageRouteBuilder(
                        pageBuilder: (context, animation, secondaryAnimation) {
                          return ImageViewerScreen(
                            imageUrls: urls,
                            initialIndex: index,
                            heroTagPrefix: 'room_${room.id ?? room.hashCode}',
                          );
                        },
                        transitionsBuilder: (context, animation, secondaryAnimation, child) {
                          return FadeTransition(opacity: animation, child: child);
                        },
                      ),
                    );
                  },
                ),
              ),
                
              // DETAILS
              Padding(
                padding: const EdgeInsets.all(20.0),
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    // INFO
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            room.name ?? room.category?.name ?? "Standard Room",
                            style: const TextStyle(
                              fontSize: 20,
                              fontWeight: FontWeight.bold,
                              color: CustomColors.textMain,
                              height: 1.2,
                            ),
                          ),
                          const SizedBox(height: 8),
                          
                          Row(
                            children: [
                              if (room.beds != null) ...[
                                const Icon(
                                  Icons.king_bed_outlined,
                                  size: 18,
                                  // color: CustomColors.textLight,
                                ),
                                const SizedBox(width: 6),
                                Text(
                                  "${room.beds} Bed${room.beds! > 1 ? 's' : ''}",
                                  style: const TextStyle(
                                    fontSize: 14,
                                    // color: CustomColors.textLight,
                                    fontWeight: FontWeight.w500,
                                  ),
                                ),
                                const SizedBox(width: 16),
                              ],
                              if (room.roomNumber != null) ...[
                                const Icon(
                                  Icons.tag_rounded,
                                  size: 16,
                                  // color: CustomColors.textLight,
                                ),
                                const SizedBox(width: 4),
                                Text(
                                  room.roomNumber!,
                                  style: const TextStyle(
                                    fontSize: 14,
                                    // color: CustomColors.textLight,
                                    fontWeight: FontWeight.w500,
                                  ),
                                ),
                              ],
                            ],
                          ),
                          
                          // CHIPS
                          if (room.category != null || room.cityView == true)
                            Padding(
                              padding: const EdgeInsets.only(top: 8.0),
                              child: Wrap(
                                spacing: 6,
                                children: [
                                  if (room.category != null)
                                    Builder(
                                      builder: (context) {
                                        final bool isStandard = room.category?.isStandard ?? true;
                                        return Chip(
                                          label: Text(
                                            room.category!.name,
                                            style: TextStyle(
                                              fontSize: 11,
                                              color: isStandard 
                                                  ? CustomColors.primaryDark 
                                                  : CustomColors.premiumAmber,
                                            ),
                                          ),
                                          backgroundColor: isStandard 
                                              ? CustomColors.borderColor.withOpacity(0.85)
                                              : CustomColors.premiumAmber.withOpacity(0.15),
                                          side: BorderSide(
                                            color: isStandard 
                                                ? CustomColors.textMuted.withOpacity(0.5)  
                                                : CustomColors.premiumAmber,
                                            width: 0.8,
                                          ),
                                          padding: const EdgeInsets.symmetric(horizontal: 4),
                                          visualDensity: VisualDensity.compact,
                                        );
                                      }
                                    ),
                                  if (room.cityView == true) 
                                    Chip(
                                      label: const Text('City View', style: TextStyle(fontSize: 11, color: CustomColors.premiumAmber)),
                                      backgroundColor: CustomColors.premiumAmber.withOpacity(0.15),
                                      side: const BorderSide(color: CustomColors.premiumAmber, width: 0.8),
                                      padding: const EdgeInsets.symmetric(horizontal: 4),
                                      visualDensity: VisualDensity.compact,
                                    ),
                                ],
                              ),
                            ),
                            
                          // DESCRIPTION
                          Padding(
                            padding: const EdgeInsets.only(top: 8.0, right: 10),
                            child: Text(
                              room.description?.trim().isNotEmpty == true
                                  ? room.description!
                                  : 'No information given',
                              style: TextStyle(
                                fontSize: 13,
                                color: CustomColors.textMuted,
                                fontStyle: room.description?.trim().isNotEmpty == true
                                    ? FontStyle.normal
                                    : FontStyle.italic,
                              ),
                              maxLines: 3,
                              overflow: TextOverflow.ellipsis,
                            ),
                          ),
                          
                          const SizedBox(height: 16),
                          
                          // PRICE
                          Row(
                            crossAxisAlignment: CrossAxisAlignment.baseline,
                            textBaseline: TextBaseline.alphabetic,
                            children: [
                              Text(
                                formatPrice(room.pricePerNight),
                                style: const TextStyle(
                                  fontSize: 22,
                                  fontWeight: FontWeight.w900,
                                  color: CustomColors.brandRed,
                                ),
                              ),
                              const Text(
                                " / night",
                                style: TextStyle(
                                  fontSize: 13,
                                  color: CustomColors.textMuted,
                                  fontWeight: FontWeight.w600,
                                ),
                              ),
                            ],
                          ),
                          // BREAKFAST PRICE
                          if (room.pricePerNightWithBreakfast != null)
                            Padding(
                              padding: const EdgeInsets.only(top: 4.0),
                              child: Text(
                                'With breakfast: ${formatPrice(room.pricePerNightWithBreakfast!)} / night',
                                style: TextStyle(fontSize: 12, color: CustomColors.textMuted.withOpacity(0.8)),
                              ),
                            ),
                        ],
                      ),
                    ),
                    
                    // SELECTION STEPPER
                    Container(
                      decoration: BoxDecoration(
                        color: CustomColors.surfaceWhite,
                        borderRadius: BorderRadius.circular(30),
                        border: Border.all(
                          color: isSelected ? CustomColors.brandRed : CustomColors.borderColor.withOpacity(0.5),
                          width: 1.5,
                        ),
                      ),
                      padding: const EdgeInsets.symmetric(horizontal: 4, vertical: 4),
                      child: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          GestureDetector(
                            onTap: onDecrement,
                            child: Container(
                              width: 32,
                              height: 32,
                              decoration: BoxDecoration(
                                shape: BoxShape.circle,
                                color: isSelected ? CustomColors.brandRed.withOpacity(0.1) : CustomColors.surfaceWhite,
                              ),
                              child: Icon(
                                isSelected && quantity == 1 ? Icons.delete_outline : Icons.remove,
                                size: 18,
                                color: isSelected ? CustomColors.brandRed : CustomColors.hintColor,
                              ),
                            ),
                          ),
                          SizedBox(
                            width: 32,
                            child: Text(
                              quantity.toString(),
                              textAlign: TextAlign.center,
                              style: TextStyle(
                                fontSize: 16,
                                fontWeight: FontWeight.bold,
                                color: isSelected ? CustomColors.textMain : CustomColors.hintColor,
                              ),
                            ),
                          ),
                          GestureDetector(
                            onTap: onIncrement,
                            child: Container(
                              width: 32,
                              height: 32,
                              decoration: BoxDecoration(
                                shape: BoxShape.circle,
                                color: CustomColors.brandRed,
                              ),
                              child: const Icon(
                                Icons.add,
                                size: 18,
                                color: Colors.white,
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
