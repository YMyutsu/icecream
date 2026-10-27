
import 'dart:math';
import 'package:flutter/material.dart';

void main() {
  runApp(const HanamusubiApp());
}

class HanamusubiApp extends StatelessWidget {
  const HanamusubiApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: '花結び - HANAMUSUBI -',
      theme: ThemeData(
        useMaterial3: true,
        scaffoldBackgroundColor: const Color(0xFFFAF5EF),
        colorScheme: ColorScheme.fromSeed(
          seedColor: const Color(0xFF814B60),
          primary: const Color(0xFF814B60),
          secondary: const Color(0xFF486653),
          surface: const Color(0xFFFFFBF8),
        ),
        appBarTheme: const AppBarTheme(
          backgroundColor: Color(0xFFFAF5EF),
          foregroundColor: Color(0xFF814B60),
          centerTitle: true,
        ),
      ),
      home: const FlowerShopPage(),
    );
  }
}

class FlowerShopPage extends StatefulWidget {
  const FlowerShopPage({super.key});

  @override
  State<FlowerShopPage> createState() => _FlowerShopPageState();
}

class _FlowerShopPageState extends State<FlowerShopPage> {
  // ベースの花束（税抜価格）
  final Map<String, int> bouquets = {
    '🌷 Petit Bouquet': 800,
    '🌹 Merci Bouquet': 1200,
    '🌻 Lumière Bouquet': 1800,
  };

  // 追加できるお花（税抜価格）
  final Map<String, int> extraFlowers = {
    '🌹 バラ': 450,
    '🌷 チューリップ': 300,
    '🌼 ガーベラ': 250,
  };

  late String selectedBouquet = bouquets.keys.first;

  // 選択された追加のお花
  final Set<String> selectedFlowers = {};

  // ラッピング
  String wrapping = '🤍 ベーシック';
  final Map<String, int> wrappingPrices = {
    '🤍 ベーシック': 0,
    '🎀 プレミアム': 150,
  };

  // メッセージカード
  bool messageCard = false;

  // 注文票
  int orderNumber = 0;
  String receipt = '';

  // 色
  final Color roseColor = const Color(0xFF814B60);
  final Color greenColor = const Color(0xFF486653);
  final Color pinkColor = const Color(0xFFF1D5DC);

  // 商品選択用ChoiceChip
  Widget choices(
    Iterable<String> items,
    String selected,
    void Function(String) onChange,
  ) {
    return Wrap(
      spacing: 8,
      runSpacing: 8,
      children: [
        for (final item in items)
          ChoiceChip(
            label: Text(item),
            selected: selected == item,
            selectedColor: pinkColor,
            onSelected: (_) {
              setState(() {
                onChange(item);
              });
            },
          ),
      ],
    );
  }

  // セクションタイトル
  Widget sectionTitle(String title, String subtitle) {
    return Padding(
      padding: const EdgeInsets.only(top: 16, bottom: 8),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            title,
            style: TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.bold,
              color: roseColor,
            ),
          ),
          const SizedBox(height: 4),
          Text(
            subtitle,
            style: const TextStyle(
              fontSize: 12,
              color: Color(0xFF777777),
            ),
          ),
        ],
      ),
    );
  }

  // 金額表示用
  Widget priceRow(String label, int price, {bool bold = false}) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            label,
            style: TextStyle(
              fontWeight: bold ? FontWeight.bold : FontWeight.normal,
              fontSize: bold ? 20 : 14,
            ),
          ),
          Text(
            '¥$price',
            style: TextStyle(
              fontWeight: bold ? FontWeight.bold : FontWeight.normal,
              fontSize: bold ? 24 : 14,
              color: bold ? roseColor : Colors.black87,
            ),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    // 追加のお花の合計
    int flowersTotal = 0;
    for (final flower in selectedFlowers) {
      flowersTotal += extraFlowers[flower]!;
    }

    // 税抜小計
    final int subtotal =
        bouquets[selectedBouquet]! +
        flowersTotal +
        wrappingPrices[wrapping]! +
        (messageCard ? 100 : 0);

    // 消費税10%（1円未満切り捨て）
    final int tax = subtotal ~/ 10;

    // 税込合計
    final int total = subtotal + tax;

    // 花束の絵文字プレビュー
    final String baseEmoji = selectedBouquet.split(' ').first;

    final String addedEmojis = selectedFlowers
        .map((flower) => flower.split(' ').first)
        .join(' ');

    final Widget bouquetPreview = Container(
      width: double.infinity,
      padding: const EdgeInsets.all(24),
      decoration: BoxDecoration(
        color: const Color(0xFFF9EDEB),
        borderRadius: BorderRadius.circular(20),
      ),
      child: Column(
        children: [
          Text(
            '$baseEmoji $addedEmojis 💐',
            textAlign: TextAlign.center,
            style: const TextStyle(fontSize: 55),
          ),
          const SizedBox(height: 10),
          Text(
            selectedBouquet.substring(
              selectedBouquet.indexOf(' ') + 1,
            ),
            style: TextStyle(
              fontSize: 20,
              fontWeight: FontWeight.bold,
              color: roseColor,
            ),
          ),
          const SizedBox(height: 6),
          Text(
            wrapping == '🎀 プレミアム'
                ? '🎀 プレミアムラッピング'
                : '🤍 ベーシックラッピング',
            style: TextStyle(
              color: greenColor,
              fontSize: 13,
            ),
          ),
          if (messageCard)
            const Padding(
              padding: EdgeInsets.only(top: 6),
              child: Text(
                '💌 メッセージカード付き',
                style: TextStyle(fontSize: 13),
              ),
            ),
        ],
      ),
    );

    // ベース花束の選択
    final Widget bouquetChoices = Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        for (final bouquet in bouquets.keys)
          Card(
            color: selectedBouquet == bouquet
                ? const Color(0xFFF8E5E9)
                : Colors.white,
            margin: const EdgeInsets.only(bottom: 8),
            child: ListTile(
              leading: Text(
                bouquet.split(' ').first,
                style: const TextStyle(fontSize: 32),
              ),
              title: Text(
                bouquet.substring(bouquet.indexOf(' ') + 1),
                style: const TextStyle(
                  fontWeight: FontWeight.bold,
                ),
              ),
              subtitle: Text(
                switch (bouquet) {
                  '🌷 Petit Bouquet' => '気軽に贈る小さな花束',
                  '🌹 Merci Bouquet' => 'ありがとうを伝える花束',
                  _ => '特別な日の華やかな花束',
                },
              ),
              trailing: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                mainAxisSize: MainAxisSize.min,
                children: [
                  Text(
                    '¥${bouquets[bouquet]}',
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                      color: roseColor,
                    ),
                  ),
                  if (selectedBouquet == bouquet)
                    Icon(
                      Icons.check_circle,
                      color: roseColor,
                      size: 18,
                    ),
                ],
              ),
              onTap: () {
                setState(() {
                  selectedBouquet = bouquet;
                });
              },
            ),
          ),
      ],
    );

    // 追加のお花の選択
    final Widget flowerChips = Wrap(
      spacing: 8,
      runSpacing: 8,
      children: [
        for (final flower in extraFlowers.keys)
          FilterChip(
            label: Text(
              '$flower  +¥${extraFlowers[flower]}',
            ),
            selected: selectedFlowers.contains(flower),
            selectedColor: pinkColor,
            onSelected: (selected) {
              setState(() {
                if (selected) {
                  selectedFlowers.add(flower);
                } else {
                  selectedFlowers.remove(flower);
                }
              });
            },
          ),
      ],
    );

    // ラッピングの選択
    final Widget wrappingChoices = choices(
      wrappingPrices.keys.map(
        (item) => '$item  +¥${wrappingPrices[item]}',
      ),
      '$wrapping  +¥${wrappingPrices[wrapping]}',
      (item) {
        wrapping = item.substring(0, item.lastIndexOf('  +¥'));
      },
    );

    // メッセージカードの選択
    final Widget messageOption = CheckboxListTile(
      title: const Text('💌 メッセージカード'),
      subtitle: const Text('想いを添えるカード +100円'),
      value: messageCard,
      activeColor: roseColor,
      controlAffinity: ListTileControlAffinity.leading,
      contentPadding: EdgeInsets.zero,
      onChanged: (value) {
        setState(() {
          messageCard = value ?? false;
        });
      },
    );

    // 注文ボタン
    final Widget orderButton = SizedBox(
      width: double.infinity,
      child: FilledButton(
        style: FilledButton.styleFrom(
          backgroundColor: roseColor,
          padding: const EdgeInsets.symmetric(vertical: 16),
        ),
        onPressed: () {
          setState(() {
            orderNumber = Random().nextInt(999) + 1;

            receipt =
                '$selectedBouquet  ¥${bouquets[selectedBouquet]}\n'
                '追加のお花: ${selectedFlowers.isEmpty ? 'なし' : selectedFlowers.join('・')}\n'
                'ラッピング: $wrapping\n'
                'メッセージカード: ${messageCard ? 'あり' : 'なし'}\n'
                '------------------------\n'
                '税抜小計: ¥$subtotal\n'
                '消費税（10%）: ¥$tax\n'
                '税込合計: ¥$total';
          });
        },
        child: const Text(
          '💐 花束を注文する',
          style: TextStyle(fontSize: 17),
        ),
      ),
    );

    // 注文票
    final Widget orderReceipt = orderNumber == 0
        ? const SizedBox.shrink()
        : Card(
            color: Colors.white,
            margin: const EdgeInsets.only(top: 20),
            child: Padding(
              padding: const EdgeInsets.all(20),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    '💌 花結び ご注文票',
                    style: TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                      color: roseColor,
                    ),
                  ),
                  const SizedBox(height: 8),
                  Text('注文番号 #$orderNumber'),
                  const Divider(height: 24),
                  Text(
                    receipt,
                    style: const TextStyle(
                      height: 1.8,
                      fontSize: 14,
                    ),
                  ),
                  const SizedBox(height: 16),
                  Center(
                    child: Text(
                      'あなたの想いが、花とともに届きますように。',
                      style: TextStyle(
                        fontSize: 12,
                        color: greenColor,
                      ),
                    ),
                  ),
                ],
              ),
            ),
          );

    return Scaffold(
      appBar: AppBar(
        title: const Text('💐 花結び - HANAMUSUBI -'),
      ),
      body: Center(
        child: ConstrainedBox(
          constraints: const BoxConstraints(maxWidth: 520),
          child: ListView(
            padding: const EdgeInsets.all(16),
            children: [
              const Center(
                child: Text(
                  'あなたの想いを、一輪ずつ。',
                  style: TextStyle(
                    fontSize: 14,
                    color: Color(0xFF814B60),
                  ),
                ),
              ),

              const SizedBox(height: 16),

              // 花束のプレビュー
              bouquetPreview,

              // ベース花束
              sectionTitle(
                '01 / ベースの花束を選ぶ',
                '贈りたい気持ちに合わせて選んでください',
              ),
              bouquetChoices,

              // 追加のお花
              sectionTitle(
                '02 / お花を追加する',
                '好きなお花を複数選べます（各1本）',
              ),
              flowerChips,

              // ラッピング
              sectionTitle(
                '03 / ラッピングを選ぶ',
                '花束を彩るラッピングを選んでください',
              ),
              wrappingChoices,

              // メッセージカード
              sectionTitle(
                '04 / メッセージを添える',
                '大切な人に気持ちを届けましょう',
              ),
              messageOption,

              const SizedBox(height: 24),
              const Divider(),

              // 金額
              priceRow('税抜小計', subtotal),
              priceRow('消費税（10%）', tax),
              const Divider(),
              priceRow('お支払い合計', total, bold: true),

              const SizedBox(height: 16),

              // 注文ボタン
              orderButton,

              // 注文票
              orderReceipt,

              const SizedBox(height: 30),
            ],
          ),
        ),
      ),
    );
  }
}


