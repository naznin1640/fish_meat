
import 'package:fish_meat/core/constants/colors.dart';
import 'package:fish_meat/features/home/model/response/response_model.dart';
import 'package:flutter/material.dart';

class ReviewCard extends StatelessWidget {
  final Review review;
  const ReviewCard({super.key, required this.review});

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.only(bottom: 10),
      padding: EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(blue: 0.04),
            blurRadius: 8,
            offset: Offset(0, 2)
          )
        ]
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              CircleAvatar(
                radius: 16,
                backgroundColor: ConstantColors.blueClr.withOpacity(0.15),
                child: Icon(Icons.person, size:  18, color: ConstantColors.blueClr,),
              ),
              SizedBox(width: 8,),
              Row(
                children: List.generate(5, (i){
                  return Icon(
                    i < review.rating.floor()
                        ? Icons.star_rounded
                        : Icons.star_outline_rounded,
                    color: const Color(0xFFFFC107),
                    size: 14,
                  );
                }),
              ),
 const SizedBox(width: 4),
              Text(
                review.rating.toStringAsFixed(1),
                style: TextStyle(fontSize: 12, color: const Color(0xFF9E9E9E)),
              ),
            ],
          ),
if (review.review.isNotEmpty) ...[
            const SizedBox(height: 8),
            Text(
              review.review,
              style: TextStyle(
                fontSize: 13,
                color: const Color(0xFF616161),
                height: 1.4,
              ),
            ),
          ],
        ],
      ),
    );
  }
}
