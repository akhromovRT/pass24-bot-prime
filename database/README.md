# База данных PASS24 AI Консьерж

SQLite-БД для хранения ответов (аналитика) и базы знаний.

## Структура таблиц

| Таблица | Назначение |
|--------|------------|
| **sessions** | Сессии пользователей: `user_id`, `source` (telegram/web/api), время |
| **messages** | Сообщения: `user` / `assistant`, `content`, `message_type` (consultation \| audit \| pass24_features \| other), связь с сессией и `parent_id` (ответ → вопрос) |
| **audit_records** | Шаги AI-аудита: `step_number`, `level` (basic / moderate / attention_zone), `payload` (JSON) |
| **knowledge_categories** | Категории базы знаний: Дом и участок, Безопасность, PASS24 |
| **knowledge_entries** | Записи базы знаний: `title`, `content`, `keywords`, привязка к категории |

## Инициализация

```bash
bash database/init_db.sh
```

Либо `cd database && chmod +x init_db.sh && ./init_db.sh`. БД создаётся в `data/pass24.db` (или `DB_PATH` / `DATA_DIR` из окружения).

## Просмотр данных

```bash
sqlite3 data/pass24.db
```

Примеры запросов для анализа ответов:

```sql
-- Все пары вопрос–ответ по типам
SELECT m.id, m.role, m.message_type, m.content, m.created_at
FROM messages m
ORDER BY m.session_id, m.created_at;

-- Ответы ассистента по типам консультации
SELECT message_type, COUNT(*), substr(content, 1, 80) AS excerpt
FROM messages
WHERE role = 'assistant'
GROUP BY message_type;

-- Итоги аудитов по уровням
SELECT level, COUNT(*) FROM audit_records GROUP BY level;
```

## Файлы

- `schema.sql` — полная схема и индексы
- `seed_categories.sql` — начальные категории базы знаний
- `migrations/` — миграции (при необходимости)
