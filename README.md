# PocketWords

PocketWords is an iOS flash-card app built with SwiftUI and Apple’s new SwiftData persistence framework. It lets you review vocabulary words one card at a time, tracks your correct/incorrect answers, and awards XP as you practice.

---

## 📐 Architecture

We follow a lightweight **MVVM** pattern layered on top of **SwiftData**:

```
┌─────────────────────────────────────────┐
│              SwiftUI Views              │
│                                         │
│  • CardStackView (root)                 │
│  • CardView, NewCardView, CardTextView  │
└─────────────────────────────────────────┘
              ▲           │
              │ binds to  │
              ▼           │
┌─────────────────────────────────────────┐
│           ViewModels (@Observable)      │
│                                         │
│  • CardStackViewModel                   │
│    – checkMeaning(…, with:)             │
│    – updateXP(context:)                 │
└─────────────────────────────────────────┘
              ▲           │
              │  uses     │
              ▼           │
┌─────────────────────────────────────────┐
│             Model Layer                 │
│       (SwiftData @Model entities)       │
│                                         │
│  • Word                                 │
│    – title, meaning, createdDate,       │
│      private status backing (_status)   │
│    – WordStatus enum (notAttempted      │
│      / correct / incorrect)             │
└─────────────────────────────────────────┘
              ▲           │
              │ powered by│
              ▼           │
┌─────────────────────────────────────────┐
│           Persistence Stack             │
│           (ModelContainer)              │
│                                         │
│  • Created in `PocketWordsApp` via      │
│    Schema([Word.self]) + configuration  │
│  • Injected into view hierarchy via     │
│ `.modelContainer(sharedModelContainer)` │
└─────────────────────────────────────────┘
```

---

## 📂 Project Structure

```
PocketWords/
├── PocketWordsApp.swift          # @main entry, sets up ModelContainer & root view
├── Model/
│   └── Word.swift                # SwiftData @Model + status enum + init
├── View/
│   ├── Card/                     # Single-card display components
│   │   ├── CardView.swift
│   │   ├── NewCardView.swift     # (e.g. “add new word” UI)
│   │   └── CardTextView.swift
│   └── CardStack/                # Stack-of-cards UI + VM
│       ├── CardStackView.swift
│       └── CardStackViewModel.swift
├── Resources/
│   └── Assets.xcassets           # App icons & colors
├── PocketWords.entitlements
└── PocketWordsTests/
    └── CardStackViewModelTests.swift
```

---

## 🚀 Getting Started

1. **Requirements**

   * iOS 17+
   * Xcode 15+

2. **Installation**

   ```bash
   git clone https://github.com/your-org/PocketWords.git
   open PocketWords.xcodeproj
   ```

3. **Run**
   Select the simulator or device, then build & run (⌘R).

---

## ⚖️ Trade-Offs & Decisions

| Decision                  | Benefits                                                        | Trade-Offs / Limitations                                       |
| ------------------------- | --------------------------------------------------------------- | -------------------------------------------------------------- |
| **SwiftData**             | • Declarative, integrates with SwiftUI<br>• Minimal boilerplate | • iOS 17+ only<br>• Less mature than Core Data                 |
| **MVVM + @Observable**    | • Clear separation of UI vs logic<br>• Simple state binding     | • May get verbose for more complex flows                       |
| **SwiftUI**               | • Fast prototyping<br>• Live previews                           | • Limited UIKit extensibility<br>• Some controls still missing |
| **Single ModelContainer** | • Global, shared context simplifies data flow                   | • Harder to scope or sandbox sub-modules                       |

---

## 📈 XP & Testing

* **XP System**:

  * Each correct answer grants 10 XP.
  * Progress bar reflects `correctCount / totalCount`.
  * All counting and persistence handled in `CardStackViewModel.updateXP(...)`.

* **Unit Tests**:
  `CardStackViewModelTests.swift` validates scoring logic and ensures `xp` and `xpProgress` update correctly.

---

## 📄 License

MIT License © 2025 PocketWords Contributors.

---

## 📄 Screen Record

https://github.com/user-attachments/assets/0995eb1f-7a7d-4c71-9b63-593c939f07cf

