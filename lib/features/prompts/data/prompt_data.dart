import 'prompt.dart';
import 'prompt_category.dart';

const List<Prompt> allPrompts = [
  // Feelings
  Prompt('How are you really feeling right now?', PromptCategory.feelings),
  Prompt('What is weighing on your mind today?', PromptCategory.feelings),
  Prompt('What emotion showed up most today, and why?', PromptCategory.feelings),
  Prompt('What would help you feel a little lighter right now?', PromptCategory.feelings),
  Prompt('When did you feel most like yourself today?', PromptCategory.feelings),
  Prompt('What are you avoiding feeling at the moment?', PromptCategory.feelings),
  Prompt('What is your body telling you today?', PromptCategory.feelings),
  Prompt('What made you smile recently?', PromptCategory.feelings),

  // Memories
  Prompt('Describe a memory that still makes you smile.', PromptCategory.memories),
  Prompt('What is your earliest memory?', PromptCategory.memories),
  Prompt('What was your favorite place to be as a child?', PromptCategory.memories),
  Prompt('Who from your past do you think about often?', PromptCategory.memories),
  Prompt('Describe a day you wish you could relive.', PromptCategory.memories),
  Prompt('What did you believe as a kid that you no longer do?', PromptCategory.memories),
  Prompt('What is a smell, song, or taste that takes you back?', PromptCategory.memories),
  Prompt('What is a moment that changed how you see things?', PromptCategory.memories),

  // Reflection
  Prompt('What did you learn about yourself this week?', PromptCategory.reflection),
  Prompt('What matters most to you right now?', PromptCategory.reflection),
  Prompt('What would you do if you weren\'t afraid of failing?', PromptCategory.reflection),
  Prompt('What habit would you like to change, and why?', PromptCategory.reflection),
  Prompt('What are you proud of that nobody knows about?', PromptCategory.reflection),
  Prompt('Where do you want to be a year from now?', PromptCategory.reflection),
  Prompt('What advice would you give your past self?', PromptCategory.reflection),
  Prompt('What are you holding onto that you could let go of?', PromptCategory.reflection),


  Prompt('What are three things you are grateful for today?', PromptCategory.gratitude),
  Prompt('Who made your life better recently, and how?', PromptCategory.gratitude),
  Prompt('What small thing went well today?', PromptCategory.gratitude),
  Prompt('What is something you have now that you once wished for?', PromptCategory.gratitude),
  Prompt('What is a simple pleasure you enjoyed this week?', PromptCategory.gratitude),
  Prompt('Which challenge are you thankful for in hindsight?', PromptCategory.gratitude),
  Prompt('Who would you like to thank, and what would you say?', PromptCategory.gratitude),
  Prompt('What part of your everyday life do you take for granted?', PromptCategory.gratitude),
];