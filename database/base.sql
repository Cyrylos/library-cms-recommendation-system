SET search_path TO public;

DROP EXTENSION IF EXISTS "uuid-ossp";
CREATE EXTENSION "uuid-ossp" SCHEMA public;

BEGIN;

CREATE TYPE books_type_enum AS ENUM ('book', 'magazine', 'article', 'thesis');
ALTER TYPE books_type_enum OWNER TO devel;

CREATE TYPE users_role_enum AS ENUM ('customer', 'employee', 'admin');
ALTER TYPE users_role_enum OWNER TO devel;

CREATE TABLE IF NOT EXISTS migrations
(
    id        SERIAL
        CONSTRAINT "PK_8c82d7f526340ab734260ea46be"
            PRIMARY KEY,
    timestamp BIGINT  NOT NULL,
    name      VARCHAR NOT NULL
);

ALTER TABLE migrations
    OWNER TO devel;

CREATE TABLE IF NOT EXISTS typeorm_metadata
(
    type     VARCHAR NOT NULL,
    database VARCHAR,
    schema   VARCHAR,
    "table"  VARCHAR,
    name     VARCHAR,
    value    TEXT
);

ALTER TABLE typeorm_metadata
    OWNER TO devel;

CREATE TABLE IF NOT EXISTS authors
(
    id          SERIAL
        CONSTRAINT "PK_d2ed02fabd9b52847ccb85e6b88"
            PRIMARY KEY,
    first_name  VARCHAR(50)             NOT NULL,
    last_name   VARCHAR(50)             NOT NULL,
    created_at  TIMESTAMP DEFAULT NOW() NOT NULL,
    modified_at TIMESTAMP DEFAULT NOW()
);

COMMENT ON COLUMN authors.id IS 'Identyfikator autora';
COMMENT ON COLUMN authors.first_name IS 'Imię';
COMMENT ON COLUMN authors.last_name IS 'Nazwisko';
COMMENT ON COLUMN authors.created_at IS 'Moment utworzenia rekordu';
COMMENT ON COLUMN authors.modified_at IS 'Moment modyfikacji rekordu';

ALTER TABLE authors
    OWNER TO devel;

CREATE TABLE IF NOT EXISTS genres
(
    id    SERIAL
        CONSTRAINT "PK_80ecd718f0f00dde5d77a9be842"
            PRIMARY KEY,
    value VARCHAR(100) NOT NULL
        CONSTRAINT "UQ_aaa21d013c0f7479debd7d21a0b"
            UNIQUE
);

COMMENT ON COLUMN genres.id IS 'Identyfikator gatunku';
COMMENT ON COLUMN genres.value IS 'Wartość';

ALTER TABLE genres
    OWNER TO devel;

CREATE TABLE IF NOT EXISTS languages
(
    id    SERIAL
        CONSTRAINT "PK_b517f827ca496b29f4d549c631d"
            PRIMARY KEY,
    value VARCHAR(100) NOT NULL
        CONSTRAINT "UQ_212a72d3830f7841097c30bea48"
            UNIQUE
);

COMMENT ON COLUMN languages.id IS 'Identyfikator języka';
COMMENT ON COLUMN languages.value IS 'Wartość';

ALTER TABLE languages
    OWNER TO devel;

CREATE TABLE IF NOT EXISTS publishers
(
    id          SERIAL
        CONSTRAINT "PK_9d73f23749dca512efc3ccbea6a"
            PRIMARY KEY,
    name        VARCHAR(250)            NOT NULL
        CONSTRAINT "UQ_39082806f986a63cd7dcf1782a5"
            UNIQUE,
    created_at  TIMESTAMP DEFAULT NOW() NOT NULL,
    modified_at TIMESTAMP DEFAULT NOW()
);

COMMENT ON COLUMN publishers.id IS 'Identyfikator wydawcy';
COMMENT ON COLUMN publishers.name IS 'Nazwa';
COMMENT ON COLUMN publishers.created_at IS 'Moment utworzenia rekordu';
COMMENT ON COLUMN publishers.modified_at IS 'Moment modyfikacji rekordu';

ALTER TABLE publishers
    OWNER TO devel;

CREATE TABLE IF NOT EXISTS tags
(
    id    SERIAL
        CONSTRAINT "PK_e7dc17249a1148a1970748eda99"
            PRIMARY KEY,
    value VARCHAR(100) NOT NULL
        CONSTRAINT "UQ_d090e09fe86ebe2ec0aec27b451"
            UNIQUE
);

COMMENT ON COLUMN tags.id IS 'Identyfikator tagu';
COMMENT ON COLUMN tags.value IS 'Wartość';

ALTER TABLE tags
    OWNER TO devel;

CREATE TABLE IF NOT EXISTS files
(
    id         uuid      DEFAULT uuid_generate_v4() NOT NULL
        CONSTRAINT "PK_6c16b9093a142e0e7613b04a3d9"
            PRIMARY KEY,
    name       VARCHAR(150)                         NOT NULL,
    path       VARCHAR(250)                         NOT NULL,
    size       INTEGER                              NOT NULL,
    mime       VARCHAR(50)                          NOT NULL,
    sha256     VARCHAR(64)                          NOT NULL,
    created_at TIMESTAMP DEFAULT NOW()              NOT NULL
);

COMMENT ON COLUMN files.id IS 'Identyfikator pliku';
COMMENT ON COLUMN files.name IS 'Nazwa pliku';
COMMENT ON COLUMN files.path IS 'Ścieżka do pliku na dysku';
COMMENT ON COLUMN files.size IS 'Rozmiar w bajtach';
COMMENT ON COLUMN files.mime IS 'Typ MIME';
COMMENT ON COLUMN files.sha256 IS 'Suma kontrolna (sha256)';
COMMENT ON COLUMN files.created_at IS 'Moment utworzenia rekordu';

ALTER TABLE files
    OWNER TO devel;

CREATE TABLE IF NOT EXISTS books
(
    id           SERIAL
        CONSTRAINT "PK_f3f2f25a099d24e12545b70b022"
            PRIMARY KEY,
    isbn         VARCHAR(13)             NOT NULL
        CONSTRAINT "UQ_54337dc30d9bb2c3fadebc69094"
            UNIQUE,
    type         books_type_enum         NOT NULL,
    title        VARCHAR(255)            NOT NULL,
    description  TEXT,
    issue_date   DATE                    NOT NULL,
    pages        INTEGER                 NOT NULL,
    details      jsonb                   NOT NULL,
    created_at   TIMESTAMP DEFAULT NOW() NOT NULL,
    modified_at  TIMESTAMP DEFAULT NOW(),
    removed_at   TIMESTAMP,
    publisher_id INTEGER                 NOT NULL
        CONSTRAINT "FK_370ec5bbafd46f74b23a20a5298"
            REFERENCES publishers,
    genre_id     INTEGER                 NOT NULL
        CONSTRAINT "FK_3b94b035d80d7564abd012014c8"
            REFERENCES genres,
    language_id  INTEGER                 NOT NULL
        CONSTRAINT "FK_3164a2958d73d8cdebe5204c838"
            REFERENCES languages,
    image_id     uuid
        CONSTRAINT "REL_ce3191ad6f325cb5b184d656dd"
            UNIQUE
        CONSTRAINT "FK_ce3191ad6f325cb5b184d656dd8"
            REFERENCES files
);

COMMENT ON COLUMN books.id IS 'Identyfikator książki';
COMMENT ON COLUMN books.isbn IS 'ISBN';
COMMENT ON COLUMN books.type IS 'Rodzaj';
COMMENT ON COLUMN books.title IS 'Tytuł';
COMMENT ON COLUMN books.description IS 'Opis';
COMMENT ON COLUMN books.issue_date IS 'Data wydania';
COMMENT ON COLUMN books.pages IS 'Liczba stron';
COMMENT ON COLUMN books.details IS 'Szczegóły';
COMMENT ON COLUMN books.created_at IS 'Moment utworzenia rekordu';
COMMENT ON COLUMN books.modified_at IS 'Moment modyfikacji rekordu';
COMMENT ON COLUMN books.removed_at IS 'Moment usunięcia rekordu';
COMMENT ON COLUMN books.publisher_id IS 'Identyfikator wydawcy';
COMMENT ON COLUMN books.genre_id IS 'Identyfikator gatunku';
COMMENT ON COLUMN books.language_id IS 'Identyfikator języka';
COMMENT ON COLUMN books.image_id IS 'Identyfikator pliku';

ALTER TABLE books
    OWNER TO devel;

CREATE TABLE IF NOT EXISTS copies
(
    id          SERIAL
        CONSTRAINT "PK_e75e3715bd8cd3329397ba0e4dc"
            PRIMARY KEY,
    number      VARCHAR(50)             NOT NULL,
    created_at  TIMESTAMP DEFAULT NOW() NOT NULL,
    modified_at TIMESTAMP DEFAULT NOW(),
    removed_at  TIMESTAMP,
    book_id     INTEGER                 NOT NULL
        CONSTRAINT "FK_4e04092cf610812045d2766d07e"
            REFERENCES books,
    CONSTRAINT "UQ_816e5e74f60e2e594c4244114ad"
        UNIQUE (number, book_id)
);

COMMENT ON COLUMN copies.id IS 'Identyfikator egzemplarza';
COMMENT ON COLUMN copies.number IS 'Numer';
COMMENT ON COLUMN copies.created_at IS 'Moment utworzenia rekordu';
COMMENT ON COLUMN copies.modified_at IS 'Moment modyfikacji rekordu';
COMMENT ON COLUMN copies.removed_at IS 'Moment usunięcie rekordu';

ALTER TABLE copies
    OWNER TO devel;

CREATE TABLE IF NOT EXISTS books_authors
(
    book_id   INTEGER NOT NULL
        CONSTRAINT "FK_bf3c609a7c91bc032b805bbe14d"
            REFERENCES books
            ON UPDATE CASCADE ON DELETE CASCADE,
    author_id INTEGER NOT NULL
        CONSTRAINT "FK_738bc3574491eddb6cdd06896c6"
            REFERENCES authors
            ON UPDATE CASCADE ON DELETE CASCADE,
    CONSTRAINT "PK_ec21802e4c7a8a22887600d7709"
        PRIMARY KEY (book_id, author_id)
);

ALTER TABLE books_authors
    OWNER TO devel;

CREATE INDEX IF NOT EXISTS "IDX_bf3c609a7c91bc032b805bbe14"
    ON books_authors (book_id);

CREATE INDEX IF NOT EXISTS "IDX_738bc3574491eddb6cdd06896c"
    ON books_authors (author_id);

CREATE TABLE IF NOT EXISTS books_tags
(
    book_id INTEGER NOT NULL
        CONSTRAINT "FK_77ba62723b88dfee0f1787f054e"
            REFERENCES books
            ON UPDATE CASCADE ON DELETE CASCADE,
    tag_id  INTEGER NOT NULL
        CONSTRAINT "FK_6c62da474cb4f4487a3c04518b7"
            REFERENCES tags
            ON UPDATE CASCADE ON DELETE CASCADE,
    CONSTRAINT "PK_9f5349d11ea8cf4f5dbe4baae9d"
        PRIMARY KEY (book_id, tag_id)
);

ALTER TABLE books_tags
    OWNER TO devel;

CREATE INDEX IF NOT EXISTS "IDX_77ba62723b88dfee0f1787f054"
    ON books_tags (book_id);

CREATE INDEX IF NOT EXISTS "IDX_6c62da474cb4f4487a3c04518b"
    ON books_tags (tag_id);

CREATE TABLE IF NOT EXISTS users
(
    id             SERIAL
        CONSTRAINT "PK_a3ffb1c0c8416b9fc6f907b7433"
            PRIMARY KEY,
    first_name     VARCHAR(50)             NOT NULL,
    last_name      VARCHAR(50)             NOT NULL,
    email          VARCHAR(255)            NOT NULL
        CONSTRAINT "UQ_97672ac88f789774dd47f7c8be3"
            UNIQUE,
    password       VARCHAR(100)            NOT NULL,
    role           users_role_enum         NOT NULL,
    is_active      BOOLEAN   DEFAULT FALSE NOT NULL,
    last_logged_at TIMESTAMP,
    created_at     TIMESTAMP DEFAULT NOW() NOT NULL,
    modified_at    TIMESTAMP DEFAULT NOW(),
    removed_at     TIMESTAMP
);

COMMENT ON COLUMN users.id IS 'Identyfikator użytkownika';
COMMENT ON COLUMN users.first_name IS 'Imie';
COMMENT ON COLUMN users.last_name IS 'Nazwisko';
COMMENT ON COLUMN users.email IS 'E-mail';
COMMENT ON COLUMN users.password IS 'Hasło';
COMMENT ON COLUMN users.role IS 'Rola';
COMMENT ON COLUMN users.is_active IS 'Czy aktywny';
COMMENT ON COLUMN users.last_logged_at IS 'Moment ostatniego logowania';
COMMENT ON COLUMN users.created_at IS 'Moment utworzenia rekordu';
COMMENT ON COLUMN users.modified_at IS 'Moment modyfikacji rekordu';
COMMENT ON COLUMN users.removed_at IS 'Moment usunięcia rekordu';

ALTER TABLE users
    OWNER TO devel;

CREATE TABLE IF NOT EXISTS borrows
(
    id          SERIAL
        CONSTRAINT "PK_69f3a91fbbed0a8a2ce30efbce1"
            PRIMARY KEY,
    date_from   DATE                    NOT NULL,
    date_to     DATE,
    created_at  TIMESTAMP DEFAULT NOW() NOT NULL,
    modified_at TIMESTAMP DEFAULT NOW(),
    copy_id     INTEGER                 NOT NULL
        CONSTRAINT "FK_4be0d26f71f4ebc4319fa134883"
            REFERENCES copies,
    user_id     INTEGER                 NOT NULL
        CONSTRAINT "FK_c9b0c21ce0c14b78c266e304622"
            REFERENCES users
);

COMMENT ON COLUMN borrows.id IS 'Identyfikator wypożyczenia';
COMMENT ON COLUMN borrows.date_from IS 'Data od';
COMMENT ON COLUMN borrows.date_to IS 'Data do';
COMMENT ON COLUMN borrows.created_at IS 'Moment utworzenia rekordu';
COMMENT ON COLUMN borrows.modified_at IS 'Moment modyfikacji rekordu';

ALTER TABLE borrows
    OWNER TO devel;

CREATE TABLE IF NOT EXISTS ratings
(
    id          SERIAL
        CONSTRAINT "PK_0f31425b073219379545ad68ed9"
            PRIMARY KEY,
    comment     TEXT,
    created_at  TIMESTAMP DEFAULT NOW() NOT NULL,
    modified_at TIMESTAMP DEFAULT NOW() NOT NULL,
    book_id     INTEGER                 NOT NULL
        CONSTRAINT "FK_5eeacfb75e4972bec496e76cc55"
            REFERENCES books,
    value       NUMERIC(2, 1)           NOT NULL,
    user_id     INTEGER                 NOT NULL
        CONSTRAINT "FK_f49ef8d0914a14decddbb170f2f"
            REFERENCES users
);

COMMENT ON COLUMN ratings.id IS 'Identyfikator oceny';
COMMENT ON COLUMN ratings.comment IS 'Komentarz';
COMMENT ON COLUMN ratings.created_at IS 'Moment utworzenia rekordu';
COMMENT ON COLUMN ratings.modified_at IS 'Moment modyfikacji rekordu';
COMMENT ON COLUMN ratings.value IS 'Wartość';

ALTER TABLE ratings
    OWNER TO devel;

COMMIT;
