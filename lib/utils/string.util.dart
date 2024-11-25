import 'package:lukatout/constants/strings.dart';

class StringFormat {
  static String testUrl = "https://kampeni.aads-rdc.org";
  static String prodUrl = 'https://kampeni.injolab.com';
  static String env = "prod";
// static String env = "test";





  static String getUrlByEnv(){
    return env == "test"? testUrl : prodUrl;
  }

  static String truncateWithEllipsisAndSpacesWithoutPTags(
      String text, int maxLength) {
    // Supprimer les balises <p> et </p> du texte
    text =
        text.replaceAll(RegExp(r'<p>'), '').replaceAll(RegExp(r'</p>'), '\n\n');

    if (text.length <= maxLength) {
      return text;
    } else {
      int spaceIndex = text.lastIndexOf(' ', maxLength - 3);
      if (spaceIndex == -1) {
        return text.substring(0, maxLength - 3) + ' ...';
      } else {
        return text.substring(0, spaceIndex) + ' ...';
      }
    }
  }

  static String truncateWithEllipsisAndSpacesWithoutPTagsSound(
      String text, int maxLength) {
    // Supprimer les balises <p> et </p> du texte
    text = text.replaceAll(RegExp(r'<p>'), '').replaceAll(RegExp(r'</p>'), '');

    if (text.length <= maxLength) {
      return text;
    } else {
      int spaceIndex = text.lastIndexOf(' ', maxLength - 3);
      if (spaceIndex == -1) {
        return text.substring(0, maxLength - 3) + '...';
      } else {
        return text.substring(0, spaceIndex) + '...';
      }
    }
  }

  static String photoUrl(String image) {
    String url = getUrlByEnv() + image;
    return url;
  }

  static String addLineBreaks(String text, int maxCharsPerLine) {
    List<String> words = text.split(' '); // Divise le texte en mots
    StringBuffer buffer = StringBuffer();
    int lineLength = 0;

    for (int i = 0; i < words.length; i++) {
      String word = words[i];
      if (lineLength + word.length <= maxCharsPerLine) {
        // Si le mot actuel peut être ajouté sans dépasser la longueur maximale
        if (lineLength > 0) {
          buffer.write(
              ' '); // Ajoute un espace entre les mots si ce n'est pas le premier mot de la ligne
          lineLength++;
        }
        buffer.write(word);
        lineLength += word.length;
      } else {
        buffer.write('\n'); // Ajoute un retour à la ligne
        buffer.write(word);
        lineLength = word.length;
      }
    }
    return buffer.toString();
  }

  static String convertDateFormat(String inputDate) {
    // Créez un objet DateTime à partir de la date d'entrée

    if (inputDate == "") {
      return "";
    } else {
      DateTime dateTime = DateTime.parse(inputDate);

      // Créez une liste des noms de mois abrégés
      List<String> monthNames = [
        "jan",
        "fév",
        "mar",
        "avr",
        "mai",
        "juin",
        "juil",
        "août",
        "sept",
        "oct",
        "nov",
        "déc"
      ];

      // Récupérez le jour, le mois et l'année
      int day = dateTime.day;
      int month = dateTime.month;
      int year = dateTime.year;

      // Créez la date au format "jour mois année"
      String formattedDate = '$day ${monthNames[month - 1]} $year';

      return formattedDate;
    }
  }
}
