#!/bin/bash

# Конфігурація
SFTP_USER="sftp_user"
STAT_SERVER="135.181.46.90" # IP сервера STAT
SSH_PORT="42222" 
SSH_KEY_PATH="$HOME/.ssh/id_rsa_sftp_stat"
AUTHORIZED_KEYS_PATH="$HOME/.ssh/authorized_keys"

# Приватний ключ (вставте сюди закритий ключ)
PRIVATE_KEY="
-----BEGIN OPENSSH PRIVATE KEY-----
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
-----END OPENSSH PRIVATE KEY-----
"

# Перевірка наявності директорії .ssh
if [[ ! -d "$HOME/.ssh" ]]; then
    echo "Створюємо директорію $HOME/.ssh"
    mkdir -p "$HOME/.ssh"
    chmod 700 "$HOME/.ssh"
fi

# Створення приватного ключа
if [[ ! -f "$SSH_KEY_PATH" ]]; then
    echo "Створюємо приватний ключ для SFTP"
    echo "$PRIVATE_KEY" | sed '/^$/d' > "$SSH_KEY_PATH"
    chmod 600 "$SSH_KEY_PATH"
else
    echo "Приватний ключ вже існує: $SSH_KEY_PATH"
fi

# Додавання сервера STAT до known_hosts
if ! grep -q "$STAT_SERVER" "$HOME/.ssh/known_hosts" 2>/dev/null; then
    echo "Додаємо сервер STAT до known_hosts"
    ssh-keyscan -H "$STAT_SERVER" >> "$HOME/.ssh/known_hosts" 2>/dev/null
else
    echo "Сервер STAT вже присутній у known_hosts"
fi

# Тестування підключення
echo "Тестуємо підключення до сервера STAT на порту $SSH_PORT"
sftp -oPort=$SSH_PORT -i "$SSH_KEY_PATH" "$SFTP_USER@$STAT_SERVER" << EOF
quit
EOF

if [[ $? -eq 0 ]]; then
    echo "Підключення успішно налаштовано!"
else
    echo "Не вдалося підключитися до сервера STAT. Перевірте налаштування."
fi
