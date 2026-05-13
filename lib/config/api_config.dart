class ApiConfig {
  static const String backendDomain = String.fromEnvironment(
    'DOMAIN_BACKEND',
    defaultValue: 'https://web-klks.vercel.app',
  );

  static String get baseUrl {
    final sanitizedDomain = backendDomain.endsWith('/')
        ? backendDomain.substring(0, backendDomain.length - 1)
        : backendDomain;
    return '$sanitizedDomain/api';
  }
}
