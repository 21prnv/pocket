import 'package:flutter/material.dart';
import 'package:pocket/ui/common/ui_helpers.dart';
import 'package:stacked/stacked.dart';

import 'home_viewmodel.dart';
import '_widgets/top_bar.dart';
import '_widgets/filter_chips.dart';
import '_widgets/conversations_header.dart';
import '_widgets/calendar.dart';
import '_widgets/conversation_date_header.dart';
import '_widgets/conversation_list.dart';
import '_bottom_sheet/bottom_record_sheet.dart';

class HomeView extends StackedView<HomeViewModel> {
  const HomeView({Key? key}) : super(key: key);

  @override
  Widget builder(BuildContext context, HomeViewModel viewModel, Widget? child) {
    return Scaffold(
      backgroundColor: Colors.black,
      body: Stack(
        children: [
          Container(
            margin: const EdgeInsets.only(bottom: 120),
            decoration: const BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.only(
                bottomLeft: Radius.circular(20),
                bottomRight: Radius.circular(20),
              ),
            ),
            child: SafeArea(
              child: Padding(
                padding: const EdgeInsets.only(top: 20),
                child: Column(
                  children: [
                    // Top Bar
                    const Padding(
                      padding: EdgeInsets.only(left: 25.0, right: 25.0),
                      child: TopBar(),
                    ),
                    verticalSpaceMedium,

                    const FilterChips(),
                    verticalSpaceMedium,

                    const Padding(
                      padding: EdgeInsets.only(left: 25.0, right: 25.0),
                      child: ConversationsHeader(),
                    ),
                    verticalSpaceMedium,

                    Calendar(
                      selectedDate: viewModel.selectedDate,
                      onDateChange: viewModel.onDateChange,
                    ),
                    verticalSpaceMedium,

                    Padding(
                      padding: const EdgeInsets.only(left: 25.0, right: 25.0),
                      child: ConversationDateHeader(
                        selectedDate: viewModel.selectedDate,
                        conversationCount: viewModel.conversations.length,
                      ),
                    ),
                    verticalSpaceMedium,

                    Expanded(
                      child: Padding(
                        padding: const EdgeInsets.only(left: 25.0, right: 25.0),
                        child: AnimatedSwitcher(
                          duration: const Duration(milliseconds: 350),
                          child: PageView.builder(
                            key: ValueKey(viewModel.selectedDate.month),
                            controller: viewModel.pageController,
                            onPageChanged: viewModel.onPageChanged,
                            itemBuilder: (context, index) {
                              final date = DateTime(2022, 1, 1)
                                  .add(Duration(days: index));
                              final conversations = viewModel.conversations;
                              return ConversationList(
                                key: ValueKey(date),
                                conversations: conversations,
                              );
                            },
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
          Positioned(
            left: 0,
            right: 0,
            bottom: 0,
            child: const BottomRecordSheet(),
          ),
        ],
      ),
    );
  }

  @override
  HomeViewModel viewModelBuilder(BuildContext context) => HomeViewModel();
}
