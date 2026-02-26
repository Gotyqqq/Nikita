# UI/UX Design Guidelines for Nikita App

## Design Philosophy
The Nikita app follows a clean, intuitive design similar to Telegram while incorporating modern UI patterns. The design focuses on usability, accessibility, and performance.

## Color Palette

### Primary Colors
- **Primary Blue**: #0088CC (used for accents, links, active states)
- **Secondary Blue**: #00AEEF (used for highlights)
- **Background Light**: #FFFFFF (default background)
- **Background Dark**: #1E1E1E (dark mode background)

### Status Colors
- **Success Green**: #00C853 (delivery/read status)
- **Warning Orange**: #FF8800 (pending status)
- **Error Red**: #FF5252 (error states)
- **Info Gray**: #9E9E9E (timestamps, muted text)

## Typography

### Font Family
- **Primary Font**: Inter (available in assets/fonts/)
- **Fallback**: System default font

### Text Styles
- **Headline**: 24sp, SemiBold (screen titles)
- **Title**: 20sp, Medium (section headers)
- **Subhead**: 16sp, Regular (list items)
- **Body**: 14sp, Regular (message text)
- **Caption**: 12sp, Regular (timestamps, metadata)
- **Overline**: 10sp, Medium (status indicators)

## Component Design

### Message Bubbles
- **Sent Messages**: Right-aligned, blue background (#0088CC), white text
- **Received Messages**: Left-aligned, gray background (#ECEFF1), black text
- **Reply Indicators**: Thin colored bar on left side of message bubble
- **Timestamps**: Subtle gray text (12sp) aligned bottom right of bubble
- **Status Icons**: Small icons at bottom right of sent messages
  - ✓ (single check): Sent
  - ✓✓ (double check): Delivered
  - ✓✓ (blue): Read

### Chat List Items
- **Avatar**: Circular, 50px diameter
- **Name**: Bold, 16sp
- **Last Message Preview**: Regular, 14sp, truncated
- **Timestamp**: Right-aligned, 12sp, gray
- **Unread Badge**: Circular, 20px, blue background with white text

### Input Fields
- **Text Input**: Rounded rectangle with padding (12dp vertical, 16dp horizontal)
- **Send Button**: Circular with paper plane icon
- **Attachment Button**: Paperclip icon
- **Voice Message Button**: Microphone icon

## Layout Patterns

### Chat Screen Layout
```
AppBar (Chat Title)
Message List (centered content area)
Input Area (bottom anchored)
```

### Message List
- Scrollable list with proper spacing (8dp between messages)
- Different alignment for sent/received messages
- Group messages by sender within 5-minute windows
- Show user avatars only for first message in a group

### Input Area
- Attachment button (left)
- Text input field (center)
- Send/Voice button (right)

## Navigation Patterns

### Bottom Navigation
- **Chats Tab**: List of conversations
- **Contacts Tab**: User contacts
- **Profile Tab**: User settings and profile

### Top-Level Navigation
- **Splash Screen**: Initial load
- **Auth Flow**: Login/Register
- **Main Tabs**: Chats, Contacts, Profile
- **Chat Screen**: Individual conversation
- **Group Creation**: Creating new groups

## Interaction Design

### Pull-to-Refresh
- Refresh chat list by pulling down
- Show refresh indicator

### Swipe Actions
- Swipe right on chat item: Mark as read
- Swipe left on chat item: Archive/delete

### Long Press
- On messages: Select message for actions (copy, forward, delete)
- On chat items: Select multiple chats

## Accessibility Features

### Text Scaling
- Support for system text scale factor
- Maintain readability at different sizes

### Contrast Ratios
- Minimum 4.5:1 contrast ratio for text
- Enhanced contrast mode available

### Touch Targets
- Minimum 48x48 dp touch targets
- Adequate spacing between interactive elements

## Platform-Specific Considerations

### Android
- Follow Material Design guidelines
- Adaptive icons support
- Proper integration with system notification settings

### iOS
- Follow Human Interface Guidelines
- Navigation patterns adapted for iOS
- Proper status bar handling

## Responsive Design

### Screen Sizes
- Support for phones, tablets, foldables
- Landscape mode optimizations
- Dynamic layout adjustments

### Orientation Changes
- Preserve scroll position during rotation
- Adjust input area for keyboard appearance

This design system ensures consistency across the application while providing a familiar and intuitive user experience similar to Telegram but with our own distinct identity.