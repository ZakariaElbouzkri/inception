import faker
import random

f = faker.Faker()

env = {
    "MYSQL_PASSWORD": f.password(special_chars=False),
    "MYSQL_ROOT_PASSWORD": f.password(special_chars=False),
    "MYSQL_DATABASE": f.word(),
    "MYSQL_USER": f.user_name(),
    "WP_ADMIN_EMAIL": f.email(),
    "WP_ADMIN_USER": f.user_name(),
    "WP_ADMIN_PASS": f.password(special_chars=False),
    "WP_USER_USERNAME": f.user_name(),
    "WP_USER_EMAIL": f.email(),
    "WP_USER_ROLE": random.choice(["author", "contributor", "subscriber"]),
    "WP_USER_PASS": f.password(special_chars=False),
    "FTP_USER": f.user_name(),
    "FTP_PASSWORD": f.password(special_chars=False),
}

for key, value in env.items():
    print(f"{key}=\"{value}\"")
