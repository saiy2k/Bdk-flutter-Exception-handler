// ignore_for_file: avoid_print

import 'dart:io';

import 'package:flutter/material.dart';
import 'package:bdk_flutter/bdk_flutter.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
        useMaterial3: true,
      ),
      home: const MyHomePage(title: 'Flutter Demo Home Page'),
    );
  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({super.key, required this.title});

  final String title;

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  int _counter = 0;

  Future<(Wallet, Blockchain)> _setupWallet() async {
    final mnemonic = await Mnemonic.fromString(
        'bacon bacon bacon bacon bacon bacon bacon bacon bacon bacon bacon bacon bacon bacon bacon bacon bacon bacon bacon bacon bacon bacon bacon bacon');
    final descriptorSecretKey = await DescriptorSecretKey.create(
        network: Network.testnet, mnemonic: mnemonic);
    final externalDescriptor = await Descriptor.newBip84(
        secretKey: descriptorSecretKey,
        network: Network.testnet,
        keychain: KeychainKind.externalChain);
    final internalDescriptor = await Descriptor.newBip84(
        secretKey: descriptorSecretKey,
        network: Network.testnet,
        keychain: KeychainKind.internalChain);
    final blockchain = await Blockchain.create(
        config: const BlockchainConfig.electrum(
            config: ElectrumConfig(
                stopGap: 10,
                timeout: 5,
                retry: 5,
                url: "ssl://electrum.blockstream.info:60002",
                validateDomain: true)));
    final wallet = await Wallet.create(
        descriptor: externalDescriptor,
        changeDescriptor: internalDescriptor,
        network: Network.testnet,
        databaseConfig: const DatabaseConfig.memory());
    final _ = await wallet.sync(blockchain: blockchain);

    return (wallet, blockchain);
  }

  void _incrementCounter() async {
    try {
      print('Init');
      final (bdkWallet, blockchain) = await _setupWallet();
      print('Created wallett');

      TxBuilder builder = TxBuilder();
      final bdkAddress = await Address.fromString(
          s: 'tb1q5sw2pcpz2trxv37fvnx0lgjwkedtvagypmejy4',
          network: Network.testnet);
      final script = await bdkAddress.scriptPubkey();
      final txBuilderResult =
          await builder.feeRate(0).addRecipient(script, 900).finish(bdkWallet);
      final psbt = txBuilderResult.$1;

      // final signingWallet =
      //     (await initializePrivateWallet(seed)) as BitcoinWallet;

      final successfulSigning = await bdkWallet.sign(psbt: psbt);

      if (successfulSigning == false) {
        throw Exception('Failed to sign transaction');
      }

      final broadcastTx = await psbt.extractTx();

      await blockchain.broadcast(transaction: broadcastTx);
    } on HexException catch (e) {
      print('HexException');
      print(e);
    } on KeyException catch (e) {
      print('KeyException');
      print(e);
    } on RpcException catch (e) {
      print('RpcException');
      print(e);
    } on JsonException catch (e) {
      print('JsonException');
      print(e);
    } on PsbtException catch (e) {
      print('PsbtException');
      print(e);
    } on SledException catch (e) {
      print('SledException');
      print(e);
    } on Bip32Exception catch (e) {
      print('Bip32Exception');
      print(e);
    } on Bip39Exception catch (e) {
      print('Bip39Exception');
      print(e);
    } on EncodeException catch (e) {
      print('EncodeException');
      print(e);
    } on SignerException catch (e) {
      print('SignerException');
      print(e);
    } on AddressException catch (e) {
      print('AddressException');
      print(e);
    } on EsploraException catch (e) {
      print('EsploraException');
      print(e);
    } on GenericException catch (e) {
      print('GenericException');
      print(e);
    } on ElectrumException catch (e) {
      print('ElectrumException');
      print(e);
    } on RusqliteException catch (e) {
      print('RusqliteException');
      print(e);
    } on FeeTooLowException catch (e) {
      print('FeeTooLowException');
      print(e);
    } on PsbtParseException catch (e) {
      print('PsbParseException');
      print(e);
    } on Secp256k1Exception catch (e) {
      print('Secp256k1Exception');
      print(e);
    } on DescriptorException catch (e) {
      print('DescriptorException');
      print(e);
    } on MiniscriptException catch (e) {
      print('MiniScriptException');
      print(e);
    } on InvalidByteException catch (e) {
      print('InvalidByteException');
      print(e);
    } on UnknownUtxoException catch (e) {
      print('UnknownUtxoException');
      print(e);
    } on InvalidInputException catch (e) {
      print('InvalidInputException');
      print(e);
    } on NoRecipientsException catch (e) {
      print('NoRecipientsException');
      print(e);
    } on VerificationException catch (e) {
      print('KeyException');
      print(e);
    } on FeeRateTooLowException catch (e) {
      print('FeeRateTooLowException');
      print(e);
    } on InvalidNetworkException catch (e) {
      print('InvalidNetworkException');
      print(e);
    } on MiniscriptPsbtException catch (e) {
      print('MiniscriptPsbtException');
      print(e);
    } on ProgressUpdateException catch (e) {
      print('ProgressUpdateException');
      print(e);
    } on BnBNoExactMatchException catch (e) {
      print('BnBNoExactMatchException');
      print(e);
    } on InvalidLockTimeException catch (e) {
      print('InvalidLockTimeException');
      print(e);
    } on InvalidOutpointException catch (e) {
      print('InvalidOutpointException');
      print(e);
    } on NoUtxosSelectedException catch (e) {
      print('NoUtxosSelectedException');
      print(e);
    } on ChecksumMismatchException catch (e) {
      print('ChecksumMismatchException');
      print(e);
    } on MissingKeyOriginException catch (e) {
      print('MissingKeyOriginException');
      print(e);
    } on InsufficientFundsException catch (e) {
      print('InsufficientFundsException');
      print(e);
    } on InvalidPolicyPathException catch (e) {
      print('InvalidPolicyPathException');
      print(e);
    } on FeeRateUnavailableException catch (e) {
      print('FeeRateUnavailableException');
      print(e);
    } on InvalidTransactionException catch (e) {
      print('InvalidTransactionException');
      print(e);
    } on TransactionNotFoundException catch (e) {
      print('TransactionNotFoundException');
      print(e);
    } on InvalidProgressValueException catch (e) {
      print('InvalidProgressValueException');
      print(e);
    } on MissingCachedScriptsException catch (e) {
      print('MissingCachedScriptsException');
      print(e);
    } on OutputBelowDustLimitException catch (e) {
      print('OutputBelowDustLimitException');
      print(e);
    } on TransactionConfirmedException catch (e) {
      print('TransactionConfirmedException');
      print(e);
    } on BnBTotalTriesExceededException catch (e) {
      print('BnBTotalTriesExceededException');
      print(e);
    } on SpendingPolicyRequiredException catch (e) {
      print('SpendPolicyRequiredException');
      print(e);
    } on IrreplaceableTransactionException catch (e) {
      print('IrreplaceableTransactionException');
      print(e);
    } on ScriptDoesntHaveAddressFormException catch (e) {
      print('ScriptDoesntHaveAddressFormException');
      print(e);
    } on Exception catch (e) {
      print('Exception');
      print(e);
    } catch (e) {
      print('final catch');
      print(e);
    }
  }

  @override
  Widget build(BuildContext context) {
    // This method is rerun every time setState is called, for instance as done
    // by the _incrementCounter method above.
    //
    // The Flutter framework has been optimized to make rerunning build methods
    // fast, so that you can just rebuild anything that needs updating rather
    // than having to individually change instances of widgets.
    return Scaffold(
      appBar: AppBar(
        // TRY THIS: Try changing the color here to a specific color (to
        // Colors.amber, perhaps?) and trigger a hot reload to see the AppBar
        // change color while the other colors stay the same.
        backgroundColor: Theme.of(context).colorScheme.inversePrimary,
        // Here we take the value from the MyHomePage object that was created by
        // the App.build method, and use it to set our appbar title.
        title: Text(widget.title),
      ),
      body: Center(
        // Center is a layout widget. It takes a single child and positions it
        // in the middle of the parent.
        child: Column(
          // Column is also a layout widget. It takes a list of children and
          // arranges them vertically. By default, it sizes itself to fit its
          // children horizontally, and tries to be as tall as its parent.
          //
          // Column has various properties to control how it sizes itself and
          // how it positions its children. Here we use mainAxisAlignment to
          // center the children vertically; the main axis here is the vertical
          // axis because Columns are vertical (the cross axis would be
          // horizontal).
          //
          // TRY THIS: Invoke "debug painting" (choose the "Toggle Debug Paint"
          // action in the IDE, or press "p" in the console), to see the
          // wireframe for each widget.
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            const Text(
              'You have pushed the button this many times:',
            ),
            Text(
              '$_counter',
              style: Theme.of(context).textTheme.headlineMedium,
            ),
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: _incrementCounter,
        tooltip: 'Increment',
        child: const Icon(Icons.add),
      ), // This trailing comma makes auto-formatting nicer for build methods.
    );
  }
}
