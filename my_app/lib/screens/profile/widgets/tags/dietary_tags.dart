// import 'package:flutter/material.dart';
// import '../../screens/profile_tag_page.dart';
// import 'manage_tags_popup.dart';

// class TagsSection extends StatefulWidget {
//   const TagsSection({super.key});

//   @override
//   State<TagsSection> createState() => _TagsSectionState();
// }

// class _TagsSectionState extends State<TagsSection>
//     with SingleTickerProviderStateMixin {
//   bool isExpanded = true;
//   int selectedTab = 0;

//   // =====================================================
//   // PRESET TAGS (FOR NOW...)
//   // =====================================================
//   final List<String> dietaryOptions = [
//     "Vegan",
//     "Vegetarian",
//     "Halal",
//     "Kosher",
//     "Gluten-Free",
//     "Dairy-Free",
//     "Keto",
//     "Pescatarian",
//   ];

//   final List<String> interestOptions = [
//     "Cooking",
//     "Baking",
//     "Fitness",
//     "Meal Prep",
//     "Travel",
//   ];

//   // =====================================================
//   // CUSTOM TAG STORAGE (FOR NOW...)
//   // =====================================================
//   List<String> customDietaryTags = [];
//   List<String> customInterestTags = [];

//   // =====================================================
//   // SELECTED TAGS
//   // =====================================================
//   List<String> dietaryTags = [];
//   List<String> interestTags = [];

//   List<String> get currentSelected =>
//       selectedTab == 0 ? dietaryTags : interestTags;

//   List<String> get currentOptions => selectedTab == 0
//       ? [...dietaryOptions, ...customDietaryTags]
//       : [...interestOptions, ...customInterestTags];

//   // =====================================================
//   // ADD CUSTOM TAG
//   // =====================================================
//   void _addTag(String tag) {
//     setState(() {
//       if (selectedTab == 0) {
//         if (!customDietaryTags.contains(tag)) {
//           customDietaryTags.add(tag);
//           dietaryTags.add(tag);
//         }
//       } else {
//         if (!customInterestTags.contains(tag)) {
//           customInterestTags.add(tag);
//           interestTags.add(tag);
//         }
//       }
//     });
//   }

//   // =====================================================
//   // POPUP FOR MANAGE TAGS
//   // =====================================================
//   void _openManageTagsPopup() async {
//     final result = await showModalBottomSheet<List<String>>(
//       context: context,
//       isScrollControlled: true,
//       shape: const RoundedRectangleBorder(
//         borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
//       ),
//       builder: (_) =>
//           ManageTagsPopup(options: currentOptions, selected: currentSelected),
//     );

//     if (result != null) {
//       setState(() {
//         if (selectedTab == 0) {
//           dietaryTags = result;

//           // remove unselected custom tags
//           customDietaryTags.removeWhere((tag) => !dietaryTags.contains(tag));
//         } else {
//           interestTags = result;

//           customInterestTags.removeWhere((tag) => !interestTags.contains(tag));
//         }
//       });
//     }
//   }

//   // =====================================================
//   // SHOW TAG OPTIONS (ADD CUSTOM TAG / MANAGE TAGS)
//   // =====================================================
//   void _showAddTagDialog() {
//     showModalBottomSheet(
//       context: context,
//       shape: const RoundedRectangleBorder(
//         borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
//       ),
//       builder: (context) {
//         return SafeArea(
//           child: Padding(
//             padding: const EdgeInsets.all(16),
//             child: Column(
//               mainAxisSize: MainAxisSize.min,
//               children: [
//                 const Text(
//                   "Tag Options",
//                   style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
//                 ),
//                 const SizedBox(height: 12),

//                 ListTile(
//                   leading: const Icon(Icons.add_circle_outline),
//                   title: const Text("Create Custom Tag"),
//                   subtitle: const Text("Make your own tag"),
//                   onTap: () async {
//                     Navigator.pop(context);

//                     final result = await Navigator.push(
//                       context,
//                       MaterialPageRoute(
//                         builder: (_) =>
//                             CustomTagPage(existingTags: currentOptions),
//                       ),
//                     );

//                     if (result != null && result is String) {
//                       _addTag(result);
//                     }
//                   },
//                 ),

//                 const Divider(),

//                 ListTile(
//                   leading: const Icon(Icons.settings),
//                   title: const Text("Manage Tags"),
//                   subtitle: const Text("Select your tags"),
//                   onTap: () {
//                     Navigator.pop(context);
//                     _openManageTagsPopup();
//                   },
//                 ),
//               ],
//             ),
//           ),
//         );
//       },
//     );
//   }

//   // =====================================================
//   // UI
//   // =====================================================
//   @override
//   Widget build(BuildContext context) {
//     return Container(
//       width: double.infinity,
//       margin: const EdgeInsets.symmetric(horizontal: 12),
//       padding: const EdgeInsets.all(12),
//       decoration: BoxDecoration(
//         color: Colors.grey[100],
//         borderRadius: BorderRadius.circular(16),
//       ),
//       child: Column(
//         crossAxisAlignment: CrossAxisAlignment.start,
//         children: [
//           Row(
//             mainAxisAlignment: MainAxisAlignment.spaceBetween,
//             children: [
//               Expanded(child: _buildToggleTabs()),
//               GestureDetector(
//                 onTap: () {
//                   setState(() {
//                     isExpanded = !isExpanded;
//                   });
//                 },
//                 child: AnimatedRotation(
//                   duration: const Duration(milliseconds: 250),
//                   turns: isExpanded ? 0.0 : 0.5,
//                   child: const Icon(Icons.keyboard_arrow_up),
//                 ),
//               ),
//             ],
//           ),

//           AnimatedSize(
//             duration: const Duration(milliseconds: 250),
//             curve: Curves.easeInOut,
//             child: isExpanded
//                 ? Padding(
//                     padding: const EdgeInsets.only(top: 12),
//                     child: _buildTags(),
//                   )
//                 : const SizedBox.shrink(),
//           ),
//         ],
//       ),
//     );
//   }

//   // =====================================================
//   // BUIiD TOGGLE TABS (DIETARY / INTERESTS)
//   // =====================================================
//   Widget _buildToggleTabs() {
//     return Container(
//       height: 36,
//       decoration: BoxDecoration(
//         color: Colors.grey[300],
//         borderRadius: BorderRadius.circular(20),
//       ),
//       child: Row(
//         children: [
//           _buildToggleButton("Dietary", 0),
//           _buildToggleButton("Interests", 1),
//         ],
//       ),
//     );
//   }

//   // =====================================================
//   // BUILD TOGGLE BUTTONS (TAGS FOR SELECTION)
//   // =====================================================
//   Widget _buildToggleButton(String title, int index) {
//     final isSelected = selectedTab == index;

//     return Expanded(
//       child: GestureDetector(
//         onTap: () {
//           setState(() {
//             selectedTab = index;
//             isExpanded = true;
//           });
//         },
//         child: AnimatedContainer(
//           duration: const Duration(milliseconds: 200),
//           alignment: Alignment.center,
//           decoration: BoxDecoration(
//             color: isSelected ? Colors.green : Colors.transparent,
//             borderRadius: BorderRadius.circular(20),
//           ),
//           child: Text(
//             title,
//             style: TextStyle(
//               fontWeight: FontWeight.bold,
//               color: isSelected ? Colors.white : Colors.black87,
//             ),
//           ),
//         ),
//       ),
//     );
//   }

//   // =====================================================
//   // BUILD TAGS
//   // =====================================================
//   Widget _buildTags() {
//     final tags = currentSelected;

//     return Wrap(
//       spacing: 8,
//       runSpacing: 8,
//       children: [
//         ...tags.map((tag) {
//           return Chip(
//             label: Text(tag),
//             backgroundColor: Colors.grey[300],
//             labelStyle: const TextStyle(color: Colors.black),
//             shape: RoundedRectangleBorder(
//               borderRadius: BorderRadius.circular(12),
//             ),
//             side: BorderSide.none,
//           );
//         }),

//         GestureDetector(
//           onTap: _showAddTagDialog,
//           child: Chip(
//             label: const Icon(Icons.add, size: 18, color: Colors.green),
//             backgroundColor: Colors.green.shade100,
//             shape: RoundedRectangleBorder(
//               borderRadius: BorderRadius.circular(12),
//             ),
//             side: BorderSide.none,
//             elevation: 0,
//           ),
//         ),
//       ],
//     );
//   }
// }
