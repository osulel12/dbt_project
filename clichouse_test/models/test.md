{% docs __overview__ %}
# Это проект описывающий структуру и настройку схемы БД Clichouse
Структура состоит из следующих баз данных:
-  dbt_test - БД содержащая тестовые витрины

После развертывания кластера ClickHouse необходимо провести настройку и создание структуры

## Настраиваем TTL для таблиц с логами
Этот код настроит очистку таблиц с логами через каждые 7 дней
```sql
ALTER TABLE system.asynchronous_metric_log
MODIFY TTL event_date + INTERVAL 7 DAY;

ALTER TABLE system.metric_log
MODIFY TTL event_date + INTERVAL 7 DAY;
                   
ALTER TABLE system.part_log
MODIFY TTL event_date + INTERVAL 7 DAY;

ALTER TABLE system.trace_log
MODIFY TTL event_date + INTERVAL 7 DAY;

ALTER TABLE system.processors_profile_log
MODIFY TTL event_date + INTERVAL 7 DAY;
```

## Создаем нужные базы данных
```sql
CREATE DATABASE IF NOT EXISTS dbt_test;
```

## Далее необходимо создать пользователей и раздать им привилегии
Логика следующая. Для каждой базы данных создается пара пользователей.
Пользователь **АДМИН** и **ВНЕШНИЙ ПОЛЬЗОВАТЕЛЬ**. У администратора есть весь спектр прав, 
в то время как у внешнего пользователя только выборка данных из таблицы.

Так же пароли пользователей необходимо хэшировать.
Для этого выполните код:
```bash
echo -n 'пароль' | sha256sum | tr -d '-'
```

Пример кода создания пользователей
```sql
CREATE USER  dbt_test_outer_user IDENTIFIED WITH sha256_hash BY 'Захэшированный пароль';
GRANT SELECT ON dbt_test.* TO dbt_test_outer_user;


CREATE USER  dbt_test_admin_user IDENTIFIED WITH sha256_hash BY 'Захэшированный пароль';
GRANT ALL ON dbt_test.* TO dbt_test_admin_user;
```

После этого можно выполнить команду `git clone` в свою директорию,
установить зависимости `pip install dbt-core==1.8.9 dbt-clickhouse==1.8.9 dbt-postgres==1.8.2`.
Так же стоит откорректировать файл `profiles.yml` и внести в него свои подключения к БД, а после
выполнить `dbt run --profiles-dir пут\к\profiles.yml --target <нужный трагет из profiles.yml>` эти команды создадут все необходимые таблицы в БД
(Перед запуском можно сделать `dbt debug` и убедиться правильном подключении к БД)

{% enddocs %}



{% docs all_table_rows %}

Тестовая витрина данных

{% enddocs %}