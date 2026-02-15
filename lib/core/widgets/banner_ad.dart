import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:google_mobile_ads/google_mobile_ads.dart';

class BannerAdWidget extends StatefulWidget {
  const BannerAdWidget({super.key});

  @override
  State<BannerAdWidget> createState() => _BannerAdWidgetState();
}

class _BannerAdWidgetState extends State<BannerAdWidget> {
  static const bool isTestMode = bool.fromEnvironment(
    'IS_TEST',
    defaultValue: false,
  );
  BannerAd? _bannerAd;
  late String _id;
  bool _isLoaded = false;
  bool _isError = false;

  @override
  void initState() {
    super.initState();

    _id = kReleaseMode && !isTestMode
        ? dotenv.get('BANNER_AD_UNIT_ID')
        : "ca-app-pub-3940256099942544/6300978111";

    _bannerAd = BannerAd(
      adUnitId: _id,
      size: AdSize.banner,
      request: const AdRequest(),
      listener: BannerAdListener(
        onAdLoaded: (_) {
          if (!mounted) return;
          setState(() {
            _isLoaded = true;
          });
        },
        onAdFailedToLoad: (ad, error) {
          ad.dispose();
          if (!mounted) return;
          setState(() {
            _isError = true;
          });
          debugPrint('BannerAd error: ${error.toString()}');
        },
      ),
    )..load();
  }

  @override
  void dispose() {
    _bannerAd?.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    if (_isError || !_isLoaded) return const SizedBox.shrink();

    return SizedBox(
      height: _bannerAd?.size.height.toDouble(),
      width: _bannerAd?.size.width.toDouble(),
      child: AdWidget(ad: _bannerAd!),
    );
  }
}
