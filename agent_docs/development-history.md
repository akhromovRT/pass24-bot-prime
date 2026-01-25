# История разработки

## 2026-01-25 — База данных для ответов и базы знаний

- Добавлена SQLite-БД: `database/schema.sql`, `init_db.sh`, `seed_categories.sql`.
- Таблицы: `sessions`, `messages`, `audit_records`, `knowledge_categories`, `knowledge_entries`. Ответы хранятся в `messages` (пары вопрос–ответ с типом: consultation / audit / pass24_features / other), шаги аудита — в `audit_records`, база знаний — в `knowledge_categories` и `knowledge_entries`.
- Добавлены `.env.example` (DB_PATH), `.gitignore` (data/, .env), `database/README.md` с примерами запросов для анализа.
- Обновлены `agent_docs`: index, architecture, adr, development-history.
