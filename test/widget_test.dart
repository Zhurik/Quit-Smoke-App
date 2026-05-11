import 'package:flutter_test/flutter_test.dart';
import 'package:quitsmoke/comps/cigaratte.dart';

void main() {
  test('Cigaratte calculates saved money correctly', () {
    final c = Cigaratte(
      dailyCigarattes: 20,
      pricePerCigaratte: 1.0,
      startDate: DateTime.now().subtract(Duration(days: 1)),
    );
    expect(c.getSavedMoney, closeTo(20.0, 0.1));
    expect(c.getsavedCigarattes, closeTo(20.0, 0.1));
  });

  test('Cigaratte day percentage is between 0 and 100', () {
    final c = Cigaratte(
      dailyCigarattes: 10,
      pricePerCigaratte: 0.5,
      startDate: DateTime.now().subtract(Duration(hours: 12)),
    );
    expect(c.getdayPercentage, inInclusiveRange(0, 100));
  });
}
