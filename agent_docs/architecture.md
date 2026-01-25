# Архитектура PASS24 AI Консьерж

Краткое описание компонентов и границ системы.

## База данных (SQLite)

БД для хранения ответов (аналитика) и базы знаний. Путь к файлу: `data/pass24.db` (или `DB_PATH` из окружения). Схема и инициализация — см. `database/README.md` и `database/schema.sql`.

### Таблицы

| Таблица | Назначение |
|--------|------------|
| **sessions** | Сессии пользователей: `user_id`, `source` (telegram/web/api) |
| **messages** | Сообщения: `user` / `assistant`, `content`, `message_type` (consultation \| audit \| pass24_features \| other), `parent_id` (ответ → вопрос) |
| **audit_records** | Шаги AI-аудита: `step_number`, `level` (basic / moderate / attention_zone), `payload` (JSON) |
| **knowledge_categories** | Категории базы знаний: Дом и участок, Безопасность, PASS24 |
| **knowledge_entries** | Записи базы знаний: `title`, `content`, `keywords`, категория |

### Инициализация

```bash
bash database/init_db.sh
```

## Остальные компоненты

Бот, API, интеграции — будут описаны по мере появления. Пока в проекте заданы только правила (AGENTS.md), БД и документы.
