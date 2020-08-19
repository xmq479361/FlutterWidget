import 'package:quicklibs/quicklibs.dart';

// formatDate(DateTime date) {
//   return Time.format(date, FORMAT_YMDHM);
// }

const FORMAT_YMDHM = "yyyy-MM-dd HH:mm";
const FORMAT_YMD = "yyyy-MM-dd";
const FORMAT_MDHM = "MM-dd HH:mm";
const FORMAT_HM = "HH:mm";
formatDate(DateTime date, [String format = FORMAT_YMDHM]) {
  return Time.format(date, format);
}
