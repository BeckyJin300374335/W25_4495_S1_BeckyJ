import firebase_admin
from firebase_admin import credentials

from firebase_admin import firestore, auth, storage
from datetime import datetime
import random


cred = credentials.Certificate('flutterapp-738bb-firebase-adminsdk-fbsvc-8a033f8c22.json')

app = firebase_admin.initialize_app(cred, {'storageBucket': 'flutterapp-738bb.firebasestorage.app'})
db = firestore.client()

users = [
    ('Leo', 'leo@gmail.com', '123456'),
    ('Marcus', 'macus@gmail.com', '123456'),
    ('Ryan', 'ryan@gmail.com', '123456'),
]

posts = [
    ('Hiking play date', 'Let us hike on grouse mountain!', datetime(2025, 4, 10, 10), datetime(2025, 4, 10, 12)),
    ('Ski play date', 'Let us ski on grouse mountain!', datetime(2025, 4, 12, 10), datetime(2025, 4, 10, 12)),
    ('Park Play Date', 'Let us play on the playground!', datetime(2025, 4, 15, 10), datetime(2025, 4, 10, 12)),
]

images = [
    'images/park1.jpg',
    'images/park2.jpg',
    'images/park3.jpg',
]

tags = [
    'park',
    'dancing',
    'sports',
    'painting',
    'hiking',
    'painting'
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
    for (name, email, password) in users:
        authentication = auth.create_user(email=email, password=password)
        user = db.collection('users').document(authentication.uid)
        user.set({'name': name, 'email': email})
        create_post(user.id)



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