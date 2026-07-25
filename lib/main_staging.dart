import 'package:Product_Catalogue_Application/boostrap.dart';

import 'app/view/view.dart';
import 'utils/utils.dart';

void main() {
  bootstrap(() => const ProductCatalogueApp(),
      environment: AppEnvironment.staging);
}
