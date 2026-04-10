class QuizQuestion {
  final String questionKey;
  final List<String> optionKeys;
  final int correctIndex;
  final String category;

  const QuizQuestion({
    required this.questionKey,
    required this.optionKeys,
    required this.correctIndex,
    required this.category,
  });
}

// Questions use translation keys so they work in all 20 languages
const quizQuestions = [
  // Pillars of Islam
  QuizQuestion(questionKey: 'q1', optionKeys: ['q1a', 'q1b', 'q1c', 'q1d'], correctIndex: 1, category: 'pillars'),
  QuizQuestion(questionKey: 'q2', optionKeys: ['q2a', 'q2b', 'q2c', 'q2d'], correctIndex: 2, category: 'pillars'),
  QuizQuestion(questionKey: 'q3', optionKeys: ['q3a', 'q3b', 'q3c', 'q3d'], correctIndex: 0, category: 'pillars'),
  // Prophets
  QuizQuestion(questionKey: 'q4', optionKeys: ['q4a', 'q4b', 'q4c', 'q4d'], correctIndex: 3, category: 'prophets'),
  QuizQuestion(questionKey: 'q5', optionKeys: ['q5a', 'q5b', 'q5c', 'q5d'], correctIndex: 0, category: 'prophets'),
  QuizQuestion(questionKey: 'q6', optionKeys: ['q6a', 'q6b', 'q6c', 'q6d'], correctIndex: 2, category: 'prophets'),
  // Quran
  QuizQuestion(questionKey: 'q7', optionKeys: ['q7a', 'q7b', 'q7c', 'q7d'], correctIndex: 1, category: 'quran'),
  QuizQuestion(questionKey: 'q8', optionKeys: ['q8a', 'q8b', 'q8c', 'q8d'], correctIndex: 3, category: 'quran'),
  QuizQuestion(questionKey: 'q9', optionKeys: ['q9a', 'q9b', 'q9c', 'q9d'], correctIndex: 0, category: 'quran'),
  QuizQuestion(questionKey: 'q10', optionKeys: ['q10a', 'q10b', 'q10c', 'q10d'], correctIndex: 2, category: 'quran'),
  // Prayer
  QuizQuestion(questionKey: 'q11', optionKeys: ['q11a', 'q11b', 'q11c', 'q11d'], correctIndex: 1, category: 'prayer'),
  QuizQuestion(questionKey: 'q12', optionKeys: ['q12a', 'q12b', 'q12c', 'q12d'], correctIndex: 0, category: 'prayer'),
  // History
  QuizQuestion(questionKey: 'q13', optionKeys: ['q13a', 'q13b', 'q13c', 'q13d'], correctIndex: 2, category: 'history'),
  QuizQuestion(questionKey: 'q14', optionKeys: ['q14a', 'q14b', 'q14c', 'q14d'], correctIndex: 1, category: 'history'),
  QuizQuestion(questionKey: 'q15', optionKeys: ['q15a', 'q15b', 'q15c', 'q15d'], correctIndex: 3, category: 'history'),
];
