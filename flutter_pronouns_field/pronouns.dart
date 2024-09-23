class Pronouns {
  String subject;
  String object;
  String possessivePronoun;
  String reflexive;

  Pronouns({
    this.subject = '',
    this.object = '',
    this.possessivePronoun = '',
    this.reflexive = '',
  });

  @override
  String toString() {
    if (subject == '') {
      return 'Other';
    }
    return '${subject.toTitleCase()}/${object.toTitleCase()}';
  }
}

enum CommonPronouns {
  they,
  she,
  he,
  other,
}

final Map<String, Pronouns> neopronouns = {
  'xe': Pronouns(
    subject: 'xe',
    object: 'xem',
    possessivePronoun: 'xyrs',
    reflexive: 'xemself',
  ),
  'xy': Pronouns(
    subject: 'xy',
    object: 'xyr',
    possessivePronoun: 'xyrs',
    reflexive: 'xyrself',
  ),
  'hi': Pronouns(
    subject: 'hi',
    object: 'hir',
    possessivePronoun: 'hirs',
    reflexive: 'hirself',
  ),
  'ze': Pronouns(
    subject: 'ze',
    object: 'zir',
    possessivePronoun: 'zirs',
    reflexive: 'zirself',
  ),
  'ey': Pronouns(
    subject: 'ey',
    object: 'em',
    possessivePronoun: 'eirs',
    reflexive: 'emself',
  ),
  'ne': Pronouns(
    subject: 'ne',
    object: 'nem',
    possessivePronoun: 'nems',
    reflexive: 'nemself',
  ),
  'fae': Pronouns(
    subject: 'fae',
    object: 'faer',
    possessivePronoun: 'faers',
    reflexive: 'faerself',
  ),
  'ae': Pronouns(
    subject: 'ae',
    object: 'aer',
    possessivePronoun: 'aers',
    reflexive: 'aerself',
  ),
  'thon': Pronouns(
    subject: 'thon',
    object: 'thon',
    possessivePronoun: 'thon',
    reflexive: 'thonself',
  ),
  'zee': Pronouns(
    subject: 'zee',
    object: 'zed',
    possessivePronoun: 'zetas',
    reflexive: 'zedself',
  ),
};

extension CommonPronounsExtension on CommonPronouns {
  Pronouns pronounDetail({required Pronouns otherPronouns}) {
    switch (this) {
      case CommonPronouns.they:
        return Pronouns(
          subject: 'they',
          object: 'them',
          possessivePronoun: 'their',
          reflexive: 'themself',
        );
      case CommonPronouns.she:
        return Pronouns(
          subject: 'she',
          object: 'her',
          possessivePronoun: 'her',
          reflexive: 'herself',
        );
      case CommonPronouns.he:
        return Pronouns(
          subject: 'he',
          object: 'him',
          possessivePronoun: 'his',
          reflexive: 'himself',
        );
      case CommonPronouns.other:
        return otherPronouns;
    }
  }
}

class PronounsField extends StatefulWidget {
  const PronounsField({super.key});

  @override
  PronounsFieldState createState() => PronounsFieldState();
}

class PronounsFieldState extends State<PronounsField> {
  late CommonPronouns? _selectedPronoun;

  final TextEditingController _subjectController = TextEditingController();
  final TextEditingController _objectController = TextEditingController();
  final TextEditingController _possessivePronounController =
      TextEditingController();
  final TextEditingController _reflexiveController = TextEditingController();

  final FocusNode _subjectFocusNode = FocusNode();
  final FocusNode _objectFocusNode = FocusNode();
  final FocusNode _possessivePronounFocusNode = FocusNode();
  final FocusNode _reflexiveFocusNode = FocusNode();

  final List<CommonPronouns> _pronouns = CommonPronouns.values;
  final Pronouns _otherPronouns = Pronouns();

  @override
  void initState() {
    super.initState();
    _selectedPronoun = null;
  }

  void _handleKey(KeyEvent event) {
    setState(() {
      if (_subjectFocusNode.hasFocus) {
        _otherPronouns.subject = _subjectController.text.toLowerCase();
        _fillPronouns(_subjectController.text);
      } else if (_objectFocusNode.hasFocus) {
        _otherPronouns.object = _objectController.text;
      } else if (_possessivePronounFocusNode.hasFocus) {
        _otherPronouns.possessivePronoun = _possessivePronounController.text;
      } else if (_reflexiveFocusNode.hasFocus) {
        _otherPronouns.reflexive = _reflexiveController.text;
      }
    });
  }

  String _generateReflexive(String subject) {
    final lowerSubject = subject.toLowerCase();

    if (lowerSubject.endsWith('s')) {
      return '${lowerSubject}self';
    }
    if (lowerSubject.length == 1 || lowerSubject.endsWith('i')) {
      return '${lowerSubject}erself';
    }
    return '${lowerSubject}self';
  }

  String _generateObject(String subject) {
    final lowerSubject = subject.toLowerCase();

    if (lowerSubject.endsWith('e')) {
      // Vowel-ending subjects like "xe", "ze" often add "m" or "r" for object forms
      return '${lowerSubject}m';
    }
    if (lowerSubject.endsWith('s') || lowerSubject.endsWith('r')) {
      // Subjects ending in "s" often remain unchanged
      return lowerSubject;
    }
    // Default to adding 'r' if it makes sense for smoothness
    return '${lowerSubject}r';
  }

  String _generatePossessivePronoun(String subject) {
    final lowerSubject = subject.toLowerCase();

    if (lowerSubject.endsWith('e')) {
      // Vowel-ending subjects like "xe", "ze" typically add "r" + "s"
      return '${lowerSubject}rs';
    }
    if (lowerSubject.endsWith('s')) {
      // Subjects ending in "s" can remain unchanged
      return lowerSubject;
    }
    if (lowerSubject.length == 1 || lowerSubject.endsWith('i')) {
      // Short or single-syllable subjects add "r" + "s"
      return '${lowerSubject}rs';
    }
    // Default case for other subjects, adding 'r' + 's'
    return '${lowerSubject}s';
  }

  void _fillPronouns(String subject) {
    Pronouns pronounSet;
    final String lowerSubject = subject.toLowerCase();
    if (neopronouns.containsKey(lowerSubject)) {
      pronounSet = neopronouns[lowerSubject]!;
    } else {
      final reflexive = lowerSubject == '' ? '' : _generateReflexive(subject);
      pronounSet = Pronouns(
        subject: lowerSubject,
        object: subject == '' ? '' : _generateObject(subject),
        possessivePronoun:
            subject == '' ? '' : _generatePossessivePronoun(subject),
        reflexive: reflexive,
      );
    }

    _objectController.text = pronounSet.object;
    _otherPronouns.object = pronounSet.object;

    _possessivePronounController.text = pronounSet.possessivePronoun;
    _otherPronouns.possessivePronoun = pronounSet.possessivePronoun;

    _reflexiveController.text = pronounSet.reflexive;
    _otherPronouns.reflexive = pronounSet.reflexive;
  }

  @override
  Widget build(BuildContext context) {
    final List<DropdownMenuItem<CommonPronouns>> items = _pronouns
        .map(
          (CommonPronouns pronoun) => DropdownMenuItem<CommonPronouns>(
            value: pronoun,
            child: Text(
              pronoun.pronounDetail(otherPronouns: _otherPronouns).toString(),
            ),
          ),
        )
        .toList();
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        DropdownButton<CommonPronouns>(
          value: _selectedPronoun,
          hint: const Text('Select your pronouns'),
          onChanged: (CommonPronouns? newValue) {
            setState(() {
              _selectedPronoun = newValue;
            });
          },
          items: items,
        ),
        if (_selectedPronoun == CommonPronouns.other) ...[
          const SizedBox(height: ShinySizes.padding),
          KeyboardListener(
            focusNode: _subjectFocusNode,
            onKeyEvent: _handleKey,
            child: TextFormField(
              controller: _subjectController,
              decoration: const InputDecoration(labelText: 'Subject (e.g. xe)'),
            ),
          ),
          KeyboardListener(
            focusNode: _objectFocusNode,
            onKeyEvent: _handleKey,
            child: TextFormField(
              controller: _objectController,
              decoration: const InputDecoration(labelText: 'Object (e.g. xem)'),
            ),
          ),
          KeyboardListener(
            focusNode: _possessivePronounFocusNode,
            onKeyEvent: _handleKey,
            child: TextFormField(
              controller: _possessivePronounController,
              decoration:
                  const InputDecoration(labelText: 'Possessive Pronoun (e.g. xyrs)'),
            ),
          ),
          KeyboardListener(
            focusNode: _reflexiveFocusNode,
            onKeyEvent: _handleKey,
            child: TextFormField(
              controller: _reflexiveController,
              decoration: const InputDecoration(labelText: 'Reflexive (e.g. xemself)'),
            ),
          ),
        ],
      ],
    );
  }

  @override
  void dispose() {
    _subjectController.dispose();
    _objectController.dispose();
    _possessivePronounController.dispose();
    _reflexiveController.dispose();

    _subjectFocusNode.dispose();
    _objectFocusNode.dispose();
    _possessivePronounFocusNode.dispose();
    _reflexiveFocusNode.dispose();

    super.dispose();
  }
}
