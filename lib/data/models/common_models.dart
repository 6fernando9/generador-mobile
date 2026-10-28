// Common/shared models for KrakenDraw - Manual JSON serialization

/// Pagination metadata
class PaginationMeta {
  final int totalItems;
  final int totalPages;
  final int currentPage;
  final int pageSize;

  const PaginationMeta({
    required this.totalItems,
    required this.totalPages,
    required this.currentPage,
    required this.pageSize,
  });

  factory PaginationMeta.fromJson(Map<String, dynamic> json) {
    return PaginationMeta(
      totalItems: json['totalItems'] as int,
      totalPages: json['totalPages'] as int,
      currentPage: json['currentPage'] as int,
      pageSize: json['pageSize'] as int,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'totalItems': totalItems,
      'totalPages': totalPages,
      'currentPage': currentPage,
      'pageSize': pageSize,
    };
  }

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is PaginationMeta &&
          runtimeType == other.runtimeType &&
          totalItems == other.totalItems &&
          totalPages == other.totalPages &&
          currentPage == other.currentPage &&
          pageSize == other.pageSize;

  @override
  int get hashCode =>
      totalItems.hashCode ^
      totalPages.hashCode ^
      currentPage.hashCode ^
      pageSize.hashCode;

  @override
  String toString() =>
      'PaginationMeta(totalItems: $totalItems, totalPages: $totalPages, currentPage: $currentPage, pageSize: $pageSize)';
}

/// Paginated response wrapper
class PaginatedResponse<T> {
  final List<T> items;
  final PaginationMeta meta;

  const PaginatedResponse({
    required this.items,
    required this.meta,
  });

  factory PaginatedResponse.fromJson(
    Map<String, dynamic> json,
    T Function(Object?) fromJsonT,
  ) {
    return PaginatedResponse(
      items: (json['items'] as List<dynamic>)
          .map((e) => fromJsonT(e))
          .toList(),
      meta: PaginationMeta.fromJson(json['meta'] as Map<String, dynamic>),
    );
  }

  Map<String, dynamic> toJson(Object Function(T) toJsonT) {
    return {
      'items': items.map(toJsonT).toList(),
      'meta': meta.toJson(),
    };
  }

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is PaginatedResponse<T> &&
          runtimeType == other.runtimeType &&
          items == other.items &&
          meta == other.meta;

  @override
  int get hashCode => items.hashCode ^ meta.hashCode;

  @override
  String toString() => 'PaginatedResponse(items: $items, meta: $meta)';
}

/// API Error response
class ApiError {
  final String message;
  final int statusCode;
  final DateTime timestamp;

  const ApiError({
    required this.message,
    required this.statusCode,
    required this.timestamp,
  });

  factory ApiError.fromJson(Map<String, dynamic> json) {
    return ApiError(
      message: json['message'] as String,
      statusCode: json['statusCode'] as int,
      timestamp: DateTime.parse(json['fecha'] as String),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'message': message,
      'statusCode': statusCode,
      'fecha': timestamp.toIso8601String(),
    };
  }

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is ApiError &&
          runtimeType == other.runtimeType &&
          message == other.message &&
          statusCode == other.statusCode &&
          timestamp == other.timestamp;

  @override
  int get hashCode => message.hashCode ^ statusCode.hashCode ^ timestamp.hashCode;

  @override
  String toString() => 'ApiError(message: $message, statusCode: $statusCode, timestamp: $timestamp)';
}