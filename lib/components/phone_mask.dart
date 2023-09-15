class PhoneMask {
  String setMask(String phone) {
    var formatted = phone.replaceAll(RegExp(r'[^0-9]'), '');

    switch (formatted.length) {
      case 1:
        return '+7 ';
      case 2:
        return '+${formatted[0]} (${formatted[1]}';
      case 3:
        return '+${formatted[0]} (${formatted[1]}${formatted[2]}';
      case 4:
        return formatted.length == 4 && phone.contains(')')
            ? '+${formatted[0]} (${formatted[1]}${formatted[2]}'
            : formatted.length == 2 && phone.contains('(')
                ? '+${formatted[0]} '
                : '+${formatted[0]} (${formatted[1]}${formatted[2]}${formatted[3]}) ';
      case 5:
        return '+${formatted[0]} (${formatted[1]}${formatted[2]}${formatted[3]}) ${formatted[4]}';
      case 6:
        return '+${formatted[0]} (${formatted[1]}${formatted[2]}${formatted[3]}) ${formatted[4]}${formatted[5]}';
      case 7:
        return '+${formatted[0]} (${formatted[1]}${formatted[2]}${formatted[3]}) ${formatted[4]}${formatted[5]}${formatted[6]}';
      case 8:
        return '+${formatted[0]} (${formatted[1]}${formatted[2]}${formatted[3]}) ${formatted[4]}${formatted[5]}${formatted[6]}-${formatted[7]}';
      case 9:
        return '+${formatted[0]} (${formatted[1]}${formatted[2]}${formatted[3]}) ${formatted[4]}${formatted[5]}${formatted[6]}-${formatted[7]}${formatted[8]}';
      case 10:
        return '+${formatted[0]} (${formatted[1]}${formatted[2]}${formatted[3]}) ${formatted[4]}${formatted[5]}${formatted[6]}-${formatted[7]}${formatted[8]}-${formatted[9]}';
      case 11:
        return '+${formatted[0]} (${formatted[1]}${formatted[2]}${formatted[3]}) ${formatted[4]}${formatted[5]}${formatted[6]}-${formatted[7]}${formatted[8]}-${formatted[9]}${formatted[10]}';
      default:
        return '';
    }
  }
}
