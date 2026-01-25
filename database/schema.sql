-- PASS24 AI Консьерж: схема БД для хранения ответов и базы знаний
-- SQLite 3

-- Сессии пользователей (чат, диалог)
CREATE TABLE IF NOT EXISTS sessions (
    id              INTEGER PRIMARY KEY AUTOINCREMENT,
    user_id         TEXT,               -- внешний ID (Telegram, web и т.д.)
    source          TEXT NOT NULL,      -- telegram | web | api
    created_at      TEXT NOT NULL DEFAULT (datetime('now')),
    updated_at      TEXT NOT NULL DEFAULT (datetime('now'))
);

CREATE INDEX IF NOT EXISTS idx_sessions_user_id ON sessions(user_id);
CREATE INDEX IF NOT EXISTS idx_sessions_created_at ON sessions(created_at);

-- Сообщения (запросы пользователя и ответы ассистента)
CREATE TABLE IF NOT EXISTS messages (
    id              INTEGER PRIMARY KEY AUTOINCREMENT,
    session_id      INTEGER NOT NULL REFERENCES sessions(id) ON DELETE CASCADE,
    role            TEXT NOT NULL,      -- user | assistant
    content         TEXT NOT NULL,
    message_type    TEXT NOT NULL,      -- consultation | audit | pass24_features | other
    created_at      TEXT NOT NULL DEFAULT (datetime('now')),
    parent_id       INTEGER REFERENCES messages(id) ON DELETE SET NULL  -- связь ответа с вопросом
);

CREATE INDEX IF NOT EXISTS idx_messages_session_id ON messages(session_id);
CREATE INDEX IF NOT EXISTS idx_messages_created_at ON messages(created_at);
CREATE INDEX IF NOT EXISTS idx_messages_message_type ON messages(message_type);
CREATE INDEX IF NOT EXISTS idx_messages_role ON messages(role);

-- Данные по шагам AI-аудита безопасности
CREATE TABLE IF NOT EXISTS audit_records (
    id              INTEGER PRIMARY KEY AUTOINCREMENT,
    session_id      INTEGER NOT NULL REFERENCES sessions(id) ON DELETE CASCADE,
    message_id      INTEGER REFERENCES messages(id) ON DELETE SET NULL,
    step_number     INTEGER NOT NULL,
    level           TEXT,               -- basic | moderate | attention_zone
    payload         TEXT,               -- JSON: вопрос, ответ пользователя, метаданные
    created_at      TEXT NOT NULL DEFAULT (datetime('now'))
);

CREATE INDEX IF NOT EXISTS idx_audit_records_session_id ON audit_records(session_id);
CREATE INDEX IF NOT EXISTS idx_audit_records_level ON audit_records(level);

-- Категории базы знаний
CREATE TABLE IF NOT EXISTS knowledge_categories (
    id              INTEGER PRIMARY KEY AUTOINCREMENT,
    name            TEXT NOT NULL,
    slug            TEXT NOT NULL UNIQUE,
    description     TEXT,
    sort_order      INTEGER NOT NULL DEFAULT 0,
    created_at      TEXT NOT NULL DEFAULT (datetime('now')),
    updated_at      TEXT NOT NULL DEFAULT (datetime('now'))
);

-- Записи базы знаний (справочные материалы, темы, подсказки)
CREATE TABLE IF NOT EXISTS knowledge_entries (
    id              INTEGER PRIMARY KEY AUTOINCREMENT,
    category_id     INTEGER NOT NULL REFERENCES knowledge_categories(id) ON DELETE CASCADE,
    title           TEXT NOT NULL,
    content         TEXT NOT NULL,
    keywords        TEXT,               -- через запятую или JSON — для поиска
    sort_order      INTEGER NOT NULL DEFAULT 0,
    created_at      TEXT NOT NULL DEFAULT (datetime('now')),
    updated_at      TEXT NOT NULL DEFAULT (datetime('now'))
);

CREATE INDEX IF NOT EXISTS idx_knowledge_entries_category_id ON knowledge_entries(category_id);
CREATE INDEX IF NOT EXISTS idx_knowledge_entries_keywords ON knowledge_entries(keywords);
