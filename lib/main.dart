import 'dart:math';
import 'package:flutter/material.dart';
import 'package:fl_chart/fl_chart.dart';

void main() => runApp(const FaunaPricerApp());

const Color faunaPurple = Color(0xFF6A1B9A); // фиолетовый акцент
const Color bgWhite = Colors.white;
const Color textBlack = Colors.black;

class FaunaPricerApp extends StatelessWidget {
  const FaunaPricerApp({super.key});
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'FaunaPricer',
      theme: ThemeData(
        scaffoldBackgroundColor: bgWhite,
        primaryColor: faunaPurple,
        colorScheme: ColorScheme.fromSeed(seedColor: faunaPurple),
        elevatedButtonTheme: ElevatedButtonThemeData(
          style: ElevatedButton.styleFrom(
            backgroundColor: faunaPurple,
            foregroundColor: bgWhite,
            minimumSize: const Size.fromHeight(44),
            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
          ),
        ),
        inputDecorationTheme: InputDecorationTheme(
          border: OutlineInputBorder(borderRadius: BorderRadius.circular(8)),
        ),
        textTheme: const TextTheme(bodyMedium: TextStyle(color: textBlack)),
      ),
      home: const HomePage(),
      debugShowCheckedModeBanner: false,
    );
  }
}

class HomePage extends StatefulWidget {
  const HomePage({super.key});
  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  final _formKey = GlobalKey<FormState>();
  final _sCtrl = TextEditingController(text: '100');
  final _kCtrl = TextEditingController(text: '100');
  final _sigmaCtrl = TextEditingController(text: '20'); // в %
  final _tCtrl = TextEditingController(text: '1'); // по умолчанию 1 год
  final _rCtrl = TextEditingController(text: '0.15'); // ставка ЦБ ~15%
  String _timeUnit = 'Годы'; // 'Годы' | 'Месяцы' | 'Дни (календарные)'
  bool _isCall = true;

  // Результаты
  double? price;
  double? delta;
  double? gamma;
  double? vegaPerPct; // на 1% (sigma в пунктах)
  double? thetaPerYear;
  double? thetaPerDay;

  List<FlSpot> priceSpots = [];

  @override
  void dispose() {
    _sCtrl.dispose();
    _kCtrl.dispose();
    _sigmaCtrl.dispose();
    _tCtrl.dispose();
    _rCtrl.dispose();
    super.dispose();
  }

  double? _parse(String s) {
    try {
      return double.parse(s.replaceAll(',', '.'));
    } catch (e) {
      return null;
    }
  }

  void _calculate() {
    if (!_formKey.currentState!.validate()) return;

    final double S = _parse(_sCtrl.text)!;
    final double K = _parse(_kCtrl.text)!;
    final double sigmaPct = _parse(_sigmaCtrl.text)!; // в %
    final double sigma = sigmaPct / 100.0; // в долях
    final double rawT = _parse(_tCtrl.text)!;
    final double r = _parse(_rCtrl.text)!;

    double T;
    if (_timeUnit == 'Годы') T = rawT;
    else if (_timeUnit == 'Месяцы') T = rawT / 12.0;
    else T = rawT / 365.0; // календарные дни

    final bs = BlackScholes.priceAndGreeks(S: S, K: K, r: r, sigma: sigma, T: T, isCall: _isCall);
    final double rawVega = bs.vega; // чувствительность на 1.0 = 100%-пункт
    setState(() {
      price = bs.price;
      delta = bs.delta;
      gamma = bs.gamma;
      vegaPerPct = rawVega / 100.0; // на 1 процентный пункт
      thetaPerYear = bs.theta;
      thetaPerDay = bs.theta / 365.0;
      _buildChart(S, K, r, sigma, T);
    });
  }

  void _buildChart(double S, double K, double r, double sigma, double T) {
    final double left = max(0.01, S * 0.5);
    final double right = S * 1.5;
    final int points = 60;
    final step = (right - left) / (points - 1);
    final List<FlSpot> sp = [];
    for (int i = 0; i < points; i++) {
      final sVal = left + i * step;
      final p = BlackScholes.price(S: sVal, K: K, r: r, sigma: sigma, T: T, isCall: _isCall).price;
      sp.add(FlSpot(sVal, p));
    }
    priceSpots = sp;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('FaunaPricer — Оценка опционов'),
        backgroundColor: faunaPurple,
        elevation: 0,
      ),
      body: Padding(
        padding: const EdgeInsets.all(14),
        child: Column(crossAxisAlignment: CrossAxisAlignment.stretch, children: [
          Card(
            elevation: 2,
            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
            child: Padding(
              padding: const EdgeInsets.all(12),
              child: Form(
                key: _formKey,
                child: Column(crossAxisAlignment: CrossAxisAlignment.stretch, children: [
                  Row(children: [
                    Expanded(child: _numberField(controller: _sCtrl, label: 'S — цена базы (₽)')),
                    const SizedBox(width: 10),
                    Expanded(child: _numberField(controller: _kCtrl, label: 'K — страйк (₽)')),
                  ]),
                  const SizedBox(height: 10),
                  Row(children: [
                    Expanded(child: _numberField(controller: _sigmaCtrl, label: 'σ — волатильность (%)')),
                    const SizedBox(width: 10),
                    Expanded(child: _numberField(controller: _tCtrl, label: 'T — значение')),
                  ]),
                  const SizedBox(height: 10),
                  Row(children: [
                    Expanded(
                      child: DropdownButtonFormField<String>(
                        value: _timeUnit,
                        items: const [
                          DropdownMenuItem(value: 'Годы', child: Text('Годы')),
                          DropdownMenuItem(value: 'Месяцы', child: Text('Месяцы')),
                          DropdownMenuItem(value: 'Дни (календарные)', child: Text('Дни (календарные)')),
                        ],
                        onChanged: (v) => setState(() => _timeUnit = v!),
                        decoration: const InputDecoration(labelText: 'Единицы времени'),
                      ),
                    ),
                    const SizedBox(width: 10),
                    Expanded(child: _numberField(controller: _rCtrl, label: 'r — ставка (в дес.)')),
                  ]),
                  const SizedBox(height: 8),
                  Row(children: [
                    ToggleButtons(
                      isSelected: [_isCall, !_isCall],
                      onPressed: (i) => setState(() => _isCall = i == 0),
                      borderRadius: BorderRadius.circular(8),
                      selectedColor: bgWhite,
                      fillColor: faunaPurple,
                      children: const [Padding(padding: EdgeInsets.symmetric(horizontal: 14, vertical: 8), child: Text('Call')), Padding(padding: EdgeInsets.symmetric(horizontal: 14, vertical: 8), child: Text('Put'))],
                    ),
                    const Spacer(),
                    SizedBox(
                      width: 160,
                      child: ElevatedButton(onPressed: _calculate, child: const Text('Рассчитать')),
                    )
                  ]),
                  const SizedBox(height: 6),
                  const Text('Волатильность вводите в % (напр. 20 → 20%). Ставка r — в долях (напр. 0.15 → 15%).', style: TextStyle(fontSize: 12, color: Colors.black54)),
                ]),
              ),
            ),
          ),
          const SizedBox(height: 12),
          if (price != null) _resultCard(),
          const SizedBox(height: 10),
          if (priceSpots.isNotEmpty) _chartCard(),
          const SizedBox(height: 8),
          Expanded(child: Container()), // чтобы элементы сверху не слипались
        ]),
      ),
    );
  }

  Widget _numberField({required TextEditingController controller, required String label}) {
    return TextFormField(
      controller: controller,
      keyboardType: const TextInputType.numberWithOptions(decimal: true, signed: false),
      decoration: InputDecoration(labelText: label),
      validator: (v) {
        if (v == null || v.trim().isEmpty) return 'Обязательное поле';
        final val = _parse(v);
        if (val == null) return 'Неверное число';
        if (!val.isFinite) return 'Неверное число';
        return null;
      },
    );
  }

  Widget _resultCard() {
    return Card(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      child: Padding(
        padding: const EdgeInsets.all(12),
        child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
          const Text('Результаты', style: TextStyle(fontWeight: FontWeight.bold)),
          const SizedBox(height: 8),
          Text('Цена опциона: ${price!.toStringAsFixed(2)} ₽', style: const TextStyle(fontSize: 16)),
          const SizedBox(height: 8),
          Wrap(spacing: 18, children: [
            Text('Δ (Delta): ${delta!.toStringAsFixed(6)}'),
            Text('Γ (Gamma): ${gamma!.toStringAsFixed(6)}'),
            Text('Vega (на 1%): ${vegaPerPct!.toStringAsFixed(4)} ₽'),
            Text('Theta (в год): ${thetaPerYear!.toStringAsFixed(4)} ₽'),
            Text('Theta (в день): ${thetaPerDay!.toStringAsFixed(4)} ₽'),
          ]),
        ]),
      ),
    );
  }

  Widget _chartCard() {
    final minX = priceSpots.first.x;
    final maxX = priceSpots.last.x;
    final minY = priceSpots.map((s) => s.y).reduce(min);
    final maxY = priceSpots.map((s) => s.y).reduce(max);
    return Card(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      child: Padding(
        padding: const EdgeInsets.all(10),
        child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
          const Text('График: цена опциона в зависимости от S', style: TextStyle(fontWeight: FontWeight.bold)),
          const SizedBox(height: 8),
          SizedBox(
            height: 220,
            child: LineChart(
              LineChartData(
                minX: minX,
                maxX: maxX,
                minY: minY - (maxY - minY) * 0.1,
                maxY: maxY + (maxY - minY) * 0.1,
                titlesData: FlTitlesData(
                  leftTitles: AxisTitles(sideTitles: SideTitles(showTitles: true, reservedSize: 48)),
                  bottomTitles: AxisTitles(sideTitles: SideTitles(showTitles: true)),
                ),
                gridData: FlGridData(show: true),
                lineBarsData: [
                  LineChartBarData(
                    spots: priceSpots,
                    isCurved: true,
                    barWidth: 2.2,
                    dotData: FlDotData(show: false),
                    color: faunaPurple,
                  )
                ],
              ),
            ),
          ),
        ]),
      ),
    );
  }
}

/// --- Black-Scholes implementation ---
class BSResult {
  final double price, delta, gamma, vega, theta;
  BSResult(this.price, this.delta, this.gamma, this.vega, this.theta);
}

class BlackScholes {
  static const double sqrt2 = 1.4142135623730951;

  static double _erf(double z) {
    final t = 1.0 / (1.0 + 0.5 * z.abs());
    final tau = t *
        exp(-z * z -
            1.26551223 +
            1.00002368 * t +
            0.37409196 * pow(t, 2) +
            0.09678418 * pow(t, 3) -
            0.18628806 * pow(t, 4) +
            0.27886807 * pow(t, 5) -
            1.13520398 * pow(t, 6) +
            1.48851587 * pow(t, 7) -
            0.82215223 * pow(t, 8) +
            0.17087277 * pow(t, 9));
    return z >= 0 ? 1 - tau : tau - 1;
  }

  static double _cdf(double x) => 0.5 * (1 + _erf(x / sqrt2));

  static BSResult priceAndGreeks({required double S, required double K, required double r, required double sigma, required double T, required bool isCall}) {
    if (S <= 0 || K <= 0 || sigma <= 0 || T <= 0) {
      final intrinsic = isCall ? max(0.0, S - K) : max(0.0, K - S);
      return BSResult(intrinsic, 0, 0, 0, 0);
    }
    final d1 = (log(S / K) + (r + 0.5 * sigma * sigma) * T) / (sigma * sqrt(T));
    final d2 = d1 - sigma * sqrt(T);
    final Nd1 = _cdf(d1);
    final Nd2 = _cdf(d2);
    final n_d1 = exp(-0.5 * d1 * d1) / sqrt(2 * pi);

    double price = isCall ? S * Nd1 - K * exp(-r * T) * Nd2 : K * exp(-r * T) * _cdf(-d2) - S * _cdf(-d1);
    double delta = isCall ? Nd1 : Nd1 - 1;
    double gamma = n_d1 / (S * sigma * sqrt(T));
    double vega = S * n_d1 * sqrt(T); // на 1.0 = 100%-пункт
    double theta = isCall
        ? - (S * n_d1 * sigma) / (2 * sqrt(T)) - r * K * exp(-r * T) * Nd2
        : - (S * n_d1 * sigma) / (2 * sqrt(T)) + r * K * exp(-r * T) * _cdf(-d2);

    return BSResult(price, delta, gamma, vega, theta);
  }

  static BSResult price({required double S, required double K, required double r, required double sigma, required double T, required bool isCall}) {
    return priceAndGreeks(S: S, K: K, r: r, sigma: sigma, T: T, isCall: isCall);
  }
}
