# Flutter MP3 Player App - Đặc Tả Giao Diện

## 📱 Tổng Quan
Phát triển ứng dụng nghe nhạc MP3 cho mobile (iOS & Android) sử dụng Flutter, lấy cảm hứng từ Spotify với hệ thống theme đa dạng và component có thể tái sử dụng.

---

## 🎨 Hệ Thống Theme

### 4 Theme Variants:

#### 1. Spotify Theme (Mặc định)
- **Background**: `#000000` (đen thuần)
- **Card Background**: `#181818` (xám đen)
- **Primary (Accent)**: `#1db954` (xanh lá Spotify)
- **Secondary**: `#282828` (xám đậm)
- **Muted Text**: `#b3b3b3` (xám nhạt)
- **Foreground**: `#ffffff` (trắng)

#### 2. Purple Theme
- **Background**: `#0a0014` (tím đen)
- **Card Background**: `#1a0a2e` (tím đậm)
- **Primary**: `#9d4edd` (tím sáng)
- **Secondary**: `#240046` (tím đen)
- **Muted Text**: `#c77dff` (tím nhạt)
- **Accent**: `#e0aaff` (tím pastel)

#### 3. Blue Theme
- **Background**: `#001219` (xanh đen)
- **Card Background**: `#0a1929` (xanh đậm)
- **Primary**: `#00b4d8` (xanh dương sáng)
- **Secondary**: `#023e8a` (xanh navy)
- **Muted Text**: `#90e0ef` (xanh nhạt)
- **Accent**: `#48cae4` (xanh sky)

#### 4. Orange Theme
- **Background**: `#1a0f00` (nâu đen)
- **Card Background**: `#2d1b00` (nâu đậm)
- **Primary**: `#ff9500` (cam)
- **Secondary**: `#4a2800` (nâu)
- **Muted Text**: `#ffb84d` (cam nhạt)
- **Accent**: `#ffb84d` (cam vàng)

### Theme Switcher
- Hiển thị 4 nút tròn với màu đại diện cho mỗi theme
- Nút được chọn có border trắng và scale to hơn
- Animation mượt mà khi chuyển theme (300ms)

---

## 🏗️ Cấu Trúc Layout

### 1. Main Screen Layout
```
┌─────────────────────────────────┐
│  Header (Good evening + Theme)  │ <- Sticky header
├─────────────────────────────────┤
│                                 │
│  Content (Scrollable)           │
│  - Recently Played (Grid)       │
│  - Your Top Songs (List)        │
│  - Made For You (Grid)          │
│  - Popular Artists (Grid)       │
│                                 │
└─────────────────────────────────┘
│  Playback Bar (Bottom Sheet)    │ <- Sticky bottom
└─────────────────────────────────┘
```

### 2. Navigation (Bottom Navigation Bar cho Mobile)
- **Home** (Icon: Home)
- **Search** (Icon: Search)  
- **Library** (Icon: Library)
- **Profile** (Icon: User)

---

## 🧩 Reusable Components (Widgets)

### 1. MediaCard Widget
**Mô tả**: Card hiển thị album/playlist/artist với ảnh bìa

**Variants**:
- `album` - Bo góc vuông (8px radius)
- `playlist` - Bo góc vuông (8px radius)
- `artist` - Hình tròn (circular)

**Properties**:
- `title`: String (tên album/playlist)
- `subtitle`: String (tên nghệ sĩ)
- `imageUrl`: String
- `onTap`: Function (khi click vào card)
- `onPlayPressed`: Function (khi click nút play)

**Behavior**:
- Hiệu ứng hover (scale 1.02, shadow tăng)
- Nút Play icon xuất hiện khi hover/long-press
- Nút Play: bo tròn, màu primary, shadow lớn
- Nút Play ở góc dưới phải của ảnh
- Text truncate nếu quá dài

**Dimensions**:
- Width: responsive (grid item)
- Image: aspect ratio 1:1
- Padding: 16px
- Gap giữa image và text: 12px

---

### 2. TrackListItem Widget
**Mô tả**: Hiển thị 1 bài hát trong danh sách

**Layout** (từ trái sang phải):
```
[#] [Thumbnail] [Title + Artist] [Duration] [Like] [More]
```

**Properties**:
- `number`: int (số thứ tự)
- `title`: String
- `artist`: String
- `album`: String (optional)
- `duration`: String (format: "4:23")
- `imageUrl`: String (thumbnail)
- `isPlaying`: bool
- `isLiked`: bool
- `onTap`: Function
- `onLikePressed`: Function
- `onMorePressed`: Function

**States**:
- Default: Số thứ tự hiển thị
- Hover: Số thứ tự -> Play icon
- Playing: Text màu primary, icon "▶" thay số
- Liked: Heart icon fill màu primary

**Dimensions**:
- Height: 64px
- Thumbnail: 48x48px, bo góc 4px
- Gap: 12px giữa các elements

---

### 3. Button Widget
**Variants**:

**Primary Button**:
- Background: màu primary
- Text: màu contrast (đen/trắng tùy theme)
- Bo tròn hoàn toàn (pill shape)
- Hover: scale 1.05, shadow tăng

**Secondary Button**:
- Background: màu secondary
- Text: màu foreground
- Hover: opacity 0.8

**Ghost Button**:
- Background: transparent
- Text: màu muted
- Hover: background secondary, text foreground

**Icon Button**:
- Chỉ có icon, không có background
- Size: 40x40px (md), 32x32px (sm), 48x48px (lg)
- Hover: scale 1.1

**Properties**:
- `variant`: enum (primary, secondary, ghost, icon)
- `size`: enum (sm, md, lg)
- `icon`: IconData (optional)
- `label`: String (optional)
- `onPressed`: Function

---

### 4. PlayerControls Widget
**Mô tả**: Nhóm các nút điều khiển phát nhạc

**Layout**:
```
[Shuffle] [Previous] [Play/Pause] [Next] [Repeat]
```

**Buttons**:
- **Shuffle**: Icon shuffle, active state (màu primary)
- **Previous**: Icon skip_previous
- **Play/Pause**: Nút tròn lớn, background foreground
- **Next**: Icon skip_next
- **Repeat**: Icon repeat, 3 states (off, all, one)

**Properties**:
- `isPlaying`: bool
- `isShuffled`: bool
- `repeatMode`: enum (off, one, all)
- `onPlayPause`: Function
- `onPrevious`: Function
- `onNext`: Function
- `onShuffle`: Function
- `onRepeat`: Function

**Dimensions**:
- Play/Pause button: 56x56px
- Other buttons: 40x40px
- Gap: 16px

---

### 5. ProgressBar Widget
**Mô tả**: Thanh tiến trình với khả năng seek

**Properties**:
- `value`: double (current time in seconds)
- `max`: double (total duration in seconds)
- `onChanged`: Function(double)

**Behavior**:
- Drag để seek
- Tap để jump đến vị trí
- Hover: hiện thumb tròn ở vị trí hiện tại
- Default: chỉ có bar, không có thumb

**Appearance**:
- Height: 4px
- Background: màu secondary
- Progress: màu primary
- Thumb (hover): 12x12px, màu foreground
- Bo tròn 2 đầu

**Time Display**:
- Format: "2:34" / "5:42"
- Font size: 12px
- Color: muted text

---

### 6. VolumeControl Widget
**Layout**: `[VolumeIcon] [Slider]`

**Properties**:
- `value`: double (0-100)
- `onChanged`: Function(double)

**Behavior**:
- Click icon: toggle mute/unmute
- Icon thay đổi theo volume:
  - 0: volume_off
  - 1-50: volume_down
  - 51-100: volume_up
- Nhớ volume trước khi mute

**Dimensions**:
- Icon: 20x20px
- Slider width: 100px (desktop), ẩn trên mobile

---

### 7. NavItem Widget (Bottom Navigation)
**Properties**:
- `icon`: IconData
- `label`: String
- `isActive`: bool
- `badge`: int (optional, hiển thị số thông báo)

**States**:
- Active: màu primary, icon fill
- Inactive: màu muted

---

### 8. MediaImage Widget
**Properties**:
- `imageUrl`: String
- `size`: enum (xs: 32, sm: 40, md: 56, lg: 80, xl: 128, cover: full width)
- `shape`: enum (square, rounded, circle)
- `borderRadius`: double (default: 8px cho rounded)

**Features**:
- Loading shimmer effect
- Error fallback (icon nhạc)
- Cached network image

---

### 9. Text Components
**Variants**:
- **H1**: 28px, semi-bold
- **H2**: 24px, semi-bold
- **H3**: 20px, semi-bold
- **H4**: 18px, medium
- **Body**: 16px, regular
- **Caption**: 14px, regular
- **Label**: 12px, regular, uppercase

**Colors**:
- `default`: foreground color
- `muted`: muted text color
- `primary`: primary color
- `secondary`: secondary foreground

---

## 📄 Screens (Pages)

### 1. Home Screen
**Sections** (Vertical scroll):

#### Header
- Text "Good evening" (dynamic: morning/afternoon/evening)
- Theme switcher (4 color dots)
- Padding: 24px horizontal, 16px vertical

#### Recently Played
- Grid: 2 columns trên mobile, 3-6 columns trên tablet
- Spacing: 16px
- Title: "Recently Played"
- "Show all" button (optional)

#### Your Top Songs
- List view
- Header row: [#] [Title] [Album] [Duration] [Actions]
- 5-10 tracks
- Title: "Your Top Songs"

#### Made For You
- Grid: 2 columns
- Similar layout với Recently Played
- Title: "Made For You"
- Subtitle: "Daily Mix 1", "Daily Mix 2", etc.

#### Popular Artists
- Horizontal scroll hoặc Grid
- Circular images (artist variant)
- Title: "Popular Artists"

**Padding**: 16px horizontal cho toàn bộ content

---

### 2. Playback Bar (Bottom Sheet)
**Layout**:
```
┌─────────────────────────────────┐
│ [Thumbnail] [Title + Artist] [♥]│ <- Track info
├─────────────────────────────────┤
│       [Player Controls]         │ <- Controls
├─────────────────────────────────┤
│  [0:00] [Progress Bar] [5:42]   │ <- Progress
└─────────────────────────────────┘
```

**Properties**:
- Fixed height: 180px (mobile), auto (tablet)
- Background: card color
- Border top: 1px, border color
- Shadow: elevation 8

**Gesture**:
- Swipe up: expand to full screen (Now Playing screen)
- Swipe down: collapse (nếu đang expand)

---

### 3. Now Playing Screen (Full Screen)
**Layout**:
```
┌─────────────────────────────────┐
│  [Back] [Title] [More]          │ <- App bar
├─────────────────────────────────┤
│                                 │
│      [Large Album Art]          │ <- 80% screen width
│                                 │
├─────────────────────────────────┤
│  Song Title                     │
│  Artist Name              [♥]   │
├─────────────────────────────────┤
│  [0:00] [Progress] [5:42]       │
├─────────────────────────────────┤
│    [Player Controls]            │
├─────────────────────────────────┤
│  [Volume Control]               │
└─────────────────────────────────┘
```

**Features**:
- Gradient background (từ màu dominant của album art)
- Large album art với shadow lớn
- Lyrics button (optional)
- Queue button (optional)

---

### 4. Search Screen (Optional)
**Sections**:
- Search bar (top)
- Recent searches (chips)
- Browse categories (grid)
- Search results (tabs: All, Songs, Albums, Artists, Playlists)

---

### 5. Library Screen (Optional)
**Tabs**:
- Playlists
- Albums
- Artists
- Downloaded

**Layout**: Grid hoặc List view với toggle

---

## 🎭 Animations & Interactions

### 1. Transitions
- **Screen transitions**: Slide animation (300ms)
- **Theme change**: Fade (500ms) với easing curve
- **Card hover**: Scale (200ms), cubic-bezier

### 2. Gestures
- **Swipe right**: Next track (trong Now Playing)
- **Swipe left**: Previous track
- **Long press**: Show context menu
- **Pull to refresh**: Refresh playlists

### 3. Loading States
- **Shimmer effect** cho images
- **Skeleton screens** cho lists
- **Circular progress** cho loading data

---

## 📊 Mock Data Structure

### Track Model
```dart
class Track {
  final int id;
  final String title;
  final String artist;
  final String album;
  final String duration; // "4:23"
  final String imageUrl;
  final bool isLiked;
  final bool isDownloaded;
}
```

### Album Model
```dart
class Album {
  final int id;
  final String title;
  final String artist;
  final String imageUrl;
  final List<Track> tracks;
  final String releaseDate;
}
```

### Playlist Model
```dart
class Playlist {
  final int id;
  final String title;
  final String description;
  final String imageUrl;
  final List<Track> tracks;
  final int trackCount;
}
```

---

## 🎨 Design Tokens

### Spacing Scale
- xs: 4px
- sm: 8px
- md: 16px
- lg: 24px
- xl: 32px
- 2xl: 48px

### Border Radius
- sm: 4px
- md: 8px
- lg: 12px
- xl: 16px
- full: 9999px (pill)

### Shadow Levels
- sm: elevation 2
- md: elevation 4
- lg: elevation 8
- xl: elevation 16

### Typography Scale
```
H1: 28px / 1.4 line height
H2: 24px / 1.4
H3: 20px / 1.4
H4: 18px / 1.4
Body: 16px / 1.5
Caption: 14px / 1.4
Label: 12px / 1.4
```

---

## 📦 Required Flutter Packages

```yaml
dependencies:
  flutter:
    sdk: flutter
  
  # UI & Theming
  google_fonts: ^6.1.0
  
  # State Management (chọn 1)
  provider: ^6.1.1
  # hoặc riverpod: ^2.4.9
  # hoặc bloc: ^8.1.2
  
  # Images
  cached_network_image: ^3.3.0
  
  # Icons (nếu cần thêm)
  font_awesome_flutter: ^10.6.0
  
  # Audio (nếu cần phát nhạc thật)
  just_audio: ^0.9.36
  audio_service: ^0.18.12
  
  # Navigation
  go_router: ^13.0.0
  
  # Utilities
  intl: ^0.18.1 # Format time
```

---

## ✅ Implementation Checklist

### Phase 1: Core UI
- [ ] Setup theme system với 4 variants
- [ ] Tạo Design System (colors, typography, spacing)
- [ ] Build reusable components (Button, Card, Text)
- [ ] Implement MediaCard widget
- [ ] Implement TrackListItem widget

### Phase 2: Main Screen
- [ ] Home screen layout
- [ ] Recently Played grid
- [ ] Top Songs list
- [ ] Made For You section
- [ ] Popular Artists section
- [ ] Theme switcher component

### Phase 3: Playback
- [ ] Playback Bar (bottom sheet)
- [ ] PlayerControls widget
- [ ] ProgressBar widget
- [ ] VolumeControl widget
- [ ] Now Playing full screen

### Phase 4: Navigation
- [ ] Bottom Navigation Bar
- [ ] Screen routing
- [ ] Page transitions
- [ ] Gestures (swipe, long-press)

### Phase 5: Polish
- [ ] Animations & transitions
- [ ] Loading states
- [ ] Error handling
- [ ] Responsive layout (tablet support)
- [ ] Dark mode persistence

---

## 🎯 Key Requirements

1. **100% Responsive**: Hỗ trợ từ điện thoại nhỏ (320px) đến tablet (768px+)
2. **Performance**: 60fps animations, lazy loading images
3. **Accessibility**: VoiceOver/TalkBack support, minimum touch target 44x44px
4. **Theme Persistence**: Lưu theme đã chọn vào SharedPreferences
5. **Offline Support**: Cache images, hiển thị last known state
6. **Clean Code**: SOLID principles, separation of concerns

---

## 📸 Reference Images URLs

Sử dụng các URL này cho mock data:
- Electronic: https://images.unsplash.com/photo-1703115015343-81b498a8c080
- Vinyl: https://images.unsplash.com/photo-1740112252288-6c5c5a149766
- Festival: https://images.unsplash.com/photo-1672841821756-fc04525771c2
- Acoustic: https://images.unsplash.com/photo-1616620377931-9b22bc292ead
- Hip Hop: https://images.unsplash.com/photo-1548527388-e836c900b6c3
- Jazz: https://images.unsplash.com/photo-1725830071503-d705ef4a0975

---

## 🚀 Expected Deliverables

1. Flutter project với architecture rõ ràng
2. Reusable widget library
3. Theme system hoàn chỉnh
4. Responsive layouts
5. Smooth animations
6. Clean, documented code
7. README với screenshots

---

**Lưu ý**: Đây là specification cho giao diện UI/UX. Logic phát nhạc thực tế có thể implement sau sử dụng `just_audio` package.
