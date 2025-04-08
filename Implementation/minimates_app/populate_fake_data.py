import firebase_admin
from firebase_admin import credentials

from firebase_admin import firestore, auth, storage
from datetime import datetime
import random


cred = credentials.Certificate('flutterapp-738bb-firebase-adminsdk-fbsvc-8a033f8c22.json')

app = firebase_admin.initialize_app(cred, {'storageBucket': 'flutterapp-738bb.firebasestorage.app'})
db = firestore.client()

users = [
    ('Becky bb', 'becky@gmail.com', '123456', 9, 'Female', 'Vernon', 'images/profile/profile1.jpg'),
    ('Leo Parker', 'leo@gmail.com', '123456', 8, 'Male', 'Burnaby', 'images/profile/profile2.jpg'),
    ('Marcus Riley', 'marcus@gmail.com', '123456', 5, 'Male', 'Kelowna', 'images/profile/profile3.jpg'),
    ('Sophia Kim', 'sophia@gmail.com', '123456', 7, 'Female', 'Vancouver', 'images/profile/profile4.png'),
    ('Olivia Smith', 'olivia@gmail.com', '123456', 3, 'Female', 'Richmond', 'images/profile/profile5.jpg'),
    ('Ethan Brown', 'ethan@gmail.com', '123456', 6, 'Male', 'Langley', 'images/profile/profile6.jpeg'),
    ('Liam Johnson', 'liam@gmail.com', '123456', 1, 'Male', 'Coquitlam', 'images/profile/profile7.jpeg'),
    ('Noah Williams', 'noah@gmail.com', '123456', 2, 'Male', 'Victoria', 'images/profile/profile8.jpg'),
    ('Ava Miller', 'ava@gmail.com', '123456', 6, 'Female', 'Surrey', 'images/profile/profile9.jpg'),
    ('Emma Davis', 'emma@gmail.com', '123456', 4, 'Female', 'Whistler', 'images/profile/profile10.jpg'),
]

posts = [
    ('Hiking Play Date', 'Join us for a fun hike on Grouse Mountain!', datetime(2025, 5, 10, 10), datetime(2025, 5, 10, 12)),
    ('Ski Adventure', 'Experience the thrill of skiing with friends!', datetime(2025, 6, 12, 9), datetime(2025, 6, 12, 11)),
    ('Playground Fun', 'Let\'s have some fun at the neighborhood park!', datetime(2025, 4, 15, 14), datetime(2025, 4, 15, 16)),
    ('Art Class', 'Join us for a creative art session.', datetime(2025, 5, 5, 10), datetime(2025, 5, 5, 12)),
    ('Soccer Match', 'Team up and play soccer with new friends!', datetime(2025, 5, 20, 15), datetime(2025, 5, 20, 17)),
    ('Swimming Meetup', 'Enjoy a cool swim at the local pool.', datetime(2025, 6, 8, 12), datetime(2025, 6, 8, 14)),
    ('Dance Night', 'Show off your dance moves at the community center!', datetime(2025, 6, 18, 19), datetime(2025, 6, 18, 22)),
    ('Picnic', 'Bring your snacks and enjoy a picnic at the park.', datetime(2025, 5, 25, 12), datetime(2025, 5, 25, 14)),
    ('Football Game', 'Let\'s play football at the local field.', datetime(2025, 4, 30, 17), datetime(2025, 4, 30, 19)),
    ('Painting Workshop', 'Learn to paint with professional guidance.', datetime(2025, 6, 20, 14), datetime(2025, 6, 20, 16)),
]

articles = {
    "Why Your Toddler Only Wants Mom & What to Do About It": {
        "content": """
    If your toddler clings to one parent—often Mom—while pushing the other away, you’re not alone. Many families experience this phase, and while it can be frustrating, it’s a natural part of child development. Understanding why it happens and how to handle it can help both parents feel more connected.

  Toddlers form strong attachments to caregivers who meet their daily needs. If one parent spends more time feeding, soothing, and caring for them, the child may instinctively seek them out for comfort. This preference doesn’t mean the other parent is any less important—it’s just a reflection of routine and familiarity.

  For the non-preferred parent, this phase can feel discouraging. However, building a bond takes time and consistency. Engaging in shared activities like reading stories, playing games, or taking part in bedtime routines can strengthen the connection. Even small, everyday moments—like preparing meals together or going for short walks—help create lasting memories.

  Separation anxiety can also play a role in a toddler’s preference. When faced with a transition, like one parent leaving for work, children may react with tears and protests. A gradual approach to separation can help ease their anxiety. Short, reassuring goodbyes and offering a comfort item, like a favorite blanket or stuffed animal, can provide a sense of security.

  For working parents, guilt can creep in when time with a child feels limited. It’s important to focus on the quality of time spent together rather than the quantity. Being fully present—listening, engaging, and showing affection—reinforces a strong parent-child bond. Even small gestures, like a video call during the day, can maintain a sense of connection.

  Parents should work together as a team, ensuring that caregiving responsibilities are shared. Rotating tasks like bath time, meals, and bedtime can help a child see both parents as sources of comfort and support. Open communication between parents is key—expressing frustrations and celebrating small wins can make this phase easier for everyone.

  While it may be tough when a toddler insists on one parent, remember that preferences shift over time. Patience, consistency, and a united approach will help strengthen family bonds, ensuring that both parents feel equally valued in their child’s life. """,
        "image": "1.jpg"
    },
    "Fun Things to Do at Home With Kids": {
        "content": """
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
        "image": "2.jpg"
    },
    "10 Unique Ways to Paint with Kids": {
        "content": """
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
        "image": "3.jpg"
    },
    "8 Best Zoo Activities for Preschoolers": {
        "content": """
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
        "image": "4.jpg"
    },
    "Easy Activity: Magic Potions for Kids": {
        "content": """
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
        "image": "5.jpg"
    },
    "How to Handle Toddler Tantrums Calmly": {
        "content": """
Fear of the dark is a common childhood fear that can affect bedtime routines and overall sleep quality. While it's a normal stage of development, it can feel overwhelming for both children and parents. The good news is that with reassurance and a few practical strategies, kids can learn to feel safe and secure in the dark.

Why Kids Fear the Dark  
Children have vivid imaginations, and at night when the lights go out, those imaginations can turn shadows into monsters or unfamiliar sounds into something scary. This fear often begins around preschool age when kids start to understand the concept of danger but haven’t yet learned what’s real and what’s not. Big changes—like moving to a new house or watching a scary show—can also trigger nighttime anxiety.

How to Comfort Your Child  
Talk About Their Fears – Ask gentle questions and listen carefully to what your child is scared of. Avoid brushing it off; instead, validate their feelings by saying, “It’s okay to feel scared sometimes.”

Use a Night Light – A soft, warm night light can help make the room feel more welcoming. Avoid bright lights that might interfere with sleep.

Create a Bedtime Ritual – A calm, predictable bedtime routine can help kids wind down. Include soothing activities like reading, cuddling, or playing soft music.

Use Comfort Items – Allow your child to sleep with a favorite stuffed animal, blanket, or item that makes them feel secure.

Avoid Scary Content – Be mindful of what your child watches during the day. Even seemingly harmless cartoons can sometimes spark nighttime fears.

Teach Coping Strategies  
• Show them how to take deep breaths to calm down.  
• Practice “bravery building” by slowly encouraging them to turn off the lights for a few seconds.  
• Help them imagine a “safe space” or calming image they can think about at night.

Be Patient and Reassuring  
Overcoming a fear of the dark takes time. Celebrate small wins, like staying in bed all night or turning off the light for a few minutes. Remind your child that they are safe and that you’re close by if they need you.

With gentle support and consistent routines, your child will eventually learn to feel comfortable in the dark—and gain confidence that can extend to other areas of life.
  """,
        "image": "6.jpg"
    },
    "Simple Science Experiments to Try at Home": {
        "content": """
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
        "image": "7.jpg"
    },
    "Creative Ways to Encourage Reading at Home": {
        "content": """
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
        "image": "8.jpg"
    },
    "Mindfulness Activities for Kids": {
        "content": """
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
        "image": "9.jpg"
    },
    "How to Handle Sibling Rivalry": {
        "content": """
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
    """,
        "image": "10.jpg"
    },
};

images = [
    'images/posts/art1.jpg',
    'images/posts/art2.jpg',
    'images/posts/art3.jpg',
    'images/posts/dancing1.jpg',
    'images/posts/dancing2.jpg',
    'images/posts/dancing3.jpg',
    'images/posts/hiking1.jpg',
    'images/posts/hiking2.jpg',
    'images/posts/hiking3.png',
    'images/posts/park1.jpg',
    'images/posts/park2.jpg',
    'images/posts/park3.png',
    'images/posts/picnic1.jpg',
    'images/posts/picnic2.jpg',
    'images/posts/soccer1.jpg',
    'images/posts/soccer2.jpg',
    'images/posts/sports1.jpeg',
    'images/posts/sports2.jpg',
    'images/posts/swim1.jpg',
    'images/posts/swim2.jpg',
]

tags = [
    'park', 'dancing', 'sports', 'swimming', 'hiking',
    'painting', 'art', 'soccer', 'picnic'
]

image_url = [

]
BATCH_SIZE = 100
def delete_collection(coll_ref, batch_size):
    if batch_size == 0:
        return
    docs = coll_ref.list_documents(page_size=batch_size)
    deleted = 0
    for doc in docs:
        doc.delete()
        deleted = deleted + 1
    if deleted >= batch_size:
        return delete_collection(coll_ref, batch_size)



def create_post(user_id):
    post = random.choice(posts)
    image = random.choice(image_url)
    tag = random.choice(tags)
    db.collection('posts').add({
        'user_id': user_id,
        'title': post[0],
        'description': post[1],
        'image': image,
        'timestamp': datetime.now(),
        'start_time': post[2],
        'end_time': post[2],
        'tags': [tag]
    })

def create_users_and_posts():
    for (name, email, password,age, gender, city,path) in users:
        authentication = auth.create_user(email=email, password=password)
        user = db.collection('users').document(authentication.uid)
        url = get_image_url(path)
        user.set({'userName': name, 'email': email, 'password': password, 'profilePicture': url, 'age': age, 'gender': gender, 'city': city})
        create_post(user.id)



def get_image_url(path):
    fileName = path
    bucket = storage.bucket()
    blob = bucket.blob(fileName)
    blob.upload_from_filename(fileName)

    # Opt : if you want to make public access from the URL
    blob.make_public()
    return blob.public_url

def upload_images():
    for image in images:
        fileName = image
        bucket = storage.bucket()
        blob = bucket.blob(fileName)
        blob.upload_from_filename(fileName)

        # Opt : if you want to make public access from the URL
        blob.make_public()
        image_url.append(blob.public_url)


def delete_authentications():
    page = auth.list_users()
    while page:
        for user in page.users:
            auth.delete_user(user.uid)
        page = page.get_next_page()


def initialize_tags():
    for tag in tags:
        db.collection('tags').add({'name': tag})

def reset_articles():
    for title, value in articles.items():
        content = value['content']
        image_path = 'assets/images/articles/' + value['image']
        url = get_image_url(image_path)
        db.collection('articles').add({
            'title': title,
            'content': content,
            'image_path': url,
        })

def initiallize_database_with_fake_data():
    delete_authentications()
    delete_collection(db.collection('tags'), BATCH_SIZE)
    delete_collection(db.collection('users'), BATCH_SIZE)
    delete_collection(db.collection('posts'), BATCH_SIZE)
    upload_images()
    initialize_tags()
    create_users_and_posts()
    # reset_articles()


if __name__ == '__main__':
    initiallize_database_with_fake_data()