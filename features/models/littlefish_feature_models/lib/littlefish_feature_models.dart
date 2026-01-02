/// Shared domain models package for littlefish merchant app.
///
/// This package contains all common data models organized by domain.
/// Feature packages should depend on this package for shared model definitions.
library littlefish_feature_models;

// Shared models
export 'models/shared/shared.dart';

// Domain-specific models
export 'models/stock/stock.dart';
export 'models/customers/customers.dart';
export 'models/suppliers/suppliers.dart';
export 'models/staff/staff.dart';
export 'models/store/store.dart';
export 'models/settings/settings.dart';
export 'models/tax/tax.dart';
export 'models/billing/billing.dart';
export 'models/expenses/expenses.dart';
export 'models/finance/finance.dart';
export 'models/products/products.dart';
export 'models/promotions/promotions.dart';
export 'models/sales/sales.dart';
export 'models/reports/reports.dart';
export 'models/analysis/analysis.dart';
export 'models/device/device.dart';
export 'models/security/security.dart';
export 'models/permissions/permissions.dart';
export 'models/online/online.dart';
export 'models/workspaces/workspaces.dart';
export 'models/activation/activation.dart';
export 'models/assets/assets.dart';
export 'models/cache/cache.dart';
