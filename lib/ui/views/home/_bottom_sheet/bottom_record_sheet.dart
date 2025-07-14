import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:stacked/stacked.dart';
import 'package:audio_waveforms/audio_waveforms.dart';
import 'package:pocket/ui/common/ui_helpers.dart';
import '../home_viewmodel.dart';
import '../_widgets/control_button.dart';
import '../_widgets/mini_control_button.dart';
import 'dart:math' as math;
import 'dart:ui';

class BottomRecordSheet extends StatefulWidget {
  const BottomRecordSheet({Key? key}) : super(key: key);

  @override
  State<BottomRecordSheet> createState() => _BottomRecordSheetState();
}

class _BottomRecordSheetState extends State<BottomRecordSheet>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  HomeViewModel? _viewModel;

  double get maxHeight => MediaQuery.of(context).size.height;
  double get minHeight => 120;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 400),
    );
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  double lerp(double min, double max) {
    return lerpDouble(min, max, _controller.value) ?? min;
  }

  void toggle() {
    if (_viewModel == null) return;

    final bool isCompleted = _controller.status == AnimationStatus.completed;

    if (isCompleted) {
      _controller.fling(velocity: -1);
      _viewModel!.hideRecordSheet();
    } else {
      _controller.fling(velocity: 1);
      _viewModel!.showRecordSheet(context);
      _viewModel!.toggleRecording();
    }
  }

  void verticalDragUpdate(DragUpdateDetails details) {
    _controller.value -= details.primaryDelta! / maxHeight;
  }

  void verticalDragEnd(DragEndDetails details) {
    if (_controller.isAnimating ||
        _controller.status == AnimationStatus.completed) return;

    if (_viewModel == null) return;

    final double flingVelocity =
        details.velocity.pixelsPerSecond.dy / maxHeight;

    if (flingVelocity < 0) {
      _controller.fling(velocity: math.max(1, -flingVelocity));
      _viewModel!.showRecordSheet(context);
    } else if (flingVelocity > 0) {
      _controller.fling(velocity: math.min(-1, -flingVelocity));
      _viewModel!.hideRecordSheet();
    } else {
      if (_controller.value < 0.3) {
        _controller.fling(velocity: -1);
        _viewModel!.hideRecordSheet();
      } else {
        _controller.fling(velocity: 1);
        _viewModel!.showRecordSheet(context);
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final viewModel = getParentViewModel<HomeViewModel>(context);
    _viewModel = viewModel;

    return AnimatedBuilder(
      animation: _controller,
      builder: (context, child) {
        return Positioned(
          left: 0,
          right: 0,
          bottom: 0,
          height: lerp(minHeight, maxHeight),
          child: GestureDetector(
            onTap: _controller.value < 0.5 ? toggle : null,
            onVerticalDragUpdate: verticalDragUpdate,
            onVerticalDragEnd: verticalDragEnd,
            child: Container(
              decoration: BoxDecoration(
                  color: Colors.black,
                  borderRadius: const BorderRadius.vertical(
                    top: Radius.circular(20),
                  )),
              child: SafeArea(
                top: false,
                child: Stack(
                  children: [
                    if (_controller.value < 1.0)
                      Positioned(
                        left: 0,
                        right: 0,
                        top: lerp(15, -50),
                        child: Opacity(
                          opacity: lerp(1.0, 0.0),
                          child: _buildCollapsedContent(viewModel),
                        ),
                      ),
                    if (_controller.value > 0.0)
                      Positioned(
                        left: 0,
                        right: 0,
                        top: 0,
                        bottom: 0,
                        child: Opacity(
                          opacity: lerp(0.0, 1.0),
                          child: _buildExpandedContent(viewModel),
                        ),
                      ),
                  ],
                ),
              ),
            ),
          ),
        );
      },
    );
  }

  Widget _buildCollapsedContent(HomeViewModel viewModel) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Container(
            width: 40,
            height: 5,
            decoration: BoxDecoration(
              color: Colors.grey.shade700,
              borderRadius: BorderRadius.circular(10),
            ),
          ),
          verticalSpaceMedium,

          // Show recording content if in a recording session (recording OR paused)
          if (viewModel.isRecordingSession)
            _buildRecordingCollapsedContent(viewModel)
          else
            _buildNormalCollapsedContent(viewModel),
        ],
      ),
    );
  }

  Widget _buildNormalCollapsedContent(HomeViewModel viewModel) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Row(
          children: [
            Container(
              height: 50,
              child: Image.asset('assets/images/pocket.png'),
            ),
            horizontalSpaceSmall,
            Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  "Sayan's pocket",
                  style: GoogleFonts.inter(
                      color: Colors.white, fontWeight: FontWeight.bold),
                ),
                Row(
                  children: [
                    Text(
                      'Connected',
                      style: GoogleFonts.inter(color: Colors.green),
                    ),
                    Text(
                      ' · 75%',
                      style: GoogleFonts.inter(color: Colors.white),
                    ),
                    horizontalSpaceTiny,
                    Image.asset('assets/images/battery.png',
                        width: 16, height: 16),
                  ],
                ),
              ],
            )
          ],
        ),
        ElevatedButton.icon(
          onPressed: toggle,
          icon: const Icon(Icons.multitrack_audio),
          label: const Text('Record'),
          style: ElevatedButton.styleFrom(
            foregroundColor: Colors.black,
            backgroundColor: Colors.white,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(30),
            ),
            padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 15),
          ),
        )
      ],
    );
  }

  Widget _buildRecordingCollapsedContent(HomeViewModel viewModel) {
    return Column(
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Container(
              width: 8,
              height: 8,
              decoration: BoxDecoration(
                color: Colors.red,
                shape: BoxShape.circle,
              ),
            ),
            horizontalSpaceTiny,
            Text(
              'Recording',
              style: GoogleFonts.inter(
                color: Colors.white,
                fontWeight: FontWeight.w600,
              ),
            ),
            horizontalSpaceSmall,
            Text(
              viewModel.formattedRecordingTime,
              style: GoogleFonts.inter(
                color: Colors.grey,
                fontSize: 14,
              ),
            ),
          ],
        ),
        verticalSpaceTiny,
        Row(
          children: [
            Container(
              height: 50,
              child: Image.asset('assets/images/pocket.png'),
            ),
            horizontalSpaceSmall,
            Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  "Sayan's pocket",
                  style: GoogleFonts.inter(
                      color: Colors.white, fontWeight: FontWeight.bold),
                ),
                Row(
                  children: [
                    Text(
                      'Connected',
                      style: GoogleFonts.inter(color: Colors.green),
                    ),
                    Text(
                      ' · 75%',
                      style: GoogleFonts.inter(color: Colors.white),
                    ),
                    horizontalSpaceTiny,
                    Image.asset('assets/images/battery.png',
                        width: 16, height: 16),
                  ],
                ),
              ],
            ),
            horizontalSpaceSmall,
            Container(
              height: 40,
              width: 60,
              child: AudioWaveforms(
                size: const Size(double.infinity, 40.0),
                recorderController: viewModel.recorderController,
                waveStyle: const WaveStyle(
                  waveColor: Colors.white,
                  showDurationLabel: false,
                  spacing: 4.0,
                  waveThickness: 2.0,
                  extendWaveform: true,
                  showMiddleLine: false,
                ),
              ),
            ),
            SizedBox(width: 20),
            MiniControlButton(
              onTap: viewModel.toggleRecording,
              image: viewModel.isRecording
                  ? Image.asset('assets/images/pause.png', width: 20)
                  : Image.asset('assets/images/wave.png', width: 20),
              color: Colors.white,
              isLarge: true,
            ),
            SizedBox(width: 20),
            MiniControlButton(
              onTap: viewModel.stopRecording,
              image: Image.asset('assets/images/stop.png', width: 16),
              color: Colors.grey.shade800,
            ),
          ],
        ),
      ],
    );
  }

  Widget _buildExpandedContent(HomeViewModel viewModel) {
    return Column(
      children: [
        Container(
          padding: EdgeInsets.symmetric(vertical: lerp(60, 90)),
          decoration: const BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.only(
              bottomLeft: Radius.circular(20),
              bottomRight: Radius.circular(20),
            ),
          ),
          width: double.infinity,
          child: Center(
            child: GestureDetector(
              onTap: toggle,
              child: RichText(
                text: TextSpan(
                  style: GoogleFonts.inter(color: Colors.black, fontSize: 14),
                  children: [
                    const WidgetSpan(
                      child: Icon(Icons.swipe_down, size: 18),
                      alignment: PlaceholderAlignment.middle,
                    ),
                    const TextSpan(text: ' Swipe down '),
                    TextSpan(
                      text: 'to go home',
                      style: GoogleFonts.inter(color: Colors.grey),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ),
        Expanded(
          child: Container(
            decoration: BoxDecoration(color: Colors.black),
            padding: const EdgeInsets.symmetric(horizontal: 25, vertical: 20),
            child: Column(
              children: [
                Container(
                  width: 40,
                  height: 5,
                  decoration: BoxDecoration(
                    color: Colors.grey.shade700,
                    borderRadius: BorderRadius.circular(10),
                  ),
                ),
                SizedBox(height: lerp(10, 30)),
                Text(
                  'New memory',
                  style: GoogleFonts.inter(
                    color: Colors.white,
                    fontSize: lerp(18, 24),
                    fontWeight: FontWeight.w600,
                  ),
                ),
                verticalSpaceTiny,
                Text(
                  viewModel.formattedRecordingTime,
                  style: GoogleFonts.inter(
                    color: Colors.grey,
                    fontSize: lerp(14, 16),
                  ),
                ),
                Expanded(
                  child: Row(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      Transform.scale(
                        scale: lerp(0.7, 1.0),
                        child: ShaderMask(
                          shaderCallback: (bounds) {
                            return const LinearGradient(
                              begin: Alignment.centerLeft,
                              end: Alignment.centerRight,
                              colors: [
                                Colors.transparent,
                                Colors.black,
                                Colors.black
                              ],
                              stops: [0.0, 0.5, 1.0],
                            ).createShader(bounds);
                          },
                          blendMode: BlendMode.dstIn,
                          child: Image.asset('assets/images/device.png',
                              width: 100),
                        ),
                      ),
                      horizontalSpaceSmall,
                      Expanded(
                        child: Transform.scale(
                          scale: lerp(0.8, 1.0),
                          child: AudioWaveforms(
                            size: const Size(double.infinity, 100.0),
                            recorderController: viewModel.recorderController,
                            waveStyle: const WaveStyle(
                              waveColor: Colors.white,
                              showDurationLabel: false,
                              spacing: 8.0,
                              waveThickness: 4.0,
                              extendWaveform: true,
                              showMiddleLine: false,
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Transform.scale(
                      scale: lerp(0.7, 1.0),
                      child: ControlButton(
                        image:
                            Image.asset('assets/images/segment.png', width: 20),
                      ),
                    ),
                    SizedBox(width: lerp(20, 40)),
                    Transform.scale(
                      scale: lerp(0.8, 1.0),
                      child: ControlButton(
                        onTap: viewModel.toggleRecording,
                        image: viewModel.isRecording
                            ? Image.asset('assets/images/pause.png', width: 20)
                            : Image.asset('assets/images/wave.png', width: 20),
                        isLarge: true,
                      ),
                    ),
                    SizedBox(width: lerp(20, 40)),
                    Transform.scale(
                      scale: lerp(0.7, 1.0),
                      child: ControlButton(
                        onTap: viewModel.stopRecording,
                        image: Image.asset('assets/images/stop.png', width: 20),
                      ),
                    ),
                  ],
                ),
                SizedBox(height: lerp(10, 20)),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(
                      'Connected',
                      style: GoogleFonts.inter(
                        color: Colors.green,
                        fontSize: lerp(12, 14),
                      ),
                    ),
                    Text(
                      ' · 75%',
                      style: GoogleFonts.inter(
                        color: Colors.white,
                        fontSize: lerp(12, 14),
                      ),
                    ),
                    horizontalSpaceTiny,
                    Transform.scale(
                      scale: lerp(0.8, 1.0),
                      child: Image.asset('assets/images/battery.png',
                          width: 16, height: 16),
                    ),
                  ],
                ),
                SizedBox(height: MediaQuery.of(context).padding.bottom),
              ],
            ),
          ),
        ),
      ],
    );
  }
}
