import 'dart:math';

import 'package:flutter/material.dart';

import '../data/firestore.dart';

class Article{
  Map<String, String> articles = {
    "Why Your Toddler Only Wants Mom & What to Do About It ":"""
    If your toddler clings to one parent—often Mom—while pushing the other away, you’re not alone. Many families experience this phase, and while it can be frustrating, it’s a natural part of child development. Understanding why it happens and how to handle it can help both parents feel more connected.

  Toddlers form strong attachments to caregivers who meet their daily needs. If one parent spends more time feeding, soothing, and caring for them, the child may instinctively seek them out for comfort. This preference doesn’t mean the other parent is any less important—it’s just a reflection of routine and familiarity.

  For the non-preferred parent, this phase can feel discouraging. However, building a bond takes time and consistency. Engaging in shared activities like reading stories, playing games, or taking part in bedtime routines can strengthen the connection. Even small, everyday moments—like preparing meals together or going for short walks—help create lasting memories.

  Separation anxiety can also play a role in a toddler’s preference. When faced with a transition, like one parent leaving for work, children may react with tears and protests. A gradual approach to separation can help ease their anxiety. Short, reassuring goodbyes and offering a comfort item, like a favorite blanket or stuffed animal, can provide a sense of security.

  For working parents, guilt can creep in when time with a child feels limited. It’s important to focus on the quality of time spent together rather than the quantity. Being fully present—listening, engaging, and showing affection—reinforces a strong parent-child bond. Even small gestures, like a video call during the day, can maintain a sense of connection.

  Parents should work together as a team, ensuring that caregiving responsibilities are shared. Rotating tasks like bath time, meals, and bedtime can help a child see both parents as sources of comfort and support. Open communication between parents is key—expressing frustrations and celebrating small wins can make this phase easier for everyone.

  While it may be tough when a toddler insists on one parent, remember that preferences shift over time. Patience, consistency, and a united approach will help strengthen family bonds, ensuring that both parents feel equally valued in their child’s life. """,
    "Fun Things to Do at Home With Kids ":"""
    Looking for ways to keep your kids entertained at home? Whether it's a rainy day or a relaxing weekend, fun activities can bring your family closer and spark creativity. From arts and crafts to backyard games, here are some great ways to make the most of your time together. 

Spending quality time at home strengthens family bonds and provides a sense of security for kids. Engaging in hands-on activities fosters creativity, encourages problem-solving, and helps kids develop important life skills. Simple moments—like baking together, building a blanket fort, or playing a board game—create lasting memories. 

Indoor Fun 

Arts and crafts are a great way to boost creativity. Painting, drawing, or making DIY projects let kids express themselves while improving fine motor skills. Cooking or baking together also turns an everyday task into a fun learning experience—kids can measure, mix, and explore new flavors. 

For an exciting challenge, try an indoor scavenger hunt. Give kids a list of household items to find and let them share their discoveries. Board games and puzzles are another engaging way to bond while giving everyone a break from screens. 

Outdoor Adventures 

If you have a backyard, make the most of it! Gardening teaches kids about nature and responsibility while letting them get their hands dirty. Water play—like sprinklers, water balloons, or a kiddie pool—adds a splash of fun on warm days. You can also set up a backyard obstacle course to encourage movement and teamwork. 

Exploring nature is another simple yet rewarding activity. Watching birds, collecting bugs, or just taking a walk helps kids slow down and appreciate their surroundings. Classic outdoor games like tag or hide-and-seek are also great ways to burn energy while having fun together. 

Learning Through Play 

Educational activities don’t have to feel like schoolwork. Science experiments, such as making homemade ice cream or a baking soda volcano, keep kids curious and engaged. Storytelling encourages creativity—give kids a fun prompt and let them make up their own bedtime story. Math games and puzzles help develop problem-solving skills, while virtual museum tours let families explore the world from their living room. 

Creating Special Family Moments 

Game nights, family history projects, and even making a time capsule can bring everyone together. Art projects where everyone contributes their unique touch can become cherished keepsakes. Volunteering as a family fosters kindness and strengthens your connection to the community. 

To make activities even more enjoyable, customize them to your child’s interests. Encourage creativity with open-ended play, minimize digital distractions, and balance structured activities with free play. These small adjustments can make home life more engaging and fulfilling for the whole family. 

No matter what activity you choose, the key is to have fun and cherish the moments spent together. Home is where the best memories are made! 
    """,
    "10 Unique Ways to Paint with Kids ":"""
    Painting with kids is always fun, but why not make it even more exciting with some creative techniques? Here are ten unique ways to turn painting into a memorable experience for the whole family. 

Fly Swatter Painting 

Take painting outdoors and let kids swat paint onto a canvas using fly swatters! This messy activity creates vibrant, splattered artwork and plenty of laughs. 

Baking Soda & Vinegar Paint 

Mix baking soda with paint and let kids create colorful masterpieces. Then, give them droppers filled with vinegar and watch as their paintings bubble and fizz in a fun science-meets-art experiment. 

Shaving Cream Swirls 

Spread shaving cream on a tray, add drops of food coloring, and swirl with a toothpick. Press paper onto the surface, then lift to reveal beautiful marbled designs. 

Water Gun Painting 

Fill water guns with watered-down paint and let kids spray their artwork onto canvases. This is perfect for summer fun and even doubles as a creative tie-dye activity when done on white shirts. 

Ceiling Art 

Tape paper under a chair and let kids lie on the floor while painting overhead—just like Michelangelo! This fun activity sparks creativity and gives a fresh perspective on art. 

Painting with Feet 

Challenge kids to paint using only their feet! Hang paper on the wall or tape it to the floor and see how they manage to create their masterpieces. 

Blindfolded Art 

Cover kids' eyes and let them paint by touch and memory. It’s a fun way to explore textures and colors without relying on sight. 

Nature Paintbrushes 

Gather leaves, grass, flowers, and twigs to use as natural paintbrushes. Each brush creates different patterns and textures, making it a great outdoor adventure. 

Balloon Pop Painting 

Fill small balloons with paint, tape them to a canvas, and pop them with darts. The bursts of color create stunning abstract pieces and add an element of surprise. 

Eggshell Paint Bombs 

Save empty eggshells, fill them with paint, and let kids smash them onto a canvas. The splatters create unique effects and make for an exciting, hands-on experience. 

Painting is more than just an activity—it’s a way for kids to explore, create, and express themselves. Try these techniques to make art time even more fun and memorable! 
    """,
    "8 Best Zoo Activities for Preschoolers ":"""
    If your little one loves animals, a trip to the zoo can be an exciting learning adventure. Even if you can’t visit in person, you can bring the zoo experience home with fun, engaging activities that balance play and education. Here are eight creative ways to spark their love for wildlife. 

Make a Zoo Memory Game 

Create simple matching cards with pictures of zoo animals. Flip them over and take turns finding pairs. This fun game helps with memory, focus, and animal recognition. 

Play Zoo Animal Bingo 

Design bingo cards featuring different animals found at the zoo. As your child sees or learns about each animal, they can place a sticker on the corresponding spot. This activity is perfect for both in-person zoo visits and at-home play. 

Keep a Zoo Journal 

Encourage your child to document their favorite animals by drawing pictures and writing simple facts about them. This not only enhances creativity but also helps with early literacy skills. 

Read Zoo Books 

Choose books featuring real animals and engaging stories to help your child learn more about wildlife. Use illustrations to count animal features or compare sizes for an extra learning boost. 

Get Crafty with Paper Plates 

Turn paper plates into adorable animal faces using paint, markers, and cut-out shapes. This hands-on activity strengthens fine motor skills and lets kids express their creativity. 

Explore with Animal Figures 

Playing with small animal figurines allows kids to visualize different species, their colors, and unique features. Pair them with nature videos to compare real-life animal movements and habitats. 

Make DIY Zoo Masks 

Help your child create animal masks using paper, glue, and child-safe scissors. Wearing their masks, they can pretend to be their favorite zoo animals while improving hand-eye coordination. 

Create a Sensory Bin 

Fill a bin with rice or sand and hide small animal toys inside. Let kids dig and discover different animals, matching them to pictures or habitats for a fun and educational experience. 

Whether you’re heading to the zoo or bringing the adventure home, these activities will keep your preschooler engaged, learning, and having fun! 
    """,
    "Easy Activity: Magic Potions for Kids ":"""
    Looking for a fun and easy indoor activity? Making magic potions is a creative and exciting way to keep kids entertained while exploring science through play. Using simple household items, this activity encourages imagination and curiosity. 

How to Make Magic Potions 

Mom of two, Savannah Russo, swears by this screen-free activity to keep her kids engaged. All you need is baking soda, food coloring, vinegar, and some kitchen tools to create a fizzing, bubbling potion that feels truly magical. 

Start by scooping baking soda into muffin tin cups. Then, add a few drops of food coloring to each section. Fill separate bowls with vinegar, and let kids use spoons or plastic syringes to add the vinegar to the baking soda. The reaction creates a colorful fizz, keeping kids entertained as they mix and experiment. 

What You’ll Need: 

Baking soda 

Food coloring (natural dyes work great!) 

Vinegar 

Plastic syringes or spoons 

Muffin tins or small bowls 

Why Kids Love It 

This activity keeps little hands busy for hours as they discover new color combinations and bubbling reactions. It's a great way to introduce basic science concepts while encouraging creativity. 

For more ways to keep kids entertained, try exploring sensory play, DIY crafts, and hands-on experiments that spark their imagination! 
    """,
    "How to Handle Toddler Tantrums Calmly":"""
    Toddler tantrums are one of the most challenging aspects of parenting. From screaming in the grocery store to refusing to get dressed in the morning, tantrums can leave parents feeling helpless and frustrated. But understanding why tantrums happen—and how to respond calmly—can make a big difference.

Why Toddlers Have Tantrums
Tantrums are a normal part of child development. Toddlers are learning how to navigate their emotions, but they don’t yet have the words or emotional control to express their feelings in a calm way. When overwhelmed, their frustration often spills out as a tantrum.

Hunger, tiredness, and overstimulation are common triggers. A change in routine or being told "no" can also spark an emotional outburst. It’s important to remember that toddlers aren’t trying to be difficult—they’re reacting to feelings they don’t know how to manage yet.

How to Respond Calmly
Stay Calm – Your child will look to you for emotional cues. Take a deep breath and speak in a calm, steady voice.
Validate Their Feelings – Let your child know it’s okay to feel upset: "I know you’re frustrated because you wanted a cookie."
Offer Choices – Giving your toddler a sense of control can help de-escalate a tantrum. "Do you want to wear the red shirt or the blue shirt?"
Use Distraction – Redirect their attention to something else. "Let’s go see what’s in the garden!"
Set Limits – Calmly state the boundary without giving in: "I know you’re upset, but it’s not safe to play with that."
Preventing Future Tantrums
Stick to a consistent routine.
Make sure your child gets enough sleep and healthy snacks.
Give them opportunities to express themselves through play and talking.
Offer praise when they handle frustration well.
Tantrums are hard, but they’re temporary. With patience and calm guidance, your toddler will learn how to handle big emotions more effectively over time.
    """,
    "Simple Science Experiments to Try at Home":"""
    Looking for fun and educational activities to do with your kids? Science experiments are a perfect way to spark curiosity and introduce kids to basic scientific concepts—all while having fun! Here are some easy experiments you can try at home using everyday items.

1. Baking Soda and Vinegar Volcano
Build a small volcano shape using playdough or foil.
Pour baking soda into the "volcano."
Add red food coloring for effect.
Slowly pour vinegar into the volcano and watch the eruption!
Why It Works: The reaction between the baking soda (a base) and the vinegar (an acid) creates carbon dioxide gas, which causes the fizzing and bubbling effect.

2. Magic Milk Experiment
Pour whole milk into a shallow dish.
Add drops of different food coloring into the milk.
Dip a cotton swab into dish soap and gently touch the milk.
Watch as the colors swirl and mix!
Why It Works: The soap breaks down the fat in the milk, causing the colors to move and mix.

3. Walking Water Experiment
Fill two glasses with water and add food coloring.
Place an empty glass between them.
Use paper towels to connect the glasses.
Watch as the water "walks" up the paper towels and mixes in the empty glass.
Why It Works: The water travels through the paper towel due to capillary action.

4. Balloon Rocket
Blow up a balloon and tape it to a straw.
Thread a string through the straw and tie the string between two chairs.
Let go of the balloon and watch it zip across the string!
Why It Works: The escaping air propels the balloon forward, demonstrating the principle of action and reaction.
    """,
    "Creative Ways to Encourage Reading at Home":"""
    Developing a love of reading early on sets the foundation for lifelong learning. But getting kids to sit down with a book isn’t always easy. Here are some creative ways to make reading more enjoyable at home.

1. Create a Cozy Reading Space
Set up a comfy reading corner with pillows, blankets, and a bookshelf. Let your child pick out some books they’re interested in.

2. Make Reading Interactive
Use different voices for characters.
Act out scenes from the story.
Ask questions like, "What do you think will happen next?"
3. Start a Family Book Club
Choose a book to read together as a family. Afterward, discuss the story and share your favorite parts.

4. Let Kids Choose Their Own Books
When kids have the freedom to choose their own books, they’re more likely to stay engaged.

5. Incorporate Reading into Daily Life
Read signs while driving.
Let kids help with grocery lists.
Look at recipes together.
6. Use Audio Books
Listening to stories helps kids build vocabulary and comprehension.
    """,
    "Mindfulness Activities for Kids":"""
    Mindfulness helps kids manage their emotions, build focus, and reduce stress. Teaching kids mindfulness early on gives them tools to handle difficult feelings in a healthy way.

1. Breathing Exercises
Have your child sit still and focus on their breath. Encourage them to take slow, deep breaths and notice how their body feels.

2. Sensory Walks
Go for a walk and ask your child to describe what they see, hear, and feel. Focusing on the senses helps kids stay present.

3. Mindful Coloring
Give your child a coloring book and ask them to focus on the colors and patterns.

4. Gratitude Jar
Have your child write down things they’re grateful for and place them in a jar.

5. Body Scan
Ask your child to lie down and slowly focus on different parts of their body, starting from their toes and moving up to their head.
    """,
    "How to Handle Sibling Rivalry":"""
    Sibling rivalry is a natural part of growing up, but it can create tension in the household. Here’s how to help your kids develop healthy sibling relationships.

1. Encourage Teamwork
Give your kids opportunities to work together toward a common goal, like building a Lego tower or completing a puzzle.

2. Avoid Comparisons
Praising one child while criticizing the other can fuel rivalry. Focus on each child’s unique strengths.

3. Teach Conflict Resolution
Encourage kids to express their feelings calmly and listen to each other’s perspectives.

4. Set Boundaries
Let your kids know that hitting, yelling, and name-calling are not acceptable.

5. Give Individual Attention
Make time for one-on-one activities with each child. This helps them feel valued and reduces competition for your attention.

6. Celebrate Each Child’s Successes
Encourage your kids to cheer each other on when they accomplish something.

With patience and guidance, sibling rivalry can turn into a foundation for lifelong friendship.
    """
  };

  /// ✅ Load articles from Firestore
  Future<Map<String, String>> loadArticlesFromFirestore() async {
    try {
      final result = await Firestore().getArticles();
      if (result.isNotEmpty) {
        articles = result;
        return articles;
      } else {
        print('No articles found');
        articles = {};
      }
    } catch (e) {
      print('Error loading articles: $e');
      articles = {};
    }
    return articles;
  }

  /// ✅ Save articles to Firestore
  Future<void> saveArticlesToFirestore() async {
    for (var entry in articles.entries) {
      try {
        await Firestore().saveArticles({entry.key: entry.value});
        print("✅ Article saved: ${entry.key}");
      } catch (e) {
        print("❌ Error saving article: ${entry.key} - $e");
      }
    }
  }

  /// ✅ Method to get a single article by title
  String? getArticle(String title) {
    return articles[title];
  }

}
