@echo off
echo ========================================
echo    FaunaPricer - APK Builder
echo ========================================
echo.

REM Проверка наличия Flutter
where flutter >nul 2>nul
if %errorlevel% neq 0 (
    echo ОШИБКА: Flutter SDK не найден в PATH
    echo.
    echo Установите Flutter SDK и добавьте его в PATH:
    echo 1. Скачайте с https://flutter.dev/docs/get-started/install
    echo 2. Распакуйте в C:\flutter
    echo 3. Добавьте C:\flutter\bin в переменную PATH
    echo 4. Перезапустите командную строку
    echo.
    pause
    exit /b 1
)

echo Flutter найден. Проверяем конфигурацию...
flutter doctor

echo.
echo Устанавливаем зависимости...
flutter pub get

if %errorlevel% neq 0 (
    echo ОШИБКА: Не удалось установить зависимости
    pause
    exit /b 1
)

echo.
echo Собираем APK (Release)...
flutter build apk --release

if %errorlevel% neq 0 (
    echo ОШИБКА: Не удалось собрать APK
    pause
    exit /b 1
)

echo.
echo ========================================
echo    СБОРКА ЗАВЕРШЕНА УСПЕШНО!
echo ========================================
echo.
echo APK файл находится в:
echo build\app\outputs\flutter-apk\app-release.apk
echo.
echo Размер файла:
dir "build\app\outputs\flutter-apk\app-release.apk" | find "app-release.apk"
echo.
echo Для установки на устройство:
echo 1. Скопируйте APK на Android устройство
echo 2. Включите "Установка из неизвестных источников"
echo 3. Откройте APK файл и установите
echo.
pause
