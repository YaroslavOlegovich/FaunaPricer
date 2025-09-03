# 🚀 Быстрый APK за 10 минут

## Вариант 1: GitHub Actions (Рекомендуется)

### 1. Создайте GitHub репозиторий
- Зайдите на https://github.com
- Нажмите "New repository" → "FaunaPricer" → "Create"

### 2. Загрузите файлы
- Нажмите "uploading an existing file"
- Перетащите ВСЕ файлы проекта (включая папку `.github`)
- Commit message: "Initial commit" → "Commit changes"

### 3. Соберите APK
- Перейдите в "Actions" → "Build FaunaPricer APK"
- Нажмите "Run workflow" → "Run workflow"
- Дождитесь завершения (5-10 минут)

### 4. Скачайте APK
- В разделе "Artifacts" нажмите "fauna-pricer-apk"
- Скачайте и распакуйте ZIP
- APK готов!

## Вариант 2: Локальная сборка

### Если Flutter установлен:
```bash
# В папке проекта
flutter pub get
flutter build apk --release
```

### Если Flutter в VS Code:
1. Откройте VS Code в папке проекта
2. Ctrl+Shift+P → "Flutter: Build APK"
3. Выберите "Release"

## 📱 Установка

1. Скопируйте APK на Android
2. Включите "Установка из неизвестных источников"
3. Откройте APK и установите

## 🧪 Тест

- S=100, K=100, σ=20%, r=0.05, T=1 год, Call
- Ожидаемая цена ≈ 10.45 ₽

---

**GitHub Actions**: 10 минут настройки + 5 минут сборки  
**Локальная сборка**: 2-5 минут (если Flutter настроен)
