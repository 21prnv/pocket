import 'package:audio_waveforms/audio_waveforms.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:pocket/ui/common/ui_helpers.dart';
import 'package:stacked/stacked.dart';
import 'package:stacked_services/stacked_services.dart';

import 'record_sheet_model.dart';

class RecordSheet extends StackedView<RecordSheetModel> {
  final Function(SheetResponse)? completer;
  final SheetRequest request;
  const RecordSheet({
    Key? key,
    required this.completer,
    required this.request,
  }) : super(key: key);

  @override
  Widget builder(
    BuildContext context,
    RecordSheetModel viewModel,
    Widget? child,
  ) {
    return Container(
      height: MediaQuery.of(context).size.height,
      decoration: const BoxDecoration(
        color: Colors.black,
        borderRadius: BorderRadius.only(
          topLeft: Radius.circular(20),
          topRight: Radius.circular(20),
        ),
      ),
      clipBehavior: Clip.antiAlias,
      child: Column(
        children: [
          Container(
            padding: const EdgeInsets.symmetric(vertical: 90),
            decoration: const BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.only(
                bottomLeft: Radius.circular(20),
                bottomRight: Radius.circular(20),
              ),
            ),
            width: double.infinity,
            child: Center(
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
          Expanded(
            child: Container(
              color: Colors.black,
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
                  verticalSpaceLarge,
                  Text(
                    'New memory',
                    style: GoogleFonts.inter(
                      color: Colors.white,
                      fontSize: 24,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                  verticalSpaceTiny,
                  Text(
                    '00:08.55',
                    style: GoogleFonts.inter(
                      color: Colors.grey,
                      fontSize: 16,
                    ),
                  ),
                  Expanded(
                    child: Row(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        ShaderMask(
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
                        horizontalSpaceSmall,
                        Expanded(
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
                      ],
                    ),
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      const _ControlButton(icon: Icons.format_list_bulleted),
                      horizontalSpaceMedium,
                      _ControlButton(
                        onTap: viewModel.toggleRecording,
                        icon: viewModel.isRecording ? Icons.pause : Icons.mic,
                        isLarge: true,
                      ),
                      horizontalSpaceMedium,
                      _ControlButton(
                        onTap: viewModel.stopRecording,
                        icon: Icons.stop,
                      ),
                    ],
                  ),
                  verticalSpaceMedium,
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text(
                        'Connected',
                        style: GoogleFonts.inter(color: Colors.green),
                      ),
                      Text(
                        ' · 75%',
                        style: GoogleFonts.inter(color: Colors.white),
                      ),
                      const Icon(Icons.battery_full,
                          color: Colors.white, size: 16),
                    ],
                  )
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  @override
  RecordSheetModel viewModelBuilder(BuildContext context) => RecordSheetModel();
}

class _ControlButton extends StatelessWidget {
  final IconData icon;
  final bool isLarge;
  final VoidCallback? onTap;

  const _ControlButton({
    Key? key,
    required this.icon,
    this.isLarge = false,
    this.onTap,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      child: Container(
        padding: EdgeInsets.all(isLarge ? 20 : 15),
        decoration: BoxDecoration(
          shape: BoxShape.circle,
          color: isLarge ? Colors.white : Colors.grey.shade800,
        ),
        child: Icon(
          icon,
          color: isLarge ? Colors.black : Colors.white,
          size: isLarge ? 30 : 20,
        ),
      ),
    );
  }
}
