#!/bin/bash

echo "========================================"
echo "    FaunaPricer - APK Builder"
echo "========================================"
echo

# Проверка наличия Flutter
if ! command -v flutter &> /dev/null; then
    echo "ОШИБКА: Flutter SDK не найден в PATH"
    echo
    echo "Установите Flutter SDK:"
    echo "1. Скачайте с https://flutter.dev/docs/get-started/install"
    echo "2. Распакуйте в ~/flutter"
    echo "3. Добавьте ~/flutter/bin в PATH"
    echo "4. Перезапустите терминал"
    echo
    exit 1
fi

echo "Flutter найден. Проверяем конфигурацию..."
flutter doctor

echo
echo "Устанавливаем зависимости..."
flutter pub get

if [ $? -ne 0 ]; then
    echo "ОШИБКА: Не удалось установить зависимости"
    exit 1
fi

echo
echo "Собираем APK (Release)..."
flutter build apk --release

if [ $? -ne 0 ]; then
    echo "ОШИБКА: Не удалось собрать APK"
    exit 1
fi

echo
echo "========================================"
echo "    СБОРКА ЗАВЕРШЕНА УСПЕШНО!"
echo "========================================"
echo
echo "APK файл находится в:"
echo "build/app/outputs/flutter-apk/app-release.apk"
echo
echo "Размер файла:"
ls -lh "build/app/outputs/flutter-apk/app-release.apk"
echo
echo "Для установки на устройство:"
echo "1. Скопируйте APK на Android устройство"
echo "2. Включите 'Установка из неизвестных источников'"
echo "3. Откройте APK файл и установите"
echo
