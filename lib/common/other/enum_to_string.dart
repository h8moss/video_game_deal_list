class EnumToString {
  static String enumToString(String originalEnum) =>
      originalEnum.split('.').skip(1).join('.');

  static String enumToCamelCaseString(String originalEnum) =>
      enumToString(originalEnum)
          .splitMapJoin(RegExp('[A-Z]|^\w'),
              onMatch: (v) => ' ${v.group(0)?.toUpperCase() ?? ''}')
          .trim();
}
