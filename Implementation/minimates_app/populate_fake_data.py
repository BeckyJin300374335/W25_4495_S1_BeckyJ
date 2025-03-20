import firebase_admin
from firebase_admin import credentials

from firebase_admin import firestore, auth, storage
from datetime import datetime
import random


cred = credentials.Certificate('flutterapp-738bb-firebase-adminsdk-fbsvc-8a033f8c22.json')

app = firebase_admin.initialize_app(cred, {'storageBucket': 'flutterapp-738bb.firebasestorage.app'})
db = firestore.client()

users = [
    ('Becky bb', 'becky@gmail.com', '123456', 39, 'Female', 'Vernon', 'images/profile/profile1.jpg'),
    ('Leo Parker', 'leo@gmail.com', '123456', 28, 'Male', 'Burnaby', 'images/profile/profile2.jpg'),
    ('Marcus Riley', 'marcus@gmail.com', '123456', 35, 'Male', 'Kelowna', 'images/profile/profile3.jpg'),
    ('Sophia Kim', 'sophia@gmail.com', '123456', 27, 'Female', 'Vancouver', 'images/profile/profile4.png'),
    ('Olivia Smith', 'olivia@gmail.com', '123456', 33, 'Female', 'Richmond', 'images/profile/profile5.jpg'),
    ('Ethan Brown', 'ethan@gmail.com', '123456', 30, 'Male', 'Langley', 'images/profile/profile6.jpeg'),
    ('Liam Johnson', 'liam@gmail.com', '123456', 31, 'Male', 'Coquitlam', 'images/profile/profile7.jpeg'),
    ('Noah Williams', 'noah@gmail.com', '123456', 29, 'Male', 'Victoria', 'images/profile/profile8.jpg'),
    ('Ava Miller', 'ava@gmail.com', '123456', 26, 'Female', 'Surrey', 'images/profile/profile9.jpg'),
    ('Emma Davis', 'emma@gmail.com', '123456', 34, 'Female', 'Whistler', 'images/profile/profile10.jpg'),
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

def initiallize_database_with_fake_data():
    delete_authentications()
    delete_collection(db.collection('tags'), BATCH_SIZE)
    delete_collection(db.collection('users'), BATCH_SIZE)
    delete_collection(db.collection('posts'), BATCH_SIZE)
    upload_images()
    initialize_tags()
    create_users_and_posts()


if __name__ == '__main__':
    initiallize_database_with_fake_data()