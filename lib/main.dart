import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_redux/flutter_redux.dart';
import 'package:streampay/pages/create_wallet.dart';
import 'package:streampay/pages/import_wallet.dart';
import 'package:streampay/pages/manage_accounts.dart';
import 'package:streampay/pages/new_wallet.dart';
import 'package:streampay/pages/pages.dart';
import 'package:streampay/pages/passphrase.dart';
import 'package:streampay/pages/password.dart';
import 'package:streampay/pages/pay.dart';
import 'package:streampay/pages/pin_code.dart';
import 'package:streampay/pages/receive.dart';
import 'package:streampay/pages/send.dart';
import 'package:streampay/pages/splash.dart';
import 'package:streampay/pages/my_wallet.dart';
import 'package:worker_manager/worker_manager.dart';
import 'state/store.dart' show AppState, StateWrapper, createStore;
// import 'pages/home.dart';
import 'pages/home_sub.dart';
import 'pages/account_selection.dart';

main() async {
  LicenseRegistry.addLicense(() async* {
    final license = await rootBundle.loadString('fonts/OFL.txt');
    yield LicenseEntryWithLineBreaks(['fonts'], license);
  });

  await Executor().warmUp();
  StateWrapper store = await createStore();
  runApp(App(store));
}

class App extends StatelessWidget {
  final StateWrapper store;
  late String initialRoute = '/splash';

  App(this.store) {
    /*
     * If there isn't any account created yet, then launch Getting Started Page
     */
    if (store.state.accounts.length == 0) {
      // this.initialRoute = '/account_selection';
      this.initialRoute = '/splash';
    }
  }

  @override
  Widget build(BuildContext context) {
    return StoreProvider<AppState>(
      store: this.store,
      child: MaterialApp(
        title: 'StreamPay',
        theme: ThemeData(
          primarySwatch: Colors.blue,
        ),
        initialRoute: this.initialRoute,
        routes: {
          '/nav': (context) => PagesWidget(store: this.store,),
          '/splash': (context) => SplashPage(),
          '/home': (context) => HomeSubPage(
            store: this.store,
          ),
          '/PinCode': (context) => PinCodeWidget(),
          '/Password': (context) => PasswordWidget(),
          '/Passphrase': (context) => PassphraseWidget(),
          '/account_selection': (context) =>
              AccountSelectionPage(store: this.store),
          '/Receive': (context) => ReceiveWidget(store: this.store),
          '/Send': (context) => SendWidget(store: this.store),
          '/Pay': (context) => PayWidget(store: this.store),
          '/watch_address': (context) => WatchAddress(store: this.store),
          '/new_wallet': (context) => NewWallet(store: this.store),
          '/create_wallet': (context) => CreateWallet(store: this.store),
          '/import_wallet': (context) => ImportWallet(store: this.store),
          // '/manage_accounts': (context) =>
          //     ManageAccountsPage(store: this.store),
        },
      ),
    );
  }
}
