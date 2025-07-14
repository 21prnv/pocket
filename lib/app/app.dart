import 'package:pocket/ui/bottom_sheets/notice/notice_sheet.dart';
import 'package:pocket/ui/dialogs/info_alert/info_alert_dialog.dart';
import 'package:pocket/ui/views/home/home_view.dart';
import 'package:pocket/ui/views/startup/startup_view.dart';
import 'package:stacked/stacked_annotations.dart';
import 'package:stacked_services/stacked_services.dart';
import 'package:pocket/ui/bottom_sheets/record/record_sheet.dart';
import 'package:pocket/services/local_storage_service.dart';
// @stacked-import

@StackedApp(
  routes: [
    MaterialRoute(page: HomeView),
    MaterialRoute(page: StartupView),
    // @stacked-route
  ],
  dependencies: [
    LazySingleton(classType: BottomSheetService),
    LazySingleton(classType: DialogService),
    LazySingleton(classType: NavigationService),
    LazySingleton(classType: LocalStorageService),
// @stacked-service
  ],
  bottomsheets: [
    StackedBottomsheet(classType: NoticeSheet),
    StackedBottomsheet(classType: RecordSheet),
    // @stacked-bottom-sheet
  ],
  dialogs: [
    StackedDialog(classType: InfoAlertDialog),
    // @stacked-dialog
  ],
)
class App {}
