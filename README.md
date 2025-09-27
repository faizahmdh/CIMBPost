# CIMBPost — SwiftUI Posts App (MVVM)

Aplikasi demo ini mengambil data dari https://jsonplaceholder.typicode.com/posts
- Arsitektur: MVVM + Repository + Service
- Concurrency: async/await
- Error/Loading state
- UI: SwiftUI (List, Detail), Custom Pull-to-Refresh
- Bonus: Unit Test (PostServiceTests)

## Menjalankan
1. Buka `CIMBPost.xcodeproj` / `.xcworkspace`
2. Pilih iPhone Simulator → Run (⌘R)
3. Atau gunakan SwiftUI Preview (⌘⇧P)

## Struktur
- `Data/Remote/`: `PostService`, `PostAPI`
- `Domain/Model/`: `Post`
- `Domain/Repositories/`: `PostRepository`
- `Presentation/ViewModels/`: `PostListViewModel`
- `Presentation/Views/`: `PostListView`, `PostDetailView`
- `Presentation/Views/Components/`: `PostCardView`, `CustomRefreshView`, `StateViews`
- `CIMBPostAppTests/`: `CIMBPostServiceTests`
- `Utils/`: `ScrollOffsetPreferenceKey`

## Catatan
- Pastikan koneksi internet untuk fetch API
- Tidak ada Pods
