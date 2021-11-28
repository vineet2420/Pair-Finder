import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:ipair/ActivityFlow/preset_activity_buttons.dart';

class Constants {

  Image logoAsset = Image.asset('assets/images/logo.png', fit: BoxFit.fill);

  // Auth
  String emailPlaceholder = 'Email';
  String passwordPlaceholder = 'Password';

  String forgotPasswordButtonText = 'Forgot Password';
  String signInButtonText = 'Sign In';

  String createAccountText = 'Don\'t have an account?';
  String signUpButtonText = 'Sign Up';

  MaterialColor themeColor = Colors.indigo;

  String userStorageKey = 'userStorage';

  String host = 'http://ec2-18-234-104-49.compute-1.amazonaws.com:8000';
  //String host = 'http://10.0.2.2:8000';
  //String host = 'http://127.0.0.1:8000';
  //String host = 'http://127.0.0.1:5000';

  List<PresetActivityButtons> icons = [
    PresetActivityButtons('🍽', 'Let\'s Grab Food!'),
    PresetActivityButtons('🍿', 'Let\'s go to the movies!'),
    PresetActivityButtons('🚵‍', 'Let\'s go biking!'),
    PresetActivityButtons('📚', 'Let\'s study!'),
    PresetActivityButtons('🗺', 'Let\'s go hiking!'),
    PresetActivityButtons('🍳', 'Let\'s cook!'),
    PresetActivityButtons('🎨', 'Let\'s paint!'),
    PresetActivityButtons('🎭', 'Let\'s attend a show!'),
    PresetActivityButtons('🎤', 'Let\'s do karaoke!'),
    PresetActivityButtons('💻‍‍', 'Let\'s build something cool!'),
    PresetActivityButtons('🎮', 'Let\'s play games!'),
    PresetActivityButtons('♛', 'Let\'s play chess!'),
    PresetActivityButtons('🛍', 'Let\'s go shopping!'),
    PresetActivityButtons('🚙', 'Let\'s go driving!'),
    PresetActivityButtons('🍻', 'Let\'s grab drinks!'),
    PresetActivityButtons('🛥', 'Let\'s go boating!'),
  ];

  Map<String, List<String>> emojiMap = {
    "🍽":["food", "dining", "fastfood", "fast-food"],
    "🍿":["movies", "movie", "watch", "popcorn"],
    "🚵":["bike", "biking", "hiking"],
    "📚":["study", "books", "stuyding"],
    "🗺":["travel", "explore", "exploring", "travelling"],
    "🍳":["cook", "cooking", "food", "make-food"],
    "🎨":["paint", "painting", "art", "paint brush"],
    "🎭":["festival", "concert", "show"],
    "🎤":["singing", "sing", "karaoke"],
    "💻":["computer", "coding", "cs", "computer", "science", "app"],
    "🎮":["games", "gaming"],
    "♛":["chess"],
    "🛍":["shopping", "shop"],
    "🚙":["car", "carpool", "uber", "lyft", "taxi"],
    "🍻":["drinking", "bar"],
    "🛥":["cruise", "boat", "boating"],
    "🏡":["garden", "gardening", "plant", "planting"]
  };
}