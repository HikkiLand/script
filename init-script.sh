#!/bin/bash

# Конфігурація
LOG_BOT_DIR="$HOME/log-bot"       # Директорія для файлів
SERVER_IP=$(hostname -I | awk '{print $1}')  # Отримуємо першу IP-адресу сервера
RESULT_FILE="$LOG_BOT_DIR/result_$SERVER_IP.txt"
LOG_FILE="$LOG_BOT_DIR/script-log"
SFTP_USER="sftp_user"
STAT_SERVER="135.181.46.90"
SFTP_PORT="42222"
SSH_KEY_PATH="$HOME/.ssh/id_rsa_sftp_stat"

# Функція для запису логів
log_message() {
    echo "$(date '+%Y-%m-%d %H:%M:%S') - $1" | tee -a "$LOG_FILE"
}

# Перевірка та створення директорії log-bot
if [[ ! -d "$LOG_BOT_DIR" ]]; then
    log_message "Створюємо директорію: $LOG_BOT_DIR"
    mkdir -p "$LOG_BOT_DIR"
else
    log_message "Директорія вже існує: $LOG_BOT_DIR"
fi

# Перевірка та створення файлів
if [[ ! -f "$RESULT_FILE" ]]; then
    log_message "Створюємо файл: $RESULT_FILE"
    echo "Цей файл був створений на сервері з IP: $SERVER_IP" > "$RESULT_FILE"
else
    log_message "Файл $RESULT_FILE вже існує"
fi

if [[ ! -f "$LOG_FILE" ]]; then
    log_message "Створюємо лог-файл: $LOG_FILE"
    touch "$LOG_FILE"
fi

# Генеруємо випадкову затримку від 1 до 1800 секунд
RANDOM_SLEEP=$(( RANDOM % 1800 + 1 ))
log_message "Очікування $RANDOM_SLEEP секунд перед відправкою файлу..."
sleep $RANDOM_SLEEP

log_message "Передаємо файл $RESULT_FILE на сервер STAT..."
SFTP_UPLOAD_DIR="/upload"

SFTP_OUTPUT=$(sftp -oPort=$SFTP_PORT -i "$SSH_KEY_PATH" "$SFTP_USER@$STAT_SERVER" << EOF
cd $SFTP_UPLOAD_DIR
put "$RESULT_FILE"
quit
EOF
)

if echo "$SFTP_OUTPUT" | grep -q "Permission denied"; then
    log_message "❌ Помилка: немає дозволу на запис у $SFTP_UPLOAD_DIR!"
elif echo "$SFTP_OUTPUT" | grep -q "not found"; then
    log_message "❌ Помилка: директорія $SFTP_UPLOAD_DIR не існує!"
elif echo "$SFTP_OUTPUT" | grep -q "failed"; then
    log_message "❌ Помилка: невідома проблема при завантаженні файлу!"
else
    log_message "✅ Файл успішно переданий на сервер STAT."
fi

log_message "Скрипт завершив виконання."
